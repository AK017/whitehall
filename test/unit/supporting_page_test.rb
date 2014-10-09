require "test_helper"

class SupportingPageTest < ActiveSupport::TestCase
  should_protect_against_xss_and_content_attacks_on :title, :body

  test "should be invalid without a title" do
    supporting_page = build(:supporting_page, title: nil)
    refute supporting_page.valid?
  end

  test "should be invalid without a body" do
    supporting_page = build(:supporting_page, body: nil)
    refute supporting_page.valid?
  end

  test "should be invalid without a policy" do
    supporting_page = build(:supporting_page)
    supporting_page.related_policy_ids = []
    refute supporting_page.valid?
  end

  test "should allow inline attachments" do
    assert build(:supporting_page).allows_inline_attachments?
  end

  test "should inherit organisations from its policies" do
    org1, org2, org3 = 3.times.map { create(:organisation) }
    policy1 = create(:policy, organisations: [org1, org2])
    policy2 = create(:policy, organisations: [org2, org3])
    supporting_page = create(:supporting_page, related_policies: [policy1, policy2])

    assert_equal [org1, org2, org3], supporting_page.organisations
  end

  test "should be findable via #in_organisation" do
    org = create(:organisation)
    policy = create(:policy, organisations: [org])
    page = create(:supporting_page, related_policies: [policy])

    assert_equal [page], SupportingPage.in_organisation(org).to_a
  end

  test "returns sorted organisations" do
    org_c = create(:organisation, name: "Organisation C")
    org_a = create(:organisation, name: "Organisation A")
    org_b = create(:organisation, name: "Organisation B")

    policy = create(:policy, organisations: [org_b, org_a, org_c])
    supporting_page = create(:supporting_page, related_policies: [policy])
    assert_equal [org_a, org_b, org_c], supporting_page.sorted_organisations
  end
end

module Document::Needs
  extend ActiveSupport::Concern

  attr_writer :need_ids

  def need_ids
    @need_ids ||= get_user_needs_from_publishing_api
  end

  def get_user_needs_from_publishing_api
    response = Services.publishing_api.get_links(
      content_id
    )

    return unless response

    response["links"]["meets_user_needs"]
  end

  def patch_meets_user_needs_links
    Services.publishing_api.patch_links(
      content_id,
        links: { meets_user_needs: need_ids.reject(&:empty?) }
    )
  end

  def associated_needs
    return [] unless need_ids.try(:any?)

    response = Services.publishing_api.get_expanded_links(
      content_id
    )

    response["expanded_links"]["meets_user_needs"]
  end
end

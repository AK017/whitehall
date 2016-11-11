class PublishStaticPages
  def publish
    index = Whitehall::SearchIndex.for(:government)
    pages.each do |page|
      index.add(present_for_rummager(page))

      payload = present_for_publishing_api(page)
      publishing_api.put_content(payload[:content_id], payload[:content])
      publishing_api.publish(payload[:content_id], "minor", locale: "en")
    end
  end

  def patch_links(content_id, links)
    publishing_api.patch_links(content_id, links)
  end

  def pages
    [
      {
        content_id: "f56cfe74-8e5c-432d-bfcf-fd2521c5919c",
        title: "How government works",
        description: "About the UK system of government. Understand who runs government, and how government is run.",
        indexable_content: TemplateContent.new("home/how_government_works").indexable_content,
        base_path: "/government/how-government-works",
      },
      {
        content_id: "dbe329f1-359c-43f7-8944-580d4742aa91",
        title: "Get involved",
        description: "Find out how you can engage with government directly, and take part locally, nationally or internationally.",
        indexable_content: TemplateContent.new("home/get_involved").indexable_content,
        base_path: "/government/get-involved",
      },
      {
        content_id: "db95a864-874f-4f50-a483-352a5bc7ba18",
        title: "History of the UK government",
        description: "In this section you can read short biographies of notable people and explore the history of government buildings. You can also search our online records and read articles and blog posts by historians.",
        indexable_content: TemplateContent.new("histories/index").indexable_content,
        base_path: "/government/history",
      },
      {
        content_id: "14aa298f-03a8-4e76-96de-483efa3d001f",
        title: "History of 10 Downing Street",
        description: "10 Downing Street, the locale of British prime ministers since 1735, vies with the White House as being the most important political building anywhere in the world in the modern era.",
        indexable_content: TemplateContent.new("histories/10_downing_street").indexable_content,
        base_path: "/government/history/10-downing-street",
      },
      {
        content_id: "7be62825-1538-4ff5-aa29-cd09350349f2",
        title: "History of 1 Horse Guards Road",
        indexable_content: TemplateContent.new("histories/1_horse_guards_road").indexable_content,
        base_path: "/government/history/1-horse-guards-road",
      },
      {
        content_id: "9bdb6017-48c9-4590-b795-3c19d5e59320",
        title: "History of 11 Downing Street",
        indexable_content: TemplateContent.new("histories/11_downing_street").indexable_content,
        base_path: "/government/history/11-downing-street",
      },
      {
        content_id: "bd216990-c550-4d28-ac05-649329298601",
        title: "History of King Charles Street (FCO)",
        indexable_content: TemplateContent.new("histories/king_charles_street").indexable_content,
        base_path: "/government/history/king-charles-street",
      },
      {
        content_id: "60808448-769d-4915-981c-f34eb5f1b7bc",
        title: "History of Lancaster House (FCO)",
        indexable_content: TemplateContent.new("histories/lancaster_house").indexable_content,
        base_path: "/government/history/lancaster-house",
      },
    ]
  end

  def present_for_rummager(page)
    {
      _id: page[:base_path],
      link: page[:base_path],
      format: "edition", # Used for the rummager document type
      title: page[:title],
      description: page[:description],
      indexable_content: page[:indexable_content],
    }
  end

  def present_for_publishing_api(page)
    {
      content_id: page[:content_id],
      content: {
        details: {},
        title: page[:title],
        description: page[:description],
        document_type: "placeholder",
        schema_name: "placeholder",
        locale: "en",
        base_path: page[:base_path],
        publishing_app: "whitehall",
        rendering_app: "whitehall",
        routes: [
          {
            path: page[:base_path],
            type: "exact",
          },
        ],
        public_updated_at: Time.zone.now.iso8601,
      }
    }
  end

private

  def publishing_api
    @publishing_api ||= Whitehall.publishing_api_v2_client
  end

  class TemplateContent
    include ActionView::Helpers::SanitizeHelper

    def initialize(template_path)
      @template_path = template_path
    end

    def indexable_content
      template = File.read("#{Rails.root}/app/views/#{@template_path}.html.erb")
      strip_tags(template)
    end
  end
end

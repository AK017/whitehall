module SyncChecker
  module Formats
    class FatalityNoticeCheck < EditionBase
      def root_path
        "/government/fatalities/"
      end

      def rendering_app
        Whitehall::RenderingApp::GOVERNMENT_FRONTEND
      end

      def checks_for_live(locale)
        super << Checks::LinksCheck.new(
          "field_of_operation",
          [edition_expected_in_live.operational_field.content_id]
        )
      end
    end
  end
end

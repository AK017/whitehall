module ServiceListeners
  class AttachmentDraftStatusUpdater
    attr_reader :attachment_data

    def initialize(attachment_data)
      @attachment_data = attachment_data
    end

    def update!
      return unless attachment_data.present?
      AssetManagerAttachmentDraftStatusUpdateWorker.perform_async(attachment_data.id)
    end
  end
end

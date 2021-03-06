require 'test_helper'

module ServiceListeners
  class AttachmentLinkHeaderUpdaterTest < ActiveSupport::TestCase
    extend Minitest::Spec::DSL

    let(:updater) { AttachmentLinkHeaderUpdater.new(attachment_data) }
    let(:attachment_data) { attachment.attachment_data }

    context 'when attachment has associated attachment data' do
      let(:sample_rtf) { File.open(fixture_path.join('sample.rtf')) }
      let(:attachment) { FactoryBot.create(:file_attachment, file: sample_rtf) }

      it 'calls the worker' do
        AssetManagerAttachmentLinkHeaderUpdateWorker.expects(:perform_async).with(attachment_data.id)

        updater.update!
      end
    end

    context 'when attachment has no associated attachment data' do
      let(:attachment) { FactoryBot.create(:html_attachment) }

      it 'does not call the worker' do
        AssetManagerAttachmentLinkHeaderUpdateWorker.expects(:perform_async).never

        updater.update!
      end
    end
  end
end

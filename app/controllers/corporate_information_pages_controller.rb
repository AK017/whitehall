class CorporateInformationPagesController < DocumentsController
  prepend_before_filter :find_organisation

  def show
    @corporate_information_page = @document

    if @organisation.is_a? WorldwideOrganisation
      render 'show_worldwide_organisation'
    else
      render :show
    end
  end

  def find_document_or_edition_for_public
    published_edition = @organisation.corporate_information_pages.published.for_slug(params[:id])
    published_edition if published_edition.present? && published_edition.available_in_locale?(I18n.locale)
  end

  def set_slimmer_headers_for_document
    set_slimmer_organisations_header([@organisation])
    set_slimmer_page_owner_header(@organisation)
  end

private

  def find_organisation
    @organisation =
      if params.has_key?(:organisation_id)
        Organisation.find(params[:organisation_id])
      elsif params.has_key?(:worldwide_organisation_id)
        WorldwideOrganisation.find(params[:worldwide_organisation_id])
      else
        raise ActiveRecord::RecordNotFound
      end
  end
end

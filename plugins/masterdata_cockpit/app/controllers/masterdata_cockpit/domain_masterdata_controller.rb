# frozen_string_literal: true

module MasterdataCockpit
  class DomainMasterdataController < DashboardController

    before_action :load_domain_masterdata, only: [:index, :edit]
    before_action :prepare_params, only: [:create, :update]

    authorization_context 'masterdata_cockpit'
    authorization_required
    
    def index
      if !@domain_masterdata && @masterdata_api_error_code == 404
        # no masterdata was found please define it
        @domain_masterdata = services_ng.masterdata_cockpit.new_domain_masterdata
        render action: :new
      end
    end

    def new
      @domain_masterdata = services_ng.masterdata_cockpit.new_domain_masterdata
    end

    def create
      unless @domain_masterdata.save
        render action: :new
      end
      
      # this is the case if no masterdata is created and we do not use the modal window
      unless params['modal']
        render action: :index
      end
    end

    def edit
    end

    def update
      unless @domain_masterdata.update
        render action: :edit
      end
    end

    private
    
    def load_domain_masterdata
      begin
        @domain_masterdata = services_ng.masterdata_cockpit.get_domain(@scoped_domain_id)
      rescue Exception => e
        # do nothing if no masterdata was found
        # the api will only return 404 if no masterdata for the domains was found
        @masterdata_api_error_code = e.code
        unless e.code == 404
          # all other errors
          flash.now[:error] = "Could not load masterdata. #{e.message}"
        end
      end
    end
    
    def prepare_params
      @domain_masterdata = services_ng.masterdata_cockpit.new_domain_masterdata
      # to merge options into .merge(domain_id: @scoped_domain_id)
      @domain_masterdata.attributes =params.fetch(:domain_masterdata,{})
    end

  end
end
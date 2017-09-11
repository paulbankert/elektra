# frozen_string_literal: true

module MasterdataCockpit
  class ProjectMasterdataController < DashboardController

    before_action :load_project_masterdata, only: [:index, :edit, :show]
    before_action :prepare_params, only: [:create, :update]
    before_action :solutions, only: [:new, :edit]

    authorization_context 'masterdata_cockpit'
    authorization_required

    def index
    end
    
    def new
      @project_masterdata = services_ng.masterdata_cockpit.new_project_masterdata
    end

    def edit
    end

    def update
      unless @project_masterdata.update
        render action: :edit
      end
    end

    def create
      unless @project_masterdata.save
        render action: :new
      end
    end

    def show;
    end

    private
    
    def load_project_masterdata
      begin
        @project_masterdata = services_ng.masterdata_cockpit.get_project(@scoped_project_id)
      rescue Exception => e
        # do nothing if no masterdata was found
        # the api will only return 404 if no masterdata for the project was found
        unless e.code == 404
          # all other errors
          flash.now[:error] = "Could not load masterdata. #{e}"
        end
      end
    end
    
    def prepare_params
      @project_masterdata = services_ng.masterdata_cockpit.new_project_masterdata
      # to merge options into .merge(project_id: @scoped_project_id)
      @project_masterdata.attributes =params.fetch(:project_masterdata,{})
    end
    
    def solutions
      begin
        @solutions = services_ng.masterdata_cockpit.get_solutions
      rescue
        flash.now[:error] = "Could not load solutions."
      end
    end
    
  end
end
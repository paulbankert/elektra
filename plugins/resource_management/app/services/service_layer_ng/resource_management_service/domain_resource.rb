module ServiceLayerNg
  # This module implements Openstack Group API
  module ResourceManagementService::DomainResource

    def find_domain(domain_id, query={})
      Rails.logger.debug  "[resource management-service][DomainResource] -> find_domain -> GET /v1/domains/#{domain_id}"
      Rails.logger.debug  "[resource management-service][DomainResource] -> find_domain -> Query: #{query}"
      api.resources.get_domain(domain_id,query).map_to(ResourceManagement::Domain)
    end

    def list_domains(query={})
      Rails.logger.debug  "[resource management-service][DomainResource] -> list_domains -> GET /v1/domains/#{query}"
      Rails.logger.debug  "[resource management-service][DomainResource] -> list_domains -> Query: #{query}"
      api.resources.get_domains(query).map_to(ResourceManagement::Domain)
    end

    def put_domain_data(domain_id, services)
      Rails.logger.debug  "[resource management-service][DomainResource] -> put_domain_data -> PUT /v1/domains/#{domain_id}"
      api_client.resources.set_quota_for_domain(domain_id, :domain => {:services => services})
    end

    def discover_projects(domain_id)
      Rails.logger.debug  "[resource management-service][DomainResource] -> discover_projects -> POST /v1/domains/#{domain_id}/projects/discover"
      api_client.resources.discover_projects(domain_id)
    end

  end
end
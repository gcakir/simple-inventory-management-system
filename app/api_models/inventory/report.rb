require_relative './abstract_inventory_api_model.rb'

###
# Produces a report of all the inventory for a given distribution center.
class Report < AbstractInventoryApiModel
    
    # The id of the distribution center for which to product the report.
    attr_accessor :distribution_center_id
    
    # Validation
    validates :distribution_center_id, :presence => true,
                                       :numericality => { only_integer: true, greater_than: 0 }
    
    # Constructor.
    def initialize(distribution_center_id)
        @distribution_center_id = distribution_center_id.to_i
    end
    
    # Query the database for the report information.
    def query()
        select_columns = [
            'inventories.*',
            'distribution_centers.name as distribution_center_name',
            'distribution_centers.location as distribution_center_location',
            'products.name as product_name',
            'products.description as product_description'
        ]
        select_string = select_columns.join(',')
        results = Inventory.select(select_string).
            joins('INNER JOIN distribution_centers on inventories.distribution_center_id = distribution_centers.id').
            joins('INNER JOIN products on inventories.product_id = products.id').
            where(distribution_center_id: @distribution_center_id)
        return results
    end
end

module ApiModel
module Inventory
class RemoveReserved < AbstractInventoryAmountAdjuster
    
    def update_db()
        super

        begin 
            Inventory.update_counters @inventory_item.id, :reserved_amount => -(@amount.abs)
			@update_db_success_msg = "#{@amount} successfully removed from reserved amount for inventory item #{@inventory_item.id}."
			return true
        rescue ActiveRecord::StatementInvalid => ex
            if ex.to_s.include? "reserved_amount_cannot_go_below_zero"
                @update_db_error_msg = "Reserved inventory amount cannot go below 0. Current amount: #{@inventory_item.reserved_amount}. Amount attempting to remove: #{amount}."
            else
                @update_db_error_msg = "Unknown database error."
            end
            return false
        end
    end
end
end
end

({
    validateItemForm : function(component) {
        var validItem = true;

        var nameField = component.find("itemname");
        var itemname = nameField.get("v.value");

        if($A.util.isEmpty(itemname)) {
            validItem = false;
            nameField.set("v.errors", [{message : "Item name can't be blank."}]);
        } else {
            nameField.set("v.errors", null);
        }

        var quantityField = component.find("quantity");
        var quantity = quantityField.get("v.value");

        if ($A.util.isEmpty(quatity)) {
            validItem = false;
            quantityField.set("v.errors", [{mmessage : "Quantity can't be blank."}]);
        } else {
            quantityField.set("v.errors", null);
        }

        var priceField = component.find("price");
        var price = priceField.get("v.value");

        if ($A.util.isEmpty(quatity)) {
            validItem = false;
            priceField.set("v.errors", [{mmessage : "Price can't be blank."}]);
        } else {
            priceField.set("v.errors", null);
        }

        return validItem;
    }
    , createItem : function (component, newItem) {
        var createItem = component.getEvent("addItem");
        
        createItem.setParams({"item" : newItem});
        createItem.fire();

        // 후처리
        component.set("v.newItem", {'sObjectType' : 'Camping_Item__c'
                                    , 'Name': ''
                                    , 'Quantity__c' : 0
                                    , 'Price__c' : 0
                                    , 'Packed__c' : false
        });
    }
})

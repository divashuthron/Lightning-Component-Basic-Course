({
    doInit : function (component, event, helper) {
        var action = component.get("c.getItems");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(action);
    }

    /*
    , clickCreateItem : function(component, event, helper) {
        var validItem = component.find('newcampingform').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        if (validItem == true) {
            var newCampItem = component.get("v.newItem");
            
            // Debug Trigger
            console.log("Create Item: " + JSON.stringify(newCampItem));

            helper.createItem(component, newCampItem);

            // 개체 초기화
            component.set("v.newItem", {
                  'sObjectType' : 'Camping_Item__c'
                , 'Name' : ''
                , 'Quantity__c' : 0
                , 'Price__c' : 0
                , 'Packed__c' : false
            });
        }
    }
    */

    , handleAddItem : function (component, event, helper) {
        var newItem = event.getParam("item");
        helper.createItem(component, newItem);

        /*
        var action = component.get("c.saveItem");
        action.setParams({"item" : item});

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                var items = component.get("v.items");
                items.push(item);
                component.set("v.items", items);
            }
        });

        $A.enqueueAction(action);
        */
       
        /*
        this.saveItem(component, item, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                var items=component.get("v.items");

                items.push(response.getReturnValue());
                component.set("v.items", items);
            }
        });
        */
    }
})

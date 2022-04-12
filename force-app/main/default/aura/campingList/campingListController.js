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
})

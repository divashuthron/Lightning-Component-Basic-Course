({
    clickCreateItem : function (component, event, helper) {
        if(helper.validateItemForm(component)) {
            try {
                var newItem = component.get("!v.newItem");

                helper.createItem(component, newItem);
            } catch (error) {
                console.log(error);
            }
        }
    }
})

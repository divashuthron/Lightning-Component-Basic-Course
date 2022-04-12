({
    createItem : function(component, Item) {
        var action = component.get("c.saveItem");
        action.setParams({"campingItem" : Item});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                // 캠핑 개체 배열 가져와서 결과 값을 push 후 새로운 배열로 입력
                var campings = component.get("v.items");
                campings.push(response.getReturnValue());
                component.set("v.items", campings);
            }
        });

        $A.enqueueAction(action);
    }
})

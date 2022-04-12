public with sharing class CntrlMemberEdit {
    public String retUrl { get; set; }          // 이전 화면 URL
    public String saveUrl { get; set; }         // 저장 후 되돌아갈 화면 URL

    public Member__c member { get; set; }               // 회원 변수
    public List<Book__c> borrowBookList { get; set; }   // 대여 중인 도서 목록

    public List<SelectOption> isLentalSelItems { get; set; }    // 대여 유무 Select Option

    public CntrlMemberEdit() {
        member = getMember();

        if (member == null) {
            member = new Member__c();
        }

        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);
        saveUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_SAVE_URL);

        isLentalSelItems = getIsLentalItems();

        borrowBookList = getBorrowBookList();
    }

    public PageReference save() {
        if (checkInput()) {
            return null;
        }

        Savepoint sp = Database.setSavepoint();

        try {
            DaoMember.upsertData(new List<Member__c>{ member });
        } catch (Exception e) {
            System.debug('[CntrlMemberEdit_save] ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '저장에 실패했습니다. 이유 : ' + e.getMessage()));
            Database.rollback(sp);
            return null;
        }

        PageReference nextPage;

        if (String.isNotBlank(saveUrl)) {
            nextPage = new PageReference(saveUrl);
        } else if (String.isNotBlank(retUrl)) {
            nextPage = new PageReference(retUrl);
        } else {
            nextPage = Page.Menu;
        }

        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);

        return nextPage;
    }

    public PageReference cancel() {
        PageReference nextPage = new PageReference(retUrl);
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);

        return nextPage;
    }

    private Boolean checkInput() {
        Boolean result = false;

        if (String.isBlank(member.MemberNo__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[회원 번호]를 입력해주세요.'));
            result = true;
        }
        
        if (String.isBlank(member.Name)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[회원명]을 입력해주세요.'));
            result = true;
        }

        if (member.IsLental__c != null) {
            if (member.IsLental__c == false && !borrowBookList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여 중인 도서가 존재하기 때문에 "미대여"선택이 불가능합니다.'));
                result = true;
            } else if (member.IsLental__c == true && borrowBookList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여 중인 도서가 없기 때문에 "대여중"선택이 불가능합니다.'));
                result = true;
            }
        }

        return result;
    }

    private Member__c getMember() {
        ID memId = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_MEMBER_ID);

        List<Member__c> memberList = DaoMember.findById(new Set<ID>{ memId });

        if (memberList == null || memberList.isEmpty()) {
            return null;
        }

        return memberList.get(0);
    }

    private List<Book__c> getBorrowBookList() {
        List<Book__c> bookList = new List<Book__c>();

        if (String.isBlank(member.Id)) {
            return bookList;
        }

        bookList = DaoBook.findByMemberId(new Set<ID>{ member.Id });

        return bookList;
    }

    private List<SelectOption> getIsLentalItems() {
        List<SelectOption> isLentalSelList = new List<SelectOption>();

        isLentalSelList.add(new SelectOption('', ''));
        isLentalSelList.add(new SelectOption('false', '미대여'));
        isLentalSelList.add(new SelectOption('true', '대여중'));

        return isLentalSelList;
    }
}

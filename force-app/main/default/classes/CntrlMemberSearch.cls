public with sharing class CntrlMemberSearch {
    public String retUrl { get; set; }          // 이전 화면 URL
    public String currentUrl { get; set; }      // 현재 화면 URL
    public String saveUrl { get; set; }         // 저장 후 돌아올 URL
    public String blankMsg { get; set; }        // 검색 결과가 없을 때 표시할 메세지

    public List<Member__c> srchRsltList { get; set; }   // 회원 검색 결과
    public Member__c srchCndtnMemberObj { get; set; }   // 검색 조건 설정용 회원 변수
    public String srchCndtnIsLental { get; set; }       // 검색 조건 설정용 회원 변수 (대여 여부)

    public List<SelectOption> isLentalSelItems { get; set; }    // 대여 유무 Select Option
    public List<SelectOption> isReturnSelItems { get; set; }    // 반납 여부 Select Option

    public CntrlMemberSearch() {
        // URL파라미터로부터 이전 화면 URL 가져오기 (Menu 페이지)
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);
        // 현재 화면의 URL 가져오기 (MemberSearch 페이지)
        currentUrl = UtilUrl.removeUrlParameter(System.currentPageReference().getUrl());
        // 저장 후 돌아올 URL 설정 (MemberSearch 페이지)
        saveUrl = currentUrl;

        // 첫 화면 출력 시 전체 회원 리스트 출력
        // srchRsltList = new List<Member__c>();
        srchRsltList = DaoMember.findBySearchCondition(srchCndtnMemberObj, srchCndtnIsLental);
        
        // Select Option 만들기
        isLentalSelItems = getIsLentalItems();
        isReturnSelItems = getIsReturnItems();

        // 검색 조건 초기화
        srchCndtnMemberObj = new Member__c();
    }

    // 검색 버튼 처리 메서드
    public void search() {
        srchRsltList = DaoMember.findBySearchCondition(srchCndtnMemberObj, srchCndtnIsLental);
    }

    // 회원 추가 버튼 처리 메서드
    public PageReference newMember() {
        PageReference nextPage = Page.MemberEdit;

        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_RET_URL, currentUrl);
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_SAVE_URL, currentUrl);

        return nextPage;
    }
    
    // 돌아가기 버튼 처리 메서드
    public PageReference returnPage() {
        return Page.Menu;
    }

    /**
     * 하단의 소스코드에 대해
     * Select Option에 대해, 수동으로 생성이 아닌 자동으로 생성하는 코드 적용 필요
     * 추후 유지보수에 어려움이 생긴다
     */

    // Select Option 설정 (대여 유무)
    private List<SelectOption> getIsLentalItems() {
        List<SelectOption> isLentalSelList = new List<SelectOption>();

        isLentalSelList.add(new SelectOption('', ''));
        isLentalSelList.add(new SelectOption('false', '미대여'));
        isLentalSelList.add(new SelectOption('true', '대여중'));

        return isLentalSelList;
    }

    // Select Option 설정 (반납 여부)
    private List<SelectOption> getIsReturnItems() {
        List<SelectOption> isReturnSelList = new List<SelectOption>();

        isReturnSelList.add(new SelectOption('', ''));
        isReturnSelList.add(new SelectOption('미대여', '미대여'));
        isReturnSelList.add(new SelectOption('미반납', '미반납'));
        isReturnSelList.add(new SelectOption('반납', '반납'));
        isReturnSelList.add(new SelectOption('연체', '연체'));

        return isReturnSelList;
    }
}

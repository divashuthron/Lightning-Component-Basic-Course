/**
 * @description 메뉴 화면 컨트롤러
 */
public with sharing class CntrlMenu {

    /**
     * @description 현재 화면의 URL
     */
    public String currentUrl {get;set;}

    /**
     * @description 생성자
     */
    public CntrlMenu() {

        // 현재 화면의 URL 얻기 (Search 페이지에서 사용 할 돌아가기 기능을 위해 사용)
        currentUrl = removeUrlParameter(System.currentPageReference().getUrl());
    }

    /**
     * @description URL에서 파라미터를 빼내는 메서드
     * @param url URL
     * @return 가공 후의 URL
     * 
     * 파라미터가 담겨있는 URL의 경우, 이동 시 예상한 결과와 다른 페이지가 출력 될 수 있으므로
     * 돌아가기, 취소, 저장 후 이동, 등의 기능에 원본 URL만을 파라미터로 넘기기 위해 사용
     */
    public String removeUrlParameter(String url) {

        if (url == null) {

            return null;
        }

        return url.substringBefore('?');
    }
}
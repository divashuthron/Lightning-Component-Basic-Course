public with sharing class UtilUrl {
    public static String removeUrlParameter(String url) {
        if (url == null) {
            return null;
        }

        return url.substringBefore('?');
    }
}

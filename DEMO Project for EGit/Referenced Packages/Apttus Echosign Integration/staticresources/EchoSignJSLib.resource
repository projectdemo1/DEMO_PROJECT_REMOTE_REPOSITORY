/**
	Apttus Echosign Adapter
	EchosignJSLib.js

	@2010 Apttus Inc. All rights reserved.
 */

// errors
var cERROR_UPDATE_AGREEMENT = "ERROR: updating the agreement:\n";
var cERROR_BUILD_PAGE = "Error building the page:\n";
var cERROR_UNKNOWN = "ERROR: Unknown error:\n";

// wait message
var cPLEASE_WAIT = "Please wait...";


/**
 * Builds the page using the given parameters
 * @param sObjectId the sobjectid associated with the page
 * @param paramNames the list of query string parameter names 
 * @param paramValues the list of query string parameter values 
 * @return the page url
 */
function buildEchosignPageURL(sObjectId, paramNames, paramValues) {

	// build the page url 
	var result = sforce.apex.execute('Apttus_Echosign.EchoSignWebService',
									'buildPageURL',
									{sObjectId:sObjectId,
									paramNames:paramNames,
									paramValues:paramValues});

	if (result == null || result == '') {
		throw(cERROR_BUILD_PAGE);
	}

	return decodeURIComponent(result);
}

function showMsgProgress(msg) {
    var html = "<center><p><p><h2>" + msg + "</h2>" +
        "<p><img src=\"/img/waiting_dots.gif\" border=\"0\" width=156 height=25></center>";
    
    setMain(html);
    showMain();
}

function hideMsgProgress() {
	resetMain();
    hideMain();
}

function resetMain() {
    setMain("");
}

function setMain(html) {
    document.getElementById("divMain").innerHTML = html;
}

function showMain() {
    document.getElementById("divMain").style.visibility = "visible";
}

function hideMain() {
    document.getElementById("divMain").style.visibility = "hidden";
}

function erroralert(msg,exception) {
    
	try {
        var emsg = null;
        var efld = null;
        var estc = null;
        var etid = null;

        try {
            var hasErrors = (exception.errors!=null);
            var hasFault = (exception.faultcode!=null);
            //alert("hasErrors="+hasErrors+"\nhasFault="+hasFault);

            if (hasErrors) {
                emsg = exception.errors.message;
                efld = exception.errors.fields;
                estc = exception.errors.statusCode;

            } else if (hasFault) {
                emsg = exception.faultcode;
                efld = exception.faultstring;
                
            } else {
                emsg = exception.message;
                efld = exception.fields;
                estc = exception.statusCode;
            }
            
        } catch(ex) {
            emsg = exception.errors.message;
            efld = exception.errors.fields;
            estc = exception.errors.statusCode;
        }

        var estr = msg;
        var estrdb = estr;
        
        if (emsg!=null && emsg!="") {
            estr += "\nmessage: "+emsg;
            estrdb += "<br>message: "+emsg;
        }
        if (efld!=null && efld!="") {
            estr += "\nfields: "+efld;
            estrdb += "<br>fields: "+efld;
        }
        if (estc!=null && estc!="") {
            estr += "\nstatusCode: "+estc;
            estrdb += "<br>statusCode: "+estc;
        }
        if (etid!=null && etid!="") {
            estr += "\ntargetObjectId: "+etid;
            estrdb += "<br>targetObjectId: "+etid;
        }
        
        alert(estr);
        
    } catch(ex) {
        alert(msg+"\n"+exception);
    }
}

/**
 * Navigates to the given url
 * @param url the url to navigate to 
 */
function navigateTo(url) {
    top.location.replace(url);
}

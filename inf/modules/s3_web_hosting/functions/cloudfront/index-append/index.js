// This is a cloudfront function that adds index.html to
// URIs that end in a slash. It is used to make the python package
// indices PEP-503 compliant - that pep specifies that package
// indices should support requests to paths by returning their index
// files, and package clients like pip should feel free to do it - and
// they do.
function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Check whether the URI is missing a file name. this is the common
    // case for indexer requests.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension. this would
    // happen more often from testing in a browser.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}

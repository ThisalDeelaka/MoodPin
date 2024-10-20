import ballerina/http;
import ballerina/log;

listener http:Listener moodPinListener = new(8080);

// Define a record to match the expected JSON structure
type MoodEntry record {| 
    string mood; 
    string note; 
|};

// In-memory store for mood entries
record {| 
    string id; 
    string mood; 
    string note; 
|}[] moodEntries = [];

// Function to set CORS headers
function setCORSHeaders(http:Response res) {
    res.setHeader("Access-Control-Allow-Origin", "http://localhost:5173");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");
    res.setHeader("Access-Control-Allow-Credentials", "true");
}

// Function to handle CORS preflight requests
function handlePreflight(http:Caller caller) returns error? {
    http:Response response = new;
    setCORSHeaders(response);
    check caller->respond(response);
}

service /moodpin on moodPinListener {

    // Preflight request handler for CORS (OPTIONS method)
    resource function options .(http:Caller caller, http:Request req) returns error? {
        log:printInfo("Received preflight OPTIONS request");
        handlePreflight(caller);
    }

    // Endpoint to add a mood entry
    resource function post add(http:Caller caller, http:Request req) returns error? {
        json requestBody = check req.getJsonPayload();

        // Convert the JSON payload to the MoodEntry type
        MoodEntry moodEntry = check requestBody.cloneWithType(MoodEntry);

        string id = "mood-" + (moodEntries.length() + 1).toString();

        // Store the new mood entry
        moodEntries.push({id: id, mood: moodEntry.mood, note: moodEntry.note});
        log:printInfo("Mood added: " + moodEntry.mood);

        // Prepare the response
        http:Response response = new;
        response.setPayload({message: "Mood saved!", id: id});
        setCORSHeaders(response); // Set CORS headers

        check caller->respond(response);
    }

    // Endpoint to get all mood entries
    resource function get entries(http:Caller caller, http:Request req) returns error? {
        // Prepare the response
        http:Response response = new;
        response.setPayload(moodEntries);
        setCORSHeaders(response); // Set CORS headers

        check caller->respond(response);
    }
}

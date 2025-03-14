import ballerina/http;
import ballerina/log;
import ballerina/time;

service /webhook on new http:Listener(8080) {
    isolated resource function post .(Update update) returns error? {
        string|error? query = constructQuery(update);
        if query is error {
            log:printError("Unable to construct query: ", query);
        }
        Message? message = update?.message;
        if query !is string || message is () {
            return;
        }
        log:printInfo(string `Constructed query ${query}`);
        string answer = check expenseClaimAgent->run(query, message.'from.id.toString());
        json reply = {chat_id: message.chat.id.toString(), text: answer};
        http:Response _ = check telegramClient->/sendMessage.post(reply);
    }
}

service / on new http:Listener(9090) {
    resource function post claims(ExpenseClaimRequest payload) returns ExpenseClaimResponse {
        return {submittedDate: time:utcToEmailString(time:utcNow())};
    }
}

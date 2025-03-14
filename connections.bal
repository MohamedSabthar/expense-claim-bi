import ballerina/http;
import ballerinax/azure.openai.chat;
import ballerinax/googleapis.drive;

final http:Client telegramClient = check new (botChatUrl);
final http:Client telegramFileClient = check new (botFileUrl);
final http:Client expenseClient = check new ("localhost:9090");
final chat:Client azureChatClient = check new (config = {auth: {apiKey: apiKey}}, serviceUrl = serviceUrl);
final drive:Client driveClient = check new (driveConfig = {
    auth: {clientId, clientSecret, refreshUrl, refreshToken}
});

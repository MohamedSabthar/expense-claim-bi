import ballerina/uuid;
import ballerinax/googleapis.drive;

isolated function constructQuery(Update update) returns string|error? {
    Message? message = update?.message;
    if message is () {
        return;
    }
    string? text = message?.text;
    PhotoSize[]? photo = message?.photo;
    if photo is PhotoSize[] {
        // Retrieve the highest quality image
        string fileId = photo[photo.length() - 1].file_id;
        string publicImageUrl = check generatePublicImageUrl(fileId);
        return string `This is the recipt image url '${publicImageUrl}'`;
    }
    if text is string {
        return text;
    }
    return;
}

isolated function generatePublicImageUrl(string fileId) returns string|error {
    File file = check telegramClient->/getFile.get(file_id = fileId);
    string filePath = file.result.file_path;
    byte[] image = check telegramFileClient->/[filePath].get();
    string extention = re `\.`.split(filePath)[1];
    return uploadReciptToDrive(image, extention);
}

isolated function uploadReciptToDrive(byte[] image, string fileExtention) returns string|error {
    string fileName = string `${uuid:createRandomUuid()}.${fileExtention}`;
    drive:File file = check driveClient->uploadFileUsingByteArray(image, fileName, parentFolderId = reciptFolderId);
    file = check driveClient->getFile(check file.id.ensureType(), "webContentLink");
    return file.webContentLink.ensureType();
}

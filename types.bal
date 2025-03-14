public type Update record {
    int update_id;
    Message message?;
};

public type Chat record {
    int id;
    string first_name;
    string username?;
    string 'type;
};

public type Message record {
    int message_id;
    User 'from;
    string text?;
    PhotoSize[] photo?;
    Chat chat;
};

public type User record {
    int id;
    string first_name;
};

public type PhotoSize record {
    string file_id;
};

public type File record {
    Result result;
};

public type Result record {
    string file_path;
};

public type ExpenseClaimRequest record {|
    string employeeEmail;
    string billDate;
    string currency;
    decimal amount;
    string jobNumber;
    string expenseType;
    string remarks;
    string receiptUrl;
|};

public type ExpenseClaimResponse record {|
    string status = "pending";
    string submittedDate;
|};

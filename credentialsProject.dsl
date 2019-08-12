

// user 'TestUser', {
//     password = 'qweqweqwe'
// }

project 'Shared Credentials', {
    credential 'TestCred', {
        userName = 'test'
        password = 'test'
    }

    procedure 'Test', {
        step 'Test', {
            subproject = '/plugins/SharedCredentials/project'
            subprocedure = 'Sample Procedure'

            actualParameter 'config', 'config'
            actualParameter 'applicationPath', 'config'
        }

        formalParameter 'test1', {
            type = 'no_such_type'
        }
    }

    // try {
    //     createAclEntry principalType: 'user',
    //     principalName: 'TestUser',
    //     credentialName: 'TestCred',
    //     readPrivilege: 'allow',
    //     projectName: 'Shared Credentials'
    // } catch (Throwable e) {

    // }
}

const amplifyconfig = {
  "dev": ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
      "plugins": {
          "awsCognitoAuthPlugin": {
              "IdentityManager": {
                  "Default": {}
              },
              "CredentialsProvider": {
                  "CognitoIdentity": {
                      "Default": {
                          "PoolId": "us-east-2:f2218648-0ce4-4fe2-bf9b-c7195260ce11",
                          "Region": "us-east-2"
                      }
                  }
              },
              "CognitoUserPool": {
                  "Default": {
                      "PoolId": "us-east-2_bobKLgwmG",
                      "AppClientId": "1m97ve39dpsnbbqk0ne7cfemot",
                      "Region": "us-east-2"
                  }
              },
              "Auth": {
                  "Default": {
                      "authenticationFlowType": "USER_SRP_AUTH"
                  }
              }
          }
      }
  },

}''',
  "prod": ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
      "plugins": {
          "awsCognitoAuthPlugin": {
              "IdentityManager": {
                  "Default": {}
              },
              "CredentialsProvider": {
                  "CognitoIdentity": {
                      "Default": {
                          "PoolId": "us-east-2:f2218648-0ce4-4fe2-bf9b-c7195260ce11",
                          "Region": "us-east-2"
                      }
                  }
              },
              "CognitoUserPool": {
                  "Default": {
                      "PoolId": "us-east-2_bobKLgwmG",
                      "AppClientId": "1m97ve39dpsnbbqk0ne7cfemot",
                      "Region": "us-east-2"
                  }
              },
              "Auth": {
                  "Default": {
                      "authenticationFlowType": "USER_SRP_AUTH"
                  }
              }
          }
      }
  },

}''',
};

  // "storage": {
  //   "plugins": {
  //     "awsS3StoragePlugin": {
  //       "bucket": "resiilio-dev",
  //       "region": "us-east-2",
  //       "identityPoolId":"us-east-2:f2218648-0ce4-4fe2-bf9b-c7195260ce11"
  //     }
  //   }
  // }
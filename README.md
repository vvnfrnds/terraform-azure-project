## Commands used

- Log in to Azure
```
- az login
```

- Create Service Principal 
```
az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
```
Note: Use the values generated here to export the variables in the next step

- Set env vars so that the service principal is used for authentication

```
export TF_VAR_subscription_id="YOUR_SUBSCRIPTION_ID"
export TF_VAR_client_id="YOUR_CLIENT_ID"
export TF_VAR_client_secret="YOUR_CLIENT_SECRET"
export TF_VAR_tenant_id="YOUR_TENANT_ID"
```

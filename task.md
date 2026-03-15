lets add one domain 

api service - image tag ghcr.io/ondc-official/ondc-onix-dev-ondcfis12-2.3.0:dev-13d15

NODE_ENV=production
SIGN_PRIVATE_KEY=TNQyLktBlHNYIecRgfgNaR+F2JgdAP1xTDng2vuOWL0YMB5ZoixsNDtExgDkBHOkoizQ5WN9qzs9NQaa1Vr6yg==
PORT=7039
SIGN_PUBLIC_KEY=GDAeWaIsbDQ7RMYA5ARzpKIs0OVjfas7PTUGmtVa+so=
SUBSCRIBER_ID=dev-workbench.ondc.tech
UKID=27baa06d-d91a-486c-85e5-cc621b787f04
ONDC_ENV=
REDIS_USERNAME=automation_ondc
REDIS_HOST=172.17.0.1
REDIS_PASSWORD=automation_password_ondc
REDIS_PORT=6379
WORKBENCH_SUBSCRIBER_ID=mock.workbench.ondc
IN_HOUSE_REGISTRY=https://dev-workbench.ondc.tech/registry/v2.0/
MOCK_SERVER_URL=https://dev-workbench.ondc.tech/mock
DATA_BASE_URL=https://dev-workbench.ondc.tech/db-service
API_SERVICE_URL=https://dev-workbench.ondc.tech/api-service
CONFIG_SERVICE_URL=https://dev-workbench.ondc.tech/config-service
CONTAINER_NAME=dev-ondcfis12-2.3.0
DOMAIN=ONDC:FIS12
VERSION=2.3.0
SERVICE_NAME=automation-api-service-dev-ondcfis12-2.3.0
TRACE_URL=http://172.17.0.1:4318/v1/traces
API_SERVICE_KEY=D33A76D111B4BDFCB96A2AC34B85E
LOKI_HOST=http://13.233.69.163:3002
HOSTED_ENV=DEV
NO_URL=https://analytics-api-staging.aws.ondc.org/
NO_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkYXRhb3JjQHNlbGxlciIsImV4cCI6MTgyMjkwMDAwMCwiZnJlc2giOmZhbHNlLCJpYXQiOjE2NTkxNTE5NTYsImp0aSI6Ijc3ZGRjMTdmNTkwMDQ0YWFhY2UzYTZiNjFmN2U1ZmI0IiwibmJmIjoxNjU5MTUxOTU2LCJ0eXBlIjoiYWNjZXNzIiwiZW1haWwiOiJ0ZWNoQG9uZGMub3JnIiwicHVycG9zZSI6ImRhdGFzaGFyaW5nIiwicGhvbmVfbnVtYmVyIjpudWxsLCJyb2xlcyI6WyJhZG1pbmlzdHJhdG9yIl0sImZpcnN0X25hbWUiOiJuZXR3b3JrIiwibGFzdF9uYW1lIjoib2JzZXJ2YWJpbGl0eSJ9.FXcJY78_swFd0VWPs-A7SfuLPaTuqGO3rhUv8ooNaV0




this is playground env (ignore docker default keys)
image - ghcr.io/ondc-official/automation-mock-playground-service:latest
   "API_SERVICE_URL=https://dev-workbench.ondc.tech/api-service",
                "REDIS_PORT=6379",
                "LOKI_HOST=http://13.233.69.163:3002",
                "BASE_URL=https://dev-workbench.ondc.tech/mock/playground",
                "SERVICE_NAME=ondc-playground-mock",
                "PORT=3000",
                "LOG_LEVEL=debug",
                "CONFIG_SERVICE_URL=https://dev-workbench.ondc.tech/config-service",
                "REDIS_HOST=13.233.69.163",
                "REDIS_USERNAME=automation_ondc",
                "REDIS_PASSWORD=automation_password_ondc",
                "REDIS_DB_0=",
                "REDIS_DB_1=",
                "NODE_ENV=production",
                "RABBITMQ_URL=",
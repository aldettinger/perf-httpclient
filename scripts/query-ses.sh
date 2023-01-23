#!/bin/sh

if [ -z "$SES_URI" ]
then
      SES_URI=http://localhost:8080
fi

#http :8080/ses/v1/applications/123 messageid:1234 password:secret partnerid:1.2.3.4 userid:dsh roleid:CONSUMER_DE

#http -v GET vlab-dsh-th:8180/hix-dsh-externalharness/ses/v1/applications messageid:h106_200E_Application
#http -v GET :8080/ses/v1/applications messageid:h106_200E_Application

#cat h105_200_CreateApplication.json | http -v POST vlab-dsh-th:8180/hix-dsh-externalharness/ses/v1/createApplicationFromPriorYear messageid:h105_200_CreateApplication
#cat scripts/h105_200_CreateApplication.json | http -v POST :8080/ses/v1/createApplicationFromPriorYear messageid:h105_200_CreateApplication

#cat h105_200_CreateApplication.json | http -v POST vlab-dsh-th:8180/hix-dsh-externalharness/ses/v1/createApplicationFromPriorYear messageid:h105_200_CreateApplication
cat scripts/h105_200_CreateApplication.json | http --verify no -v POST ${SES_URI}/v1/createApplicationFromPriorYear messageid:h105_200_CreateApplication partnerid:04.NDB.NV*.702.126
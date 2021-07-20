#!/bin/sh

set -e

BASEDIR=$(dirname "$0")
CORE_INFRA_DIR=$BASEDIR/../../core-infra
APP_DOMAIN=$(terraform -chdir=$CORE_INFRA_DIR output --raw app_domain)
GCS_BUCKET=$(terraform -chdir=$CORE_INFRA_DIR output --raw frontend_app_bucket_name)

rm -rf $BASEDIR/dist
cp -R $BASEDIR/src $BASEDIR/dist

echo "var appConfig = {
  apiUrl: 'https://$APP_DOMAIN'
}" > $BASEDIR/dist/config.js

gsutil -m rsync -r -d $BASEDIR/dist gs://$GCS_BUCKET/
#!/usr/bin/env bash

docker build -t frc-churn .

docker run --rm \
  -v "$PWD/output:/churn/output" \
  -v "$PWD/cache:/churn/cache" \
  frc-churn make

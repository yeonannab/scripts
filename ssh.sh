#!/usr/bin/env bash
# Copyright 2021 Dokyung Song. All rights reserved.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.

ssh -i stretch.id_rsa -p 10022 -o "StrictHostKeyChecking no" root@localhost

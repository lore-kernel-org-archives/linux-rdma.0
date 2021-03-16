Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126ADC433DB
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Mar 2021 09:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6EC65016
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Mar 2021 09:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhCPJvr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 16 Mar 2021 05:51:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40699 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbhCPJvV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 16 Mar 2021 05:51:21 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lM6M9-000548-IN; Tue, 16 Mar 2021 09:51:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] RDMA/mlx5: Fix missing assignment of rc when calling mlx5_ib_dereg_mr
Date:   Tue, 16 Mar 2021 09:51:17 +0000
Message-Id: <20210316095117.17089-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment of the return code to rc when calling mlx5_ib_dereg_mr is
missing and there is an error check on an uninitialized rc. Fix this by
adding in the assignment.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: e6fb246ccafb ("RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 86ffc7e5ef96..9dcb9fb4eeaa 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1946,7 +1946,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 			mr->mtt_mr = NULL;
 		}
 		if (mr->klm_mr) {
-			mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
+			rc = mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
 			if (rc)
 				return rc;
 			mr->klm_mr = NULL;
-- 
2.30.2


Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BC9C433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 14 Mar 2021 08:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E3F64E13
	for <linux-rdma@archiver.kernel.org>; Sun, 14 Mar 2021 08:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhCNIW7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 14 Mar 2021 04:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234609AbhCNIW7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 14 Mar 2021 04:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A930964EBE;
        Sun, 14 Mar 2021 08:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615710176;
        bh=sLl2nYkD/4TZCSxevhnQbZ6vDwLMPKYMWjWlR+JBF2g=;
        h=From:To:Cc:Subject:Date:From;
        b=IsF8qCA17AwBMq0yz8xHAafNDZpv/dzDLorCsivbUyrkrsxauuDhC4i0PVGlbVpGa
         x/5bqLtftzfFb6K1AUT4hLNPxQ2WNH2tdCV3WWRa2AvBdNF0hq11wCwVPH9BxIng4g
         2Vzthux+1lm8rI7jh6VP6AdeMXSambKMZX+IMUkvkACKd70x3LA910mC4F6j36QSYx
         ucn1x/JIJZXgHSJ6Yi3BrJFudHpVEQujSo+1zhyDVNMCld2UILEn+pcu64twRD0D3y
         2JoxoriCtJdnOq/LQ1TZDEPPud2zRZ4pFr7HmyA+lBwvOI1ipnlOzQmH70zF8drWwR
         phMMUbHn+vFTA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        kernel test robot <lkp@intel.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Add missing returned error check of mlx5_ib_dereg_mr
Date:   Sun, 14 Mar 2021 10:22:50 +0200
Message-Id: <20210314082250.10143-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following smatch error:
drivers/infiniband/hw/mlx5/mr.c:1950 mlx5_ib_dereg_mr() error: uninitialized symbol 'rc'.

Fixes: 715d68e63629 ("RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index dbf4c6face6c..552fecd210c2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1962,7 +1962,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
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


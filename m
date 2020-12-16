Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AF7C4361B
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Dec 2020 10:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ACAB2313B
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Dec 2020 10:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLPKIj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Dec 2020 05:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgLPKIj (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 16 Dec 2020 05:08:39 -0500
From:   Leon Romanovsky <leon@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/restrack: Don't treat as an error allocation ID wrapping
Date:   Wed, 16 Dec 2020 12:07:53 +0200
Message-Id: <20201216100753.1127638-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

xa_alloc_cyclic() call returns positive number if ID allocation
succeeded but wrapped. It is not an error, so normalize the "ret"
variable to zero as marker of not-an-error.

   drivers/infiniband/core/restrack.c:261 rdma_restrack_add()
   warn: 'ret' can be either negative or positive

Fixes: fd47c2f99f04 ("RDMA/restrack: Convert internal DB from hash to XArray")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/restrack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 53a8005972a8..5226ac0e0e07 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -257,6 +257,7 @@ int rdma_restrack_add(struct rdma_restrack_entry *res)
 	default:
 		ret = xa_alloc_cyclic(&rt->xa, &res->id, res, xa_limit_32b,
 				      &rt->next_id, GFP_KERNEL);
+		ret = (ret < 0) ? ret : 0;
 	}
 	if (ret) {
 		ibdev_err(
-- 
2.29.2


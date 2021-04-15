Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F75CC43460
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Apr 2021 15:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F9DC61184
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Apr 2021 15:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhDOPQT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 15 Apr 2021 11:16:19 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:22297 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbhDOPO6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 15 Apr 2021 11:14:58 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13FFEN4r027341;
        Thu, 15 Apr 2021 08:14:24 -0700
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     jgg@nvidia.com, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com
Subject: [PATCH for-next] RDMA/cxgb4: add missing qpid increment
Date:   Thu, 15 Apr 2021 20:44:22 +0530
Message-Id: <20210415151422.9139-1-bharat@chelsio.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

missing qpid increment leads to skipping few qpids while allocating QP.
This eventually leads to adapter running out of qpids after establishing
fewer connections than it actually supports.
Current patch increments the qpid correctly.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 5c95c789f302..e800e8e8bed5 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -216,7 +216,7 @@ u32 c4iw_get_qpid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx)
 			goto out;
 		entry->qid = qid;
 		list_add_tail(&entry->entry, &uctx->cqids);
-		for (i = qid; i & rdev->qpmask; i++) {
+		for (i = qid + 1; i & rdev->qpmask; i++) {
 			entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 			if (!entry)
 				goto out;
-- 
2.24.0


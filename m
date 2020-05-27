Return-Path: <SRS0=0PZL=7J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB6BC433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 08:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B282078B
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 08:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgE0IfA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 27 May 2020 04:35:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42733 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387811AbgE0Ie7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 27 May 2020 04:34:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yaminf@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 11:34:57 +0300
Received: from arch012.mtl.labs.mlnx. (arch012.mtl.labs.mlnx [10.7.13.12])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R8YvRW003290;
        Wed, 27 May 2020 11:34:57 +0300
From:   Yamin Friedman <yaminf@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Yamin Friedman <yaminf@mellanox.com>
Subject: [PATCH V4 1/4] RDMA/core: Add protection for shared CQs used by ULPs
Date:   Wed, 27 May 2020 11:34:52 +0300
Message-Id: <1590568495-101621-2-git-send-email-yaminf@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590568495-101621-1-git-send-email-yaminf@mellanox.com>
References: <1590568495-101621-1-git-send-email-yaminf@mellanox.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

A pre-step for adding shared CQs. Add the infrastructure to prevent
shared CQ users from altering the CQ configurations. For now all cqs are
marked as private (non-shared). The core driver should use the new force
functions to perform resize/destroy/moderation changes that are not
allowed for users of shared CQs.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 9 +++++++++
 include/rdma/ib_verbs.h         | 5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bf0249f..675f601 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1990,6 +1990,9 @@ struct ib_cq *__ib_create_cq(struct ib_device *device,
 
 int rdma_set_cq_moderation(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 {
+	if (cq->shared)
+		return -EOPNOTSUPP;
+
 	return cq->device->ops.modify_cq ?
 		cq->device->ops.modify_cq(cq, cq_count,
 					  cq_period) : -EOPNOTSUPP;
@@ -1998,6 +2001,9 @@ int rdma_set_cq_moderation(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 
 int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 {
+	if (WARN_ON_ONCE(cq->shared))
+		return -EOPNOTSUPP;
+
 	if (atomic_read(&cq->usecnt))
 		return -EBUSY;
 
@@ -2010,6 +2016,9 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 
 int ib_resize_cq(struct ib_cq *cq, int cqe)
 {
+	if (cq->shared)
+		return -EOPNOTSUPP;
+
 	return cq->device->ops.resize_cq ?
 		cq->device->ops.resize_cq(cq, cqe, NULL) : -EOPNOTSUPP;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4c488ca..322dacf 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1576,7 +1576,8 @@ struct ib_cq {
 
 	/* updated only by trace points */
 	ktime_t timestamp;
-	bool interrupt;
+	u8 interrupt:1;
+	u8 shared:1;
 
 	/*
 	 * Implementation details of the RDMA core, don't use in drivers:
@@ -3824,6 +3825,8 @@ static inline struct ib_cq *ib_alloc_cq_any(struct ib_device *dev,
  * ib_free_cq_user - Free kernel/user CQ
  * @cq: The CQ to free
  * @udata: Valid user data or NULL for kernel objects
+ *
+ * NOTE: This function shouldn't be called on shared CQs.
  */
 void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata);
 
-- 
1.8.3.1


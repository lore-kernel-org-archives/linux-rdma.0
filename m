Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6019C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 09:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4C364DD6
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 09:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhBJJlW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Feb 2021 04:41:22 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52950 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhBJJjT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Feb 2021 04:39:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UOLfwUr_1612949902;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UOLfwUr_1612949902)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Feb 2021 17:38:35 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mkalderon@marvell.com
Cc:     aelior@marvell.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] DMA/qedr: Use true and false for bool variable
Date:   Wed, 10 Feb 2021 17:38:21 +0800
Message-Id: <1612949901-109873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix the following coccicheck warning:

./drivers/infiniband/hw/qedr/qedr.h:629:9-10: WARNING: return of 0/1 in
function 'qedr_qp_has_rq' with return type bool.

./drivers/infiniband/hw/qedr/qedr.h:620:9-10: WARNING: return of 0/1 in
function 'qedr_qp_has_sq' with return type bool.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/infiniband/hw/qedr/qedr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 9dde703..3cb4feb 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -617,18 +617,18 @@ static inline bool qedr_qp_has_srq(struct qedr_qp *qp)
 static inline bool qedr_qp_has_sq(struct qedr_qp *qp)
 {
 	if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_XRC_TGT)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 static inline bool qedr_qp_has_rq(struct qedr_qp *qp)
 {
 	if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_XRC_INI ||
 	    qp->qp_type == IB_QPT_XRC_TGT || qedr_qp_has_srq(qp))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 static inline struct qedr_user_mmap_entry *
-- 
1.8.3.1


Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C031C43334
	for <linux-rdma@archiver.kernel.org>; Fri, 10 Jun 2022 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbiFJJpq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245750AbiFJJpp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 10 Jun 2022 05:45:45 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50883151E7;
        Fri, 10 Jun 2022 02:45:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VFypZVW_1654854332;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VFypZVW_1654854332)
          by smtp.aliyun-inc.com;
          Fri, 10 Jun 2022 17:45:41 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jgg@ziepe.ca
Cc:     leon@kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] RDMA/cm: fix cond_no_effect.cocci warnings
Date:   Fri, 10 Jun 2022 17:45:30 +0800
Message-Id: <20220610094530.28950-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This was found by coccicheck:

./drivers/infiniband/core/cm.c:685:7-9: WARNING: possible condition with no effect (if == else).

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/infiniband/core/cm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1c107d6d03b9..bb6a2b6b9657 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -676,14 +676,9 @@ static struct cm_id_private *cm_find_listen(struct ib_device *device,
 			refcount_inc(&cm_id_priv->refcount);
 			return cm_id_priv;
 		}
-		if (device < cm_id_priv->id.device)
+		if (device < cm_id_priv->id.device ||
+		    be64_lt(service_id, cm_id_priv->id.service_id))
 			node = node->rb_left;
-		else if (device > cm_id_priv->id.device)
-			node = node->rb_right;
-		else if (be64_lt(service_id, cm_id_priv->id.service_id))
-			node = node->rb_left;
-		else if (be64_gt(service_id, cm_id_priv->id.service_id))
-			node = node->rb_right;
 		else
 			node = node->rb_right;
 	}
-- 
2.20.1.7.g153144c


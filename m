Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47220C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF7064E90
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhBYJ1I (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:27:08 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:41471 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234932AbhBYJ1E (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 25 Feb 2021 04:27:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UPX1c9T_1614245177;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPX1c9T_1614245177)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Feb 2021 17:26:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mike.marciniszyn@cornelisnetworks.com
Cc:     dennis.dalessandro@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] RDMA/hw/hfi1/tid_rdma: remove unnecessary conversion to bool
Date:   Thu, 25 Feb 2021 17:26:15 +0800
Message-Id: <1614245175-73043-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/infiniband/hw/hfi1/tid_rdma.c:1118:36-41: WARNING: conversion
to bool not needed here.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 0b1f9e4..8958ea3 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -1115,7 +1115,7 @@ static u32 kern_find_pages(struct tid_rdma_flow *flow,
 	}
 
 	flow->length = flow->req->seg_len - length;
-	*last = req->isge == ss->num_sge ? false : true;
+	*last = req->isge == !ss->num_sge;
 	return i;
 }
 
-- 
1.8.3.1


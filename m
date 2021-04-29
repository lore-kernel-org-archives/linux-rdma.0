Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C726AC433B4
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Apr 2021 10:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B1E7613E8
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Apr 2021 10:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhD2KnM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 29 Apr 2021 06:43:12 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56100 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232245AbhD2KnM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 29 Apr 2021 06:43:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UX9d.L0_1619692943;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UX9d.L0_1619692943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 18:42:24 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     dennis.dalessandro@cornelisnetworks.com
Cc:     mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, nathan@kernel.org, ndesaulniers@google.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] IB/qib: Remove redundant assignment to ret
Date:   Thu, 29 Apr 2021 18:42:20 +0800
Message-Id: <1619692940-104771-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Variable 'ret' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed

Clean up the following clang-analyzer warning:

drivers/infiniband/hw/qib/qib_sd7220.c:690:2: warning: Value stored to
'ret' is never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/infiniband/hw/qib/qib_sd7220.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index 4f4a09c..81b810d 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -687,7 +687,6 @@ static int qib_sd7220_reg_mod(struct qib_devdata *dd, int sdnum, u32 loc,
 		spin_unlock_irqrestore(&dd->cspec->sdepb_lock, flags);
 		return -1;
 	}
-	ret = 0;
 	for (tries = EPB_TRANS_TRIES; tries; --tries) {
 		transval = qib_read_kreg32(dd, trans);
 		if (transval & EPB_TRANS_RDY)
-- 
1.8.3.1


Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB1DC43219
	for <linux-rdma@archiver.kernel.org>; Thu, 24 Nov 2022 11:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKXLtt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 24 Nov 2022 06:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiKXLtp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 24 Nov 2022 06:49:45 -0500
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B269BE857
        for <linux-rdma@vger.kernel.org>; Thu, 24 Nov 2022 03:49:39 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VVb2j-G_1669290575;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VVb2j-G_1669290575)
          by smtp.aliyun-inc.com;
          Thu, 24 Nov 2022 19:49:35 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: [PATCH v2 for-rc] RDMA/erdma: Fix a typo in annotation
Date:   Thu, 24 Nov 2022 19:49:33 +0800
Message-Id: <20221124114933.77250-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

A non-ASCII character was wrongly put in annotation, which should be
removed.

Fixes: bee85e0e31ec ("RDMA/erdma: Add main include file")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma.h b/drivers/infiniband/hw/erdma/erdma.h
index bb23d897c710..35726f25a989 100644
--- a/drivers/infiniband/hw/erdma/erdma.h
+++ b/drivers/infiniband/hw/erdma/erdma.h
@@ -219,7 +219,7 @@ struct erdma_dev {
 	DECLARE_BITMAP(sdb_page, ERDMA_DWQE_TYPE0_CNT);
 	/*
 	 * We provide max 496 uContexts that each has one SQ normal Db,
-	 * and one directWQE db。
+	 * and one directWQE db.
 	 */
 	DECLARE_BITMAP(sdb_entry, ERDMA_DWQE_TYPE1_CNT);
 
-- 
2.27.0


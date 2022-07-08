Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79146C433EF
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Jul 2022 17:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiGHRUr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 8 Jul 2022 13:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238508AbiGHRUq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 8 Jul 2022 13:20:46 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48D1759D
        for <linux-rdma@vger.kernel.org>; Fri,  8 Jul 2022 10:20:45 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 9rejoEOTkxzw29rekoKOUt; Fri, 08 Jul 2022 19:20:43 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 08 Jul 2022 19:20:43 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/qib: Use the bitmap API to allocate bitmaps
Date:   Fri,  8 Jul 2022 19:20:39 +0200
Message-Id: <f7a8588447679e80a438b6188b0603c1a11ad877.1657300671.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/infiniband/hw/qib/qib_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index d1a72e89e297..45211008449f 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1106,8 +1106,7 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	if (!qib_cpulist_count) {
 		u32 count = num_online_cpus();
 
-		qib_cpulist = kcalloc(BITS_TO_LONGS(count), sizeof(long),
-				      GFP_KERNEL);
+		qib_cpulist = bitmap_zalloc(count, GFP_KERNEL);
 		if (qib_cpulist)
 			qib_cpulist_count = count;
 	}
@@ -1279,7 +1278,7 @@ static void __exit qib_ib_cleanup(void)
 #endif
 
 	qib_cpulist_count = 0;
-	kfree(qib_cpulist);
+	bitmap_free(qib_cpulist);
 
 	WARN_ON(!xa_empty(&qib_dev_table));
 	qib_dev_cleanup();
-- 
2.34.1


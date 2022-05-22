Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D336FC433EF
	for <linux-rdma@archiver.kernel.org>; Sun, 22 May 2022 13:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345222AbiEVNZQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 22 May 2022 09:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbiEVNZP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 22 May 2022 09:25:15 -0400
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D97B37AB1
        for <linux-rdma@vger.kernel.org>; Sun, 22 May 2022 06:25:12 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id sla2n9Iqx26JCsla2nXCYh; Sun, 22 May 2022 15:25:11 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 22 May 2022 15:25:11 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     dan.carpenter@oracle.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Bob Pearson <rpearsonhpe@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/rxe: Fix an error handling path in rxe_get_mcg()
Date:   Sun, 22 May 2022 15:25:08 +0200
Message-Id: <fe137cd8b1f17593243aa73d59c18ea71ab9ee36.1653225896.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The commit in the Fixes tag has shuffled some code.
Now 'mcg_num' is incremented before the kzalloc(). So if the memory
allocation fails, this increment must be undone.

Fixes: a926a903b7dc ("RDMA/rxe: Do not call dev_mc_add/del() under a spinlock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/infiniband/sw/rxe/rxe_mcast.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index 873a9b10307c..86cc2e18a7fd 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -206,8 +206,10 @@ static struct rxe_mcg *rxe_get_mcg(struct rxe_dev *rxe, union ib_gid *mgid)
 
 	/* speculative alloc of new mcg */
 	mcg = kzalloc(sizeof(*mcg), GFP_KERNEL);
-	if (!mcg)
-		return ERR_PTR(-ENOMEM);
+	if (!mcg) {
+		err = -ENOMEM;
+		goto err_dec;
+	}
 
 	spin_lock_bh(&rxe->mcg_lock);
 	/* re-check to see if someone else just added it */
-- 
2.34.1


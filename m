Return-Path: <SRS0=V7/i=4P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC798C4BA24
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 12:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D232468E
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 12:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582806859;
	bh=LRFurkEkQTugMY/NHnAjHAnKl8tjjhq3VB3qCGAgfGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AOESLMBc4KqPE3XBIslEPXCyyli5IpM2qV7FxRnm0imkmvoLsji/R8aOggGY0DH3W
	 DWQyEWpXt4X7/U3esktRvIiZfHsufEVTsr8Iu1jtpgq8ls3CNFpGBRJfWYLTz1xmA+
	 7Cg2iwcCtuqXVDDLyfepa2uM062jpIMxKjog8G3Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgB0MeT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 Feb 2020 07:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgB0MeS (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 27 Feb 2020 07:34:18 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7211824697;
        Thu, 27 Feb 2020 12:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582806858;
        bh=LRFurkEkQTugMY/NHnAjHAnKl8tjjhq3VB3qCGAgfGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZd+m2gde9BGOyid2HSWehgICsvuMFP/wx3Hac3RJebO2ypmrjALzZ6UvDkP3pDF5
         FMG7xsNadY1JIaSfhnbjnM6EhW3Pxh0RkSzN8u8PlDad79AEvBYHAwMeDUerJR4OaD
         NCkoQ8WZRkboW1y/Whhuqs2NWteo08Y4Vi7p+lUo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Artemy Kovalyov <artemyko@mellanox.com>,
        linux-rdma@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 4/9] RDMA/mlx5: Always remove MRs from the cache before destroying them
Date:   Thu, 27 Feb 2020 14:33:55 +0200
Message-Id: <20200227123400.97758-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227123400.97758-1-leon@kernel.org>
References: <20200227123400.97758-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

The cache bucket tracks the total number of MRs that exists, both inside
and outside of the cache. Removing a MR from the cache (by setting
cache_ent to NULL) without updating total_mrs will cause the tracking to
leak and be inflated.

Further fix the rereg_mr path to always destroy the MR. reg_create will
always overwrite all the MR data in mlx5_ib_mr, so the MR must be
completely destroyed, in all cases, before this function can be
called. Detach the MR from the cache and unconditionally destroy it to
avoid leaking HW mkeys.

Fixes: afd1417404fb ("IB/mlx5: Use direct mkey destroy command upon UMR unreg failure")
Fixes: 56e11d628c5d ("IB/mlx5: Added support for re-registration of MRs")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 68e5a3955b1d..c951bb14de56 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -464,6 +464,16 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_cache_ent *req_ent)
 	return mr;
 }

+static void detach_mr_from_cache(struct mlx5_ib_mr *mr)
+{
+	struct mlx5_cache_ent *ent = mr->cache_ent;
+
+	mr->cache_ent = NULL;
+	spin_lock_irq(&ent->lock);
+	ent->total_mrs--;
+	spin_unlock_irq(&ent->lock);
+}
+
 void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_cache_ent *ent = mr->cache_ent;
@@ -473,7 +483,7 @@ void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		return;

 	if (mlx5_mr_cache_invalidate(mr)) {
-		mr->cache_ent = NULL;
+		detach_mr_from_cache(mr);
 		destroy_mkey(dev, mr);
 		if (ent->available_mrs < ent->limit)
 			queue_work(dev->cache.wq, &ent->work);
@@ -1432,9 +1442,8 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		 * UMR can't be used - MKey needs to be replaced.
 		 */
 		if (mr->cache_ent)
-			err = mlx5_mr_cache_invalidate(mr);
-		else
-			err = destroy_mkey(dev, mr);
+			detach_mr_from_cache(mr);
+		err = destroy_mkey(dev, mr);
 		if (err)
 			goto err;

@@ -1446,8 +1455,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			mr = to_mmr(ib_mr);
 			goto err;
 		}
-
-		mr->cache_ent = NULL;
 	} else {
 		/*
 		 * Send a UMR WQE
--
2.24.1


Return-Path: <SRS0=BMee=WC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C3BC41514
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 21:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225322089E
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565127376;
	bh=c4SWqxEVkDOOshiCTZCQDp/v/qbClgzW5QOXT48+CyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=T/HobmQ/hyrFB6sMFw8b4UGQIW++9PqDEZShvxC7t5rmkggGDqPh0/BXPyQDJwbki
	 Mv1bGrLQRGuWSBUmJ2b6/G/939kAPtNlnPYKvOjtHvWwjbPX31dE5k+cSS7v1nrB6G
	 vPTzYv5njO8dCeQoVAK5cDTC0sIRfOWkenaDGWUY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfHFVgL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Aug 2019 17:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbfHFVgL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6078D217D9;
        Tue,  6 Aug 2019 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127370;
        bh=c4SWqxEVkDOOshiCTZCQDp/v/qbClgzW5QOXT48+CyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXPu4j39GFbiqedE8EJ7kHJ5z23a5gdsILBnrQrFIymwv+WTcV1Dmlkw4bzfzu/gB
         /t6rChF2mz9IvOwelF7JPlL3jFCgPk2zJ5BugLzdq0kDkJxvSTeVVRCAJS3NBna490
         CPEFFa6zqysmnuxcN4TWPoVnhU5+4rVyn4q6Z67M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guy Levi <guyle@mellanox.com>, Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/32] IB/mlx5: Fix MR registration flow to use UMR properly
Date:   Tue,  6 Aug 2019 17:35:13 -0400
Message-Id: <20190806213522.19859-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213522.19859-1-sashal@kernel.org>
References: <20190806213522.19859-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Guy Levi <guyle@mellanox.com>

[ Upstream commit e5366d309a772fef264ec85e858f9ea46f939848 ]

Driver shouldn't allow to use UMR to register a MR when
umr_modify_atomic_disabled is set. Otherwise it will always end up with a
failure in the post send flow which sets the UMR WQE to modify atomic access
right.

Fixes: c8d75a980fab ("IB/mlx5: Respect new UMR capabilities")
Signed-off-by: Guy Levi <guyle@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190731081929.32559-1-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7df4a4fe4af47..4ea8d04143ae5 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -51,22 +51,12 @@ static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
-static bool umr_can_modify_entity_size(struct mlx5_ib_dev *dev)
-{
-	return !MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled);
-}
 
 static bool umr_can_use_indirect_mkey(struct mlx5_ib_dev *dev)
 {
 	return !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled);
 }
 
-static bool use_umr(struct mlx5_ib_dev *dev, int order)
-{
-	return order <= mr_cache_max_order(dev) &&
-		umr_can_modify_entity_size(dev);
-}
-
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	int err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
@@ -1302,7 +1292,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
-	bool populate_mtts = false;
+	bool use_umr;
 	struct ib_umem *umem;
 	int page_shift;
 	int npages;
@@ -1335,29 +1325,30 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (use_umr(dev, order)) {
+	use_umr = !MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled) &&
+		  (!MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled) ||
+		   !MLX5_CAP_GEN(dev->mdev, atomic));
+
+	if (order <= mr_cache_max_order(dev) && use_umr) {
 		mr = alloc_mr_from_cache(pd, umem, virt_addr, length, ncont,
 					 page_shift, order, access_flags);
 		if (PTR_ERR(mr) == -EAGAIN) {
 			mlx5_ib_dbg(dev, "cache empty for order %d\n", order);
 			mr = NULL;
 		}
-		populate_mtts = false;
 	} else if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset)) {
 		if (access_flags & IB_ACCESS_ON_DEMAND) {
 			err = -EINVAL;
 			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB\n");
 			goto error;
 		}
-		populate_mtts = true;
+		use_umr = false;
 	}
 
 	if (!mr) {
-		if (!umr_can_modify_entity_size(dev))
-			populate_mtts = true;
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(NULL, pd, virt_addr, length, umem, ncont,
-				page_shift, access_flags, populate_mtts);
+				page_shift, access_flags, !use_umr);
 		mutex_unlock(&dev->slow_path_mutex);
 	}
 
@@ -1375,7 +1366,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	update_odp_mr(mr);
 #endif
 
-	if (!populate_mtts) {
+	if (use_umr) {
 		int update_xlt_flags = MLX5_IB_UPD_XLT_ENABLE;
 
 		if (access_flags & IB_ACCESS_ON_DEMAND)
-- 
2.20.1


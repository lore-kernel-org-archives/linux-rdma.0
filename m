Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDE5C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Feb 2022 05:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbiBWFKx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Feb 2022 00:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbiBWFKs (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Feb 2022 00:10:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D55865833;
        Tue, 22 Feb 2022 21:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E691CB81E82;
        Wed, 23 Feb 2022 05:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0A6C340EB;
        Wed, 23 Feb 2022 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593013;
        bh=m6XO6tyCsQl/0mkgQVShucIMftO83qs12ofEEKGhrpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUJOcCqkWjj9MLFX6kJ2D/rYMXWsjJXfKzYNJT/rMD7WPJWVjkqvZJo6P0hG0DSA5
         FCdjnOOiMC/87sW5P/tCLbO+Y8+2LLy1FS+o81xhIQFhkOnqLVBkH59oRhNrldZcfs
         KLlk+2Kp5a4VVESwzTmjYaJPjGyPHzQnnTRtOgmsdKXU0WZ+zLp5NId1ZVtHTMoirx
         7GdtEKGNdv8ogWmjAUyYJfZx35kWXE6uKiyNpz4ghAMaBt+2jpwpYw7RJAwNd+Q+kq
         C1akdHpFfVGVcuyNWtWHhrLYlPceelE9gXo4CUzwitMr8saUWKQGABEbCuWyuyj/Nv
         pTBKid2Pbsb/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 06/17] net/mlx5: Lag, use local variable already defined to access E-Switch
Date:   Tue, 22 Feb 2022 21:09:21 -0800
Message-Id: <20220223050932.244668-7-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Use the local variable for dev0 (and add from dev1) instead of using
the devices stored in the ldev structure. Makes the code easier
to read.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4ddf6b330a44..0758a98a08d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -347,6 +347,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
 	u8 flags = ldev->flags;
@@ -356,8 +357,8 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	mlx5_lag_mp_reset(ldev);
 
 	if (ldev->shared_fdb) {
-		mlx5_eswitch_offloads_destroy_single_fdb(ldev->pf[MLX5_LAG_P1].dev->priv.eswitch,
-							 ldev->pf[MLX5_LAG_P2].dev->priv.eswitch);
+		mlx5_eswitch_offloads_destroy_single_fdb(dev0->priv.eswitch,
+							 dev1->priv.eswitch);
 		ldev->shared_fdb = false;
 	}
 
-- 
2.35.1


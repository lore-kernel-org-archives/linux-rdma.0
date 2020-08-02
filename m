Return-Path: <SRS0=CapX=BM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAA2C433DF
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 08:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BD9207FB
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 08:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596356238;
	bh=JkUjVBNg1mLjiabyLv/Hg8W+Oip3xJomOyaMAQ6TMKQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=X/qnkMFe+MHdG7SIGuHNFPn0jkHn7T7cFthyKCV9PaavioZWpzZVHRvjoyOEbz4qO
	 mD5RS3bYJ3dt23xmPDPSaE2ZGwFtM41xQayTkSbYW2Mj9D3PRMh7Qf4aJJ5rae3Ix2
	 DTqR2wLORdACI17UJjmpvjnjepNn7i+kG0H3fN5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgHBIRS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 2 Aug 2020 04:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgHBIRR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 2 Aug 2020 04:17:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2542075A;
        Sun,  2 Aug 2020 08:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596356237;
        bh=JkUjVBNg1mLjiabyLv/Hg8W+Oip3xJomOyaMAQ6TMKQ=;
        h=From:To:Cc:Subject:Date:From;
        b=x2yUPq/zbsN/xC8e97a5ktKnAfEhoN/+TCG+hTNn39sTZu10N9rLmT5B+IsTebFEM
         UMJ4FN2HIBLqFlp1WDsJEstfSV0jz8y97lSwd+iReXL7NzSqsZIh6Z+AzlpCbQKWz/
         2SU38zAtuwvJow7staSD1JAeIomKWRT7w0BCTbnA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Add new IB rates support
Date:   Sun,  2 Aug 2020 11:17:12 +0300
Message-Id: <20200802081712.1993490-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Support 56, 25, 100, 200 and 50Gbps IB rates in mlx5 driver.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a5c32be73575..e5c6f7772521 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3085,20 +3085,44 @@ enum {
 	MLX5_PATH_FLAG_COUNTER	= 1 << 2,
 };
 
+static int ib_to_mlx5_rate_map(u8 rate)
+{
+	switch (rate) {
+	case IB_RATE_PORT_CURRENT:
+		return 0;
+	case IB_RATE_56_GBPS:
+		return 1;
+	case IB_RATE_25_GBPS:
+		return 2;
+	case IB_RATE_100_GBPS:
+		return 3;
+	case IB_RATE_200_GBPS:
+		return 4;
+	case IB_RATE_50_GBPS:
+		return 5;
+	default:
+		return rate + MLX5_STAT_RATE_OFFSET;
+	};
+
+	return 0;
+}
+
 static int ib_rate_to_mlx5(struct mlx5_ib_dev *dev, u8 rate)
 {
+	u32 stat_rate_support;
+
 	if (rate == IB_RATE_PORT_CURRENT)
 		return 0;
 
 	if (rate < IB_RATE_2_5_GBPS || rate > IB_RATE_600_GBPS)
 		return -EINVAL;
 
+	stat_rate_support = MLX5_CAP_GEN(dev->mdev, stat_rate_support);
 	while (rate != IB_RATE_PORT_CURRENT &&
-	       !(1 << (rate + MLX5_STAT_RATE_OFFSET) &
-		 MLX5_CAP_GEN(dev->mdev, stat_rate_support)))
+	       !(1 << ib_to_mlx5_rate_map(rate) & stat_rate_support))
 		--rate;
 
-	return rate ? rate + MLX5_STAT_RATE_OFFSET : rate;
+	return ib_to_mlx5_rate_map(rate);
 }
 
 static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
-- 
2.26.2


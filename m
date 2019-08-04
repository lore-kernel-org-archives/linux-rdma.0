Return-Path: <SRS0=GppO=WA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8791C433FF
	for <linux-rdma@archiver.kernel.org>; Sun,  4 Aug 2019 10:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF36206C1
	for <linux-rdma@archiver.kernel.org>; Sun,  4 Aug 2019 10:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564912864;
	bh=Rtk6U7EiDjBgEU7EoLUkbC8qd00Qm2tk1eW9nxTWRiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=plT1DeThby2/X5wnKu4NzHVTFGtjnQtlcYGtouEqDPuOOK/CGMIQanV5FjFUUOw8C
	 NbA4TuqQ+w4djB6hwBrgSCCNqLi0KuG7sH5yrYuZat5ov/VBpK2owJUQ6215W6s07k
	 lM+B8AEok8SmH0h/lZt8d87bEXFM2UKlkunWX6jw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfHDKBE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 4 Aug 2019 06:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfHDKBD (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 4 Aug 2019 06:01:03 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D510F2086D;
        Sun,  4 Aug 2019 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564912862;
        bh=Rtk6U7EiDjBgEU7EoLUkbC8qd00Qm2tk1eW9nxTWRiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2aS02/vd/eT2562VKg6/nZwvn1ST7H46e0ao4GyBwc+tebO+BQ27x5VMbo5f/zRE
         K7/3CdVtiqbzjNuVZfliGDuyBzfUWXAZoH/H1THQ+l3g0XZPMccNsqs4YujAa7QI8t
         /zk4H3nfacvXLaeRMCYguRLaiR0AJV9NAVVlsnBQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v1 1/3] IB/mlx5: Query ODP capabilities for DC
Date:   Sun,  4 Aug 2019 13:00:46 +0300
Message-Id: <20190804100048.32671-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190804100048.32671-1-leon@kernel.org>
References: <20190804100048.32671-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Set current capabilities of ODP for DC to max capabilities and cache
them in mlx5_ib.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  1 +
 drivers/infiniband/hw/mlx5/odp.c               | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  6 ++++++
 include/linux/mlx5/mlx5_ifc.h                  |  4 +++-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index cb41a7e6255a..f99c71b3c876 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -967,6 +967,7 @@ struct mlx5_ib_dev {
 	struct mutex			slow_path_mutex;
 	int				fill_delay;
 	struct ib_odp_caps	odp_caps;
+	uint32_t		dc_odp_caps;
 	u64			odp_max_size;
 	struct mlx5_ib_pf_eq	odp_pf_eq;
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b0c5de39d186..5e87a5e25574 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -353,6 +353,24 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.srq_receive))
 		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
 
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.send))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_SEND;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.receive))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_RECV;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.write))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_WRITE;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.read))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_READ;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.atomic))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.srq_receive))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
+
 	if (MLX5_CAP_GEN(dev->mdev, fixed_buffer_size) &&
 	    MLX5_CAP_GEN(dev->mdev, null_mkey) &&
 	    MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b15b27a497fc..3995fc6d4d34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -495,6 +495,12 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.send);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.write);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
 	if (do_set)
 		err = set_caps(dev, set_ctx, set_sz,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ec571fd7fcf8..5eae8d734435 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
 
 	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
 
-	u8         reserved_at_100[0x700];
+	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
+
+	u8         reserved_at_100[0x6E0];
 };
 
 struct mlx5_ifc_calc_op {
-- 
2.20.1


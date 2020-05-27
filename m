Return-Path: <SRS0=0PZL=7J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139E2C433E1
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB806207D8
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590587831;
	bh=ofZOYiNIvQlcB32FVr0BvKaKqU69DeAoSccHnObzJeA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=KShkqq2TolBWpx2jB65P1MNURzBbmVUtmwwZIewg1c6AD9NCVH4IHe+aTpRYlq7oz
	 +7W7RKiMjfVo3YF29DEaK8p5juZ3x9uBAOerABYoDlctNFBuhLGBFf7bhgNXL9R52Z
	 iUb56g4j9mWpXyzduuqqSDAwRJbXv2dJ9gwIjI5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbgE0N5J (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 27 May 2020 09:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389038AbgE0N5I (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 27 May 2020 09:57:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BB8207D8;
        Wed, 27 May 2020 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587828;
        bh=ofZOYiNIvQlcB32FVr0BvKaKqU69DeAoSccHnObzJeA=;
        h=From:To:Cc:Subject:Date:From;
        b=z5/9aIOaH1Fy2n2JZ1BK5m5m7APHSpRbipLHGtMGvSjdftTPZ6VjoW9s3ERWowlPh
         73oqvQ56ARe88a1whp/DsuWL0D99iWRzs+2z9OFZFuAhxG7xyRHQ57oDbswY/Bznv9
         Bp1SxkINMlKtOojp0hxzT27mYmq1zhXY+b61KLsc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Aharon Landau <aharonl@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next] IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command
Date:   Wed, 27 May 2020 16:57:03 +0300
Message-Id: <20200527135703.482501-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

The commit citied in the Fixes line wasn't complete and solved
only part of the problems. Update the mlx5_ib to properly support
MLX5_CMD_OP_INIT2INIT_QP command in the DEVX, that is required when
modify the QP tx_port_affinity.

Fixes: 819f7427bafd ("RDMA/mlx5: Add init2init as a modify command")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 3047e7d60a9b..9454a66c12cc 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -495,6 +495,10 @@ static u64 devx_get_obj_id(const void *in)
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
 					MLX5_GET(rst2init_qp_in, in, qpn));
 		break;
+	case MLX5_CMD_OP_INIT2INIT_QP:
+		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
+					MLX5_GET(init2init_qp_in, in, qpn));
+		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
 					MLX5_GET(init2rtr_qp_in, in, qpn));
-- 
2.26.2


Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D69C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4302166E
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592447016;
	bh=dUkmD52lNqPmRdAMdoB/PrJJyegJXyeJhm0rTeXELTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IXESwCFEySFhfcwZW1oShpA4sv9Wm3920KPo3xiFVeqxPejQNe71i0Gwar+jfWyVD
	 WwTVaBj7jag8chI7f2PxhwnHwkLAs+MMMmE9Fpgvpg+BLWyTSqwWuXz2xbithDH2q8
	 OdwTk3WudeP2ZAE6V/87b5vOp1kvB8aIBn7nJnLQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgFRCXf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgFRBRy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE87921D90;
        Thu, 18 Jun 2020 01:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443073;
        bh=dUkmD52lNqPmRdAMdoB/PrJJyegJXyeJhm0rTeXELTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0y4WQSXAmKZhV+1XmeQ9LhGIKnOEco2RCDYorCOuZ2Lsc1j3GNx384LEyFKORQq6
         Tf4ob10J56GDDOflkyXJEUuwff/7myk0eV4IgIPRRrxpiuNYGXRLbMU5SlBOrhKn5G
         IpfAHdYBBzP5tGYP1Kl5/sGWrgFcJLKFEqKghMRo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 061/266] IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command
Date:   Wed, 17 Jun 2020 21:13:06 -0400
Message-Id: <20200618011631.604574-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit d246a3061528be6d852156d25c02ea69d6db7e65 ]

The commit citied in the Fixes line wasn't complete and solved
only part of the problems. Update the mlx5_ib to properly support
MLX5_CMD_OP_INIT2INIT_QP command in the DEVX, that is required when
modify the QP tx_port_affinity.

Fixes: 819f7427bafd ("RDMA/mlx5: Add init2init as a modify command")
Link: https://lore.kernel.org/r/20200527135703.482501-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index bba7ab078430..fd75a9043bf1 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -489,6 +489,10 @@ static u64 devx_get_obj_id(const void *in)
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
2.25.1


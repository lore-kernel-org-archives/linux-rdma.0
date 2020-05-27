Return-Path: <SRS0=0PZL=7J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B691C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02BBD208DB
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590587690;
	bh=FyAdW0ohZnFSSXe9LwmyBjMecXhVAIkAGpdrJlmOAfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RdSSsW7fY8R1UXAlrRklZk8G9kwIQFy/d6LzrwYbld1gEkSK7xQW26KGhle5EnBDo
	 Bc6D6KRb6i8Oypb3RtT4qWoz6ks5kOhp3361LtS9vudFC0ro1zpx1SAu9Ywgu7myig
	 zQ8cggU+BHi7XctdPibsz5NPQPZQun7OIJr2KoTU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388891AbgE0Nyt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 27 May 2020 09:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388887AbgE0Nys (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 27 May 2020 09:54:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A64F9207D8;
        Wed, 27 May 2020 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587688;
        bh=FyAdW0ohZnFSSXe9LwmyBjMecXhVAIkAGpdrJlmOAfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYb8eatddenXHTx1WJT4aRddXIITT2RJAXgPy3j6cBQeQEz96obRqTkqz10m6bajQ
         GhxqQ9MBXc012h65mTkG9dRSvmFG1WRbtTQK+mYRTDiQ8/PaQZCpvTXYGMZnBkBSbR
         rCFJgLiOfdti7ygEjfIA9+WevTslAWH0VS0WVK8w=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v1 10/11] RDMA/mlx5: Add support to get CQ resource in RAW format
Date:   Wed, 27 May 2020 16:54:07 +0300
Message-Id: <20200527135408.480878-11-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527135408.480878-1-leon@kernel.org>
References: <20200527135408.480878-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add support to get CQ resource dump in RAW format.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c     |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  2 ++
 drivers/infiniband/hw/mlx5/restrack.c | 10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d81cb7139e98..6094ab2f4cd7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6610,6 +6610,7 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
 	.enable_driver = mlx5_ib_enable_driver,
 	.fill_res_mr_entry = mlx5_ib_fill_res_mr_entry,
 	.fill_res_qp_entry = mlx5_ib_fill_res_qp_entry,
+	.fill_res_cq_entry = mlx5_ib_fill_res_cq_entry,
 	.fill_stat_mr_entry = mlx5_ib_fill_stat_mr_entry,
 	.get_dev_fw_str = get_dev_fw_str,
 	.get_dma_mr = mlx5_ib_get_dma_mr,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8959db266a35..b486139b08ce 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1387,6 +1387,8 @@ int mlx5_ib_fill_res_mr_entry(struct sk_buff *msg, struct ib_mr *ib_mr,
 			      bool raw);
 int mlx5_ib_fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp,
 			      bool raw);
+int mlx5_ib_fill_res_cq_entry(struct sk_buff *msg, struct ib_cq *ibcq,
+			      bool raw);
 int mlx5_ib_fill_stat_mr_entry(struct sk_buff *msg, struct ib_mr *ib_mr);
 
 extern const struct uapi_definition mlx5_ib_devx_defs[];
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index cf2322109f88..9e1389b8dd9f 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -141,6 +141,16 @@ int mlx5_ib_fill_res_mr_entry(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+int mlx5_ib_fill_res_cq_entry(struct sk_buff *msg, struct ib_cq *ibcq, bool raw)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibcq->device);
+	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+
+	if (!raw)
+		return 0;
+	return fill_res_raw(msg, dev, MLX5_SGMT_TYPE_PRM_QUERY_CQ, cq->mcq.cqn);
+}
+
 int mlx5_ib_fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp, bool raw)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
-- 
2.26.2


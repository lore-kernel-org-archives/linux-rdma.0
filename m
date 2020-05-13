Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8573EC2D0F9
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 09:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F0B206D6
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 09:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589363495;
	bh=DAYTr3BfLUARGlQAx9SRIs9R5Eow3CW2dZD7oo/k+Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gh6Xuv47Q+OOkfdLeUZH8KPu4MaBGj4PNQWNWBFzfXCjcldL1qTWklxIjW5L1ctn+
	 yDpudQaW00Zg+ASYs0RI1hpzYePBGFtPVGYIqFXyruhf12aOzmdaqf9m0FuAsGchBo
	 R4+0W6gtw8nWEc/UQoIdZkGXYorSO/Dlk2tDjtiw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733031AbgEMJve (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 05:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732694AbgEMJvc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 05:51:32 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B911206D6;
        Wed, 13 May 2020 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363491;
        bh=DAYTr3BfLUARGlQAx9SRIs9R5Eow3CW2dZD7oo/k+Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlHe8p/rWrFczJQm5hEhk/DXGwo9A6tcKlYwu4uE2TY9ONcd+S2RMR+MjaghbGU5F
         px0qKgWVUrOuJhA6WeoLoIxniqu5EsQLS+CbLAQXE9eyE2+61D6MECVB5TJAn5Y1e3
         nDwMO0PDvZqv9tpOJgS3fhYtXVFq3spztopjP9mk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 13/14] RDMA/mlx5: Add support to get CQ resource in RAW format
Date:   Wed, 13 May 2020 12:50:33 +0300
Message-Id: <20200513095034.208385-14-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513095034.208385-1-leon@kernel.org>
References: <20200513095034.208385-1-leon@kernel.org>
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
index ba298a8e3ce1..a707576a8337 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6616,6 +6616,7 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
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


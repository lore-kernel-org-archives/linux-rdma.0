Return-Path: <SRS0=rh+6=6L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A1DC54FCB
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A4D20661
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588002433;
	bh=5CpcU3FvoSSn4CMAKtN0z3SPGSzoDz5mIHYGprHoH/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n51J9UGs42YhZx86TjPoy38ektCDeomwHAWMfzgDixgogfWTX3wBUBmFuXBl5RJLl
	 fL+0ZiUMNkJyXO6QQlm3gWYw9T4Hqsh5IHMUDMYqi/ui7/HSFROK96ffvI4MOXbftX
	 kuvQ3oD3znh8ZDYVtImaLtAamx4Kk9z3dMs9AiuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD0PrN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgD0PrM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Apr 2020 11:47:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 965FD2064C;
        Mon, 27 Apr 2020 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588002432;
        bh=5CpcU3FvoSSn4CMAKtN0z3SPGSzoDz5mIHYGprHoH/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+UDOqfogWl4BBDU5WS1MQUxX0YolXCrIjkdH8wpmgleJ6fe0beMoIFSGUDyDMQSX
         Fvura8fh1ZujxaFBnmfgRN7xfKgWuBnUEAdvSC4mT9b484m8CzGHYtFNacgijGPPiL
         INAaI6BDhuhBEfhrW07oUeu55nsh37Onn+VAcmeQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 09/36] RDMA/mlx5: Update all DRIVER QP places to use QP subtype
Date:   Mon, 27 Apr 2020 18:46:09 +0300
Message-Id: <20200427154636.381474-10-leon@kernel.org>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200427154636.381474-1-leon@kernel.org>
References: <20200427154636.381474-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Instead of overwriting QP init attributes with driver QP subtype,
use that subtype directly. This change will allow us to remove
logic which cached QP init attributes.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 48 +++++++++++----------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d0e8d27305e9..0b2090bcb8e8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1232,7 +1232,7 @@ static void destroy_qp_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 static u32 get_rx_type(struct mlx5_ib_qp *qp, struct ib_qp_init_attr *attr)
 {
 	if (attr->srq || (attr->qp_type == IB_QPT_XRC_TGT) ||
-	    (attr->qp_type == MLX5_IB_QPT_DCI) ||
+	    (qp->qp_sub_type == MLX5_IB_QPT_DCI) ||
 	    (attr->qp_type == IB_QPT_XRC_INI))
 		return MLX5_SRQ_RQ;
 	else if (!qp->has_rq)
@@ -1241,15 +1241,6 @@ static u32 get_rx_type(struct mlx5_ib_qp *qp, struct ib_qp_init_attr *attr)
 		return MLX5_NON_ZERO_RQ;
 }
 
-static int is_connected(enum ib_qp_type qp_type)
-{
-	if (qp_type == IB_QPT_RC || qp_type == IB_QPT_UC ||
-	    qp_type == MLX5_IB_QPT_DCI)
-		return 1;
-
-	return 0;
-}
-
 static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_qp *qp,
 				    struct mlx5_ib_sq *sq, u32 tdn,
@@ -1897,33 +1888,14 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return err;
 }
 
-static void configure_responder_scat_cqe(struct ib_qp_init_attr *init_attr,
-					 void *qpc)
-{
-	int rcqe_sz;
-
-	if (init_attr->qp_type == MLX5_IB_QPT_DCI)
-		return;
-
-	rcqe_sz = mlx5_ib_get_cqe_size(init_attr->recv_cq);
-
-	MLX5_SET(qpc, qpc, cs_res,
-		 rcqe_sz == 128 ? MLX5_RES_SCAT_DATA64_CQE :
-				  MLX5_RES_SCAT_DATA32_CQE);
-}
-
 static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
 					 struct ib_qp_init_attr *init_attr,
 					 struct mlx5_ib_create_qp *ucmd,
 					 void *qpc)
 {
-	enum ib_qp_type qpt = init_attr->qp_type;
 	int scqe_sz;
 	bool allow_scat_cqe = false;
 
-	if (qpt == IB_QPT_UC || qpt == IB_QPT_UD)
-		return;
-
 	if (ucmd)
 		allow_scat_cqe = ucmd->flags & MLX5_QP_FLAG_ALLOW_SCATTER_CQE;
 
@@ -2018,7 +1990,9 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
-	mlx5_st = to_mlx5_st(init_attr->qp_type);
+	mlx5_st = to_mlx5_st((init_attr->qp_type != IB_QPT_DRIVER) ?
+				     init_attr->qp_type :
+				     qp->qp_sub_type);
 	if (mlx5_st < 0)
 		return -EINVAL;
 
@@ -2240,12 +2214,20 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
 	if (qp->flags & MLX5_IB_QP_PACKET_BASED_CREDIT)
 		MLX5_SET(qpc, qpc, req_e2e_credit_mode, 1);
-	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
-		configure_responder_scat_cqe(init_attr, qpc);
+	if (qp->scat_cqe && (init_attr->qp_type == IB_QPT_RC ||
+			     init_attr->qp_type == IB_QPT_UC)) {
+		int rcqe_sz = rcqe_sz =
+			mlx5_ib_get_cqe_size(init_attr->recv_cq);
+
+		MLX5_SET(qpc, qpc, cs_res,
+			 rcqe_sz == 128 ? MLX5_RES_SCAT_DATA64_CQE :
+					  MLX5_RES_SCAT_DATA32_CQE);
+	}
+	if (qp->scat_cqe && (qp->qp_sub_type == MLX5_IB_QPT_DCI ||
+			     init_attr->qp_type == IB_QPT_RC))
 		configure_requester_scat_cqe(dev, init_attr,
 					     udata ? &ucmd : NULL,
 					     qpc);
-	}
 
 	if (qp->rq.wqe_cnt) {
 		MLX5_SET(qpc, qpc, log_rq_stride, qp->rq.wqe_shift - 4);
-- 
2.25.3


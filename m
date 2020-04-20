Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D276C3815B
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 15:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9FB20B1F
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587395571;
	bh=ETHzXxY0YSgcgv1D/1mKZvYLsFUCsIPeTwIaIY08Qiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2P/GIUu9hTWpCNDWqPD4+ZtrMm6iRd7Uchzq2Ele4OCr4qOeco5PrpopCaiA/hGdU
	 WKqbo5raDk0/XjlndedoutboOb2MCRnG2muyghjYOkP8HxUKEcRJtB7DJ77xZZyYwt
	 vYBvhKKDJcsmTdbPfwjJua8aqC7/OFCUyHgpLOlM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgDTPMt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 11:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbgDTPMK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Apr 2020 11:12:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444B92074F;
        Mon, 20 Apr 2020 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587395530;
        bh=ETHzXxY0YSgcgv1D/1mKZvYLsFUCsIPeTwIaIY08Qiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPh1EUAnTEfncTANU83/JrjKTCgh/IG73dTZp2ydum7ukIXBkCnH+TJCjBEk+pvFw
         cwMM51JTeSs14Cut3sj4Ur8IYiVwQbKX2RT4vwcpZMjAeznHdd7NKub07tssMTAuTW
         x+RglF4hYMiv3rvXP8I/6QgLGQJ0QkZpMkGi3niI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next 17/18] RDMA/mlx5: Return all configured create flags through query QP
Date:   Mon, 20 Apr 2020 18:11:04 +0300
Message-Id: <20200420151105.282848-18-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420151105.282848-1-leon@kernel.org>
References: <20200420151105.282848-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The "flags" field in struct mlx5_ib_qp contains all UAPI flags
configured at the create QP stage. Return all the data as is
without masking.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 13 +------------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9451aa836df0..cb2331b03f7b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -443,6 +443,7 @@ struct mlx5_ib_qp {
 	/* serialize qp state modifications
 	 */
 	struct mutex		mutex;
+	/* cached variant of create_flags from struct ib_qp_init_attr */
 	u32			flags;
 	u8			port;
 	u8			state;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8facbaa0ce5a..15c476e858c5 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5931,18 +5931,7 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	qp_init_attr->cap	     = qp_attr->cap;
 
-	qp_init_attr->create_flags = 0;
-	if (qp->flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
-		qp_init_attr->create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
-
-	if (qp->flags & IB_QP_CREATE_CROSS_CHANNEL)
-		qp_init_attr->create_flags |= IB_QP_CREATE_CROSS_CHANNEL;
-	if (qp->flags & IB_QP_CREATE_MANAGED_SEND)
-		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_SEND;
-	if (qp->flags & IB_QP_CREATE_MANAGED_RECV)
-		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_RECV;
-	if (qp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)
-		qp_init_attr->create_flags |= MLX5_IB_QP_CREATE_SQPN_QP1;
+	qp_init_attr->create_flags = qp->flags;
 
 	qp_init_attr->sq_sig_type = qp->sq_signal_bits & MLX5_WQE_CTRL_CQ_UPDATE ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
-- 
2.25.2


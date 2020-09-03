Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E263C433E7
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C357F207EA
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599118755;
	bh=SXjVopkYWbshhy89eMx2Y6de7yh58BuDF7mZcj1MSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L6cFLGGjy2fRusCxroXwSv/IzUofkXrA8aGJFMThA2Y8RJXoMKhSRp/zgUB6iXyEY
	 nd0u0lamjLzSfb0zfHhQbf5SlHmB4gMajhAbrzDIZWdrYlvthrFzAwQ3u+CFJaP70u
	 b3+6kYUQ5MAm6j4pmEB/RwB7qTua0SnGSr7kZP5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgICHjP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgICHjO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 03:39:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4108120775;
        Thu,  3 Sep 2020 07:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599118754;
        bh=SXjVopkYWbshhy89eMx2Y6de7yh58BuDF7mZcj1MSMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdCwTM1MC5RmvbpNn79UtXMbeaubfBTocSG2DEsgSnxIExnRyQ7TrLCBeePu4vJe+
         EVw/i3wOkFuhUKUrGlCYedYze1/K7m1o+gRAlQrI5ieFODhjCTMDfCigpZcth/nkGE
         krWSCek8NYHFMLrTCWbVEU2GJBaD8EGqVvtot4BE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Vesker <valex@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Expose TIR and QP ICM address for sw_owner_v2 devices
Date:   Thu,  3 Sep 2020 10:38:57 +0300
Message-Id: <20200903073857.1129166-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903073857.1129166-1-leon@kernel.org>
References: <20200903073857.1129166-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

Expose the ICM address to access TIR and QP, this will allow sw_owned_v2
devices to steer traffic to TIRs and QPs same as done with sw_owner
capability.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 22280ea92006..ada852fcc427 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1477,7 +1477,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_RQN;
 			resp->tirn = rq->tirn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
-			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner)) {
+			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
+			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2)) {
 				resp->tir_icm_addr = MLX5_GET(
 					create_tir_out, out, icm_address_31_0);
 				resp->tir_icm_addr |=
@@ -1739,7 +1740,8 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (mucontext->devx_uid) {
 		params->resp.comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
 		params->resp.tirn = qp->rss_qp.tirn;
-		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner)) {
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
+		    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2)) {
 			params->resp.tir_icm_addr =
 				MLX5_GET(create_tir_out, out, icm_address_31_0);
 			params->resp.tir_icm_addr |=
-- 
2.26.2


Return-Path: <SRS0=H9Qn=ZH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F59C432C3
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 15:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B61532073B
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573832760;
	bh=Jo2Wa8YPHoHTaGCVenDywrIiaE5hkQsIkZyYVsb34YQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=buuMWz5wlBa5nDiG7ay0m7Nr8LHRoWSUxGkVCcH0JUrguUE2FlgtYwq1vumGz5IuB
	 JB0ubeG606JLPP9o+63wb/kDWDYfTZmTEP4jCnOH7BBaVKCSzLrUM1NHeS/KshYxDr
	 tgjG8JS6Qk6F4TxmmsI/1yKIjNkH0MMfZFAPaJZk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKOPqA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Nov 2019 10:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfKOPqA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 Nov 2019 10:46:00 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7382072D;
        Fri, 15 Nov 2019 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573832758;
        bh=Jo2Wa8YPHoHTaGCVenDywrIiaE5hkQsIkZyYVsb34YQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dacRVvMqw4m8E1ebSJbwy7SexYTu6hmx8dab7Ahcc6vPwht+onfoksZr54Tn/N+eT
         C6JLKAkuXzuDWh9jGvmqfy7q2Kr10hr57/wTaP2rIx9NHxA2eRyQn8rCnv+rEw4Eqc
         EwKqeu7wDjl06C4bwcrWo9RRnsPziLdCe4H6+j48=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH rdma-next] IB/mlx5: Support extended number of strides for Striding RQ
Date:   Fri, 15 Nov 2019 17:45:55 +0200
Message-Id: <20191115154555.247856-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Extends the minimum single WQE strides from 64 to 8, which is exposed
by the "min_single_wqe_log_num_of_strides" field of striding_rq_caps.
Choose right number of strides based on FW capability.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 10 +++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 44 +++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 43f9013ea26c..2d83f8c1d7ba 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1149,8 +1149,14 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES;
 			resp.striding_rq_caps.max_single_stride_log_num_of_bytes =
 				MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES;
-			resp.striding_rq_caps.min_single_wqe_log_num_of_strides =
-				MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES;
+			if (MLX5_CAP_GEN(dev->mdev, ext_stride_num_range))
+				resp.striding_rq_caps
+					.min_single_wqe_log_num_of_strides =
+					MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES;
+			else
+				resp.striding_rq_caps
+					.min_single_wqe_log_num_of_strides =
+					MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES;
 			resp.striding_rq_caps.max_single_wqe_log_num_of_strides =
 				MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES;
 			resp.striding_rq_caps.supported_qpts =
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 21660d3ad6fb..00fd412ef686 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -291,6 +291,7 @@ enum mlx5_ib_wq_flags {
 #define MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES 16
 #define MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES 6
 #define MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES 13
+#define MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES 3
 
 struct mlx5_ib_rwq {
 	struct ib_wq		ibwq;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 26fb0227a514..82814c6d15a3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5957,12 +5957,21 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	}
 	MLX5_SET(wq, wq, log_wq_stride, rwq->log_rq_stride);
 	if (rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ) {
+		/*
+		 * In Firmware number of strides in each WQE is:
+		 *   "512 * 2^single_wqe_log_num_of_strides"
+		 * Values 3 to 8 are accepted as 10 to 15, 9 to 18 are
+		 * accepted as 0 to 9
+		 */
+		static const u8 fw_map[] = { 10, 11, 12, 13, 14, 15, 0, 1,
+					     2,  3,  4,  5,  6,  7,  8, 9 };
 		MLX5_SET(wq, wq, two_byte_shift_en, rwq->two_byte_shift_en);
 		MLX5_SET(wq, wq, log_wqe_stride_size,
 			 rwq->single_stride_log_num_of_bytes -
 			 MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES);
-		MLX5_SET(wq, wq, log_wqe_num_of_strides, rwq->log_num_strides -
-			 MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES);
+		MLX5_SET(wq, wq, log_wqe_num_of_strides,
+			 fw_map[rwq->log_num_strides -
+				MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES]);
 	}
 	MLX5_SET(wq, wq, log_wq_sz, rwq->log_rq_size);
 	MLX5_SET(wq, wq, pd, to_mpd(pd)->pdn);
@@ -6037,6 +6046,19 @@ static int set_user_rq_size(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
+static bool log_of_strides_valid(struct mlx5_ib_dev *dev, u32 log_num_strides)
+{
+	if ((log_num_strides > MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES) ||
+	    (log_num_strides < MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES))
+		return false;
+
+	if (!MLX5_CAP_GEN(dev->mdev, ext_stride_num_range) &&
+	    (log_num_strides < MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES))
+		return false;
+
+	return true;
+}
+
 static int prepare_user_rq(struct ib_pd *pd,
 			   struct ib_wq_init_attr *init_attr,
 			   struct ib_udata *udata,
@@ -6084,14 +6106,16 @@ static int prepare_user_rq(struct ib_pd *pd,
 				    MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES);
 			return -EINVAL;
 		}
-		if ((ucmd.single_wqe_log_num_of_strides >
-		    MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES) ||
-		     (ucmd.single_wqe_log_num_of_strides <
-			MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES)) {
-			mlx5_ib_dbg(dev, "Invalid log num strides (%u. Range is %u - %u)\n",
-				    ucmd.single_wqe_log_num_of_strides,
-				    MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES,
-				    MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES);
+		if (!log_of_strides_valid(dev,
+					  ucmd.single_wqe_log_num_of_strides)) {
+			mlx5_ib_dbg(
+				dev,
+				"Invalid log num strides (%u. Range is %u - %u)\n",
+				ucmd.single_wqe_log_num_of_strides,
+				MLX5_CAP_GEN(dev->mdev, ext_stride_num_range) ?
+					MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES :
+					MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES,
+				MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES);
 			return -EINVAL;
 		}
 		rwq->single_stride_log_num_of_bytes =
-- 
2.20.1


Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE90C8300F
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Dec 2020 20:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910A7205F4
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Dec 2020 20:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389361AbgLBUoH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Dec 2020 15:44:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:58903 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389339AbgLBUoG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Dec 2020 15:44:06 -0500
IronPort-SDR: hsjY+zKL5t+cbOfPFRoQMkENZnCpser6SOnTeUuJFQt0HNXSQ5p+xkOWnbOSKju3bLxnyOv8qu
 V4M22vccfwIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="169579862"
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="169579862"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 12:43:25 -0800
IronPort-SDR: UjT5b2FMDNXBfigzdO6Yv2mcmiYJGRFrHwalsjVJPaHBpEfLHI5eF7eRY/Ty3z/yZY2iMxeEpl
 U6OMDUP+OHgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="365457423"
Received: from cst-dev.jf.intel.com ([10.23.221.69])
  by fmsmga004.fm.intel.com with ESMTP; 02 Dec 2020 12:43:24 -0800
From:   Jianxin Xiong <jianxin.xiong@intel.com>
To:     linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Jianxin Xiong <jianxin.xiong@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Koenig <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-core v4 3/6] mlx5: Support dma-buf based memory region
Date:   Wed,  2 Dec 2020 12:57:18 -0800
Message-Id: <1606942641-47234-4-git-send-email-jianxin.xiong@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606942641-47234-1-git-send-email-jianxin.xiong@intel.com>
References: <1606942641-47234-1-git-send-email-jianxin.xiong@intel.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Implement the new provider method for registering dma-buf based memory
regions.

Signed-off-by: Jianxin Xiong <jianxin.xiong@intel.com>
---
 providers/mlx5/mlx5.c  |  2 ++
 providers/mlx5/mlx5.h  |  3 +++
 providers/mlx5/verbs.c | 22 ++++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 1378acf..b3e2d57 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Mellanox Technologies, Inc.  All rights reserved.
+ * Copyright (c) 2020 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -96,6 +97,7 @@ static const struct verbs_context_ops mlx5_ctx_common_ops = {
 	.async_event   = mlx5_async_event,
 	.dealloc_pd    = mlx5_free_pd,
 	.reg_mr	       = mlx5_reg_mr,
+	.reg_dmabuf_mr = mlx5_reg_dmabuf_mr,
 	.rereg_mr      = mlx5_rereg_mr,
 	.dereg_mr      = mlx5_dereg_mr,
 	.alloc_mw      = mlx5_alloc_mw,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 8c94f72..17a2470 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Mellanox Technologies, Inc.  All rights reserved.
+ * Copyright (c) 2020 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -903,6 +904,8 @@ void mlx5_async_event(struct ibv_context *context,
 struct ibv_mr *mlx5_alloc_null_mr(struct ibv_pd *pd);
 struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 			   uint64_t hca_va, int access);
+struct ibv_mr *mlx5_reg_dmabuf_mr(struct ibv_pd *pd, uint64_t offset, size_t length,
+				  uint64_t iova, int fd, int access);
 int mlx5_rereg_mr(struct verbs_mr *mr, int flags, struct ibv_pd *pd, void *addr,
 		  size_t length, int access);
 int mlx5_dereg_mr(struct verbs_mr *mr);
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index b956156..a7fc3b0 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Mellanox Technologies, Inc.  All rights reserved.
+ * Copyright (c) 2020 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -647,6 +648,27 @@ struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	return &mr->vmr.ibv_mr;
 }
 
+struct ibv_mr *mlx5_reg_dmabuf_mr(struct ibv_pd *pd, uint64_t offset, size_t length,
+				  uint64_t iova, int fd, int acc)
+{
+	struct mlx5_mr *mr;
+	int ret;
+
+	mr = calloc(1, sizeof(*mr));
+	if (!mr)
+		return NULL;
+
+	ret = ibv_cmd_reg_dmabuf_mr(pd, offset, length, iova, fd, acc,
+				    &mr->vmr);
+	if (ret) {
+		free(mr);
+		return NULL;
+	}
+	mr->alloc_flags = acc;
+
+	return &mr->vmr.ibv_mr;
+}
+
 struct ibv_mr *mlx5_alloc_null_mr(struct ibv_pd *pd)
 {
 	struct mlx5_mr *mr;
-- 
1.8.3.1


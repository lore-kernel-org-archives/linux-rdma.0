Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDEEC07E9B
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 09:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37D86109F
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 09:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhGUIlU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Jul 2021 04:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235879AbhGUI0n (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 21 Jul 2021 04:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F65D611C1;
        Wed, 21 Jul 2021 09:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626858440;
        bh=5J+jBturQ/bt30k9Ss/DG7LeflH8jrxgH/e5dbAPOps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZ9nYGvpwOJ2oDLwJnfIOgxsPQ8VF2qR0P6+/QYZVFEdOFtXUEbyglw9e9/nNRlva
         Qbyf0Qk4Q2yMuTMCj52LQ9F9+Loou5kCxsNKWDoNPwE2BJSU7y5p/cdlYsyOTUdRwM
         kkm/CGTBidL4ZbNSBPZ5H5IIBtKpTyEYMxiNM+s1eYaU4jntupnBG4qglD3/y+3jco
         u64orbNdhIbs653x8dJzLARhQ6R7Gyd90pQ28p0pxJBs/oKgwRLixCSv+OdIHMoEA9
         F/lr8rHhzv1CqeKA1to0I7QmytF6uGpzmhtNG7psTSaC4ba+3aU5+GNKN7laBfmToZ
         dCzsD7iQCfpZg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH rdma-next v1 1/7] RDMA/mlx5: Delete not-available udata check
Date:   Wed, 21 Jul 2021 12:07:04 +0300
Message-Id: <b93cef10d53cb2c5508cfabdff3d9c43686175ff.1626857976.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1626857976.git.leonro@nvidia.com>
References: <cover.1626857976.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

XRC_TGT QPs are created through kernel verbs and don't have udata at all.

Fixes: 6eefa839c4dd ("RDMA/mlx5: Protect from kernel crash if XRC_TGT doesn't have udata")
Fixes: e383085c2425 ("RDMA/mlx5: Set ECE options during QP create")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 18b018f1db83..81e3170a1ae6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1908,7 +1908,6 @@ static int get_atomic_mode(struct mlx5_ib_dev *dev,
 static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			     struct mlx5_create_qp_params *params)
 {
-	struct mlx5_ib_create_qp *ucmd = params->ucmd;
 	struct ib_qp_init_attr *attr = params->attr;
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
@@ -1928,8 +1927,6 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!in)
 		return -ENOMEM;
 
-	if (MLX5_CAP_GEN(mdev, ece_support) && ucmd)
-		MLX5_SET(create_qp_in, in, ece, ucmd->ece_options);
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_XRC);
-- 
2.31.1


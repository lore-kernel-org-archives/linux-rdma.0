Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20544C54FCF
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 11:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E490121473
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587382994;
	bh=dORNRzQIGKKTXgUjmn0WjUDUejNiPh8ZCsxPY5NZQIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2hXjmdjgmkySCUB1JyE4wSVVhsWIEaE5+ii4ee6eII0hzFtSnK5kMFUtSYC1OysiH
	 WjE1zzmlE+Thw+tggVE69oNArFNfucH8pk23k16QNK/CVJPYi63byZF0hfPCJjAl6b
	 U+hpfM7ie9e7efcJERdAJtadZ9+8RWl3hSRDgNzs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgDTLnL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 07:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgDTLnL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Apr 2020 07:43:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 548622224F;
        Mon, 20 Apr 2020 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382991;
        bh=dORNRzQIGKKTXgUjmn0WjUDUejNiPh8ZCsxPY5NZQIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9qrfzyTCJ+m6CrBd58bbMe0zCHadf6/bGcogSf+ivYRy881JwLQC8Dgzb8C3FiDP
         2b6a7YjvOUDjP3Ryv+rNUOFNr9xMcP4dWK1mRIuFDNbgj6vCkfhdVMZxPaxObeCFym
         M+FeFrRSFrPHiOQq6ZGqdJo9cC3inTce9n42yvn4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 20/24] net/mlx5: Update uar.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:32 +0300
Message-Id: <20200420114136.264924-21-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of uar.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/uar.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 816f9c434359..da481a7c12f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -38,12 +38,12 @@
 
 int mlx5_cmd_alloc_uar(struct mlx5_core_dev *dev, u32 *uarn)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_uar_in, in, opcode, MLX5_CMD_OP_ALLOC_UAR);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, alloc_uar, in, out);
 	if (!err)
 		*uarn = MLX5_GET(alloc_uar_out, out, uar);
 	return err;
@@ -52,12 +52,11 @@ EXPORT_SYMBOL(mlx5_cmd_alloc_uar);
 
 int mlx5_cmd_free_uar(struct mlx5_core_dev *dev, u32 uarn)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_uar_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(dealloc_uar_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_uar_in)] = {};
 
 	MLX5_SET(dealloc_uar_in, in, opcode, MLX5_CMD_OP_DEALLOC_UAR);
 	MLX5_SET(dealloc_uar_in, in, uar, uarn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, dealloc_uar, in);
 }
 EXPORT_SYMBOL(mlx5_cmd_free_uar);
 
-- 
2.25.2


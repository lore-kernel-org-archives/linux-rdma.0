Return-Path: <SRS0=0PZL=7J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA8BC433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C553B207D8
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590587663;
	bh=BbKj/hAo8dcJrmgK/HQEO3BCEI5Pim0NsUGOFehoCmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=K73ok3Ik+7vPatZaNfdeWZwvaki8nmOmrjlqloy+ZIjKLkO/2bfXKZnBDWmA9JKNe
	 RT2WyTytxSw/id5iGtNg2+frLKI1hUu1StxNcpWSHpn2v7YMXrxLnTvC12/JkhtxsN
	 AC0bawPSJk4SIgURqejWtLT35alJYSLd5oNpcfn8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgE0NyX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 27 May 2020 09:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388401AbgE0NyW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 27 May 2020 09:54:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B3B2078C;
        Wed, 27 May 2020 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587662;
        bh=BbKj/hAo8dcJrmgK/HQEO3BCEI5Pim0NsUGOFehoCmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgPcWuWX4s/iQ9B/sEPFJfNaGQsyriuJRcpIL7coHfFE1b6koDJ6YxFGeTB8kRNFe
         usbXDNNPNC2PuqKS3kg8BqqsHfr+3YB0lVIWmXzbDY6hrnY3g9FegNtCDG6Z0no/Ff
         zBUV3LGp5jkrLbytnLmyXI0pTDIGFBnYzp3C2FmU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v1 02/11] net/mlx5: Add support in query QP, CQ and MKEY segments
Date:   Wed, 27 May 2020 16:53:59 +0300
Message-Id: <20200527135408.480878-3-leon@kernel.org>
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

Introduce new resource dump segments - PRM_QUERY_QP,
PRM_QUERY_CQ and PRM_QUERY_MKEY. These segments contains the resource
dump in PRM query format.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c | 3 +++
 include/linux/mlx5/rsc_dump.h                           | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 10218c2324cc..4924a5658853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -23,6 +23,9 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 	MLX5_SGMT_STR_ASSING(SX_SLICE_ALL),
 	MLX5_SGMT_STR_ASSING(RDB),
 	MLX5_SGMT_STR_ASSING(RX_SLICE_ALL),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_QP),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_CQ),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_MKEY),
 };
 
 struct mlx5_rsc_dump {
diff --git a/include/linux/mlx5/rsc_dump.h b/include/linux/mlx5/rsc_dump.h
index 87415fa754fe..d11c0b228620 100644
--- a/include/linux/mlx5/rsc_dump.h
+++ b/include/linux/mlx5/rsc_dump.h
@@ -23,6 +23,9 @@ enum mlx5_sgmt_type {
 	MLX5_SGMT_TYPE_SX_SLICE_ALL,
 	MLX5_SGMT_TYPE_RDB,
 	MLX5_SGMT_TYPE_RX_SLICE_ALL,
+	MLX5_SGMT_TYPE_PRM_QUERY_QP,
+	MLX5_SGMT_TYPE_PRM_QUERY_CQ,
+	MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
 	MLX5_SGMT_TYPE_MENU,
 	MLX5_SGMT_TYPE_TERMINATE,
 
-- 
2.26.2


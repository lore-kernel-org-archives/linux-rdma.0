Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87669C4708F
	for <linux-rdma@archiver.kernel.org>; Mon, 31 May 2021 08:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6232C6108D
	for <linux-rdma@archiver.kernel.org>; Mon, 31 May 2021 08:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhEaIyH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 31 May 2021 04:54:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6092 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhEaIyD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 31 May 2021 04:54:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtprM6J6nzYp4s;
        Mon, 31 May 2021 16:49:39 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 16:52:22 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 16:52:22 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] net/mlx5e: Remove the repeated declaration
Date:   Mon, 31 May 2021 16:52:10 +0800
Message-ID: <1622451130-58224-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Function 'mlx5e_deactivate_rq' is declared twice, so remove the
repeated declaration.

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b636d63358d2..d966d5f40e78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -974,7 +974,6 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 		  struct mlx5e_xsk_param *xsk, int node,
 		  struct mlx5e_rq *rq);
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
-void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
 int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
 void mlx5e_destroy_rq(struct mlx5e_rq *rq);
-- 
2.7.4


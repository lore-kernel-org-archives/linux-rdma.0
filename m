Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6519BC4332F
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Nov 2022 13:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiKHNE5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Nov 2022 08:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiKHNEr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Nov 2022 08:04:47 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD1C6159;
        Tue,  8 Nov 2022 05:04:46 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N67bj20h7z15MPN;
        Tue,  8 Nov 2022 21:04:33 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 21:04:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lkayal@nvidia.com>, <tariqt@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
Date:   Tue, 8 Nov 2022 21:04:11 +0800
Message-ID: <20221108130411.6932-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

'accel_tcp' is allocated by kzalloc(), which should freed by kvfree().

Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 285d32d2fd08..7843c60d5b99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 err_destroy_tables:
 	while (--i >= 0)
 		accel_fs_tcp_destroy_table(fs, i);
-	kfree(accel_tcp);
+	kvfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 	return err;
 }
-- 
2.17.1


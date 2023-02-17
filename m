Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D705C61DA4
	for <linux-rdma@archiver.kernel.org>; Fri, 17 Feb 2023 03:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBQDNs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Feb 2023 22:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQDNr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 16 Feb 2023 22:13:47 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4BF54D18;
        Thu, 16 Feb 2023 19:13:44 -0800 (PST)
Received: from dggpemm100007.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PHxfc15b9z16Nkw;
        Fri, 17 Feb 2023 11:11:20 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm100007.china.huawei.com
 (7.185.36.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.6; Fri, 17 Feb
 2023 11:13:42 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <roid@nvidia.com>, <ozsh@nvidia.com>, <yangyingliang@huawei.com>,
        <liwei391@huawei.com>
Subject: [PATCH net-next] net/mlx5e: TC, fix return value check in mlx5e_tc_act_stats_create()
Date:   Fri, 17 Feb 2023 11:13:01 +0800
Message-ID: <20230217031301.4024714-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm100007.china.huawei.com (7.185.36.116)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

kvzalloc() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: d13674b1d14c ("net/mlx5e: TC, map tc action cookie to a hw counter")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index f71766dca660..626cb7470fa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -37,7 +37,7 @@ mlx5e_tc_act_stats_create(void)
 	int err;
 
 	handle = kvzalloc(sizeof(*handle), GFP_KERNEL);
-	if (IS_ERR(handle))
+	if (!handle)
 		return ERR_PTR(-ENOMEM);
 
 	err = rhashtable_init(&handle->ht, &act_counters_ht_params);
-- 
2.25.1


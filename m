Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F040EB64DA
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Jun 2023 02:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjF2CkU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 28 Jun 2023 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjF2CkS (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 28 Jun 2023 22:40:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E59268F;
        Wed, 28 Jun 2023 19:40:16 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qs2hn1JlRzTlXQ;
        Thu, 29 Jun 2023 10:39:21 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 29 Jun
 2023 10:40:13 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>, <lkayal@nvidia.com>,
        <tariqt@nvidia.com>, <gal@nvidia.com>, <rrameshbabu@nvidia.com>,
        <vadfed@meta.com>, <ayal@nvidia.com>, <eranbe@nvidia.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net 0/2] fix two memory leak issues for mlx5en driver
Date:   Thu, 29 Jun 2023 10:46:40 +0800
Message-ID: <20230629024642.2228767-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix two memory leak issues for mlx5en driver:
1. fix memory leak in mlx5e_fs_tt_redirect_any_create
2. fix memory leak in mlx5e_ptp_open

Zhengchao Shao (2):
  net/mlx5e: fix memory leak in mlx5e_fs_tt_redirect_any_create
  net/mlx5e: fix memory leak in mlx5e_ptp_open

 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c            | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.34.1


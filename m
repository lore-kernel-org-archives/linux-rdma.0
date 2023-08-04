Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52E9EB64DD
	for <linux-rdma@archiver.kernel.org>; Fri,  4 Aug 2023 01:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjHDBoX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Aug 2023 21:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjHDBoW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 3 Aug 2023 21:44:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301BF10D;
        Thu,  3 Aug 2023 18:44:21 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RH7lQ09WSz1KCDM;
        Fri,  4 Aug 2023 09:43:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 4 Aug
 2023 09:44:17 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH net-next v2] net/mlx5: remove many unnecessary NULL values
Date:   Fri, 4 Aug 2023 09:43:44 +0800
Message-ID: <20230804014344.1319026-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There are many pointers assigned first, which need not to be
initialized, so remove the NULL assignments.

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
v2:
- Update the commit message, Ther -> There and assignment -> assignments.
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 39c03dcbd196..e5c1012921d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -57,7 +57,7 @@ static const char * const mlx5_fpga_qp_error_strings[] = {
 };
 static struct mlx5_fpga_device *mlx5_fpga_device_alloc(void)
 {
-	struct mlx5_fpga_device *fdev = NULL;
+	struct mlx5_fpga_device *fdev;
 
 	fdev = kzalloc(sizeof(*fdev), GFP_KERNEL);
 	if (!fdev)
@@ -252,7 +252,7 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
 
 int mlx5_fpga_init(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_fpga_device *fdev = NULL;
+	struct mlx5_fpga_device *fdev;
 
 	if (!MLX5_CAP_GEN(mdev, fpga)) {
 		mlx5_core_dbg(mdev, "FPGA capability not present\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
index 4047629a876b..30564d9b00e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -40,7 +40,7 @@ struct mlx5_hv_vhca_agent {
 
 struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
 {
-	struct mlx5_hv_vhca *hv_vhca = NULL;
+	struct mlx5_hv_vhca *hv_vhca;
 
 	hv_vhca = kzalloc(sizeof(*hv_vhca), GFP_KERNEL);
 	if (!hv_vhca)
-- 
2.34.1


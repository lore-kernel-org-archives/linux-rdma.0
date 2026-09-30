Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528A34C900C;
	Wed, 30 Sep 2026 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768679; cv=fail; b=Pw/ZJA4+hBCq0Wgb3He14EJc7/83Lw/u5VWB3j+6SU4OD0lwkdOBIN4oMhE3qgJt1HThAoTNyHLkqXXjRNGAblVlZBS2Fh65uYbvqf9jI6nSXnXdmuG88s9hfRma6W6p4E/m0Tcms0x5pL9sAcPPvWwf8+qbT2gupwPtj13ty/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768679; c=relaxed/simple;
	bh=9RMgfcyDynZ8D4t1hmGUIVJEe8Zq3PDmArYJY+y6qSI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TV5th+yiqQkb+yosNt7H1tHkAqzw8nBjpm1WlvPDaVc2M//9ZzM1iyUrlIIdxcFbiNnp7k1dIzE2rrClKj4ePG9hdm0JA7IImjTwLNlQhHIriLrpnFzC7SV7M42QrKHQmQosFHRWBY3NcTzgParSDvyVB8O/bXqlYu3vTLfFrmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PHRujCyu; arc=fail smtp.client-ip=52.101.62.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PHRujCyu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxo9hYzu518c1ijkfNPBszheEftaVVyJnzrqHccLiMikguFm64Q0tKsLt7/vobDOryYdcqERuOEiM/4/RmOk+WZvrOqyB5XKBqEod5Mu6Lzy/mq+YS82ZDzdSSW9mwpWCOWS8XnUsWcX4OZtwALvCGKhzepOo8pFG33vSCnyFGda/vWbO+OpaSxzV96kXg9l7tfTdkmpuVq8qb8tRsgooY+RbKzx4N1D2w4OfgWsedhV8zsGvEHiNI0tb/NX22s41NzayHNBiOOro3cfS4O91Ud7vaSWxRGGGd9WWTONZEWfDSXYXPBAt5hggAMqSjARKOdIDphUcQlLhxxI6LQUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sj1tBwBLpd7EXHh2/Dr5BGbzkJYhIsCo3MnaicyEOiM=;
 b=V1D6c9E6hGYzPqO6kN5rqWRX7w700ByL8kuMEuXmCTKXm3+us0PLjrUKhRkXN/RlYn9MQDiY7hHgx+yo3QMNS/oH0r9lL7v8oq8/dgbYMWvzRdcCHQV2P4NzDUwVcXad8liP+AB1o6Tqj6M0S+3HlhueW0x5P3MWaJC84dRw31KYFJD43mNGo3n8WONrsDyx5F2L5RwDdYQbxc3SBeRAGMKD70I8yQSxXRH8uxmPoJg27PVDCRcaeUBOLWa2I5Zt/d+yvsBQit2igkPaSod7peM8DqdMSS8ieWlhjNMx56fnYHTThQHg81P2EGVJu6QPhmozEJm2MKqNB/Ts43Vb3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sj1tBwBLpd7EXHh2/Dr5BGbzkJYhIsCo3MnaicyEOiM=;
 b=PHRujCyuTxJW9SWLsBc+W7Vw2hpWDyWMHg+j5ygGNkuuG3Aup0h1shyzZ0nlI44EOfQ7agToWTRrTCcM22CbQnbGJ/tSbC+SQyVnydQkjv1gIr9RouHTgDvd8JVKRMPzSPdhBmMwYrPG6obxdB7Zwd2lsoguO/gcq9HEw2w1f6uYB5AJdfR6jcFYTVk0JGQkGKIh7uFboVmUD54Slk0rePNhbH7WZKSROa+5M0A1H+cRdlzW2cEHpotBazFntTlr4XiSIGYGK8X/89Hl5OJwMXaLpLEycL6R2wR4YFzJ5KPwNY4FcYW2gaW4U0s5s437kQDnOreTU7OwQDjsJuajrQ==
Received: from BN0PR08CA0017.namprd08.prod.outlook.com (2603:10b6:408:142::24)
 by DM6PR12MB4452.namprd12.prod.outlook.com (2603:10b6:5:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 11:44:04 +0000
Received: from BL6PEPF00020E61.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::74) by BN0PR08CA0017.outlook.office365.com
 (2603:10b6:408:142::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:44:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E61.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:48 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:44 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next V2 05/10] RDMA/mlx5: Move and rename data direct resource functions
Date: Wed, 30 Sep 2026 14:42:22 +0300
Message-ID: <20260930114227.139274-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930114227.139274-1-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E61:EE_|DM6PR12MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: 152d863d-b92e-477a-71d5-08df1ee820f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|376014|7416014|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oOY5ANzL/MasRT+0Mxt726AYnvgI36+oYJYkEIajaNmeE5ZLRLZp9P8+dFkgouM4i4j/7n3iM3cu9fPi0UT3zLxW26BXgwvl9xplhfO+Ipp4MleduNJkaErHh6ClmZHZfQGmcTCZiIzPBCfXigSqCqqYRqrdLXd0dYbUhLfvobI2Djp4nXhwGuYUQ9Z7Z6Rf4lxOS6FGfjtBsqxgMuxHhewbmambw4UyLdYs1AdmawNiezH7MkLgv+3Ln0Ujy0yk6BkIA6vtvL3ekZERvJbNcz1Fn5LfhQsxIMBsq9XaREw7mOJWZaS9vHIUoM7xreiNp5WN+P7AnJQZD76FsA8cZ+4yrKQm4TBmLvJvF+jWS+Lcz5khEIdvuq6OXmbXc7vFj/yBaae2KIDABLOG72k93ccoDrA6LAlxhK5aiqX0fFy82eZ9DVbSsM1g12BpSuRifgLtWXHYIqM97L4u3lPYsVqVKWmrGwuWrT163COCh/3ggBXOwY+563GYlV4As/BabmwqTXfrIhO8GgUK0+sjgzeK7a67eM/2X+48MCfRqt+PgNgH3vEFr8rTmOg1wQxNc8cL7hNBC/h9povr1+CcDieC2nX/z42jaMNjBABxkDigLWhqxm2fUaAORJUz/2F3Mi/7oJ0xpqA5RvDe2ZF6Ya9kF5LxUzuaWTAwlu6BwUKn6Bd0BLyu6nP3cL7T2OLVN+859A50s+GYCzHP6XhcwA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(376014)(7416014)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W2Fzgxy9qykh4fzEm3oQMtwKXrdDQSYRn7mDCKiZIa305RO9XaawbHpwzgE2C1G+Ds5LPPO/W10bZVn/dKtJkDIczfhI2zOaN2wo+4KPvZRaa2V/8aoXVYhBP6Tmo1F78GKh55QSzXHjsHbaalQRNaZIxDXA4W+bWgYfVXpV9ZGSbrcQXNIJGVNeerpC1x5yGCqVm4WpDyeUrE0A977cQNVaoy9HP1i9aoqJHiECkBzqTVNJfCvEV/GyAw/N5zjWJDcfmrRYueapWTWNmineWNf0ZFDJ9UdbfjRd30MUwVPNRya6YOPtKO5GoOAAlZaG3iZSCE/m10CpIh4bcyk8l60V1a3yDVqyTg1Ag2ZGm1j4OKAC8F13ZOPtvL+QGGCGr+KQYHRXZx4XJNAXuoNZqjcmAoX2Sy+uaJqd+nlyjJFzjY2XCCugJg248S672Lal
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:04.2110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 152d863d-b92e-477a-71d5-08df1ee820f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4452

From: Dragos Tatulea <dtatulea@nvidia.com>

Move the data direct resource creation/deletion and resource
struct to be self contained in the data direct file. Rename
the functions to be consistent with the rest.

While at it clear the fields on resource deletion.

This is preparation for moving the data direct code to the
mlx5_core driver. The code has no functional changes.
Keep the resource struct and function declarations in the IB-local
data_direct.h header.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 80 ++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/data_direct.h | 10 +++
 drivers/infiniband/hw/mlx5/main.c        | 87 +-----------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  8 +--
 4 files changed, 94 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index a80778f2b9b2..cc3f741b4f81 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -102,6 +102,86 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 	return 0;
 }
 
+int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	struct mlx5_core_dev *mdev = dev->mdev;
+	bool ro_supp = false;
+	void *mkc;
+	u32 mkey;
+	u32 pdn;
+	u32 *in;
+	int err;
+
+	err = mlx5_core_alloc_pd(mdev, &pdn);
+	if (err)
+		return err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	MLX5_SET(create_mkey_in, in, data_direct, 1);
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, rw, 1);
+	MLX5_SET(mkc, mkc, rr, 1);
+	MLX5_SET(mkc, mkc, a, 1);
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, length64, 1);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
+	if (err)
+		goto err_mkey;
+
+	dev->ddr.mkey = mkey;
+	dev->ddr.pdn = pdn;
+
+	/* create another mkey with RO support */
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write)) {
+		MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
+		ro_supp = true;
+	}
+
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)) {
+		MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
+		ro_supp = true;
+	}
+
+	if (ro_supp) {
+		err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
+		/* RO is defined as best effort */
+		if (!err) {
+			dev->ddr.mkey_ro = mkey;
+			dev->ddr.mkey_ro_valid = true;
+		}
+	}
+
+	kvfree(in);
+	return 0;
+
+err_mkey:
+	kvfree(in);
+err:
+	mlx5_core_dealloc_pd(mdev, pdn);
+	return err;
+}
+
+void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
+{
+	if (dev->ddr.mkey_ro_valid)
+		mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey_ro);
+
+	mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey);
+	mlx5_core_dealloc_pd(dev->mdev, dev->ddr.pdn);
+
+	memset(&dev->ddr, 0, sizeof(dev->ddr));
+}
+
 int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 			    struct notifier_block *nb)
 {
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index fa3a145c06c6..90e0565d7333 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -23,6 +23,16 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
+struct mlx5_data_direct_resources {
+	u32 pdn;
+	u32 mkey;
+	u32 mkey_ro;
+	u8 mkey_ro_valid :1;
+};
+
+int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev);
+void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev);
+
 int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
 int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 			    struct notifier_block *nb);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8d6914de1442..0bece3e55109 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3474,87 +3474,6 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 	mutex_destroy(&devr->srq_lock);
 }
 
-static int
-mlx5_ib_create_data_direct_resources(struct mlx5_ib_dev *dev)
-{
-	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
-	bool ro_supp = false;
-	void *mkc;
-	u32 mkey;
-	u32 pdn;
-	u32 *in;
-	int err;
-
-	err = mlx5_core_alloc_pd(mdev, &pdn);
-	if (err)
-		return err;
-
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		goto err;
-	}
-
-	MLX5_SET(create_mkey_in, in, data_direct, 1);
-	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
-	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
-	MLX5_SET(mkc, mkc, lw, 1);
-	MLX5_SET(mkc, mkc, lr, 1);
-	MLX5_SET(mkc, mkc, rw, 1);
-	MLX5_SET(mkc, mkc, rr, 1);
-	MLX5_SET(mkc, mkc, a, 1);
-	MLX5_SET(mkc, mkc, pd, pdn);
-	MLX5_SET(mkc, mkc, length64, 1);
-	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
-	if (err)
-		goto err_mkey;
-
-	dev->ddr.mkey = mkey;
-	dev->ddr.pdn = pdn;
-
-	/* create another mkey with RO support */
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
-		ro_supp = true;
-	}
-
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
-		ro_supp = true;
-	}
-
-	if (ro_supp) {
-		err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
-		/* RO is defined as best effort */
-		if (!err) {
-			dev->ddr.mkey_ro = mkey;
-			dev->ddr.mkey_ro_valid = true;
-		}
-	}
-
-	kvfree(in);
-	return 0;
-
-err_mkey:
-	kvfree(in);
-err:
-	mlx5_core_dealloc_pd(mdev, pdn);
-	return err;
-}
-
-static void
-mlx5_ib_free_data_direct_resources(struct mlx5_ib_dev *dev)
-{
-
-	if (dev->ddr.mkey_ro_valid)
-		mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey_ro);
-
-	mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey);
-	mlx5_core_dealloc_pd(dev->mdev, dev->ddr.pdn);
-}
-
 static u32 get_core_cap_flags(struct ib_device *ibdev,
 			      struct mlx5_hca_vport_context *rep)
 {
@@ -4044,7 +3963,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mlx5_ib_create_data_direct_resources(dev);
+	ret = mlx5_data_direct_create_resources(dev);
 	if (ret)
 		return ret;
 
@@ -4052,7 +3971,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
 	ret = mlx5_data_direct_ib_reg(dev, vuid, &dev->data_direct_nb);
 	if (ret)
-		mlx5_ib_free_data_direct_resources(dev);
+		mlx5_data_direct_free_resources(dev);
 
 	return ret;
 }
@@ -4063,7 +3982,7 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 		return;
 
 	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
-	mlx5_ib_free_data_direct_resources(dev);
+	mlx5_data_direct_free_resources(dev);
 }
 
 static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 97d2aa79e95d..ff026985e293 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -24,6 +24,7 @@
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/mlx5_user_ioctl_verbs.h>
 
+#include "data_direct.h"
 #include "srq.h"
 #include "qp.h"
 #include "macsec.h"
@@ -781,13 +782,6 @@ struct mlx5_ib_port_resources {
 	struct work_struct pkey_change_work;
 };
 
-struct mlx5_data_direct_resources {
-	u32 pdn;
-	u32 mkey;
-	u32 mkey_ro;
-	u8 mkey_ro_valid :1;
-};
-
 struct mlx5_ib_resources {
 	struct ib_cq	*c0;
 	struct mutex cq_lock;
-- 
2.44.0


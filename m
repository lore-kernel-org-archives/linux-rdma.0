Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21154AEBED;
	Thu, 17 Sep 2026 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643759; cv=fail; b=cCrPuUu2/rvBk9ABJcN0iG38of771vkbqDRNlIzIgpqxsbMdTDlXuxUmzTSg9ERnMzGiGnt06aIxUx+NS+SvcVUBJpNKloviUmxb2zVME6B3kc+HhRermbGKfTyak4tc12fJDBphnAOuUn2EsYvkxieKw1OFB3D0oZ71E4plCJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643759; c=relaxed/simple;
	bh=ri/vXCBSz/vtj3IXgWZXbI29VChA706fHbcSE6PmT0k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8J2/EP2WfLNHjW0GofIA//v7LlpgKvjUReVU+jent2xSJjvdYLRm9DEbTR863qioU2nTYuDpg7HppoiqHgL6n3I9lKTv60buMQqcKadaMtVe9JNVrOZUZjJdyYZUIvcHnFlJYB86XjqJE+oB+EUKLM7ts3SuFURsv/Ndzb7JzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hBV5m5ci; arc=fail smtp.client-ip=40.93.194.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hBV5m5ci"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfL3vptPiDRYo/gv9r1o2UF2hesngF7JvjtL/DD050XwIBPeqvr9osmsmeUxbkKRIFG1wE2O9e6tCuIHmFnlnTDRnZtwBozdiChyFbrzPiCR+PohMKOrHhiyN+MwU5zjB4byuuA7xA2lbSGWkM6FIJ3sM2jMnBpzbrUWv8MiQyt8H3QHzgHhNzLdUmdpLUDfr8N2zwZw2l3J2ZpLTATOx2ozAUwsoZGQkoTKfjxT0Av5ARSBU0MwXlM7GgF5IB8EnhLesIpxE8OZE2eQUwPIjRpf7OVeGhpAuNoN0I4UlDyoXJt0R5OnBgdMiTfuPHC3vIWpDet9PswqKA+7z/zj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G541XZUpdoYn5ynbQO55dewem1bPfTnbBBvTFgctOR4=;
 b=C9P2+sDxLJCsOa+kftyHa8IpvllTOKH4YrUjqD+XKB0uzNuRrL3lWTfzb1MOsOsUULhaSN7wCV33LezJXtApzGSEnqK7i6+pgIQq98bPFpHp6wCwI31L1xVXdHrHXnp8boerk89uJuO4sGA+1NTGLS7EdwYd9rVO1tu7HVKu0Xx15mAGmKX/867ms4H3CSrEQLCvisI6zYlwQYlTB2JRmvbQ1xRhdQWuqe5pqsxKqGlgdE+l6XKbctGNiN0fyNJKoWCBUH1M3dBGlh9kwGxR2jnUHk7Nm+GlQSYkkPNN2P9Hwwxc3A8/LmjJnfTtxeFlwvGk8C7co3h9pmIEfuCSUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G541XZUpdoYn5ynbQO55dewem1bPfTnbBBvTFgctOR4=;
 b=hBV5m5ciQHgYhOngUzsVuByir6DJuzSwjnt9IM+s2CUnWgzYNAUkMu42pI7cWikK7A4LwB2wci+dhWTTrUj6NzltL+4SyDzL5uK3u8qWYQ+R4ih3/lwuSBUW+p+5WynhGPPdR9+sz7PCBzEsIR6evX6BqM+C1hup+Ufp4q3NMC8y3yeO7tb2VJh8iPbc8hjkYZ0E9hOpE6vwjs6Fc0xbn1OcaRd16LnMeQzskJuVIvNUyiopJR7iIM+VyryO2APm5TGscYNB5DoA8YspR3il3ZuG0H8hHe4M+mILWr5Skx6VZPoLtqfTY+us7KCTW7KppIzkhAT8PipZlym0NYl/XQ==
Received: from BL1PR13CA0449.namprd13.prod.outlook.com (2603:10b6:208:2c3::34)
 by LV3PR12MB9166.namprd12.prod.outlook.com (2603:10b6:408:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.14; Thu, 17 Sep
 2026 11:15:42 +0000
Received: from BN3PEPF00022BC4.namprd05.prod.outlook.com
 (2603:10b6:208:2c3:cafe::97) by BL1PR13CA0449.outlook.office365.com
 (2603:10b6:208:2c3::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Thu, 17
 Sep 2026 11:15:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC4.mail.protection.outlook.com (10.167.248.216) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:23 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:18 -0700
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
Subject: [PATCH mlx5-next 05/10] RDMA/mlx5: Move and rename data direct resource functions
Date: Thu, 17 Sep 2026 14:14:17 +0300
Message-ID: <20260917111422.4054862-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917111422.4054862-1-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC4:EE_|LV3PR12MB9166:EE_
X-MS-Office365-Filtering-Correlation-Id: 19012b3b-22d9-4210-cb06-08df14ad02ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IHO8JJxuP86lcyDw8Vdic9gR4ETIqO6IZa/Upo0FRJcluH/TKERSeyZrJ4VlnSIHbDgM/3VNQlyJm08/OPZpapYwtB1msc3wIXddek8MUjjT38wdHqc7plwmKRV6nYUQImkiWBOFuYtzLzspaXfCgSqc2VAJZOAWTmUcIf5NvyHQGVtNRPpi0db7SuOfSX3701uy+4TesnF29t0Wkfglhpy3SstvgqzPS9UfDM5gGnizYiJHPTOlJxSjY8TdFUs8aUuazwGveWaPttZOTcsXU66wRv2NTvsIEiDHtzYzJ7/8P6+FOhavqvtNpa8BLsHisJBAm9mIN8QRothni5efYbD9W5a5zq6jr+zbJtJN/Y9iENmfZPph5MVC7vnL/NmRD6CBi4OvJCYHgbn/J4P2+AptlJqnAzto8SRONYCo2VgmbdHyie8MmBYrsucASewAZOFXnwTTK/ZAut2O1Ogk/0BMoovHj2GKoN30m8FwjvXraxv6rkpW90bHWfuC/UY8Ym30EXxMfzNOy39H5cDLCLLNI6dEIvNILztOyf2J1xQe2nb5u6vaIb8/WVfkKwBbNny85kWmMx8DMmzVP9J5/0Sb4QeK6wDR7IUsoziqEhF7RcyT1+49l6wAVPbfGo5Onw39Zhx27VlfqRjKUYZPPLkv3uiXXBaPLUwoyRU4/a5KQXytE7qNJh3wM24XzzqgERxuyz+f2sbPIGaMwZL8Uw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cWTueDjJbhwvZuCXP4lYmL5sqiovVItESxJYJPnhDNHd0QiaKj009FaqTW3dqBtplqZa6K1Pc5344BG34GsKu/3vFTfvArVghwtgoLO30ExssBf09+ptluU/CcxCWWsYR8rjptO6bLIYdnbyrM2KdAd5rV8N76i2ear+5IammPd6Fo2Zrw1h6OAsdU12WkxeugZW+lr6BdzHWR4UcIYdlg86qgKWGYQnxiRvabHDbhUPoJCkVV/pMemQHLzoxMzTTk2nRU+DV/nkR9A+9yRv+71dVnX6pgx+YWwByFY+5Bumvl8/KRp6pHXDug+a2bi4laidaQ34KbHVj4wK9PdaG12FkCcdODVSiuqbE1quKCRF0vwFkJ0FfyX3lEBQBNsLmyxqrFVcwcEcy/a83907rxjLZ63rrEkkJFTJon6SKOxAIM5fHMTaaHmGRDKIL/cr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:41.7106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19012b3b-22d9-4210-cb06-08df14ad02ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9166

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
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
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


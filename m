Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725886;
	b=SIJBJbjAkKmXn7vFhmEKEuByCXy6VPfiZM+IArFirlwN4rc550O88f2MYnmwGBcBLLaT
	 2cbohehSJjiuvcKW6dnbjFq/Lhw49riAQMdSLUN1vwP6NWnlJ28L67kOJ78feGO2P6PNa
	 aHCxRRfLqYmNzvZ7eTf8tGYQWgp6R3p7mf6i+K/6gOrsWOyfh3EygHuiaI2vvZArR+gUt
	 b+gOKWGoIyBNLYL8/zyEyu4x3idYIVol86QM8yD+lZiTu6+KcpWAGnZ8Cu3beuT+a+aXE
	 RnRLtsF40CdljsrdwxOkGGnwpI0bQANBcpcT9mXVAGNEQtZJogL/nUj0sHaE8wAljNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725886;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DTOQcBgbV9CV4Zg8waPeMI53hBXEDoaueylrT/Catbs=;
	b=1dETwDFoEgh8DMWns/sA3ZQV5CUQ18/Ty3XY5rg6ovqKbsOILDAnnb70DSSJ3QGYrc5f
	 Bqw+dAyfQeDJz8RS49N4/TTgTdltLWiyobpixio8+zdkD/K1O4YC6XlJJ4Sc8rHfcXh2D
	 33dxX0DwxgjYAhS+CCLGn1nU7ydEUxeKG8yRa6FOBMkcHTJIIL1Yyccjmlll3xjwloZ5v
	 BLmts6G9oPvc7X4O/wIlScMpAjNpfc070HGY47+TGyduRCmgFeTmCV3wZT03WR/A5U3wl
	 DySgDT3yrNT/6nV+NcO4+HDGzzh3MRYCXwKZqCxDETDej2kqvH6hBhl71fZ/YO5loAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ifHqukpE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.68
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9055B606A324;
	Tue,  3 Nov 2026 17:11:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9055B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ifHqukpE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RTkNB5mvi7e3xmX7ai9PCwC42sr6BXEuBnN7Wc1Fcc/LOgg37L1RokfxSQ1bAv9XAjXJAbGal9nMiDLr2dlL3TQRdXrOz23qGlV7ieuBW0xR32O2VAQeBK5fgifKnIOTT8WX/Ck7JzV4gzwQOxTsci7n4qo99Pv4Fk6+nBZxAbYvT0y4Uh/uUQBr+tfKu1L4uIJ/it2P6RUDKbn79FWI3GS4kxP989vid9itFpzKNkM1y+Sgoz8xjufEMc0uL82KQ7nV5ZIRth8L5caJRCHS6aoEHI5WRBLKfAmq59o5MMMPzyzbnTzJZ+p5+/zEUPp5wcIxhNMrOLy1uU2avQbBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTOQcBgbV9CV4Zg8waPeMI53hBXEDoaueylrT/Catbs=;
 b=EFDpYaBtRv54ON8HPwdT7N+XB4rXAbYukhq6Dkn6Y0meE47OB4L8E6pkUkZ10NnPU5r2VgsxSxA/mfvSmH6G+nFuRv8F11U4EEmWBoMUWFsGUVfLiAu7baOZgS47WOllVDRe20AdfEHbOuOHJTSIMpLxiiNrz3JIN7IvQJ/UOb8Qct19Y4S+viI1ngIC8i/QOaGM3gs/Gl8WUYHYsCRMkSWV2xzBeptPxh2lx5gHV8hx4bpHVSd1Yc2wDHTdk2Qat5YlFCt3o8jlNLLU7+MIZ0LEUllFngze6+rhmHTrGutHfS4cnA7n2sgtZ0cU+gREKPcBwlxxaONt4inmnntGTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTOQcBgbV9CV4Zg8waPeMI53hBXEDoaueylrT/Catbs=;
 b=ifHqukpEOeOjY+DO1FaUPLQ8yhF/GXmuwasfXHdw1122CzbDVmY6UAfWO7SkWmf0YrJ+PNnG/rkSfUfUQY826UgjZI1hcx8ZX9KSYAhoTdjFI5+GIoViWZxrqETlw+ZiuKHBq6f4pX/UpCOe9B+ZmZ/XlMGugNfuhRKS44S+ReZHSfifDvsPGktda5a35Yct32I6e8B9ORe7FRM/hXDexFbHxmfTn9FPecjOvqm7+nFHO/9+/q8gb0PUrWYpe2rgfqm9IeJCHYHfDy7KxN/HpvWg6zisr8n0sIyzpRVfo0lNRsARDn33458RBVrpQoUW7XTwvsAR41f62qPne5pI0Q==
Received: from DS7P220CA0084.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:259::14) by
 IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:11:18 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:8:259:cafe::f) by DS7P220CA0084.outlook.office365.com
 (2603:10b6:8:259::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.8 via Frontend Transport; Tue, 3
 Nov 2026 17:11:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Tue, 3 Nov 2026 17:11:17 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:10:46 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:10:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:10:40 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 02/15] net/mlx5: LAG, select the MPESW master from the live member snapshot
Date: Tue, 3 Nov 2026 19:09:56 +0200
Message-ID: <20261103171009.563034-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|IA1PR12MB6305:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c6abe0-8aab-453f-9cd8-08df39cd7968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|11063799006|261021123027099003|261028144727099003|261009223027099003|261021121427099003|261026121527099003|261022105027099003|261026140227099003|10067099003|18002099003|261102123227099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZIY7RWjp4OY+6n+IKM4+Dm499u7WE+bX6/HWVapg8Iwbi2BNW+GciH+ZA/9vwtrzb+kizP6+z8LNyUKhHrYdBKR3KY0cLSlGcjtfErkPEqEHj+YGaPBn90NxL4ZrL4OCEnipSwmswJ1bbeRe6E+qqmPIYJHIfOF0Hn9KuKfUYtR018luxquQcRIdEvgaFtBhLqIRwC+0kH0DRJATQa8J5Zikr/B5DPsNZ8TZy0bdaRKCGZKqS+XiA7GgPgJjGyXqbT+9eTUSKNHbR9ioi48if/n6UCVgdDZwLM8jgJs4Tb3nYObJ8MxfggNqtgMeT93yiYHGpXwV3DpH47cJHrEyOBYebn4ik0SfJK4UhX+Y7jSyHMtBBx0F64CVZnVXBZnXp7P8jiM4mrQq1t7lJ9jK05r7w7B26icYWUm9Jwcm8TCWN70yO8Ejy+F8wHBj7RsI7e7VnHXaTBN3h/8dB6dVq+YaFypSm5mshvfZn+lD/mmKq2vfG/5JgS9mJsnGYVa2lTg9zspiDMvhYNufdSNP3bpkoum9J6Jh80iIkur4v6F5t1n5nLSRSk2BvEFSQQMu+gSh6ivZ3n4NKLnOOrpqt9KkUYN5VOQ27QYoLxp04SIix8PH+yhguDVgvpYFBX7+bEuFW9wGV8ZBzqjk6BN1uKO2LsFOzEyTDY2n4rXzDra7J+l7mf9kJOD52OpVF4AhST9g4qKtQod53sqVx/YoKg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(261021123027099003)(261028144727099003)(261009223027099003)(261021121427099003)(261026121527099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(261102123227099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kIs7qoFsr5mXU1lgs/NOL2Qff45kt6WcXaxm7Co1SlZ64nbvAJDbRw8y2Jziog+20SZjtN7eLbzC6CPcQ2ZDd1y2Qs0zy8tFbhNmaUaJjjI/Q6EdqiyV2c5Dr1pmvQXRWuqm45icDX5aLkvTAYLlkucBCT3ME/neH7S7US9pYCWMdQjHihU7WQz7b/dOqkqiHBvh/KBTkIzhHG0AlNQm/NYPLIVxAGe714szalaHLEZj4KCJgnubdxYEUmRlX2G4cIhD90ByRFM0SgSreLkje91YwGAPPFdUiVinSZMlw6bbplotrq2E9czzvY2Yh7cq8B57mCFguYLnDoNtA7zzQ89lbFgappLYQpJsNa+Knui0bhJKljdkWvK+3itPokxFbwrc0RayC2VsNRWwiLlXaZ+w6dhe6XilzntkZsntqZ1m1+mQt7isrF8RCRFGhujj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:11:17.6047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c6abe0-8aab-453f-9cd8-08df39cd7968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6305

From: Shay Drory <shayd@nvidia.com>

The LAG master is marked by the devcom PAIR event when all physical
ports have registered (mlx5_lag_num_devs() == ldev->ports). That does
not work for a virtual LAG of VFs/SFs: those functions are unrelated to
the physical port count.

Select the master from the current membership snapshot in
mlx5_lag_enable_mpesw() via mlx5_virt_lag_mark_master(), and clear it in
mlx5_lag_disable_mpesw(). Unlike the regular path, it walks all LAG
members.
mlx5_get_dev_index() is identical for a PF and all its VFs/SFs, so
tie-break by a stable per-member key is used - PCI BDF for VFs, sfnum
for SFs.

This is gated by a new ldev->virt_lag bit identifying this type of LAG.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 46 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 42 +++++++++++++----
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  | 12 +++++
 4 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 24086267b4a7..46f125d24f15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -39,6 +39,7 @@
 #include "lib/mlx5.h"
 #include "lib/devcom.h"
 #include "mlx5_core.h"
+#include "sf/dev/dev.h"
 #include "eswitch.h"
 #include "esw/acl/ofld.h"
 #include "lag.h"
@@ -598,7 +599,43 @@ static void mlx5_lag_mark_master(struct mlx5_lag *ldev)
 		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
 }
 
-static void mlx5_lag_clear_master(struct mlx5_lag *ldev)
+static u64 mlx5_lag_member_tiebreak(struct mlx5_core_dev *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+
+	if (mlx5_core_is_sf(dev))
+		return mlx5_sf_coredev_sfnum(dev);
+
+	return ((u64)pci_domain_nr(pdev->bus) << 16) | pci_dev_id(pdev);
+}
+
+void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev)
+{
+	u64 lowest_tiebreak = U64_MAX;
+	int lowest_dev_idx = INT_MAX;
+	int master_xa_idx = -1;
+	struct lag_func *pf;
+	u64 tiebreak;
+	int dev_idx;
+	int i;
+
+	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
+		pf = mlx5_lag_pf(ldev, i);
+		dev_idx = mlx5_get_dev_index(pf->dev);
+		tiebreak = mlx5_lag_member_tiebreak(pf->dev);
+		if (dev_idx < lowest_dev_idx ||
+		    (dev_idx == lowest_dev_idx && tiebreak < lowest_tiebreak)) {
+			lowest_dev_idx = dev_idx;
+			lowest_tiebreak = tiebreak;
+			master_xa_idx = i;
+		}
+	}
+
+	if (master_xa_idx >= 0)
+		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
+}
+
+void mlx5_lag_clear_master(struct mlx5_lag *ldev)
 {
 	unsigned long idx = 0;
 	void *entry;
@@ -618,7 +655,7 @@ static int mlx5_lag_devcom_event(int event, void *my_data, void *event_data)
 	int idx;
 
 	ldev = mlx5_lag_dev(dev);
-	if (!ldev)
+	if (!ldev || ldev->virt_lag)
 		return 0;
 
 	mutex_lock(&ldev->lock);
@@ -1785,10 +1822,13 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 {
 	struct mlx5_devcom_comp_dev *devcom = NULL;
 	struct lag_func *pf;
+	u32 filter;
 	int i;
 
 	mutex_lock(&ldev->lock);
-	i = mlx5_get_next_lag_func(ldev, 0, MLX5_LAG_FILTER_PORTS);
+	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
+		MLX5_LAG_FILTER_PORTS;
+	i = mlx5_get_next_lag_func(ldev, 0, filter);
 	if (i < MLX5_MAX_PORTS) {
 		pf = mlx5_lag_pf(ldev, i);
 		devcom = pf->dev->priv.hca_devcom_comp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 0ff337983a6d..dff04f40d8f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -84,6 +84,7 @@ struct mlx5_lag {
 	unsigned long		  state_flags;
 	u8			  ports;
 	u8			  buckets;
+	bool			  virt_lag;
 	int			  mode_changes_in_progress;
 	u8			  *v2p_map;
 	struct kref               ref;
@@ -225,6 +226,8 @@ static inline bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 }
 #endif
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
+void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev);
+void mlx5_lag_clear_master(struct mlx5_lag *ldev);
 bool mlx5_lag_is_sd(struct mlx5_core_dev *dev);
 int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 			struct mlx5_flow_table_attr *ft_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index abf72026c751..cdaf72cb0595 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -109,8 +109,8 @@ static bool mlx5_lag_has_sd_group(struct mlx5_lag *ldev)
 
 static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 {
-	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
+	int idx;
 	int err;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW)
@@ -119,20 +119,32 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
 
-	if (idx < 0)
-		return -EINVAL;
+	/* VFs/SFs (nested LAG) are not marked by the LAG devcom PAIR event;
+	 * select the master from the current snapshot before resolving it via
+	 * mlx5_lag_get_dev_index_by_seq().
+	 */
+	if (ldev->virt_lag)
+		mlx5_virt_lag_mark_master(ldev);
+
+	idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
+	if (idx < 0) {
+		err = -EINVAL;
+		goto err_clear_master;
+	}
 
 	dev0 = mlx5_lag_pf(ldev, idx)->dev;
 	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
 	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
 	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
 	    !mlx5_lag_check_prereq(ldev) ||
-	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
-		return -EOPNOTSUPP;
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL)) {
+		err = -EOPNOTSUPP;
+		goto err_clear_master;
+	}
 
 	err = mlx5_mpesw_metadata_set(ldev);
 	if (err)
-		return err;
+		goto err_clear_master;
 
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_teardown_sd_fdb(ldev);
@@ -143,13 +155,19 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 		mlx5_core_warn(dev0,
 			       "Failed to create LAG in MPESW mode (%d)\n",
 			       err);
-		if (mlx5_lag_has_sd_group(ldev))
-			mlx5_mpesw_restore_sd_fdb(ldev);
-		mlx5_mpesw_metadata_cleanup(ldev);
-		return err;
+		goto err_restore;
 	}
 
 	return 0;
+
+err_restore:
+	if (mlx5_lag_has_sd_group(ldev))
+		mlx5_mpesw_restore_sd_fdb(ldev);
+	mlx5_mpesw_metadata_cleanup(ldev);
+err_clear_master:
+	if (ldev->virt_lag)
+		mlx5_lag_clear_master(ldev);
+	return err;
 }
 
 void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
@@ -161,6 +179,10 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_restore_sd_fdb(ldev);
+
+	/* Pair with the master mark taken at MPESW create for VFs. */
+	if (ldev->virt_lag)
+		mlx5_lag_clear_master(ldev);
 }
 
 void mlx5_mpesw_sd_devcoms_lock(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index 3ab0449c770c..382162baabdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -19,6 +19,13 @@ struct mlx5_sf_dev {
 	u16 fn_id;
 };
 
+static inline u32 mlx5_sf_coredev_sfnum(struct mlx5_core_dev *mdev)
+{
+	struct auxiliary_device *adev = mlx5_sf_coredev_to_adev(mdev);
+
+	return container_of(adev, struct mlx5_sf_dev, adev)->sfnum;
+}
+
 struct mlx5_sf_peer_devlink_event_ctx {
 	u16 fn_id;
 	struct devlink *devlink;
@@ -68,6 +75,11 @@ static inline bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
 	return false;
 }
 
+static inline u32 mlx5_sf_coredev_sfnum(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.44.0


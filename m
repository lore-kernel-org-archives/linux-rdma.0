Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012065.outbound.protection.outlook.com [52.101.53.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0843F23CC;
	Tue, 11 Aug 2026 06:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429039; cv=fail; b=IiBYa9xlW1ZcEEjEZ0XaESxOOcKgozEf4CTMFwDf0Uc/Hb8ir5HfuifoJAME0vTYequAzSinPcWc6mz21QL+MMnI2kDG8b5hQTHvfYx1ldCkB52fIFi4xlHAt/4OZOZ1IjmVQPMJQ+3ToSa3hvMckxFWE5LZzmzVqn9y2rI7HzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429039; c=relaxed/simple;
	bh=cIoDhfK2Oa08KzxjkjQpi4YGnM7CPFNUCMcUyjjKJ+s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ja6For5CFeOUcm/CHETqJJFo/H50eWVbyOoiBmN8rBMJINlGOfCB5yBCa6Dn0q06U9MYL5NtHAd4w9VyM/hZMFukKyYJ0MRDgCGhwvtWcgR28Ymf14fxmHae3IL+esR1E7CyXX5ttR2Rnmb1vGRBg+oZDzlBc7QCjs/lMG13+Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mfd5cA/U; arc=fail smtp.client-ip=52.101.53.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mfd5cA/U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYw73oJUEzgKTrOYK0ds69MBcXTs4AMJx1t/i7kjXjwHCt96G9jgRjquNMyvKgkm6jmXkQ5bR7za9xNOYgVzeRrTc9Pveshu9Za+eOmIR+KY/crx1nQG0I+unwc2HtxywKBwDroVB8n+vRzPUahFxfttWlpTMzOzu0/24ZZ4ihjPcHoLzGn8j2kEqb+7bmmWi/1p66HSF4qccjheq13kS8zvXSrXNX2BrFlcZlU7RtNwiEPE3P3h7/7MOtrgc3zgVYOKnWS22IVoCbYHqvt3XZ08MbxE+hXdBWePW897ftmof72hjMxBMv9GXmnip5Rygvqcrulx5ITtfA23ng9Ieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwMUByo+Jy73gq4ndR1PA0IMXtUwSVZBI7vwgEMbOHM=;
 b=fu73LKDfmLQrbmVliWiYug5vCWTak71XYBDM3tJLTi+WGVYCpmlreXjzpI++cW4ylntUKK4yyA3GJjj80swMG5fCS1ts0pQBmjI+Nv65XCAE+opGyYxvJB+ql6jrK6D8lX2zytQX/qv1zkbntlM86ib2L0wqKmS0gsMJ6AR4GTBI0gAwDDYVbasll+WP8IJgM8VjgTWOu+RB45vo/vj8j9kW8TC1a39kVDYzV7vz+w9CQNmc1AayQGnNu/Jea+PTVkgVAgR8ONiFjU9sUn9QY3OY0LouJ9n1SQGUy1ZqwhfUuuZBRHCoIbJqjcswN2DQ3VT+t88GdpsWPKUAT5MtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwMUByo+Jy73gq4ndR1PA0IMXtUwSVZBI7vwgEMbOHM=;
 b=Mfd5cA/UTxZRdTVj6yKAAzgZIpZD5Oq9E4zQxZserdUawqEJ7bahazIDruWL2B1KE2Amk+v/1UB82ccSj3Ftho+gh9wf1e3M9mBUc8mA/da0ed58Cd2kSXP+46zd2o7vvcKyWVCUgwPS5gCKWCqiUV2kDj9Emi76gRA+TSps7Oq1OkPGymYqK8hfieVQqbXgzyAx67pnLPRiteXnzTd9TVhTYhB8xaIuVR6HxjnrX20otTaivLoSlo/lWKCHYn0zDvg2GtgIjfPINGWKo7vFH3rwxJuGkEJr9j4qIM6VYTo6uoRcy1aEqdpVojnLvtCzHjJnmu8V2eKv6h8oTvKGrA==
Received: from BN9PR03CA0187.namprd03.prod.outlook.com (2603:10b6:408:f9::12)
 by SJ2PR12MB8720.namprd12.prod.outlook.com (2603:10b6:a03:539::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 06:17:09 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:f9:cafe::4b) by BN9PR03CA0187.outlook.office365.com
 (2603:10b6:408:f9::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Tue,
 11 Aug 2026 06:17:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Tue, 11 Aug 2026 06:17:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 23:16:52 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 23:16:52 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 23:16:48 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Eran Ben Elisha <eranbe@nvidia.com>, Feng Liu <feliu@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Michael
 Guralnik" <michaelgur@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shay
 Drori" <shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5: rsc_dump and hv_vhca return NULL on create error
Date: Tue, 11 Aug 2026 09:16:37 +0300
Message-ID: <20260811061637.3195320-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|SJ2PR12MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: c634144a-4623-46c4-f7ae-08def7702c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|23010399003|7416014|376014|11063799006|56012099006|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	K0OJDFhXqtDDEZiY4OTK5c2rHShWwmA/HaBSO5R4NMSWxZgxzW/VGa+m9u8obhVms5gFPLcarp1LNGR7Q3ZlGMKQEoj/hUH1aYOKEE1uIGcjd53s73n4CSrvh65Ve5qd9ORmWXNXCV1RYjsIJiUnresM4dgJ0JQUa996j0nlActtWT9G2IZy60yqjY1Owg7FzQqKNyTSeFiIIfZoCkOg0331VU25IqApGBKPCg9LntAOHdE+YpzXN6sJqB3pbAZxmTW1TYx3XAMV5vgmjav3wQ0F43GMDeyTr3GjoMQ/wCO/Y2jPc9FWUX+UvHKsHI4uSIrezl5cGf6CC+Qz+R33FUbIuKyW/zff4SPx/QSugQOv4OSksuTtKtY9zYgpxok5zGadb33w8nspUVsA8y0CmnRTJEUA1VD7TNhhDMvq1pAJoCPmzAkVHRrloqQ+xkmYEWcAzymFumyHZd1FeVAB9s+gHXWBXWjSlXNvebapPdCWV/UGSthaOvDbwqLD3wOAyA2wX4HWJuMQOQEChY6j/rqgn747aCmKd9Ns1MqBq9jnxS8RBRpWPQ84K670ImN9TJWgIYafLvr4Z0ktZKynFFvEJYizS09SHzIt8VDbN9Y+XkDkwqumCiLmlrPiQa8+WUrukgDmMR8B7IZDT6Z8AMpNgXKdUNiAiH+lGIYAGwRVeOm6JN9IAnTMWf+hIEEOUVASyebwY/p1KK4JRRvSOg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(23010399003)(7416014)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SCiOrjCnu77qEvHyXZOmNDLkCvvv9snn/DlpYc/LgkxZajd6TMlYO38rUt2BSgDnkbVPqYF0Nv1kvaofvP6XgzeAMVxcHPzzOUCcocJZCtVoN1v9sBmrQKUYfDtzfEo9fQ8w2QiDN8rq5+Nbv0D9oarwO1V/Cusm7DaLhCYGT+ttVsUOryTvnheN+aPB181xamnqcVjXEHd/9ebW/+Nihpj+Iubatf8MFHu2D4CEa+lShl67956Xb3S3nRdIjnK1Oz7sgCeF5kflyOhRFLpoQW3WNF0g4slODFCXxGnfEQ+yUaGYKZUq8WIwo17dMVDc4vbJ0+gm6c5I/Xk+/fbMQPtR2zn1l7VVi5qTX8Ho8Mb0qda4bZBMRoolHNG2W/EebpxsCrcyt6Ji28bhO3PKxC1e29V7caZdzBa1e6TIVvj5GQ0rSOGXV20rxEWwmool
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 06:17:08.5321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c634144a-4623-46c4-f7ae-08def7702c72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8720

From: Michael Guralnik <michaelgur@nvidia.com>

All callers of these create functions treat NULL and ERR_PTR as
equivalent error cases. Align the return convention to NULL-on-failure
to simplify the checks at usage sites.

Since its return value is never checked and failure is non-fatal, change
hv_vhca init function to return void.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 12 +++++-----
 .../ethernet/mellanox/mlx5/core/en/health.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/hv_vhca.c | 22 +++++++++----------
 .../ethernet/mellanox/mlx5/core/lib/hv_vhca.h |  6 ++---
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index e770088de129..8044419fb5eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -130,7 +130,7 @@ struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *dev,
 	struct mlx5_rsc_dump_cmd *cmd;
 	int sgmt_type;
 
-	if (IS_ERR_OR_NULL(dev->rsc_dump))
+	if (!dev->rsc_dump)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	sgmt_type = dev->rsc_dump->fw_segment_type[key->rsc];
@@ -165,7 +165,7 @@ int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
 	bool more_dump;
 	int err;
 
-	if (IS_ERR_OR_NULL(dev->rsc_dump))
+	if (!dev->rsc_dump)
 		return -EOPNOTSUPP;
 
 	err = mlx5_rsc_dump_trigger(dev, cmd, page);
@@ -257,14 +257,14 @@ struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev)
 	}
 	rsc_dump = kzalloc_obj(*rsc_dump);
 	if (!rsc_dump)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	return rsc_dump;
 }
 
 void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev)
 {
-	if (IS_ERR_OR_NULL(dev->rsc_dump))
+	if (!dev->rsc_dump)
 		return;
 	kfree(dev->rsc_dump);
 }
@@ -274,7 +274,7 @@ int mlx5_rsc_dump_init(struct mlx5_core_dev *dev)
 	struct mlx5_rsc_dump *rsc_dump = dev->rsc_dump;
 	int err;
 
-	if (IS_ERR_OR_NULL(dev->rsc_dump))
+	if (!dev->rsc_dump)
 		return 0;
 
 	err = mlx5_core_alloc_pd(dev, &rsc_dump->pdn);
@@ -303,7 +303,7 @@ int mlx5_rsc_dump_init(struct mlx5_core_dev *dev)
 
 void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev)
 {
-	if (IS_ERR_OR_NULL(dev->rsc_dump))
+	if (!dev->rsc_dump)
 		return;
 
 	mlx5_core_destroy_mkey(dev, dev->rsc_dump->mkey);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index cb972b2d46e2..45574f8b10eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -186,7 +186,7 @@ int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_key *key
 	struct page *page;
 	int size;
 
-	if (IS_ERR_OR_NULL(mdev->rsc_dump))
+	if (!mdev->rsc_dump)
 		return -EOPNOTSUPP;
 
 	page = alloc_page(GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
index 305752dab7bd..4c4cf6da519f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -44,12 +44,12 @@ struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
 
 	hv_vhca = kzalloc_obj(*hv_vhca);
 	if (!hv_vhca)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	hv_vhca->work_queue = create_singlethread_workqueue("mlx5_hv_vhca");
 	if (!hv_vhca->work_queue) {
 		kfree(hv_vhca);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	hv_vhca->dev = dev;
@@ -60,7 +60,7 @@ struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
 
 void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
 {
-	if (IS_ERR_OR_NULL(hv_vhca))
+	if (!hv_vhca)
 		return;
 
 	destroy_workqueue(hv_vhca->work_queue);
@@ -198,28 +198,26 @@ static void mlx5_hv_vhca_control_agent_destroy(struct mlx5_hv_vhca_agent *agent)
 	mlx5_hv_vhca_agent_destroy(agent);
 }
 
-int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
+void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
 {
 	struct mlx5_hv_vhca_agent *agent;
 	int err;
 
-	if (IS_ERR_OR_NULL(hv_vhca))
-		return IS_ERR_OR_NULL(hv_vhca);
+	if (!hv_vhca)
+		return;
 
 	err = mlx5_hv_register_invalidate(hv_vhca->dev, hv_vhca,
 					  mlx5_hv_vhca_invalidate);
 	if (err)
-		return err;
+		return;
 
 	agent = mlx5_hv_vhca_control_agent_create(hv_vhca);
 	if (IS_ERR_OR_NULL(agent)) {
 		mlx5_hv_unregister_invalidate(hv_vhca->dev);
-		return IS_ERR_OR_NULL(agent);
+		return;
 	}
 
 	hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] = agent;
-
-	return 0;
 }
 
 void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
@@ -227,7 +225,7 @@ void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
 	struct mlx5_hv_vhca_agent *agent;
 	int i;
 
-	if (IS_ERR_OR_NULL(hv_vhca))
+	if (!hv_vhca)
 		return;
 
 	agent = hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
@@ -261,7 +259,7 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 {
 	struct mlx5_hv_vhca_agent *agent;
 
-	if (IS_ERR_OR_NULL(hv_vhca))
+	if (!hv_vhca)
 		return ERR_PTR(-ENOMEM);
 
 	if (type >= MLX5_HV_VHCA_AGENT_MAX)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
index 8b3974cf0ee4..393dc5b62a17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -31,7 +31,7 @@ struct mlx5_hv_vhca_control_block {
 
 struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev);
 void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca);
-int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca);
+void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca);
 void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca);
 void mlx5_hv_vhca_invalidate(void *context, u64 block_mask);
 
@@ -63,9 +63,9 @@ static inline void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
 {
 }
 
-static inline int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
+static inline void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
 {
-	return 0;
+	return;
 }
 
 static inline void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)

base-commit: d67e5dbda22604d0fcde32fce58c65f88676e676
-- 
2.44.0


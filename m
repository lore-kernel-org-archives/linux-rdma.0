Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870915;
	b=gzPozqbO9vRi5GVpcz4VQdLw5AIRYDZQ5ec++Zs2A4lN3xaGjzF38hrWjnL7cfPVA9XN
	 IduA1roOOxuF7GjqZwm4VUAfIiFADe5DVQh6+2l2nsY9fW/EyyLIoUeEMUVRGr4q78B34
	 a4vGZmE2gVQ0BaIdxKTECTzPYP0fOpUojCJHjmNN99q+GTpQLoPtAO5eqVYiGabmh+QdT
	 B1kunYz/GPvDXdGDtUwjF7UV753EnLXsUrWiHIw4zz3tgrSJsMJCeNHKIZScmRK5u4AEI
	 XJgZXWdElLt42YKaCCGqcZuIGcM0pxbb+b0xIl9gL4fPhv+3GkRSA0al3PJhc70l1Ag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870915;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yl17SSWGKuD3xehqXvFXoYfzy7WYMHnZm90KCIyYLQk=;
	b=yxtSXRC3dvREYOf23XcdRNI9th00RmbFWRNlAxZMpxjOzo0fmPjHh1A/qPIqQCTYcplz
	 zX+BmYkFEGulzGWqLICC1fAlYvwasbS52v9SmlA+HxpxDmdT56lo3d7YotIvVHORFNOAf
	 OeWfDEhMfo9VnKPKbI4c3btuouJgfRWTQiSe9QhBl3ltqi8oOlbZAemSkOUNAAElb/tJA
	 RhW0fvTzF4xZobV9Cv4J6Pw9bGAOuyDjyMINdqPSFv9wAjSrcoAqlGT6Flrq7FuVSWRHC
	 b7YS9DOfECPJ3zuVfvPcYGBpKSR9k/GzqoPYijH42eh7m6OX7hTRuujdY9gBK54Txog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LvuNzLne;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.12
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011012.outbound.protection.outlook.com [40.93.194.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0CC606A326;
	Sat, 28 Nov 2026 13:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C0CC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LvuNzLne
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q2TSIvH31Gv5AMoyJKoGSjYw/ATTRhGf8U7UUxRqRdlb37x1+A7Ig4obedgTBCywRkXrDJ58Ld8F2glPC8RYEa/oFPvUS6H7sHYYqDjXL3eOWeV7aOq/nzBCDWh94WGf9w7Fx6MXsKcDjbfvY0Aqiy9hLqi9cPVOev++iZuSfJ9dLHjVNo2+C9oFy8HwL1qMu0dxHSeWRXObM2yBf3BT1zvbOAJF7nGNVZKk18BGAAb/TJ87WxPTNeRGW3n3inVUTHlqkjbv+HS6daeKYIktG5T4piTAanVbMaIk907kw+bpCnZHQ2Fcom9Ww7l2mgfbDZ/TYDZOMLUxRApg1IaA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yl17SSWGKuD3xehqXvFXoYfzy7WYMHnZm90KCIyYLQk=;
 b=CFfZ2UZGq30npqYpG7LmJAD0/wHPh6T4l0+DVVqi4MRjS4yt+7K1ixocJO9x58SPxrnvs1J/8S6OgOm5kQGT3o0TsQhzzKmOSBOBjDaEp0dvdqEOY2hTBvI0WH5f1rsHOKYoZEiaA6x9LkKMdwemaMlCD1TgMC22RVDvORTYPHQIrQY1Lm9glMYehEBN3KElbYUOuSXA5n1o00qJ/mfnyOlNQCPtUcKFWnVpPPffeP6vLWLW4U4htOSMS9Rq1h5+BDJo6vVebouw7NbqVvvMVbKE6mXgFGr2CdxZoksDRd+Y1X4irnh5+K+v8tL8JfqsDDA/5rSXMUEBcQgtLhIaXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl17SSWGKuD3xehqXvFXoYfzy7WYMHnZm90KCIyYLQk=;
 b=LvuNzLnecQfqZYsXcPeOQnA2PXzMuCLWlSnRWj2SQvQKqE15ph0E/zap5JQ7mfJDXOJHK/7JR7JBhvRRfnNca3XrkMBJer2DZ2sfuqzB9fUTJ/CEz9sUQfyQxDoElNsfujmGDmFYeyPavWqRwAEmjwCbCkQIiJZ6yc23CuH7X4ZXkL4AlgoOki3/ejNRfPdXRYuNFrs42QgbEXcOHWvuaETdD9v+UPc4HEc8ShL0CKYmnXBGJL9PKRVfgZDCnfb6Jyi7CPvBTnfadvwFQH0+31qZt34sGtFKfC3kYNn1HAH0DQFgpe8dxlgRlqbldIu60axrR+9039/Sd3dRLPtKEQ==
Received: from BN0PR04CA0113.namprd04.prod.outlook.com (2603:10b6:408:ec::28)
 by BN3PR12MB9570.namprd12.prod.outlook.com (2603:10b6:408:2ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:01:48 +0000
Received: from BN6PEPF0000006F.namprd03.prod.outlook.com
 (2603:10b6:408:ec:cafe::16) by BN0PR04CA0113.outlook.office365.com
 (2603:10b6:408:ec::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN6PEPF0000006F.mail.protection.outlook.com (10.167.248.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:38 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:38 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:36 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:20 +0200
Subject: [PATCH rdma-next v2 07/11] RDMA/mlx5: Select the QP core device
 through its PD
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261128-mlx5-sd-prep-v2-7-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=66710;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=GEPElTBr6tMPR0nTrautfh0O/0DvGW6t8XvP4Aczx1c=;
 b=t7s7DX8RDZpgAJuaP0bE+OsuoUDht1jZx9BLaJKK2yzrY0VODBbtdVPtVcLPoqw/gBXw8nYhh
 xiK+Xv3JeCsBQsZd7jDgdKXuwK7aGtbmF2033RNT5gbq0tUemdyMySr
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF0000006F:EE_|BN3PR12MB9570:EE_
X-MS-Office365-Filtering-Correlation-Id: 65367e38-40e8-4963-a20b-08df4d4fc396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|6133799003|261009223027099003|22082099003|18002099003|10067099003|11063799006|56012099006|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261022075727099003|261022105027099003|261021135927099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	ogaMd5gY8So1LsCiN2U8S1ezcz/P9/WyxYbo480WqA+EgroshVMi+qON3VE470zQe0SJ2SrCScJbfdPsEtddl5nqHCqBEW2vNyzoRKdWH7pQmivUs8DIth3hFuOioUF7P0HEfR9bsYSXOrRV7Lz4PV0O2nJ1bj5lVvzpZJzwSynY11mT8XMJhdK2cQyXt55K87Ubk1HvO5qCCQLAkJfUlNuVGro2R906Ad5Q/zDv+9CEKkmOSGn8LKNFCN7MNRZpWlTIOTLDIayqIhgJZ3KJLAr1M72osA3ujFJZXG1cEkYs/eEztBGBr51GX7Vc2hNqAwqJ4VGQQxBz6Hx4WR+8Q83H/QVuxc26ynbyVb9PVdNN0fvy0ScAclfnLp/TaxOYoYGW1E3U5c7eigoxSvo1V0uqXgvMd17A0Yve+adqlH6ZnhRZy+xCaj2B1v/oTfcN/60nVt8VnymCMqgyCjDQMp4dbGLJeSqV6TEzd49AcXnfPf9Zzw8b3A1zoQ1azp/RPSw8GXO11jRWZrFSLJY9fqOetjjFAvy4h1rE9LqAPEu7ohU2gY4wHc7Af35G4I1AEapI1SyWMLOnxq7pkqAx9wS9q26y6ryIsgI/NynEzYSokKFtcilu8bx3hqsPtDoj+aQ4QCT/HZEFfTPPPHc6nEQbaANdQsbrqlh0yC76iiGv0fGoEgswFAymp1PgBEjuEpsWds4fjphZTANTvE9dTQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(6133799003)(261009223027099003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022075727099003)(261022105027099003)(261021135927099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t3f0R1zki45LkN2qQMSIBv+ZVCb0TMEZtUEG/YZo/9+8mg49yAbUJ7ld5Udk2Luqm1uWF0L35tI+tT3h5Np3X2FI8DV/zfsylQeUSv5kc/izUd2SnEDJHE06boG3VUBufd3xJSkXHsRiwL7fGBMiKKjB4anmOs8OpGQGLP5a9HOEUbq3vl4rK3DQsrgnPfexN1CJ+6jF4p2Fa2esA7kAI5KZ+e/REbHUWXUFno9Xqd07HpuKBz354DSiVDzdSvPWKAx//t84DJciW5SvtqBMzUhQ8Ga0PuZgpPwdogydPwR0wIX5fQoRc3yYOq+pv/Kwg+MGsgm77x3BZlYCOG2kqbAUoTZP35Qx3GrKfGYB8Kz27/xuuoeTy2lF7MTyS46J+OeUi4nqpKy1GaWZdF88ZrifWHZFfDRUwv5JJjCgEEXZnccIDnqriuFQfK2pXv37
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:48.7298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65367e38-40e8-4963-a20b-08df4d4fc396
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF0000006F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9570

From: Akiva Goldberger <agoldberger@nvidia.com>

Resolve the core device from the QP across the QP create and modify
paths, instead of accessing the core dev through dev->mdev.
Delay drop is armed once for the whole IB device, so it stays on
dev->mdev.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/gsi.c     |  13 +-
 drivers/infiniband/hw/mlx5/ib_rep.c  |   3 +-
 drivers/infiniband/hw/mlx5/main.c    |   6 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  14 +-
 drivers/infiniband/hw/mlx5/qp.c      | 415 +++++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/wr.c      |   4 +-
 6 files changed, 244 insertions(+), 211 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 65668bd1b30fcab6a5e6775e09505d417f33656a..a665f41a005ca53f632684725bd8b4b7a5d1210e 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -38,9 +38,9 @@ struct mlx5_ib_gsi_wr {
 	bool completed:1;
 };
 
-static bool mlx5_ib_deth_sqpn_cap(struct mlx5_ib_dev *dev)
+static bool mlx5_ib_deth_sqpn_cap(struct mlx5_core_dev *mdev)
 {
-	return MLX5_CAP_GEN(dev->mdev, set_deth_sqpn);
+	return MLX5_CAP_GEN(mdev, set_deth_sqpn);
 }
 
 /* Call with gsi->lock locked */
@@ -89,15 +89,15 @@ int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 		       struct ib_qp_init_attr *attr)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_gsi_qp *gsi;
 	struct ib_qp_init_attr hw_init_attr = *attr;
 	const u8 port_num = attr->port_num;
 	int num_qps = 0;
 	int ret;
 
-	if (mlx5_ib_deth_sqpn_cap(dev)) {
-		if (MLX5_CAP_GEN(dev->mdev,
-				 port_type) == MLX5_CAP_PORT_TYPE_IB)
+	if (mlx5_ib_deth_sqpn_cap(mdev)) {
+		if (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_IB)
 			num_qps = pd->device->attrs.max_pkeys;
 		else if (dev->lag_active)
 			num_qps = dev->lag_ports;
@@ -268,7 +268,8 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 	u16 pkey;
 	int ret;
 
-	if (MLX5_CAP_GEN(dev->mdev,  port_type) != MLX5_CAP_PORT_TYPE_IB)
+	if (MLX5_CAP_GEN(qp_to_mdev(gsi->rx_qp), port_type) !=
+	    MLX5_CAP_PORT_TYPE_IB)
 		pkey_index = 0;
 
 	ret = ib_query_pkey(device, gsi->port_num, pkey_index, &pkey);
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 244c22bc09086a2af06d3090e3501a48b539b742..4796eb51bf540792f4046dc6180415cfcbb9177b 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -314,7 +314,8 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
 						   u32 port)
 {
-	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
+	struct mlx5_core_dev *mdev = qp_to_mdev(sq->base.container_mibqp);
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 	struct mlx5_eswitch_rep *rep;
 
 	if (!dev->is_rep || !port)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 109b305559b37ee26bf9e46999e8b7bb60727828..90d19c49bc00bc3d53b5f30d2f87ef062dcd6406 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2311,7 +2311,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	context->lib_caps = req.lib_caps;
 	print_lib_caps(dev, context->lib_caps);
 
-	if (mlx5_ib_lag_should_assign_affinity(dev)) {
+	if (mlx5_ib_lag_should_assign_affinity(dev, dev->mdev)) {
 		u32 port = mlx5_core_native_port_num(dev->mdev) - 1;
 
 		atomic_set(&context->tx_port_affinity,
@@ -2844,7 +2844,7 @@ static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5_cmd_attach_mcg(dev->mdev, gid, ibqp->qp_num, uid);
+	err = mlx5_cmd_attach_mcg(qp_to_mdev(ibqp), gid, ibqp->qp_num, uid);
 	if (err)
 		mlx5_ib_warn(dev, "failed attaching QPN 0x%x, MGID %pI6\n",
 			     ibqp->qp_num, gid->raw);
@@ -2860,7 +2860,7 @@ static int mlx5_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
 	uid = ibqp->pd ?
 		to_mpd(ibqp->pd)->uid : 0;
-	err = mlx5_cmd_detach_mcg(dev->mdev, gid, ibqp->qp_num, uid);
+	err = mlx5_cmd_detach_mcg(qp_to_mdev(ibqp), gid, ibqp->qp_num, uid);
 	if (err)
 		mlx5_ib_warn(dev, "failed detaching QPN 0x%x, MGID %pI6\n",
 			     ibqp->qp_num, gid->raw);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 36340c4aaee84b56df42b136cfbd201025cd0f38..a4948e3556597af569c91b1dfc828e0dcb8d05a6 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1688,7 +1688,9 @@ static inline void mlx5r_deref_wait_odp_mkey(struct mlx5_ib_mkey *mmkey)
 	wait_event(mmkey->wait, refcount_read(&mmkey->usecount) == 0);
 }
 
-static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
+static inline bool
+mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev,
+				   struct mlx5_core_dev *mdev)
 {
 	/*
 	 * If the driver is in hash mode and the port_select_flow_table_bypass cap
@@ -1698,16 +1700,16 @@ static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 	 * the port affinity by default.
 	 */
 	if (dev->lag_active &&
-	    mlx5_lag_mode_is_hash(dev->mdev) &&
-	    MLX5_CAP_PORT_SELECTION(dev->mdev, port_select_flow_table_bypass))
+	    mlx5_lag_mode_is_hash(mdev) &&
+	    MLX5_CAP_PORT_SELECTION(mdev, port_select_flow_table_bypass))
 		return 0;
 
-	if (mlx5_lag_is_lacp_owner(dev->mdev) && !dev->lag_active)
+	if (mlx5_lag_is_lacp_owner(mdev) && !dev->lag_active)
 		return 0;
 
 	return dev->lag_active ||
-		(MLX5_CAP_GEN(dev->mdev, num_lag_ports) > 1 &&
-		 MLX5_CAP_GEN(dev->mdev, lag_tx_port_affinity));
+		(MLX5_CAP_GEN(mdev, num_lag_ports) > 1 &&
+		 MLX5_CAP_GEN(mdev, lag_tx_port_affinity));
 }
 
 static inline bool rt_supported(int ts_cap)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index c6ad1621ce67a3e2f5859193738050ed1edebab6..be0b3437eb86329edb66bb8fc6d0dfdd8c18f8dd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -443,11 +443,12 @@ static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
 static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 		       int has_rq, struct mlx5_ib_qp *qp, struct mlx5_ib_create_qp *ucmd)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int wqe_size;
 	int wq_size;
 
 	/* Sanity check RQ size before proceeding */
-	if (cap->max_recv_wr > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz)))
+	if (cap->max_recv_wr > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz)))
 		return -EINVAL;
 
 	if (!has_rq) {
@@ -479,10 +480,10 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 			wq_size = roundup_pow_of_two(cap->max_recv_wr) * wqe_size;
 			wq_size = max_t(int, wq_size, MLX5_SEND_WQE_BB);
 			qp->rq.wqe_cnt = wq_size / wqe_size;
-			if (wqe_size > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq)) {
+			if (wqe_size > MLX5_CAP_GEN(mdev, max_wqe_sz_rq)) {
 				mlx5_ib_dbg(dev, "wqe_size %d, max %d\n",
 					    wqe_size,
-					    MLX5_CAP_GEN(dev->mdev,
+					    MLX5_CAP_GEN(mdev,
 							 max_wqe_sz_rq));
 				return -EINVAL;
 			}
@@ -598,6 +599,7 @@ static int get_send_sge(struct ib_qp_init_attr *attr, int wqe_size)
 static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 			struct mlx5_ib_qp *qp)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int wqe_size;
 	int wq_size;
 
@@ -609,9 +611,9 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	if (wqe_size < 0)
 		return wqe_size;
 
-	if (wqe_size > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
+	if (wqe_size > MLX5_CAP_GEN(mdev, max_wqe_sz_sq)) {
 		mlx5_ib_dbg(dev, "wqe_size(%d) > max_sq_desc_sz(%d)\n",
-			    wqe_size, MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq));
+			    wqe_size, MLX5_CAP_GEN(mdev, max_wqe_sz_sq));
 		return -EINVAL;
 	}
 
@@ -621,11 +623,11 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 
 	wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size);
 	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
-	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz))) {
+	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz))) {
 		mlx5_ib_dbg(dev, "send queue size (%d * %d / %d -> %d) exceeds limits(%d)\n",
 			    attr->cap.max_send_wr, wqe_size, MLX5_SEND_WQE_BB,
 			    qp->sq.wqe_cnt,
-			    1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz));
+			    1 << MLX5_CAP_GEN(mdev, log_max_qp_sz));
 		return -ENOMEM;
 	}
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
@@ -646,12 +648,13 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct mlx5_ib_qp_base *base,
 			    struct ib_qp_init_attr *attr)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int desc_sz = 1 << qp->sq.wqe_shift;
 	int rq_buf_size, sq_buf_size;
 
-	if (desc_sz > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
+	if (desc_sz > MLX5_CAP_GEN(mdev, max_wqe_sz_sq)) {
 		mlx5_ib_warn(dev, "desc_sz %d, max_sq_desc_sz %d\n",
-			     desc_sz, MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq));
+			     desc_sz, MLX5_CAP_GEN(mdev, max_wqe_sz_sq));
 		return -EINVAL;
 	}
 
@@ -663,10 +666,10 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
 	qp->sq.wqe_cnt = ucmd->sq_wqe_count;
 
-	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz))) {
+	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz))) {
 		mlx5_ib_warn(dev, "wqe_cnt %d, max_wqes %d\n",
 			     qp->sq.wqe_cnt,
-			     1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz));
+			     1 << MLX5_CAP_GEN(mdev, log_max_qp_sz));
 		return -EINVAL;
 	}
 
@@ -1100,6 +1103,7 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 static void destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		       struct mlx5_ib_qp_base *base, struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_ucontext *context = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
 
@@ -1124,9 +1128,9 @@ static void destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	kvfree(qp->sq.wr_data);
 	kvfree(qp->rq.wrid);
 	if (qp->db.db)
-		mlx5_db_free(dev->mdev, &qp->db);
+		mlx5_db_free(mdev, &qp->db);
 	if (qp->buf.frags)
-		mlx5_frag_buf_free(dev->mdev, &qp->buf);
+		mlx5_frag_buf_free(mdev, &qp->buf);
 }
 
 static int _create_kernel_qp(struct mlx5_ib_dev *dev,
@@ -1134,6 +1138,7 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 			     struct mlx5_ib_qp *qp, u32 **in, int *inlen,
 			     struct mlx5_ib_qp_base *base)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int uar_index;
 	void *qpc;
 	int err;
@@ -1147,7 +1152,7 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 	/* We need to divide by two since each register is comprised of
 	 * two buffers of identical size, namely odd and even
 	 */
-	qp->bf.buf_size = (1 << MLX5_CAP_GEN(dev->mdev, log_bf_reg_size)) / 2;
+	qp->bf.buf_size = (1 << MLX5_CAP_GEN(mdev, log_bf_reg_size)) / 2;
 	uar_index = qp->bf.bfreg->index;
 
 	err = calc_sq_size(dev, init_attr, qp);
@@ -1160,8 +1165,8 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
 	base->ubuffer.buf_size = err + (qp->rq.wqe_cnt << qp->rq.wqe_shift);
 
-	err = mlx5_frag_buf_alloc_node(dev->mdev, base->ubuffer.buf_size,
-				       &qp->buf, dev->mdev->priv.numa_node);
+	err = mlx5_frag_buf_alloc_node(mdev, base->ubuffer.buf_size,
+				       &qp->buf, mdev->priv.numa_node);
 	if (err) {
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		return err;
@@ -1193,7 +1198,7 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 
 	qpc = MLX5_ADDR_OF(create_qp_in, *in, qpc);
 	MLX5_SET(qpc, qpc, uar_page, uar_index);
-	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(dev->mdev));
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(mdev));
 	MLX5_SET(qpc, qpc, log_page_size, qp->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
 
 	/* Set "fast registration enabled" for all kernel QPs */
@@ -1207,7 +1212,7 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 				  (__be64 *)MLX5_ADDR_OF(create_qp_in,
 							 *in, pas));
 
-	err = mlx5_db_alloc(dev->mdev, &qp->db);
+	err = mlx5_db_alloc(mdev, &qp->db);
 	if (err) {
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		goto err_free;
@@ -1233,13 +1238,13 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 	kvfree(qp->sq.wrid);
 	kvfree(qp->sq.wr_data);
 	kvfree(qp->rq.wrid);
-	mlx5_db_free(dev->mdev, &qp->db);
+	mlx5_db_free(mdev, &qp->db);
 
 err_free:
 	kvfree(*in);
 
 err_buf:
-	mlx5_frag_buf_free(dev->mdev, &qp->buf);
+	mlx5_frag_buf_free(mdev, &qp->buf);
 	return err;
 }
 
@@ -1259,24 +1264,24 @@ static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_sq *sq, u32 tdn,
 				    struct ib_pd *pd)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
 	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
 	MLX5_SET(create_tis_in, in, uid, to_mpd(pd)->uid);
 	MLX5_SET(tisc, tisc, transport_domain, tdn);
-	if (!mlx5_ib_lag_should_assign_affinity(dev) &&
-	    mlx5_lag_is_lacp_owner(dev->mdev))
+	if (!mlx5_ib_lag_should_assign_affinity(dev, mdev) &&
+	    mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
 	if (qp->flags & IB_QP_CREATE_SOURCE_QPN)
 		MLX5_SET(tisc, tisc, underlay_qpn, qp->underlay_qpn);
 
-	return mlx5_core_create_tis(dev->mdev, in, &sq->tisn);
+	return mlx5_core_create_tis(mdev, in, &sq->tisn);
 }
 
-static void destroy_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
-				      struct mlx5_ib_sq *sq, struct ib_pd *pd)
+static void destroy_raw_packet_qp_tis(struct mlx5_ib_sq *sq, struct ib_pd *pd)
 {
-	mlx5_cmd_destroy_tis(dev->mdev, sq->tisn, to_mpd(pd)->uid);
+	mlx5_cmd_destroy_tis(pd_to_mdev(pd), sq->tisn, to_mpd(pd)->uid);
 }
 
 static void destroy_flow_rule_vport_sq(struct mlx5_ib_sq *sq)
@@ -1292,9 +1297,10 @@ static bool fr_supported(int ts_cap)
 	       ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
 }
 
-static int get_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
-			 bool fr_sup, bool rt_sup)
+static int get_ts_format(struct mlx5_ib_cq *cq, bool fr_sup, bool rt_sup)
 {
+	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
+
 	if (cq->private_flags & MLX5_IB_CQ_PR_FLAGS_REAL_TIME_TS) {
 		if (!rt_sup) {
 			mlx5_ib_dbg(dev,
@@ -1315,35 +1321,37 @@ static int get_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 			MLX5_TIMESTAMP_FORMAT_DEFAULT;
 }
 
-static int get_rq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *recv_cq)
+static int get_rq_ts_format(struct mlx5_core_dev *mdev,
+			    struct mlx5_ib_cq *recv_cq)
 {
-	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, rq_ts_format);
+	u8 ts_cap = MLX5_CAP_GEN(mdev, rq_ts_format);
 
-	return get_ts_format(dev, recv_cq, fr_supported(ts_cap),
+	return get_ts_format(recv_cq, fr_supported(ts_cap),
 			     rt_supported(ts_cap));
 }
 
-static int get_sq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
+static int get_sq_ts_format(struct mlx5_core_dev *mdev,
+			    struct mlx5_ib_cq *send_cq)
 {
-	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, sq_ts_format);
+	u8 ts_cap = MLX5_CAP_GEN(mdev, sq_ts_format);
 
-	return get_ts_format(dev, send_cq, fr_supported(ts_cap),
+	return get_ts_format(send_cq, fr_supported(ts_cap),
 			     rt_supported(ts_cap));
 }
 
-static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
+static int get_qp_ts_format(struct mlx5_ib_qp *qp, struct mlx5_ib_cq *send_cq,
 			    struct mlx5_ib_cq *recv_cq)
 {
-	u8 ts_cap = MLX5_CAP_ROCE(dev->mdev, qp_ts_format);
+	u8 ts_cap = MLX5_CAP_ROCE(qp_to_mdev(qp), qp_ts_format);
 	bool fr_sup = fr_supported(ts_cap);
 	bool rt_sup = rt_supported(ts_cap);
 	u8 default_ts = fr_sup ? MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
 				 MLX5_TIMESTAMP_FORMAT_DEFAULT;
 	int send_ts_format =
-		send_cq ? get_ts_format(dev, send_cq, fr_sup, rt_sup) :
+		send_cq ? get_ts_format(send_cq, fr_sup, rt_sup) :
 			  default_ts;
 	int recv_ts_format =
-		recv_cq ? get_ts_format(dev, recv_cq, fr_sup, rt_sup) :
+		recv_cq ? get_ts_format(recv_cq, fr_sup, rt_sup) :
 			  default_ts;
 
 	if (send_ts_format < 0 || recv_ts_format < 0)
@@ -1353,7 +1361,7 @@ static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
 	    recv_ts_format != MLX5_TIMESTAMP_FORMAT_DEFAULT &&
 	    send_ts_format != recv_ts_format) {
 		mlx5_ib_dbg(
-			dev,
+			to_dev(qp->ibqp.device),
 			"The send ts_format does not match the receive ts_format\n");
 		return -EOPNOTSUPP;
 	}
@@ -1367,6 +1375,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 				   struct mlx5_ib_sq *sq, void *qpin,
 				   struct ib_pd *pd, struct mlx5_ib_cq *cq)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_ubuffer *ubuffer = &sq->ubuffer;
 	__be64 *pas;
 	void *in;
@@ -1379,7 +1388,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	unsigned long page_size;
 	int ts_format;
 
-	ts_format = get_sq_ts_format(dev, cq);
+	ts_format = get_sq_ts_format(mdev, cq);
 	if (ts_format < 0)
 		return ts_format;
 
@@ -1409,7 +1418,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	MLX5_SET(create_sq_in, in, uid, to_mpd(pd)->uid);
 	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 	MLX5_SET(sqc, sqc, flush_in_error_en, 1);
-	if (MLX5_CAP_ETH(dev->mdev, multi_pkt_send_wqe))
+	if (MLX5_CAP_ETH(mdev, multi_pkt_send_wqe))
 		MLX5_SET(sqc, sqc, allow_multi_pkt_send_wqe, 1);
 	MLX5_SET(sqc, sqc, state, MLX5_SQC_STATE_RST);
 	MLX5_SET(sqc, sqc, ts_format, ts_format);
@@ -1417,8 +1426,8 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	MLX5_SET(sqc, sqc, cqn, MLX5_GET(qpc, qpc, cqn_snd));
 	MLX5_SET(sqc, sqc, tis_lst_sz, 1);
 	MLX5_SET(sqc, sqc, tis_num_0, sq->tisn);
-	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-	    MLX5_CAP_ETH(dev->mdev, swp))
+	if (MLX5_CAP_GEN(mdev, eth_net_offloads) &&
+	    MLX5_CAP_ETH(mdev, swp))
 		MLX5_SET(sqc, sqc, allow_swp, 1);
 
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
@@ -1458,8 +1467,7 @@ static void destroy_raw_packet_qp_sq(struct ib_pd *pd, struct mlx5_ib_sq *sq)
 	ib_umem_release(sq->ubuffer.umem);
 }
 
-static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
-				   struct mlx5_ib_rq *rq, void *qpin,
+static int create_raw_packet_qp_rq(struct mlx5_ib_rq *rq, void *qpin,
 				   struct ib_pd *pd, struct mlx5_ib_cq *cq)
 {
 	struct mlx5_ib_qp *mqp = rq->base.container_mibqp;
@@ -1475,7 +1483,7 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	size_t inlen;
 	int err;
 
-	ts_format = get_rq_ts_format(dev, cq);
+	ts_format = get_rq_ts_format(pd_to_mdev(pd), cq);
 	if (ts_format < 0)
 		return ts_format;
 
@@ -1541,7 +1549,7 @@ static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 	if (qp_flags_en & (MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC |
 			   MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC))
 		mlx5_ib_disable_lb(dev, false, true);
-	mlx5_cmd_destroy_tir(dev->mdev, rq->tirn, to_mpd(pd)->uid);
+	mlx5_cmd_destroy_tir(pd_to_mdev(pd), rq->tirn, to_mpd(pd)->uid);
 }
 
 static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
@@ -1549,6 +1557,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 				    u32 *qp_flags_en, struct ib_pd *pd,
 				    u32 *out)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	u8 lb_flag = 0;
 	u32 *in;
 	void *tirc;
@@ -1581,7 +1590,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 
 	MLX5_SET(tirc, tirc, self_lb_block, lb_flag);
 	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
-	err = mlx5_cmd_exec_inout(dev->mdev, create_tir, in, out);
+	err = mlx5_cmd_exec_inout(mdev, create_tir, in, out);
 	rq->tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
 		err = mlx5_ib_enable_lb(dev, false, true);
@@ -1646,7 +1655,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
 		if (qp->flags & IB_QP_CREATE_PCI_WRITE_END_PADDING)
 			rq->flags |= MLX5_IB_RQ_PCI_WRITE_END_PADDING;
-		err = create_raw_packet_qp_rq(dev, rq, in, pd,
+		err = create_raw_packet_qp_rq(rq, in, pd,
 					      to_mcq(init_attr->recv_cq));
 		if (err)
 			goto err_destroy_sq;
@@ -1661,8 +1670,10 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_RQN;
 			resp->tirn = rq->tirn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
-			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
-			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2)) {
+			if (MLX5_CAP_FLOWTABLE_NIC_RX(pd_to_mdev(pd),
+						      sw_owner) ||
+			    MLX5_CAP_FLOWTABLE_NIC_RX(pd_to_mdev(pd),
+						      sw_owner_v2)) {
 				resp->tir_icm_addr = MLX5_GET(
 					create_tir_out, out, icm_address_31_0);
 				resp->tir_icm_addr |=
@@ -1690,7 +1701,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return err;
 	destroy_raw_packet_qp_sq(pd, sq);
 err_destroy_tis:
-	destroy_raw_packet_qp_tis(dev, sq, pd);
+	destroy_raw_packet_qp_tis(sq, pd);
 
 	return err;
 }
@@ -1709,7 +1720,7 @@ static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
 
 	if (qp->sq.wqe_cnt) {
 		destroy_raw_packet_qp_sq(qp->ibqp.pd, sq);
-		destroy_raw_packet_qp_tis(dev, sq, qp->ibqp.pd);
+		destroy_raw_packet_qp_tis(sq, qp->ibqp.pd);
 	}
 }
 
@@ -1727,10 +1738,11 @@ static void raw_packet_qp_copy_info(struct mlx5_ib_qp *qp,
 
 static void destroy_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	if (qp->flags_en & (MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC |
 			    MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC))
 		mlx5_ib_disable_lb(dev, false, true);
-	mlx5_cmd_destroy_tir(dev->mdev, qp->rss_qp.tirn,
+	mlx5_cmd_destroy_tir(mdev, qp->rss_qp.tirn,
 			     to_mpd(qp->ibqp.pd)->uid);
 }
 
@@ -1751,6 +1763,7 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 				 struct mlx5_ib_qp *qp,
 				 struct mlx5_create_qp_params *params)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct ib_qp_init_attr *init_attr = params->attr;
 	struct mlx5_ib_create_qp_rss *ucmd = params->ucmd;
 	struct ib_udata *udata = params->udata;
@@ -1908,14 +1921,14 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 create_tir:
 	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
-	err = mlx5_cmd_exec_inout(dev->mdev, create_tir, in, out);
+	err = mlx5_cmd_exec_inout(mdev, create_tir, in, out);
 
 	qp->rss_qp.tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
 		err = mlx5_ib_enable_lb(dev, false, true);
 
 		if (err)
-			mlx5_cmd_destroy_tir(dev->mdev, qp->rss_qp.tirn,
+			mlx5_cmd_destroy_tir(mdev, qp->rss_qp.tirn,
 					     to_mpd(pd)->uid);
 	}
 
@@ -1925,8 +1938,8 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (mucontext->devx_uid) {
 		params->resp.comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
 		params->resp.tirn = qp->rss_qp.tirn;
-		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
-		    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2)) {
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner) ||
+		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner_v2)) {
 			params->resp.tir_icm_addr =
 				MLX5_GET(create_tir_out, out, icm_address_31_0);
 			params->resp.tir_icm_addr |=
@@ -1953,11 +1966,11 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	return err;
 }
 
-static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
-					 struct mlx5_ib_qp *qp,
+static void configure_requester_scat_cqe(struct mlx5_ib_qp *qp,
 					 struct ib_qp_init_attr *init_attr,
 					 void *qpc)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int scqe_sz;
 	bool allow_scat_cqe = false;
 
@@ -1973,7 +1986,7 @@ static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
 	}
 
 	if (init_attr->qp_type != MLX5_IB_QPT_DCI ||
-	    MLX5_CAP_GEN(dev->mdev, dc_req_scat_data_cqe))
+	    MLX5_CAP_GEN(mdev, dc_req_scat_data_cqe))
 		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
 }
 
@@ -1996,11 +2009,11 @@ static int atomic_size_to_mode(int size_mask)
 	return MLX5_ATOMIC_MODE_8B;
 }
 
-static int get_atomic_mode(struct mlx5_ib_dev *dev,
-			   struct mlx5_ib_qp *qp)
+static int get_atomic_mode(struct mlx5_ib_qp *qp)
 {
-	u8 atomic_operations = MLX5_CAP_ATOMIC(dev->mdev, atomic_operations);
-	u8 atomic = MLX5_CAP_GEN(dev->mdev, atomic);
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
+	u8 atomic_operations = MLX5_CAP_ATOMIC(mdev, atomic_operations);
+	u8 atomic = MLX5_CAP_GEN(mdev, atomic);
 	int atomic_mode = -EOPNOTSUPP;
 	int atomic_size_mask;
 
@@ -2008,9 +2021,9 @@ static int get_atomic_mode(struct mlx5_ib_dev *dev,
 		return -EOPNOTSUPP;
 
 	if (qp->type == MLX5_IB_QPT_DCT)
-		atomic_size_mask = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_dc);
+		atomic_size_mask = MLX5_CAP_ATOMIC(mdev, atomic_size_dc);
 	else
-		atomic_size_mask = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_qp);
+		atomic_size_mask = MLX5_CAP_ATOMIC(mdev, atomic_size_qp);
 
 	if ((atomic_operations & MLX5_ATOMIC_OPS_EXTENDED_CMP_SWAP) ||
 	    (atomic_operations & MLX5_ATOMIC_OPS_EXTENDED_FETCH_ADD))
@@ -2036,7 +2049,7 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	struct mlx5_ib_resources *devr = &dev->devr;
 	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_qp_base *base;
 	unsigned long flags;
 	void *qpc;
@@ -2065,7 +2078,7 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->flags & IB_QP_CREATE_MANAGED_RECV)
 		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
 
-	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(dev->mdev));
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(mdev));
 	MLX5_SET(qpc, qpc, rq_type, MLX5_SRQ_RQ);
 	MLX5_SET(qpc, qpc, no_sq, 1);
 	MLX5_SET(qpc, qpc, cqn_rcv, to_mcq(devr->c0)->mcq.cqn);
@@ -2115,7 +2128,7 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_cq *send_cq;
 	struct mlx5_ib_cq *recv_cq;
 	unsigned long flags;
@@ -2152,7 +2165,7 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (ucmd->sq_wqe_count > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz)))
 		return -EINVAL;
 
-	ts_format = get_qp_ts_format(dev, to_mcq(init_attr->send_cq),
+	ts_format = get_qp_ts_format(qp, to_mcq(init_attr->send_cq),
 				     to_mcq(init_attr->recv_cq));
 
 	if (ts_format < 0)
@@ -2179,7 +2192,7 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (qp->flags & IB_QP_CREATE_MANAGED_SEND)
 		MLX5_SET(qpc, qpc, cd_slave_send, 1);
 	if (qp->flags_en & MLX5_QP_FLAG_SCATTER_CQE)
-		configure_requester_scat_cqe(dev, qp, init_attr, qpc);
+		configure_requester_scat_cqe(qp, init_attr, qpc);
 
 	if (qp->rq.wqe_cnt) {
 		MLX5_SET(qpc, qpc, log_rq_stride, qp->rq.wqe_shift - 4);
@@ -2276,7 +2289,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_cq *send_cq;
 	struct mlx5_ib_cq *recv_cq;
 	unsigned long flags;
@@ -2320,7 +2333,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		return -EINVAL;
 
 	if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
-		ts_format = get_qp_ts_format(dev, to_mcq(init_attr->send_cq),
+		ts_format = get_qp_ts_format(qp, to_mcq(init_attr->send_cq),
 					     to_mcq(init_attr->recv_cq));
 		if (ts_format < 0)
 			return ts_format;
@@ -2367,7 +2380,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	}
 	if ((qp->flags_en & MLX5_QP_FLAG_SCATTER_CQE) &&
 	    (qp->type == MLX5_IB_QPT_DCI || qp->type == IB_QPT_RC))
-		configure_requester_scat_cqe(dev, qp, init_attr, qpc);
+		configure_requester_scat_cqe(qp, init_attr, qpc);
 
 	if (qp->rq.wqe_cnt) {
 		MLX5_SET(qpc, qpc, log_rq_stride, qp->rq.wqe_shift - 4);
@@ -2478,7 +2491,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	struct mlx5_ib_resources *devr = &dev->devr;
 	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_cq *send_cq;
 	struct mlx5_ib_cq *recv_cq;
 	unsigned long flags;
@@ -2698,6 +2711,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			      struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_cq *send_cq, *recv_cq;
 	struct mlx5_ib_qp_base *base;
 	unsigned long flags;
@@ -2762,7 +2776,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			mlx5_ib_warn(dev, "failed to destroy QP 0x%x\n",
 				     base->mqp.qpn);
 		if (qp->rl.rate) {
-			mlx5_rl_remove_rate(dev->mdev, &qp->rl);
+			mlx5_rl_remove_rate(mdev, &qp->rl);
 			memset(&qp->rl, 0, sizeof(qp->rl));
 		}
 	}
@@ -2770,16 +2784,17 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	destroy_qp(dev, qp, base, udata);
 }
 
-static int create_dct(struct mlx5_ib_dev *dev, struct ib_pd *pd,
+static int create_dct(struct ib_pd *pd,
 		      struct mlx5_ib_qp *qp,
 		      struct mlx5_create_qp_params *params)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct ib_qp_init_attr *attr = params->attr;
 	struct mlx5_ib_create_qp *ucmd = params->ucmd;
 	u32 uidx = params->uidx;
 	void *dctc;
 
-	if (mlx5_lag_is_active(dev->mdev) && !MLX5_CAP_GEN(dev->mdev, lag_dct))
+	if (mlx5_lag_is_active(mdev) && !MLX5_CAP_GEN(mdev, lag_dct))
 		return -EOPNOTSUPP;
 
 	qp->dct.in = kzalloc(MLX5_ST_SZ_BYTES(create_dct_in), GFP_KERNEL);
@@ -2793,7 +2808,7 @@ static int create_dct(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	MLX5_SET(dctc, dctc, cqn, to_mcq(attr->recv_cq)->mcq.cqn);
 	MLX5_SET64(dctc, dctc, dc_access_key, ucmd->access_key);
 	MLX5_SET(dctc, dctc, user_index, uidx);
-	if (MLX5_CAP_GEN(dev->mdev, ece_support))
+	if (MLX5_CAP_GEN(mdev, ece_support))
 		MLX5_SET(dctc, dctc, ece, ucmd->ece_options);
 
 	if (qp->flags_en & MLX5_QP_FLAG_SCATTER_CQE) {
@@ -2807,16 +2822,19 @@ static int create_dct(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	return 0;
 }
 
-static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
+static int check_qp_type(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 			 enum ib_qp_type *type)
 {
-	if (attr->qp_type == IB_QPT_DRIVER && !MLX5_CAP_GEN(dev->mdev, dct))
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
+
+	if (attr->qp_type == IB_QPT_DRIVER && !MLX5_CAP_GEN(mdev, dct))
 		goto out;
 
 	switch (attr->qp_type) {
 	case IB_QPT_XRC_TGT:
 	case IB_QPT_XRC_INI:
-		if (!MLX5_CAP_GEN(dev->mdev, xrc))
+		if (!MLX5_CAP_GEN(mdev, xrc))
 			goto out;
 		fallthrough;
 	case IB_QPT_RC:
@@ -2939,7 +2957,7 @@ static void process_vendor_flag(struct mlx5_ib_dev *dev, int *flags, int flag,
 static int process_vendor_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				void *ucmd, struct ib_qp_init_attr *attr)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	bool cond;
 	int flags;
 
@@ -3033,7 +3051,7 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				struct ib_qp_init_attr *attr)
 {
 	enum ib_qp_type qp_type = qp->type;
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int create_flags = attr->create_flags;
 	bool cond;
 
@@ -3044,7 +3062,7 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return (create_flags) ? -EINVAL : 0;
 
 	process_create_flag(dev, &create_flags, IB_QP_CREATE_NETIF_QP,
-			    mlx5_get_flow_namespace(dev->mdev,
+			    mlx5_get_flow_namespace(mdev,
 						    MLX5_FLOW_NAMESPACE_BYPASS),
 			    qp);
 	process_create_flag(dev, &create_flags,
@@ -3155,7 +3173,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	switch (qp->type) {
 	case MLX5_IB_QPT_DCT:
 		rdma_restrack_no_track(&qp->ibqp.res);
-		err = create_dct(dev, pd, qp, params);
+		err = create_dct(pd, qp, params);
 		break;
 	case MLX5_IB_QPT_DCI:
 		err = create_dci(dev, pd, qp, params);
@@ -3310,7 +3328,7 @@ int mlx5_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	if (err)
 		return err;
 
-	err = check_qp_type(dev, attr, &type);
+	err = check_qp_type(ibqp, attr, &type);
 	if (err)
 		return err;
 
@@ -3416,7 +3434,6 @@ static int set_qpc_atomic_flags(struct mlx5_ib_qp *qp,
 				const struct ib_qp_attr *attr, int attr_mask,
 				void *qpc)
 {
-	struct mlx5_ib_dev *dev = to_dev(qp->ibqp.device);
 	u8 dest_rd_atomic;
 	u32 access_flags;
 
@@ -3438,7 +3455,7 @@ static int set_qpc_atomic_flags(struct mlx5_ib_qp *qp,
 	if (access_flags & IB_ACCESS_REMOTE_ATOMIC) {
 		int atomic_mode;
 
-		atomic_mode = get_atomic_mode(dev, qp);
+		atomic_mode = get_atomic_mode(qp);
 		if (atomic_mode < 0)
 			return -EOPNOTSUPP;
 
@@ -3512,8 +3529,7 @@ int mlx5r_ib_rate(struct mlx5_core_dev *mdev, u8 rate)
 	return ib_to_mlx5_rate_map(rate);
 }
 
-static int modify_raw_packet_eth_prio(struct mlx5_core_dev *mdev,
-				      struct mlx5_ib_sq *sq, u8 sl,
+static int modify_raw_packet_eth_prio(struct mlx5_ib_sq *sq, u8 sl,
 				      struct ib_pd *pd)
 {
 	void *in;
@@ -3532,15 +3548,14 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *mdev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
 
-	err = mlx5_core_modify_tis(mdev, sq->tisn, in);
+	err = mlx5_core_modify_tis(pd_to_mdev(pd), sq->tisn, in);
 
 	kvfree(in);
 
 	return err;
 }
 
-static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *mdev,
-					 struct mlx5_ib_sq *sq, u8 tx_affinity,
+static int modify_raw_packet_tx_affinity(struct mlx5_ib_sq *sq, u8 tx_affinity,
 					 struct ib_pd *pd)
 {
 	void *in;
@@ -3559,7 +3574,7 @@ static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *mdev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, lag_tx_port_affinity, tx_affinity);
 
-	err = mlx5_core_modify_tis(mdev, sq->tisn, in);
+	err = mlx5_core_modify_tis(pd_to_mdev(pd), sq->tisn, in);
 
 	kvfree(in);
 
@@ -3655,8 +3670,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 alt ? attr->alt_timeout : attr->timeout);
 
 	if ((qp->type == IB_QPT_RAW_PACKET) && qp->sq.wqe_cnt)
-		return modify_raw_packet_eth_prio(dev->mdev,
-						  &qp->raw_packet_qp.sq,
+		return modify_raw_packet_eth_prio(&qp->raw_packet_qp.sq,
 						  sl & 0xf, qp->ibqp.pd);
 
 	return 0;
@@ -3851,6 +3865,7 @@ static int modify_raw_packet_qp_rq(
 	struct mlx5_ib_dev *dev, struct mlx5_ib_rq *rq, int new_state,
 	const struct mlx5_modify_raw_qp_param *raw_qp_param, struct ib_pd *pd)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	void *in;
 	void *rqc;
 	int inlen;
@@ -3868,7 +3883,7 @@ static int modify_raw_packet_qp_rq(
 	MLX5_SET(rqc, rqc, state, new_state);
 
 	if (raw_qp_param->set_mask & MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID) {
-		if (MLX5_CAP_GEN(dev->mdev, modify_rq_counter_set_id)) {
+		if (MLX5_CAP_GEN(mdev, modify_rq_counter_set_id)) {
 			MLX5_SET64(modify_rq_in, in, modify_bitmask,
 				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
 			MLX5_SET(rqc, rqc, counter_set_id, raw_qp_param->rq_q_ctr_id);
@@ -3878,7 +3893,7 @@ static int modify_raw_packet_qp_rq(
 				"RAW PACKET QP counters are not supported on current FW\n");
 	}
 
-	err = mlx5_core_modify_rq(dev->mdev, rq->base.mqp.qpn, in);
+	err = mlx5_core_modify_rq(mdev, rq->base.mqp.qpn, in);
 	if (err)
 		goto out;
 
@@ -3889,43 +3904,45 @@ static int modify_raw_packet_qp_rq(
 	return err;
 }
 
-static bool qp_rate_limit_supported(struct mlx5_ib_dev *dev,
-				    struct mlx5_ib_qp *qp)
+static bool qp_rate_limit_supported(struct mlx5_ib_qp *qp)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
+
 	if (qp->type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN)
 		return true;
 
 	if (qp->type == IB_QPT_UD)
-		return MLX5_CAP_QOS(dev->mdev, packet_pacing_req_ud);
+		return MLX5_CAP_QOS(mdev, packet_pacing_req_ud);
 
 	if (qp->type == IB_QPT_UC)
-		return MLX5_CAP_QOS(dev->mdev, packet_pacing_req_uc);
+		return MLX5_CAP_QOS(mdev, packet_pacing_req_uc);
 
 	return false;
 }
 
-static int qp_rl_parse(struct mlx5_ib_dev *dev,
-		       struct mlx5_ib_qp *qp,
+static int qp_rl_parse(struct mlx5_ib_qp *qp,
 		       const struct ib_qp_attr *attr,
 		       const struct mlx5_ib_modify_qp *ucmd,
 		       struct mlx5_rate_limit *rl_desired)
 {
-	if (!qp_rate_limit_supported(dev, qp))
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
+
+	if (!qp_rate_limit_supported(qp))
 		return -EOPNOTSUPP;
 
 	rl_desired->rate = attr->rate_limit;
 
 	if (ucmd->burst_info.max_burst_sz) {
 		if (!attr->rate_limit ||
-		    !MLX5_CAP_QOS(dev->mdev, packet_pacing_burst_bound))
+		    !MLX5_CAP_QOS(mdev, packet_pacing_burst_bound))
 			return -EINVAL;
 		rl_desired->max_burst_sz = ucmd->burst_info.max_burst_sz;
 	}
 
 	if (ucmd->burst_info.typical_pkt_sz) {
 		if (!attr->rate_limit ||
-		    !MLX5_CAP_QOS(dev->mdev, packet_pacing_typical_size))
+		    !MLX5_CAP_QOS(mdev, packet_pacing_typical_size))
 			return -EINVAL;
 		rl_desired->typical_pkt_sz = ucmd->burst_info.typical_pkt_sz;
 	}
@@ -3933,10 +3950,10 @@ static int qp_rl_parse(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static int qp_rl_prepare(struct mlx5_ib_dev *dev,
-			 struct mlx5_ib_qp *qp, u16 op,
+static int qp_rl_prepare(struct mlx5_ib_qp *qp, u16 op,
 			 struct mlx5_rate_limit_ctx *ctx)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	int err;
 
 	ctx->rl_old = qp->rl;
@@ -3951,7 +3968,7 @@ static int qp_rl_prepare(struct mlx5_ib_dev *dev,
 	ctx->rl_changed = true;
 
 	if (ctx->rl_desired.rate) {
-		err = mlx5_rl_add_rate(dev->mdev, &ctx->rl_desired_index,
+		err = mlx5_rl_add_rate(mdev, &ctx->rl_desired_index,
 				       &ctx->rl_desired);
 		if (err) {
 			pr_err("Failed configuring rate limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
@@ -3965,18 +3982,18 @@ static int qp_rl_prepare(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static void qp_rl_rollback(struct mlx5_core_dev *mdev,
+static void qp_rl_rollback(struct mlx5_ib_qp *qp,
 			   struct mlx5_rate_limit_ctx *ctx)
 {
 	if (ctx->rl_desired_index)
-		mlx5_rl_remove_rate(mdev, &ctx->rl_desired);
+		mlx5_rl_remove_rate(qp_to_mdev(qp), &ctx->rl_desired);
 }
 
-static void qp_rl_commit(struct mlx5_core_dev *mdev,
-			 struct mlx5_ib_qp *qp,
+static void qp_rl_commit(struct mlx5_ib_qp *qp,
 			 struct mlx5_rate_limit_ctx *ctx,
 			 enum ib_qp_state new_state)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	if (ctx->rl_changed) {
 		if (ctx->rl_old.rate)
 			mlx5_rl_remove_rate(mdev, &ctx->rl_old);
@@ -3995,9 +4012,10 @@ static void qp_rl_commit(struct mlx5_core_dev *mdev,
 }
 
 static int modify_raw_packet_qp_sq(
-	struct mlx5_core_dev *mdev, struct mlx5_ib_sq *sq, int new_state,
+	struct mlx5_ib_sq *sq, int new_state,
 	const struct mlx5_modify_raw_qp_param *raw_qp_param, struct ib_pd *pd)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	const struct mlx5_rate_limit_ctx *rl_ctx = &raw_qp_param->rl_ctx;
 	struct mlx5_ib_qp *ibqp = sq->base.container_mibqp;
 	void *in;
@@ -4101,7 +4119,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		struct mlx5_flow_handle *flow_rule;
 
 		if (tx_affinity) {
-			err = modify_raw_packet_tx_affinity(dev->mdev, sq,
+			err = modify_raw_packet_tx_affinity(sq,
 							    tx_affinity,
 							    qp->ibqp.pd);
 			if (err)
@@ -4113,7 +4131,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (IS_ERR(flow_rule))
 			return PTR_ERR(flow_rule);
 
-		err = modify_raw_packet_qp_sq(dev->mdev, sq, sq_state,
+		err = modify_raw_packet_qp_sq(sq, sq_state,
 					      raw_qp_param, qp->ibqp.pd);
 		if (err) {
 			if (flow_rule)
@@ -4133,11 +4151,12 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 }
 
 static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_dev *mdev,
 				       struct ib_udata *udata)
 {
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
-	u8 port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	u8 port_num = mlx5_core_native_port_num(mdev) - 1;
 	atomic_t *tx_port_affinity;
 
 	if (ucontext)
@@ -4146,7 +4165,8 @@ static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
 		tx_port_affinity = &dev->port[port_num].roce.tx_port_affinity;
 
 	return (unsigned int)atomic_add_return(1, tx_port_affinity) %
-		(dev->lag_active ? dev->lag_ports : MLX5_CAP_GEN(dev->mdev, num_lag_ports)) + 1;
+		(dev->lag_active ? dev->lag_ports :
+				   MLX5_CAP_GEN(mdev, num_lag_ports)) + 1;
 }
 
 static bool qp_supports_affinity(struct mlx5_ib_qp *qp)
@@ -4164,6 +4184,7 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 				    int attr_mask, u8 init,
 				    struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_dev(qp->device);
@@ -4171,17 +4192,17 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 	struct mlx5_ib_qp_base *qp_base;
 	unsigned int tx_affinity;
 
-	if (!(mlx5_ib_lag_should_assign_affinity(dev) &&
+	if (!(mlx5_ib_lag_should_assign_affinity(dev, mdev) &&
 	      qp_supports_affinity(mqp)))
 		return 0;
 
 	if (mqp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)
 		tx_affinity = mqp->gsi_lag_port;
 	else if (init)
-		tx_affinity = get_tx_affinity_rr(dev, udata);
+		tx_affinity = get_tx_affinity_rr(dev, mdev, udata);
 	else if ((attr_mask & IB_QP_AV) && attr->xmit_slave)
 		tx_affinity =
-			mlx5_lag_get_slave_port(dev->mdev, attr->xmit_slave);
+			mlx5_lag_get_slave_port(mdev, attr->xmit_slave);
 	else
 		return 0;
 
@@ -4195,8 +4216,7 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 	return tx_affinity;
 }
 
-static int __mlx5_ib_qp_set_raw_qp_counter(struct mlx5_ib_qp *qp, u32 set_id,
-					   struct mlx5_core_dev *mdev)
+static int __mlx5_ib_qp_set_raw_qp_counter(struct mlx5_ib_qp *qp, u32 set_id)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
@@ -4216,12 +4236,13 @@ static int __mlx5_ib_qp_set_raw_qp_counter(struct mlx5_ib_qp *qp, u32 set_id,
 		   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
 	MLX5_SET(rqc, rqc, counter_set_id, set_id);
 
-	return mlx5_core_modify_rq(mdev, rq->base.mqp.qpn, in);
+	return mlx5_core_modify_rq(qp_to_mdev(qp), rq->base.mqp.qpn, in);
 }
 
 static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 				    struct rdma_counter *counter)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	u32 in[MLX5_ST_SZ_DW(rts2rts_qp_in)] = {};
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
@@ -4235,7 +4256,7 @@ static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 		set_id = mlx5_ib_get_counters_id(dev, mqp->port - 1);
 
 	if (mqp->type == IB_QPT_RAW_PACKET)
-		return __mlx5_ib_qp_set_raw_qp_counter(mqp, set_id, dev->mdev);
+		return __mlx5_ib_qp_set_raw_qp_counter(mqp, set_id);
 
 	base = &mqp->trans_qp.base;
 	MLX5_SET(rts2rts_qp_in, in, opcode, MLX5_CMD_OP_RTS2RTS_QP);
@@ -4246,7 +4267,7 @@ static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 
 	qpc = MLX5_ADDR_OF(rts2rts_qp_in, in, qpc);
 	MLX5_SET(qpc, qpc, counter_set_id, set_id);
-	return mlx5_cmd_exec_in(dev->mdev, rts2rts_qp, in);
+	return mlx5_cmd_exec_in(mdev, rts2rts_qp, in);
 }
 
 static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
@@ -4257,6 +4278,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			       struct mlx5_ib_modify_qp_resp *resp,
 			       struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	static const u16 optab[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE] = {
 		[MLX5_QP_STATE_RST] = {
 			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
@@ -4343,7 +4365,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 	MLX5_SET(qpc, qpc, lag_tx_port_affinity, tx_affinity);
 	if (tx_affinity && new_state == IB_QPS_RTR &&
-	    MLX5_CAP_GEN(dev->mdev, init2_lag_tx_port_affinity))
+	    MLX5_CAP_GEN(mdev, init2_lag_tx_port_affinity))
 		optpar |= MLX5_QP_OPTPAR_LAG_TX_AFF;
 
 	if (is_sqp(qp->type)) {
@@ -4363,7 +4385,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 		MLX5_SET(qpc, qpc, mtu, attr->path_mtu);
 		MLX5_SET(qpc, qpc, log_msg_max,
-			 MLX5_CAP_GEN(dev->mdev, log_max_msg));
+			 MLX5_CAP_GEN(mdev, log_max_msg));
 	}
 
 	if (attr_mask & IB_QP_DEST_QPN)
@@ -4491,7 +4513,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_RATE_LIMIT) {
-		err = qp_rl_parse(dev, qp, attr, ucmd, &rl_ctx.rl_desired);
+		err = qp_rl_parse(qp, attr, ucmd, &rl_ctx.rl_desired);
 		if (err)
 			goto out;
 	} else {
@@ -4500,7 +4522,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 	op = optab[mlx5_cur][mlx5_new];
 	if (!mlx5_rl_are_equal(&rl_ctx.rl_desired, &qp->rl)) {
-		err = qp_rl_prepare(dev, qp, op, &rl_ctx);
+		err = qp_rl_prepare(qp, op, &rl_ctx);
 		if (err)
 			goto out;
 	}
@@ -4528,11 +4550,11 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 		err = modify_raw_packet_qp(dev, qp, &raw_qp_param, tx_affinity);
 		if (err) {
-			qp_rl_rollback(dev->mdev, &raw_qp_param.rl_ctx);
+			qp_rl_rollback(qp, &raw_qp_param.rl_ctx);
 			goto out;
 		}
 
-		qp_rl_commit(dev->mdev, qp, &raw_qp_param.rl_ctx, new_state);
+		qp_rl_commit(qp, &raw_qp_param.rl_ctx, new_state);
 	} else {
 		if (rl_ctx.rl_changed) {
 			MLX5_SET(qpc, qpc, packet_pacing_rate_limit_index,
@@ -4542,7 +4564,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		if (udata) {
 			/* For the kernel flows, the resp will stay zero */
 			resp->ece_options =
-				MLX5_CAP_GEN(dev->mdev, ece_support) ?
+				MLX5_CAP_GEN(mdev, ece_support) ?
 					ucmd->ece_options : 0;
 			resp->response_length = sizeof(*resp);
 		}
@@ -4550,11 +4572,11 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 					  &resp->ece_options);
 
 		if (err) {
-			qp_rl_rollback(dev->mdev, &rl_ctx);
+			qp_rl_rollback(qp, &rl_ctx);
 			goto out;
 		}
 
-		qp_rl_commit(dev->mdev, qp, &rl_ctx, new_state);
+		qp_rl_commit(qp, &rl_ctx, new_state);
 	}
 
 	if (err)
@@ -4662,6 +4684,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			      int attr_mask, struct mlx5_ib_modify_qp *ucmd,
 			      struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	enum ib_qp_state cur_state, new_state;
@@ -4676,7 +4699,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	new_state = attr->qp_state;
 
 	dctc = MLX5_ADDR_OF(create_dct_in, qp->dct.in, dct_context_entry);
-	if (MLX5_CAP_GEN(dev->mdev, ece_support) && ucmd->ece_options)
+	if (MLX5_CAP_GEN(mdev, ece_support) && ucmd->ece_options)
 		/*
 		 * DCT doesn't initialize QP till modify command is executed,
 		 * so we need to overwrite previously set ECE field if user
@@ -4705,7 +4728,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC) {
 			int atomic_mode;
 
-			atomic_mode = get_atomic_mode(dev, qp);
+			atomic_mode = get_atomic_mode(qp);
 			if (atomic_mode < 0)
 				return -EOPNOTSUPP;
 
@@ -4713,9 +4736,9 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			MLX5_SET(dctc, dctc, rae, 1);
 		}
 		MLX5_SET(dctc, dctc, pkey_index, attr->pkey_index);
-		if (mlx5_lag_is_active(dev->mdev))
+		if (mlx5_lag_is_active(mdev))
 			MLX5_SET(dctc, dctc, port,
-				 get_tx_affinity_rr(dev, udata));
+				 get_tx_affinity_rr(dev, mdev, udata));
 		else
 			MLX5_SET(dctc, dctc, port, attr->port_num);
 
@@ -4758,11 +4781,11 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					   qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,
 					   sizeof(out));
-		err = mlx5_cmd_check(dev->mdev, err, qp->dct.in, out);
+		err = mlx5_cmd_check(mdev, err, qp->dct.in, out);
 		if (err)
 			return err;
 		resp.dctn = qp->dct.mdct.mqp.qpn;
-		if (MLX5_CAP_GEN(dev->mdev, ece_support))
+		if (MLX5_CAP_GEN(mdev, ece_support))
 			resp.ece_options = MLX5_GET(create_dct_out, out, ece);
 		err = ib_respond_udata(udata, resp);
 		if (err) {
@@ -4791,22 +4814,20 @@ static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
 	return false;
 }
 
-static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
+static int validate_rd_atomic(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			      int attr_mask, enum ib_qp_type qp_type)
 {
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	int log_max_ra_res;
 	int log_max_ra_req;
 
 	if (qp_type == MLX5_IB_QPT_DCI) {
-		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_res_dc);
-		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_req_dc);
+		log_max_ra_res = 1 << MLX5_CAP_GEN(mdev, log_max_ra_res_dc);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(mdev, log_max_ra_req_dc);
 	} else {
-		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_res_qp);
-		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_req_qp);
+		log_max_ra_res = 1 << MLX5_CAP_GEN(mdev, log_max_ra_res_qp);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(mdev, log_max_ra_req_qp);
 	}
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
@@ -4828,6 +4849,7 @@ static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_modify_qp_resp resp = {};
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
@@ -4856,7 +4878,7 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			return -EOPNOTSUPP;
 
 		if (ucmd.comp_mask & MLX5_IB_MODIFY_QP_OOO_DP) {
-			if (!get_dp_ooo_cap(dev->mdev, qp->type))
+			if (!get_dp_ooo_cap(mdev, qp->type))
 				return -EOPNOTSUPP;
 			qp->is_ooo_rq = 1;
 		}
@@ -4884,7 +4906,7 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	} else if (attr_mask == IB_QP_RATE_LIMIT && cur_state != IB_QPS_RTS) {
 		struct mlx5_rate_limit rl_desired = {};
 
-		err = qp_rl_parse(dev, qp, attr, &ucmd, &rl_desired);
+		err = qp_rl_parse(qp, attr, &ucmd, &rl_desired);
 		if (!err)
 			qp->rl_desired = rl_desired;
 		goto out;
@@ -4916,7 +4938,7 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out;
 	}
 
-	if (!validate_rd_atomic(dev, attr, attr_mask, qp_type))
+	if (!validate_rd_atomic(ibqp, attr, attr_mask, qp_type))
 		goto out;
 
 	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
@@ -4994,13 +5016,14 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 	}
 }
 
-static int query_raw_packet_qp_sq_state(struct mlx5_ib_dev *dev,
+static int query_raw_packet_qp_sq_state(struct ib_pd *pd,
 					struct mlx5_ib_sq *sq,
 					u8 *sq_state)
 {
 	int err;
 
-	err = mlx5_core_query_sq_state(dev->mdev, sq->base.mqp.qpn, sq_state);
+	err = mlx5_core_query_sq_state(pd_to_mdev(pd), sq->base.mqp.qpn,
+				       sq_state);
 	if (err)
 		goto out;
 	sq->state = *sq_state;
@@ -5009,7 +5032,7 @@ static int query_raw_packet_qp_sq_state(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int query_raw_packet_qp_rq_state(struct mlx5_ib_dev *dev,
+static int query_raw_packet_qp_rq_state(struct ib_pd *pd,
 					struct mlx5_ib_rq *rq,
 					u8 *rq_state)
 {
@@ -5023,7 +5046,7 @@ static int query_raw_packet_qp_rq_state(struct mlx5_ib_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_query_rq(dev->mdev, rq->base.mqp.qpn, out);
+	err = mlx5_core_query_rq(pd_to_mdev(pd), rq->base.mqp.qpn, out);
 	if (err)
 		goto out;
 
@@ -5081,8 +5104,7 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
 	return 0;
 }
 
-static int query_raw_packet_qp_state(struct mlx5_ib_dev *dev,
-				     struct mlx5_ib_qp *qp,
+static int query_raw_packet_qp_state(struct mlx5_ib_qp *qp,
 				     u8 *raw_packet_qp_state)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
@@ -5093,13 +5115,13 @@ static int query_raw_packet_qp_state(struct mlx5_ib_dev *dev,
 	u8 rq_state = MLX5_RQ_STATE_NA;
 
 	if (qp->sq.wqe_cnt) {
-		err = query_raw_packet_qp_sq_state(dev, sq, &sq_state);
+		err = query_raw_packet_qp_sq_state(qp->ibqp.pd, sq, &sq_state);
 		if (err)
 			return err;
 	}
 
 	if (qp->rq.wqe_cnt) {
-		err = query_raw_packet_qp_rq_state(dev, rq, &rq_state);
+		err = query_raw_packet_qp_rq_state(qp->ibqp.pd, rq, &rq_state);
 		if (err)
 			return err;
 	}
@@ -5264,7 +5286,7 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	if (qp->type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
-		err = query_raw_packet_qp_state(dev, qp, &raw_packet_qp_state);
+		err = query_raw_packet_qp_state(qp, &raw_packet_qp_state);
 		if (err)
 			goto out;
 		qp->state = raw_packet_qp_state;
@@ -5375,6 +5397,7 @@ static int set_delay_drop(struct mlx5_ib_dev *dev)
 static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		      struct ib_wq_init_attr *init_attr)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_dev *dev;
 	int has_net_offloads;
 	__be64 *rq_pas0;
@@ -5387,7 +5410,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 
 	dev = to_dev(pd->device);
 
-	ts_format = get_rq_ts_format(dev, to_mcq(init_attr->cq));
+	ts_format = get_rq_ts_format(mdev, to_mcq(init_attr->cq));
 	if (ts_format < 0)
 		return ts_format;
 
@@ -5410,7 +5433,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		 rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ ?
 		 MLX5_WQ_TYPE_CYCLIC_STRIDING_RQ : MLX5_WQ_TYPE_CYCLIC);
 	if (init_attr->create_flags & IB_WQ_FLAGS_PCI_WRITE_END_PADDING) {
-		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
+		if (!MLX5_CAP_GEN(mdev, end_pad)) {
 			mlx5_ib_dbg(dev, "Scatter end padding is not supported\n");
 			err = -EOPNOTSUPP;
 			goto out;
@@ -5442,9 +5465,9 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET(wq, wq, log_wq_pg_sz, rwq->log_page_size);
 	MLX5_SET(wq, wq, wq_signature, rwq->wq_sig);
 	MLX5_SET64(wq, wq, dbr_addr, rwq->db.dma);
-	has_net_offloads = MLX5_CAP_GEN(dev->mdev, eth_net_offloads);
+	has_net_offloads = MLX5_CAP_GEN(mdev, eth_net_offloads);
 	if (init_attr->create_flags & IB_WQ_FLAGS_CVLAN_STRIPPING) {
-		if (!(has_net_offloads && MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
+		if (!(has_net_offloads && MLX5_CAP_ETH(mdev, vlan_cap))) {
 			mlx5_ib_dbg(dev, "VLAN offloads are not supported\n");
 			err = -EOPNOTSUPP;
 			goto out;
@@ -5453,7 +5476,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		MLX5_SET(rqc, rqc, vsd, 1);
 	}
 	if (init_attr->create_flags & IB_WQ_FLAGS_SCATTER_FCS) {
-		if (!(has_net_offloads && MLX5_CAP_ETH(dev->mdev, scatter_fcs))) {
+		if (!(has_net_offloads && MLX5_CAP_ETH(mdev, scatter_fcs))) {
 			mlx5_ib_dbg(dev, "Scatter FCS is not supported\n");
 			err = -EOPNOTSUPP;
 			goto out;
@@ -5487,13 +5510,13 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	return err;
 }
 
-static int set_user_rq_size(struct mlx5_ib_dev *dev,
+static int set_user_rq_size(struct mlx5_core_dev *mdev,
 			    struct ib_wq_init_attr *wq_init_attr,
 			    struct mlx5_ib_create_wq *ucmd,
 			    struct mlx5_ib_rwq *rwq)
 {
 	/* Sanity check RQ size before proceeding */
-	if (wq_init_attr->max_wr > (1 << MLX5_CAP_GEN(dev->mdev, log_max_wq_sz)))
+	if (wq_init_attr->max_wr > (1 << MLX5_CAP_GEN(mdev, log_max_wq_sz)))
 		return -EINVAL;
 
 	if (!ucmd->rq_wqe_count)
@@ -5509,13 +5532,14 @@ static int set_user_rq_size(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static bool log_of_strides_valid(struct mlx5_ib_dev *dev, u32 log_num_strides)
+static bool log_of_strides_valid(struct mlx5_core_dev *mdev,
+				 u32 log_num_strides)
 {
 	if ((log_num_strides > MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES) ||
 	    (log_num_strides < MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES))
 		return false;
 
-	if (!MLX5_CAP_GEN(dev->mdev, ext_stride_num_range) &&
+	if (!MLX5_CAP_GEN(mdev, ext_stride_num_range) &&
 	    (log_num_strides < MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES))
 		return false;
 
@@ -5527,6 +5551,7 @@ static int prepare_user_rq(struct ib_pd *pd,
 			   struct ib_udata *udata,
 			   struct mlx5_ib_rwq *rwq)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_create_wq ucmd;
 	int err;
@@ -5540,7 +5565,7 @@ static int prepare_user_rq(struct ib_pd *pd,
 	}
 
 	if (ucmd.comp_mask & MLX5_IB_CREATE_WQ_STRIDING_RQ) {
-		if (!MLX5_CAP_GEN(dev->mdev, striding_rq)) {
+		if (!MLX5_CAP_GEN(mdev, striding_rq)) {
 			mlx5_ib_dbg(dev, "Striding RQ is not supported\n");
 			return -EOPNOTSUPP;
 		}
@@ -5554,13 +5579,13 @@ static int prepare_user_rq(struct ib_pd *pd,
 				    MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES);
 			return -EINVAL;
 		}
-		if (!log_of_strides_valid(dev,
+		if (!log_of_strides_valid(mdev,
 					  ucmd.single_wqe_log_num_of_strides)) {
 			mlx5_ib_dbg(
 				dev,
 				"Invalid log num strides (%u. Range is %u - %u)\n",
 				ucmd.single_wqe_log_num_of_strides,
-				MLX5_CAP_GEN(dev->mdev, ext_stride_num_range) ?
+				MLX5_CAP_GEN(mdev, ext_stride_num_range) ?
 					MLX5_EXT_MIN_SINGLE_WQE_LOG_NUM_STRIDES :
 					MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES,
 				MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES);
@@ -5573,7 +5598,7 @@ static int prepare_user_rq(struct ib_pd *pd,
 		rwq->create_flags |= MLX5_IB_WQ_FLAGS_STRIDING_RQ;
 	}
 
-	err = set_user_rq_size(dev, init_attr, &ucmd, rwq);
+	err = set_user_rq_size(mdev, init_attr, &ucmd, rwq);
 	if (err) {
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		return err;
@@ -5673,6 +5698,8 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl =
 		to_mrwq_ind_table(ib_rwq_ind_table);
 	struct mlx5_ib_dev *dev = to_dev(ib_rwq_ind_table->device);
+	struct ib_pd *pd = init_attr->ind_tbl[0]->pd;
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	int sz = 1 << init_attr->log_ind_tbl_size;
 	struct mlx5_ib_create_rwq_ind_tbl_resp resp = {};
 	size_t min_resp_len;
@@ -5687,10 +5714,10 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 		return err;
 
 	if (init_attr->log_ind_tbl_size >
-	    MLX5_CAP_GEN(dev->mdev, log_max_rqt_size)) {
+	    MLX5_CAP_GEN(mdev, log_max_rqt_size)) {
 		mlx5_ib_dbg(dev, "log_ind_tbl_size = %d is bigger than supported = %d\n",
 			    init_attr->log_ind_tbl_size,
-			    MLX5_CAP_GEN(dev->mdev, log_max_rqt_size));
+			    MLX5_CAP_GEN(mdev, log_max_rqt_size));
 		return -EINVAL;
 	}
 
@@ -5712,10 +5739,10 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 	for (i = 0; i < sz; i++)
 		MLX5_SET(rqtc, rqtc, rq_num[i], init_attr->ind_tbl[i]->wq_num);
 
-	rwq_ind_tbl->uid = to_mpd(init_attr->ind_tbl[0]->pd)->uid;
+	rwq_ind_tbl->uid = to_mpd(pd)->uid;
 	MLX5_SET(create_rqt_in, in, uid, rwq_ind_tbl->uid);
 
-	err = mlx5_core_create_rqt(dev->mdev, in, inlen, &rwq_ind_tbl->rqtn);
+	err = mlx5_core_create_rqt(mdev, in, inlen, &rwq_ind_tbl->rqtn);
 	kvfree(in);
 	if (err)
 		return err;
@@ -5733,21 +5760,23 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 	return 0;
 
 err_copy:
-	mlx5_cmd_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn, rwq_ind_tbl->uid);
+	mlx5_cmd_destroy_rqt(mdev, rwq_ind_tbl->rqtn, rwq_ind_tbl->uid);
 	return err;
 }
 
 int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
 {
 	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl = to_mrwq_ind_table(ib_rwq_ind_tbl);
-	struct mlx5_ib_dev *dev = to_dev(ib_rwq_ind_tbl->device);
+	struct ib_pd *pd = ib_rwq_ind_tbl->ind_tbl[0]->pd;
 
-	return mlx5_cmd_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn, rwq_ind_tbl->uid);
+	return mlx5_cmd_destroy_rqt(pd_to_mdev(pd), rwq_ind_tbl->rqtn,
+				    rwq_ind_tbl->uid);
 }
 
 int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(wq->pd);
 	struct mlx5_ib_dev *dev = to_dev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 	struct mlx5_ib_modify_wq ucmd = {};
@@ -5784,8 +5813,8 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 
 	if (wq_attr_mask & IB_WQ_FLAGS) {
 		if (wq_attr->flags_mask & IB_WQ_FLAGS_CVLAN_STRIPPING) {
-			if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-			      MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
+			if (!(MLX5_CAP_GEN(mdev, eth_net_offloads) &&
+			      MLX5_CAP_ETH(mdev, vlan_cap))) {
 				mlx5_ib_dbg(dev, "VLAN offloads are not supported\n");
 				err = -EOPNOTSUPP;
 				goto out;
@@ -5807,7 +5836,7 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		u16 set_id;
 
 		set_id = mlx5_ib_get_counters_id(dev, 0);
-		if (MLX5_CAP_GEN(dev->mdev, modify_rq_counter_set_id)) {
+		if (MLX5_CAP_GEN(mdev, modify_rq_counter_set_id)) {
 			MLX5_SET64(modify_rq_in, in, modify_bitmask,
 				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
 			MLX5_SET(rqc, rqc, counter_set_id, set_id);
@@ -5817,7 +5846,7 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 				"Receive WQ counters are not supported on current FW\n");
 	}
 
-	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in);
+	err = mlx5_core_modify_rq(mdev, rwq->core_qp.qpn, in);
 	if (!err)
 		rwq->ibwq.state = (wq_state == MLX5_RQC_STATE_ERR) ? IB_WQS_ERR : wq_state;
 
@@ -5905,7 +5934,7 @@ void mlx5_ib_drain_sq(struct ib_qp *qp)
 	};
 	int ret;
 	struct mlx5_ib_dev *dev = to_dev(qp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
 	if (ret && mdev->state != MLX5_DEVICE_STATE_INTERNAL_ERROR) {
@@ -5934,7 +5963,7 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
 	const struct ib_recv_wr *bad_rwr;
 	int ret;
 	struct mlx5_ib_dev *dev = to_dev(qp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
 	if (ret && mdev->state != MLX5_DEVICE_STATE_INTERNAL_ERROR) {
@@ -5961,7 +5990,7 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
  */
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_dev(qp->device);
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	int err = 0;
 
@@ -5971,7 +6000,7 @@ int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
 		goto out;
 	}
 
-	if (!MLX5_CAP_GEN(dev->mdev, rts2rts_qp_counters_set_id)) {
+	if (!MLX5_CAP_GEN(mdev, rts2rts_qp_counters_set_id)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 7d1a64d24df181ad5b23580c00d68a3b48baf960..dda89cfb2c56be27e68a00f5da350a1f88f6b22a 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1055,7 +1055,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 {
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;  /* compiler warning */
 	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_xrc_seg *xrc;
 	void *cur_edge;
@@ -1212,7 +1212,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	struct mlx5_wqe_data_seg *scat;
 	struct mlx5_rwqe_sig *sig;
 	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	unsigned long flags;
 	int err = 0;
 	int nreq;

-- 
2.49.0


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935485;
	b=isJjODyMnd+s/H3WZf9XYBa9vcVkDF1gFt0wes0o1OWleB1QgHa4v8SV2f9r1ZgkpEjw
	 85Iyga7W6qno5FWyj1X0h8RuaMm+ZAK1Ry17Fxq++nx/RAUK4UQZNXAqMBMfTtijATGuf
	 QhakfEd73vcrW/6GVnxq9NIGwU+jq5VwwIMB4HQV+tCRPD0zikyNjA0FB50fjsDgppL3q
	 vHq1FFhSGUxR891ltVaRmuwOQ1JxxDd7KZnHd+3+F8kUKcVel/Q25YzCWxKfYw4XvXlLG
	 KSPG12Cs3apFKqdA3DXhspSMsQ0NLAzpD2HWLZyBsPf6tFu5pv1DkR+C1GysWtzGSvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935485;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=vIZNPLlC+vjvIjV0W0l4Otl4pnSE8YUlorJN2avhI7s=;
	b=s3oyDZc/MANO4kBMO/UJXJJ5u1MdOx0YyIc2GIe7NpYNtXzupqqiwNFdZaNAU179SVOK
	 z+nPTwGDYz8TcetaZShYhkLVTHboxnl1ab1kPrQSdlT+TS2LxROWOLuTU7UvfPA7QEblV
	 yx8gFuVptcLxPcv9J3e7XAgYRJyA4PMk0RhBYQt7FLx0TzBooX+nsKqU0jbRYhhDD4olr
	 5wDO4LBe6ov1xsfsltzQQzg6uAdHj+eT0a67EgoMXgi+xd0hC0MV6H5HbIGLUmCnVLtG6
	 50uEY37o5BEModrUKmvuSvgzyuYbDPPFXReNclFVbaYk3VP+iRAAORomkeCvlZa7e8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e0tA40H5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A1606A330;
	Tue, 17 Nov 2026 17:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 278A1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e0tA40H5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajxNv9si1FlhA1cNZgE6UD5dfyD0K1yaleZrmhpTpb5VFJub3M4TO+mgnPvOe7K1ykuDHBSnYPS1T/44cALdR+6aok46jLUSQIoU+gaos89Gi/cOQAs1/eJP57a3UJ1P1AgjQ0o+H2JIjsGz7iG08UcqEOXbvzRII/4u6tV5hx6vtCGqHc1Mz7gSLB+s+rn+cckrCTCidV4cOQzsdNpksh1Y4FqXd0rYXB4yBeeg60lj1JFJNUUomWjs1+Xhr2G6iibUyxelJwcF/2QiBrB7rgPTG8+t+sjEtpPaHNd/fTn5tstlmYl3S0dR1/Nz3AC2wiOZj9EJZaBgKn1rmU9J5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIZNPLlC+vjvIjV0W0l4Otl4pnSE8YUlorJN2avhI7s=;
 b=JWqvGRrPFIv3dm25FanV4qQT59qaR51UkzHTF2Qabc7T2127ZKHbIjqhVije+8eHqtcY53nE/uQ2K3Obq+wA9gV1Vna9Bagn0d+TZDgXTSfmhPbMzAc+8oBp16QfQZsCsqgdAdnbxpvceBGRBDc0dxdWSdkiBrx66y19pyr1bWpYoo5G4iIAONYTX0BcUhrPB4q6MmnvJCcZ6dUrN9vweNtlZ7D//E+xjpkG+rrG/hdLSILVD+Cy8SEmZujVMuj0FfAv2G73/H8oK9MwYapglsTRrGyP8FLIUDyYFDhtIuKRvW0JVomnwwPm4GDXd7gRPLeIVV+ilKTO4i91eAQXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIZNPLlC+vjvIjV0W0l4Otl4pnSE8YUlorJN2avhI7s=;
 b=e0tA40H5Xq2wgCv+WvCUOv4mdwZwfwT1IsNvS3qC/ikfqfCXOPJFOjaJTCvNJ5ogNday7beLzUjZMHnzbz8XDA37tk6iTEPhBPOt4m5iusNWcsdQ2YH4lcj+i/UNJx8ZO2vSE2SrQRKcdu+r/FPW1jlCiOLiBx5Ux7Xp9ajnJJ6agHTbblmoAymg5+TM0jzKCvRHOtqCqqIeRtIqGuOrsbzzkCXkd5UWXMEpTwqVSyxFVifBAJvVdAqDPdRZhdrfZ9m/L6f14ueAhPSqGQSDaLWw33ff2qZvNgVME9tft/4HdBiuSnr903XSwI91mACMzxRedgYCVPkaX15un8A2wg==
Received: from SJ0PR03CA0159.namprd03.prod.outlook.com (2603:10b6:a03:338::14)
 by SJ5PPFCB5E1B8F5.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 17:11:17 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::ac) by SJ0PR03CA0159.outlook.office365.com
 (2603:10b6:a03:338::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.11 via Frontend Transport; Tue,
 17 Nov 2026 17:11:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:17 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:59 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:58 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 16/21] RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
Date: Tue, 17 Nov 2026 19:09:09 +0200
Message-ID: <20261117170914.27410-17-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|SJ5PPFCB5E1B8F5:EE_
X-MS-Office365-Filtering-Correlation-Id: 77238e08-54e4-48d0-4e47-08df44cdcafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|22082099003|11063799006|56012099006|261026121527099003|261028144727099003|261021121427099003|10067099003|261021123027099003|261026140227099003|261009223027099003|261102123227099003|261021135927099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	BQpm7mIicFNz97Mwa49rSGkv8duF1X8rw/wKdL7Xd+pPv36Mgaxb9P3hOGEPB2yzcChSDBke0Meb3Z1d/YnMsPDzOmX1OOseBnDPIADGkyeKstEwPnBSG0GCGPa9LIAOjgDhMMBPRaf2Ide+favTtTEo4SxhqhwIrLOGt+xtNyYxdEBdMRc3ikbyifXe1/smtgEkuARvENGhziiEan+tQcN3+R25Pb6L3vurMg8If9ZgamPC2c7/ufq5tIiO0LCTEbUn4zdjCkCabv3XkLNEuRM6N8weYnTea/FSVBQXtOk2G65iS8RwQQE4arz621GtzSvsNv8dfoG+m8gEj3gZ4wnt8Bro5PMC1QvZ8PyigecTiEIOX0ix9R2P6qwKngtW5UmTF6SmOy7ZT6Iow0QtbNmWGUISqwv+TqP5e8OC/z4JgN4RIYOH73xe+ObHExVcTCjiGDgCDjuzdvbH3gIBsRiUk1IdygtbCqTyCN+VKAElt9RGKP+Et4kEqs/oLuVbpCaSBKT311R3Efsi149+L1/Z5kA/lVx2M3wMqGUGsbzbsE0tDi0pE1V3TAYJg3moNqzK8dwKnxh2mPoHcnec3j6KoxAsCfCUMUVXoslu5go42N+51o5IwARIVhXrKc4W1Bbf+CXCVDMDt88osYZvmn76m5EB80+cxd6bFRaS2G7XyMSJ2OdNL8VakE4HN2L5UJn9r2aNzc7Dot2PbKKeag==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(261026121527099003)(261028144727099003)(261021121427099003)(10067099003)(261021123027099003)(261026140227099003)(261009223027099003)(261102123227099003)(261021135927099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	95QNmJOhB4xeq019NgKLsuoSD64oZH8kECfBnrTSrOl5n6MIXdWhZJ39/bJhEStnzuiFeX8RRAd3bQn89X5i8bLXz0n1AkkyzjcJ1At04+a7i3CqBlW/aeTx7wQD9e4adzFH0FTfdUVLOok+rRDddjwxWIpl0FCiwzIcuc8VxPQyXceSx7ptNXj+GK6BldoqJa+BLsymeHSw9WQmZprE6nmv3Jv6W7JNaJ1Tq1U+x4J2PQ+qAowfsQaT7z1WMsAdJ/Tf8UWrqjr/SuNbm02E/clOssjgogYmI+tEDsc05MFZW9DMaQV7wXIQlfHs5rOLG4JbCk/D+iUxE1P/AUp2Kw1FoJnjNSF1C9B2kn69qVIuS9NbkZsdFu87UuxkI/rOSrwva3I3n2PGs352ErE2rKmJv4+2QKMFCO4yP2pQB7DrLlGScRWw1r6nzNW0+m+e
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:17.4145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77238e08-54e4-48d0-4e47-08df44cdcafc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCB5E1B8F5

devr.ports[] has 2 entries, but it is indexed by port numbers taken
from the NIC, which adversarial mode does not trust.

handle_port_change() uses the EQE port before any validation, so port 0
wraps the index to UINT_MAX and a port above 2 overflows the array.
mlx5_ib_create_gsi() gets a port already checked against phys_port_cnt,
but that comes from the num_ports and num_vhca_ports FW caps, which may
report more than 2 ports.

Validate the port and bound it by ARRAY_SIZE() in both paths.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/gsi.c  |  4 ++++
 drivers/infiniband/hw/mlx5/main.c | 11 ++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index b2e2a219639d..7ce390a2820f 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -95,6 +95,10 @@ int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 	int num_qps = 0;
 	int ret;
 
+	if (!rdma_is_port_valid(&dev->ib_dev, port_num) ||
+	    port_num > ARRAY_SIZE(dev->devr.ports))
+		return -EINVAL;
+
 	if (mlx5_ib_deth_sqpn_cap(dev)) {
 		if (MLX5_CAP_GEN(dev->mdev,
 				 port_type) == MLX5_CAP_PORT_TYPE_IB)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 69e11c06bd9c..0bf7e68a377d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3062,6 +3062,12 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 {
 	u32 port = (eqe->data.port.port >> 4) & 0xf;
 
+	if (!rdma_is_port_valid(&ibdev->ib_dev, port) ||
+	    port > ARRAY_SIZE(ibdev->devr.ports)) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
+		return -EINVAL;
+	}
+
 	ibev->element.port_num = port;
 
 	switch (eqe->sub_type) {
@@ -3139,11 +3145,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 
 	ibev.device = &ibdev->ib_dev;
 
-	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
-		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
-		goto out;
-	}
-
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 
-- 
2.18.1


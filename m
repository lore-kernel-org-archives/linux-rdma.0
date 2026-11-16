Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825101;
	b=IZbS7T/oRxoirb1VLhQjGW0Twntu3aL/pUkEkLXe5ZQ2m9LKV4Y441EY1EttTtfRXgtu
	 +BlGANkpP37j2w8FEIECblGpGyyxf1NWO1y4d3lXj+dlkj7xYh+GoxCHbOjsWEgNPdsl0
	 YJBkjbQlJZ1NDwFFG3f+7qxyeOXbbpdmptv5QdY+q6P8s/SQ5IdaNTNZyEyJHFc05Rfle
	 LtmCiQL1p6gVrL0kwhgLQ6/UHXOU5g7NPXMmpSLlFeLbPB2OTRHGB0cjZM0Ft7zJ6sHiP
	 c7A+8bnI9vRIQBDe37yVrY2zNYGcYlznf28GndPB3CjNumLPsFKv2UshCqziTZbOBmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825101;
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
	bh=Iz/EFK91Ddf+XKeEUhkoMVXm94mrKBgmCR5Y+YVsNWk=;
	b=hvC9E0qxY6wzzzt8WrXwoa6lNzLcXX6D2Irv1y8o2GpxYYbsMora+9YslQmY6jFZSyPo
	 QBBA0MlGp5vsOtDHEOW6RdavZSS+W11VjSWH2DFE0twMBEzdtxR1/zJuw4aQ14pMdttyY
	 JyxMz3+kt9Qf2Hor3NZG2+Q3shA/6UUyGXdNC6G04Gr1hl/ZlqukCQbXFjkcOgWpryXV9
	 YJP5Eb+H8rTnjFcFUizPVs4WL5vj5nz36R1oAiUQg6CiB7+H+Mb95dFaoCR2mjHjOyayj
	 f5Ug/FK16Xyj1ocS/M0y3/u6+KXuIxkr1qGK7L7jE0RrN8zKSSWj8IdoMPux+k9R+uA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AbHAHguC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.19
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9FE606A899;
	Mon, 16 Nov 2026 10:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC9FE606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AbHAHguC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uYpAxqduvKhXZu4Jx8r+PM0HQpWjeQMId1ccoOs0yVQB7qW+H2kUrqIZR9nFmuYDrRgq/js3LUrPpcS8E6M8huf/w9PqB3M0H+sagSv69wbIBOZu/QxGVDSm+AVVGkxImBS1PMsWNvu4reQaizsH2MsuKI83h0gIS2C3uSp1joNXBpQGoQ0WRFbbTf51A2u0p5DW2sw2JvejHGiBArgxEzAa0emTUNG/kFXEAkTbZFNTLUvs3ukSrB/Om81I5qlRGkBWeAHcXDAm1mB4CIhzNXta/F7TWvmR8kXxrp8rjzRTUy2tyvOdWEftRJzUjFqi5fO/jxSJOiIdrSkV5hm08w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iz/EFK91Ddf+XKeEUhkoMVXm94mrKBgmCR5Y+YVsNWk=;
 b=rKqf8vmM/OtzeH17+rvGPYZqZQ3TdZpSSck36ctUYt1PqqXMI2k8uduciGM0Y1D9d1iIDQVZuDMY8u4mF+M/cUoWkRwE0tQPc/A/ROTclfUPTQ8HlGEsJ9AvPDF3eLXwUeoM72EG4YtECdCkkOF5g/YDzmeHiD+35JFobVe/qnF/Xe9uuxwG4bE62QgJnNPNT6PkBsY5vpA6GbCShxtZdh/0Cd5azEZuUPBP3gebF1KHGkwmlP+wq9aYGkWu6qT0vLWS5S+vsvYmQ9tzDx2yy4hk3yWXHq/IbTu5bmRF4IlEsILGR8XbXSmquM3H4f+soEr/qFiy598H5LnGIc0ugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz/EFK91Ddf+XKeEUhkoMVXm94mrKBgmCR5Y+YVsNWk=;
 b=AbHAHguClmkq2Pn0K3pf7U74ZYo7vnsPjb5436QZs0JSeh7o/87BXgDP9CUWTcyUIVveKxXJrEbTBKSuh8XeYsoPsI+aC4SiJcwKylIOg0VVr8dMudV0ArAJwtYN7ddyOXrvhUF1YM0K5HMOtNcmvvE+RGzbHURwvhW1zE1BhnSLdg/1cLX8ayTCrSY7lzKKUgqCzO32jtjHNeMspVkzS2fAHbkrgdiAfXx5jjlDVr3aszlhgzEMXXUEjv5sTHXWujqo5o6eF8m69eb35AqdQX0wdJ/KeSNEljPU+ngfTSVuvIdEMht6bFprMSUC3Ar80aJL4KzncdnMEpMflDTMYQ==
Received: from PH5P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::12)
 by CH3PR12MB7692.namprd12.prod.outlook.com (2603:10b6:610:145::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 10:31:35 +0000
Received: from CY8PEPF0000005C.namprd21.prod.outlook.com
 (2603:10b6:510:34b:cafe::f) by PH5P222CA0001.outlook.office365.com
 (2603:10b6:510:34b::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005C.mail.protection.outlook.com (10.167.247.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:19 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:31:13 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 07/10] net/mlx5: LAG, resolve affinity indices only in queue-affinity mode
Date: Mon, 16 Nov 2026 12:30:07 +0200
Message-ID: <20261116103010.1129666-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005C:EE_|CH3PR12MB7692:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bb032a-7a82-47bf-04e3-08df43ccc9c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|36860700016|82310400026|10067099003|11063799006|56012099006|261026140227099003|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eEtUkVCHH8EvBtf5DDw2c0kW5QitogNqXCauOz9baSXVYUFey9V5QSUs8LmD5JN7YLMbGW6FbDrLFJoiSI2Cf0bARR31JkjNIUssRY0A8abN14SWxFegIeQhl3S2bGoTnREmJvV5DHyE7Rjz5lA+3t9gDsaFqdmmVcqJOkS26imfMVbE6coKdXGR/vF78/5pqDYY0e9jMQP31xXAlAJO7HlEVJYGRq6R3277H6w5BKsq+Z6V3SMn2HBjI/YW0+6mIMIrOEHCesDcsfSbajYb43eyQH/nhz1Pmv0AVQg0INCBg8enfjHTB/6rWQDTPTPDPeBojlnWHDcyZ3olRBQVFxXXnaTA3xd3d0u6ukiSQTI0UdB+HudALkKbJM/GAHAB9ngZqLaFNplGNno9riL1k1AAkjXrwZDLACL4RKiJjhj89X7zDHOobsRS0St3/Fbx7wRMrbUYrH26xd8nyG9P1TjpI7Rq5hwoxeVsVrU4khmeUlXwKiRMtOHjPxXncoA6y3OgKwhU7Bmn05t0ijFxfHCYS25xQRs5fdKupAbfF/kKmgfNuZESPpSw0exKSWacl0h8mXT3TxYU7UnPJ7HHDzQteVPJ1QeNkfX+Mj+oHk2mKrf4dIc9UjS2KXIQLe0INCmXzOb5Y82Ur3ysui2LF6DSrnXsFULXBOiwho8e2xL5keWzYYeAoUIj2d8exR77T3zmCi27ulkZCMugR10pdw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(36860700016)(82310400026)(10067099003)(11063799006)(56012099006)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IBG5wKFTQUQodnRnBxFbmEIuWvjSITBWWYraJOSITKUDcNEIOcI27RTSZgFFU/OEImTOOWvoJkOHUkbdXffz+TRNZEWZMFkGLpFddlt22gT7IAzTzo1EPUozEwb+y9de515JBNwO0wVcrTF5A3Ow2jB2+sEp5IhlgXJBADBOuoXGgvY84Zui1L9gX+WPhAXUW/cJ+s1eCbwBrLAAw21/uyRqblz9Ev5lfRNEJQyXeGlGYWBAYj/RuajSrmBge/wZng2J/7RgAgn+OQcBf+rN0GSJLiRgq7HZtuoGZQ9JeZfiafG0EKZKDNqs/aMY1xCsco6cMtwSmJMX3q/e9xBI1eXm8c11A+PsLVGqmk2P80MPeI/MTsi6Rw/oKzwb6xElaKFsC0g+YKjIKBqavfXOZZMJ+yZj5ipodQTtBGYFLMt+WwoaPhzdhWUl3DV0I1IO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:34.6168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bb032a-7a82-47bf-04e3-08df43ccc9c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7692

From: Shay Drory <shayd@nvidia.com>

mlx5_cmd_create_lag() resolved the first two members up front via
mlx5_lag_get_dev_index_by_seq() and returned -EINVAL if either failed,
but only the queue-affinity mode uses them.

Move the lookup into that case.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c    | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 74e7e7161c95..5c9f200c9637 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -95,23 +95,25 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
 	int port_sel_mode = get_port_sel_mode(mode, flags);
 	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
 	u8 *ports = ldev->v2p_map;
-	int idx0, idx1;
 	void *lag_ctx;
 
 	lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, fdb_sel_mode);
-	idx0 = mlx5_lag_get_dev_index_by_seq(ldev, 0);
-	idx1 = mlx5_lag_get_dev_index_by_seq(ldev, 1);
+	switch (port_sel_mode) {
+	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY: {
+		int idx0, idx1;
 
-	if (idx0 < 0 || idx1 < 0)
-		return -EINVAL;
+		idx0 = mlx5_lag_get_dev_index_by_seq(ldev, 0);
+		idx1 = mlx5_lag_get_dev_index_by_seq(ldev, 1);
+
+		if (idx0 < 0 || idx1 < 0)
+			return -EINVAL;
 
-	switch (port_sel_mode) {
-	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY:
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[idx0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[idx1]);
 		break;
+	}
 	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT: {
 		u8 active_port;
 		int ret;
-- 
2.44.0


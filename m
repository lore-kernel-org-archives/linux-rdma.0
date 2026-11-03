Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725994;
	b=olvI36+uxCUbUwK7Irx27kZESjvf2qwXWzAKMbPBkCv2J5RmK4vJp7cR2Fp69iXbA1q0
	 WJnoD2zhG/HfWpvOzKB/wrPmcPlJer4MUsaXGQk6sHhBM8GYcwJLd8Y4WPeBN8ipeQkyM
	 wPFnr7GTo7FV3bmoSQacZbo4fJeJHie5s0qmxvzYXYf5mmvQwEAomEMhDIbGYX3lfHSm7
	 79loNn37PZpIojI06MoODFZTbHSG5PZoKSLZI4v+k9YfxKqf9V0dkU7jKIJQYu4MJcppx
	 kj+iZORNy3aoIYnsmVesA5GAbs6pkbD1Xite5ET0Oy531m9QlPDm5kec5A559xmVrig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725994;
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
	bh=bO/IHBOq5ohMlKO2hyW7rPYXsLy+LWBc7WUSepaI0BM=;
	b=h6M9FMT0Zgy7H+cz/JGUThKBfbO+sGCRioi+CIDTmTQbdtMVEkZT7/mhg7Yfxi89jcOk
	 W4Bn7X3+mUdd2H+rYhXT+hsOj3Ik3UtTPL+ePnr9Mrsl8zNDLDudqMCAKboPAM65/8Vlv
	 JgoKCBrn3XFVmJJXTw4ztOcRUM+66DJH3N1v48LQ/MSMHuDF4tlTjOo//f+fdErV7HyaG
	 tN90pe9bb+7+Shncvtci3X665FRvHzmlZhr9YQt5xs1DFlX09fvvCGN897pE7FH417ybq
	 G+/BTQolqiSCFDo1wNUsuwjjx0JTUHQOqsGVeQcMHeRRdGy0LIpGacq+7ZkLA29b/vw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JNAqgFOd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.39
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3235606D81F;
	Tue,  3 Nov 2026 17:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3235606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JNAqgFOd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRZzOAacfjmyy1HZEnFjAfbkTXGDAtw9N/jmWCpWpYDiQDyNybeVmmI9NR9LMIB++wGK4sbM/OlWHbkJQJg5H4sU5NAHgIhLsu1Iz5DLDGgKv6SIenkRnFEjuw5SyOo568ahUivjOFV8+44ho5wiMVcMHzYqLPNUTyZW0NnUVzYz6qEpWXSAzUJAaK5pqLyHLjVB/+g2uPRQFsXtiI0yqInIebXEZCd2MtWX3VPk5HjaqS45slQip9Xg69nHZn+7Kd30z6QRYMfjuAA/tuFe54iQ+9tmuelTnZ8K4WSbDZ0ww70WoINvEnGOuONYVKOnmXMVaop6eNUyHrRqbFzqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bO/IHBOq5ohMlKO2hyW7rPYXsLy+LWBc7WUSepaI0BM=;
 b=TDLqIsm/gv3+pTZTDf9gDevXyE2PWnGIu6Tljyyh568LTWvZ9zcOfkVWzKRzNwlEzPFiuxkOzJel9EJgYuU1jexE6y2/U/q7XGLqPMViKdlXIB+5UERwWTXI1anQLGYcrZIcI9yK0Qx3oeV0Hc2C7ZVbrcAw0RmACS77njMmqj5ylteIJZM90pHXsLcpdlRVJeyImhnvnpJEe2dH5WcHTe1Vm3ugDGo7+IEeB8q0ZtYo2hzwE6fNXYm0btXtfTRPRBTkW3zrEJbtEabnIBw0ajkPqCuVh2yQscPcNtaweMpF2x39i2VPIdF6wbdxGg1xjkCYmcLGTLCw7R6nd+cFpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO/IHBOq5ohMlKO2hyW7rPYXsLy+LWBc7WUSepaI0BM=;
 b=JNAqgFOdd3VEYcaj6YOe4J3L1qMECR2MNk0d/wXc+azpghpIIKV4YS/U/qPbuq1El3fw+BtekM4ftcFsw8Qzrvqq41T4USLqR/30G+BSm0l4bziwfFBkbedA6u71Byywf4Du0nsSkuXXU5TBiW3SFQ+iRHjE2dnQj0X57L2zJaxbZY1oD0aCDPgNFOLTIxzJzcYrlUxR7poG/QLWnQtNfBHT6CgQbiPNv8E9XRZYavzoZN9AKpFMWNv29oULg7KBUJYleWcf9iE5fQTen39aQEllE9ua095H+XfBKoFdLQzBpZAvtyP73zP+KyHhFaUsC+IhxFMeQoeJFp06lwPDOA==
Received: from MN0P223CA0022.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::23)
 by BN5PR12MB9488.namprd12.prod.outlook.com (2603:10b6:408:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:06 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:208:52b:cafe::24) by MN0P223CA0022.outlook.office365.com
 (2603:10b6:208:52b::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:20 -0800
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
Subject: [PATCH net-next 07/15] net/mlx5: LAG, resolve affinity indices only in queue-affinity mode
Date: Tue, 3 Nov 2026 19:10:01 +0200
Message-ID: <20261103171009.563034-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|BN5PR12MB9488:EE_
X-MS-Office365-Filtering-Correlation-Id: f134e8f9-cc34-4f12-2fd5-08df39cdba21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|261102123227099003|261021121427099003|11063799006|261021123027099003|56012099006|261028144727099003|261009223027099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	C1Jzvm8brqY57UqBB7Ad13vGJgEZHiHW6oIawpuhmAu/QcQpiwolwhtt/GqQdGCl3G+CfMTKWOTHJFAOfcjgCYob5IJVwQH6rgu+FuqhF/9Uy6ff4gQxIJu9Z3J6BOyO1pVow93ukSSqV8Cffsj2tab9n7pisGdw1h3NqOnylH8h87UBbG2lXcw8Ikcr2/d4zY76mxnSCtTEpeov8uhnmtmOBD6xFPOxzGDtjOv0pQW32HLb8hH/YvcPlthEePKk31oE+HZCuT+ov68seJTEi0NOrjawsOgh+BnL9gFKyHpa4MvPjueKMycxaLzvsEjtQ5XzeiA5cfTlTuAxxkOwRxGjpSuo5MMTJL4ZP1FzSV2ACwJepNg5NfTu9+E7QyxOuxKR8luu6wiDP7sFXzB18gwXyps+G30O07L+W3EsiSqdJgP4VWgBNV0VcJSEJirskyNGjjPWsoFYtcR9r6A/km0e9X4HgouHBvsvQa97DmEXa965mtruHbNugwhekw+Bd5AxiAqeR4T19JBPU3X4QvLASseGP2i8UlEMkEF4cjGZcHw2lorYxyzIyp7cbK/3l8H5tsL9mBGN9UTGMMNlr4139mPl1RBemZmujO9qF1OEO8ne8bGBj0EmgkyyTtnf472KPKQhUXGLZJowWwyuec5ZpztKCMK9Yu0Vjr8UfIEm1Sxj1rtEYLs4mVzz1ueN7j0oQVfivPhTztjR0Ax5dA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(261102123227099003)(261021121427099003)(11063799006)(261021123027099003)(56012099006)(261028144727099003)(261009223027099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XbGJEmeO6zfNpX96ye8JwWnD239qvG16DuQzshiWo8Hde1tnNL8yqC9nygev46oUEAJx5qa0OxxfEhk2q+QIeK8Nc1GK6bnYZG+lrC4DV4784LskBUhjsqQuS/AmUJ/1P39fUGwIcl7W1TFexcBrk/CLpR1iKEf6Wx4EsyXiEoYCGMC2DiqDzeJd7IrhGHdXMluufLszC28safc4LdEDI3s3JEyjDHkrY047/HRKpCrXPMkM/C57SOPErFOdBYlYyNnMRAQODfgh1m+wWFNd6m+s8P8vYJzaTVVAbKf98xYPmjlCXB9TYOwnhjE4SjxKwauV1ME/rD8rfBMeLQeZaRO7gdrFYYlEhd5CJ2uztsy0hKr3DdVPMOwfMxf24WJVqnXkViBHE8tuTa97ZL7y7aY2wFfD/SVcmC+OyWclpTfwlZne+gc3gqcrC/i5JRBc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:06.1863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f134e8f9-cc34-4f12-2fd5-08df39cdba21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9488

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
index 1b065033a2a1..2b76d119cfa6 100644
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


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794302836;
	b=tDtudyOe6+jPdesKlgk0SUSISXq9ABogoE7tWFnUUqa4QPFtolyEovkSVON2N4QMuWvU
	 A2d3gXqrqp6sBeTpXopenBaUFTC0Gm2CgDtpwRkellEyUThDYtrdLeKNas2oaY/bUP+HY
	 ipeSsiqY4ruyzeewOP9N+nqSMkOzkkY4epHudcRofeShnRdTVKNVte0Nc1f9NY9wv1Fcx
	 eQcov46RRQ6wZr0NLoDK1SiOZF6fweHg3o5BlYoK8gmt3U/po9+qKNDti3dY6PzutVe4p
	 oFgF3NogRed0Mp1dXCA0gb7AcC7aw5QTsX7xiP89LNAsjfXxktrcjVVnHZCBO8hJ1ag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794302836;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=w4Nx67jGl7TawAw/9ngW0wl/i/twF4QXG/m8XRpFxxI=;
	b=vnroCti/dC3L6Tu9KRZVYfyOruHJHfYnoegDiEsPTgw4VhreE4uZV3DM9JbXDGsHq3f9
	 EAfdwaxrS35kBL6OAxotXsS1ChgKEE180PWwpSQWG2DTVhv2/lJuO+ihLt/L7ZQvMdckn
	 AcPOKQoGXrlWzdriwF+O2u3ANTKeFgq353Ql6L0csbUf44tvblO7BGKIfr6kOq02laCO8
	 oIq4eFt8HDYMur+65wmNtxNR2aJa2lU49DMUN/lL3CQFjz+7mbNCniywasRvilaP7CyS0
	 UmRAOL72/QEhHA8vtIxsz/UsooSLYUmu1HdXWPdV/65yU9/Jk1GF2dmjXdY6OVyxwNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FnUGYmYW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.47
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F41606A938;
	Tue, 10 Nov 2026 09:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98F41606A938
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FnUGYmYW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO1i1+Ke6QMtKz03uQrm3ZOVMQDMhW5QJH/AgoovPn6i2Ys3FNnQz8LjK2GknPp959Mh18H2/WzfnJ/p6XbV/vq++3BoMyA5pbI5FWRP7aDz7teI06M+w9j/1lrAfXWp053weWcXSnW8rdj25PVHCqGNoi41Mw61FRADM1fmJem2wThA/HZGkXS7+jAKjKlZM9e8xkc9lfTKy9DaBGwDtb8Aqc4PGRymDi07qvIG9JqZDKzZceV2CtscntmoAkkwhmEoU0eROigBCk++//vTsruNQPeJCLoDBBzZ/sEeFlmjNdpcAh4BMDKsWwqK1VXhNAN+HS1vgEAdMo16tSRHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4Nx67jGl7TawAw/9ngW0wl/i/twF4QXG/m8XRpFxxI=;
 b=Fe0SGNW9oIRaKxGbCy8Kh9KsG83Et1Z0Q/dcifQboSAliLVzP2OGtpTVXG6+CAlnWfb4MDAg7yn2rnY18ErXRISj9tqCKWmoh487WdOBrrxgeFsd+J+g5CyXOxq7jqpeTrIX9WXjzjpbJmr7A56mSZIDWFsOYEQKa13EBgMhWWKMaIZCMMrwmDZhBR9dBb41NvWAdSfSbhIBL0u+g424fPjwH1Uy9IltgftYEeFc4ptxNzDeX4YJ1o9ojLn4FbXIlopcZU1JkugNSGXu70UOubHZVX2DSdNc5GA8+4v7cOCvtj1KLD8Sh7dyuukWWZZLTO98sQfm1MOwvxCFdaG8dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4Nx67jGl7TawAw/9ngW0wl/i/twF4QXG/m8XRpFxxI=;
 b=FnUGYmYWPcAilsSdCvzayxAPjPUzc0kpRB0B7GjGleBTzNkn/27b0ufsjALBeHHjX7OrL96xfDwZ7d9dxtExB67DwcqONM9Y/WWl/0UWuQi1XGxA1tKcZz/tXUapxBnLlrXT09jI4h2XNKzAMbsTm1HXcv5UUrnc5oIhsJp+X3b5RFWLg1jTO9TY3iDCK/DWshrAvXV/TRBmN2yCGk9GN6R8yyp4V99YbFaLEkeH+W8jX+QrGQdGmMim/hkgz/LR2S93jvp/9HV+4jcGnp8v+uD9ocSDQcKKqVA4LwHFby3zQU9HR8iqJbruTYllOS3S36EZ8aKIUqFtYRp3fx0HYg==
Received: from BN9PR03CA0052.namprd03.prod.outlook.com (2603:10b6:408:fb::27)
 by CYXPR12MB9442.namprd12.prod.outlook.com (2603:10b6:930:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 09:27:12 +0000
Received: from BN1PEPF00018073.namprd04.prod.outlook.com
 (2603:10b6:408:fb:cafe::2d) by BN9PR03CA0052.outlook.office365.com
 (2603:10b6:408:fb::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 09:27:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00018073.mail.protection.outlook.com (10.167.245.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 09:27:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 01:27:00 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 01:26:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 01:26:55 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Uri Dar
	<udar@nvidia.com>
Subject: [PATCH net] net/mlx5: E-switch, Query port function mac only when vport is enabled
Date: Tue, 10 Nov 2026 11:26:48 +0200
Message-ID: <20261110092648.2511196-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018073:EE_|CYXPR12MB9442:EE_
X-MS-Office365-Filtering-Correlation-Id: ad94be12-d1d1-4e54-28e0-08df3f0cccee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|11063799006|56012099006|261022105027099003|261022075727099003|261021121427099003|261021123027099003|261021135927099003|261028144727099003|261102123227099003|261009223027099003|261026140227099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CNWCH6Enb+gUvTCjwDnxtvmFkgjYN+k4nLe5/Flmo/r7Y9N91gdODjjKOYtTXocvQBY0aVKDxPzHfCSEZ/SdtLCyTPJvkHCrzvKwwVOHbIS9SgPkZYziUdhxt2WxsmTyfT6NMdgZhUBVY/DB8nVMwmEPH4paptYUmymgdp3p17QfKl1b4056kKvCydEmKyTgZ/uVLJkUK7YAo4V1SElzCZJM5bsBZW99VzsHab1xql2UV27vmgsKvLOOphGED808iBb7pUv9x4GD+w4K4+1+THlVg0t8uVDBoxVJS2i1P5obCmJytS4N3d2Q9c5Gv/0QD3+YZHB68k5AHS1URsNOFWupYXbcpt+zFhAhmCBB0NsDJB72E1b/rMSLdEG9l+/HqxBFhjpjkS63XGg2oVIsEEBr2uQjaJ1RriAmYEO4sVS5bHUvUcNSxFeoCGUfjx4AAyhoZVzsx1VRGrqXOY1qhtLM0AFVM1Nf+CmH9n8MlBXkkFgA10Rk1KZk2zPnuqC6WujmZD4SD6XpeG7PvD7GuDpkkB7jQFwf4kNmJV4t8rRXWDwmgP1pneWUhZdPobZP542Yyro9YbPcHlumgHNNy5EgO4xqTvrCIn7XNsJ8pT/WODjkT3Dd96i/EAavCH8wQJGFZI6mz+WEdmIVcof2zAkOdJAwefbIteXiK3BwZc7fCIAq0qfoM2FfW8h/kekLDgYhjHUyQb0Y/+whT7qa6w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261021135927099003)(261028144727099003)(261102123227099003)(261009223027099003)(261026140227099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e1LD1xOIMIdBSxnjyHtu6C334iKjCWqK4odAhXDKJ/9XiDJAWYcRqsz+FnftNYKFnZZUIiEidf/0AH3nmQsN/XD2EUcPor4UdimgrP3etVefqhOcE3MfaSp2HgYIi7RNnJL1yChtzY02UMcJyu6n8lw4l7kPJU/Z6jYmcleXn7ETMsS24jfTz2g/j0b5w2iRhzd+70ErFPxL7A8lN81o1JQsqd7245XBDImvhdRZXJsdl3udL75ZJp40dDva37xFoCdTbGo7MyeSDSy6ZIX+MJl0UzlHDP7zyySgC8PlYfK8Pkm9D4hLrhOq/SjJuvFx9s7L6s3vuoy9uiKeGDHKKMl/c8r8kAbPwyJDeEU5FGNwIxv+AYJG6mo6YwEAD/3f2d8Hh3yaFL3aRsJZ1nJEn53EmqhJJd7A7NobQpbrsqxoIkKubxU6Bb/jJA0uhcRA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 09:27:11.8345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad94be12-d1d1-4e54-28e0-08df3f0cccee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9442

From: Uri Dar <udar@nvidia.com>

Commit eea31f21dce1 ("{rdma,net}/mlx5: Query vports mac address from
device") added a call to mlx5_query_nic_vport_mac_address() in
mlx5_devlink_port_fn_hw_addr_get() without checking whether the vport is
enabled. A port function can be dumped while its vport is not enabled,
for example when SFs are created or destroyed in bulk, and firmware then
rejects the query for a vport it has not allocated:

 mlx5_core 0000:03:00.0: mlx5_cmd_out_err:840:(pid 25225):
 QUERY_NIC_VPORT_CONTEXT(0x754) op_mod(0x0) failed, status bad
 parameter(0x3), syndrome (0x29d722), err(-22)

Query the device only when the vport is enabled; vport->info.mac is
updated under the state_lock already taken here.

Fixes: eea31f21dce1 ("{rdma,net}/mlx5: Query vports mac address from device")
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c712848b202d..b83c6c02670f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -5121,8 +5121,9 @@ int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
 
 	mutex_lock(&esw->state_lock);
 
-	mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
-					 vport->info.mac);
+	if (vport->enabled)
+		mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
+						 vport->info.mac);
 	ether_addr_copy(hw_addr, vport->info.mac);
 	*hw_addr_len = ETH_ALEN;
 	mutex_unlock(&esw->state_lock);

base-commit: 1d5e2c57e9ffc134e14b3f837c8d7c53b508bd22
-- 
2.44.0


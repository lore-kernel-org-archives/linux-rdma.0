Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C51499F24;
	Wed, 23 Sep 2026 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160033; cv=fail; b=cO4Jw1iKRc4Q88Yf1mn/NBGb4U0LY2GBESHxrJ0dpuFF3JRx5DNtq6Uj2IZb0PQgoGintS4cWWnV6OLz5NUJohdLbrw+ZRYR7y3ot2qtapxlKRQtudbWL4Ibpkt3qF6vqw0fTixGE0jAT3o9CY1uYfOqQH+Qgh59pYIhCL/FE/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160033; c=relaxed/simple;
	bh=ETrqY/y5St1mcCWKtXGT/9Ww+8m0Wcc5BCTNBEwGxwA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jAzbBXDgiIukftlCBJlM+8Rh/wppRF30dhs+cf44s0+8/cOEfvbHeNbLYhVvTThM+htKeDhjBulS/tGZ+QJcanIoUhMzW7YJGQafQsNmOpPrNWek4bXkZREfQ2e99eT/Z51KEilyDyrD2Zl+L60AM2cXlVtTmWhQi9xbjjnfoNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MUDaKiew; arc=fail smtp.client-ip=52.101.53.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MUDaKiew"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dw+SF90MIXzvWqrHEVJEicOAVHsq+InYhMMSVRcNaVBYb085nSLVDHMvbXZo4Gxl3sVsz5c/9SSd+M0MHXpaD8lzkIt5PXAlf+l8PkEcBzGEhLtv8557A3nMVqGxKCwoK1mKmM36cqlBh7SM63sEF6bHLESPgiJv2ltoppWsGiTjg31g/1ifBEOzmoTn8W1t6dXJgcNeF7kTQEJdXwC5G5CYL4yau8iJWYf0Cat5v10QhKJDbE4QVmLqivhSlKpq6Zin+7yYLfuFEpvMTzp9saDvM9B44FaqMQ5vG06PFzCPg6HVC/uHBXQMKEVZZOJWpvplayvcJ1umHUf+XLwWfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/GHMz7jFaGNrVzMwdWIFM/WwXJgsE8na0dszsJieOY=;
 b=DDjsQJTiMi9Y/GgvGQKmNZh521ES1NiyNNvo93pFKr2UMU21SHDmxhNqiKNaN/FurJ8Y7lra6B4Dt4Y22fdEMU1EE/kx6+ZSzya723vVYTd8nO4s3c9f4hP3RX1OJp1j9LDnWrwFO2PGrYsR93NWbUWBpg8R5cx8c9vAGZj2yOeXR8LNI3lj/RdQCgi5Dph115+tVTWNoKiqCcilqSynqifbdX+Thh3P1fD3A0+ZQIVoSH7HHnYmWWAlxn/SPKKosOyKDuljwSkIxcK4dIHKbT7j0JtmZ17yf/jVF6NvIq7qFyQ5zJVbPoQoOIEsnPdSBa5j4DWzTujMe7mSeVMsEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/GHMz7jFaGNrVzMwdWIFM/WwXJgsE8na0dszsJieOY=;
 b=MUDaKiewRfWlPSc2J3y+vWjQL5qO5vIh1p+KwgL2MRBvPL9+m0qYuPLuvxsb29Y6/QKMTH7uZWjxwXL+2ZTWlGhMdQhRrDkxjNG383svwhboNc4Z9O9PvViX37QfURzNqOvc3eMM902TvIi/k0AH2eHILlLA9LDQhYGCX2lfvweQ5hz1gdjBdoYEm+rMDU+fBrPoDyVi+ehyLjZJfjQZ88YQl7gsD3BrJ44+OKNH1cUHfb3C35PciLGFtwq0ckYG4lyBNC5bFvV2oq08m0zD90QsX70XDIUMz6X0f98V9mPnq9KRAKZiMOeaoUh9oyxzbbroAVaLp3IxqlpbwFo54Q==
Received: from BN9PR03CA0489.namprd03.prod.outlook.com (2603:10b6:408:130::14)
 by DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:40:19 +0000
Received: from BN3PEPF00022BC9.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::6b) by BN9PR03CA0489.outlook.office365.com
 (2603:10b6:408:130::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Wed,
 23 Sep 2026 10:40:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC9.mail.protection.outlook.com (10.167.248.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:05 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:03 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:39:59 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 02/13] net/mlx5: E-switch, do not leave an unpaired devcom registered
Date: Wed, 23 Sep 2026 13:38:19 +0300
Message-ID: <20260923103830.1183-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260923103830.1183-1-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC9:EE_|DS0PR12MB8295:EE_
X-MS-Office365-Filtering-Correlation-Id: 29e121ba-576a-4a72-c132-08df195f102a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sf4aWRx+/nRx/+LzFdyPDHg1w0B3VGHNWHQA4EadSz9po0g45YVpF2QDFYZM7lVhFZOXe2mbdnimSQsb8lsmiIV990rah/k6YnYz0ZeZZRDsvXZ4U6Q5WsxtkTdNteQ4edURsXDrzw19tmCmACxTRvt9fGWzxQFNkwybanAlvQD/YWOetg0wSyUcsVwuWxjSyr5gJ7zqQhZpSJsBlL+u2Pek8alU2X2mrjL4/ZuWtrLjjiZlAk6MFXkfYvSx5k71Aft+UUSCxtcJhHaBdzn7giOT1tvthwdJb1sRpEVzT7TQkkome6A6zNt7Yq76UON2v9qyXcIqodGy7BXcbULvZryIVB6kezhtzN5E4kJgnEb78H0/60ATv8fvgTaMfPJfm2lmnwbqidmwKnqLCWbXe0Bm/EV1yp06/lby9GJjVVLl2WG1r8I9OhArPMzOIDFWw3LyGXuuvqU0G29p/4IyDt0sUOAe5OkEk7vWqpMa0fc07Qm83TQjB6t1hp+IYXw0dL8f4evj0Ky4wV/Nujzd0SFu+mmOZ8CLozzu8sm7pSFHNpTfliqY87BpZpVN8B+TERxBixs6BE/kjwa5AYNgrpb5402dj+/M46U3UhNET3heB1gBL2Rc2kA6BRneSHw2k8ZjrOOShcaU3vZ6kXSQ8oXEBJ7kjEECZMJDgLvqKWLX0vgy54zhoHGzxtQyAKF23kWzD7NhosCR++qov3LrVQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SkLgEzThGk0D8ywPvW+t+4Cg44fPrX0sNX2T9SywmnNinuAGco4ZU2vXm9SAES3HbEsH6fIHdRqgKfs9kjqvUBw9fndAKiNrEKLSsGhsGoSlsUGeE1LjtKeTOfMEnOKSaxukrPpoVkUDMuD32bmWdcryrjvbaVp0aSKoS0PdKkddj2ixk1rC5bCPrNzsHqUU1xKwvIIbt9RcDAVfAhpSe5lImq40lLf0aVvE0haAWFzB4ryX/rwb3pC4B4McKvC443oOKYiWrY59u6nYaVoM9bhtr/Pr262hDhsmdmM1yFUrZCQd32IE4LanIJJh2EBzM2jEItvYTz9veTW3tSqays2WLXBRI7ikeXNQkpydt3FaqPKmWy9NTiPGSfVXbO9TShvkkTEoLZLCrgFqET6LaOiT2gmykwXL1MZGWpI4m1UXvViVzumanIdokjzPzevd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:19.1863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e121ba-576a-4a72-c132-08df195f102a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8295

From: Shay Drory <shayd@nvidia.com>

If the initial PAIR event fails, the eswitch offloads devcom component
stays registered until eswitch teardown even though no peer was ever
paired. devcom is optional, so this is not a functional bug - but a
registered component that reflects no actual pairing is incorrect state
to keep around.

Release it when the initial pairing fails.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eb74b6260168..e7d92d9bde16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3548,6 +3548,7 @@ static int mlx5_esw_offloads_devcom_event(int event,
 void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
 				   const struct mlx5_devcom_match_attr *attr)
 {
+	int err;
 	int i;
 
 	for (i = 0; i < MLX5_MAX_PORTS; i++)
@@ -3572,10 +3573,12 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
 	if (!esw->devcom)
 		return;
 
-	mlx5_devcom_send_event(esw->devcom,
-			       ESW_OFFLOADS_DEVCOM_PAIR,
-			       ESW_OFFLOADS_DEVCOM_UNPAIR,
-			       esw);
+	err = mlx5_devcom_send_event(esw->devcom,
+				     ESW_OFFLOADS_DEVCOM_PAIR,
+				     ESW_OFFLOADS_DEVCOM_UNPAIR,
+				     esw);
+	if (err)
+		mlx5_esw_offloads_devcom_cleanup(esw);
 }
 
 void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
-- 
2.44.0


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726013;
	b=eEBcP4qYuGI3VC33mXKPXSp+aUXlcaXdiexVFMANkIdXHtBvGYbdHPwqY2CB4uNwMl9L
	 uCQ7fmxrxLJRQRFQXc9ZBxScB0JP9+1p7GYFLPXwio3JqRvIzp1lT1lyLtYv5napq4CMI
	 KwB3xZ+rwXMDMzTB0+Fk1bD6kvx77pMKvY+kpzu1DOdI6PGOs+mJp2iFH8tH2HORhS7oo
	 G7cz6wkxAMZQmLanuWno0CvxMiYcbHVNaJKi+Ojt5BiMTgdC9QRyfC2HcUOeKyHffdM+s
	 NfNatgVvORv2DQiDwReMDrxtSwz0i2/rm0RHp/Frg0cHEALr9QEBVPf5NtvZ6mSb7qQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726013;
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
	bh=ODRk7u5OSRi4r5fhy76A40Juy8OtbFhvU7HknqYSaZY=;
	b=ST6OihZFw1dktw7TxUztDR6CJuM0dTOiCjAyDLHk53Otxre/FoBX/pIU05KrnYe4glX/
	 KUCODkaAeImR9oW+RdhO9XlGILC3pmgaeDMuZeh9nuxAPmvmAyWu5uMdUPbaJWVQ1wT/m
	 99W4/fXRDMApSJlMe96NUkQSbjvhsQFW7kTShKmctwe3nOttSdyg7JMn49cCIym0E9aWL
	 9yRSuYVw0zKMhOvwLbYp80calNAj44REyit9fqPXom775lX1/EmTDsN2f5umflvEsXhO1
	 4ykmRPhW6qjTxyokofos5cfvhvt4nVGC94Y5tsvN8+fOYClxSsQyXbBZu5sFScDm5lg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gZUXVgtJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.11
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16536606D80A;
	Tue,  3 Nov 2026 17:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16536606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gZUXVgtJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEV3yDWOC2d2D+LY4kPf/fmsDGXUEs6du9Q7eiKGa2JGHapCDEl0u8jXSI4TmwVZCvAgKKlBxc4EYKMiIvCgscWxhHwX3veizfETdpCpvTRn+qOggQXPRVosS4217lSGRPd5zb2KLyUDRRZwO2zEkEIRMsU196n3A8EQnKr0O/CLi0TFEcP43TXtdjytl9lRFDFbcTnZACpZ+Pr5z2E/xOUQei5elOvvDK30oWe913+DFuAarL277iZZkyULl7cPU4TyIWGXwxpV62U+9Qdf7pS/+zx/q8JcAtKSGnGavo1e1n4VlOWvO89aiynKiQNVZk8rcpLzSZy0Ymj91DnJRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODRk7u5OSRi4r5fhy76A40Juy8OtbFhvU7HknqYSaZY=;
 b=Hf1gly6aSoiot7dDDiWL4CKU3MThegegi7OEFaV980w+Vp97CZSVJ/cFVHYaI+rdVegGl+OOvsBz13r8z4FF1UBD3jzFpIo7UNeav61GWk93Rph2FkPB/vUatGt8Ytw/e7ywY3YoirDq+q+OxmL92moVctmBXMn6cxfXfTGQMJoz6Eo34CoDrchZbMZ3kzJwNE5I0fY6Y99HboernQxkZlGzaAMLpvVkaZ0/FRv/8ZhIQ5EE3o78M0u+c1YHYxFjZqX3KZy/G13YRhMBHaDSYsFN48EqjvI2AoUTKtm8IQfzzotyRiJcpDaUUvQDZpcj6Lb8BhpVNwBrciSKu/kpYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODRk7u5OSRi4r5fhy76A40Juy8OtbFhvU7HknqYSaZY=;
 b=gZUXVgtJc4FRIwFZZJjdoZEAtyiuCgH8GBdYonvUj+qDBoLADRHuY2vJ+XktNSb7Aln3qFaHI9WUBZLe7R3js6i+MO2NqPlR12GYfpRfmxUlkpdJdCZjzyRGNS5H8d6o2/F6NCg6CZjOtBBbmnAqMU+Eei4FfxGqnD72yd2sUK90wnAIlj8PIwuCmMLKLeteuXwJ4chJFZO4BTDtL9mAfTVdZNa8V/VyTnALBroAWFml9vkPGHGhq66t75nXeox2gPiI4zSyAOfBDfvHFijo0jYuoaSBIbcsvticZcMqmGEKyEW0cCUrYAjtZv4ygbKMHeG4XDfbUztF6ntJ3PUrSg==
Received: from CY5P221CA0141.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::14)
 by PH7PR12MB9076.namprd12.prod.outlook.com (2603:10b6:510:2f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 17:13:26 +0000
Received: from DM3PEPF000265AF.namprd02.prod.outlook.com
 (2603:10b6:930:6a:cafe::2d) by CY5P221CA0141.outlook.office365.com
 (2603:10b6:930:6a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265AF.mail.protection.outlook.com (10.167.23.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:56 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:51 -0800
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
Subject: [PATCH net-next 13/15] net/mlx5: E-switch, drop master egress rule under a SW vport LAG
Date: Tue, 3 Nov 2026 19:10:07 +0200
Message-ID: <20261103171009.563034-14-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265AF:EE_|PH7PR12MB9076:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ed2e413-8175-454d-fe86-08df39cdc648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|11063799006|261022105027099003|56012099006|261009223027099003|261021121427099003|261021123027099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fLEsWbATjjxjdijoSJLsKDsTnEG+Z3DPobd1jwXSlekzKsf50+9o23QT9W0fT+Uqg1di72dmYKi2YYr3+ESaBCuoJ1eccGMqrhaB8v8svDE5CPM35wIKPbS4cMTrrxOTSlxMaaEA2CvcIHjjyQLE/k9lM3j/a/wxp9lVO1ssjWFM3TfD6K4zKQOE1wh7bspNqAze2A0IYK3mjirORQWDjeqfKlYvodRFknXaIJZRP3UYzC45HArGd61eWYSgtpK5yzGZ2lMoOi/ZZLvDiJRTAuWOqPepuahiwVSVLtJYvx8sBUW6QFNaKocdmfXdmU5V22PFCnDBJFXGegUaFoJM6O2xZ5In/1USpiDmJe6Xj7x18l5atHgVr/BNCnwZQgBen7n50FCf/SBT6F9EORIuBy1UFuWK0doaMy1oErhsfSLxqF4TfY9v3DP4dAPCTeTbNOyYZpV6dNgLGSFKzjCoU2oCwM81Isfl9/2XKyMZeWHIZj8wcSeDnOmvAw4JVpC+ieMGgeXKYNAGOX4q5BqfmUxH6DMNZongZYZ1wvPDWMrBTdfLjmnST+i+DRe+s6HFhVEECDNk2uzOVrs4TjmCqriMq6KhI55lu0/NBqed1/wLtHL+HCmdfMknJuNgTAVlrK1qdXRDagy6eBGCbH6EtGfujYgJqQYSPNMeRPZo42Q4W9hX2MTMjj52I6HGK6EXr1woOb7r1xsofI7UiRkUIw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(11063799006)(261022105027099003)(56012099006)(261009223027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cv0ZN/zPF2VPc2Rl0CmFwcYiulfRqMnIZcahoeSPvNFm0BiObTU8BEPe3kIMXLZHF7ILjj3w78rhNk7/8x9fzBnxujj+yseGc7F/UXRoag1gF2pJgLEPp0I0Uv6f2Vuw5acNyzVfj+NvOP40nJFgsyCT2XcEsnAT0Ti+jkP4NemeViRAfyVzAh+zMPldLECQOVqTJuf1gfd2VMjxZbgRL1wrZpC/jz2hmfoLu0k/VFBgA50jsp8WtZZIxYkLR3CQWnEczRcCp5B9zFqsAkPN38MTbiOv34xoTzQUW9jSpTDEx0M/0bbvl6q4X3MQD7Im8TWPDfmQVrN7FWtc0S6PxjBXEuIXJAWPR/htIRxwRDlBkbhpVTfCIGHCf8wv2Lt5739HTWAPexb1utYN0VlkrTapxD8ktRmuXyHfE8e5I/HUtv4/jd4kNPA1P+az/mvZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:26.6539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed2e413-8175-454d-fe86-08df39cdc648
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265AF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9076

From: Shay Drory <shayd@nvidia.com>

VPORT_LAG steers all traffic of a LAG slave to the LAG master. The
eswitch master egress rule does the opposite direction: it bounces
traffic that reached the master's manager vport into the slave eswitch.
With a FW vport LAG the FW steers that bounced packet to the LAG master,
so the two coexist.

The software vport LAG emulation cannot. It is a catch-all rule in the
slave eswitch's egress ACL that forwards to the master's manager vport,
while the master egress rule redirects the packet after the FDB - past
the point where the slave egress rule is evaluated - so the bounced
packet never reaches it.

The two therefore cannot coexist: drop the master egress rule when the
software vport LAG is installed, and restore it when it is removed. Both
rules are keyed by the peer vhca_id, so each slave swaps its own pair
independently. Restoring needs the ACL size, so pass ldev->max_funcs
down to mlx5_eswitch_offloads_vport_lag_del_one(), as the single FDB
path already does.

Also, release the MPESW metadata after the shared FDB is destroyed,
mirroring the creation order. Releasing it first makes all slaves fall
back to the same default uplink metadata, so the restored master egress
rules collide.

Note that vport LAG on its own only gets traffic to the LAG master; the
distribution to the other slaves esw managers, which was managed by
master egress rules, is done by the LAG demux

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 24 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  6 +++--
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e9cbcd73b23f..55f5ea522d46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -957,7 +957,8 @@ bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 cont
 int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
 					    struct mlx5_eswitch *slave_esw);
 void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
-					     struct mlx5_eswitch *slave_esw);
+					     struct mlx5_eswitch *slave_esw,
+					     int max_slaves);
 int mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
 					     struct mlx5_eswitch *slave_esw, int max_slaves);
 void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d633c63b309b..f1a5d7d036cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3381,12 +3381,32 @@ void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
 					    struct mlx5_eswitch *slave_esw)
 {
-	return esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
+	int err;
+
+	err = esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
+	if (err)
+		return err;
+
+	esw_unset_master_egress_rule(master_esw->dev, slave_esw->dev);
+
+	return 0;
 }
 
 void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
-					     struct mlx5_eswitch *slave_esw)
+					     struct mlx5_eswitch *slave_esw,
+					     int max_slaves)
 {
+	int err;
+
+	if (mlx5_sd_is_primary(slave_esw->dev)) {
+		err = esw_set_master_egress_rule(master_esw->dev,
+						 slave_esw->dev, max_slaves);
+		if (err)
+			esw_warn(master_esw->dev,
+				 "Failed to restore master egress rule (%d)\n",
+				 err);
+	}
+
 	esw_unset_slave_egress_rule(master_esw->dev, slave_esw->dev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 584436668a5c..3dd7fa8de66c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -208,10 +208,10 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_MPESW)
 		return;
 
-	mlx5_mpesw_metadata_cleanup(ldev);
 	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_restore_sd_fdb(ldev);
+	mlx5_mpesw_metadata_cleanup(ldev);
 
 	/* Pair with the master mark taken at MPESW create for VFs. */
 	if (ldev->virt_lag)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 404278a15ef7..90209e4b99f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -126,7 +126,8 @@ int mlx5_lag_create_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 		if (j == master_idx)
 			continue;
 		slave_esw = mlx5_lag_fn(ldev, j)->dev->priv.eswitch;
-		mlx5_eswitch_offloads_vport_lag_del_one(master_esw, slave_esw);
+		mlx5_eswitch_offloads_vport_lag_del_one(master_esw, slave_esw,
+							ldev->max_fns);
 	}
 	return err;
 }
@@ -153,7 +154,8 @@ int mlx5_lag_destroy_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 			continue;
 		dev = mlx5_lag_fn(ldev, i)->dev;
 		mlx5_eswitch_offloads_vport_lag_del_one(master_esw,
-							dev->priv.eswitch);
+							dev->priv.eswitch,
+							ldev->max_fns);
 	}
 	return 0;
 }
-- 
2.44.0


Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3223A49E5E0;
	Wed, 23 Sep 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160086; cv=fail; b=mdKFGFx76tc+9rVg1GI7+C8L6R179MDmEHieslJDQz2vZYDqnRSvVvfuDec2YD/XNlCVWRNBglo2+uLyABF5X+qi1GR7k4DDLtxdi1jn1l9seBYJwpze+VB1xO25xDAd4S2bfLNJK8md6Bk7/Q8Hhpinn6A4ssTc5tiqmsKF9vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160086; c=relaxed/simple;
	bh=mRWQ7XwTOX3oeSiURMCdPOFcAl185E1YJquGxUw97vI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q48So6RsvuObNPCkq29JOaxyOf/TFwwl63unXw4jYSj+akqaNLG1DedATVH9ck5wWBA7QQPZsgyvEWAO34PKxTk1H3A4xMQxcW7XdqDES0G5jlURj6uFda+bi+xAMa3EViAz8n6vd3Gf9qSXHGVdD6ZyTyVojcIR3SathVi2lYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C5m+DOPB; arc=fail smtp.client-ip=40.93.195.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C5m+DOPB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/n+E3n1l9NxvuKgOv4j8VlwYzDegumU1f39Vswp5g88NKJqYsBebPcUXKDtqeJkbkM9QvO9DKJnO/vVrGCMp8OJhovKVbnqAd8/vS/zYr2MoObhnRr35ELzvl6WJl0aL2+CkLtEcRTK0G+hEhuYOSwxrz09CljrQS8u3AgzrJRg8kHTPdp4iFmm8TbCxIZ/vXQzw2p8Qs4BHBYtNq/jbHtt9qkDdgpkvlv8/MDbLQ6a9f02vxFbHIqxLDBs4eHk9Xoyj5D1I+bH3HDbRqpN4QWSHSWiBG+8+oem2ovkr0TjbO0IxpY0suz0Y1aAD0fdYNXkviJ0K3HzrO3f6KI7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXNrUYqZmq0ST+9278A4L7YU8vZCo27DZUwgY4QxpY4=;
 b=WqvuxwYHB1jmU0o4Jyh2kHyaS+GG5UHz6PhTeF2W3tp9FtGw+fOKo5aEq4YXQ8A2F7DXR8yyjpxo8LpNEXBclbSLIjtP3w/wmv9mL96O4PUFUscPHG4fMI/+cNTLYxUF32vKnwFZXt4upreIqM7H/7wLAR1YcIzMuLBPskvT07sN5xINQR/t4IxakPiIbZ0Bmg4mrlcpbP+Uoq8ZNGUNrJHTACbTqb+x9NJqXXCYqU9WWfEBvtmCyswdKQ+iC8vH8celF6qi6K1ycYEH5UPGfXKfKDU4e8DGtXUGyMCVqYANTaJ7JcP8nZGDesa9SnK5fu0r8VeLjCcQWUDzbKu6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXNrUYqZmq0ST+9278A4L7YU8vZCo27DZUwgY4QxpY4=;
 b=C5m+DOPBEsTRnpMhyBRGWQJ+stvmDct/uX8v5Pn/vqbxJW4JMk/nTEB8jSrpDejlsvAhzEmKSZ66EwWsHlo7R4Y8FU0jqAC9IM7uAvHakpyRydz+9hB8nLUPdWOJXIFVoDSANgFYkix5Ka9OJ6nQc+FsM15oKdlpl0GWmJ2aAGaTY1XgXIoAU4vwXF28o4kRg9HKlDtP2X8D/G2eXxFqZVjCn/rw0bIlIhFVsqyC2ms6b+fvK+qXE5fmPVr3IN1jmIRyyyOHjW16I56U4H9qTiqMK00owZyReDMMOM9Zyx6ZwfSVWdyC8Cm/im1M59p4u0s+n+iR7pLonChvuwq7+w==
Received: from BN9PR03CA0505.namprd03.prod.outlook.com (2603:10b6:408:130::30)
 by IA1PR12MB7638.namprd12.prod.outlook.com (2603:10b6:208:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:40:49 +0000
Received: from BN3PEPF00022BC9.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::27) by BN9PR03CA0505.outlook.office365.com
 (2603:10b6:408:130::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Wed,
 23 Sep 2026 10:40:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC9.mail.protection.outlook.com (10.167.248.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:24 -0700
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
Subject: [PATCH net-next 07/13] net/mlx5e: TC, anchor peer-flow reverse index on the duplicated flow
Date: Wed, 23 Sep 2026 13:38:24 +0300
Message-ID: <20260923103830.1183-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC9:EE_|IA1PR12MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ddc0f5e-1089-4126-5d15-08df195f21f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OyEX+V8gW17kXQCGuQQfANVgdyJgbZIlHABPZqY6Epv5+Lf+KM4vPkjJ57bQfszXh+t0+dEKnOkfEH+Ql9Kfw9/UNRtWZAPCA4G7JgNCa0kqcyW+pjxq7ZVGohncEuZUXG/bLYN1AzMUZ8Xri3mALFX0k/CTIJKQKoNrblKC/Pcg1RcARk5Gg4xh7R9wt9Wyr2hRudzT9TeDdB87Mso0VxU+aKZ4YR3t6aJjWWM7UjQF/I3/KJFmTF8iYJkkOM12cvs2XEVYmFUvGFdMhoP6OYaO9qsaLv2jyh45hq7CWyktnsjnzxRb9GxZ376E/fEs0ShT0TRFeoIOvlnDhEE4u5iS6DzRN0o17OMao018aXeZ/VGeHvS9AQxwaMTxqLrl4DqwtzFo67J8KE3SRbGcAN1ePNZ/qgB3uYoa3h10mOoLhoerw8+OP1OlOHKY9kiqekwAUBDDgsthS+b7/Ie1quei5iXQIKhIXO2w8CorOULOUtTYRH+30i74PrcKj2SqTl4dGkuirxeViYasNawh0uKoICkK8MznWPyVyaFBNAs1J3g6DR3jqzCXfY7wHfO/CFTeq8fdxc6uL1kfwCeh9O06+e5pikSco+OWQ6w4I/g2T8gJhDI7tuvzbes7bLsyYCIi01HV7Tg8wNXg4WrNbkhnP8PFBP4sDTPIQjXamL7TQhzJRiUQ3GsTQfOkRrKMDip2fApCO+JO/Sx09gIarw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v0dL5KulHoyW64Mkain+n4WSb+xw1m0DPrYUS/rDLb76nYcLETpr9jO2CWcUzMBQHFPCCmBdMIAYvZUSVl198XGZ5qtOy7YPBT+WHWnNo7z7MjL18dyJ6R0B2l+gC8PsBfjeOVdRXmYtbOEdvVVqn6hprU3SDFxJgcSMF68cqNiPmiaeynQosp2+nsGw/HVXJ+t0YqgnoiH/SUx+mBELU6t2cT12PEmOhPTP5OAX+x8jU8tSfswN6dG8gijHZATwkqMGv6UUh+SUVCZ/xJ7kGXN0CtcsQ4oz2G6ul96seVuLF0//on0HwlfHC/UxL4yna0nssySdG0bpwCg9TqhXhevTjjFtlA36kcIkHFLBUQ+vxjo5MhdC2hxAfyTb3X0Yr+w0NStgi+98Pk4PD+JhWNbv/rzq5nM8A8X/9f+31o89PGb1RYAzYQIDMcS8nGzN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:49.0146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddc0f5e-1089-4126-5d15-08df195f21f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7638

From: Shay Drory <shayd@nvidia.com>

A TC eswitch flow offloaded to a shared FDB is duplicated onto every
peer eswitch. Besides the forward list of duplicates on the origin flow
(mlx5e_tc_flow.peer_flows), the eswitch keeps a reverse index,
esw->offloads.peer_flows[], an array of per-peer list heads keyed by the
peer's LAG sequence number, used to tear down a peer's duplicates when
it is removed.

That reverse index was anchored on the origin: since one origin can have
a duplicate on every peer, the origin carried per-peer storage sized to
the max port count - a peer[MLX5_MAX_PORTS] array of list nodes plus a
peer_used bitmap - and each duplicate stored its peer_index.

Anchor it on the duplicate instead, which belongs to a single peer. Give
each flow one list node, mlx5e_tc_flow.peer, and place the duplicate -
not the origin - on its peer's list through it; add a peer_orig back-ref
so del can reach the origin from the duplicate. One node then replaces
the origin's per-peer array, and del unlinks the duplicate directly, so
peer[], peer_used and peer_index are dropped.

The per-peer list heads remain the fixed esw->offloads.peer_flows[]
array keyed by the LAG sequence number - that array is replaced in the
next patch.  No functional change.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  | 14 ++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 59 ++++++++-----------
 2 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 7bfe7cdc5770..1ceebab4ce08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -97,18 +97,14 @@ struct mlx5e_tc_flow {
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
-	struct list_head peer[MLX5_MAX_PORTS];    /* flows with peer flow */
-	DECLARE_BITMAP(peer_used, MLX5_MAX_PORTS); /* tracks populated peer
-						    * slots
-						    */
+	struct list_head peer; /* dup: node in origin esw's peer_flows */
 	struct list_head unready; /* flows not ready to be offloaded (e.g
 				   * due to missing route)
 				   */
-	struct list_head peer_flows; /* flows on peer */
-	int peer_index; /* peer-flow index pinned at add time, used at del
-			 * time so removal is independent of LAG state
-			 * changes between add and del.
-			 */
+
+	/* origin: its dups; dup: node on that list */
+	struct list_head peer_flows;
+	struct mlx5e_tc_flow *peer_orig; /* dup: back-ref to origin flow */
 	struct net_device *orig_dev; /* netdev adding flow first */
 	int tmp_entry_index;
 	struct list_head tmp_list; /* temporary flow list used by neigh update */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369a..fae4f8625da4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2116,43 +2116,35 @@ void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 		mlx5e_flow_put(priv, flow);
 }
 
-static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow,
-				       int peer_index)
+static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *peer_flow)
 {
-	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
-	struct mlx5e_tc_flow *peer_flow;
-	struct mlx5e_tc_flow *tmp;
-
-	if (!flow_flag_test(flow, ESWITCH) ||
-	    !flow_flag_test(flow, DUP))
-		return;
+	struct mlx5e_tc_flow *flow = peer_flow->peer_orig;
+	struct mlx5_eswitch *esw;
 
+	esw = flow->priv->mdev->priv.eswitch;
 	mutex_lock(&esw->offloads.peer_mutex);
-	list_del(&flow->peer[peer_index]);
-	clear_bit(peer_index, flow->peer_used);
+	list_del(&peer_flow->peer);
 	mutex_unlock(&esw->offloads.peer_mutex);
 
-	list_for_each_entry_safe(peer_flow, tmp, &flow->peer_flows, peer_flows) {
-		if (peer_index != peer_flow->peer_index)
-			continue;
-
-		list_del(&peer_flow->peer_flows);
-		if (refcount_dec_and_test(&peer_flow->refcnt)) {
-			mlx5e_tc_del_fdb_flow(peer_flow->priv, peer_flow);
-			kfree(peer_flow);
-		}
-	}
-
+	list_del(&peer_flow->peer_flows);
 	if (list_empty(&flow->peer_flows))
 		flow_flag_clear(flow, DUP);
+
+	if (refcount_dec_and_test(&peer_flow->refcnt)) {
+		mlx5e_tc_del_fdb_flow(peer_flow->priv, peer_flow);
+		kfree(peer_flow);
+	}
 }
 
 static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
 {
-	int i;
+	struct mlx5e_tc_flow *peer_flow, *tmp;
 
-	for_each_set_bit(i, flow->peer_used, MLX5_MAX_PORTS)
-		mlx5e_tc_del_fdb_peer_flow(flow, i);
+	if (!flow_flag_test(flow, ESWITCH) || !flow_flag_test(flow, DUP))
+		return;
+
+	list_for_each_entry_safe(peer_flow, tmp, &flow->peer_flows, peer_flows)
+		mlx5e_tc_del_fdb_peer_flow(peer_flow);
 }
 
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
@@ -4639,12 +4631,11 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 		goto out;
 	}
 
-	peer_flow->peer_index = i;
+	peer_flow->peer_orig = flow;
 	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
 	flow_flag_set(flow, DUP);
 	mutex_lock(&esw->offloads.peer_mutex);
-	list_add_tail(&flow->peer[i], &esw->offloads.peer_flows[i]);
-	set_bit(i, flow->peer_used);
+	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);
 	mutex_unlock(&esw->offloads.peer_mutex);
 
 out:
@@ -5539,21 +5530,19 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
 
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
 {
-	struct mlx5_devcom_comp_dev *devcom;
-	struct mlx5_devcom_comp_dev *pos;
-	struct mlx5e_tc_flow *flow, *tmp;
+	struct mlx5_devcom_comp_dev *devcom = esw->devcom, *pos;
+	struct mlx5e_tc_flow *peer_flow, *tmp_peer_flow;
 	struct mlx5_eswitch *peer_esw;
 	int i;
 
-	devcom = esw->devcom;
-
 	mlx5_devcom_for_each_peer_entry(devcom, peer_esw, pos) {
 		i = mlx5_lag_get_dev_seq(peer_esw->dev);
 		if (i < 0)
 			continue;
 
-		list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows[i], peer[i])
-			mlx5e_tc_del_fdb_peers_flow(flow);
+		list_for_each_entry_safe(peer_flow, tmp_peer_flow,
+					 &esw->offloads.peer_flows[i], peer)
+			mlx5e_tc_del_fdb_peer_flow(peer_flow);
 	}
 }
 
-- 
2.44.0


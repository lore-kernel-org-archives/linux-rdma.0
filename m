Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22284A093D;
	Wed, 23 Sep 2026 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160092; cv=fail; b=eopVXw9xniAL+6+kvz7YqijlUWyZez8jrq1cAYqBM3z3lMVX9H10lPGv4JFLFyg2246yqbEJ0Y4GhJIIoLHHAQCIe/YSn3wjPAzbwhRD99g6H824BdWlor+cWq3ycH+HdjgyKoH8TFZ+6M9hdi8/MrgUWiU6nDgavUFlmhfkdIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160092; c=relaxed/simple;
	bh=Ti5cNctTUYwX6QWQdeZrDrLxafslmYTaErRnRozxn64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObtdgSGKbDdpZvmOMmt12nvS599LVEjI4/77Y/TLDRmJL92cpOpgfr3SNzs8vo37LtofpObebH4nVu6cL/zsAyDWkR4Bi9cK0BToXF68HcI1sEeuyHaQvJIELn/eCdYqeFzGVyaqzEOPLnTw/4PR5yrN2iwD1nMidyb0rJMblUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BSFceCWd; arc=fail smtp.client-ip=52.101.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BSFceCWd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZRqRxKZ3o1UPwB7VxmOXORjYxTGsZ/zaENQTcaJRhnByz9XXpQyIPc34ekvHA90shE1VjDbLJLjJVu2/g6OTq3QRECUz6deUXIoKcIFjStzC4EfTLCPvlSGH1/UhlO6DI7cXZxhdMrmOJPz58xA7D4FPVJJmG75YufAL4W5uI1FUJmpMZayM117nyyGNS/tWcqWYoZ4T/04snx/F7QKN3PUsfMXdXqUsCyZYxYd2Hh4LH0kpryWYJlvUZoGfONeft2mE2KdWm3GfAZJ/UFmGQKNPa3lrjg+HeKY0dRArR8WBPNyg7A1PAsNhE+PmneGntWweJZcIzawcvdZm2MYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6a+hkVaRteaJfvQSavsNbKSNFA/vY23RfLYdPUV2fs=;
 b=dYU6kGCDAgaNIQ571yRTgW3ViE5iTeVb4GbiEjKOtmKvYUKW1q7XH841MA2sGteg0IVtvOTJB0KwU0yFaiZje55JEAK7ctBzb2m8Rev8Z5C0WVCr2y19rwAS/uK6qlvb7C60DE2yO1oSwW/Iek/uZrsg4DmRoBGfIMIkn4i9NqKnJyB2JJNntYhiRQZFxc8TvDbSiMnTmCi8qzw/WhtxEv40iHkkYrAxl/az9ye0hPkWfSCAwwwOCBJiuJBY/WlWD6WSJb2VZDfKOroL7ZbI51gUp2T1Dk3+y3H/oyPYz8e76YLQJfHgLvmYW7CSsXBwXtNSzo5HJBp201IKaHD7yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6a+hkVaRteaJfvQSavsNbKSNFA/vY23RfLYdPUV2fs=;
 b=BSFceCWdKgyuuFuPAUhHChc24vf++5EKhxZDbRa6W10ZlOVD0OXj4V8CO1E1anYn0dW27JegZ0Cz/IeNAtj6ZuL2x+PAkjxJiPspdqjc1M5BJFNTB5poYZhjzltzvguIZZr6OqroB7pVj/JvF6U8uU6rqv5Pv5tQq9thG58mXbEN8ZDjdaTO5OnDl83+TESs8sU7jMIwXy6bz/aLsh0G11P0nWRQgUsb7uEYvBmF2ncaFmQB1dy7CN8QHXmiTCcMKkE792Dw5GNMMpEJmvaUHAKgMAwDYKgjEMBF/3Nz9BoLuppW3SWbwn/oeBnFGm1THKXVR1cjFr8LYPvQSKVo8w==
Received: from BN0PR07CA0030.namprd07.prod.outlook.com (2603:10b6:408:141::13)
 by BL3PR12MB6594.namprd12.prod.outlook.com (2603:10b6:208:38d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:40:54 +0000
Received: from BN3PEPF00022BC7.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::1) by BN0PR07CA0030.outlook.office365.com
 (2603:10b6:408:141::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Wed,
 23 Sep 2026 10:40:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC7.mail.protection.outlook.com (10.167.248.212) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:34 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:29 -0700
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
Subject: [PATCH net-next 08/13] net/mlx5e: TC, track peer flows in a vhca_id xarray
Date: Wed, 23 Sep 2026 13:38:25 +0300
Message-ID: <20260923103830.1183-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC7:EE_|BL3PR12MB6594:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b763d84-78bb-4fdc-4efe-08df195f24c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Fpr4EeaS1MCMxGYa2DCQQuhYIbBz8qv/T5NhHdIC5HoENA/kg7msol1ZOpsuigS3aQYb9AuS2zWX7NVh4yOcK84bJoyCYTV/7VpeWIOZ03+mc48UjKdDUGLWp6LczC03uFt8NdHMB4eaEDUDXY/2SFByE5ZiXo/A15zcyo4jpb/Rbs8tfvB7EkRqGrdxn/sxMqOT6SSPhEnsbfuIXeWdcgU573wA8eXtJxWfC+HFwdGSGWVdMV/E45q/HIMJudMbmBy5cmoVPfqdEgeCipItajIvdTyBARUQxj06sP6AjsGXu1QAlXL+9cRGwMUQOQvm3A+TV8ce5arnh53NiazOfFaArEAwXAAPS5OdLlDjl2qTeFZ6J+qOB4h2aZ1KuVGFzDiMTHQI1uDj5s01BwH/L0h9xZdSf5QZypBjux/MhzI0pP4SVHa5fy+p/uuXaBUBMUJHskKthLOcjNIu7X5fIXCwbnwMqnRgltv3WQmoHU+elbWJP30Ne1DIQMvphcUDL3YghpbYDdcJtN2/RIQm5Sm5dqtmPkWvin6XvnVEv4IvA42fQpuZzj9ZxVclJiivYBmgCCPH1uaGYQ+2uIUV7ufnZFhH28okessahFAtEFPSvnjIaexw1oyXJbE5YohOheTORDMc9+h/+5yVhxOlbfuml4eu7v1RTCwjWcpayjqrmXLVFnu17JqK9bitFAFnHpAcvMBMRJ/0am0hTh08Fw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ouapHfzDcSfAjzre65hn3t+cnnWl5G9JBNqS+hugF5B/LXzLKzWhu6F7TNjuo9jSgF7hPJ6PsJjBastTccGtxYHTAyhSn16LtrubMTPa+BFTMJs6TGcxzytJvK2FnXFkSzVzEOzVu6P6c0U36m8pC6d4V4R2eRaShbxJkGmwjGazInpUxs8qN8/qH/9HwAhpoi2myZYx6hRi+iuuh+8zH3zWZTh3BhhJhPClizYgmT47kTmY5eRc54IlFyWRPPJhQ4qV/RiTQzOSxcPdxHd7meqeYqL8pusGyjni5rYcuKbDFY8FRPXx4cnPeUNT1NuJNAfdqmVJTSo6He/JIdY0xJ9zbTK/8QwJXopfNdn9XFqYm4/tU4gq0hLjAdAHthtBN2dX2F123UapHDXXrWk04khK8eAe4GUJ+ijmJcBqqXaN4TjAFLVXVIs5E43LIV0m
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:53.7764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b763d84-78bb-4fdc-4efe-08df195f24c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6594

From: Shay Drory <shayd@nvidia.com>

The per-peer reverse index lived in a fixed esw->offloads.peer_flows[]
array of list heads indexed by the peer's LAG sequence number, capping a
shared FDB at MLX5_MAX_PORTS members.

Replace the array with an xarray keyed by the peer vhca_id. Each entry
is a heap-allocated list head that chains the flows duplicated to that
peer via their peer node. This lifts the MLX5_MAX_PORTS cap: the number
of peers is bounded only by the number of distinct vhca_ids.

The lifetime of the duplicated peer flows list_head follows the devcom
pairing of the two eswitches:
  - pair   (mlx5_esw_offloads_pair): kzalloc_obj + INIT_LIST_HEAD +
	   xa_store the dup_peer_flows under the peer's vhca_id.
  - add    (mlx5e_tc_add_fdb_peer_flow): xa_load the dup_peer_flows and
	   list_add the duplicated flow's peer node.
  - del    (mlx5e_tc_del_fdb_peer_flow): list_del that node.
  - flush  (mlx5e_tc_clean_fdb_peer_flows): xa_for_each dup_peer_flows,
	   drop every duplicated flow on it; called from unpair.
  - unpair (mlx5_esw_offloads_unpair):  xa_erase + kfree the
	   dup_peer_flows.

So a dup_peer_flows is created when the local eswitch pairs with a peer
over devcom and freed when they unpair.

No functional change.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 +++++++---------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 26 ++++++++++++++++---
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fae4f8625da4..c99e824b4c6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4596,12 +4596,13 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 				      unsigned long flow_flags,
 				      struct mlx5_eswitch *peer_esw)
 {
+	u16 peer_vhca_id = MLX5_CAP_GEN(peer_esw->dev, vhca_id);
 	struct mlx5e_priv *priv = flow->priv, *peer_priv;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	int i = mlx5_lag_get_dev_seq(peer_esw->dev);
 	struct mlx5e_rep_priv *peer_urpriv;
+	struct list_head *dup_peer_flows;
 	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5_core_dev *in_mdev;
 	int err = 0;
@@ -4634,8 +4635,11 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	peer_flow->peer_orig = flow;
 	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
 	flow_flag_set(flow, DUP);
+	dup_peer_flows = xa_load(&esw->offloads.peer_flows, peer_vhca_id);
+	if (!dup_peer_flows)
+		return -ENODEV;
 	mutex_lock(&esw->offloads.peer_mutex);
-	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);
+	list_add_tail(&peer_flow->peer, dup_peer_flows);
 	mutex_unlock(&esw->offloads.peer_mutex);
 
 out:
@@ -5530,20 +5534,14 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
 
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
 {
-	struct mlx5_devcom_comp_dev *devcom = esw->devcom, *pos;
 	struct mlx5e_tc_flow *peer_flow, *tmp_peer_flow;
-	struct mlx5_eswitch *peer_esw;
-	int i;
-
-	mlx5_devcom_for_each_peer_entry(devcom, peer_esw, pos) {
-		i = mlx5_lag_get_dev_seq(peer_esw->dev);
-		if (i < 0)
-			continue;
+	struct list_head *dup_peer_flows;
+	unsigned long index;
 
+	xa_for_each(&esw->offloads.peer_flows, index, dup_peer_flows)
 		list_for_each_entry_safe(peer_flow, tmp_peer_flow,
-					 &esw->offloads.peer_flows[i], peer)
+					 dup_peer_flows, peer)
 			mlx5e_tc_del_fdb_peer_flow(peer_flow);
-	}
 }
 
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8b1f93b13ea9..e9cbcd73b23f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -319,7 +319,7 @@ struct mlx5_esw_offload {
 	struct mlx5_flow_handle *vport_rx_drop_rule;
 	struct mlx5_flow_table *ft_ipsec_tx_pol;
 	struct xarray vport_reps;
-	struct list_head peer_flows[MLX5_MAX_PORTS];
+	struct xarray peer_flows;
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e7d92d9bde16..c712848b202d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3383,10 +3383,15 @@ static void mlx5_esw_offloads_rep_event_unpair(struct mlx5_eswitch *esw,
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw,
 				     struct mlx5_eswitch *peer_esw)
 {
+	struct list_head *dup_peer_flows;
+
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	mlx5e_tc_clean_fdb_peer_flows(esw);
 #endif
 	mlx5_esw_offloads_rep_event_unpair(esw, peer_esw);
+	dup_peer_flows = xa_erase(&esw->offloads.peer_flows,
+				  MLX5_CAP_GEN(peer_esw->dev, vhca_id));
+	kfree(dup_peer_flows);
 	esw_del_fdb_peer_miss_rules(esw, peer_esw->dev);
 }
 
@@ -3394,6 +3399,7 @@ static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 				  struct mlx5_eswitch *peer_esw)
 {
 	const struct mlx5_eswitch_rep_ops *ops;
+	struct list_head *dup_peer_flows;
 	struct mlx5_eswitch_rep *rep;
 	unsigned long i;
 	u8 rep_type;
@@ -3403,6 +3409,20 @@ static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 	if (err)
 		return err;
 
+	dup_peer_flows = kzalloc_obj(*dup_peer_flows);
+	if (!dup_peer_flows) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+	INIT_LIST_HEAD(dup_peer_flows);
+	err = xa_err(xa_store(&esw->offloads.peer_flows,
+			      MLX5_CAP_GEN(peer_esw->dev, vhca_id),
+			      dup_peer_flows, GFP_KERNEL));
+	if (err) {
+		kfree(dup_peer_flows);
+		goto err_out;
+	}
+
 	mlx5_esw_for_each_rep(esw, i, rep) {
 		for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
 			ops = esw->offloads.rep_ops[rep_type];
@@ -3549,10 +3569,8 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
 				   const struct mlx5_devcom_match_attr *attr)
 {
 	int err;
-	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
-		INIT_LIST_HEAD(&esw->offloads.peer_flows[i]);
+	xa_init(&esw->offloads.peer_flows);
 	mutex_init(&esw->offloads.peer_mutex);
 
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
@@ -3595,6 +3613,8 @@ void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 	xa_destroy(&esw->paired);
 	xa_destroy(&esw->fdb_table.offloads.peer_miss_rules);
 	esw->devcom = NULL;
+	WARN_ON_ONCE(!xa_empty(&esw->offloads.peer_flows));
+	xa_destroy(&esw->offloads.peer_flows);
 }
 
 bool mlx5_esw_offloads_devcom_is_ready(struct mlx5_eswitch *esw)
-- 
2.44.0


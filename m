Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AAF4B44C4;
	Thu, 17 Sep 2026 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668655; cv=fail; b=uafvN5XVHLKAwqaPdeFX2oH+uSLIHpYsZa1dyJidWr8iJ+mTjotlWSh/Spm7/+LX0Xhi+YA65WTzEKLsyeJIm5bgiyc0OUI+E1hz5EuKh7MBsDEJwPvK6yaa33Wn2XBJ7lMSSw+FFFujttXdsNLiLaEN19Y5+n5qfl2CtmxSICY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668655; c=relaxed/simple;
	bh=GSkGoa0wGuocpY5aB5vKv4k4Jgc2zzcc1ejX45Rdvww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEXGCtkKWX2MTIFu1lZd2LwwyIVeydQaYqHbGorH+vLpJAtcPYZXoJ/QtN4H+kyByVU0nhdeTo2kkBvhvBdPnGKnEVZa1BVKwo9D+iScwQxR+pWN/pTR/xdYLvMUNo0YuObB0qrXPBaY0bj/HBp540px+tVlrmXTF4RXkaSOHeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LfUlC9A4; arc=fail smtp.client-ip=52.101.46.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LfUlC9A4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUmspFgYy+//wTkNN1bVa9HI+y/yy1yrghg/+dOlZ0lGxT2vwyvTjM+01XNAU9ttLvYQZ5OKTcWnNdqX7j6x9l+kUF4+u5eyBLziodf/N7tMp9SrAOvsV/DouRH478NDeCO0H1tsGTFWF/4BSLQYXQSUzcGf9O5fbJj/ly6BCppIWrV7fJioeTURCV7LFk1JuZgFEGDXTHUhPkUw0QCb3KrjpkfvKTNne+6Ci96FbCmtJmBJpywsTeJITnNWLT0+l//4vBBbNjMsLe9ttCnSOzB7IFZzN1FSCS1kybG29TQENvh8vQ7HlfjB5GMFLwMJ3VRKdrivynIrqHbsgfi/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Opjfy1e6VZR0xpq9NLcZbA1S3ltbenwjo43efOWL8go=;
 b=lBmoo9nYY67sKGjXwhyTRVq8zzHY7c6UcEcTatekCUeussbmj2Y4qWqZHg9Q8V55eXi3Od6OqJS4Z183z7ps0RSw7n6yW3QU0Nq6G1skPWHEVOCvjqB43H33hgWsXyLZKm0MBcn2bn3lw9+zEgOFOzeQ6ls/hUHEJBIZvqp/kAsFtgWQUEkz46qvOsIS9eO7CxNIjyWtNxUjAUbkeY5lhYegZxMrBkSe2im+kZSj8/wu/4oO4Cqws3Q6I3YsqYPbSKsTci0XCW8IkDHWs/XHn5OHUkLyNxrqyTbEiyq558Gvu2wIFSKeJf9F+FW9zii3/vA1TzKM7bQSgdE+TSBIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Opjfy1e6VZR0xpq9NLcZbA1S3ltbenwjo43efOWL8go=;
 b=LfUlC9A41epSxVTj+DOKD6gT2BP6cTLkkTzbfvCXwrHhVGEN+osxeTgtjiHmXgyJMhmmvtOlQ0osDyCtdkaLV/d49MMKVUuNwSz6bVsd3H69REU64o+xQ7nRmrV7fDeLRVXV+/LZCon5fA0YminPG5BGLxy21PRLPkTQLVO6Yy4WE6dEeDBXLFc+FMOUIO7Ia8SwfwO9/Tub7gUyGlNDaHbQKpybw5iYiDdZy3ARQYQD22JfHMNRmc9IocI+dAdD5CFNK8IoPmpCT4YNiFNzMvCgyJrBmXF3paWFE6HtSAcT2w4aqoTpUOPfn5ShO4hb7amejmuRDv78Rahn97i8oQ==
Received: from BN1PR12CA0029.namprd12.prod.outlook.com (2603:10b6:408:e1::34)
 by DS7PR12MB8230.namprd12.prod.outlook.com (2603:10b6:8:ed::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.12; Thu, 17 Sep 2026 18:10:42 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::96) by BN1PR12CA0029.outlook.office365.com
 (2603:10b6:408:e1::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 18:10:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:10:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:15 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:08 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 3/7] net/mlx5e: tc: Tie esw & accel blocking refs to the flow's lifetime
Date: Thu, 17 Sep 2026 20:54:29 +0300
Message-ID: <20260917175433.4090878-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|DS7PR12MB8230:EE_
X-MS-Office365-Filtering-Correlation-Id: 164e799f-baaf-4d07-b2a1-08df14e6fc8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	vtNtKxngd91XOkYmNoxQmlSDkMGPjbWerJ/V0ZJn1yRdDHepJAqFfGYm+cOgR2JhJMGzlTl62wVCnsxQHMYx6Njh1w5n/clJvsc2q3Pb2g415w4en9gTl5+Y+6/jFlWa/WKFeGKIn7Ys2Qtiq1TNE46Rxdr40BXlX0AuceX51grQ/SIG1EA1S+7VyYuKjc4wVPGy7hgQnwLHsxi4pkgubimpmMhrLl1PGLp1p28GK65Eg2oB4t13JTICZaD0ImCv4D2dNtArUABEw+2DSbcHRUQo5fyuGCPytReszT2LhTrLquzZBjf0yGL7o/KxMIulHqXLM4pHaajqprM7oTqTQJ4l8n9u8OiT/Z48Tj+8R8wusR+ul/OY//haGCeuC8jI7muosziuxt8x1aeFgK/U4ZA0jwb/C9I0MEcbbSTs2mzUay5yTpeYCzkNwSfieXEJ2GvdhCN1SmFGqVBaTItnE97fmjdH5tzSfHJab41KyqeUtVqB2rzJucuV/Rt7cQePhcqa1Cn3S8KAo9j7V3lIx3wdWVnn8F77Acv3DvFOpjr3j1BwFmfCyTvPTInW0KpV07Dla77RPtFQSpI9JFLsNBetx87XG2Ocejc7bGertJO+PDYhE+skaP/MdmNlzJ3ZGcB9fiJO+39Y05rFLgu92VHS6kuB3+1mWG0V/+o8BmYNvylJFzck506Kpa9YQIeJ2R/llu8AhFkigHSVv8jLJQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bVcPBXVOuj0BtpgFZlmqnkcZwEHa12dETr0x4I/QGF+1TjEOisWnBKChlhV2FrxZ7VIbEnoq+gNEpfqD/+SMQqPe9NHLssmp7hBw6z0weVjcnyghiGoqn+KIWTvMPcEKtZwHG9cFvvUL7iJQrFipfMA08W5a2uH+HBJbu7yQUWB7ggKo5qydjrUsrVcHlt/BKVLI/zCfGmOQCC0PTvs3pFqDov5F8fS+D8d/ufPPeXwTh6laoKV+bbBZwU6UVMtwN+bPrTzwafvIaQu8TR5diEowkeNYaysIFIoU/hH33Z6qmDnYn7beI4ecaf9xLVxxBUXbwPfqH+GGAjmJT9tLjshwl9POml+QVm8vV4c/kAXU0z4ZMWrrC5knnenU7ZVo4c4o6bXZf/qR/aWExJNcoXBC5eyF7raz3JzxPzMHYmXJIs5rJkduLNk+ojplJLA2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:42.0290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 164e799f-baaf-4d07-b2a1-08df14e6fc8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8230

From: Cosmin Ratiu <cratiu@nvidia.com>

TC flow creation acquires an esw user ref and, where required, an
IPsec-blocking reference. mlx5e_delete_flower() releases these, but
bulk cleanup (mlx5e_tc_nic_cleanup -> _mlx5e_tc_del_flow) destroys the
remaining flows without releasing either.

When bulk cleanup runs during suspend, the core device survives with
stale counters, which can prevent subsequent eswitch mode changes and
IPsec offload.

For the same reason, two more bugs are that the refs are dropped in
mlx5e_delete_flower(), before the flow is actually freed, leaving a
window of time where:
- a racing esw mode change could pull the rug from underneath the
  existing flow, leading to use after free.
- new IPsec objects might be installed, violating the restriction of
  mutual exclusion between TC and IPsec.

To fix these issues, this patch moves the reference acquisitions in
mlx5e_alloc_flow(), before the HW objects are actually allocated, and
moves the reference dropping to mlx5e_tc_del_flow(), after the HW
objects are deallocated.

Fixes: 7dc84de98bab ("net/mlx5: E-Switch, Protect changing mode while adding rules")
Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 48 ++++++++++++-------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369a..44fc421e7b8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -603,6 +603,10 @@ struct mlx5e_hairpin_entry {
 
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
+static int mlx5e_tc_block_ipsec_offload(struct net_device *filter,
+					struct mlx5e_priv *priv);
+static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter,
+					   struct mlx5e_priv *priv);
 
 struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow)
 {
@@ -2158,13 +2162,16 @@ static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
+	struct net_device *filter_dev = flow->attr->parse_attr->filter_dev;
+	bool peer = flow_flag_test(flow, PEER);
+
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
 
-		if (flow_flag_test(flow, PEER) ||
+		if (peer ||
 		    !mlx5_devcom_for_each_peer_begin(devcom)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
-			return;
+			goto out;
 		}
 
 		mlx5e_tc_del_fdb_peers_flow(flow);
@@ -2173,6 +2180,11 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
 	}
+out:
+	if (!peer) {
+		mlx5e_tc_unblock_ipsec_offload(filter_dev, flow->priv);
+		mlx5_esw_put(flow->priv->mdev);
+	}
 }
 
 static bool flow_requires_tunnel_mapping(u32 chain, struct flow_cls_offload *f)
@@ -4463,6 +4475,7 @@ mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *a
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		 struct flow_cls_offload *f, unsigned long flow_flags,
+		 struct net_device *filter_dev,
 		 struct mlx5e_tc_flow_parse_attr **__parse_attr,
 		 struct mlx5e_tc_flow **__flow)
 {
@@ -4497,11 +4510,23 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	init_completion(&flow->init_done);
 	init_completion(&flow->del_hw_done);
 
+	parse_attr->filter_dev = filter_dev;
+	attr->parse_attr = parse_attr;
+	/* Non-peer flows own the reservations until final destruction. */
+	if (!flow_flag_test(flow, PEER)) {
+		err = mlx5e_tc_block_ipsec_offload(filter_dev, priv);
+		if (err)
+			goto err_free_attr;
+		mlx5_esw_get(priv->mdev);
+	}
+
 	*__flow = flow;
 	*__parse_attr = parse_attr;
 
 	return 0;
 
+err_free_attr:
+	kfree(attr);
 err_free:
 	kfree(flow);
 	kvfree(parse_attr);
@@ -4558,11 +4583,10 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
 	attr_size  = sizeof(struct mlx5_esw_flow_attr);
 	err = mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
-			       &parse_attr, &flow);
+			       filter_dev, &parse_attr, &flow);
 	if (err)
 		goto out;
 
-	parse_attr->filter_dev = filter_dev;
 	mlx5e_flow_esw_attr_init(flow->attr,
 				 priv, parse_attr,
 				 f, in_rep, in_mdev);
@@ -4712,7 +4736,7 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	mlx5e_tc_del_fdb_peers_flow(flow);
 	mlx5_devcom_for_each_peer_end(devcom);
 clean_flow:
-	mlx5e_tc_del_fdb_flow(priv, flow);
+	mlx5e_flow_put(priv, flow);
 	return err;
 }
 
@@ -4739,11 +4763,10 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_NIC);
 	attr_size  = sizeof(struct mlx5_nic_flow_attr);
 	err = mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
-			       &parse_attr, &flow);
+			       filter_dev, &parse_attr, &flow);
 	if (err)
 		goto out;
 
-	parse_attr->filter_dev = filter_dev;
 	mlx5e_flow_attr_init(flow->attr, parse_attr, f);
 
 	err = parse_cls_flower(flow->priv, flow, &parse_attr->spec,
@@ -4865,12 +4888,6 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (!mlx5_esw_hold(priv->mdev))
 		return -EBUSY;
 
-	err = mlx5e_tc_block_ipsec_offload(dev, priv);
-	if (err)
-		goto esw_release;
-
-	mlx5_esw_get(priv->mdev);
-
 	rcu_read_lock();
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	if (flow) {
@@ -4914,9 +4931,6 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
-	mlx5_esw_put(priv->mdev);
-esw_release:
 	mlx5_esw_release(priv->mdev);
 	return err;
 }
@@ -4957,8 +4971,6 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
 
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
-	mlx5_esw_put(priv->mdev);
 	return 0;
 
 errout:
-- 
2.44.0


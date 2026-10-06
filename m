Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650DD370ACA;
	Tue,  6 Oct 2026 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791284599; cv=fail; b=KolRxEXRUx13zKuFaEOIOV2lGLuHIOH8ldssq1cHov1VgIh/KhnWdjy+hBNooYs2ZdDTrYOk+GrHrrby47ByLKqajObaJQm2Ejn7GW7IFU56Eefq1qkrUB6k1nNvw4eD2DI46CQXEbZPMUQaGIKh9hk0Pi/yTeGhVWQf7sFhyq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791284599; c=relaxed/simple;
	bh=lYG5W7TPFIVETfixHlgSZ4cj0KQ5zbeNAoLE6sfU/mg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u9wrHT2E9ZzeIHSmEXg/NQfwDbsb1n3SKG8gv4LcNZ9CPD9PAlDotLepB075P2/HI3BzTO0v/57uP6vPdlE6KOo5zrTPtRd2HgKXHiQzYxjca9DfdxQPpbtfEKMSqkfFP3uASkiPKYaF8C7wG/bvnz1X8PX4E9yVw69iVb/XydQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QeUqrLeu; arc=fail smtp.client-ip=52.101.48.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QeUqrLeu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ninxrWwBqJgR3GGWfcxtvUlbXXQiCpPvvZM4BpjWYcsc1JzABre3oF7Is+D5Ct9fSFgAwabc7ygdybbPrbP6Nk1NTr+e8wf3Wd/QNKGx44hnXKb+8j4V5zYz4i9MYDXcj17e3F4T4uvPLmQL2wK9LJvyvpxqPawwZUzuEeZ4QxC4BDr/3gwesmGUOEWpAfbr0TU9nOYoSDD3pnTp9AfGzMiRV0YiffNZS0XqFl1BZPUKUnHp9ksYFN1L93YxFJ93tjevMlR058E9p7opVyGAwQYXaNyBlFt13Rvpe4oaUKv/rP+38Dcr6ib+A7dvrknlr/Dndi5RTRrjKksaXLpWmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kejvNDitKbHkEZ8Jfev7uXsWUsVvwiYjqR+f75OaUEk=;
 b=FZFIc0TDQa4eewbE0rXWtOXE0s6cPbWxr3Ac6FIXINQxjau9xQzgvb57KXPqKw2hU8NB9FUd+1D7mIGYImE+l4n/EekJegTPi/WwPrYVc48qTY/RqEOo2s88af+RdyabC2g0hCinIGKC25lozr8HI1H3ceVRjEQs4kHEsvKxVW1zcq6hvtABQoG60Nbij41aierqJL1IcBOOM13ABWG+c3Mgi/wl8olbmLVdYgMMz6HEhuDp54T1SMAGN54MimxRmTW0rFOUY0k1272888D7m65R+jhfaDDaYipezg0nfJayjmnVt21+vguO9V0q/NkUROU3b23A3oL6gSc+2aU29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kejvNDitKbHkEZ8Jfev7uXsWUsVvwiYjqR+f75OaUEk=;
 b=QeUqrLeuRlnflZVYK9aspE78RDC2BVkMXfBs8uPoRULt/e20Ceppt3RuF8OqS3sNhrG3fz3JQtUI5S572IDme1tDcPPmvlONBPDVlJBNa3VS+2g/52xvHwtIqh9sjLVf7cZat+fAy6f1FSgQSZrGs0RulsfJuMsN3AbOdVDS5XKW//uC9hpQtmyr5CaISkPazlfbD3671KyjWukIblE8crIn7mO0650K90Ycy5difrd3ipUdZq/i/Qq8yOt9mliCkMVLHafMgtirBGzwEnyWL4/wr/gVM91MvcRDNKyFTYXsoihBePsEDvCAI+yhjgITsVsME0d1EAuHaHDIio9SWw==
Received: from BN9PR03CA0484.namprd03.prod.outlook.com (2603:10b6:408:130::9)
 by SA1PR12MB999230.namprd12.prod.outlook.com (2603:10b6:806:4de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 11:03:12 +0000
Received: from BN7PEPF000000A1.namprd04.prod.outlook.com
 (2603:10b6:408:130:cafe::82) by BN9PR03CA0484.outlook.office365.com
 (2603:10b6:408:130::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 11:03:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN7PEPF000000A1.mail.protection.outlook.com (10.167.248.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 11:03:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 04:02:48 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 04:02:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 6 Oct 2026 04:02:43 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jianbo Liu
	<jianbol@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Attach late uplink netdev to loaded representors
Date: Tue, 6 Oct 2026 14:02:19 +0300
Message-ID: <20261006110219.257714-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A1:EE_|SA1PR12MB999230:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eea281d-bcce-460b-6ff3-08df23996970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|23010399003|376014|1800799024|36860700016|6133799003|18002099003|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	/igUrmuRx5ZRLmbBqiJ89XTL9XjpSu7HOlcFUYJ23UkUeAwt6+c/EZHG4k5nJHpyZf5UrBEZCAcdEQFTFDrGZh2+Z1Fzt68Y3E/W4IZHExC+vsjSR9Q6ZsgCxfIyQRx0ptX2hivZOhC870XxrC6yZgn7QhTEZCAPI7EVgAK35WFYzatTtHcpclv9qYVqgk6PLDMp8MJYTk0SMetUSqt8qrXwwCGTmQBB6xJsdc6EXBwZqo75lN2dDU+Co5GDB4I1iGnBnxoCpJpg/HvxyW69DmrK2uQFu9mFYP82xwf8ARbA1qi2WVHFDrr28BGpVZCDpkVDOa/4eWEq1jZ5OhvuqRgIkroxuQ0WvTrQv4yxcShoWMVNzksL+9iv53X1PIj8Kt/eIYYqflKMssLadTKEF4g1XM3cDEqB5X17HGwKmEcn9yGqRLaE5KC7T0/FVvEAwc2oVlsl7A6jpJYcOMsz6sCMieNJGVkNd2RrNPqPXg10fIFSHJzZqxWbWF8nYV0rrVM4893wihykBIrf1GHeXJWTbW/6mV0c44G1memuNQhY5wzLTcD+LBEP1+DxW6ZfLFcBJJ+VINg6dLGcrzkSsqEIQ3ggFFyjWtyg094qxMZL6EAkOAwA2qVkjmGo6F+kC8uRdRK+FGoRlPmVVe0ZT9PpZyiK0iRHLvPreNQqypsMpspHh2TcaU3juQRaF0it8E2uoi1I74ljitWQwHazjQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(6133799003)(18002099003)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V8b83IYqe00FQ0daEDblxkbGlpMkqombJBR2vJQzmnrXqri/FycGPw3HLfoa1TKAj7WevRuPGM7tzJe+pnQwFP4NTvKo1EJPc+mNixJTowpWTTiuE/NmqCVSHuHYepfVoLMTPsf0p/g6R1IKQYim+ueVLdg/mK+n5gt8bjtMk5svhVhXbyiVaZZvmrkwkhIrVFv03iih+RNpwJ5QYSG2i8ENDP4LqIpxsXa4gggZMTyPAUlpQh1J0A3bFeX5GJNfJsdqUY6mSx92LqRbOfql4CtQ2Pwiw6+Kx801vvRJsssHOK5WyXPDAgNUh3+Uz8jVKYOf0UOCRcxrFVSr4b+qPHEtnXTOZ9e1nBeruIZfGc3xx7+xZKNeomepWsuJZ9h4aXjOc8I9pJWrnIE01wswo5kBYiH9CRrYl/mD18UmxZ42vZI+GT9mc9l2YdH1z5dF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 11:03:11.4020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eea281d-bcce-460b-6ff3-08df23996970
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999230

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_vport_uplink_rep_load() returns success when the uplink netdev is
missing, so the ETH rep is marked loaded with a NULL netdev, the IB rep
copies that NULL association, and nothing repairs it later. Unbind
mlx5_core.eth.<N> in legacy mode, enter switchdev, bind it again, and
rdma link show still reports no netdev on the uplink port. The netdev
also keeps the NIC profile instead of the uplink rep profile.

Add an attach_uplink_netdev rep op, run from the existing reload-reps
work once mlx5_core_uplink_netdev_set() reports a netdev. ETH re-runs
the uplink load, switching profile and setting rpriv->netdev; IB redoes
ib_device_set_netdev(). Deferring to the work keeps the devlink lock
out of probe context.

Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against device unbind")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           | 24 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 15 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 35 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 include/linux/mlx5/eswitch.h                  |  5 +++
 6 files changed, 85 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 65d8767d1830..f9931a94157a 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -273,10 +273,34 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	}
 }
 
+static int
+mlx5_ib_vport_uplink_rep_attach_netdev(struct mlx5_core_dev *mdev,
+				       struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5_ib_dev *dev = mlx5_ib_rep_to_dev(rep);
+	struct net_device *ndev;
+	int i;
+
+	/* Shared FDB slave uplinks share the master's IB device. */
+	if (!dev)
+		return 0;
+
+	ndev = mlx5_ib_get_rep_netdev(rep->esw, rep->vport);
+	if (!ndev)
+		return -ENODEV;
+
+	for (i = 0; i < dev->num_ports; i++)
+		if (dev->port[i].rep == rep)
+			return ib_device_set_netdev(&dev->ib_dev, ndev, i + 1);
+
+	return 0;
+}
+
 static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.load = mlx5_ib_vport_rep_load,
 	.unload = mlx5_ib_vport_rep_unload,
 	.get_proto_dev = mlx5_ib_rep_to_dev,
+	.attach_uplink_netdev = mlx5_ib_vport_uplink_rep_attach_netdev,
 };
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 88a170e40bd9..19812bf6a830 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1490,10 +1490,24 @@ mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *
 	rpriv->netdev = netdev;
 	err = mlx5e_netdev_change_profile(netdev, dev,
 					  &mlx5e_uplink_rep_profile, rpriv);
+	if (err)
+		rpriv->netdev = NULL;
 	mlx5_uplink_netdev_put(dev, netdev);
 	return err;
 }
 
+static int
+mlx5e_vport_uplink_rep_attach_netdev(struct mlx5_core_dev *dev,
+				     struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
+
+	if (rpriv->netdev)
+		return 0;
+
+	return mlx5e_vport_uplink_rep_load(dev, rep);
+}
+
 static void
 mlx5e_vport_uplink_rep_unload(struct mlx5e_rep_priv *rpriv)
 {
@@ -1741,6 +1755,7 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.unload = mlx5e_vport_rep_unload,
 	.get_proto_dev = mlx5e_vport_rep_get_proto_dev,
 	.event = mlx5e_vport_rep_event,
+	.attach_uplink_netdev = mlx5e_vport_uplink_rep_attach_netdev,
 };
 
 static int mlx5e_rep_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8b1f93b13ea9..3dd6931f13cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -1012,6 +1012,7 @@ mlx5_esw_lag_demux_rule_create(struct mlx5_eswitch *esw, u16 vport_num,
 			       struct mlx5_flow_table *lag_ft);
 void mlx5_esw_reps_block(struct mlx5_eswitch *esw);
 void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw);
+void mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev);
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
@@ -1098,6 +1099,8 @@ mlx5_esw_host_functions_enabled(const struct mlx5_core_dev *dev)
 
 static inline void mlx5_esw_reps_block(struct mlx5_eswitch *esw) {}
 static inline void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw) {}
+static inline void
+mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev) {}
 
 static inline bool
 mlx5_esw_vport_vhca_id(struct mlx5_eswitch *esw, u16 vportn, u16 *vhca_id)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eb74b6260168..cf61bd76889c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4842,6 +4842,29 @@ mlx5_eswitch_register_vport_reps_blocked(struct mlx5_eswitch *esw,
 	}
 }
 
+static void mlx5_eswitch_attach_uplink_netdev(struct mlx5_eswitch *esw,
+					      struct mlx5_eswitch_rep *uplink)
+{
+	const struct mlx5_eswitch_rep_ops *ops;
+	int type;
+	int err;
+
+	for (type = 0; type < NUM_REP_TYPES; type++) {
+		if (atomic_read(&uplink->rep_data[type].state) != REP_LOADED)
+			continue;
+
+		ops = esw->offloads.rep_ops[type];
+		if (!ops || !ops->attach_uplink_netdev)
+			continue;
+
+		err = ops->attach_uplink_netdev(esw->dev, uplink);
+		if (err)
+			esw_warn(esw->dev,
+				 "Failed to attach uplink netdev to rep type %d, err(%d)\n",
+				 type, err);
+	}
+}
+
 static void mlx5_eswitch_reload_reps_blocked(struct mlx5_eswitch *esw)
 {
 	struct mlx5_eswitch_rep *uplink;
@@ -4862,6 +4885,8 @@ static void mlx5_eswitch_reload_reps_blocked(struct mlx5_eswitch *esw)
 		return;
 	}
 
+	mlx5_eswitch_attach_uplink_netdev(esw, uplink);
+
 	if (mlx5_get_sd(esw->dev) && !mlx5_lag_is_active(esw->dev))
 		return;
 
@@ -4886,6 +4911,16 @@ static void mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
 	mlx5_esw_reps_unblock(esw);
 }
 
+void mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+
+	if (!mlx5_esw_allowed(esw))
+		return;
+
+	mlx5_esw_add_work(esw, mlx5_eswitch_reload_reps, GFP_KERNEL);
+}
+
 static void
 mlx5_eswitch_register_vport_reps_locked(struct mlx5_eswitch *esw,
 					const struct mlx5_eswitch_rep_ops *ops,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b..ab93c807b58c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -278,6 +278,9 @@ void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *n
 	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
 					  netdev);
 	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+
+	if (netdev)
+		mlx5_esw_offloads_uplink_netdev_attach(dev);
 }
 
 void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index a0dd162baa78..e823fbe7ff40 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -43,6 +43,11 @@ struct mlx5_eswitch_rep_ops {
 		     struct mlx5_eswitch_rep *rep,
 		     enum mlx5_switchdev_event event,
 		     void *data);
+	/* Attach an uplink netdev that showed up only after the uplink
+	 * representor was already loaded.
+	 */
+	int (*attach_uplink_netdev)(struct mlx5_core_dev *dev,
+				    struct mlx5_eswitch_rep *rep);
 };
 
 struct mlx5_eswitch_rep_data {

base-commit: d5a007b9b457c915ab1a53227e8939e4018aa97a
-- 
2.44.0


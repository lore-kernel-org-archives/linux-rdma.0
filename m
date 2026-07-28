Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431B932B104;
	Tue, 28 Jul 2026 04:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213857; cv=fail; b=HY1xl/MyYlpD0SboeuiUqQgbdsW4frI/M3qmtpIEiDkIwsllxIIFO2eTgKhfRXTgDGRTuNITmxF1QV3VPJZQaqK4UfPAXIWQXzWCFfN6J2aEAhpotuNJrmZkV7A2rUZW/cvQ7cYp0LaW2EGDTGUq7JIn9r3Ivwa8JxiYnW9dcJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213857; c=relaxed/simple;
	bh=t3RQvjeUUCfgC31/0fiIoCyAZuZKZ7qPM3aHX60iLi8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gbnrQjsYii7tMj+/Cj7GwNpKxVjdOh+3bUVQN201hPbpz3ll+nPM3ZO5rsZ1INLhhoQf3pU3TrHxv2FDwlrp5FyOxGS/XFaEkNq0txXg3MhPu5+ugPEtpezhHG0fkWe+LDqiIQSSwNzeHfgIbFs0h78FyuAhmqfRFfAGKe/cJgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eGWHmFpW; arc=fail smtp.client-ip=52.101.56.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eGWHmFpW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iR8wFJvGUEJ1owzARhy5KZ+W0YGgFUShhvZjy7Inv7TUDUjntaseYad6wCWzWM65JaO/Budgaz82GtgU7IvN3oPLF8RtiwXS0aaqMFJ8rfC9AOgWk68HXDiM7ikLHoLAqHCUrHJDmhVUwYs+UrgWQcOz5kw427Vrow/9v2XXszc4C4OVpznNP7WpxNnGDyKj0ptmGnwSmyHcz4r5fZ1iGQ5dmYuZZg2JOOMfHnVBz6+K9tlyxW+rDKQgaQmPBxMLOkRhY3KmnvhyoLAvTnYtIY7C5nj1iwUwxEwqDHlFcxXMlFRjFwwQhxGiR0SS3tVlvcJhsTnubmtCfbMGzce3yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaP4MdwRdqfAxOnzJ97PuswNYN+zJjq407dgqKSXz40=;
 b=kW/vK6UqL2LDw6dBPXNp1bM2flGGTv2z+Ul0bHovw2ShO7+yeHrvF73IbYZpT8HqU23bG8JECAyllBClck/BsEjq9ttYPksTI83vWPGKAR6t6BZSk+yyjw7jNwG/Bm+dhbJ1Y/ze5hlj/MqmoFtaHyaRv4NcDg+ylbiS+VR+Zt4DuG/zRpCY/CMHZw0sTb52EuvxFS6VI5rgjE5cso4OEq/tqaZ4VimSs+Io6nhctv9xx04IIlP4K1sxo9tjBKN65V5IJtpChRayvXdHD9CwI8979G6AbIdYQvuFeCHysy2IB4KJ7TZMB5BKSQexLnvMfAHVS5u736djNebSNMdpig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aaP4MdwRdqfAxOnzJ97PuswNYN+zJjq407dgqKSXz40=;
 b=eGWHmFpWC1sEGzziV17MA/+Jx0wVFgXe8z4O1qx9zUzyE+bbdbSCpLA48Mze8jg7ROfx4+uSPUnQ0ANsY6DrfLDEgOYby/KstIu5OGN5OTarTFNUHuGW+1hn4Vm0AMwymeLM0qlF43k6hMnOk7/gjqjQVzv4aMLI3hQb8OKOVP6SFp4mLIUpCidhCknQtK7m5mC5quhejCTa579AvMEoFXz+dIor26jwMHswBKk1KAZPogaVLOMn/h/f0WPKb+qfdQnqTc79b4Bn6hTFnYESRokzeJWri72whJlARzGtFzQ85/2dZbiWVWezs73yBgiQ/1LLFl7/lbQxQS6qp00QjQ==
Received: from BN9PR03CA0471.namprd03.prod.outlook.com (2603:10b6:408:139::26)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 04:44:08 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::3e) by BN9PR03CA0471.outlook.office365.com
 (2603:10b6:408:139::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 04:44:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 04:44:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 27 Jul
 2026 21:43:56 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 27 Jul 2026 21:43:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 27 Jul 2026 21:43:52 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
Date: Tue, 28 Jul 2026 07:43:38 +0300
Message-ID: <20260728044338.2271143-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|SJ2PR12MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cb02a69-27d7-4ff6-8157-08deec62dbd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|10067099003|11063799006|6133799003|56012099006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	kjMtWGMY8QO3lOMvA7DNVm1rDaDoSLf5sKPjWMnAqGoevsYQHSW1WRPRJCsyhf59MooS2/6k72JogFugLpiayoZN/QTbOEmFyFS9jKp6uSzBpEF0mWcDmMHtBLUqYHa1BghtVf6klv/SOXVh41ZSf62gx9fLldxO781UlIkvq9WRANkkFFsHmk5pu48M47KRJxSankvz4hyext4GO9wTmLJTYlkSnz/nYpalmL58CrBATbZz6nwkp26TRsMhcZQ2MhknOz29zSVY1gg0LJFLBDrhiF2nKKgtHdvffMQx+xnEsHA32lK240tUpZvgp1Txpou0Nta7Xte2fPE3SWffupEBnCnOPHsF9FQe4cXaj7J29Cws/ajVtP7rWmBlMaPxPQyxN8DwSNrlGhLGmo63U9Dwo31cPETSfV22Ku6juvsRx90EzxSWnaHhR+LoQC/ELokb7vp/FFQXigIBtScRBVAQM2ICvHzyk15XUM+dkTS5JPatTyr2InYCQ860yr8lVeDlyz9chPunn16mRk+PjLUDKLy0wX6xMiOuU0m81TsuxSkdHNOT0tw7x6uVM+t5fFwkT1LLUR70bybZUaa2hY+kf5YBSvsKWO90jIa0Zc50dlnUP9PDwyVyvl8er9S9nZEQqRgLVcKJf3pyyeXIYXF6GGx8fEPkKdAsxmL4woLisqRzsxAZIJGGzYv8Lr8gFcIu2S5Ea9YZv9ctnRrIbw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(10067099003)(11063799006)(6133799003)(56012099006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OZRsp//PpTU5DY8gZw5JrwdVSaj6UDzAcqVQcXSoyEf6DrDfZqYjcSh7yE+pqoYpJr0Fql2k1VXGo4ZH+ER9caM6HYPEbHK/mxOHsFj4422QwcCnBlOonOpP5h0csnd2LPlcYJKrZxL3jGIaA50I97eY6KNU5NW/dojoRdy27EJ5Q3eLikHJe8PhJHIILZRvkhj2+lKOOGqLAReGd4aJzhn45UZRARIYyI3b6evzlib+ievh0x9zbYAg+KQB5s6Rpsk8sEUA9hZVpRkanK8uDSjrd7Ym4yxd8ZZGqbjzmIK20BDWHVxTcYPX9MOBQcaltvk5rGUb5qwuhxITR/hr4zl1oESUxDzNUzvwK0riZIwfDrkj4oo5siEnffv2DNm5YQLlMt743jm/xrxb0TsEaH2awVuRUZsTevPFJ/tMscv+5tq+muyPV0bK3MTI1H/Q
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 04:44:07.0485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb02a69-27d7-4ff6-8157-08deec62dbd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848

From: Shay Drory <shayd@nvidia.com>

In case __mlx5e_add_fdb_flow() fails in lower levels, the flow is
deleted via mlx5e_tc_del_flow(), and mlx5e_tc_del_flow() is acquiring
ESW devcom lock without condition. In addition, in case of peer_flow,
__mlx5e_add_fdb_flow() is called while holding ESW devcom comp lock.
This results in an AA deadlock.

To fix this, introduce a new PEER flag that is set on flows created as
peer flows (the duplicate flows on peer devices), and check it in
mlx5e_tc_del_flow() before acquiring ESW devcom lock.

Lockdep splat:
============================================
WARNING: possible recursive locking detected
============================================
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(&comp->lock_key#2);
  lock(&comp->lock_key#2);
 *** DEADLOCK ***
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_deadlock_bug.cold+0xbd/0xca
 __lock_acquire+0x1671/0x2ec0
 lock_acquire+0x10e/0x2e0
 down_read+0x95/0x430
 mlx5_devcom_for_each_peer_begin+0x4e/0xe0 [mlx5_core]
 mlx5e_tc_del_flow+0x11d/0xa70 [mlx5_core]
 mlx5e_flow_put+0x99/0x100 [mlx5_core]
 __mlx5e_add_fdb_flow+0x409/0xf00 [mlx5_core]
 mlx5e_configure_flower+0x2a86/0x4100 [mlx5_core]
 mlx5e_rep_setup_tc_cls_flower+0x12f/0x1b0 [mlx5_core]
 mlx5e_rep_setup_tc_cb+0x153/0x750 [mlx5_core]
 tc_setup_cb_add+0x1dc/0x470
 fl_change+0x2f4d/0x626d [cls_flower]
 tc_new_tfilter+0x79b/0x2310
 rtnetlink_rcv_msg+0x778/0xad0
 do_syscall_64+0x70/0x960
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

V2: Remove leftover pharagraph from commit message.
V1: https://patchwork.kernel.org/project/netdevbpf/patch/20260717073041.1241894-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 28cab4bf525c..7bfe7cdc5770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS         = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_PEER                  = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1bc7b9019124..b290beb4369a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2161,7 +2161,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
 
-		if (!mlx5_devcom_for_each_peer_begin(devcom)) {
+		if (flow_flag_test(flow, PEER) ||
+		    !mlx5_devcom_for_each_peer_begin(devcom)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
 			return;
 		}
@@ -4628,6 +4629,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	else
 		in_mdev = priv->mdev;
 
+	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_PEER);
 	parse_attr = flow->attr->parse_attr;
 	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
 					 parse_attr->filter_dev,

base-commit: 97ac08560d236ca17f6606d9e671118e5eae5721
-- 
2.44.0


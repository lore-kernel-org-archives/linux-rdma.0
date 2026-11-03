Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726017;
	b=dmMBnTjwhn1gjt1YWdCIt9EVc96tXBHv7NRBqKAO8p+H6zQdmnQfLyqBURv78o2pnv3b
	 shI6UXqoKnHb5EB0VE44te1kSiqzmoOGaPANQYAdZWu2isk7cyVYGnAtWC8dknC8tXH35
	 emmfCdx80iIy/Xm+ZnSuqWST12sJbBqmArajj/WguRPe8tBkCFivcC0X9T8aHoM5OEAAD
	 EQ281+hMc3qjp5nj220qDUZr8nyJfNMSBIpxZHkPMFCIgb3hKOdFpib5E4YqERC2+UMSX
	 I+NXfzOca8h0wSHw1qoD+2ukuifs1EPoJrGpkVDXKSY0D98OqXHjdAPu8+PIsELxJww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726017;
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
	bh=cFFJXlAKxexqK4sw82up8z1vesixQiTNOu0+MgY7Tno=;
	b=Fs3jg5q/2BXQQS1f9GPQXnaAFWbC7MWrmydb6o/wnKw4I9c09aLl5n3kZ5SF73reVMxr
	 OcDUiS7ih1zTK0/Y3JtUaQjcAI7ZrbXSDgMxmLRjzGpoNJ8iPzqlghfABtn4aArtbJax4
	 1eJ8489DQFdfBOCtoShp8Q0I0tLqm1dJff8ufuc3hr1/mUOAcmZiJswOLJ/DLrEa8VKhI
	 9DT9SpSBy5+W+LsqZw5J04O5wDJzCuVpxJfzH0+NckkrJgWN5WSDTiHByHth6efn771gm
	 3IusHClnnLVNgraGSXO7SzPkQtE+gozlOyWmws6oRq1fshcxNGY8mZd6vyEhUJsJIaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="b6Bl/jaX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.30
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8A86082BD7;
	Tue,  3 Nov 2026 17:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD8A86082BD7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b6Bl/jaX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RIU/HzFhPHDRXcZb/7RpoSxyy3GVkp9aJEyok5730nV+FyXjCgTpfTBxeDTg8k0Jt/g0L76o+S2HpyVbBS60YpczG1eSaGYlW3T4xGw90l+CGVsyTeEVEw5HqgNy+VAVTu4wY58cVF43P5tJJ5inlZ7KbyrfKMgaKL0k0tS/oHruC0EWoZ3x5rBzf22j/+ibta6KXW2SQ9tmxEq9sYc9UCEvUBevRXj4xudW98LdAV7DElOyJYBJiDRIm4IsAc2HwcJ6zW88wz3i+4uGbpGQxpLN2AKJLUxHM68yW1TB7M8ZBtEhRK69XgKJo9MHRz3WQkaEk2i/b0PKnchsXBjUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFFJXlAKxexqK4sw82up8z1vesixQiTNOu0+MgY7Tno=;
 b=OU8t6WyWXls+0Q5uVIYLd9LuDxYm4+bqr440xQ/rI41a0rJEhr8IeSX5oMU6XAoQ5jYMlQ6YXLRRBpeIsaeTLJdAqOImWaHJBCbrdch90/nv7AXhonmqQSrOks/YRLH8w3+uVFZ3EzhMVqjR/Wtj7svjMPaYI10NhviZ1sfXqy1Fd+2kmL8B+revA3OJ9AwWOGgqF4JLAOkov5DjIyL1vtNu4YHzRd+bH7VXDDBAGF4fU7O2Xq3cPhu7OC8jbFwC7LVHmYYDJ6PRreN183PLaWkx3sXl3Jc2Rf8fyUQMciIk9eicecMVSItlR9GChhZwG/nEXBjegXBP/lD0F5E8eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFFJXlAKxexqK4sw82up8z1vesixQiTNOu0+MgY7Tno=;
 b=b6Bl/jaXex6rHnFU06qxHfKgRt50YXbPVkuIhV0m3pxVe/KgReGHCf8PVtjoTZZmJpQOPTwIEIV8//fNiIDkJGqRsJQxT4OODUjkRg18RWajLvT/ncRG59ooLN5WGtuEJh+aFErtyZdyodH8o7cbClBNEpHGhzkNSmIa6ILqAGvPvgL2eI3iZAeMfYOCj3oUw3I44fT/46vRt2QnYlfVYtnZKA7iuljLfX34ulhY9Tic7VThhaZvEcPoVOiPe2/oNVR+OPId8kZT02bG+Z8rI/s4ZCEPxh9YxujowWhV/iQ5267EFrrEVq/5CwpuKQ1zLKY48Q46Q0wn4Z58ps8X8A==
Received: from CH2PR03CA0004.namprd03.prod.outlook.com (2603:10b6:610:59::14)
 by SACPR12MB553146.namprd12.prod.outlook.com (2603:10b6:806:542::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:32 +0000
Received: from DM3PEPF000265B3.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::6) by CH2PR03CA0004.outlook.office365.com
 (2603:10b6:610:59::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265B3.mail.protection.outlook.com (10.167.23.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:13:07 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:13:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:13:01 -0800
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
Subject: [PATCH net-next 15/15] net/mlx5: LAG, enable LAG over functions that do not represent a physical port
Date: Tue, 3 Nov 2026 19:10:09 +0200
Message-ID: <20261103171009.563034-16-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B3:EE_|SACPR12MB553146:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c98f48-7c61-49c7-fb75-08df39cdc94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|10067099003|6133799003|22082099003|261102123227099003|18002099003|261102130727099003|56012099006|11063799006|261009223027099003|261026121527099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	gqi5aAha+YK6yximccttynXpKbDhqHLeeZsXMz8hEX8kYf4DcHCiUE4vBCOd+VFGIjxk34XiepVGMJq2byjNXyg5g4jbyuukHwWdUHOXMGIqam+X/Z9y2sxA+lWI8f3RX+yYw44vdWgfPrCA0P5SBOXqB4yY7wh7x2UBn2fe4+MIPqB7ZLXfyAXdhw2P1re5F4Nreoul+1AeS2l7alucFVze2G2n/Xl351B3LSA1NyeG7qVT7w9e9Uw/dnnE/5Wd0huJiakAUXT47GrtlkUxIDPLy5a/6aKQY+FcQ1z2Tv7ClJ5T1IflehhmXaYHn31Un22mRAhSIR9U2yW5ksp8EPA38E7qh80Uq2fmrlH7rOl5HBt2UnSYaNZAXF7t4hWtFIYptVcnGuDtx9Vt8JEog4uJjAKy1r+AfdMqW5ft63qiI2bCOSQc6+owlFYM83Or6yCDjoTRHLQ1BGW7N2liFCN7ETmxADHDjq4txuNhs8SiTbsE4U0cH5ihl751qwEQjb4FH8B306b1G1SjBNW45uLj58q2nTPDRKcgRCjXKm1QZES0bVIwQdLqAtz4EVXu35eAiXhy9iXBaW5m9AHQ018xpct62q0Ytp25DRH9AjsDzLN2HGxRbo80lIvF11eIgYeTyN2tCo9X5R4l1GXV+tzsqDAn360iJcadKjGIQXqgzAx1IQVNLl5iF9u+B6rgokP0F7nVTkpx0vZcwwVbKQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(10067099003)(6133799003)(22082099003)(261102123227099003)(18002099003)(261102130727099003)(56012099006)(11063799006)(261009223027099003)(261026121527099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sf/E/22GBCEgxypkNqjxLRRssBjQFmkjfP6lDaqj0Zbbtp58TgcndlnT0QtrgItj8USkPeEb+JPT7D/9+tHWhIgalrZrpvikR9uB72dRjyt8QQAoyPr2iM9bBNHk7Li92eRcT8SAjBkJ7i0ZxfiacxvLfyeHs8sDSfSVce8ygcuWJ4dc9+rtlzjzQHsK634c2PRf7zuqNUk/SZmpST2S9WkckM9C8iuIC42ZG2obQvZw6egirNA+y6/vU5iW64iJAnLvQG5/vp0BQLcXIXZQpDMAlYVGzMtrWjPu+xeVawZMS5dl6ZL/OCIdjEmD/26UlEYnBkn+tbJlMAnskA4dD/5+jIC8FJAmVfD2D0qbgktXBDMqIHoWfdYs+PbZYunjJJwUH3IZXlQWGdsRBLl5MM6WVL4R5nwHzuqWHbnTlaYwtRssp5C93FjZLMgnl943
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:31.7466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c98f48-7c61-49c7-fb75-08df39cdc94f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB553146

From: Shay Drory <shayd@nvidia.com>

LAG membership assumes every member represents a physical port.
A nested LAG of VFs/SFs does not fit that assumption; its member
functions sit behind a multi_uplink_eswitch and each reports
num_lag_ports < 2, so they do not represent a physical port.

Detect this with mlx5_virt_lag_is_supported(): let such a function join
the LAG in mlx5_lag_add_mdev(), and skip the MLX5_LAG_XA_MARK_PORT mark
in mlx5_ldev_add_mdev(), since it is not a physical port.

These function only support MPESW, and netdevs addition to LAG is only
needed for linux bond. Hence, don't allow such a lag to add netdevs to
itself. For the same reason, don't register the LAG netdev notifier for
it.

Such a function may report num_lag_ports == 0, which ldev->ports keeps
as is. Report at least one port from mlx5_lag_get_num_ports(), so RDMA,
which uses it as the TX-affinity divisor, sees the function's own port
rather than dividing by zero.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 21 +++++++++++++------
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4e15e16ae6e8..5532b2505161 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -366,6 +366,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 
 	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
 	ldev->buckets = 1;
+	ldev->virt_lag = mlx5_virt_lag_is_supported(dev);
 	ldev->v2p_map = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
 				sizeof(*ldev->v2p_map), GFP_KERNEL);
 	if (!ldev->v2p_map)
@@ -381,7 +382,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
 	INIT_WORK(&ldev->speed_update_work, mlx5_mpesw_speed_update_work);
 
-	if (!mlx5_sd_is_supported(dev)) {
+	if (!mlx5_sd_is_supported(dev) && !ldev->virt_lag) {
 		ldev->nb.notifier_call = mlx5_lag_netdev_event;
 		write_pnet(&ldev->net, mlx5_core_net(dev));
 		if (register_netdevice_notifier_net(read_pnet(&ldev->net),
@@ -468,7 +469,9 @@ int mlx5_lag_get_dev_index_by_seq(struct mlx5_lag *ldev, int seq)
 /* Return the appropriate iterator filter for a device in LAG:
  * - SD shared FDB active: iterate only the device's SD group
  * - SD group exists but shared FDB not active: iterate all devices
- * - No SD: iterate ports only
+ * - Virt LAG: iterate all devices, since its members are not marked as
+ *   ports, as they do not represent a physical port
+ * - Otherwise: iterate ports only
  */
 static u32 mlx5_lag_get_filter(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 {
@@ -476,7 +479,7 @@ static u32 mlx5_lag_get_filter(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 
 	if (fn && fn->sd_fdb_active)
 		return fn->group_id;
-	if (fn && fn->group_id)
+	if (fn && (fn->group_id || ldev->virt_lag))
 		return MLX5_LAG_FILTER_ALL;
 	return MLX5_LAG_FILTER_PORTS;
 }
@@ -2399,7 +2402,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 	fn->group_id = group_id;
 	dev->priv.lag = ldev;
 
-	if (group_id)
+	if (group_id || ldev->virt_lag)
 		return 0;
 
 	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);
@@ -2548,7 +2551,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
 	int err;
 
-	if (!mlx5_lag_is_supported(dev))
+	if (!mlx5_lag_is_supported(dev) && !mlx5_virt_lag_is_supported(dev))
 		return;
 
 	if (mlx5_lag_register_hca_devcom_comp(dev))
@@ -2583,6 +2586,9 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
+	if (ldev->virt_lag)
+		return;
+
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_remove_netdev(ldev, netdev);
 	clear_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
@@ -2604,6 +2610,9 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
+	if (ldev->virt_lag)
+		return;
+
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_add_netdev(ldev, dev, netdev);
 	num = mlx5_lag_num_netdevs(ldev);
@@ -2887,7 +2896,7 @@ u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return 0;
 
-	return ldev->ports;
+	return max_t(u8, ldev->ports, 1);
 }
 EXPORT_SYMBOL(mlx5_lag_get_num_ports);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 3dd7fa8de66c..6f575750e403 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -336,7 +336,7 @@ bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 
 	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW &&
-	       __mlx5_lag_dev_is_port(ldev, dev);
+	       (ldev->virt_lag || __mlx5_lag_dev_is_port(ldev, dev));
 }
 EXPORT_SYMBOL(mlx5_lag_is_mpesw);
 
-- 
2.44.0


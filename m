Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7853DA5D5;
	Wed, 29 Jul 2026 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309426; cv=fail; b=Tu5laW5FaKgt9mXe5NhaYmiqXsPuf9+3T/MtUJQNJzWdOvCEhROMvmo1U9ve49w29vnJ/4loqpVh3JEVTA8+L5McHMEyrMaCev99eXoEOR0N1QTe3q+k6wv2VgyZPR3aB3E57sO1/RTb49XqWjLAkyKwIMoRO+AHnFfZJQgqm7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309426; c=relaxed/simple;
	bh=wAZ7WBZk9dv03ryYCqznMPw0Kz698zhzZv6BScMtB8U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RQj/ZKyZWsNP9/0t67eBB2s6/RV6zD2dfjfzrp9u7xPr6RMq1X6VVBgytbwasJgeHOgibq+oWir7OBg/mnhq6m3B4RH7IU4wM6wLZMiqHe0gqwV4yJHo3IFYOtyLNzJuqVAABwVL1FuZzzYCB/EPZNEcyfBvtcErDMdUtCfE6ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M0l2kjh7; arc=fail smtp.client-ip=52.101.53.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M0l2kjh7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ofu6AoN1/+N5UbJYG3M3o82iE3N+Fy2/2XgNWsQqcX+M6mRkcV1ZRWwHy4H5XHEqdGmV9dMmfKnhxyDGC9NpsVi7BrE6Lk7y5Fo+b9xQZ7pXjdKlyfFyrpa3asRadIgZfrySQu4iPiIGF4R7+S6hQUZJZmWp/cXAuCfB+4Z4Wfc22CpdUIVXm3vWmfQeiTM8nqeneP0u76fUWzR1dywiftI/CPkj9IziZgw2f5RKPJoHjCwZXw4Hd0ExbpV9NlOH2EAe/k4ZZ12QR3H0wPzzqn3/O9+s0ugKoAa6VsJpwGDfe3JKed5+4nrSoLTSR2i8z+a63bMAZyURGP+dxWIVJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFXblL6Gq/sYk/7e9V+f4TRyLD06WrfNKjBj39vOJhY=;
 b=HfpAJFlOdPoZSIXwBXDZuNtfGLXinSbiCz4+Mfmou1raz44AOft7ZagcDiNzJlawkrd/j/LYlhl6Tx/2mxBqWkHfiBli/QbDAAcjaJp6NXNoa+Nnl3GQ2w+nEiT6FKW5lxb/dnza5lkM/a9GsFueJvjPlm9/3j/uEEdxw+qUywItIwP3IEWcem69YtbbTC7hV6x3P0wI3taF3r8tCuRh8IIu0OoTvR8yyhLIsv/Z9YWZvrmtx725z9Ha80vyizPuGJPjaJH3kGOJJjf/LRFibGFvd30Bn543IDQXEEYyTsOlGZ0jstQTV8sFkPIW6Ne0c/qgWYbgMO7KvcOUs2vDeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFXblL6Gq/sYk/7e9V+f4TRyLD06WrfNKjBj39vOJhY=;
 b=M0l2kjh7dxdC9H4SXRfZojbj2nw/Cpa8vLLdCv9OfV8t7qlch2mJO249FLlfsLzV/ddZgZ+nNiNr1dAmkKWQl0J3IRymBlQ9xGdG7EM9t3EBUVshX+WZ9mEosuBEJSDrG1fAfWQBWoN/6qdpvSoVS7RV7ebNiOgbR6gb4DjTsgIsiu78/9gK21/kWye4LCvTt2vWCAktmNWIZ35M/8ps9uPoCqK8Otm7d+YK+Hv0vR0ODjQgM1525S5jGptJuiXSTNVFef+SkxL2r/7bX80DGthhUD7bc/KeNcM3ezm/aHznp4vKzsbvZIkTXRyrKOoF7FERIOSLRXDaWPF9rVhAtQ==
Received: from DS7PR03CA0330.namprd03.prod.outlook.com (2603:10b6:8:2b::22) by
 LV8PR12MB9208.namprd12.prod.outlook.com (2603:10b6:408:182::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 07:16:53 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:8:2b:cafe::6c) by DS7PR03CA0330.outlook.office365.com
 (2603:10b6:8:2b::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Wed,
 29 Jul 2026 07:16:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 07:16:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 29 Jul
 2026 00:16:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 29 Jul
 2026 00:16:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 29
 Jul 2026 00:16:32 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, "Cosmin
 Ratiu" <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Vu Pham
	<vuhuong@nvidia.com>
Subject: [PATCH net] net/mlx5: SF, Handle function changed event
Date: Wed, 29 Jul 2026 10:16:22 +0300
Message-ID: <20260729071622.2423270-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|LV8PR12MB9208:EE_
X-MS-Office365-Filtering-Correlation-Id: 89d65e70-2770-435c-2eee-08deed415d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|23010399003|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8YWgu59sfXE1HHE4THDJ5QBdLBCviwWeUfeSzfe8+rsLLydq5On/h0trckA1V2hKXj9ThtpsxD6dDavL4B/lhh/NrqJjfI2bdMNgfxf4PW/LaJC6UwvG6GfZeLdwoHaxdf5KialZykhjS1UN+rJfMCpBHSOiioCs9NmshLGSaPJUWVjifvGyJEsi85RtzJLajOEDmQ7kQ1pNiu8/LezlRb9K2MDNnx7iinM8uw/Tx5CEvmg3+jHGozwbNaoZbDHFG43k7DK4AfKalr111qxM4JXY8f72PAXBicu9nkgqDg1ZnS4LOS6vYKLWeEFxji4+jPZP4bXd4/FFPdHGffhR+nOLBR7sis4VzfZmMVq+JG+scgHBR768cB+/+1RAHKNFcc2gl6ljdPWnDg98cgsXr2M+rFUoBZjB3jFkDwLbBqYFJnj2eADelCjjcfyO7LVJdrETxON+ujj0cMq6HNqXiGnCUtrpJfvtJfZHV96QRYvr0gf7anmlvcozaM7E/h/A1XrjzS/pyeDkAqiKcMnlJDOsfzirbGLUBfthnEMOdtdLU3tL0lw0ZZuTs3E8NnL7G9ynCHg7GVUQksxVnx9JfQvu0ynkfWbX+UtJd0WC+ThnBEXMdwdBUt5WLYqv9xSKsDstefn5FEOpOyiaTfpDmTJHAJfzy2BSH69NUQcgLDSutaizNtdahZ2LBgoMe8SQCrljJLG1IKoB0DiH/PeS0w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(23010399003)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qw5xCR0/uOjEXuHo2dpdGbD5LmWuLwJdSxgw57kSP9XQYHRZe/dVPn0hw5iVpymbYiXWl6wBk/MVWLIZImyj0IK7NZOO4HWmBaQsZ4Gn6wQETTR8g/kCzQt0vxIOoEjd/YpMY9At3dZzv2hxLtI4jopdUu6sNj/pd+MTMEupTlu7Ao6SajA59E3Ee2wSIHHFwt4b9mFMdWkRtXXmCkiZYtBD9bgyQkOYfrcAzF7i6POrkhK7rYgZWfNO8U7FFPzJeCOFUG4JLj9k5Pbr6CEwOyHQ6I2IWKgJp9g5WUOxNGBIDGoY4r5jtBprbZIaDYNEs22idDhIKqanpGcNzGFckV9QGj4HZR237I+Avq7vTQ1e1pQ3B7OgINtMjaqcIk6M7Umkw/ItzY9Goa2Crr8bUV2Z2kzRieyeNHNLORYBM9n7ZnLc/ShDqGh00SnhlyA3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 07:16:52.5295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d65e70-2770-435c-2eee-08deed415d46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9208

From: Chris Mi <cmi@nvidia.com>

When host is powered off, firmware does not send vhca_state event
for every probed host SF on the DPU because it may have deployed
thousands of SFs to the host. Instead it sends a function changed
event. Currently, only VFs handle this event. This commit extends
support to SFs.

When DPU user deactivates[1] SFs, mlx5 expects vhca_state event
and leaves the SF in dangling state[2].

When DPU user deletes[3] SFs, mlx5 also expects vhca_state event
and destroys the SF resources[4].

Fix it by changing SF to the right state and freeing SF resources
when the function changed event is received.

When this event is received, driver checks all SF states.
 - If state is in_use, change it to active.
 - If state is teardown_request, change it to allocated.

And SF hardware table entry is freed if it is pending for delete.

[1]
 # devlink port function set en3f0c1pf0sf0 state inactive

[2]
 # devlink port function set en3f0c1pf0sf0 state active
 Error: mlx5_core: SF is inactivated but it is still attached.
 kernel answers: Device or resource busy

[3]
 # devlink port show
 pci/0000:03:00.0/229376: type eth netdev en3f0c1pf0sf0 \
	flavour pcisf controller 1 pfnum 0 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state active opstate attached \
	roce enable trust off max_uc_macs 4096 max_io_eqs 8
 # devlink port del en3f0c1pf0sf0

[4]
 # devlink port add pci/0000:03:00.0 flavour pcisf pfnum 0 sfnum 0 \
	controller 1
 Error: mlx5_core: SF already exist. Choose different sfnum.
 kernel answers: File exists

Fixes: 6a3273217469 ("net/mlx5: SF, Port function state change support")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 10 +++++--
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 29 +++++++++++++++++++
 .../mlx5/core/sf/diag/sf_tracepoint.h         |  8 +++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 22 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   | 12 ++++++++
 5 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 907ee83a722d..247e5d85ec36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3986,7 +3986,7 @@ static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->fdb_table.offloads.vports.lock);
 }
 
-static void esw_vfs_changed_event_handler(struct mlx5_eswitch *esw)
+static void esw_changed_event_handler(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_pf_info host_pf_info;
 	u16 new_num_vfs;
@@ -3999,6 +3999,11 @@ static void esw_vfs_changed_event_handler(struct mlx5_eswitch *esw)
 	host_pf_info = mlx5_esw_get_host_pf_info(esw->dev, out);
 	new_num_vfs = host_pf_info.num_of_vfs;
 
+	if (host_pf_info.pf_disabled) {
+		mlx5_sf_table_esw_changed_event_handler(esw->dev);
+		mlx5_sf_hw_table_esw_changed_event_handler(esw->dev);
+	}
+
 	if (new_num_vfs == esw->esw_funcs.num_vfs || host_pf_info.pf_disabled)
 		goto free;
 
@@ -4091,8 +4096,7 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb,
 	esw_funcs = mlx5_nb_cof(nb, struct mlx5_esw_functions, nb);
 	esw = container_of(esw_funcs, struct mlx5_eswitch, esw_funcs);
 
-	ret = mlx5_esw_add_work(esw, esw_vfs_changed_event_handler,
-				GFP_ATOMIC);
+	ret = mlx5_esw_add_work(esw, esw_changed_event_handler, GFP_ATOMIC);
 	if (ret)
 		return NOTIFY_DONE;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index b6cecbcc392d..4564d460416b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -561,3 +561,32 @@ bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev)
 
 	return xa_empty(&table->function_ids);
 }
+
+void mlx5_sf_table_esw_changed_event_handler(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table = dev->priv.sf_table;
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	trace_mlx5_sf_host_pf_disabled(dev);
+
+	if (!table)
+		return;
+
+	mutex_lock(&table->sf_state_lock);
+	xa_for_each(&table->function_ids, index, sf) {
+		if (!sf->controller)
+			continue;
+
+		if (sf->hw_state == MLX5_VHCA_STATE_IN_USE)
+			sf->hw_state = MLX5_VHCA_STATE_ACTIVE;
+		else if (sf->hw_state == MLX5_VHCA_STATE_TEARDOWN_REQUEST)
+			sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;
+		else
+			continue;
+		trace_mlx5_sf_update_state(table->dev, sf->port_index,
+					   sf->controller, sf->hw_fn_id,
+					   sf->hw_state);
+	}
+	mutex_unlock(&table->sf_state_lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
index 302ce00da5a9..9dc88a7e30ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
@@ -11,6 +11,14 @@
 #include <linux/mlx5/driver.h>
 #include "sf/vhca_event.h"
 
+TRACE_EVENT(mlx5_sf_host_pf_disabled,
+	    TP_PROTO(const struct mlx5_core_dev *dev),
+	    TP_ARGS(dev),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))),
+	    TP_fast_assign(__assign_str(devname);),
+	    TP_printk("(%s)\n", __get_str(devname))
+);
+
 TRACE_EVENT(mlx5_sf_add,
 	    TP_PROTO(const struct mlx5_core_dev *dev,
 		     unsigned int port_index,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 0bc9146a3598..95a8b1e64ba4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -459,3 +459,25 @@ bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev)
 {
 	return !!dev->priv.sf_hw_table;
 }
+
+void mlx5_sf_hw_table_esw_changed_event_handler(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_hw_table *table;
+	struct mlx5_sf_hwc_table *hwc;
+	int i;
+
+	table = dev->priv.sf_hw_table;
+	if (!table)
+		return;
+
+	mutex_lock(&table->table_lock);
+	hwc = &table->hwc[MLX5_SF_HWC_EXT_HOST];
+	for (i = 0; i < hwc->max_fn; i++) {
+		struct mlx5_sf_hw *sf_hw;
+
+		sf_hw = &hwc->sfs[i];
+		if (sf_hw->allocated && sf_hw->pending_delete)
+			mlx5_sf_hw_table_hwc_sf_free(dev, hwc, i);
+	}
+	mutex_unlock(&table->table_lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index d8a934a0e968..ed784682b9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -15,12 +15,14 @@ void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sf_hw_notifier_init(struct mlx5_core_dev *dev);
 void mlx5_sf_hw_notifier_cleanup(struct mlx5_core_dev *dev);
 void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev);
+void mlx5_sf_hw_table_esw_changed_event_handler(struct mlx5_core_dev *dev);
 
 int mlx5_sf_notifiers_init(struct mlx5_core_dev *dev);
 int mlx5_sf_table_init(struct mlx5_core_dev *dev);
 void mlx5_sf_notifiers_cleanup(struct mlx5_core_dev *dev);
 void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev);
+void mlx5_sf_table_esw_changed_event_handler(struct mlx5_core_dev *dev);
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
@@ -60,6 +62,11 @@ static inline void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
 {
 }
 
+static inline void
+mlx5_sf_hw_table_esw_changed_event_handler(struct mlx5_core_dev *dev)
+{
+}
+
 static inline int mlx5_sf_notifiers_init(struct mlx5_core_dev *dev)
 {
 	return 0;
@@ -83,6 +90,11 @@ static inline bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev)
 	return true;
 }
 
+static inline void
+mlx5_sf_table_esw_changed_event_handler(struct mlx5_core_dev *dev)
+{
+}
+
 #endif
 
 #endif

base-commit: 3bd438a58e910db5dc369aa25dfed1fc95f1b596
-- 
2.44.0


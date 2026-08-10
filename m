Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011055.outbound.protection.outlook.com [40.93.194.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7235E29993F;
	Mon, 10 Aug 2026 09:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354277; cv=fail; b=WsVBUxAxGDPCkLKms5vjzBJryf9MyVsdzTXhnMShJBbb3kdCwbKzR+5OnUUd5vLWqC7orymr22s7MI8F6E5gbuZTZLOCdpMMzxFh52OeyXTU0UR2/SsHcxHVSzLn1Qv+NyOejzTWugWsFXXlDfXKJfOzMahFKd2fNESIVfD/jxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354277; c=relaxed/simple;
	bh=aIGAZDTz2HMdA2NTcdMIMaWtWJ7IljJF8EfNN77JEkc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=icjW0dSo4cUr6J/74UNguRE5/z4p2viuHOS+KvyZsaCHvsZYzRZz7YB52MjqnH1ZjJjYo0nvD1I7gW8exa9bFfEoiqwo4l6QztzsykWN009pUGstGF0GNXZybH71rM2psmxUShPd1OIn4iue6vZfP7rjDvtm2zRY1ve0jKhBBkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+cqVUfv; arc=fail smtp.client-ip=40.93.194.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+cqVUfv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJEC46oPzsP5dIxgDrcTYafDdIvzKrAaXk6mhe0FlMmHI7XZy5YHWm0r0rvLCUrgvu5NYzaYz4qUGowmK+FPUz//T2pI+o4a9EayhVuQVlIxslSRyuhmnfYma17EGyV5xr2WLMqYn+0vaevJoGy2D0jrmV6vIwSAA+rFPnMLyC0l5XUEwLEoO9wOAf1uDQtsTFQIYeqqZAaLGhok8kUv6L7+nD3+N2oK3M7KhNtxpjEdIldBhKl7z1LfUm8fTc845J9f1kbAntaTMyrqYerBQm6s9vXzKs/80Mjtte8zWcr0HL6omb5cXALrLQOZ3n096SWY08UYoSeNQJcr6GMG1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdhhwN/oC1jqiHctBMsGF5FGUc4iJ5EQ7Ar/l7yzoRc=;
 b=TYHu9UP/I/nkAtmHy+2bmcXNsKNWsxPCLtMyKfRmP8+h+yPsb2mP3ZNXK9MbRVzEfuqxkID45jQfVPe+eQHdyzt2wLbiYjfWVKqb9N/laKerX0mgjf7d3wpvJ09+NnqFiDpVVvvOVYPmCHbk9JWXJV/BpU3bWGoSnSy4pR24x14gGqzF6HphULSjhkl7QD6znwmDYVWKwRyXA66U4E9zrCtsFJn2Zp3wVYsQgmgO+u8NaRhL/RFtNDJmwev0MioQPE9yPw6PTzygVx37Ul1FPB05gNNFDliiSFf1khZ4OQmnOGYYhRmSCKgF7Wb4wtmxCuaEiRAUXMqSRm3OMgI/Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdhhwN/oC1jqiHctBMsGF5FGUc4iJ5EQ7Ar/l7yzoRc=;
 b=h+cqVUfvYT+0Z+sHhR+pLbNcVu0ez2Yeo21ujvt69vcOlqIoAMKZ4eti/wTpQIZ2nRq30JZbUuIo4tMOqyEU16m2JdeoPd3zJyNXEqAT0RlBs/5in2qWay1CGAd8K1Qlmg66WaS0osBDvERPLz9ZMRAcLF2Cjvx2yfTeO6ojJmr9rwJ2g71RY1z8bg7RrzjvTnDpil+T8OCKyfVkYqvj1J9j8E7f88ZE7LanqspbLt75lyRcBwhpiOHNguw3vW/KHR8aCa4kMFt20YZfgaay3fUgdDcRG+8gRJvkby2XL2kFFfLS8Fti77IdmR0EJsZ1ECgkKd3HUqMWh5F7x3I5/A==
Received: from SJ0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:a03:2c0::13)
 by BN7PPFFF39339DD.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6eb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 09:31:09 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::38) by SJ0PR13CA0008.outlook.office365.com
 (2603:10b6:a03:2c0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.10 via Frontend Transport; Mon,
 10 Aug 2026 09:31:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:31:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:30:56 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:30:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 10
 Aug 2026 02:30:51 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5: SD, prefer sd_group_size from vport context
Date: Mon, 10 Aug 2026 12:30:37 +0300
Message-ID: <20260810093037.3138197-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|BN7PPFFF39339DD:EE_
X-MS-Office365-Filtering-Correlation-Id: 06a68df7-ca02-47fd-04b0-08def6c21c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700016|23010399003|82310400026|18002099003|6133799003|56012099006|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	qFfcGYPgwHcb819SYNt7fV+3PAbBBdGcgkCER7YScIju9ojTi8ptg+xysBgN/6OzzZMpIx3ojpdDqIFIlflWhfahvb29I1VsaQeNsrojGke7dYOYnY6jFXj/UgIGAr7tNGVOvylYGh0wpG4qETDjd+e/v4bitUzdTwAMmj+Jt/jCkrfdtPojnT9pgmGUQfl3kUzl1UToTyBv+zc066lo8hO9JRJEhEWJUjru+9276wMukYMXSwQAmUdw/lwWrKDXV9bRdZcDtmNywn2r33H4DHz05zFWel2Bu8sIoYTeJtUa7z/E6x37LXIJlJcyAgQwduHWeLVYxxXzwRve+1Bb+j8kUZFLKbY/lTBCVM9cI8jz6jAFpc7FrLwJIzALGyEba5pMuorri6oMq8I38JxsA5iVN3a1JyVepkCMrpE1B0uQ+0O3KyP4iM1r3d64Rz5GHGPxkKQToSkksojMmH7Y3lZltJRlXO3W/m8iay0r2Fet9v7e/DTZ0YqyDwZQmGVj5fzZyGfV5LEo+GScVajm6V4gWj3RjYxBCcEboDboIzWAmiq/au5gXkES0zojkPqpZF0W+7GWgb0YWtn4IMGBSkhWUnKDeIie0hJ9f+GfVi8uQopYcmGLe+sT1J5njtdgToykPS9J1bf6dFQMsJs2yNjSoFTZ/QfGzqFVI5MQp2LZgSmQxmqQW+qIW1oznc9hP11qQpeReDecMOYNm+l30g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700016)(23010399003)(82310400026)(18002099003)(6133799003)(56012099006)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7Ntg8dPi0YiPvT68ycM8A6pq4tt9fQJzcBDp0SIfkUG0Vm9EpaBczj6eIpxbVP5bXYWED5Yv4APOU8psU46z93OasMTl8HBqEmPmB5efkzHE5o1A2/ZZ+ZnP2Z8t3++FyzwsUUnupiHkLf78kGv0GItMtz/yWABv3w10yWaqaqh8hRh9U1JEnmjxEJcJPOpDx50ZXulm381RV/MPqBqdO7QsPaExM7qgwmOX4dPVZig0BQlNBDbHDtWV6/xPEPMlG2Z6lxtSY3VEQUHanu/Nf+DF5n3+PSdK24VhUZDwD5uKyjo3V/UUcNLB+R772hxs3KkViNB/USVlBhJeuHYvmyEOjvi/uwAt8J+IAxnBGiBWXVSoaMOVpc3gk9CX3e9wsV8jVksVvEWtiylYXnLgI3/X1UHgJ8+YlPssfrz+Ayc9KF90GhSqaSoezYJm1LBz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:31:08.7455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a68df7-ca02-47fd-04b0-08def6c21c0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFFF39339DD

From: Shay Drory <shayd@nvidia.com>

Newer FW reports the SD group size directly in the NIC vport context
via the sd_group_size field, gated by the sd_group_size capability.
Switch sd_init() to source the group size from there and fall back to
the MPIR-based host_buses query only when the cap is absent.
sd_group_size might return 1 in some FW configuration. Add explicit
check to disable SD creation in this case.

While here, rename host_buses to group_size throughout sd.c to follow
the new name on capable FW.

issue: 4680618
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  | 75 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/lib/sd.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  6 +-
 include/linux/mlx5/vport.h                    |  3 +-
 4 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
index ee2fdefa1945..4cdc50cd6f03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
@@ -19,7 +19,7 @@
 
 struct mlx5_sd {
 	u32 group_id;
-	u8 host_buses;
+	u8 group_size;
 	struct mlx5_devcom_comp_dev *devcom;
 	struct dentry *dfs;
 	u8 state;
@@ -46,14 +46,14 @@ enum mlx5_sd_state {
 	MLX5_SD_STATE_UP,
 };
 
-static int mlx5_sd_get_host_buses(struct mlx5_core_dev *dev)
+static int mlx5_sd_get_group_size(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sd *sd = mlx5_get_sd(dev);
 
 	if (!sd)
 		return 1;
 
-	return sd->host_buses;
+	return sd->group_size;
 }
 
 struct mlx5_core_dev *mlx5_sd_get_primary(struct mlx5_core_dev *dev)
@@ -107,7 +107,7 @@ int mlx5_sd_pf_num_get(struct mlx5_core_dev *dev)
 		if (pos == dev)
 			break;
 
-	return pf_num * sd->host_buses + i;
+	return pf_num * sd->group_size + i;
 }
 
 struct mlx5_core_dev *
@@ -118,7 +118,7 @@ mlx5_sd_primary_get_peer(struct mlx5_core_dev *primary, int idx)
 	if (idx == 0)
 		return primary;
 
-	if (idx >= mlx5_sd_get_host_buses(primary))
+	if (idx >= mlx5_sd_get_group_size(primary))
 		return NULL;
 
 	sd = mlx5_get_sd(primary);
@@ -130,7 +130,7 @@ int mlx5_sd_ch_ix_get_dev_ix(struct mlx5_core_dev *dev, int ch_ix)
 	if (is_mdev_switchdev_mode(dev))
 		return 0;
 
-	return ch_ix % mlx5_sd_get_host_buses(dev);
+	return ch_ix % mlx5_sd_get_group_size(dev);
 }
 
 int mlx5_sd_ch_ix_get_vec_ix(struct mlx5_core_dev *dev, int ch_ix)
@@ -138,7 +138,7 @@ int mlx5_sd_ch_ix_get_vec_ix(struct mlx5_core_dev *dev, int ch_ix)
 	if (is_mdev_switchdev_mode(dev))
 		return ch_ix;
 
-	return ch_ix / mlx5_sd_get_host_buses(dev);
+	return ch_ix / mlx5_sd_get_group_size(dev);
 }
 
 struct mlx5_core_dev *mlx5_sd_ch_ix_get_dev(struct mlx5_core_dev *primary, int ch_ix)
@@ -164,7 +164,7 @@ static bool ft_create_alias_supported(struct mlx5_core_dev *dev)
 }
 
 static int mlx5_query_sd(struct mlx5_core_dev *dev, bool *sdm,
-			 u8 *host_buses)
+			 u8 *group_size)
 {
 	u32 out[MLX5_ST_SZ_DW(mpir_reg)];
 	int err;
@@ -174,7 +174,7 @@ static int mlx5_query_sd(struct mlx5_core_dev *dev, bool *sdm,
 		return err;
 
 	*sdm = MLX5_GET(mpir_reg, out, sdm);
-	*host_buses = MLX5_GET(mpir_reg, out, host_buses);
+	*group_size = MLX5_GET(mpir_reg, out, host_buses);
 
 	return 0;
 }
@@ -184,10 +184,10 @@ static u32 mlx5_sd_group_id(struct mlx5_core_dev *dev, u8 sd_group)
 	return (u32)((MLX5_CAP_GEN(dev, native_port_num) << 8) | sd_group);
 }
 
-static bool mlx5_sd_caps_supported(struct mlx5_core_dev *dev, u8 host_buses)
+static bool mlx5_sd_caps_supported(struct mlx5_core_dev *dev, u8 group_size)
 {
 	/* Honor the SW implementation limit */
-	if (host_buses > MLX5_SD_MAX_GROUP_SZ)
+	if (group_size > MLX5_SD_MAX_GROUP_SZ)
 		return false;
 
 	/* Disconnect secondaries from the network */
@@ -200,7 +200,7 @@ static bool mlx5_sd_caps_supported(struct mlx5_core_dev *dev, u8 host_buses)
 	/* RX steering from primary to secondaries */
 	if (!MLX5_CAP_GEN(dev, cross_vhca_rqt))
 		return false;
-	if (host_buses > MLX5_CAP_GEN_2(dev, max_rqt_vhca_id))
+	if (group_size > MLX5_CAP_GEN_2(dev, max_rqt_vhca_id))
 		return false;
 
 	/* TX steering from secondaries to primary */
@@ -214,7 +214,7 @@ static bool mlx5_sd_caps_supported(struct mlx5_core_dev *dev, u8 host_buses)
 
 bool mlx5_sd_is_supported(struct mlx5_core_dev *dev)
 {
-	u8 host_buses, sd_group;
+	u8 group_size = U8_MAX, sd_group;
 	bool sdm;
 	int err;
 
@@ -222,23 +222,25 @@ bool mlx5_sd_is_supported(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return false;
 
-	err = mlx5_query_nic_vport_sd_group(dev, &sd_group);
-	if (err || !sd_group)
+	err = mlx5_query_nic_vport_sd_group(dev, &sd_group, &group_size);
+	if (err || !sd_group || group_size < MLX5_SD_MIN_GROUP_SZ)
 		return false;
 
-	if (!MLX5_CAP_MCAM_REG(dev, mpir))
-		return false;
+	if (group_size == U8_MAX) {
+		if (!MLX5_CAP_MCAM_REG(dev, mpir))
+			return false;
 
-	err = mlx5_query_sd(dev, &sdm, &host_buses);
-	if (err || !sdm)
-		return false;
+		err = mlx5_query_sd(dev, &sdm, &group_size);
+		if (err || !sdm)
+			return false;
+	}
 
-	return mlx5_sd_caps_supported(dev, host_buses);
+	return mlx5_sd_caps_supported(dev, group_size);
 }
 
 static int sd_init(struct mlx5_core_dev *dev)
 {
-	u8 host_buses, sd_group;
+	u8 group_size = U8_MAX, sd_group;
 	struct mlx5_sd *sd;
 	u32 group_id;
 	bool sdm;
@@ -248,26 +250,27 @@ static int sd_init(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return 0;
 
-	err = mlx5_query_nic_vport_sd_group(dev, &sd_group);
+	err = mlx5_query_nic_vport_sd_group(dev, &sd_group, &group_size);
 	if (err)
 		return err;
 
-	if (!sd_group)
+	if (!sd_group || group_size < MLX5_SD_MIN_GROUP_SZ)
 		return 0;
 
-	if (!MLX5_CAP_MCAM_REG(dev, mpir))
-		return 0;
+	if (group_size == U8_MAX) {
+		if (!MLX5_CAP_MCAM_REG(dev, mpir))
+			return 0;
 
-	err = mlx5_query_sd(dev, &sdm, &host_buses);
-	if (err)
-		return err;
-
-	if (!sdm)
-		return 0;
+		err = mlx5_query_sd(dev, &sdm, &group_size);
+		if (err)
+			return err;
 
+		if (!sdm)
+			return 0;
+	}
 	group_id = mlx5_sd_group_id(dev, sd_group);
 
-	if (!mlx5_sd_caps_supported(dev, host_buses)) {
+	if (!mlx5_sd_caps_supported(dev, group_size)) {
 		sd_warn(dev, "can't support requested netdev combining for group id 0x%x, skipping\n",
 			group_id);
 		return 0;
@@ -277,7 +280,7 @@ static int sd_init(struct mlx5_core_dev *dev)
 	if (!sd)
 		return -ENOMEM;
 
-	sd->host_buses = host_buses;
+	sd->group_size = group_size;
 	sd->group_id = group_id;
 
 	mlx5_set_sd(dev, sd);
@@ -540,7 +543,7 @@ static int sd_register(struct mlx5_core_dev *dev)
 	sd->devcom = devcom;
 
 	mlx5_devcom_comp_lock(devcom);
-	if (mlx5_devcom_comp_get_size(devcom) != sd->host_buses ||
+	if (mlx5_devcom_comp_get_size(devcom) != sd->group_size ||
 	    mlx5_devcom_comp_is_ready(devcom))
 		goto out;
 
@@ -576,7 +579,7 @@ static int sd_register(struct mlx5_core_dev *dev)
 				      DEVCOM_CANT_FAIL, primary);
 
 	primary_sd = mlx5_get_sd(primary);
-	if (primary_sd->next_secondary_idx + 1 == sd->host_buses)
+	if (primary_sd->next_secondary_idx + 1 == sd->group_size)
 		mlx5_devcom_comp_set_ready(devcom, true);
 out:
 	mlx5_devcom_comp_unlock(devcom);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.h
index cb88bf34079a..bc8dbc299070 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 
+#define MLX5_SD_MIN_GROUP_SZ 2
 #define MLX5_SD_MAX_GROUP_SZ 2
 
 struct mlx5_sd;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 3676e26ac6b0..3d86510af615 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -550,7 +550,8 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_system_image_guid);
 
-int mlx5_query_nic_vport_sd_group(struct mlx5_core_dev *mdev, u8 *sd_group)
+int mlx5_query_nic_vport_sd_group(struct mlx5_core_dev *mdev, u8 *sd_group,
+				  u8 *sd_group_size)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
 	u32 *out;
@@ -566,6 +567,9 @@ int mlx5_query_nic_vport_sd_group(struct mlx5_core_dev *mdev, u8 *sd_group)
 
 	*sd_group = MLX5_GET(query_nic_vport_context_out, out,
 			     nic_vport_context.sd_group);
+	if (MLX5_CAP_GEN(mdev, sd_group_size))
+		*sd_group_size = MLX5_GET(query_nic_vport_context_out, out,
+					  nic_vport_context.sd_group_size);
 out:
 	kvfree(out);
 	return err;
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index ee34d3ed335f..577168a4ca0c 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -78,7 +78,8 @@ int mlx5_query_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 *mtu);
 int mlx5_modify_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 mtu);
 int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 					   u64 *system_image_guid);
-int mlx5_query_nic_vport_sd_group(struct mlx5_core_dev *mdev, u8 *sd_group);
+int mlx5_query_nic_vport_sd_group(struct mlx5_core_dev *mdev, u8 *sd_group,
+				  u8 *sd_group_size);
 int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev,
 				   u16 vport, bool other_vport, u64 *node_guid);
 int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,

base-commit: 001b5d347d8ba39b2dccaefcc57967b18caec8fe
-- 
2.44.0


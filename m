Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A12849D5A5;
	Wed, 23 Sep 2026 10:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160049; cv=fail; b=T185cz+0VotPjuFZBLud0kO0VWJOGHci9OnYtRXVZCmfNLe6Xua3WBknryY3u+GuokgVupstTkp+QuIgqT8Dj+1vwEIYMOoVPLtNTI7PTjZuSgd0+owx0UPZR8Yi/XTKA12OGu1DSe4A9yWY5BAaC8ncF/NxPB18Dmc3B2hwBVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160049; c=relaxed/simple;
	bh=B7/tu4T3AA5PV/MsuadurcoDlbSAIusGwTzcYZT3nHE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MnPw/Jd1DN2n/gHVOt3BhjF4BLP6Za68fUj4qcFb90oWnkk+lHQmmf7ErG7O6fR2xwsb4IvHepaSykiEAETi4SWskBp1Y7+prDfTXDLlltYp7UTaLc3up3wjJFuJRatPWYy0pq+jgubdKxnTVIebkV4KTJiUGyEx9233T41ewNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rQtFt/J6; arc=fail smtp.client-ip=52.101.46.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rQtFt/J6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JueIfrsnuQJAMAjq/EYZ7LW7WAxwBxzsx1kZpSQkIHQ1fgAXWtdThdyGhDAY1yk3U4ER1V343hKiIaKtguU/NsKOxifu6E00621r1r0gyQ4YM3rtUr6w4BMFB18oeUYOt2gjtXfgULkJRuGVJbMd0blPHxSinMYconbiDyodSoxsR/PC8DRRqW1dUtOI0tRKyFNilZKshtP42aw9jgjO1WqLcxqcpBGfRE6LOxsPRhV0P5UqKRsAJ37CWPxkIDkIdwQlyusqzha0I7RAq5EwD69CayAGpAwZeog6BfjNinasDVDp6W1zh2j++14g29Q6i1zextZRPJv+Eqg17tfJkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXV/9du/SBcaVlurvBqZaQIR63UG7b2pSvm2BwueF6o=;
 b=A6FqfgyA7xyyHDQRnwXbdDVwaSqrvkj5h8Pp8XhLyNGJmcG/X5ya41MCAgsCr+WCsRjtEeJHRF1A37zCp3vwISg32A0MxVKafJUgPxG2owlRgpPDSwSabHNhOeEJQDizRkZUVU/WcZHgSmFD9iu+xkWe1axwV4h703y9+zIrJOU6ocSI7oFHFLZKFEKPbP26doV64Me2V+MoE9A8yG32+2fWLgucpTC9fJF6dgvCu2AS7POpAWW7kSfFb6I0R+2sWtcKCloLAd349toEriIj+ZYdbFLo9sBjTrdus9ZR28SGfYAkmczeScUxhr8WCStUHLZvr35jKaTGz+96k7ggow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXV/9du/SBcaVlurvBqZaQIR63UG7b2pSvm2BwueF6o=;
 b=rQtFt/J6iIm1A2pbkvbupe0sBqeBDDoXPCrwt0m3Gz+HRHDztiboHjTOsjpmoP4JC2vH32pc43uiyenkBcjus/bArqoNv4ZWdOpDclaZHk7jSrTPxXUijzXuCzu/HcHWw6EkjYDvoz9KEv8xyhOLOpyXbJFVxC2mzSbAbSkOg8YeyGWKazDqrhCkOaJ5MvxS/L2nGHDQnq4b9RGIaj/IqJtdRdA7iaZvc3w+nrgEEw6XaqewbWqpia7SD5Ilh9ekiFTQnaFsvBpLIMubwpF5x0B5Mb5XE4d/KDOPUM0+dt+8NpvRSWwJD/gVmDO2tReT4Ac8jfDCte57G0Q0aFLSKA==
Received: from DS1PR06CA0010.namprd06.prod.outlook.com (2603:10b6:8:458::17)
 by CH2PR12MB9541.namprd12.prod.outlook.com (2603:10b6:610:27e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:40:34 +0000
Received: from DS2PEPF000061C1.namprd02.prod.outlook.com (2603:10b6:8:458::4)
 by DS1PR06CA0010.outlook.office365.com (2603:10b6:8:458::17) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16
 via Frontend Transport; Wed, 23 Sep 2026 10:40:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C1.mail.protection.outlook.com (10.167.23.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:14 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:09 -0700
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
Subject: [PATCH net-next 04/13] net/mlx5: LAG, allocate port-indexed scratch buffers dynamically
Date: Wed, 23 Sep 2026 13:38:21 +0300
Message-ID: <20260923103830.1183-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C1:EE_|CH2PR12MB9541:EE_
X-MS-Office365-Filtering-Correlation-Id: 862f5814-072c-436b-1bc9-08df195f18db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MipqEfzH90Csjg3xizunSNxVcQ8BMWphR/A3avmzEsmDFGIKdeiJDS5G++6d0x1Ysx00Y61NHFEJfnoQdSXkq6TCcKZsafhkKt8iD2IPH3rjxpjdBshbKLPzlgsjFna2e2sIfiw4q0+Nw3MvslVuKRRcPqnnKqH0b/eSO2chQsSM7SAAoFrVazc3GiO1cTtFT27iUAmuB96gzTRyoyIt9J4h2c9LgUJaLH9LyZBJWo2SYre0S72v9G4dYNweaxGUvSS+DDjTygRLFHYbPUReYJdegwJshH3ka+QGXgb8vjKkGL6d+wvw2682ekjm0yEdnYwXnFlwtSmWSqCgUpKZ28C/0KBdCwbIgGfayAgFqaPue/rokZB2o0v/49hHtgXlW6dondfYL6+D5hHTqC1NcL5p7MGua0TWerH7HuVyXJrnDGYntY/wKUpwHbOEvvjAKfGb/A0nXDJsG++Qr19io3Ii4IUhNvtkD0hpmm0Da7piWcxUXpKZkL5jabHuB9J7Vyl4tH23AJwhwSP5My7yJqR5b+uhtzoY0Pqnee6aK2L6UxiEPykhBxVA6spKG5fLxaN3J60yC44rOqQ628CRzOWfSWga5OI5np15GkhtI96Hl5mS0VXmL/NMvWMVl5jmEuEY4sgj9uUTCC9WBMjl40rq7xv6F+bo6GQ6zNU+ZvqDwNyxBCLe7VV/8h29j1ogOnSIo8Yj6LexCZUhje/hvw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QWuY6RBaTxTrwXEE123C7pTWPJNPYehp6o38jdGuFHCcOEW/q7Z+nolnJ03r8udMYRLBNK1lHR2ADXiMs8+Ds26/qyg6Pi+D9D8cYkEigoA/70TjBBVKvYnXaVczso9DLYj8DLE6s/43OhtS0YRL7VhD2dy5PO3l7K+fsOgv3YcsXdTSw1g6RZmuTGwkT2yJtZg6RTlPhP6gHmAd3e/Lg+wGQYvn/FlCtrwq8tHHlccceTWNKA2dBXkbrv7WPB6D7flY02l5Yug2U9Rl+2dlwsOBgJZYr4wJoJgZ42G2RgifLfqvnw5zBS+nfBWsdo2A384vgg1pBcMcbIy3X8u5ynIfKRZzdMZvfYyZjkJOKhA1t/jNQmqqiDiYv01Zfws7J87AZmp/wm/wUlwHs2nyinNyMu4v3/u7/XV2mliisET8zT/piH9IZ2nSLvLltaGC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:33.8137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862f5814-072c-436b-1bc9-08df195f18db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9541

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_print_mapping(), mlx5_infer_tx_affinity_mapping() and
lag_active_port_bits() each used a MLX5_MAX_PORTS-sized stack buffer to
hold per-port working state. Allocate these buffers with
kcalloc(ldev->ports, ...) instead so they track the actual port count
and no longer depend on MLX5_MAX_PORTS.

lag_active_port_bits() can now fail on allocation, so it returns int and
propagates -ENOMEM; a non-negative return is the active-port bitmask as
before. Its two callers, mlx5_cmd_create_lag() and _mlx5_modify_lag(),
check for a negative return and bail out, then narrow the value back
into the u8 they hand to the device.

This removes these buffers' dependency on MLX5_MAX_PORTS.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 100 ++++++++++++++----
 1 file changed, 80 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 00b0159cb422..93ead5664152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -63,19 +63,25 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
-static u8 lag_active_port_bits(struct mlx5_lag *ldev,
-			       struct lag_tracker *tracker)
+static int lag_active_port_bits(struct mlx5_lag *ldev,
+				struct lag_tracker *tracker)
 {
-	u8 enabled_ports[MLX5_MAX_PORTS] = {};
 	u8 active_port = 0;
+	u8 *enabled_ports;
 	int num_enabled;
 	int idx;
 
+	enabled_ports = kcalloc(ldev->ports, sizeof(*enabled_ports),
+				GFP_KERNEL);
+	if (!enabled_ports)
+		return -ENOMEM;
+
 	mlx5_infer_tx_enabled(tracker, ldev, enabled_ports,
 			      &num_enabled);
 	for (idx = 0; idx < num_enabled; idx++)
 		active_port |= BIT_MASK(enabled_ports[idx]);
 
+	kfree(enabled_ports);
 	return active_port;
 }
 
@@ -105,13 +111,21 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[idx0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[idx1]);
 		break;
-	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT:
+	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT: {
+		u8 active_port;
+		int ret;
+
 		if (!MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass))
 			break;
 
-		MLX5_SET(lagc, lag_ctx, active_port,
-			 lag_active_port_bits(ldev, tracker));
+		ret = lag_active_port_bits(ldev, tracker);
+		if (ret < 0)
+			return ret;
+
+		active_port = ret;
+		MLX5_SET(lagc, lag_ctx, active_port, active_port);
 		break;
+	}
 	default:
 		break;
 	}
@@ -240,22 +254,31 @@ static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
 				   struct lag_tracker *tracker,
 				   unsigned long flags)
 {
-	char buf[MLX5_MAX_PORTS * 10 + 1] = {};
-	u8 enabled_ports[MLX5_MAX_PORTS] = {};
+	u8 *enabled_ports = NULL;
 	int written = 0;
 	int num_enabled;
+	char *buf;
 	int idx;
 	int err;
 	int i;
 	int j;
 
+	buf = kcalloc(ldev->ports * 10 + 1, sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return;
+
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
+		enabled_ports = kcalloc(ldev->ports, sizeof(*enabled_ports),
+					GFP_KERNEL);
+		if (!enabled_ports)
+			goto free_buf;
+
 		mlx5_infer_tx_enabled(tracker, ldev, enabled_ports,
 				      &num_enabled);
 		for (i = 0; i < num_enabled; i++) {
 			err = scnprintf(buf + written, 4, "%d, ", enabled_ports[i] + 1);
 			if (err != 3)
-				return;
+				goto free_enabled;
 			written += err;
 		}
 		buf[written - 2] = 0;
@@ -267,12 +290,17 @@ static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
 				err = scnprintf(buf + written, 10,
 						" port %d:%d", i + 1, ldev->v2p_map[idx]);
 				if (err != 9)
-					return;
+					goto free_enabled;
 				written += err;
 			}
 		}
 		mlx5_core_info(dev, "lag map:%s\n", buf);
 	}
+
+free_enabled:
+	kfree(enabled_ports);
+free_buf:
+	kfree(buf);
 }
 
 static int mlx5_lag_netdev_event(struct notifier_block *this,
@@ -668,20 +696,28 @@ static bool __mlx5_lag_is_sd_active(struct mlx5_lag *ldev,
  * If there are ports that are disabled fill the relevant slots
  * with mapping that points to active ports.
  */
-static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
-					   struct mlx5_lag *ldev,
-					   u8 buckets,
-					   u8 *ports)
+static int mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
+					  struct mlx5_lag *ldev,
+					  u8 buckets,
+					  u8 *ports)
 {
-	int disabled[MLX5_MAX_PORTS] = {};
-	int enabled[MLX5_MAX_PORTS] = {};
 	int disabled_ports_num = 0;
 	int enabled_ports_num = 0;
+	int *disabled;
+	int *enabled;
+	int err = 0;
 	int idx;
 	u32 rand;
 	int i;
 	int j;
 
+	enabled = kcalloc(ldev->ports, sizeof(*enabled), GFP_KERNEL);
+	disabled = kcalloc(ldev->ports, sizeof(*disabled), GFP_KERNEL);
+	if (!enabled || !disabled) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	mlx5_ldev_for_each(i, 0, ldev) {
 		if (tracker->netdev_state[i].tx_enabled &&
 		    tracker->netdev_state[i].link_up)
@@ -704,7 +740,7 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 	/* If all ports are disabled/enabled keep native mapping */
 	if (enabled_ports_num == ldev->ports ||
 	    disabled_ports_num == ldev->ports)
-		return;
+		goto out;
 
 	/* Go over the disabled ports and for each assign a random active port */
 	for (i = 0; i < disabled_ports_num; i++) {
@@ -717,6 +753,11 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 				mlx5_lag_xa_to_dev_idx(ldev, rand_xa_idx) + 1;
 		}
 	}
+
+out:
+	kfree(enabled);
+	kfree(disabled);
+	return err;
 }
 
 static bool mlx5_lag_has_drop_rule(struct mlx5_lag *ldev)
@@ -816,7 +857,10 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
 		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
 			return ret;
 
-		active_ports = lag_active_port_bits(ldev, tracker);
+		ret = lag_active_port_bits(ldev, tracker);
+		if (ret < 0)
+			return ret;
+		active_ports = ret;
 
 		return mlx5_cmd_modify_active_port(dev0, active_ports);
 	}
@@ -879,7 +923,14 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 	if (!ports)
 		return;
 
-	mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets, ports);
+	err = mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets,
+					     ports);
+	if (err) {
+		mlx5_core_err(dev0,
+			      "mlx5_infer_tx_affinity_mapping failed, err = %d\n",
+			      err);
+		goto out;
+	}
 
 	mlx5_ldev_for_each(i, 0, ldev) {
 		for (j = 0; j < ldev->buckets; j++) {
@@ -1045,7 +1096,16 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		return err;
 
 	if (mode != MLX5_LAG_MODE_MPESW) {
-		mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets, ldev->v2p_map);
+		err = mlx5_infer_tx_affinity_mapping(tracker, ldev,
+						     ldev->buckets,
+						     ldev->v2p_map);
+		if (err) {
+			mlx5_core_err(dev0,
+				      "mlx5_infer_tx_affinity_mapping failed, err = %d\n",
+				      err);
+			return err;
+		}
+
 		if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
 			err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
 						       ldev->v2p_map);
-- 
2.44.0


Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA483C456F;
	Wed,  2 Sep 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377366; cv=fail; b=lOJH1AjDa6OSl1zx/+E/SRS8w9sXWoVhOuT+4yOorwgZNQZ0sedXWV+FUBl0ZXnDpuFUuJ5EaLHtJVf6QzDlt9DVGV2KFm9dnb4BD/U4Gyb/gUXGcKSWPRgeN/BFQkkSiOqWxEM+UIZpDUW6l1w32MesCesHRoT9+ZKapquPxk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377366; c=relaxed/simple;
	bh=2Hr+gMurbYm+zkm2jdTK1H7mnCk9k2DvD1QCClhWd78=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rt99GHqCw2JBBKnXgNCj888qpQ9IeXRl1QFAIyn1/iGGxxaOxHkkODlu9JaB1ooRwb5OCASOWYs4OMUYxvhrXNzWBU0swBp8k4Jw+EFU83J2IJIb4pgaaunZpUjrCRZEfQNby7AMLTphn0SFy7+ONmgQrNG28sOXaWogHV31TM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eY95jcn5; arc=fail smtp.client-ip=52.101.53.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eY95jcn5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEhQTxELSqwLLuvYRmuEAQM7bcCbgFpvE7P27LeCDOVBeHE6OSpXQmT/LS3RMY7pcHKhXpXpB30o3VZFwIlWUGPAG2HmjaSVOgSc4kzcLKdH7GIae2Gjl2KR9nSBnWpOk3UST92qunmGZt1rYBbINyTVDKB39gfDP8U+biR2dWIQCLnPfbTPwN6fIrREnfVhCOltf2MOvf+ds8BTOWzR350LSFuwyo/YQYhaWVVUe+j5OlToClr/c6BUXVcRobtr3EQDgbnmlk88mfv/F7TNmcpXSYoD7NK4mtmpDfbEikhid7jbGgRtlz4ivqMHp7PDPq6vH8WlQ+gViTsjQbH3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsjJyomjRk0V36PnoBRCxZZAaj9kdg4LYoraNZotRQ0=;
 b=I51BlvBNDBeE5gyQcCrJT1clqhQyBYkSWdVuyChx5q5v5KNwIl7kD56bqu1eeazsEjlql8WDSCa5nJMcwPzHPK+8WRvXpNbIZFbev0kbvZXEjQXHc+SkCIjw0uA/2TOfq1kfueyYqPT0Y/TFCM3w6/+ATjcva4PJzaGuWhVuMiqWFa1PVIRAAIPJfUbkXwG1uzfeBsn+gk/EshLvGG7lq6jDHAXmGUvSHHIhiOlVG3uj5SScVIEbUY5ScMuDZAfmIAQ3bsnyXaxCeKe4LL6ujx4u1ydsqPHa2lfJ+Gh96cSpku2WbB4oJQE8OepCOM3eSmFqQYFW9ESgHZTNJGPpMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsjJyomjRk0V36PnoBRCxZZAaj9kdg4LYoraNZotRQ0=;
 b=eY95jcn5jVQXbNjEkp2Z8efjCUd9zfCNtQOrHuhNJEs3d/Lt/GUiWntAv3FsQGYL09Au6NbEP5Hj9BkKTGgjyikQ6csyrEeIdzJkQhOV6u7tvLH7aoJduDR+Mgae0J8Mk0KvN6vB5yRU8ygSEDFfgggXni6QpENeUewqGeSsPL1iGI8Gda9aPnifPZlG7RpTk8bLuKTeuyIwkmwhrTRudp0hf+gyRjkkLcxyb/C5aM/KY8kS6Tl52OuVJadtaBslAkGc9BMUGnGH+Kqi2HXoX4gLDB6lU1KRJ7TpMDKpyy+gbXELlu0DtK2CVR6NV+xjF1zALDrH2rTdK8dqI5jOLA==
Received: from CH0PR03CA0069.namprd03.prod.outlook.com (2603:10b6:610:cc::14)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 19:29:00 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::41) by CH0PR03CA0069.outlook.office365.com
 (2603:10b6:610:cc::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 19:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:28:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:28:22 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:28:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 2 Sep
 2026 12:28:17 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, "Liu, Changcheng" <jerrliu@nvidia.com>, "Maher
 Sanalla" <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: LAG, use local tracker to update active ports
Date: Wed, 2 Sep 2026 22:27:40 +0300
Message-ID: <20260902192740.3665435-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|DS7PR12MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: 306dab5a-f07d-4f0f-8e0f-08df09287065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|7416014|23010399003|82310400026|6133799003|10067099003|56012099006|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Pq+KpWSQGufexfsMtju4EX72f6OicGVNuKnKFigoCIYABMViSkEHHjTjHpgI61xL5lX8XfkGApl7S2M/WdCKGKLV8mvojtY61tpulLRE/XWLtY3QgvcgeYPztkPsWoMk1xDtPftkCjK1I68Ldh4zzvLYXktk6viVGfJ2vyfbH1+1oOjoYOQkhNnVJ/PVOoNigBEKzB8T4dfQCxvKRtWhIrrHdHFSrVCWaq5K43a+dD3VKf2JeN3t5jwsN7uZ61nvPLO2Borv5NCAD6E4O8NWvz+E2TVD4OZZ2r3p9a2TLiw62CZXbM7Ei9KkXXecdEykFIoX5sR3lZjmMsLXRIIFOWhKfmWfI7Jbhz5pCQ2wAsK8N7xbytFjsfh6dXE67UQmbYlNoeeS2NkmxtPt7LpBDWZpniKzGEdelEya2qXy77axtMZsQ4DuqQvOT8hdLOTWDHQ8aN0LWyhNCgVXvtCxwkFUIzaGiErEzCtpyLx/svIpieKbMKsjSWLC+QBu25SWtO2M9RSNMItpVz65fIQrperXOpuFkgZNJc3Yw4CQvX4txYvGtJUJ2TLCm1OWQsJaT4dip8Z1JMeB150b2JQsZuqV62B3qnaipmriS9nsGsL40Z62P/EX7ol/ypfnBpYKO9zGJmmGqJV5ZKeoOt8uuOS99/zg3j7oDduWpUYi8NzQSlBMUl61RF9/Q45oSYQYgI4JrSBansuNtGQcGVhftg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(7416014)(23010399003)(82310400026)(6133799003)(10067099003)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VIzXe8fhS6Gp3/h+kKDgo/lhsXNDm61lJwM/dTRtvAYtYkjciDaszI99Jrqgia9P+9DJuSPXsoKm9TxzuO6glAQIhnXpmpYEw5h4Igba9PbaNwSaxsNdRSGGM1a0WgJidcZx+6joKsyjN3FVAqazDsmvsf7h5gSoS7exD+OjWzbJSY4FDNFLY2LYs2sE7jL/rSmhpVM7yvEswnOkbmCmnk39ohW9/JCZ8npWMQQne90hAKgyUoRhnwy1FBVBAaJDX8HJELGgnJ1XnfV3qFRa1/SGuH+PBhp0OzRW8D/JzsRoIC4l4fJ3wfTGyQ1IuiLUeqYaGFyjsE9WU8CggYn266mfGZxWXHtkKFpbkgOjdaS0Ff0EQKDohB4AQ4HfAGvXtlEIf2QyuMYm+YDTKTn96apektSqR68BJsHXcaSgwY0E3DekNp4nOamZEBIRiDdI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:28:59.7304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 306dab5a-f07d-4f0f-8e0f-08df09287065
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095

From: Akiva Goldberger <agoldberger@nvidia.com>

The CREATE_LAG command is handled asynchronously by queuing a work,
which stores a local copy of ldev->tracker. When the work is processed,
it is possible that the values of the local copy and ldev->tracker have
diverged.

A single CREATE_LAG command programs two related fields into the
firmware: the v2p (virtual-to-physical) map, which selects the physical
egress port for each hash bucket, and the active_port bitmask, which
tells the firmware which physical ports are currently up so it can
redirect QP/TIS away from inactive ports. For the firmware to steer
traffic correctly, both must be derived from the same view of the ports'
link state.

The v2p map is computed by mlx5_infer_tx_affinity_mapping() from the
local tracker snapshot, but lag_active_port_bits() called
mlx5_infer_tx_enabled() on the live ldev->tracker instead. If
ldev->tracker changed between the snapshot and command execution, the
two fields reflect different port states: the v2p map may steer a bucket
to a port that the active_port mask marks as inactive (or vice versa).
The firmware then receives a self-contradictory configuration and can
redirect or drop traffic on a port the mapping still points at, until a
later event happens to reconcile the state.

Update lag_active_port_bits so that it receives the local version of the
tracker from when the work was queued, effectively closing the window
for injecting an inconsistency.

Fixes: c5c13b456cb8 ("net/mlx5: Lag, set active ports if support bypass port select flow table")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 2285c889c215..c655f6e32e9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -63,14 +63,15 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
-static u8 lag_active_port_bits(struct mlx5_lag *ldev)
+static u8 lag_active_port_bits(struct mlx5_lag *ldev,
+			       struct lag_tracker *tracker)
 {
 	u8 enabled_ports[MLX5_MAX_PORTS] = {};
 	u8 active_port = 0;
 	int num_enabled;
 	int idx;
 
-	mlx5_infer_tx_enabled(&ldev->tracker, ldev, enabled_ports,
+	mlx5_infer_tx_enabled(tracker, ldev, enabled_ports,
 			      &num_enabled);
 	for (idx = 0; idx < num_enabled; idx++)
 		active_port |= BIT_MASK(enabled_ports[idx]);
@@ -79,7 +80,8 @@ static u8 lag_active_port_bits(struct mlx5_lag *ldev)
 }
 
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
-			       int mode, unsigned long flags)
+			       struct lag_tracker *tracker, int mode,
+			       unsigned long flags)
 {
 	bool fdb_sel_mode = test_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE,
 				     &flags);
@@ -108,7 +110,7 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
 			break;
 
 		MLX5_SET(lagc, lag_ctx, active_port,
-			 lag_active_port_bits(mlx5_lag_dev(dev)));
+			 lag_active_port_bits(ldev, tracker));
 		break;
 	default:
 		break;
@@ -787,7 +789,8 @@ static int mlx5_cmd_modify_active_port(struct mlx5_core_dev *dev, u8 ports)
 	return mlx5_cmd_exec_in(dev, modify_lag, in);
 }
 
-static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
+static int _mlx5_modify_lag(struct mlx5_lag *ldev,
+			    struct lag_tracker *tracker, u8 *ports)
 {
 	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
@@ -804,7 +807,7 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
 			return ret;
 
-		active_ports = lag_active_port_bits(ldev);
+		active_ports = lag_active_port_bits(ldev, tracker);
 
 		return mlx5_cmd_modify_active_port(dev0, active_ports);
 	}
@@ -868,7 +871,7 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 			idx = i * ldev->buckets + j;
 			if (ports[idx] == ldev->v2p_map[idx])
 				continue;
-			err = _mlx5_modify_lag(ldev, ports);
+			err = _mlx5_modify_lag(ldev, tracker, ports);
 			if (err) {
 				mlx5_core_err(dev0,
 					      "Failed to modify LAG (%d)\n",
@@ -976,7 +979,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, mlx5_get_str_port_sel_mode(mode, flags));
 
-	err = mlx5_cmd_create_lag(dev0, ldev, mode, flags);
+	err = mlx5_cmd_create_lag(dev0, ldev, tracker, mode, flags);
 	if (err) {
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
-- 
2.44.0


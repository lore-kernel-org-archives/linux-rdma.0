Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1296495030;
	Wed, 23 Sep 2026 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160047; cv=fail; b=lK4uqUTYQq/cCZ6u9B0sooaJrV9V8x2tVrBMCTvlLjstv0cRQE5lVwry/FsjM4m34WvsgLZxQP4DcXWWAtRy9QpHH3i27Ifm7Uc55ReyQVr1hIkNQmvqM8HcVympobr8z6UQeCQu7sQGi2413zeFx2FgYNiWcqwGJ3bSu09s9zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160047; c=relaxed/simple;
	bh=Ns/Vr4jq6m5cgyHixrzNZQb8uFpV/vrcspEzlIbvIqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s29jqNXMfu41UznAip5cAEE4iclRmKOXhnv9D1PVTktrqoRWmvwvEO/DKE9ZslXE2oBMBG7u0nfP774WOdJNNyo2A5H3kB3PHSUa6n3NdfyjS7XblQuJMCPEgMPVCu88+wf7j5SrsB/O+JvL73NOc1DhJReuAxSmNjqMs51zfYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N2dCxAL+; arc=fail smtp.client-ip=52.101.52.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N2dCxAL+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/Us5Sd7gbGErG+S/NFKJFlszmzYXOzLvU68pP+YFrdPN1PRPfHK6kom3Ao9cYxzpiEJGX+hR36LhQN+pw8iXoSEcZJ4YCgFJqlm2tFrH4Krt6EmT2fymDYO7ExqRLveOPa1tmeOisoxijolwLoPjy6ehC0bdOIGGiTdFKXmp+nnH2xfjT4OTYxosWg69htBQyV0MTr/ptbc25UQJkIG3Q8PBGqlGuBIs8w3NR5rmRCsYxnKy5CP8x7xQgTkvmT7RyTv/NlE7eMHJKFcE02OCyhfeiF6R/Qi7iPstn+ZXtA8VXoPAErhe0Mi3MMeZC2fBF7pmRU9S2r28FEOHorTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zB0MRrxSJBnHzBAOmQmC4oPHKO0rFjPjd6fxQsYAf6A=;
 b=eLLzexhWEHqR2YsOaZxj6zdTOUnMrNZsrMC2R148HKG3Alsxt1Dk3WJNTsG6ZJHI8NM5AmjI7YeGb1I0hHX2WaCc2QjzkFNPZFhQF+Ee4wNhVfj3OzpVEig7qCULpLfaBhV9DcORF6kgNTGJc9u4i1VkI912wCztZR7CLITrw0boyhfft35ovC3oiYFeqhwtbHcX0l5oXCA1TWySusA2Bf0hfWTEsucFuhYVdTblRhqH3/uLFME5z4wwp4VZXEHS6ZgEc5fA4Dkh7Q4SEPGCb/eevgDsaUXe+SZ0d0o3ZrH1tGOVA1zxq+qC/TEhiLR3L54aiw80jJOS3q+Aalk+Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zB0MRrxSJBnHzBAOmQmC4oPHKO0rFjPjd6fxQsYAf6A=;
 b=N2dCxAL+curgNj5CjjKd59GEh2IL+05BR5he4rUcwGGmgzZ61mbVq3IFl7OUmr6DYIEDhBp/hbWyhJpntP4n2kXM4hD4QyBdOwd3eEltL3i+nYSMwccuY6VfTQMf6dX4Y0D4Ng3qTorI6cqWSfK1XQzEupqmWs1sf0kiT+PqJPJH4GFEq8i1p8O1auV1smyl3mGqNZFdLvYBDpgFHJ7F3K/XMCS+n6CYaNtvvMvKKtgmc7iWC4ANPTVYTv2BSwEzlFrD4g93Pjr+tnx4v67/bpUbCCqBS8T/rHlLHXNIOS6Pw+FTN+UXmGSjUitAMTgox7Hdfp6km3GHQMhkSCwdPA==
Received: from DS7P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25c::13) by
 LV8PR12MB9111.namprd12.prod.outlook.com (2603:10b6:408:189::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:40:29 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:8:25c:cafe::7a) by DS7P221CA0026.outlook.office365.com
 (2603:10b6:8:25c::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Wed,
 23 Sep 2026 10:40:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:09 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:04 -0700
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
Subject: [PATCH net-next 03/13] net/mlx5: LAG, allocate v2p_map dynamically
Date: Wed, 23 Sep 2026 13:38:20 +0300
Message-ID: <20260923103830.1183-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|LV8PR12MB9111:EE_
X-MS-Office365-Filtering-Correlation-Id: b66c7632-e660-446b-592a-08df195f1584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	j/iSMDQNqcJqKwg5585GNGbq3pFeWSfvVspeaim5EjhZct/CcS7QJN5zSIbCyTUVXxSNHYyElFjcQBOFsgqhbW2ntMyCxh+/YBpMD3CS5xtBRCKLRYx+1bQdGR/ER3uUdLZk7caFg1BMv91vIvx/ngFlYvc0PVN1Oxwu8IWKJxqE+ELTktIBXo7dSO286VZxktvMjNCLh8ongc9IUtCo5/ZCmIjGKyccZuUcWIPn3/nn5CL1G9u6gJ8+qY89WVt541/N08AZQ7Fzo7CxFdCX/P1xiQ0tn7iOi1SW/X0qGtlP0IpAT+7nUz0qUXcrlsHylk8quPW/OD7lnxFKfzoZU+Q4/Og1jK6wIBiICrRt4wZimfwMqeLXHt59BzEoIjHQFKtlFLWzVz3kLlvqf8xc78lujhI/QuHI3ybOzwh4J0tZtj9tVA63mOsifMkguhVKWsc7yD8Lqr9CWhJWO5df/qfsLw7E6+/CRwhqCqWwZOsww8AIVwXqL1AyIoeCAmZGabjLEhjz1aaigeMyyPUvw95/s1Habjq6FcvwnQTsvxUUmndemmaIiz3dfF1dzWPydBOX9xiTQyOERb9aXdb9N/Ncz6ujOIx7OijOTYnDuUyOmDGtJjaJWXzsSjQhbXGSjcRjbtkE+4mlIrNFY9lNEYrMdbRExBjpxx+K6k5wY7zh25X4wxCLkReK6vCMOWRxmDqLUWumYlXw7vBsYxCyxw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Llj4Hjnw85zK7u9ywW92lWiXhFIarB1sxt3Gd88Nx8bRhuPF2PSH3MUSt0F+JnBfrTV0sWCmI0Jw789qisqhisJRqTDEerSk9OIqH4zNswMoSXWU16sLLq9K7mI+700xgrQ6W1ifoD4AIdlr2qdI5JHIe1oC2knTym4g0Ee7MbehxqZUutbGCQRwvP0RwiqShdPcxAAUwg0sStJE8mIXT0gULtzs2hbhLSOFZf18d1jWvXozQn+msxvncWcuPQgmudxsoX1xwC+nHyKvhIO6i+5KWyMlL+cOVNben5YyDG5QxZeTkb+oWG3hnZfbCKzd0vT1jjMetUv9tbTaWXOYoAOD7mCBm1GQgN4psr2esTw9D4sarmx0FOdAs7X7oZ+C3rF0QWOrXogdxW0AKUNJRIY5TSuwhPjrOIrELIQjQqeywJdsC94T1PjiWbc4C1z4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:28.1996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b66c7632-e660-446b-592a-08df195f1584
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9111

From: Shay Drory <shayd@nvidia.com>

v2p_map was a fixed array sized MLX5_MAX_PORTS *
MLX5_LAG_MAX_HASH_BUCKETS embedded in struct mlx5_lag. Turn it into a
pointer allocated in mlx5_lag_dev_alloc() once ldev->ports is known,
sized by the actual port count, and free it in mlx5_ldev_free(). The
ldev->ports / ldev->buckets initialization is moved up so the allocation
can use it.

The matching scratch buffer in mlx5_modify_lag() is converted from a
MLX5_MAX_PORTS-sized stack array to a kcalloc() of the same extent, with
the trailing teardown reworked through a goto so the buffer is freed on
every path. The memcpy() that previously relied on sizeof() of the stack
array now uses the explicit ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS
span.

No functional change; this removes v2p_map's dependency on
MLX5_MAX_PORTS.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 38 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  2 +-
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c655f6e32e9b..00b0159cb422 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -308,6 +308,7 @@ static void mlx5_ldev_free(struct kref *ref)
 	cancel_work_sync(&ldev->speed_update_work);
 	destroy_workqueue(ldev->wq);
 	mutex_destroy(&ldev->lock);
+	kfree(ldev->v2p_map);
 	kfree(ldev);
 }
 
@@ -330,11 +331,16 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return NULL;
 
+	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
+	ldev->buckets = 1;
+	ldev->v2p_map = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
+				sizeof(*ldev->v2p_map), GFP_KERNEL);
+	if (!ldev->v2p_map)
+		goto err_v2p_map;
+
 	ldev->wq = create_singlethread_workqueue("mlx5_lag");
-	if (!ldev->wq) {
-		kfree(ldev);
-		return NULL;
-	}
+	if (!ldev->wq)
+		goto err_wq;
 
 	kref_init(&ldev->ref);
 	mutex_init(&ldev->lock);
@@ -358,10 +364,13 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 
-	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
-	ldev->buckets = 1;
-
 	return ldev;
+
+err_wq:
+	kfree(ldev->v2p_map);
+err_v2p_map:
+	kfree(ldev);
+	return NULL;
 }
 
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
@@ -853,8 +862,8 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker)
 {
 	int first_idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
-	u8 ports[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS] = {};
 	struct mlx5_core_dev *dev0;
+	u8 *ports;
 	int idx;
 	int err;
 	int i;
@@ -864,6 +873,12 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		return;
 
 	dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
+
+	ports = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
+			sizeof(*ports), GFP_KERNEL);
+	if (!ports)
+		return;
+
 	mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets, ports);
 
 	mlx5_ldev_for_each(i, 0, ldev) {
@@ -876,9 +891,10 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 				mlx5_core_err(dev0,
 					      "Failed to modify LAG (%d)\n",
 					      err);
-				return;
+				goto out;
 			}
-			memcpy(ldev->v2p_map, ports, sizeof(ports));
+			memcpy(ldev->v2p_map, ports,
+			       ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS);
 
 			mlx5_lag_print_mapping(dev0, ldev, tracker,
 					       ldev->mode_flags);
@@ -899,6 +915,8 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 					     ndev);
 		dev_put(ndev);
 	}
+out:
+	kfree(ports);
 }
 
 static int mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index e9f0ef83ce1d..8552792b9035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -85,7 +85,7 @@ struct mlx5_lag {
 	u8			  ports;
 	u8			  buckets;
 	int			  mode_changes_in_progress;
-	u8			  v2p_map[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
+	u8			  *v2p_map;
 	struct kref               ref;
 	struct xarray             pfs;
 	struct lag_tracker        tracker;
-- 
2.44.0


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161674;
	b=cRA5+IlX2p4MqRVhOKSpc8ILnNOsOdZ+TNq051hWk1NCp7DthPT1U2Rn0Qb59E5CBnBf
	 PPsKpm7sp1Tp7+ZGnxx81USkGKLdVPo8vpC93r1K9hd1J/jHT3VjjFn9OKA/hDeOeiZ5t
	 Ow661Bh8yWqW1VSgP2ZePx3f1FlQt17yf1kXHa7cJP4UMG1UzxBUC1m7NyEPJGaCJcNoa
	 DenzEmCVBUA+adD6nPLqathB3tyiBC9KkVSeLW6ReMS031gB4UbJG3IMH5TGcnhT6CmXl
	 zIEb+jxW7V4H8o+KyyR0GIDTq8enegwQ+bh8cJiPzv6YZqlDrWWgg50sXSuzzG0mb3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161674;
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
	bh=5pJPaEGpg1UN6AxCkx/yBltWbuV2ugRT1bmFu/A0q8s=;
	b=U0odJE7Yj81xhsJr7g49bNMwvucf4LiVD8r2xKZLIxAQ+HyjzrcNWloMw6gRtxBAF8vG
	 pBqLP0bBih69THYkT5z8WfCC4LIKQ+sd3iNMym2aG04Rd23GPAldTBkm1ZeH+WkegdBRz
	 skVmvS5aSn30eH4fovJcTga51ZlFG3taCe0GGIYPbx9yTKDoqRir0oeX5StYsgeMXVW5n
	 9dJCwwscgWA6ZquW8kY8i6Q3pgf/RVvbfwOl9T+aR35A02nAyGj3j/P1+YQVXndlAcT3z
	 cO9+osBewglG/eoFkJ2JxIlH1jQUKANHlotl0y2UA10SX1x16iFXfbcWs6V4IarSO7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qtCe2i0m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.17
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A15606A325;
	Fri, 20 Nov 2026 08:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98A15606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qtCe2i0m
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGh/d7/eBDGRYCJks4ALHwFonNgHf2hgBu1JFgJ3si8K0aGGzUCdm6HC+5ns2C9tvhNeQNBiVi+fChxG1XTBsIxf+xCmJRz9hg0py5nIaB5YZM7Yw3YEHdl9sJsp6XZpnIrrxaQ4G5X9UdK5MYwVGuSzlGbe1h5twJ33hzPLRlWVIdoeehqGcvIglXjjwavH+1AqxIT7yparF9jvgwaeROvvXsJhQLPosgfhcr4p8rw8qmJ5mUpbVAtlPS8FCuXscUlPpAUHJ8I2HCN+GpZSnY5GKbUkNK6HkY4i3GaOTHmvUaUPMTSVqyCHXEpxBRk/JMRmpZJYCRZSgKr8RIfP4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pJPaEGpg1UN6AxCkx/yBltWbuV2ugRT1bmFu/A0q8s=;
 b=OMoSNoXex2WvJEtsiYweybQVZ5XZGDLkNi/piwDwTCRoWZk4fbeWTIf973vzejvbT5WDy09T1VjRJ/YDSSUgehcG9mya/Uq055DwgU2btRydXXPdA7ZZlmx62hsEW+8nKuD9TyfNhrqhOCPPuiFkI3cLon/QuWEbG7Pvp6wIWOdtWZVLS0Jj8OnJv2Gp0XH1H047LwPbKMzesYJym8jJXRSYXafJOhQl3yCxz52emD8Z0xN2nXzu4vHmCSktDGqPxrpGIcbyUwxlxlS413s/q9+i6ncvUJ9W+vJgwGqUn0sRLKQDoG3SqAE6WWLkrP4yy9TcCoV5KAIDod8wShvMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pJPaEGpg1UN6AxCkx/yBltWbuV2ugRT1bmFu/A0q8s=;
 b=qtCe2i0mHAh9EwScu00eEjDBbGEPOwD2aQjD0NO2LseuW8uGcYtA0l/MTloEw1E+ry3o7AnJhNfHcfXTeMN2jeT2xGkX+qV/znrbY5AzTnCD45piO8cxyjEbq7sshjIDMRWGp1sLPRkW3EsPDfwTD1vIBbVKeO9E7JoltkGteRk0dQYVZVLvXMRfGEVw+oPzDJe24kBN6MEehFS4v0bo4f+jxFvmQ5xOj2AWJ3FZV/45EHM9UwdWJSFLtEb4D3eBLMqg7YatAPU9SqaODBE5Us78V7fSWoJr5hTDbR9UdYEsRUotuEo92zgOrLOqr33JXXSyiFNjwXmR6yFoy+Y6lw==
Received: from BN9PR03CA0685.namprd03.prod.outlook.com (2603:10b6:408:10e::30)
 by BN5PR12MB9512.namprd12.prod.outlook.com (2603:10b6:408:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 08:01:06 +0000
Received: from BN1PEPF00018549.namprd05.prod.outlook.com
 (2603:10b6:408:10e:cafe::26) by BN9PR03CA0685.outlook.office365.com
 (2603:10b6:408:10e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:01:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018549.mail.protection.outlook.com (10.167.248.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:01:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:46 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:41 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 5/5] net/mlx5: LAG, enable LAG over functions that do not represent a physical port
Date: Fri, 20 Nov 2026 09:59:58 +0200
Message-ID: <20261120075959.2533702-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018549:EE_|BN5PR12MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: 66cc1413-f906-4a9f-341f-08df46dc6dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|18002099003|22082099003|6133799003|11063799006|56012099006|261021123027099003|261026140227099003|261021121427099003|261028144727099003|10067099003|261102123227099003|261026121527099003|261102130727099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	PL4KxLlW8UH8QDDbSC3ZSj4HqslRzw4FQe63TJWNkCmKwL789kM2OmsqxRA/yVDe5HeTE4QPD8g97wZQAVfTByUP+YUIfW1sLX9SkYSTWc04xtDOTg+FlpeUFI3PsPJePt92bKLtE1OtaSz1cTbsOqqhzaqZVxDuHCJg1fjdBBx1GN1x/uZZbVlX4LhsqNVwnOB1YEH3WcOB9LE2e/Q64kWwzLZuHXMrkppdo5eGImBi/OfaFn01RM1ppllPbXoCGyuk1U63s4RecS0btRDV68r8Utr+QkqmTflvfuKuhXTGO833pMBoA/bSP7CQDnWegLqxKGkY6COsQSo0sd8xFQ2d4hOtnR6W97QT1h0pXaOvv/kqoKjOmul6fN8ZXOBAikffkZVrJSeSxfD54yMFdH1DPTj38D/55hekXq1b1vAkbiGA92N6Ar43s/Z5aeJItC1KIDhbwAP7Y/vuB2ZNG8JZMm23BChj5r3KNg72AVMEA6LSs5nTmp6033Qdubc4NV7QQfEBxOxgYX/clxR2WX1zNzxybnvyXJQzzIlKaXBIFFnXhvM9hYKUxK38x+Ww5Ai5Nr1zw61YkRjO5bouG5jiGiimHIJEEsR1Uo/vru4Cuz4W4wkKMTreE9wP4hToBrvXkXQoy06zoDPH7amyUM9mlszIYEgE0+btFGMvMwuT0n+bjnMSA//V33n0bi/U/VhBtIAINt02shhF+XIlaw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(11063799006)(56012099006)(261021123027099003)(261026140227099003)(261021121427099003)(261028144727099003)(10067099003)(261102123227099003)(261026121527099003)(261102130727099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cwTkECYAUqSuz+6OxHyrIkdI3pWJuXdRR5kvaXmQ6IKRaPKGKh1YqZML+Ugmtjd5iumgRdLIzcobwZHe9qZNBdQvF6h/B6gJZxXmDaIc60lzl4ce+R6vpv4DfDfiAPNiRaAVlAKsE7p4bb2UMQiAjNXJ2L8Q9NImXx+apdi3bvkzEgfyV4i3v8zsiffrLqU2gpNkfN5GEYbQNL7CrYPTtHe6WLjyETPRGDfGFxAv9wmeBkOrziHO4QAAVdltLgO7WIUhIuLu7pFpFdagcPueIPbjGpQQWiL+l11ue+T4Y8BYAOamsuH8w4o712yceEnDoKt+TsvNRGBe6btTcEpEJm8oJprKXsk55M6BURC+q2qdcyTGxzlJbEZf5esfuF7I4cYQ2Dr4XcqjRosfNHAXWU+iAsLr5lDrj13SWqHxDtYV1qVHf7sBdZdSLQvFy58W
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:01:05.6775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cc1413-f906-4a9f-341f-08df46dc6dc8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018549.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9512

From: Shay Drory <shayd@nvidia.com>

LAG membership assumes every member represents a physical port.
A nested LAG of VFs/SFs does not fit that assumption; its member
functions sit behind a multi_uplink_eswitch and each reports
num_lag_ports < 2, so they do not represent a physical port.

Detect this with mlx5_virt_lag_is_supported(): let such a function join
the LAG in mlx5_lag_add_mdev(), and skip the MLX5_LAG_XA_MARK_PORT mark
and the PORT_CHANGE event notifier in mlx5_ldev_add_mdev(), since it is
not a physical port.

These function only support MPESW, and netdevs addition to LAG is only
needed for linux bond. Hence, don't allow such a lag to add netdevs to
itself. For the same reason, don't register the LAG netdev notifier for
it. Multipath LAG is not supported either, so skip mlx5_lag_mp_init()
and do not register the FIB notifier for it.

Such a function may report num_lag_ports == 0, which ldev->ports keeps
as is. Report at least one port from mlx5_lag_get_num_ports(), so user
would avoid divide by 0.

Such a function selects the uplink through port_select_eswitch, not
through a TX port affinity. Yet once its LAG is active, RDMA sets
lag_active, and mlx5_ib_lag_should_assign_affinity() then assigns a TX
port affinity to every QP, bypassing the num_lag_ports > 1 and
lag_tx_port_affinity capability checks. Make
mlx5_ib_lag_should_assign_affinity() return false for such a function.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 ++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 32 +++++++++++++------
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d..494b7036321b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1612,6 +1612,9 @@ static inline void mlx5r_deref_wait_odp_mkey(struct mlx5_ib_mkey *mmkey)
 
 static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 {
+	if (dev->lag_active && mlx5_virt_lag_is_supported(dev->mdev))
+		return 0;
+
 	/*
 	 * If the driver is in hash mode and the port_select_flow_table_bypass cap
 	 * is supported, it means that the driver no longer needs to assign the port
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 193fbe47fef1..2cd2319f9318 100644
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
@@ -392,10 +393,13 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	}
 	ldev->mode = MLX5_LAG_MODE_NONE;
 
-	err = mlx5_lag_mp_init(ldev);
-	if (err)
-		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
-			      err);
+	if (!ldev->virt_lag) {
+		err = mlx5_lag_mp_init(ldev);
+		if (err)
+			mlx5_core_err(dev,
+				      "Failed to init multipath lag err=%d\n",
+				      err);
+	}
 
 	ldev->max_fns = ldev->ports;
 	return ldev;
@@ -468,7 +472,9 @@ int mlx5_lag_get_dev_index_by_seq(struct mlx5_lag *ldev, int seq)
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
@@ -476,7 +482,7 @@ static u32 mlx5_lag_get_filter(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 
 	if (fn && fn->sd_fdb_active)
 		return fn->group_id;
-	if (fn && fn->group_id)
+	if (fn && (fn->group_id || ldev->virt_lag))
 		return MLX5_LAG_FILTER_ALL;
 	return MLX5_LAG_FILTER_PORTS;
 }
@@ -2398,7 +2404,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 	fn->group_id = group_id;
 	dev->priv.lag = ldev;
 
-	if (group_id)
+	if (group_id || ldev->virt_lag)
 		return 0;
 
 	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);
@@ -2547,7 +2553,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
 	int err;
 
-	if (!mlx5_lag_is_supported(dev))
+	if (!mlx5_lag_is_supported(dev) && !mlx5_virt_lag_is_supported(dev))
 		return;
 
 	if (mlx5_lag_register_hca_devcom_comp(dev))
@@ -2582,6 +2588,9 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
+	if (ldev->virt_lag)
+		return;
+
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_remove_netdev(ldev, netdev);
 	clear_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
@@ -2603,6 +2612,9 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
+	if (ldev->virt_lag)
+		return;
+
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_add_netdev(ldev, dev, netdev);
 	num = mlx5_lag_num_netdevs(ldev);
@@ -2886,7 +2898,7 @@ u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return 0;
 
-	return ldev->ports;
+	return max_t(u8, ldev->ports, 1);
 }
 EXPORT_SYMBOL(mlx5_lag_get_num_ports);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 2d3e61541d8a..0ef2d13d0096 100644
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


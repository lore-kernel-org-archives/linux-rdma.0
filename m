Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817165;
	b=dlE11Sb7PksiJ6EGk1ZOAYmFtkffuf90P8m2m6uZpdR7aPs24rdIKW6E1behvhk6JomJ
	 TgzfdWr7uZ5loXLl6QSS3YjUb9cp1l32ZqwmWKvrDmOJgOrRLB4lF0ZNkVzd9An+bg6A4
	 8qs/6lqKt96MwVE3Rplz5bKZUfY6GfMQ49ti+yUQrD5MKbm4ylvDXoAE3h8RuhEcvHHTs
	 8qLHjgR9JMH5CByu7ESTgKKsknvPFT2HkXVel4iU2QFVo9321oLcrKlBZ6bem893COg4G
	 1Pc5LpAUNFFRrVbcGyeVDqcbDqcqUr92TYOxvmjF6hApv/H6U/HpngYSodmUfA5SjZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817165;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jPBijhvONwOBJ6KZ95naT9Lv1p2pj6wx1e7i5DR2OFE=;
	b=WGBXNBLhpcbK68lrbpBcZFZbFwe/YhH+WNHTOe5mBPcFl6PzUGYL3/GRaaDmuNASosuJ
	 n0kbKLLkRyrQ/fshah6BFExk8NdseTgHnoZk5Bv9ibKigDWZ5AubB5ujzF7r4j06Nf5h9
	 xRbm2Er9zFGhRUR8h80eyVbYdAHDCYbZciH2mu4DloX4Q/bLRcY7oyp5wCHemqdh/gIWG
	 nBt5HNQ3vk3sGGeqJ3WhSAC/pbT8GCz9aaXKF3MRTCPndCrlDDibCaduOoLCRWe5oFK/7
	 y8DBJ6YrNsiCoU/HYiy1h8URo0y7PIpQXHKsVDJfuc9W/vD9e42MoMXN8qRtrDZWgww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tshsq3lo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E03606A328;
	Wed,  4 Nov 2026 18:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45E03606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tshsq3lo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZJUnDhCHSdAYrFZDA0yyTNVyna0lyceMc+mGcNrmVYSnnn8ZbA6o6fHpDyBDYeTORGZYAqn9qXK7oH8Mk+lHd+ksdpu7sjv5xkyo6fopteE+BtZ1RFiPSCHtZtUbpFfUjkDi53HyMR6WPKNB8gr3NEU193NLVDoxs9K2XvANjQ5uipB5Z5HqmjCcb/IScieS+f+FZyxe+oHmeLBiFpcz7qRwub2CZpOFANXaPb5cuZyJBBiUnGTC41lTUonjm9TidqbtlkKNf15bpbbbrfBAFr46uJJTLwtlv/CKKp+I1rVXJXOKDtOuzRY9NYXxV1gHRZHWdujje/8M+fuHPMo5yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPBijhvONwOBJ6KZ95naT9Lv1p2pj6wx1e7i5DR2OFE=;
 b=oOLdSYoZuc1+tfw8lL9ICacMLsXQEexUTevzS5Amo6dvEPkOJV7UzHUik5j261G/txMLJgZdwT+A/6m11IAvby7974SPe7Gd1TCDIMC+wOBjhRU6GZpJ0IUfo+ypO6tDRSgumtVGmgHO8iO8DbkPS48aVUmSRQ+W+t2MJfMXZT5f5+73jF7U1MS6O4rAs6gu892KjLOHD0AULGgTfuKthkrp0eFUJufX3eN2fA1Uh1mchYyhkul0WaLMGMAS35uOSHLllSka8NzIgHRgnUx69AUsKJt5EiV0dazsLybMw/9SERVXyWo1bj+UbhCMIDjkzf7h6EN8vkX2TLRNJcj1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPBijhvONwOBJ6KZ95naT9Lv1p2pj6wx1e7i5DR2OFE=;
 b=Tshsq3loQsJr3GLC+aNVs7Y5uvjeruUbVAhndPLLgh6ZnlJDHq9BEZfArvnh0/CiyQG5bXVW+niZwc6vsAeEDHL3NdSNzId6p9DQiW+SKHS6sV8/o4DB0yO9QqCBaBT0wjiwSoCxYy6M6hJIqSkMOfL1d2oVWp8tLPCJSQF5KJYLv4n0pRgdrTQ2oEtEJ5Q+M6a+W/Vbygu4bA5uiLoon4I01A/YQr2324w1/IJhtOYZMrEhpAmMOgXJtpZym7Lgno/npwkflEEcUkMYmxY/MOE4EsEYcowQHuq3nWoA24e9ZeZenOWX259EYqlQbhYLxMmDcrx5rQIcOCXWLkBqKw==
Received: from PH7P220CA0131.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:327::33)
 by MN0PR12MB6200.namprd12.prod.outlook.com (2603:10b6:208:3c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 18:32:36 +0000
Received: from SJ1PEPF000037A3.namprd04.prod.outlook.com
 (2603:10b6:510:327:cafe::52) by PH7P220CA0131.outlook.office365.com
 (2603:10b6:510:327::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 18:32:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000037A3.mail.protection.outlook.com (10.167.244.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 18:32:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:32:13 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 10:32:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 10:32:08 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@mellanox.com>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shahar
 Shitrit" <shshitrit@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH net V2] net/mlx5: Use only loaded devices for PTP clock operations
Date: Wed, 4 Nov 2026 20:31:58 +0200
Message-ID: <20261104183158.758314-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A3:EE_|MN0PR12MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b0fd58-55d9-4d62-72fc-08df3aa1ff0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|1800799024|376014|36860700016|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261021123027099003|261028144727099003|261026140227099003|11063799006|56012099006|261102123227099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Ou8lMbHoZG4kv0g2l6nvYZ9ulnyXcxjoaZ9RBDeL6o3L5UzKzV+bTTSzbg0MMM51hGQGOpd1nkwYaeuM2aY8Fvr+IEEbXTEroTXneVmOfWRaLhGvDfM3/e4ZznOz+s9q6Lc7DFfV9ncXQoJHeCN0NPMgEsLFVxn+hFRao+tw6hYB1AlfFiMny+yTPjLL/9I1e+1gF6JgJXfjtcBj3QdF+w7DUF8cf+tdX7WlH25Pn9kw6AZ/QbG+hK3vlF1JFAcWzhjEX1AcSwstsaCONbvgdg3d6BWU8dInM345xwxHBh2prnGYxTJG88VXbqvMpK5jEgzOnT0lc89UPn8QZmvWIREoEoXYEsB7EQNpxDZ1ne2Jwlr4aOBL3iVX//0MDlIRqc0g9vi0xKNq0boKisRYfVCGWiMKBc4pgL4kyChh20Q1MuG8HFxeoaanU3mX4d9XgldH8KDnuQHroyRuwq5N1Ngwhmm55k27zGk9Z+1mt7FvnH+mxg1WieIFervMY4NODyS48x0EOmk8GpePkBXpE/sQ4W/+F5KQvLAKNMEttOOs7pP0yy9ezJYgkJrRpLO9wlH9KGCni0W4RuqteRFKG1GJLUUGYRaKTUBJdh7ej1kUTPY58kouxxzQcWfJCi8hjW2wtWhywyTmBcg0Q5mIG1tajf+5J4O8a1FEw8yso756hVJfW3Pyi7TCZEXP8iZPc5t0tKl2B7yMjRfHdMzGBQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(1800799024)(376014)(36860700016)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261021123027099003)(261028144727099003)(261026140227099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vfRCPZDy+MzGakDJLaXiJXi1Ka1QGdK8LvPspu9gPmiZ/AP8EvLl/Z44xj5CO62iozFl8e/MCTDh36TOh83crEN+GVkdJZpbwiEuvjWJjbPk+gsbaORQvixDuyWQxzHoBHfX9+FnVx3FkcaKn81C5we1t8mbB0D4E0WWsHQZ8TPlpUH0Dd9+cvaABkTnH/akP/qrFvEv50CVg1eqng8089iy8IL+9LgCc1qypv9B9ZAB4sh4UCpUXk3IuZTz0P4hC50s2KwB+/OQXnDbZ2gfZO4LkR6xRbE9KHR++HEEmkQbGaFPEqYD2gKOcoapB/1CElAIhXekfuBVLobZoe2JGz4ectHp6L715j8/KFSuiG9JBfpCk6FHgkZ6Cobxip/4DxeYtPo52CZrXTHIsm3BdQONys8JZaOwP6E7Ur5pb9pdetNxqST4xxSNcTz8nt/B
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 18:32:35.3063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b0fd58-55d9-4d62-72fc-08df3aa1ff0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6200

From: Carolina Jubran <cjubran@nvidia.com>

The PTP periodic worker and PTP operations access PCI registers through
the function backing the PTP clock. The PTP clock remains registered
when a PCI function is suspended, so these paths can still access the
function after it has been unloaded.

To fix that, serialize clock hardware access with the clock mutex for
all clocks and fail callbacks with -EAGAIN when there is no loaded
function to service the clock. Additionally, tie the worker's lifetime
to load/unload and use the devcom lock to synchronize with peer
loads/unloads.

Since the periodic worker is stopped during unload, the free running
counter may wrap without being sampled. Reinitialize the timecounter
on load using the hardware real time clock in real time mode, or the
saved PHC time plus elapsed CLOCK_BOOTTIME in free running mode.

This provides best effort PHC continuity across unload/load. In free
running mode, elapsed time while unloaded is estimated using
CLOCK_BOOTTIME rather than the PHC's adjusted frequency.

Fixes: 8fc3e29be924 ("net/mlx5: Fix crash upon suspend/resume")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 248 +++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |   2 +
 2 files changed, 185 insertions(+), 65 deletions(-)

V2:
- Update commit message.

V1:
https://lore.kernel.org/all/20261021105600.3481485-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 5df786133e4b..c3e53d219496 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -80,6 +80,7 @@ enum {
 };
 
 struct mlx5_clock_dev_state {
+	bool loaded;
 	struct mlx5_core_dev *mdev;
 	struct mlx5_devcom_comp_dev *compdev;
 	struct mlx5_nb pps_nb;
@@ -89,7 +90,7 @@ struct mlx5_clock_dev_state {
 struct mlx5_clock_priv {
 	struct mlx5_clock clock;
 	struct mlx5_core_dev *mdev;
-	struct mutex lock; /* protect mdev and used in PTP callbacks */
+	struct mutex lock; /* protect mdev and serialize hardware callbacks */
 	struct mlx5_core_dev *event_mdev;
 };
 
@@ -100,9 +101,6 @@ static struct mlx5_clock_priv *clock_priv(struct mlx5_clock *clock)
 
 static void mlx5_clock_lockdep_assert(struct mlx5_clock *clock)
 {
-	if (!clock->shared)
-		return;
-
 	lockdep_assert(lockdep_is_held(&clock_priv(clock)->lock));
 }
 
@@ -115,20 +113,24 @@ static struct mlx5_core_dev *mlx5_clock_mdev_get(struct mlx5_clock *clock)
 
 static void mlx5_clock_lock(struct mlx5_clock *clock)
 {
-	if (!clock->shared)
-		return;
-
 	mutex_lock(&clock_priv(clock)->lock);
 }
 
 static void mlx5_clock_unlock(struct mlx5_clock *clock)
 {
-	if (!clock->shared)
-		return;
-
 	mutex_unlock(&clock_priv(clock)->lock);
 }
 
+static struct mlx5_core_dev *
+mlx5_clock_active_mdev_get(struct mlx5_clock *clock)
+{
+	struct mlx5_clock_priv *cpriv = clock_priv(clock);
+
+	mlx5_clock_lockdep_assert(clock);
+
+	return cpriv->mdev->clock_state->loaded ? cpriv->mdev : NULL;
+}
+
 static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
 {
 	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
@@ -333,7 +335,11 @@ static int mlx5_ptp_getcrosststamp(struct ptp_clock_info *ptp,
 	int err;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	if (!mlx5_is_ptm_source_time_available(mdev)) {
 		err = -EBUSY;
@@ -359,7 +365,11 @@ static int mlx5_ptp_getcrosscycles(struct ptp_clock_info *ptp,
 	int err;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	if (!mlx5_is_ptm_source_time_available(mdev)) {
 		err = -EBUSY;
@@ -411,6 +421,12 @@ static u64 read_internal_timer(struct cyclecounter *cc)
 	return mlx5_read_time(mdev, NULL, false) & cc->mask;
 }
 
+static void mlx5_timer_snapshot(struct mlx5_timer *timer)
+{
+	timer->saved_phc_ns = timer->tc.nsec;
+	timer->saved_boot_ns = ktime_get_boottime_ns();
+}
+
 static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
@@ -418,6 +434,9 @@ static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
 	struct mlx5_timer *timer;
 	u32 sign;
 
+	timer = &clock->timer;
+	mlx5_timer_snapshot(timer);
+
 	if (!clock_info)
 		return;
 
@@ -425,7 +444,6 @@ static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
 	smp_store_mb(clock_info->sign,
 		     sign | MLX5_IB_CLOCK_INFO_KERNEL_UPDATING);
 
-	timer = &clock->timer;
 	clock_info->cycles = timer->tc.cycle_last;
 	clock_info->mult   = timer->cycles.mult;
 	clock_info->nsec   = timer->tc.nsec;
@@ -471,10 +489,9 @@ static long mlx5_timestamp_overflow(struct ptp_clock_info *ptp_info)
 
 	clock = container_of(ptp_info, struct mlx5_clock, ptp_info);
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
 	timer = &clock->timer;
-
-	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+	if (!mdev || mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto out;
 
 	write_seqlock_irqsave(&clock->lock, flags);
@@ -531,8 +548,13 @@ static int mlx5_ptp_settime(struct ptp_clock_info *ptp, const struct timespec64
 	int err;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 	err = mlx5_clock_settime(mdev, clock, ts);
+unlock:
 	mlx5_clock_unlock(clock);
 
 	return err;
@@ -550,26 +572,40 @@ struct timespec64 mlx5_ptp_gettimex_real_time(struct mlx5_core_dev *mdev,
 	return ts;
 }
 
-static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
-			     struct ptp_system_timestamp *sts)
+static void mlx5_clock_gettimex(struct mlx5_core_dev *mdev,
+				struct mlx5_clock *clock, struct timespec64 *ts,
+				struct ptp_system_timestamp *sts)
 {
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
-	struct mlx5_core_dev *mdev;
 	u64 cycles, ns;
 
-	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
 	if (mlx5_real_time_mode(mdev)) {
 		*ts = mlx5_ptp_gettimex_real_time(mdev, sts);
-		goto out;
+		return;
 	}
 
 	cycles = mlx5_read_time(mdev, sts, false);
 	ns = mlx5_timecounter_cyc2time(clock, cycles);
 	*ts = ns_to_timespec64(ns);
-out:
+}
+
+static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			     struct ptp_system_timestamp *sts)
+{
+	struct mlx5_clock *clock =
+		container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
+	int err = 0;
+
+	mlx5_clock_lock(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
+	mlx5_clock_gettimex(mdev, clock, ts, sts);
+unlock:
 	mlx5_clock_unlock(clock);
-	return 0;
+	return err;
 }
 
 static int mlx5_ptp_getcyclesx(struct ptp_clock_info *ptp,
@@ -580,14 +616,20 @@ static int mlx5_ptp_getcyclesx(struct ptp_clock_info *ptp,
 						ptp_info);
 	struct mlx5_core_dev *mdev;
 	u64 cycles;
+	int err = 0;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	cycles = mlx5_read_time(mdev, sts, false);
 	*ts = ns_to_timespec64(cycles);
+unlock:
 	mlx5_clock_unlock(clock);
-	return 0;
+	return err;
 }
 
 static int mlx5_ptp_adjtime_real_time(struct mlx5_core_dev *mdev, s64 delta)
@@ -620,7 +662,11 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	int err = 0;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	if (mlx5_modify_mtutc_allowed(mdev)) {
 		err = mlx5_ptp_adjtime_real_time(mdev, delta);
@@ -630,6 +676,7 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	}
 
 	write_seqlock_irqsave(&clock->lock, flags);
+	timecounter_read(&timer->tc);
 	timecounter_adjtime(&timer->tc, delta);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
@@ -646,8 +693,13 @@ static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
 	int err;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 	err = mlx5_ptp_adjtime_real_time(mdev, delta);
+unlock:
 	mlx5_clock_unlock(clock);
 
 	return err;
@@ -683,7 +735,11 @@ static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	u32 mult;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	if (mlx5_modify_mtutc_allowed(mdev)) {
 		err = mlx5_ptp_freq_adj_real_time(mdev, scaled_ppm);
@@ -744,7 +800,11 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	}
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 
 	if (!MLX5_PPS_CAP(mdev)) {
 		err = -EOPNOTSUPP;
@@ -917,7 +977,11 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		return -EBUSY;
 
 	mlx5_clock_lock(clock);
-	mdev = mlx5_clock_mdev_get(clock);
+	mdev = mlx5_clock_active_mdev_get(clock);
+	if (!mdev) {
+		err = -EAGAIN;
+		goto unlock;
+	}
 	rt_mode = mlx5_real_time_mode(mdev);
 
 	if (!MLX5_PPS_CAP(mdev)) {
@@ -1151,7 +1215,7 @@ static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
 	struct timespec64 ts;
 	s64 target_ns;
 
-	mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
+	mlx5_clock_gettimex(mdev, clock, &ts, NULL);
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
@@ -1222,8 +1286,8 @@ static void mlx5_timecounter_init(struct mlx5_core_dev *mdev)
 	timer->nominal_c_mult = timer->cycles.mult;
 	timer->cycles.mask = CLOCKSOURCE_MASK(41);
 
-	timecounter_init(&timer->tc, &timer->cycles,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&timer->tc, &timer->cycles, ktime_get_real_ns());
+	mlx5_timer_snapshot(timer);
 }
 
 static void mlx5_init_overflow_period(struct mlx5_core_dev *mdev)
@@ -1381,9 +1445,6 @@ static void mlx5_init_clock_dev(struct mlx5_core_dev *mdev)
 			       clock->ptp);
 		clock->ptp = NULL;
 	}
-
-	if (clock->ptp)
-		ptp_schedule_worker(clock->ptp, 0);
 }
 
 static void mlx5_destroy_clock_dev(struct mlx5_core_dev *mdev)
@@ -1530,22 +1591,53 @@ static void mlx5_clock_arm_pps_in_event(struct mlx5_clock *clock,
 		    !clock->pps_info.pin_armed[i])
 			continue;
 
-		if (new_mdev) {
+		if (new_mdev)
 			mlx5_set_mtppse(new_mdev, i, 0, MLX5_EVENT_MODE_REPETETIVE);
-			cpriv->event_mdev = new_mdev;
-		} else {
-			cpriv->event_mdev = NULL;
-		}
 
 		if (old_mdev)
 			mlx5_set_mtppse(old_mdev, i, 0, MLX5_EVENT_MODE_DISABLE);
 	}
+	cpriv->event_mdev = new_mdev;
+}
+
+static void mlx5_set_timecounter(struct mlx5_core_dev *mdev, u64 ns)
+{
+	struct mlx5_clock *clock = mdev->clock;
+	struct mlx5_timer *timer;
+	unsigned long flags;
+
+	timer = &clock->timer;
+	mlx5_clock_lockdep_assert(clock);
+
+	write_seqlock_irqsave(&clock->lock, flags);
+	timecounter_init(&timer->tc, &timer->cycles, ns);
+	mlx5_update_clock_info_page(mdev);
+	write_sequnlock_irqrestore(&clock->lock, flags);
+}
+
+static void mlx5_save_timecounter(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = mdev->clock;
+	struct mlx5_timer *timer;
+	unsigned long flags;
+
+	timer = &clock->timer;
+	mlx5_clock_lockdep_assert(clock);
+
+	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		return;
+
+	write_seqlock_irqsave(&clock->lock, flags);
+	timecounter_read(&timer->tc);
+	mlx5_update_clock_info_page(mdev);
+	write_sequnlock_irqrestore(&clock->lock, flags);
 }
 
 void mlx5_clock_load(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = mdev->clock;
 	struct mlx5_clock_priv *cpriv;
+	bool start;
 
 	if (!MLX5_CAP_GEN(mdev, device_frequency_khz))
 		return;
@@ -1554,18 +1646,32 @@ void mlx5_clock_load(struct mlx5_core_dev *mdev)
 	MLX5_NB_INIT(&mdev->clock_state->pps_nb, mlx5_pps_event, PPS_EVENT);
 	mlx5_eq_notifier_register(mdev, &mdev->clock_state->pps_nb);
 
-	if (!clock->shared) {
-		mlx5_clock_arm_pps_in_event(clock, mdev, NULL);
-		return;
-	}
-
 	cpriv = clock_priv(clock);
-	mlx5_devcom_comp_lock(mdev->clock_state->compdev);
+	if (clock->shared)
+		mlx5_devcom_comp_lock(mdev->clock_state->compdev);
 	mlx5_clock_lock(clock);
-	if (mdev == cpriv->mdev && mdev != cpriv->event_mdev)
+	start = !cpriv->mdev->clock_state->loaded;
+	mdev->clock_state->loaded = true;
+	if (start) {
+		struct mlx5_timer *timer = &clock->timer;
+		u64 ns;
+
+		cpriv->mdev = mdev;
+		if (mlx5_real_time_mode(mdev))
+			ns = mlx5_read_time(mdev, NULL, true);
+		else
+			ns = timer->saved_phc_ns +
+			     ktime_get_boottime_ns() - timer->saved_boot_ns;
+
+		mlx5_set_timecounter(mdev, ns);
 		mlx5_clock_arm_pps_in_event(clock, mdev, cpriv->event_mdev);
+	}
 	mlx5_clock_unlock(clock);
-	mlx5_devcom_comp_unlock(mdev->clock_state->compdev);
+
+	if (start && clock->ptp)
+		ptp_schedule_worker(clock->ptp, 0);
+	if (clock->shared)
+		mlx5_devcom_comp_unlock(mdev->clock_state->compdev);
 }
 
 void mlx5_clock_unload(struct mlx5_core_dev *mdev)
@@ -1573,30 +1679,42 @@ void mlx5_clock_unload(struct mlx5_core_dev *mdev)
 	struct mlx5_core_dev *peer_dev, *next = NULL;
 	struct mlx5_clock *clock = mdev->clock;
 	struct mlx5_devcom_comp_dev *pos;
+	struct mlx5_clock_priv *cpriv;
+	bool stop;
 
 	if (!MLX5_CAP_GEN(mdev, device_frequency_khz))
 		return;
 
-	if (!clock->shared) {
-		mlx5_clock_arm_pps_in_event(clock, NULL, mdev);
-		goto out;
-	}
-
-	mlx5_devcom_comp_lock(mdev->clock_state->compdev);
-	mlx5_devcom_for_each_peer_entry(mdev->clock_state->compdev, peer_dev, pos) {
-		if (peer_dev->clock && peer_dev != mdev) {
-			next = peer_dev;
-			break;
+	if (clock->shared) {
+		mlx5_devcom_comp_lock(mdev->clock_state->compdev);
+		mlx5_devcom_for_each_peer_entry(mdev->clock_state->compdev,
+						peer_dev, pos) {
+			if (peer_dev->clock == clock &&
+			    peer_dev->clock_state->loaded) {
+				next = peer_dev;
+				break;
+			}
 		}
 	}
 
 	mlx5_clock_lock(clock);
-	if (mdev == clock_priv(clock)->event_mdev)
+	cpriv = clock_priv(clock);
+	mdev->clock_state->loaded = false;
+	if (mdev == cpriv->mdev && next)
+		cpriv->mdev = next;
+	if (mdev == cpriv->event_mdev)
 		mlx5_clock_arm_pps_in_event(clock, next, mdev);
+	stop = !cpriv->mdev->clock_state->loaded;
+	if (!mlx5_real_time_mode(cpriv->mdev))
+		mlx5_save_timecounter(cpriv->mdev);
 	mlx5_clock_unlock(clock);
-	mlx5_devcom_comp_unlock(mdev->clock_state->compdev);
 
-out:
+	/* Keep devcom locked to prevent a peer from restarting the worker. */
+	if (stop && clock->ptp)
+		ptp_cancel_worker_sync(clock->ptp);
+	if (clock->shared)
+		mlx5_devcom_comp_unlock(mdev->clock_state->compdev);
+
 	mlx5_eq_notifier_unregister(mdev, &mdev->clock_state->pps_nb);
 	cancel_work_sync(&mdev->clock_state->out_work);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index aff3aed62c74..86ae447a23ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -50,6 +50,8 @@ struct mlx5_timer {
 	struct timecounter         tc;
 	u32                        nominal_c_mult;
 	unsigned long              overflow_period;
+	u64                        saved_phc_ns;
+	u64                        saved_boot_ns;
 };
 
 struct mlx5_clock {

base-commit: 647b81ddefc6364290e67bf33c89d54971f8995e
-- 
2.44.0


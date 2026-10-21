Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792580208;
	b=XjHqLItyotlbYMLfVD+1yAopneyxniW8vo1Qa3iiOVXO0EiJHwW5gbgIHZFq5TvkxHy4
	 SDjXYSgZHQAQfuncOEx6D5+qlkWRDIPhUDOLnHi3SJDH2eH2kCfmIpdjJRKuH8XEmINqQ
	 2FQr2GC4/rbO45R7U93zfCbMUhtJZ6fnXN2X2dOZkTdzXLyj7Uooma5cZGhChfiLYbR01
	 NynAvuGnEl1pXOabR6zTfM6FRno6kKHyU2ynWLd5GOjZDT2yrRAO6UJvy70cLffOi7gCp
	 rXR47HRUPlRbsKWlo1wEdMyqS1ald5BBUMuo0JeVy5ecwIBP5UAUtWf99FhyKmnKTnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580208;
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
	bh=0tjw/5RZr7ify1QWeoYC0RvJKyRuydJPn1PAr10/sC8=;
	b=5avcdiwFVG1t7HOncyVDKCY4S/Nd1XdE+KlS769GKcnCxZV78/SZ6ccxHa/k21yAM8kj
	 ZHQCCREvTxMjPSgQIt+7XR3KaOt0rvTDt9B7+AeAqFquOYxFgnvMDLo68mz4lJi6qh8J7
	 h7iZmjUlLlpVCzQx9BK0Xg/DB8OO+8R1hl2ZNHy5hvAo5arJrRHFmSqoLTHTd7rGlI77k
	 GI7CBc0oMd1T0gSTb01tk1rlwjFXnqcYVkrUSRush7zHbPNJhRqOx/1805DEsu8hsaggL
	 XiBN/oWTiSSMu/O87Jdvz58U27DgHyUnXv4CSDTbeIfOGocWT+ylm+wylv7AvGK/nyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RE6sd2Lw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.39
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D21606A319;
	Wed, 21 Oct 2026 10:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3D21606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RE6sd2Lw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VRLPyoyNBnKSitl6y0LPlG+VGsXAZQxUBfj2/QVZm1meqjSEcPYDhkQAI3gCAU7Q4lGcbSdsp6eZoYGMN87jOkVz59egG7zx7lfciqeMIGOpJjqAPTgFSr6oE+Dc7wvY7UaoX7RnO/Imm/CV4ZjUMPTAWgHrWg8+lkDQQmEND7N5NS0I+SK5+/E/hVrRGpoYWuVvheKaxKdUHlfbxZ8qdAcs3eF4a97AIm9NUeHT8WmP/tgonNuoKUpOaILsSQGvLiEUyMk/+ro44O74hxWnJXGVqaeSLQUpG75duLqtPKAh3rsoLXmfKDshAFgVQmBvsHZ253hfctJuZO2Za3wG5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tjw/5RZr7ify1QWeoYC0RvJKyRuydJPn1PAr10/sC8=;
 b=ITe0iw19Q4xrL7eNJxqpBaAc+x5Oh/n1Esb/KmO8zU59OlpSAaLIuOKvzVzoYsgjTA/Ha6lvA4P8eo1bx3WC/PM5V8nmdX6ynZF/3EeJrg+OASuvSxTXTIsw/8HD0PKtgewMaN+d3Yu28sGYdUkxVZtueC3ag7rew+PkXx/tsQIN4nBgYDF9wJ0+PBL+KSODgYlUSMVKBBcup4ISJQODSDD8eb+3XjBn5Cnb72cu8GeJkTaWM6SpIhK+Rek0Y8xGVGrIRgRPYAj6Jkywc3ETf+8rCzaeAiv9yA4gX1TfURtwf7YL4DIBAyTa4on9gfIGozn13N6HxNufLDQ7hbi3PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tjw/5RZr7ify1QWeoYC0RvJKyRuydJPn1PAr10/sC8=;
 b=RE6sd2LwVGhO1t7Y3JhHhO2qvgLVYBTBFpcNgIn/Ef1Y/wVrKAEHQiJ6B2GLu4sBB6pqlAM754ASzLP5wW6T/tTRbD/lkEj166LMtBTQ4PrBiGjWEnJrCb4Q8uTZcq/QlKIM0jzjGXKkb5gAeBwWUx4q2E+sXjv9X3S6t3VojK/XWUAG2UCUdawVevLwl1+ip9uILOBBdjPBIhOBDEvB4sucq2kpmEHJEZfB1OwIwJN5BGzu8hHdoBUpcNG4MgYecKsJBNkYmNz1xDCp0Y6hB/nZthkKpmPb7A9ZwRIBba5epg/W6oNgOoe9THI0Tk+gM9LaHp2DG2Ude3WUfBtiJw==
Received: from BN9PR03CA0642.namprd03.prod.outlook.com (2603:10b6:408:13b::17)
 by SJ2PR12MB9137.namprd12.prod.outlook.com (2603:10b6:a03:562::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 10:56:42 +0000
Received: from BN6PEPF00000075.namprd03.prod.outlook.com
 (2603:10b6:408:13b:cafe::2) by BN9PR03CA0642.outlook.office365.com
 (2603:10b6:408:13b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.19 via Frontend Transport; Wed,
 21 Oct 2026 10:56:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN6PEPF00000075.mail.protection.outlook.com (10.167.248.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 10:56:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 03:56:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 21 Oct
 2026 03:56:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 21
 Oct 2026 03:56:16 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shahar
 Shitrit" <shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, "Thomas
 Gleixner" <tglx@kernel.org>
Subject: [PATCH net] net/mlx5: Use only loaded devices for PTP clock operations
Date: Wed, 21 Oct 2026 13:56:00 +0300
Message-ID: <20261021105600.3481485-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN6PEPF00000075:EE_|SJ2PR12MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa99d5d-0a67-47e3-bd6a-08df2f61fd5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|7416014|23010399003|1800799024|261009223027099003|10067099003|56012099006|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	7AnvtwABeY/zlekhroq10hh8XgtscaO93/sXQ4BKE0PzmiNfAyCpvwHvxIIyM6EcG67ChDF9fmi1T7lPaBaB0sF2WxzXCuCCEn8kDK9vg2l5IvDGfhAaTiKR6Uv26uYk4FSSOw1lrtUMKSxJTqpMOfq09sDJsawDoiGPwqIv8tR3D8Sh6hPlBpfNZFMIPrL9s/kQK76mJluaMDULkrYzXjXn6Onnd/UTbdOuC99n5OFjh4syt5u5KS5l1Q9VOxPUSZW5feIwdctES2lAqNqSf65+mq2OVCf0wSjCzR2JugWBpFQq87YdQ9GPcbxsJO7Qy8m6OGI72/VAsA2+Jl8DwqlJwksLan6aJkoWCNIJgqU7MYMAlqYIr0wdmojDoaropLabzw06DDz2z/HcBEKlp+vDK+aNBWIua4hNtW7So48i6z1umTDC+Ij6UMAEiKbA3hnT/mAKh7kTYPGiTxDpwkiAdnFmtsfKjn8bIpiJPG73gGSfIGXM5+28VkMxCXzszq0B0frI2awcSNBrU9YHqOBWHNVj7xb5AEJK7/f0I4zpDnuhmkOaBDpjcUDAhOLCylc34rMdv5m0krvJwylXQx3IaikIBbPyRNGAdmGDfXPUFurwy2dOFwIMM0zdpntdKuN+sdr5OCRnrc9JTkSegCw3qo3nSOIa4jWJCKilVKnc5+b4e1EPJStvNeG2Goju8KkkXnDumKHbr8eKrWQqhg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(7416014)(23010399003)(1800799024)(261009223027099003)(10067099003)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bPEtkBQ47Hbl+s/s/UbNcB5xCCjm0nfSI8tXkDRj7orE4pILSUzAdqj1yJZKigQrGeV5V0MAn/zurkdUlCYS9EqH+SD1lAz7BRDe0OGmDEZuM8xQIA++3ad4pg2tpltHpQkaO9WD4eWQtyU+862Z8UgrcsXzBf5Vz3KNMrLyh9ecnxBHZyCQbswEx1GYrmHCBbL0CGNsd5Yx9at2IBcYwfrj5CNYK8kOgGGYIikF/PI0Zi0+Vp621XllZEbCpws/EIjpQEFHG72zzabT7xkndcINxMNMsDe5u6qh6ONfg14e6rXPN5Ep74CKAsx0/Z1FQdzR5pWRHZUQomyTGHYDdRQ2xAZ3ROw4hql0/Xa3AVg/i483kMM1Q2D//hSnw0a3JpqzB8CqUSM1GH6gQ9K2mJE0VuoEz1R1VJFFlRixlJv9UasMRCrzXVjLqGmnYi0c
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 10:56:41.7162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa99d5d-0a67-47e3-bd6a-08df2f61fd5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000075.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9137

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

Fixes: 8fc3e29be924 ("net/mlx5: Fix crash upon suspend/resume")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 248 +++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |   2 +
 2 files changed, 185 insertions(+), 65 deletions(-)

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

base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0


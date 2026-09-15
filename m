Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012053.outbound.protection.outlook.com [52.101.48.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DCE4DF4D7;
	Tue, 15 Sep 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472160; cv=fail; b=TGkxkOg4PR/je2LL3bWDZtqd95WO8kdQpxbkvDxkkm+BKnxYAQA3oOMrqzK3aRl3HWPM/ZbChOxTdfb3EgnsV9mM+0+tvdxyivn9CdTiYzi/9vXPBZ0raDicePxcuq8+LWCqE0qddh+Vi2fOnWk0oJCfTo8cebzTKhVbV24/ujo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472160; c=relaxed/simple;
	bh=ylClRsC5Sp3zN8Xd30lUqPW5XbERBmGZJNIlTP2CrQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gWD/V8l2OLMxmsTPSG6Z4IyaGIsAmnJArz4L2bSzZnDQq7o2r5ClhO0pyVjpSHpROCyiJ1W0PAXzF52geGkAuBD7Jx3iHTLJa3dwOqaMX6rOFrRA4iGBJqTDUJ13gnlFIqGHFQqtvAVBlCxIyCJVnfkqCatOnEqR2XrYV2Kk7OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ot+L1RzC; arc=fail smtp.client-ip=52.101.48.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ot+L1RzC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=foa8Rlr9DxXG4cSrTiYJXZolLHGB8kLAldtlIzdCcxkErThkBHRSDJCRBxRr6yCG5dkBEQdwlDNNNyMjtbAQqMabNRkpbK9dRz1ziOyxCxH2G44IpCQMoY5LqCH8oM3tIw4o/SX+43dBa55iC6h5q29v+OcpZctW5TcJA2dCxqUscLPxbtQbLiycZSXdjOgHqU7revl6t1/AKWnWi31CgxWm9sfnk68e2a6s2H5Xyn0qUCpn2y1QPnGlrX5C2qRHOg+RrsowoW6YnlHS1h1CTYfDsWW9PDmVYrOZo1MXkxkUjV9HPzysAIcnd8UXUGidz+kypzL2nZRGogslc342sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=HLp7wTAk7MAADkNYAoKeCezSkRIJI87J7UJQGyf8vUbfCprNMZq9RsfydJRZXV4Y0ShApAb0vu77Pg/7McPQB4dcwbv9xCUCB+nsRZebGMO4zGXNq5ildkIXvGIOSEFmxgYCAQ1lVGoqqsFJ1sJ3hfn8uIEAQGcX5iI/oMr3FmzDsD2+P3L8VpJQhyYQ2lYI/AC/nvpRutJiP9mIE5QrlgW5Hi33YMw40RXuzvHFMOY6QeCBHOu6kL+JxSwgYs6HiRSYugDaxVk18V68vsqaiSLZDvjcs/4wPZx1lU8in/8gOk2uzYrUHz7YTwl4Ndjgg5OeoAXghw/88yoHB1qrGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=ot+L1RzCv03dPCEwO/W8/hakLJZ2s+vhYUO7HzTCFL+xQV5MaxgX3OXKzfu2V8vtRba2GDbghhJWEi1tvhNuk/2gI4DDwx8F62FBMqGbKMTBWibVw9k3r0pqIo+bbJfr8KpFQ8TS2NR4IzQbcU8zKCtNNBp3JPae/tpSjXZAKx9R9fTsiX9TsRGrTwZcBmEUzabW27BuZlVnWxNJsM+TDJPv6YimaL2UlLvoZwE0TDSTKFKRZgQsFyomD6o1MQu7Mw6glNuay1QKgvwH8hmvLBJLj7v6zane6J02YEG/O6/1ZUPNrWsz7EpKgPIdLfTpGOIM1WeAJqAeWL8CkwcDvg==
Received: from CH3P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::21)
 by LV2PR12MB5824.namprd12.prod.outlook.com (2603:10b6:408:176::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 11:35:52 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::d) by CH3P221CA0013.outlook.office365.com
 (2603:10b6:610:1e7::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 11:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:35:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:35:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 04:35:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 04:35:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V3 1/3] net/mlx5: devcom, Base component size on linked devices
Date: Tue, 15 Sep 2026 14:34:57 +0300
Message-ID: <20260915113459.3934760-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915113459.3934760-1-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|LV2PR12MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: d89cce0d-11af-4e66-79ef-08df131d7f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|23010399003|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	y7nvmiNhrB7IKeIpn2znlUdv9ep8VCuJhYs7gJ98sCG5dLB8nkEfk4UZopHUcIep5vmomz3+w65aIQW/fT31IHGc8LKtYNwMM81y8X9gdC+vb96Mdg891u5Eb8b0C0aqlUApjlWxa+DlHvQo0ipIbci1ZDj1ZPfNuqW5E7h3YMNB5islYKSCZ29fh/YijdR+1ww42mXK/xbs+t+hXAR6/NfsKgJAvCqcvTNL1h5Q/Vj2ipxg9LbFcPrqSBplnYVU1M15q7KsxJYMx5FyL8tZSsfvPSiwSolIT/Ru4gGZA7y7DS6XbHqE46IUbmMl4iKEE6ijjJVqeZgGDiQ1U1aUyQE3utdQi5gm1bGdroATU9liAfkmeEkfMpylR7yT0HbVXcYq3Wsa35Y91YM/rFJnR6ZuAExXmc3pmPiKuvwaa68M/TjDkayIPGOzy5f09XQt/ZYpi/A/7a9RTDnV19qhgCj4mBcfNpeDGfnSjemxCjd5v6Z0JlNqFMNM2xVq+3U6VKxBtV5xgUT4s7itS4g0DJzHaUyb+pD9dM6gELOAi5h+iRejLdatsWjHXnNL4p+aRD6jV8kBsi6vk+5DZ30t3eFP8zWZvZJIu/o/XXIWEInuEDdk5yhaCrNbcAUql3KU8NOdtl7MpujP+lp0pagDV3xX8gAuY4s38p5/VnQXRN7lBeXAQLoTUBXfYQwrmod6Q3tyFTyXqVXKOOOAP8abvg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2jHi3M0FcPIGi+78WDGcoaWi0giWuOLVlhtq05FbObR4/1ER3GjcPEMP4oXUy8NaVXkHA2j+scQ5fKcyJLHkKcA5Nhh+emmuDUQH7H1bjz3Wm/JpfxjOryuwaudjxBGBLHuwZPpIE2wl+pq60D9yHJi+NP+1Stuh8QKvC3CqIsDCpa/qyzwa82nABogHTw0LzZQmtdqrogz7iuFIHmcHbTGnXniEZ/0xQzIf6leIncBbFcPtF/TbR52xmO8kE9f4uuqrbcoSrgZaK9m5Z0bchrrW5gnEDx09TAuqvZg3XU54gZV5K2jI/z3Tmj7p0mltdNLvdtT0cIUr8pdDDn85rOkMK8o4TmM7wEiMYet4DY++g1wNl/ARwhFo531BjpZiulij0uDpu9wTCETW3c9SWIUD/I1mdadAD1WXaO6cZyxQqgjeXMKgjc766T6WLwgb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:35:51.5374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d89cce0d-11af-4e66-79ef-08df131d7f1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5824

From: Shay Drory <shayd@nvidia.com>

mlx5_devcom_comp_get_size() returns the component's kref count. That
kref is bumped in mlx5_devcom_register_component() under comp_list_lock,
before the comp_dev is linked onto comp_dev_list_head under comp->sem.
The event broadcast (mlx5_devcom_locked_send_event()) walks that list.

Hence, a caller can read the expected size, but send_event won't be sent
to all peers. In the SD group registration path, this lets a member
broadcast its role-election event over an incomplete list, electing a
primary that never completes the group, is never marked ready, and
leaves the group with a stale primary.

Track the number of linked comp_devs in a dedicated counter, maintained
under comp->sem together with the list add/remove, and return it from
mlx5_devcom_comp_get_size().

Fixes: 9bb1ac80738a ("net/mlx5: devcom, Add component size getter")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 64f92427602d..75855481522b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -37,6 +37,7 @@ struct mlx5_devcom_comp {
 	struct mlx5_devcom_key key;
 	mlx5_devcom_event_handler_t handler;
 	struct kref ref;
+	int nr_devs;
 	bool ready;
 	struct rw_semaphore sem;
 	struct lock_class_key lock_key;
@@ -170,6 +171,7 @@ devcom_alloc_comp_dev(struct mlx5_devcom_dev *devc,
 
 	down_write(&comp->sem);
 	list_add_tail(&devcom->list, &comp->comp_dev_list_head);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs + 1);
 	up_write(&comp->sem);
 
 	return devcom;
@@ -182,6 +184,7 @@ devcom_free_comp_dev(struct mlx5_devcom_comp_dev *devcom)
 
 	down_write(&comp->sem);
 	list_del(&devcom->list);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
 	up_write(&comp->sem);
 
 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
@@ -284,7 +287,7 @@ int mlx5_devcom_comp_get_size(struct mlx5_devcom_comp_dev *devcom)
 {
 	struct mlx5_devcom_comp *comp = devcom->comp;
 
-	return kref_read(&comp->ref);
+	return READ_ONCE(comp->nr_devs);
 }
 
 int mlx5_devcom_locked_send_event(struct mlx5_devcom_comp_dev *devcom,
-- 
2.44.0


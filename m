Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010029.outbound.protection.outlook.com [40.93.198.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E48497B83;
	Wed, 23 Sep 2026 10:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160085; cv=fail; b=cWCU1kWvcz7NlagncrsIsMnRbALP6DuY3I4+QmchDxtq2koztLjzgnkUEgnL3Ft3VgnPVb6IXoVghi6mp4NiGKI2h/JrolaAEjb6QGgCjXfkIjiy67IVCc3ve1XUMx6USYfXtdxvo/tTSu81VCM0pms5QaWwjoFY303924kelCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160085; c=relaxed/simple;
	bh=l7DU3/cBnjO/HJ8350KSI7IOyuAFqkWbv16o/1o0Gh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WtsJD5VAt/LsLpiQ9IpHcMQ7eP+YfnOMfjfxxPCj+0ANbSCOvndwqDYt6BZn3LLirz1PeP6j6mMHNe1qQ76XY7HoS1yvdZ65yRsK70glMyV6aIETKzIh0q00+72djfpNTkAOhaO8bkwVIMrfnWCmPtRehCaGVi+Q/ArG3GdHbEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kx6YmoAH; arc=fail smtp.client-ip=40.93.198.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kx6YmoAH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2zWpN/dN+pJ2B/qM3g4hCqBity9l1KIH9bXgCaL74WlqLAw07IifJ3Zbs0hXo/8NOGYiYUTjkT3dD+QXVlDzBaT0eCjMZbXhah0Dz4tb4svgWaqlTCCo5BXVh2uJH5JVweTkPe6jvWQA2lBu/RMq6etfzk9yNCYSATIzpFVro9LqdlgM4s6wwnDJaT8eYMYyvopRS7pyDOwhkuK5IK5AWd1Rc2Iwv7tyRkrritR9LzA2+fdSW7EH15iLyKI1uTFXoqj+pmTxrwNf7f2pGWD0M8WwSx6nLBYvQ5SNALAc8LXxI78l0PpNrRfprjMf3Z+2NtpJpA+wGVQoiVykMX/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ll56nHHAeIj70oSUvjHg3ULLP/R+tcVzd2hh1h2Hhk=;
 b=tstkJaGzL74YZzqFjnbg+Xf0gaD6FbE3fmY+BxDszCsNdoq2S+TIRL8H7DO2X8L6UX2LmuJlpm6yNuUrpenGc4Oa74dd8lhuSRE820DjY7OPPU0zzFO8Fw3V8ciZaqzhkdbrKgIfi2YyBtGa/hkLEUaY4m1f3RP5SiJh+WEjaM+0b5bXFpjD1ze4/AgRsTyDm41mCtw9Fj3ZQieF5ac/dkxI5Cz7geKB9lx6EEdWE3laGNoE6gJ4zMEKNQBTzGMbteeiU5h6+sHYH5irFMc4wm5BUhEy+uM3zDIxl/QoyMMxLtE7Qyf6vtA4YoPktP+NHKRBDmZ6ui3ZlaRXebvp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ll56nHHAeIj70oSUvjHg3ULLP/R+tcVzd2hh1h2Hhk=;
 b=Kx6YmoAHjm/mIJifrRLmIZPn+uEWx09nFJNinU/hGevkJn59rzSrZJtP9zlSGfDExOxSeph3lGisIQrR6eRVQRNeJukxzCMW50HOenbg3smj/kU0GeiXuIxU7N+8JtrVVmJ+WMWL4K/l05rVTaS2iuDbrnuuFUhcbcSrpDKHjWWAEWXFuj8Uy1kBHEYVZAU3f5lUu5YpCfJT8Y2r8Z/OXjotGsRCbEA7Fxk+/hez1Nlbb+06E2cOFPcT4TD4+5JjVtE5QctGWI2JLXgbhaCvX8CzpUpDCmD9/8VAzoQ8er/V7++xajjs4HNv57pXd3CU5Xwsjf/3uMMY/zC2wK/uoA==
Received: from BN0PR07CA0022.namprd07.prod.outlook.com (2603:10b6:408:141::14)
 by SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:41:10 +0000
Received: from BN3PEPF00022BC7.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::4a) by BN0PR07CA0022.outlook.office365.com
 (2603:10b6:408:141::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Wed,
 23 Sep 2026 10:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC7.mail.protection.outlook.com (10.167.248.212) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:41:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:49 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:44 -0700
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
Subject: [PATCH net-next 11/13] net/mlx5: LAG, drop stale esw_shared_ingress_acl gate from shared FDB
Date: Wed, 23 Sep 2026 13:38:28 +0300
Message-ID: <20260923103830.1183-12-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC7:EE_|SA1PR12MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: c4241649-7b63-41e4-6877-08df195f2ebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|10067099003|5023799004|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EegXudHPAuwwGEGaPRBA+fhbCWqI5gYGINVUZOzHYAIYuT+YCy6ygqkHEmvfeF3BY5ZmwkoXQ/oSb+1PCLYNTkZuJDvWm0GxHhVxdO9aP4KhiDJ26zjwti7ZvnCeON6JfGHm+vTk1pXK5NYLIJRLi4skdB4Dh4HSg4F5duOTNVEA1RsEgG+senbmJj3yfoIgLEuS8OdDidTw2eTLTLYlCNZJ9TeWu9W28+lbkGBRxMSBL3AVTUmnrYw64UYS9bKOoLodQv/BOPkwVti7eJoEGwAQOnBXzxYAtATUgty/QeEm++wEKKk1TEv7sDhsi7EJj7eRdGHhHvZ2g0zQt2FH3o7NOtK5ldeP/xGjA3E9n6eu9WmJXb9xs2ddeVtS8N6gjSgrUpMpebv9nQTUYm9cCqD4ywPXUdjREMCAuZEt4AFy+slAxYK5kJ2Pe1DwyUPvnn6sQ61deZ4VbNtMiEovC6aP05DxeT6QzAJtCw1n36n+tPJmUnaMGnjwl5heGRLeB3goTnKCNBkONNw0ITNRzlufo268HYvlKCmpqf9uF+0HumO5PupFv5rSrHiKvdVTqtz7LCqEDeLT+K1HKqDt9J7HN76BVl1JJQp++iqs0io76EGTo96MeDH1RKXlUXehEwsTfPSXjiJz5SmIAWRGBFBa22pfugbny3iNxqK4EMG8RTC5J1MrCSoQLRIkR80ZCiVr5LKWUBZK8Ovq+VtDXQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(10067099003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SAPeCkpA5IIcQx2vaOzrax/ppDU6g0Ee2y2Y8qe896kCOHc3VqKRD5LFoGI5sfHZNBkcrJqeYXtYhXMj6E7jw4nYmncLKooU3J9tUsfH7/hs3udEij3ZbuiwumtfRaY/6yB2+wyQwpV27Xs48wKp6VrSUoL1Mlb3snD+2MHtJjHuONZ1BuCFfSizxaHFPULNJzn/scKCs9SUmzkKxfutOf+HsPIGMmgEzNC5pBszlpheGjUNAzeckNCfqkK7/oPjTCvGby9G630VT5u1orfsxEnDA6SJm9YXnX6p+GT2DjAZOJJQpJw7OiDLJYdrVgO7Hidt9XKvX+knLWbUdTfijGr6Nxjx2uFMubJIx6766cODNhrm8yfPLFdXv8kG9naeygTLj7YRHDdUy8YvJFrE2BJeX0VB0SAziL9gUE+wTc5KL2RnsMloTls6g2TlQPQd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:41:10.4869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4241649-7b63-41e4-6877-08df195f2ebd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344

From: Shay Drory <shayd@nvidia.com>

The shared-FDB support check still requires the esw_shared_ingress_acl
capability. That capability backed the merged uplink ingress ACL, where
the slave uplink's ingress-ACL root was pointed at the master's
(esw_set_uplink_slave_ingress_root()). That handling was removed in
commit 82e86a6c7109 ("net/mlx5: E-switch, remove special uplink ingress
ACL handling") once both uplinks were tagged with the same reserved
metadata (MLX5_ESW_METADATA_RSVD_UPLINK) - a single FDB rule then
matches traffic from either uplink, with no shared ingress ACL involved.

The capability check was left behind and has been dead since: the driver
programs no shared ingress ACL, yet the check still keeps otherwise
shared-FDB-capable devices out of shared FDB. Drop it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 6b4ad3c53f2f..c2185c3d7f6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -35,8 +35,7 @@ bool mlx5_lag_shared_fdb_supported_filter(struct mlx5_lag *ldev, u32 filter)
 
 	if (is_mdev_switchdev_mode(dev0) &&
 	    mlx5_eswitch_vport_match_metadata_enabled(dev0->priv.eswitch) &&
-	    mlx5_esw_offloads_devcom_is_ready(dev0->priv.eswitch) &&
-	    MLX5_CAP_ESW(dev0, esw_shared_ingress_acl))
+	    mlx5_esw_offloads_devcom_is_ready(dev0->priv.eswitch))
 		ret = true;
 
 	return ret;
-- 
2.44.0


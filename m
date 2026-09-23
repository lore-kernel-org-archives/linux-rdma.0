Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7FD4A0928;
	Wed, 23 Sep 2026 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160088; cv=fail; b=QDHn2WWQKUlqpaQfn8ydL8uNYXp4hrFd/moUPmWxJddxsKbdhixZkQz/p93AUGzMWVUk9oWXxBO8rzlap2+SDZpfI+Xga5iZ9QYfl1F7NSwnUwryIHGwZR73OPW/M5g+ScVdpsIDa3zhoDvGxOmwn/epz+n/cv3NhCVRwXH7D8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160088; c=relaxed/simple;
	bh=B2BnXf+qP4CG2gWNsfOwgVwInv7s1R6UjVh+eivDI2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ToJL1UU8rBVdSHfhC21dExGG5wHhDugDq5jFbJUaq2v//T0ULzPuQlnGBvFDBEbpsGx0trTB8wdvzFKOSK7r9GYBCAderv39z0PGXUQUU+69ile1kLhaqnBVLmn9L8pK1yI4siRqCE+A46gPV6/thMZGIPwntvZ5sPvH0MP15M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ctlz9zQ6; arc=fail smtp.client-ip=40.107.208.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ctlz9zQ6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVp3gKtFfmITLHcy5eJygnIhPPKXi0veqJjQyDl0arzrIWJCceBOJ/EOIpgZFJmBEFl47IyddvbLl6vuJgI81R0iF3qegm6PnVgxL2KaGLV8JGySv1BcAGoP8dJ2RWSTb6NH/pwNhJ5VpN7wV535ZbcooLRM6wG0uC3jUPY/x2nyodIA6nXp4NIZ8wIjZ0bqnJqOuNJ3TXPXnaKuF7c889ShTMVRM5soETTHmK2nPKZrPJzZ2OctIDhavPGUgwPv2h/NDn8/KWMgR9s23j19XUAp2J0nGcYMEvgjB/yg8o6H/hx0pWj7U9U1Foqu1hYvcgX1xc4354tGSpEFDvVNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Kd0x2X3J90V8sMI2IoJjjAPDqoJLalWrFWUiYr0gtU=;
 b=MVbrFYZdXhoceZI5KPHYkppi57Iyqq+N5Opp43Z7LIWBAN7fco6q433kRoo+jwFk3XluXrnMHTx1d2h1kfU49no6ifH+1QgWCeZr1PkVCFQ0PGUer6VhNfbpOImMF8096Ppee8B26u29T1NW1BbIOrmV+WrdEK0KTRnhpCaMSFtAhTeGG8Vc+I9a3IxJcEQd9IFcI2ZdtstCf9vi0OvrEnPP4IdIZXmiLc7W9f8CGLtDCcbQWTkpqu1aDlz2DmCDNDYIZo2n85Xwe8JiAVKxvcmqgrqSkaffbkA8wq/XyOCaaoTQ5YV7c64BIBV6plC6zI+OM/imtNSNvD7bxnEwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kd0x2X3J90V8sMI2IoJjjAPDqoJLalWrFWUiYr0gtU=;
 b=Ctlz9zQ6hh329QqPAN6tmQqz7QWVp1Nt7l3vSOkGEG9zK4yhzyLpKBGCJRUiRvJc3UxS9h4Iqz+43So4MI72IXxHD2bLkmQn/Sb1v4cJRoS+eA9u4nmZ6hSrvLJ1Hqmhfr0v22baZXW8nUYnT1mWVBu4wbemZLXxHmDTicRtkGhYp+0oCCoyucZpUqOWa4QfU/stkujSbpm+LDnqguLdIMWwSfyhM87hzvC4i3k59qg6oFT+QOjMB+0tzrp1wq4u0FCxhc1x8uDnwZ1eWc1QtBMhybAfob+s82MbGIBQeii0ChsB5iXnmJKJz7Y1ejNiUJKb5G5ltBkYc9C8bxmpfw==
Received: from SJ0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:33a::31)
 by DM4PR12MB6565.namprd12.prod.outlook.com (2603:10b6:8:8c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:41:04 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::c) by SJ0PR03CA0026.outlook.office365.com
 (2603:10b6:a03:33a::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Wed,
 23 Sep 2026 10:41:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:41:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:44 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:39 -0700
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
Subject: [PATCH net-next 10/13] net/mlx5: LAG, don't print port mapping to debugfs in MPESW mode
Date: Wed, 23 Sep 2026 13:38:27 +0300
Message-ID: <20260923103830.1183-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|DM4PR12MB6565:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b1ab29-d60d-4158-9380-08df195f2a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YFkqNxqBuF67U8WJOPGB6PcU0kZGzqKZDq08KHLRrgo8FP+L+GAdhTpkVmqim0R/cV+TOCbP3TNby9rY9qxOjdd+1KvJHumZmxGy3Tx14KtTvwQjkTmrSoB3b0wiXiVW3ak2rJykHYj9E/Ww2IVmJqWk58Tw9ohFUYL30WVpDnYrFIzvDym+lgVcYCsXYzzGl6JKZjVMPfrCCH915yvZSUeOfa5FM0vQ8W5oGraytzUMpdRD6TwxWdBuyKjGzmG0Y+lojaT70haICzhXp0bGATkhwnD/kasayoxaRWnZm64cQdeBFVkJZH8XID9eX0aDMtcsNpQVokgk/HEdOtrh2eSKxT7FqxmIBfP/huqSMOJ5yjR+cae4quftFP0bpDqim4Q9QU/u5I/iTAgY63tdoleTHvL1Bhvj2tUyDxqfGw3B+3Cl3xyVt/OPlaKMZFSu6hT14+36TSILrshP0NH6PNJ+RH1/XLxDvkvQWBkMWq/TiH7+9py0QP59Z2h90bBx6Yvxj/MZVeWaQMCj4n6IW9khgm2Z7SeC7Bzb54FOxd7pNDVoGU3AActn5gtwvDXY1xClzlb3+JlLUKcZXh8kFJ2ilcW+veGvrZRpD74duAnwQ9iCdMShURfCj1TztfAytz2K8k0rkDPEiG+x1b93XPDrlTndYh3ENP6mCjHKpSOeOENvwaWg104eEecSox346TOQr6n34Z36SgtTtQFrQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I0H6Tdl8SvrpE5QhWBKWUfAHA2ySoCctWi20wlxGX3AZ7HuTgj/zA6r6jx4nmApoKtREyMJ3Kxohn95rE9P6rNdiPoIiLxCGhVt0jCxmnW1DbQWnS4z3ybWCDqOP8Mqdq8WhIaBXDU/Okb1dmNrZBogQ15krBPXNLGoXHkiwzT0SBYOjLZMOUOlxhKNvWeA52ZaM2TXudE85ckKBPstd8Sde37Gh7Tf2ON1npOEnPzYd5vDBeaICTUnYoEqe6oIiCPr9c+TjhEKWWWKClV0mIXPNPgSeMr7wU34ZSn/Pl+ZO6D2kmwCMAvYu9wxTYhvHep0QFknZ0IdBIruWW8psl3XXGpYSDDOnsYROxNe3NFe4Hjx/lr3AcaqzxfodhVjGAsPqPlMqBSwb/mzdZv+26py88frJmnQ4p+aUlOKhCtNV3QWMWrcIsXXnTDUX9JGL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:41:03.5651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b1ab29-d60d-4158-9380-08df195f2a95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6565

From: Shay Drory <shayd@nvidia.com>

The mapping debugfs file dumps the LAG virtual-to-physical port mapping.
In MPESW mode the LAG does not own that mapping - port selection is
driven by user steering rules, not by the LAG - so the dumped values are
meaningless.

Treat MPESW as if LAG is inactive and don't print anything to the user.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index 44296789d656..b6125c7bd91b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -114,7 +114,8 @@ static int mapping_show(struct seq_file *file, void *priv)
 		return -ENOMEM;
 
 	mutex_lock(&ldev->lock);
-	lag_active = __mlx5_lag_is_active(ldev);
+	lag_active = __mlx5_lag_is_active(ldev) &&
+		ldev->mode != MLX5_LAG_MODE_MPESW;
 	if (lag_active) {
 		if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags)) {
 			mlx5_infer_tx_enabled(&ldev->tracker, ldev, ports,
-- 
2.44.0


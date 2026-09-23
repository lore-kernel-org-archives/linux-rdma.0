Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0549480C;
	Wed, 23 Sep 2026 10:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160062; cv=fail; b=H1sVBA3UZwmrn/3M1XOdjs7A0WOeSlQ7Q1Mne0OmiyUCh0KIlb0MURTm27B88S+w78G2tWiKP5XVIn7ofw/sV7mN/KmZ+as45cGZ7QijK/bHmkUG67WMGPfhEs4SZk7E2rg5qBNslTbNNZpfwVooaMWOv13w31m4Sbdo8SS7Cz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160062; c=relaxed/simple;
	bh=Sr8ZDzLwmad7B7GvVB4TktczhwdI2emZtCg4s97mEuM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqxUi+Oiie/W+1v/G+7g50WaqMIWndArw0A1Xy8/ZF6l8/sdFFqDVm2+IIEnJlSh3Yjmtxdg1CfbshBaE5kIcYNczCMZA3UgkavQUSJrqS9lh+SaOcsTLWYc+AU3jqYefQ4Scj1w7qKSPL7ojSaJfXJ6Ae5wJKwCWjicp3TjR8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xrn+hebt; arc=fail smtp.client-ip=52.101.56.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xrn+hebt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NnJU7UcvXkQ+6b+ltUEP2oSE/P/SMk3V4HWsuisLF1KLuEHrxaufx6kyF6JBrqxPYkv/xeUbD6JTrhRierto6TtumcU5luMayD8FGJ7IeTYrOORWkjloFEt1tpgIzO8CCaAj3BGwP7iM7NW1UZkMtUyxVleAM3fbj0avHytBUjf5spiIh7a+cjGhADr3SS8oDkIM8UeRreRl16BocLSabsg0jTScZN9S8cuUrRvX/8mMZQW4NtO9/YsSQw/nKuLlo9l4TMw6dPYTs1HjekwtWvN73Hgxgq2EwmrDQkCje5Vl1fsVHjbD887koaNuZofBAl7OQ5HsFjAz0sWRIZQa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1BimsmJH4jr3bhHB3HTTV8B5tL8oXU4RIb2AFpCiIA=;
 b=Ydl3JzCSFioEy8Bq7gWs6Ra+xIvPZC4NLBBes4jX9uoPAYDIw34C5st2IkPioK0ENV1IFTdDwYxUL4wGikmNFi/MCSumZ5iVb1FFlCMJYphWm5+bWflzDOXnhq3PiFIibcZxVpr3Df5kSDDl6ZWLIQCSifR0dcN3ay/H3tIpCbxDaF3GvWzzE3A/5ddnYoxlSj1k54D1rVBxWbG+IMz3qFlM/neAMvKx0CwIbpGwPD27/BWdEbWTjFbPdywLvsEpdsFkXFcnc0lXOihYJ7gI7O5/nM7f4ASeeJJPoryR+jvgBaRQ9AkfJfDedCQRuKuDwSXUjEeHNCo3iQ0wf0JXQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1BimsmJH4jr3bhHB3HTTV8B5tL8oXU4RIb2AFpCiIA=;
 b=Xrn+hebtSDcU/Ma+K/Jv1SpIbXZgzxSiYQDj7Ha/YEwzZm7WW+6bGcBxqrZHVJFPPI5ePVzTLyS8SczUOBSV5xOsHZAG++PSA+Fqnkv+7gRT2bf1OmoYf2EeWK92yt++FYTCCXHGS6uJ5VOrzdDitknsN/ultb2YY2erXznivK/ARyGbZLWwwDoGzHi8z/tA/OWXn74gg4lzq4oH3uWDSFavbFU0o9BSTPROLLvVp+t8JOx7lWRkOPDPsL69MMeFb2ChwYdER5uM4xO8YO8XNxqxDM/F8gl+vwhQrZNTBXQ+iZG8H3hX90NXlhRkUsxmF18lfpgJ9kkQwVo5jztkvQ==
Received: from BN9PR03CA0225.namprd03.prod.outlook.com (2603:10b6:408:f8::20)
 by DS0PR12MB8765.namprd12.prod.outlook.com (2603:10b6:8:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 10:40:37 +0000
Received: from BN3PEPF00022BC6.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::90) by BN9PR03CA0225.outlook.office365.com
 (2603:10b6:408:f8::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.13 via Frontend Transport; Wed,
 23 Sep 2026 10:40:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC6.mail.protection.outlook.com (10.167.248.219) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:19 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:14 -0700
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
Subject: [PATCH net-next 05/13] net/mlx5: LAG, drop per-port scratch array in drop-rule setup
Date: Wed, 23 Sep 2026 13:38:22 +0300
Message-ID: <20260923103830.1183-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC6:EE_|DS0PR12MB8765:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aac6db5-27ae-470c-9aed-08df195f1a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lyht68z7NbTwawQ6Qs96POoAsX6m62Za384Q0LDPKPR4HSt8elxPKKt1zpJdSwbxEPP7sTKW13SBB9y4GN4RtkTBwsEA53cwV0OcxZfMU+o6dsiqtc2aGobchS37hTovLPfx0NVEV+kmeNfYlfqrX1BEjUHtXdvV6bu26ttqi7DqYxph85DId9x7R1QKbhFARz1YWN8ASVfZG/eVEmXRiFcSQolhCydYjrv6J07Prbxw2v/yJ+jFyw8X6cN2bcCHN3Xyu8hc7YHqFaZA7ACQsmbdUaI8X98aal7n8jy0CoMm4M09BMDooildo842TgCwGkNjJ1JO7noz4eDgTJXKKsE6yWBVfHQVDCvDU4FAYawtR7IvX/CAArLetn/k+8dSGyIvtR/Bwii0X73WqpUg2KjgXhgCIqPm8UI1D21WDgKMB1R9LTnfVIE6BQt72rI3Bv+LwQpw4tkEGMe6ulAA8TsCQX9JyA04E/xbsLeGtZ//YNVjTRazJOnpA2k+XJuYIeFargCNyR3GuVrq0zGd9kip1+DWyiuPRJlfmSvBo3fOhZhN/vQlSFNz/NnG1JzQ1YZWSlSD2qLUZdrirzFz++gUVtHYdW4Dm6y5VOn0EeRC6B9Lq/32IfGuVwXSIJ9pHVu+O27c1ievBpuTqLwvQJkJrAojhcyifRvwDnEqik/wjtEVhZJRVijhvtqEaQa8tVrMJMZznnbtXTkF7zp2Dg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IsB6ly8vd37qAWLWOE4iV7/Y1oCIPLifvks7hxY50V4lJWHkjT+W3Ba5PpZvcks43XEDLT8cPwXAVKwsVphgd5t0iW+jCR9i8aQ7Z008Mhk1x2w5fFyxH968kde/gS+xVkPM2yqvOvBUug4MoFr31tY3gYcTGwAJ+S9sTrXXm5oicmS6iGnAAMBQIV9eLYA9oBCe3aHqbiqFognnn2y9LeJnhR1QFR6BOBFJibVfWeRhQKVEykkMAXLywO6l4Ph8quiyQq4uLOgsogfJ3oSfUwGSavdsANoh+pc72aIXH28jVwNfGytfPiojoRdczidCzmw1TEkqhmYgeuPrrdbIgE/MpsqqhBInGyrzJFtZNPktAtX2CFDRLU0lkNkIjrFhTPq/orE1A3g2DO21GVu397rSAp1OHie0PGd5DBy2SjdVBLOknb3S5lq1ZpwTXNQF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:36.4438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aac6db5-27ae-470c-9aed-08df195f1a73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8765

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_drop_rule_setup() walks the per-port tracker state, but does so
through a per-port scratch array, mlx5_lag_drop_rule_setup() collects
the disabled ports to create a per-port drop rule.

Walk the tracker state inline removing its MLX5_MAX_PORTS dependency.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c    | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 93ead5664152..4648371f9914 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -792,11 +792,8 @@ static void mlx5_lag_drop_rule_cleanup(struct mlx5_lag *ldev)
 static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 				     struct lag_tracker *tracker)
 {
-	u8 disabled_ports[MLX5_MAX_PORTS] = {};
 	struct mlx5_core_dev *dev;
 	struct lag_func *pf;
-	int disabled_index;
-	int num_disabled;
 	int err;
 	int i;
 
@@ -808,11 +805,11 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 	if (!ldev->tracker.has_inactive)
 		return;
 
-	mlx5_infer_tx_disabled(tracker, ldev, disabled_ports, &num_disabled);
-
-	for (i = 0; i < num_disabled; i++) {
-		disabled_index = disabled_ports[i];
-		pf = mlx5_lag_pf(ldev, disabled_index);
+	mlx5_ldev_for_each(i, 0, ldev) {
+		if (tracker->netdev_state[i].tx_enabled &&
+		    tracker->netdev_state[i].link_up)
+			continue;
+		pf = mlx5_lag_pf(ldev, i);
 		dev = pf->dev;
 		err = mlx5_esw_acl_ingress_vport_drop_rule_create(dev->priv.eswitch,
 								  MLX5_VPORT_UPLINK);
@@ -820,7 +817,8 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 			pf->has_drop = true;
 		else
 			mlx5_core_err(dev,
-				      "Failed to create lag drop rule, error: %d", err);
+				      "Failed to create lag drop rule, error: %d",
+				      err);
 	}
 }
 
-- 
2.44.0


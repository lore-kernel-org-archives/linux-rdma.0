Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E2E47F782;
	Wed,  2 Sep 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367667; cv=fail; b=OOLsfBHIP1oS6eXESnJtjyBdrbbfwK/g1KU1K4Lx4Ie00kdlA6o7xD/FRJ63nGP0x4uAGQo4e/OBNnpHxkxpw9E/qiEePDLYf92QZ4ZraxaunPNccBCbZZQKaiLnjjwWyM+sNg4ulqB5SwkZduqmHaHWNxB9GhosMUrwqfNX+t8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367667; c=relaxed/simple;
	bh=6lpnV6ObLMGOH8BKRUkrCgpi9QBueBFsaBzEzMcm5zk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duMKCqyiaIXF7KlgRLH34OZuy5bjl1qF9lwReu1EiageC03Sary9FYght1pgdyHPOaQiD6hbv4l+I9BkiJrhw894l96jYkzJJxRGYevnz+VamJQLtbmIDixKIQMsBKlicVbvXUgLQrObTxEVX18ieEVGOIMheDBAfLWE8pKFPlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b65/C9+J; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b65/C9+J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mF/x6Jk//xz42i6CRXjtRkGPIrSBj0gcHcm9/6iBrRXocG6CgC5OLWQPJCthoCGKnrwn807tOzdiA+w4VYOY0jNzax/uRUoSYz6Et/tB2wQyagO3wrYtqqbIWwjd7EzvkFUtPtXvb07gfMjmmG355Er1XsCOjcJZoMA9o22NVG4Hi9OmhMWueLT1EgFTE4YPmHVT5gG/CjbWj0GLR/ktE+SqiYYKUQbb8hFS2gU/R+xVp8OwEsMzt+4y42Stm5J6GroooO/YorjnBUCEpS30hlP2QYuTJdqChr/VGDbo7CaExbUuc7lnrDa+uVoX5kHYch5psaVxWilwjzZcgL48nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9ny1+aT0nCe90ULX407QVwHl0F3iJ1br2JHleobQfE=;
 b=QIsK+v5bJfru1zgZCQciOfdGHWEs8WyHvBEnIgwizIf0zKFXUA8B/kW+t6/DxNMuPLxvkggDOao2eC/xttP4XsgORnnrhK5AykvyRg37uFlUnpqfHUS7HIfVGa5/gjsv2OR0ydKZO2rpdfo5KUW8kNsnHcxo79bA2Mm6sPKTfEGwGRVp3xRV3qgV4A5/yf9EWjy91iJ7jhAny7KYJewR3qkr7OMNZyXG7Wuo5qxLdsiqKtSklgDnltoe9zcaq2HKFsO6Aj0XbNQkB6m/uHepGQUBqk54iMekOHQFtaV+lZfva+AEkwib32uY7TzyLcvsWBBGRjTLvtKzxYN1IcSzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9ny1+aT0nCe90ULX407QVwHl0F3iJ1br2JHleobQfE=;
 b=b65/C9+JQv66SuAg2tX8iDNtCtbQVOd1FBTnDf4OvhOVmjSTMQckjiUOe84qEKG1G4akgigqrV+clecGldgPjMV52u35gulO5XiEAYyd2Gp7A0AkL82d66FZs6Bww3RwP6/AH2UVQ8MIG7g+wD2OFtzXe8iNaVgHexgb2/l3jIZxOEx2o4H6aChyggZLZ6Ml1b6HJBai6qVBjl1ag4CbdWRlTViyEkYr2nKtpY/4rF2APhFx093myiS41TK+Lwx9ws5VAxR/FFtlBk53ywEFvg2knYKunnxhRnhWqAKYgIIkOY8vJJNy2zzAWruk+iyQfwK7hM5sHWc1jgj7uR89qw==
Received: from BN9PR03CA0373.namprd03.prod.outlook.com (2603:10b6:408:f7::18)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:47:41 +0000
Received: from BN7PEPF00000095.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::99) by BN9PR03CA0373.outlook.office365.com
 (2603:10b6:408:f7::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Wed, 2
 Sep 2026 16:47:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN7PEPF00000095.mail.protection.outlook.com (10.167.245.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:47:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:47:14 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:47:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:47:09 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit
	<shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net 1/3] net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD
Date: Wed, 2 Sep 2026 19:46:32 +0300
Message-ID: <20260902164634.3657606-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260902164634.3657606-1-tariqt@nvidia.com>
References: <20260902164634.3657606-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000095:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: a34d3eb1-640a-4a91-8e77-08df0911e701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Qk/faABke+ytKuTE7UD+z0z49rkUi6jqRz1YYw3WG6gYGgvAXDaWNeYTMRNYrC9GHVlEsL5V1u5FQER8dbA6tK/oLZYPNxReL/aBpZ3nAI7ytsQB/Iq+F8zNCv6QB3X3t5G59+jBQR5pW1GC9plkQeki4oVA/MIJj23tVGqzSLTJYU3LUZn4BWvWffnfpEXl+qCCdJlK7EZodzJeKvTX6fsUuitifUqzYtTYLnNd1MUKw/mtXImsAda3DBfSAjjUTNCh9WT/hcDZjYdGm16emc4NzKpSCaIJhUmT1/4vIga/bN71Wi0YS8qGWVW6Qz26nDldcCaOGMTj1Nc1ma16dMNmntkTFqehAuDGoMpz6pYWIi8dPe8nXP0l75zXyrZVQrLi4dTSthhpsSHCu+C8VbWlfWl+G5t/CrhmDsJmWkPoQyVFV5Q69tvMQqCo0m4KTeDAbwidb1GUiMr5u9Fm2DN/FQZDQc0ab/0z+usVhUddxQrVpCG5/RBjaUcflfSvsL7H4klfJW7bK5M1trxBi9MVO7sc/QBmFz886NhFAyHAC52QAUznf2oWPH1zhAWW6bVjmchQnX4ihAJltXRmwIIMsysHW8MpjNXerRMwKpMi1A6YiPfjhAbo9WFi1iOVkZOnXUMngvTbJzAJ/cCC9rJDfAS3CHtwG9acIyqqdIAYhs/xn9Dcar99V3+0G2mfS8jmsNnIPigDSJmLFr1ODw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A25TG4TP3TmGWaVlsRxdYKQ5SVigfRFGMQQGUbWTLyJanKgoaujMN+Ve9rKLQtDBfKUbEiuqCJGJL084lYeVJoc7Agf361kccv5YNcm3yqMCaZFkjHHPbmsBtW14RaONiYhMxZGOw05RwOCmgq/DOBqoj0YVwL8/0w0a7vpGdwJDFvzvzC3pQk1bJmGKYAzolJrat1r1h5NT6L/9XD3wG2xLJR5KH3kGyMi//e5aj2l1A1v7khbKINMU/wXAmkdNdpVd4V6aXjN28xAZKfm4xGRxenaSDVLTE+XbBkKwug1vzBPxQUI8vD2k/Uos8Hk54HuAvZ3bzXmlWs49yuQ0n0UT0u1OGzh5lVZ4OV6QgpH8ZrbLPf9wqXQE998rsYhL8YqYNiMmZNWgk80S6fnNOtIQHqKpuF649JV6TLrG+8gi1ocgBeSirxgKNDlbG9j+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:47:40.2680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a34d3eb1-640a-4a91-8e77-08df0911e701
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965

From: Shahar Shitrit <shshitrit@nvidia.com>

MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD is missing from
pplm_fec_2_ethtool_linkmodes[], leaving index 4 zero-initialized.
As a result, when this FEC mode is active, find_first_bit() returns
index 4, causing __set_bit() to set bit 0
(ETHTOOL_LINK_MODE_10baseT_Half_BIT) instead of
ETHTOOL_LINK_MODE_FEC_RS_BIT. Consequently, ethtool reports:

  Advertised FEC modes: Not reported

Add the missing mapping to ETHTOOL_LINK_MODE_FEC_RS_BIT.

Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 112926d07634..f285ad88b6d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1013,6 +1013,7 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] = {
 	[MLX5E_FEC_NOFEC] = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 	[MLX5E_FEC_FIRECODE] = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 	[MLX5E_FEC_RS_528_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_RS_544_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_LLRS_272_257_1] = ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 };
-- 
2.44.0


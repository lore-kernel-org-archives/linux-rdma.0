Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C194ACC88;
	Wed,  2 Sep 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367683; cv=fail; b=Zie7kRLa7ENFKCQpTNvbA5fCCx0FDt017A70PsL2mAwhD+z3ZOHMqyRlXbo084cAdTdzQAxgrCxJOijtd9NUR5RkA6qw5X4kn6dCqktWB+5/HDbqDzWUgPGOd+jDIRmWEwDoSqSoeVQy8iaVgiM3Fck1HzaJYPDacFhWpnGn+Bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367683; c=relaxed/simple;
	bh=o8liquoPgyQMv7VEAD66g4mCaQ8bDgn6BwqdYxwew34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjXwsepAbgHKj0zSDClJtDhVdG6Q3Qdprq5AtHDBfMS+bLYRanxm/ULBdymdPmr5uHM5iZDufOGvRXC+RPLsoSC9FW2UFVc12GJ8oGPBIXLghf3bHYLqbJ6qrD5c9Lgiz5OdG4z4ryYjcKuDb8/AFu585u2oPj3qIgs6Qlf8cCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r+475SHL; arc=fail smtp.client-ip=40.107.209.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r+475SHL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XnDVKDZhYGdWmQfVOGj2aivUonwlanqyapzgsRchqSUp9KCxEa3bq3VHgPVVU6auRhDAe0UExBtIftSx2h40liokRfnsLOMy1YzkRxPpKQZ0U8mhLxjmhqCXmgPmA81gRlaEKazcppRu/amPaNOO67FZ8sB8Q+grYZvw3RLfTPZnDA5PlP6/ARBdSvu10PimmRlEkhQE2sTq56/j/mrPLJQaAkjC1Ny+ofPjmiZc6yiv+JgMuByPG1SSIYfLUb5SOhGgKvs06Uie+hm1r5AaICtVLZtwwpoCHiC6qkpz6DN3u4PDFJuwjYQWBXzabEdhMiEn9KHjT9MS9GboUqhfIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mdoGrb0cWFdGzpkjl/Wrt7hgSr2nisP9rrhCMRkVng=;
 b=MOc9ueWrArtSGR1KXBRJOociBRtRrFFN9Dmf6qztFHq7LO4EAcOqHpxkUTqJBVQAFouYK9rLp3ECasa1eZ0ytbz2Rklb4YGatuqvAeJ8St6Ih45P/lTmQNVtfPwwVNP69V9CfgwJObL4X4iBveFeWu04gt3XC+QxMMwmsBeN9wyXFe7ZRCFLo0yvmIIyp7Xp3E2Hx8CwkZQWhxnYgTLWMfs8o3v0wj8mVEM5zSFnn+zF3KnJNZE5y3k2nvL1ltcgwj15LQ/hGaLyJopwDtvvKpnzsHldjOtj1CXKk2rlVq5mkAjHvZYOwMAvnD3we5Nq7Q0RBwIwpvbJp6mB2gMu5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mdoGrb0cWFdGzpkjl/Wrt7hgSr2nisP9rrhCMRkVng=;
 b=r+475SHL8AP3oPz5XiYEsza+IBIflMulG+w5CHFmoUMKKKneSVTWQjkzjaLvVEB5y11nHCG71b15tUf+PZ9XNgCzAExgSRhfK5HD7Q+KNaorie0RzwKGeIb9m9ZcRCjNSeMTEzFvPW6NeqXrCirVw+27cdkoNS6fZ9uxUUkucki6jXBKZ9R7l3TTZ7gtGyeSVfsGLv2L0lWz4Eui2pekXjpuwq1k1gmQP7BLyFcl0HFRCL1LQ8W+YWKnJQBUf/ztyyG4TqcboSrgK6I5DFuCQcqZM/xVStSXWhCdX0HArzI0C9brnVt4ulyAZpI07pkwEyxiuEJ6QTsPz9lOsEocLQ==
Received: from BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::26)
 by CH0PR12MB8578.namprd12.prod.outlook.com (2603:10b6:610:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Wed, 2 Sep
 2026 16:47:53 +0000
Received: from BN7PEPF00000093.namprd03.prod.outlook.com
 (2603:10b6:408:10b:cafe::57) by BN9P223CA0021.outlook.office365.com
 (2603:10b6:408:10b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Wed, 2
 Sep 2026 16:47:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN7PEPF00000093.mail.protection.outlook.com (10.167.245.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:47:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:47:24 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:47:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:47:19 -0700
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
Subject: [PATCH net 3/3] net/mlx5e: Fix reporting support for all RS FEC variants
Date: Wed, 2 Sep 2026 19:46:34 +0300
Message-ID: <20260902164634.3657606-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000093:EE_|CH0PR12MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff1265c-f255-49f9-5655-08df0911ee51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fBrzqR4iEZsLyqTybNCsV+mtg3wilQBPMAsH51Cbins8Rgjo9NbEXNVJaRxXQsOp2/tgbz8EuunBiEZHo8O1aMDAuuaFSLHFZZ9f+ptBSuUCf72eS6Hv64zJQZMUO2wzRDPmLhoNFlZCpy5aNuXBeHHJ9eEaUatXwj8vap7wTWb82ZpTKnzMfr+xlKVEcuyyAEprr7D+vsWqzPuCofgf5yAlatPmRTc9dZyht3qYUUykD7rxPgF1m19yk0nHjO+fNZmRnmhhAG/AsYswG5/9q/0NhIZ3JmCYw79SGK5SMa1SVH23A7RLbJgqYWY6dpPpxqzIoCC6v8xzxiGxmRylob/lAsM/ZyTSQIbJ75zVCwHakMZdqZDIPWmrU7pZu6Efd9mxQ8mzMxioBXMRnykXux6DqEC2zPGstgCqK5PqM7CDONJjizzAdQiaxNqlOFRhHg9YELL821qvQFCJMoTaI7Z9fI3J6BM/UuMQG9Qf67w43H4ssQ8UcNuyb4aucaEcpXL/noEO4ISSnGO4U/Qika0gMQ5nnj0Qb6gbRSEa3Rltggh05iHvubYFe48lGprsFhvj+a28RYnK2Jei7jo8tXfgXfwHUTXYUY14XkVodUAit9aCSxgF++/X7w/pWAl5KOcH5dAjnEDR9fFsvbaqUS9BulimH+wGEg44mVap/NYiFYJg+D51EPQD7cRxrQQPXlj+37evsNF9jvuxnp6ytg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yQsBTO/y59W8yGeoNyhmLQqcuAxvvjw9iCqcGl8b2ACZzAoSgSp27YZ7ZFZsm4dbikIdT6zZS+nZHMXOtMP+1tXw7xHA5/md08HA+Xp0i/aOzJJsN9nPAaDw/4FX6l25Fu8iwNDB1o/5BFbEc/yYB/ZvzrRtJXOq7gBmR+aPi7TAIgDgfr1SiBcXMDGKKb64MeKqVS5+h1lexqwVueiiyytKuLMZCFLL3sqUmH7mJcUWHSGk/guqVPt39N44U+gBIsF49Q52zkDrKYXBYkgCP2/AlvfWvO154UMdz4ZoZ/ezhfHKH6km6kvM4usjwt8/dy1J1GXD2GiHdrA3lWzxvis35tGNHh7F7VMUruYd2O7yob99WT4xb1LJs72m/o0RoU3XbZuTxMEOc/b8mG1lfPT9zlxPSWM38dCFlYByBvFwB3r9+ElXZ5UOt3sA/baH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:47:52.4976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff1265c-f255-49f9-5655-08df0911ee51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8578

From: Shahar Shitrit <shshitrit@nvidia.com>

get_fec_supported_advertised() populates the FEC modes reported as
supported to userspace. The MLX5E_ADVERTISE_SUPPORTED_FEC macro only
checked MLX5E_FEC_RS_528_514, causing devices that support only the
other RS variants (RS_544_514_INTERLEAVED_QUAD or RS_544_514) to not
advertise RS as supported to ethtool at all.

Introduce MLX5E_FEC_RS_MASK covering all three RS bit positions,
update the macro to accept a bitmask directly rather than a single
enum value, and pass MLX5E_FEC_RS_MASK for the RS entry.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h    |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 12 ++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index fa2283dd383b..53dbdf77bcce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -66,4 +66,8 @@ enum {
 	MLX5E_FEC_LLRS_272_257_1 = 9,
 };
 
+#define MLX5E_FEC_RS_MASK (BIT(MLX5E_FEC_RS_528_514) | \
+			   BIT(MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD) | \
+			   BIT(MLX5E_FEC_RS_544_514))
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f285ad88b6d5..3ed59ced0407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1002,9 +1002,9 @@ static u32 pplm2ethtool_fec(u_long fec_mode, unsigned long size)
 	return 0;
 }
 
-#define MLX5E_ADVERTISE_SUPPORTED_FEC(mlx5_fec, ethtool_fec)		\
+#define MLX5E_ADVERTISE_SUPPORTED_FEC(fec_mask, ethtool_fec)		\
 	do {								\
-		if (mlx5e_fec_in_caps(dev, 1 << (mlx5_fec)))		\
+		if (mlx5e_fec_in_caps(dev, fec_mask))			\
 			__set_bit(ethtool_fec,				\
 				  link_ksettings->link_modes.supported);\
 	} while (0)
@@ -1030,13 +1030,13 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 	if (err)
 		return (err == -EOPNOTSUPP) ? 0 : err;
 
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_NOFEC,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_NOFEC),
 				      ETHTOOL_LINK_MODE_FEC_NONE_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_FIRECODE,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_FIRECODE),
 				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_MASK,
 				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_LLRS_272_257_1,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_LLRS_272_257_1),
 				      ETHTOOL_LINK_MODE_FEC_LLRS_BIT);
 
 	active_fec_long = active_fec;
-- 
2.44.0


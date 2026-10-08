Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010025.outbound.protection.outlook.com [52.101.201.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E20549E5C4;
	Thu,  8 Oct 2026 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466171; cv=fail; b=dyKMqZ1n4ZEJSOYulHLHk3GpjXlN8R8sPRnsfrJwnob3tFpzIVlPqVYDNOCbRuZrHYENreEHmCrYqeCJTJWQMFFNV78B26pxHxjbD6ZUDPpK88fH0potzKtI6lnwwWXAXlsBq/Jo3crPnKlZ0Q1qRD4rtznLA6YSmCxhGl6r8lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466171; c=relaxed/simple;
	bh=+5snryIGRI+gNVv8RwhBqb9+uPdqzmKm8rfmCgM8ykY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5VQiUZg52RBPHxeuUkDUbQBBc2DnfUWRZpGuK9DdEdOL/hzuNBnQlb1sEfdOqP8JyyAMLxtCwMeI0VCb/cJXCUvWT4CsVnZ52aBWfSmuV8lKgRN22TzOaI7TZqz0d2aPSxDqS6TEmhMBVsD//ioJxL0aDjqknOruBcsV+73gmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XrprKBGq; arc=fail smtp.client-ip=52.101.201.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XrprKBGq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKgnvZuUuaYcaJLaTEzvjxdkHthf8rC7QjpQ0dnWrsXKV78GfYO2zHwDvASA3iZDO/MglJAtCW4QqjpqEjJo888vHYm72mVR0+rG9hiZZALM1jHbC3uU5j47MV9pJ3/OZJe/qyIesjH/4PJAs08TqulOl1ifhbXZPGhmGxAocHlDYTNFXsproixEcNJhrhkxnR4lIyQk3pZj245o33/PYSF12PxJwTfa02KQHS4WjksOZP7pbK61PnlpQcmstWE/q0vlZusktZBblARHv8DwZw3Y49x3yuGmWMwORL1kkRc00wPs3GOYdbJlDuJmj6Y0EWdvohQKda9ZXEhUShB9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTr3KrspZpwpNzsRr5j3z9uZz6Yq6uR9t+MBOKmRSPQ=;
 b=J+jhfY9t68QIYD8Z7Uqcf3aCCB5KHjNsVkAMGBFbKO2Qw62prcJa3SLgBArUfLvTw2m+EJZHwoUBDGom0InJ2i6BwSoCjIhlznwIIYE72e+DqqmlgOyfA9ST463LquqhRJLi4OnVcQn12q/o8OwAxZvEazXqYdKGAjJuc2AFjoDK8cYsZGn5xOEleexizRo+03henVMEemjFL9CSRDQLg/nzANNRvk90+24eVPWEboXM92xksP/mbQsEdiuXlX0YW0gQrz7pOg7HlcHhdqNH/GPxlTN7iBXpop3rsso+Kert5c99Owcl0BcuQ4WrqVYKTuNbjnGKNRNIO7zu0LkSpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTr3KrspZpwpNzsRr5j3z9uZz6Yq6uR9t+MBOKmRSPQ=;
 b=XrprKBGqRri50CODJsZMRCf6tvmHQu9IlUyjUMZuuSLkOkF+ZMqK+vFR6URm0Vr7qYMfVdvHFy5LUE7kd0EiujgmZgBiMoHhU5qdex/FloGz8DOMF0YThqQ7elkQh0EOXrVU8Tfa75+YdtKJmsgbSa0M+6aZ6nEPSbm/5QtCLeC6HrF0fEcrt7XVxZ4xoSvyVoqkI5qcs+QzrDgH79rxKORh94ELnNWiocBI+wEp5t8uZwa86xWrDRTaMB7qLAc7M6k4ewtbCnc4SD+GR5my27fZlpwCxsOiKqQsWanZR+Wjjj2+HnGamIeXyKjJm3BpdC8G7CPVImOPsCY7xO9IOw==
Received: from PH8PR15CA0022.namprd15.prod.outlook.com (2603:10b6:510:2d2::19)
 by CH1PPF7A6EE32B1.namprd12.prod.outlook.com (2603:10b6:61f:fc00::616) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:29:24 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::2f) by PH8PR15CA0022.outlook.office365.com
 (2603:10b6:510:2d2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu, 8
 Oct 2026 13:29:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 8 Oct 2026 13:29:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:56 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:56 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:49 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 04/10] net/mlx5e: Add data direct ethtool private flag
Date: Thu, 8 Oct 2026 16:28:09 +0300
Message-ID: <20261008132815.654147-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|CH1PPF7A6EE32B1:EE_
X-MS-Office365-Filtering-Correlation-Id: 084a716b-f554-4e8d-de52-08df25402a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	fL1pqgctHf8aOLmmtRhh2kjzB87SaDOhfB1ycLTCZyLWRTo4VWRgKBVcn1kf31zr3eq4z8vzpTFaQ8J+6NVj49hyI18oQz5L867BHCFt2KaWD2OaQpnDSXaL35tZC0tViSyP+SezIETao4V+zj02VCmTL0I+/3jREmXjZAtqJrVYCS4hQIF2zlIKoMPo/ue/NAxfk6bGs+eXTx0Dulo0LuQVjKkD/ZNT4xZaVaESsaLuvQoKX5af0wB41Oxj98JlNlLmidwsStRqwNhUkDjRs98gCOePDmdiJI+G+taXM+jVVP+d5Pw72cgFsHNQG+4k/u36gzSPceO9aPgzj6IFkskbeMmfYXcTvwJWxSAheeShYXh+LKj7F+Y4cpFEd86X9s7zE7wN/1/YitML3yatYx0WWfcrigLTQz2be2N5yoOFyDs9IJAzYX1hemrXWwOkBB7YdSkX61NJeKNvr+mYEW9aR2BE510cDFHjLfuhjy/phBVDcm4lzkXRty3mcYQqAETlmElOKiwg6wejoGzMghxXH/yE/T6Wpd141ZXmN8cgiY7kKn9Bt4OOOL1iNCATCBsOKFdYUHsRo1SdFSz09j37v8BmIQQEIP+qKuS3AK/VCqBwVZCDAknS4xvvLTW5M8u17PjV6aC1gYcBGTWXcPHHoC+PlrDBUBhujbiECFfjfjd6+IN8nsKhBTfP7a5b
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wyRo/P50bSEVS0w2SiEM9zy/PoU7GbvDcktS/N+jnhp1Ie5iPOJESlvRL0txmQ+2TqbPnqHkqAe8O+P23gKgLk57z3lmPmqrxVTfFgpUKHZdNWfXxZoaXJgzqMTogSAeiQ8TFT/lL3nV+7pKKOqshLar7Sahmq0+9YDDXoI/jkPYHcLV9crAI9Po3PKU5vsA7xx9+Q3ylt8BIL85CUv0yrL7dIZcrNdQRBjHoaKH8dUHDl7ExqkSLiLvbwFdvOQf2vgwrs9b+DF8xWWzp1AlbB+ce/ZflsKtIhgodJzeNGbl/SEDPd3sfEYGsCt59nQh/YuumV2Tka6AtAaePKzRM+7EtqshuLljgVqFZHiHAp2Lg8s1Y6P9pr/5grwru5sskikOJq85mpUKVrYDqVEXegFcBBSeAx8vKHTaaWAkwoLwRzwwAUXg8POT7+g8QWVG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:22.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 084a716b-f554-4e8d-de52-08df25402a64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF7A6EE32B1

From: Dragos Tatulea <dtatulea@nvidia.com>

This patch adds the data direct private flag infrastructure.
The MLX5E_PFLAG_DATA_DIRECT flag is needed in the follow-up patches to
detect the configuration of data direct from the user side.

For now the flag can't be actually set. This will be implemented in a
follow-up patch once all pieces are put together.

This patch doesn't introduce any functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 000493f42912..c5bbe5adea45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -264,6 +264,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_XDP_TX_MPWQE,
 	MLX5E_PFLAG_SKB_TX_MPWQE,
 	MLX5E_PFLAG_TX_PORT_TS,
+	MLX5E_PFLAG_DATA_DIRECT,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 261c466a4d36..b3eced1dd43f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2400,6 +2400,11 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_pflag_data_direct(struct net_device *netdev, bool enable)
+{
+	return -EOPNOTSUPP;
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -2409,6 +2414,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
 	{ "skb_tx_mpwqe",        set_pflag_skb_tx_mpwqe },
 	{ "tx_port_ts",          set_pflag_tx_port_ts },
+	{ "data_direct",         set_pflag_data_direct },
 };
 
 static int mlx5e_handle_pflag(struct net_device *netdev,
-- 
2.44.0


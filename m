Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011051.outbound.protection.outlook.com [52.101.57.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03CC49BD79;
	Wed, 23 Sep 2026 10:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160036; cv=fail; b=f3snUiZjIcpW0cnX8J05zIyuSmufUCJ1aLqqvtKSMJVesRAEjqODoJU7trj5WIFXfaLtpkwBIMynYa+O/bAT9cZpGjlr+kfvDIGRPHx4eIpJKqlewAk6Li4W1roktKxEaqUrD3bDY0F2g35gX6BNPQeDz4ymcxRJIGFydreS2z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160036; c=relaxed/simple;
	bh=RTmosO/ZIsOFYZq/kbGxxK7Vo+cwoLf15luQg619Drk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELkbWdHs9t6K4FX5UVpzIMFm29KWeMRLV8j9TGbVUcekfDkPxcOFBvFXXxSGe0oXHgAJ4KpEdXmy8JeH/+VPkFqphv4nI8logzDR3vYiJKLLPuqFJy8DvsCM9Hh8VTv/tlw2cD4cdor4f/3raKVnig31SIXdPdiOaRGN3pEpBmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KDw25Dn9; arc=fail smtp.client-ip=52.101.57.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KDw25Dn9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e49nt1+xsM6MfXVOkrMDZ08/M83tn7clqGuqg76bLLltinAVtF+5kJew9ooIYcmV8MLcdf5WhAsh1kk/v+bO7ISUvGf1HwxBOFU3wvOxZ/1EMYFIfktMKnxcfXl1OurPLXmqrugtug3SXPgsywQkl6D3DqR/HjXWSNK3rct5iYLQc49UXw8xKrTtKonqD+ddwTwh+jc5p/841vuV/WsZD6NxnoaClZyxLzKqwXMwMo3MtIkcKyOzAGnKKUxqmlKJJGXTYfxhrx1gKdufHLAof0IsBDp07OELBzkpGpCsHQ1CyqgvNGE1AVeVT7GNJ46s9JcN7IZG8xPlzzt0cCt+6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFCEI3rIp76JJSUxHFB359by67sTKrPGbglg9QXRBgs=;
 b=bisEOqRD/JwYXT2Nom/GE36HUR+QeD/wb6ZtCywZghkUzSB63FXA5Pa2/KDPe0k6JXb5+RgDm4UnZyneY+JSpH3GevEqWNd8CPmiI82/CSovG71hPv85EbydeOhKvkyEIfNPec3X2ZrW0+WO9raD/qy+sn7+VKlGl4Rh0k8MCudMhIXXFpn0w5O+4E97vT7t+d/RQIkfKsC7vKQVoCgIqWSQGW0y2mbItk9Za3sKe65JMEfyQbDzejgyGKjZPbjgSk7bVY4hYaIsj+paexbU5Z4uIxNMr3oAExfxsSxDALGSCyW//VBG5gXWfdWLaX/xtBp2kmhEDeJLeJww98REAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFCEI3rIp76JJSUxHFB359by67sTKrPGbglg9QXRBgs=;
 b=KDw25Dn9N8fcs4LrpdDq3vqPKStGeyymYY+ekEd28txn9rYEJUD/ZDlJMzguPvhKJxm1VLYdn6D5ax8/VKqO52qyc3yNQ/qKoKC5AwoNrY555/WmOI5EgCyF4Co8IClHRu3k0joYnY01FsfmjPMESYLpX1Rds2i9JnA0EEIgJmynheKaIO6IFtzMrEkIFNGzZ8DH6zsyL9s72Wpw931x9TFV1yvJUckS8kwZsr6njaeIu0BJsHdzT4+J+bcvMUPOZoF7G5x/KVeALiAg+2HkuQvPfgibAlUc6/PmMEQ/Km/+ZT5Zqu3M18xEPKdWKeHRKDha7Q8xgETr6Pb4OZfStA==
Received: from BN9PR03CA0650.namprd03.prod.outlook.com (2603:10b6:408:13b::25)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 10:40:14 +0000
Received: from BN3PEPF00022BC2.namprd05.prod.outlook.com
 (2603:10b6:408:13b:cafe::5b) by BN9PR03CA0650.outlook.office365.com
 (2603:10b6:408:13b::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Wed,
 23 Sep 2026 10:40:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC2.mail.protection.outlook.com (10.167.248.213) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:39:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:39:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:39:54 -0700
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
Subject: [PATCH net-next 01/13] net/mlx5e: Assign a random MAC to any netdev with a zero MAC address
Date: Wed, 23 Sep 2026 13:38:18 +0300
Message-ID: <20260923103830.1183-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC2:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: ae139a5e-609d-4785-e4e0-08df195f0cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sff8cgDICMhGD1JBJ0ULIgWjsDlZhPIi84g5Djj7therGNikeeWsEP6BURmvwLRgsQdnPQEJKWrut0MJI2dw5SCViqpJOM1z7ZHFl+Fx/9AqqKVKCp+2jBKzZtKhtRGSHT7JOlOEimmV32Z2LS5iRwzOAhCGJEp8Z8hzjlVSx8k48pKAu2FqIYZkTwDoay0Btc3qctlCoStD5jsf0SDw/Q3hCkmThCaenZ++GhGwi6hmxAzoM62e/3t7aWIekXbNMpu8xZlKrEAodjfWkCcjLpYxc/rkq7OVxhoCYc9JqC6YGUtkHNPnRSvSj/fC0Uic6fHGVJE4Vx5lNXxtn5SPGskCpTFZy+RyLkiLgpBl6FdAcVlV9vaJQ+RLE4gnGycWdklYPMfVVsrBrmTPCLzlr10Ug3TPIgFQUIe+85vZtxru99NFA9mfbkQsjqt7yWn6O6Ez+Bw3JUkfqQROi5sCVrMVbDnZzhioU4aDKh9W+iAeJAa+uI84TN0kxvq9w39pkhsY4Cu3tBmaBqckmEAHxmMieyMZIMUke/uu/jzEuulYm0tSwFAGXJq0rEjM1P17Zf/oGO+Gz5s50jZRXCNNbawd93TWEhiH4AOqjPlW83k7ikWVCdkGNV1w+StVwNF4GN7E3FE2FuH8QtzPsoiR4WVIgfFCliHk8N1w/0gpngMA1ZCbkJET9kQurfKgaEND50mFj2daQE1XnCCm5/XPHw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rrPTzzEaBPZclIIAB40YNzLYefliXhUhjYIf2P7fUZOnwv3TSThKy88piwtg9QEYjImUHlAwfV5ITBeTl2bHYaI2b8NR3dXtfxQGEsCQnddq6+Rjuyf2H6Esfa0REUeEWme1tZCBpkz9qkfsqu6RnZExBOprwMQL89o4otcR1K3RK76/6h4EULt+RRRwWADxSgEbHsK19Erapi2fIeToOHQzF3eUmPT8q89f+YGSZcsKAZgpf51Wk2rKpKXaQS+klcroIDhhMI38prcnDMJz/l4Ael108xjjLCM6oMvxlR2j+LiRJxQ9QPN1McKsvsTDQ+VoP724F6nA/0wYpPMLxy/KqgV2pG5zpPNVIC+j/kTnu1tv0P4XbblLSsWy63pYhWz3FeNxo/3TVOdJZF53gJfP/N6wC0fHgyUOR/wBUYy2Dci/DJwf8Mjbd5y/PmiS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:13.8211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae139a5e-609d-4785-e4e0-08df195f0cf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087

From: Shay Drory <shayd@nvidia.com>

mlx5e_set_netdev_dev_addr() falls back to a random MAC only when the
queried address is all-zeros AND the device is not a vport group
manager.  A vport group manager that comes up with a zero MAC is
therefore left with an invalid all-zero address.

The vport_group_manager exception is unnecessary: a zero MAC is always
invalid, regardless of device type. Drop the condition and assign a
random MAC whenever the queried address is zero, so every netdev comes
up with a valid address.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fc110a7d16e8..b0765f07cc3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5430,8 +5430,7 @@ static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
 	u8 addr[ETH_ALEN];
 
 	mlx5_query_mac_address(priv->mdev, addr);
-	if (is_zero_ether_addr(addr) &&
-	    !MLX5_CAP_GEN(priv->mdev, vport_group_manager)) {
+	if (is_zero_ether_addr(addr)) {
 		eth_hw_addr_random(netdev);
 		mlx5_core_info(priv->mdev, "Assigned random MAC address %pM\n", netdev->dev_addr);
 		return;
-- 
2.44.0


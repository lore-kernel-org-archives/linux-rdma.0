Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC7D4D0CE2;
	Wed, 14 Oct 2026 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982125; cv=fail; b=Io6FjuVtTDsikDH82gdblKIf6ZP7bviQNq2mMRi3VdgHueVPd0eNBAGy4rVZ3BU3YckWJzslDT37aizQl3ElxGEAML6nJzTNJkHctDvntFCjRuH3dYNSKRrS0SKHYFzXJk7OR6EHG8TByR5Bbuo9mzXgiHSpi+ejbYChmxkWQ24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982125; c=relaxed/simple;
	bh=UYlzfNUCrXdxiGfHGen/aXCDgbs0d/xDeCRr0srvuDA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o3QgNwWgo/7JJYa1GrLe9CqQvyhUHDZ1hEKL1p0N/VIoKhVSVN3vYatLN8jbEiVrz7QXKK0kYpGCk3IHpZVWUQ8pkVya0Mhq1o/C2xk1F1JJlmaMaSrYh9j90hai9b8tXSphZob81IEg99csK24YN0DJ7kpJsER54TOwO+hL+iM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PZ6O6/8C; arc=fail smtp.client-ip=52.101.61.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PZ6O6/8C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBxWZzDfMhnroePGQcRdV84en021fjYgWu86sOGM1WELzbAs7/Fz2cdv/8fxlonugJ4kTDMzAkRJeW+Qtu2u+c4R4DX9OHc6ExiRvWEJ9jMvn7tFqXmPY9DubhjJ6tIMKdsw1I5cwy6FshKlhvVFiPvBz6XVkV9y/fUEzthq4iQjXn67Fxap518E7t3dJLh/zb/3HkxsQfulnlmf6pdbxYPtFAqHBQJDGMr9GJDeUzs2Hvouc6kgpVj90Rlxsv/QhFHDiO4DNThpxjHLSjuYaqY2fQanQmCA9AmruvtbfCk5sib1tqHjSh2AWt3qqsv96Zt/rljiETb3iHjuRJVdrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=essQg3KQF9rkha8A9ELCLAgwXBzMYMImDwlkWSAecAg=;
 b=dgM0Y83Y5SH1scuRquwp1h84Th0lyNyWIIo0IiqQ45Wro4zTmBbOLlqthCL00ifbzlCORsT4tL88FDYoc1HX4p/+1RgbadiMAil0l7hVT8I4/nHvu076DmT8Sk+Dbi8nZfKc5E7R5qqGsIk+Y5ItaUxMJuors3XeqIofGbIMmOJ+SFRUZm/jUBlnIvelr2nC44+kkogQZNFGF0n1ofI5OcRFFCkyDuUBuVBliOaiCNhyZoZxM3BlBSm5eEYwKyKbRWDNsLMR3Pgjc20dlujb8wp1qg1uo+7LHeOqIVGPg8a2/lWeQ9i2LsjSIUyR6EvTnLqn6q2xE5cXwmPO6/h00w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=essQg3KQF9rkha8A9ELCLAgwXBzMYMImDwlkWSAecAg=;
 b=PZ6O6/8Ck98xKbqEDWk4qLdkrk419Yfetmyc77pM+NTOAvarMeGO78NaAJe01sTp+w8SwyRx04a22vf7Be2brI4hswooVF423QvbvXTt6h/R4VJ/RBZMrdgJPOfeSmWT/hK3Vd3gN8L4oxnmMIRBIytSPcFnK7dcyL9Wn53sLHCBqFztqMOIa36JZTHmR6jbuCzdr0RkNxW7aG9uUIx6cHZ9HM563Umad2pb7RwQvzjiqfqeLL2rrQIDZigJO+5NwKFgy9BWKnHaCFnDMDlxgQeKM5K1lsm3vkX/j3BWrB1EN31zm0p4yKgWuaoput2M5mRzaurNtzFVMhClWZhIJg==
Received: from MW4PR03CA0030.namprd03.prod.outlook.com (2603:10b6:303:8f::35)
 by SJ0PR12MB7081.namprd12.prod.outlook.com (2603:10b6:a03:4ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 14 Oct
 2026 12:48:11 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::25) by MW4PR03CA0030.outlook.office365.com
 (2603:10b6:303:8f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 12:48:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 12:48:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 05:47:46 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 05:47:46 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 14 Oct 2026 05:47:42 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Joe
 Damato" <joe@dama.to>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Nabil S. Alramli" <dev@nalramli.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yael Chemla <ychemla@nvidia.com>
Subject: [PATCH net 1/3] net/mlx5e: Sync CQE moderation pflags with coalesce params
Date: Wed, 14 Oct 2026 15:47:02 +0300
Message-ID: <20261014124704.1017782-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261014124704.1017782-1-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SJ0PR12MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c305480-2ddd-4b4f-1f34-08df29f16789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|82310400026|7416014|261009223027099003|56012099006|11063799006|22082099003|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6JsOtGAzUJGiSrxt1whtcqz9nixkAFPA5cCN6yRKEbUpjw53raxfadSJF+9LcTeyoSEfBDUoWlfeFemys9F6pooV51hRgZHs3hx+d33MJ59oIweG9uSAZ4oi4mzkgQA3s5vGCTRayStMV3O4mDPqW2rW14LwS+RyVgEknG3CyR09f95CTTB78fcPVj3LsP8d8kJ7BX0JCzCVDCnmVCWmEOV1C6zgFKN1ZBy4Z6AkpoGD0zrhUO517a5GCpJGSF0KkCbjt1O9YJvQ7yCnq/evx4BvlZx1DkPgT59kt01Uj35PfBFT55YdnZfnU1ZylhcBbzYoa4kB2eJF2TlWrxUUTXSsGfTdouxZzeUFUOCx2cbbs9yaFxJ4xGKFJ64/fq6SC4KubfM7yL4Ayjtybb5fNreQmlAHpBuip32GpcRAtayTbGQhF2klRklSAjzTaNWXOq6BwQTn28vnw7d1SADIzPl+nQJMvknlpqo4s6OJ21ZraSCJv69jdRYAfkQ5L7vFfShy+CkoIouMM6nkGyodrMmkCq8oKybijvD5dacAKcdC6IcyDBcosoVcTLYTyXY58Q7sBcsbfAwPFgw8/Czb+k2x5hhHJsRQMHN9tfAFf8tUP3NNAcLOxK0TbCgZNeRZ+CuNdKNcRbnHSAnk6/aO2escPOYVM9jKdE/scI3/+tTXknxk9B/2kF/Gk/rCax0dd08Y6MBz365kVHK15C6vIQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(82310400026)(7416014)(261009223027099003)(56012099006)(11063799006)(22082099003)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DU3FRHqvr9eNAvLgCRUR60nq+c0ww/6Sn2HKdbneSc2GKvEedfjBx6J5404MODUQ5V+0PHTQqbPt4XkfWAg9d70I3YHZwxzRfTA2dqjBXJOHn8Cx+pUjSJ1/Pt9EysGX0owaySjtbWXae9dKOIlBDDCcuyoxwiUecodmcU26HyCHJLxYdtmaAzOGb2tRmimG/MN9C9DlX+IBKkqSk3pkzYriBLuywp2PNQ+JsYE2Xl7xfOkXI3XuaesDci80tukB+rmNkyfS7cIUcfQe2EgPVrK+JRDclgxzDX/7Um2F9S6oZ9Q3MOp/2JMqU0YlVEkemENibPs3By9b4vsG0lGnIDIQxGAtqRhm7T5O2zFCzxRWiYppUUff96bFVE1cyVccE5fgTZd3KdHmoySWJInlkGVAllhOeohc7ylDbR6cyphG394/NoZ47EOtKFwaOnIk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:48:11.0645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c305480-2ddd-4b4f-1f34-08df29f16789
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7081

From: Yael Chemla <ychemla@nvidia.com>

mlx5e_params keeps two representations of CQE moderation: the private
flags (MLX5E_PFLAG_RX_CQE_BASED_MODER, MLX5E_PFLAG_TX_CQE_BASED_MODER)
and the fields rx_moder_use_cqe_mode / tx_moder_use_cqe_mode, which are
used by ethtool get/set coalesce. Both are used by the driver (ethtool
get/set coalesce, channel open, moderation apply). When they disagree,
CQE moderation reported value is wrong.

Such an issue can be seen on channel attach or reopen:
mlx5e_build_nic_params() runs and sets rx_moder_use_cqe_mode and
tx_moder_use_cqe_mode from device capability but did not set the
corresponding pflags. So after attach/reopen, pflags could remain zero
while the fields reflected hardware configuration.

Fix by syncing pflags in build_nic_params from the capability-derived
fields.

Reproducer:

    ethtool --show-priv-flags eth2 | grep rx_cqe_moder
      rx_cqe_moder       : off
    ethtool --coalesce eth2 adaptive-tx off
    ethtool --show-priv-flags eth2 | grep rx_cqe_moder
      rx_cqe_moder       : on

Fixes: 445a25f6e1a2 ("net/mlx5e: Support updating coalescing configuration without resetting channels")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4c6060d54fbe..9fcea0395137 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5407,6 +5407,10 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 				 MLX5_CAP_GEN(mdev, cq_period_mode_modify);
 	params->rx_moder_use_cqe_mode = !!MLX5_CAP_GEN(mdev, cq_period_start_from_cqe);
 	params->tx_moder_use_cqe_mode = false;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
+			params->rx_moder_use_cqe_mode);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
+			params->tx_moder_use_cqe_mode);
 	mlx5e_reset_rx_moderation(&params->rx_cq_moderation, params->rx_moder_use_cqe_mode,
 				  params->rx_dim_enabled);
 	mlx5e_reset_tx_moderation(&params->tx_cq_moderation, params->tx_moder_use_cqe_mode,
-- 
2.44.0


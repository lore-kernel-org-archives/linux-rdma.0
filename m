Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B93B47F6;
	Sun, 11 Oct 2026 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718180; cv=fail; b=SnwdZqJtgR6wIICc3QArSWaZw/mAXZaZdZDrrJdCMj5cDEVkcN8q2GfNxZquQEXIkaoNdAUD5v9aWM8wNV8wdQj+J0ktwL1Ndrutoj3AF/2AKYM7IS3SKgvK7EnfxBkzy7wQNvK6MfBF0u+OOuRUjrfpl8o2F/a0HakaXUCQ7w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718180; c=relaxed/simple;
	bh=Drej+MgWv3zSPEiNaha1pXmvJfZjkO9sIrzKbkNJcGo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyjpwBPYBEvDfWShD6m/Q+dXPWZzyqdV+5uV1N3w98OCDFx3V5EmLkARc3QC8xSSJdGv5rnfOMFZDjAoWE/ZeA1SztWU/W91lo4DQc6d+PDfirzpl7SkVgsw/pl3cPMEBnUik2S6QlrkNXYn5+uXkW7ZL42OkrIZL7i1TdAAKTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KPXjoF5P; arc=fail smtp.client-ip=52.101.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KPXjoF5P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yHRT5tLRwtqbPjUMjKG/SL+mr2w85F/bkhbZ8h5SOPGFX7J+Ceb5QeRic1O10dN4P+OMKd90xRElPtB7/x4OJ1CsbwSVLxXvKoAQEKglNb+eDmSagY9HZepuOwQKXRTPHM3Tx7nrWBtWsBKf5qBFVziSKd+BPisLyvtS0xiJO64dki/8JFzLUM9MXeJ7/i6NR4Y+FYXv1vOOvcBmVwPppgoNZEAN78Nf8dmFavxbLAXyh2lfz2JE5S7q9KDr43/cARSVBQLV9FT27SxWB2LjpcSCuC1GdGkqA1NYt+esgwNqOHk6ShsLmpaeAS7fq/ZnT9p6b4X4IpOEo37WurWCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8micnnON1BzJNlZVT1Ijjf065vPZQmk28QXY3EIAIU=;
 b=AQ8dCB5h9zu5RTEjwLu3iYyksF1Z284xMQcVclQeh/tOsMVc1ilSfBtngDWhLK3TIAyTpdqgT4FRhIOO8Ip2KpSBmheQctKxSwcqgsAxiOB+ZEJXu7UI1tAdDVWOJBVx8pPVz7dQGVqunhFhVeg+G7Wc/kvouCKugfR267jqCo5Fwajzg8/qvvcuLcdmWYufzk1clVOqMA+EakEsSCVsLWm29LEC4Ot5M4YLcFwP0So+LyB2pcxZcHCNiAAtXxFe2yWBz4mjHr/XUn7rtf7pwaBEZyX6d9yTLv6BMs5h580GzoMGHskVhBs0PK0uI49EvlMg20bT3k0QrDXxb9wcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8micnnON1BzJNlZVT1Ijjf065vPZQmk28QXY3EIAIU=;
 b=KPXjoF5PigCtttxoQjffKuNZOm+ntYl+IcJaNmz8G4AFpkfp/8KwXgnN3JsKa79JPTF6u8Tra4+BiVEVcEdSYXjmCKMq6/oC8jET8Hytfuqe6x3qaoKDB/UfALOA1PB5GAQRHcwu03jaZze2TIyq5Mief1M/H2Dxg/Gr0xMYISFTEHGE7s9ijEH+gVuEgVhNk7Vohvh0QBuJUnMDzWw1ie6y8KrWLSIjIh7Iiuz3Iqt4uT9RFMXz9QhZyyFacNIZCYTSA4A5gcfFwGfjXJi0G1fqoFOPssIgBcESA4G3x1ij65FSlEWZ/e5AW9kXNcQScKTnOAlhyosqDJNN8gn3ew==
Received: from CH2PR20CA0018.namprd20.prod.outlook.com (2603:10b6:610:58::28)
 by DSVPR12MB999149.namprd12.prod.outlook.com (2603:10b6:8:383::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 11:29:32 +0000
Received: from DM3PEPF000265BF.namprd03.prod.outlook.com
 (2603:10b6:610:58:cafe::14) by CH2PR20CA0018.outlook.office365.com
 (2603:10b6:610:58::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 11:29:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265BF.mail.protection.outlook.com (10.167.23.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 11:29:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 04:29:26 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 11 Oct 2026 04:29:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 11 Oct 2026 04:29:22 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED support in setdcbx
Date: Sun, 11 Oct 2026 14:29:00 +0300
Message-ID: <20261011112900.802150-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261011112900.802150-1-tariqt@nvidia.com>
References: <20261011112900.802150-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BF:EE_|DSVPR12MB999149:EE_
X-MS-Office365-Filtering-Correlation-Id: 41435df2-06a2-4330-e4f8-08df278aeb62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	F8NN4usqNq1IX8rWuqfMTYFkYj4+yN9T9324fFjGELzYRTWdlpnFITYaoljFWPsP/M4z4IJNW8JwDIefOeS/sYR1n/LqW7ZYGb8EtY4BMdVBh9Lrs0o3WIg80+H0y9jEbFJ+6MTIea6w5wzSknsMGLQ7e2f/QsGoKOJXbyRji532wG9jwVc9HIeG5Nshp5zATVgOcOmzde8o1GOB6SKTM5J9iRNfDzioKlIde/lJ3XD3BPE5eQz9rQl7uu43HR/gACmf4Sifpv/xdtNEJ92gT881Dd2ihuxpzx4I3uXXpVS015KZwLJtOeSe9/hSjdOhZtRJx3uT9lK93phvOuS7z2Ganly+PZ7xVQ9zFeR7bmmyrjBsy6SsRi1KoJnMzHcwPAv1ZhOLGvG3OUXOpV97sOVw7Jhc7i5M4LlmHnhtwy1bLknroTGPbibNmspiS4IK2wRW2o/Lfy1pm51qAWq4DmZbgTcm9Q3JrO5FGTu3BRJs7EaeXcov3ZmeuWWqguCH8x+zLXf90WEJY82snz8qMDb8juCDTJW6uCIm29XqXhwcqBcVW/HH/2TiVHBNPAaYkDCQnSvuoqxcYIaaa1pMcaTN2lcZPR/uqLyg8svFsRSY1zrRw2RSpoA83IyJUV06uWryQm5hcKnmgDjmkEKnWum+gLMVsNkDNOL4DrTOqojinatOYgoRnumwoqIwOQ6TxFOrGRP7ATkgdG+YWnZEvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TgG88e9Hmxdf8LrUTDy5xl6xBpmBQd5CscxY3FKIgPjY9kIhI1vA5uTu9HdgFym8M6GXv/3ZHV5O9w4bUoAZSBaWBb9PGBAtsc3t/i0oWW0wvp7kPmSL+mmxjR6mXS8s37VRe/F/lFZoHHHFM3fFReXhRWs2ktphX7MuIYNhXUz4h4oFbIG4teizELwC5yrVvoHw+z4iz9spjsc1uBnvm3VH/IBtq9n4RiTYVkaCPENu0h0Zgp0vGMZqYHFe0t0R+AD6XytxyI9ODQCrOxcWAyA1jsvsHHIZL3Ol/6CTrMevLMVsC6IJ+/EHnr8LChBqJDQIEtEofJpE0LGJxuteL94IzqFixZoj3n842BHwxVVRxAgVHrMt1UVMIpp6CP0Kovz+YsBfCAf1uFLiOhGzj6Dt72sbPmFMdqIZysW+L5F33nS1Cr1dEXLzlt0kedEd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 11:29:31.6644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41435df2-06a2-4330-e4f8-08df278aeb62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999149

From: Alexei Lazar <alazar@nvidia.com>

Add support for DCB_CAP_DCBX_LLD_MANAGED, which indicates that DCBX
negotiation is performed by the firmware/LLD agent rather than the host.

When DCB_CAP_DCBX_LLD_MANAGED is requested, switch to
firmware-controlled DCBX mode.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 4eef929f5ae9..68deedb6f82e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -439,9 +439,6 @@ static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev, u8 mode)
 	struct mlx5e_dcbx *dcbx = &priv->dcbx;
 	enum mlx5_dcbx_oper_mode target_mode;
 
-	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
-		return 1;
-
 	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
 		return !new_is_host;
 
-- 
2.44.0


Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0AA49502D;
	Tue, 15 Sep 2026 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471209; cv=fail; b=tseV++uEdSv0cAYHf5cdi0aIpguaWvJeal7yirjqFcLvHgLg+JqF8/RuBUe7tQCOQ9rXoyy/3HdSd++BKDpUEI1YgkC9cD3xcFK46YJ/NpMnQlk7ekyjDhYLab+btDUpTqd3z/LVs0Z1paIGDZVhPwdBzr9bd7+fLVYT69BrS4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471209; c=relaxed/simple;
	bh=d/8shBU73F5s4hWV5FI8sNhFnV4SIs5KQrGxhZ2HnrA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDH+6NsMl5Xaaj026/PM1RerP8kRzTUlVGQeAKMxhIaZljfmAYeFTiK+cqlNAeJuunoNRcEQdrwNsCR5OEw0G3pBYsSQ9Ae0fCyl1t6DE41Ny7fBx2sqnWYDNEEff3D/FkZ4aZruyWirvYcb7h96JyZ0cua+stZXo+U4crfwNo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MdFXBV8a; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MdFXBV8a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUg1A3Ld7al4fKNZvEeS4fxuNrddjI0zA/A2nyiPfHN546ZVclWYNfXVSHawIh80/dGyGtf6RuWGGpCZxmptva7hvzYFlOeed8OdmH+UpKCbS7NW5rw+GPbsz0bVud0oeDnr4gH13BKbbYkuP8GLPVqu2YnJxk4iV1c51oNfsuh/2GW9+sZiZj0Cm5YxdJNL1dxO/mSTkSm5MGexB3pdHX45d99mO6Bxsrj/8SiE5JyNqsX/kvHc8+dMMDZo2cyKCj88JKBlliDwp/aqLYaowCW4mLaWGbQLexuZ8HiOU3IXXh5hWRpiFE27/An8qXJlLYhuTFZHMG7oMwdzEI01CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCH2MFEFmtiTEaDwA16ZdZJ4Ii+lXHEm413rFfJf38A=;
 b=CeCAu4hh5oE5auJGtr06d9n5BdiuGSQeIiY87qrJ52umBznfzZc19Xgk7q0uvg45TffBhrzD0I+B1xbjUQscywAJ/gF/Q6kv9t8o+/kqGrBiuk882oVmiuYEsZRbYay9y9jgprLbvEP37Kv/JqgTiqpZBV6Znzjq+mFZnMlOL2YH3By1462mYwECl5GDSFeuESV0FpSmabrIBlKBxaAtJSl+/tbVmfsgRCKrx0GA+plmIeW5I6PZDhnFjNEQOY3sIARqASUTWZjp0WkmfUk92/6RY49tPgdndyQno4MZqYmsbw1xdbLvl/98uh7wtS0PlJww++0KdRoBXDJhFhHrUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCH2MFEFmtiTEaDwA16ZdZJ4Ii+lXHEm413rFfJf38A=;
 b=MdFXBV8agjKaUJ6ZY+ldhlD3hERnglDaUdS6AKiSBLdpO8AGCZXVxNrm0U4B6Zk2ysbhmGZBG1wrGpWDvrOWD41UjMe0lpf/aEgAPeDTPsXlvOg6ll64B8+SLK3VLNkox/h4gfShSI30zn8J/PN+rRfOn0qa1j0GbGoDbsEKwF9QtExjujbMuEh5OIWv+XKb88i0VwQcM53H49El+Is0hkhl2DPc3+NzKgHt/dREbmvAbT2thbt8CFWmZbxwS1fLY1fihp+hSfLH1kWaywrCCcyS8ad4s0t/LIpt5lN/KJzf5yzTfvdcob9dD5vDXOAf+l8b93wr3cRrYQvKWWs2Ig==
Received: from BN0PR04CA0168.namprd04.prod.outlook.com (2603:10b6:408:eb::23)
 by MW6PR12MB8759.namprd12.prod.outlook.com (2603:10b6:303:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:19:59 +0000
Received: from BN3PEPF00022BBC.namprd04.prod.outlook.com
 (2603:10b6:408:eb:cafe::78) by BN0PR04CA0168.outlook.office365.com
 (2603:10b6:408:eb::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 11:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BBC.mail.protection.outlook.com (10.167.248.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:19:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:41 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:41 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:37 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 3/6] net/mlx5: HWS, Replace kzalloc with kzalloc_obj
Date: Tue, 15 Sep 2026 14:19:09 +0300
Message-ID: <20260915111912.3926585-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915111912.3926585-1-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBC:EE_|MW6PR12MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: 722115b0-83f4-46db-eed2-08df131b46e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|36860700016|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fYfOVmS33e2AFSHvPzFbT24csQsbusadfbT3hRHJBRfEBmZom8ErI+y2iAxFkkFXJeLtrBM+npJXQ+yXbEuQ1OJ2Idqf0W9xTQshIPWe21JuPm0pFNGHcDliTCNk/R79afUBvqA/XfwMeWETOqAY3a4HzB1mPT40Klouw23Z9huADkekoAeeeVrtwT+quKDP8NvPuWVS84rmRnlnGrHQUrcvRHuZTTZhWKT4KvuvfZx3el6Kw8RzuFBGltJhO4BOZocHuT//Dlg1U/ug/CV7jLbzG8ILME6fr2/3JPPtXUJ9myLMIQT5S3uKQZnkiERoK1rqIirw+bknBTGEI/3X6csm9BREza1Z2kPzKRgDlSk99aFu1YA0s6p2glTQiEC0R38Xvufb8ppBlmtCxQii9DHMf9WAxqZRxki05ao7We4AkHpkk4viShtWneiHIrcKBMseQ82VzLztDretzflkse5EmEllgqpAq56Pfp/z59f2x1xFbulNkb+0Xn1LPpMN/wQFPO9LaO7vuukEPtIcqKXNcyIC+b9tkagawGWZT1MdwoCxBV5ilhXy/W2X2ahRP1MeYJyf/MwAUKlRaXFZhrsllIkrBiKSwgCg/y4DkOiGokhPnEuHDz1Lg7RFnA5JVUMDSAvc/9X2XjnzeEzVj8nMFcaEQY1J01i+eVEPdfYk5MNy+wlPYa/gwlhjljjOtx+b11cSgGDUM2ABmLPUBA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	P/39x0bZrM0LIJZCYxPoLLOh43DHuU8e5TGTc3pJ9+IROTAaH1VkcVuxomRj55L4VwiuXls6XvUR7ogKsNjBSOP1UryJfj2gQn0O627f3anyaXAfYgU7jpcDBq9CsqEhfPSOE5Smk4DTzTthxngZgjNwjM0kDF2NO1GSvzfKw+7wvqTuIILtUJEvXXuXopZbaGJK5YIbvIV5fjLSQbTGTzPth3OXXkw943PLgI2iuLBKSF8deKEycOFuXVWzvC+tjH/A1dny5qKLAsV7SlribE+IY+VjYCs/xhpgfXNBZ2d465wRI7BBKNjcOKRMo/dFqWAgqdP0NphiKPMKnbkawDwZPjjaWr0roEi/S0yAp4yYa5WkbXy4IZCgvpmeJ7v4/7+++M5L6j0m+PI725Ml0K2BnJ9MVn34MgHBhbceKiMmx1aSmWr0vRpd6YMzKmhI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:19:58.3031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 722115b0-83f4-46db-eed2-08df131b46e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8759

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Replace kzalloc with the newer kzalloc_obj allocation function.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 80cfd0ddba08..49dee44d0bef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -732,7 +732,7 @@ static int hws_send_ring_alloc_sq(struct mlx5_core_dev *mdev,
 		goto destroy_wq_cyc;
 	}
 
-	sq->wr_priv = kzalloc(sizeof(*sq->wr_priv) * buf_sz, GFP_KERNEL);
+	sq->wr_priv = kzalloc_objs(*sq->wr_priv, buf_sz);
 	if (!sq->wr_priv) {
 		err = -ENOMEM;
 		goto free_dep_wqe;
-- 
2.44.0


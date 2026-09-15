Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC2E486E62;
	Tue, 15 Sep 2026 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471199; cv=fail; b=RPz0WLrhsVIkceWBaYnl1JphmK1O8jphqGIW5Iljjd6HsTy/z5MwTj4EQJcrcRyOrSq9gOSESl/DBiYfk/vTsrO5xhLtn2RMG7Y+V0+zmoGWRA4CS9U3Kff15kV8MdG5pTa4nQMJk8whe46FgHGprjlOhp30WSHK6JxRRCJppuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471199; c=relaxed/simple;
	bh=zXXfrJYgUkmAYYO0l+E5ULTnHVFXfZUNYmAGYM1m1pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyP0bVCBxjy6Z2g/CE5TwNCKdG1tf3KWMqal4sw3TLZkcAYb53vwNPibrByecG/CNi1gjiAhgGH7ADIfFfvcExpjJgH3P2lo809dTre9SWbNWDuP8oNANCzb4+1yYaA9xGoKnfDevuLyVMrScT7T9Mr6j7klCc9yo0AOu0dI9mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tdQ1YVom; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tdQ1YVom"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyN+8uzeGjLkB7gOOhCAj9wF2uOIufKSaGG2g+TnQwhvRCjtsdEhzTEc4WNnO/ici0GZLx6yDwjIKLtWnKxCNKwR5p9J8eLF2ZcdzZQm5/wkFvUiwB/dgEuclapSctK41WbFkA58eCp36PgArX2lJX9rgO7WGorJ1+5UhBSSBoGKEM3gonmhIgRpZsH/NTOd6UNjevoAjAb82nZTFRskPaVZOHG6QvDOsAymOWrmYSty8Hcs7ldy4nzuZjWkF2lrWvJkDwA/pPyoNOJ+Khawb1zKpGBZn/kZepZkZCd0GpZCpC7dn5yYeJXDA30TD63Jjh/uVCduMGNQ3ETJqOJP6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjVu0NXm+G+bGHpRZ+HBqCzsgj0wRUb9CRP+f2Zaywk=;
 b=gU+ZQ0aDLfF67QggOGbfwCqdifl3quPwi/xIKJ+VgqakNx+jCDMee3Dgjj8ddt/MSRFUUGO2+V0ACJDIIij2jW7MjNo+wWGfGkwKzxrwKu7IUgm3O1JIMb02bobcrwFZGw1P7/8k6SWiAFHLATvX+vGREiqsjV+reHbnQ9yeMgye8IA4Dh010vAw7wsDpEEUTj6E2db46a7szT34WhtS0qgYw4HqexYHWbEEKLaPzTeWH8mgfGjOnuZQXezMTT0jJjd2ozJV2vnG9gw1rz9i2VdMSN5QmkMBuhJghkUNhHuKNOouh/FBLdtvasspi3Tvp9p+BkWy4SYHUHMUWoaZQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjVu0NXm+G+bGHpRZ+HBqCzsgj0wRUb9CRP+f2Zaywk=;
 b=tdQ1YVomrvPUCT/bjXJzDQCMg6Um0V+bsDOCfdY2jMFKhBR/pjifEFpUyQZQag9Wg8rrgmXK1aSH5n8tocfuM1NqndaCJ1IHMa19KSKTPN7dq/MZGFWqIlUUNjdSaM6DUSPLhwyfhBbtA438UGxKjvGqa3126IRzrLNsGc/7Od3zLCFebPeZJDkhWAV0QIlQ3q7Xy5vQTbKlHeTT0XJvRuUv+7EPCwXupVgj8t7KN77qSate1dMTu1LZpLaBdP8j1XInf/K1XcdXSW/ldv01VomiZCbx3ZnmVhTAMyI27J2Hj9PP55x/FwT2keDwsxb9SQ5o+SuQ5OWaDossM0IgcA==
Received: from CH5PR02CA0002.namprd02.prod.outlook.com (2603:10b6:610:1ed::14)
 by MN6PR12MB8489.namprd12.prod.outlook.com (2603:10b6:208:474::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:19:53 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::80) by CH5PR02CA0002.outlook.office365.com
 (2603:10b6:610:1ed::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 11:19:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:19:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:38 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:37 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:33 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 2/6] net/mlx5: HWS, Fix error message in mlx5hws_cmd_generate_wqe
Date: Tue, 15 Sep 2026 14:19:08 +0300
Message-ID: <20260915111912.3926585-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|MN6PR12MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 48785123-8253-44c7-c92d-08df131b4395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	LjHvs3EK+PN0vV7FGP01o8sOZlOIPOm3rl70AiEnH4UNRIOrj32IjFivGlY4jLuFlbNCYrb1PLuEIbVYAoJk4Z+MOl26SERUluPqJqEhLDcvJc8lZ+z0JkogrpsmEgOwNtpHpDlD2ob3RBwDJTbaupocrLyzURGPfrdUujFfX8T/VumKOVTte54QCTJkr2PMBa2pjbedtH64KhkcasjozRw7bsVaE3nkmJo8pYA1FlkRPLZA4H3YfkCmlZxqqkb1Sy7YI70e+MvWxccnFvxpoDN2E4xr7e44T5hz1P45RuHnSF8Zb/zIyLktD65E0PN4rPINfTHbxOs9twiPsS38cVaMj9L2EsC89EOaMDoVgpETgatevqqfrRAEkQeLbGJNHGGuLLmbyPEk5e6hzdcD4v7po5yMXaDyU8m023QnRFRGaKGdjTp3cErMXZq29G8EIArMR7WLJdz9KNxkUefVpIABhQFLcKDbma+vfzyS+fs0ayGIgL7eIZd9FGX+pIcUys7G+gCOVh7Ejs4GNWwN9yW3VghgoKXzYyjQx5+E8QzUJD9DjSh1+ZUFl438VjW55t897ypkSnpI6XseelbYNkTjG/1gRizNLWkGBxwG04AN89WvT59Y3ZcaHJQk5pZAmhbq+Rs0Yij24Nd2nFKFp2ETZrhozTDVMlhvNEMRxBKAYBE0e4nIKVV/DtU+VUghf5eXiNVz4xYcqsXfo14PvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CkvB0FUYgGYWQxs6DcvF81qG1tRGVaj9MQ6kYKstnsNLuLuPl1G2nr+1+pn+mzI2r2CEdHy2Z7JXYHrZOnodKJRdUz9tr2LUbeLRAKBMBNlHxVrCoq7vvuGm1AbZAKcvZW/VutoDHPM1dU188losgM/bEYrxFmNGKIHJtUicd/utgUFw7iveA3RbGustfFpLGQ811+ULCAE2cs+aGGGkzN6bVARilf6/SIDU1NXy1NSXYE4H8NQY0kLTskjF0Wkuz2lpwQU8lKcfbvw3FA35gma08i1cawPraOOXlqohwSNbYg+hpdtovRxiTy0aFySukz1/5J30ZHotdfvuQyi/ejYeRpj+rl4/ymg5jI6T+oGIJ1lOBdeoH/ob6LIS0o/gOUd7NatsqoCLGZotsZpxYavh0RkOHxIx+nsHzUHbKmu92uasfkxli71hPN4CQ+vJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:19:52.7492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48785123-8253-44c7-c92d-08df131b4395
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8489

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Kernel log messages should end with '\n' for proper formatting.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index ae3ff232c63b..80cfd0ddba08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1287,7 +1287,7 @@ hws_send_wqe_fw(struct mlx5_core_dev *mdev,
 send_wqe:
 	ret = mlx5hws_cmd_generate_wqe(mdev, &attr, &cqe);
 	if (ret) {
-		mlx5_core_err(mdev, "Failed to write WQE using command");
+		mlx5_core_err(mdev, "Failed to write WQE using command\n");
 		return ret;
 	}
 
-- 
2.44.0


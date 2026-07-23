Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B045430783;
	Thu, 23 Jul 2026 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799936; cv=fail; b=L9+DJfS+8PljIzYZmg+YKqHYOW3ZfvtRVilhKrGztRkAyKgOSEtI7Nof10uYcy2ceSHasVZuON02AIadgDgxWzGwJm2aK7hBIETGprnDKwDCr+iQb8b2e3QjDzcXgwj55z5O9XVSuAWLyi1uzdkpvpwK9UlcL1qgz51BzrtgNdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799936; c=relaxed/simple;
	bh=WKkVmMg7cKEnr/4rT1FgCR9V5D7hR/8I2FOjqhqFoAU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BC4NZ3dQpaJt6Z7JZV25I+zHRMKbeOajUCdS8f0TGkXxa/tPRTSzLc40yktG7jtrEN8uT1y2j6a3ny21lV8wTAfDvNtkOKg3/KsVPDKTCZ+EiSApW73bLckxfHhTnAQqVn4FrQSf0/+uoXalfAw8khe+kceqWOjxNsvXVO5XmMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=poGunALL; arc=fail smtp.client-ip=52.101.85.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="poGunALL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6XbdlL4aQ5eYUt4ER1/A+jaERRyf9Hh9MpLaLCqxq85j2JuV6wArU5pEorkPiSCtJnRkoUaPC57t+9s/rG4I9Cyb420YqPpzZ2HNjd4rJRl6+Php6dBoyTtWB1/EXPf2O2IJLjRlNn3an4OEO/dDZUtINA9SB8i86MWn6whw+Vpjimkf3Y0DhyssDHAeOtTZaeyrtd4kfT/BP6k9/eu5St8DZ/zH1NBry25nZVZv4K1LddpcmPomCUiv+NFvEWs+dUebZRh6x+mYAC9L1yec1KDqwtSMmzM1q/paC1nlXmcRApz0FEQw3FphAFoNLVCJhx5UKUQi+TUI8RQjiz/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMNjHHmkZeFevICFdtsJud0mLLIi/W3xvWb2W9BNLtM=;
 b=YAfMic6EgQcra2p5Fdcfs/k5qLhEqSmKwGLxYlNQ4FyyyeOU07m3JkE7DUnytCRybKjwGAWKouzg+DD7oLcAqnMe6QK5vc56Tryzi4RHJDJosg80JdlG7H3D8CU5/sM6QVfNuJGNtiS+P/7Yd3g2oKQst8j7sBd1jwNSWiUlzGpjh9ws8BmlmyrkP3mCADwaiPVpWIIY+KwbWTSNTtbY3ZCKy+mNnZetTExwJLWEJbVc2f6iPYm2Naj2n4WUbJU0E1ywbJ7NKk0hcr7Rn7s4tLN/QV/cJJ1FFAVvyT4x5qY5snbZ2nDl9Sx0uE4nw8si18N8m/VhaFmRxpaNZC3Lsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMNjHHmkZeFevICFdtsJud0mLLIi/W3xvWb2W9BNLtM=;
 b=poGunALL0MrUZJY7g5vDmDkjEYmRf9K3tN4OcYKioikoucf2tQrmHrti60SYiNZtgTD9Xm6yINz50Lg7sgTQKe84lbrGofU9BgzAyC+p6Hjk/futbYQj2rjb3+GzzXyQYDKv4uBVbx6BVPr8xfKCsXHbhZJRDUPfNzDGZtyzSJYdkmCED//OI5wmvoVysfg6f46juP5zGWOQQTRlp/MlS8wjG4xPiiSlnPdBpMIc75ZmsuR95oDMrbCM+7I6PaEDLSd0K2TOsu8aacCegVATArxki2bv+Sz4+VsUmYVStpC9y10CY89izSZl5IWheoppyMLBgAU/xqWXlrrqRAV0cw==
Received: from PH2PEPF00003852.namprd17.prod.outlook.com (2603:10b6:518:1::77)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:45:28 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2a01:111:f403:f910::) by PH2PEPF00003852.outlook.office365.com
 (2603:1036:903:48::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 09:45:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:45:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:45:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:45:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:45:05 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, kernel test robot <lkp@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Fix indentation in mlx5e_free_mpwqe_rq_drop_page()
Date: Thu, 23 Jul 2026 12:44:52 +0300
Message-ID: <20260723094452.1888786-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: a079d9a8-84e9-40a3-5436-08dee89f205a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|23010399003|10067099003|11063799006|56012099006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	kM8VWAZlLf3hEVg+ZWY/YAKSIdJZAcfbUBWxL3YGOW9uDhN/vmfNd72r1QkrveKV7K4mTdysc5h3tstb6DjtFS82mtrsP1715bQCxYr/cM6w89/gSNkIXnONmb9pggpoU2+sneIcOeT5ydx+URehvdHYN/48F1KdgDfgsn4ynC87oEhKSWEkUg1WtYvC15Pmp7AC3lW91h/CrlfaC5/Ykuu6Go5a9JK1UGdsyREiSU3nCmxE3OtCxdzpjR8cAeUd170FXzN/vZre2Gq1F9JdkIqO3C/MpLqb53uvYOxEqu23m7J0dabxTj+RIkG2H7vXcNyZBeiBCRDKFcyofC4YG2DGDX9CRgltvpt7oqoDhumRz6Cl8Rk+F48Qrk3DQMle7lbM1TBjMAP8lKeZg1d4+E+j/yKx0Ie0up+Djbx0wOs2NxNV8dm8nO1SQ6Qiyen1xVrlcMeUBj4FF0jV7eS+fdB9vcjq8ZVzCfnMEg2Wlg/ywJZ2Sufbk5XvN4vjkIWysOPjkofvMeR8Ebv/96Iao4yEPDKOjgMw0Nck1BkQB9JHS2r441lPD30YYNux8G+DBMFmrz74g2z6ykELKDookO0kGujEVnXn4Ku9/IDNkOvWCTVsfbXL6/0N1MZ+w5tXd4dCvcdTQxl/bfWToN1pG1HeWcNlTcAd6QyybMQrLueZep4SByxi5kITE3dlia5Cz8pPBE1pP6T1RVJhk8fFEA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0gL60mhK+0xArN5CPNL7PIi2m1oJP7EqKpKrLgaVPJtNIl6fjfa2lQIHt/S9EUNwEPR+sv9DOF8jZcD9YVIxy/7DHfTKZezurGcXcOVmcEPdIJVKhD9S4O94Suq0uBh4hIbaJdvihGgvCMZY4gbK72nz3NJSdSPxtMxf2cnQbekHN72r8VPgLSnspQuKVuzufk+GajqI5HG5T3tLBk2hk+Ps/EsMifpe7h41MiEBkeR3JbTjRh3G5EorJtiSbrWG6xpHl5GURvw5+6W7Af0U+APr5NZsfGUI04B+/KsgO8UORjfzqGaAmGMhDa3DpUAj59bev6HFaSGuj1m0l8tJD1TUDhIl51+OzAhWSfhKyEjpu1Ibpud67wMt4q8zCMsCKFVSqwbRn33IbTfgW42NEeISgSUIKqKWNeddajJreT/oFGnbaA3pMNcWuani1aRB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:45:27.2300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a079d9a8-84e9-40a3-5436-08dee89f205a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213

Remove a stray leading space before __free_pages() call.

Fixes: 0285cc3dac1b ("net/mlx5e: Alloc rq drop page based on calculated page_shift")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607142323.qm25Crps-lkp@intel.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c1acb9012d3f..5ad8c67e4695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -695,7 +695,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 
 	dma_unmap_page(rq->pdev, rq->wqe_overflow.addr, page_size,
 		       rq->buff.map_dir);
-	 __free_pages(rq->wqe_overflow.page, page_order);
+	__free_pages(rq->wqe_overflow.page, page_order);
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,

base-commit: f43ee0c0730d6191629b5ee1ceae27b1ebfdc047
-- 
2.44.0


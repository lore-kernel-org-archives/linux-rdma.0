Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725964;
	b=YSPD66qipR1skeRE/1VMDfwkTmnWiu2hn/FYDYTiEe5PQy1BMgszRtobLqeJWnXJB2Az
	 8ACVtYKlHJINy6InfeBE6hfhPH2YhodXss4VA3k6W+qb/TmbFxCyFn61gxDEDI+o1BMyt
	 chkYyropJD5GQSEJzyBVZgMUbQ4AmzdahfC3UNA3sfyiJBotf/i6uG/fTwM1p4twVbHn+
	 YK7j5aWrr5/Hf8Zy4pCiz++WWIkI8djLelcIGPueNqQ6SJvo4zvvrGsAkQmwblW3tAI+Q
	 UsJoY8kkSNDRUf5EiMs37EXiqYs+XVk/s2cACAvtHZPTcn2ZFlSf1woRAJnRtI2mX3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725964;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1toQhrKZwPOIK0gZ8RRU0Bo+eut0PF1fnW0sGfcb+V0=;
	b=yYL45A3jZAlrtfPQNqXZp9k8ieRiPolkTMZblFdvqv334spdaIvFdTjJWj1H7JZ2wrWv
	 IwyangkUFY1wTo0bKvgJIvroZHrg5AefqXg2E0BmjMZ1TOaW9SruIW57NlGuHRAwEwgnd
	 hCJAUwA5E8DV8S9HgtyaDwE0g5B0Y7AB+SRGRgwOHM/UqfXE4QgPzYkADVAaqn0F6dZeO
	 jd5EmhW3oe/sOjBceohedARRJTgGxOtCjulaSQiWDviTYVUqSPEFsBTmZswA5ozycEk8t
	 2VjiJy6gogaNBnllr7A0tnn4MwwTFv81TUCxWp5MySES4hxPXgLje7yEUg5mB00moOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MKjB8ASH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.55
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011055.outbound.protection.outlook.com [40.107.208.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFA2606A32E;
	Tue,  3 Nov 2026 17:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FFA2606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MKjB8ASH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6FWuPrJH0HM32+WpjUzIyL93VVZlUMmcEh/7yGsnWSp9FtgYTS2+8yoI3nMbWal7EX5SMaGdSgBJu4qpt1IYKshM9eWShO6pHy+5vVIi3OlmGz8NXZ/IQVCZ5wTO53/PTdlJY5RGCg08t74bieWfqb/gwabHXLnI+J4TeMnSHvplcV/8U6vJpOv7jZxZ0cUlT4+jmjAjd2L2WdbRxlSYo4ewoYbkA3mePx2UhrvLx3jn9Eb+w05AkYe5d9XqJL8uCuYzOFpmMoYSbAoErn+2sXGAAOF3xtJ4VK7F2srW+RukAryV0SFb98ASlz5u22lpcp2ZiPFIuylvzN3vG8Uqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1toQhrKZwPOIK0gZ8RRU0Bo+eut0PF1fnW0sGfcb+V0=;
 b=gfTqnP0aBb89t0h+3CgnAph0daq8qHz1718Kr8Au4exGHiizZE1Cl6Uzkl/oBJTmxXW7iKSxGcS1IT5GeVbOOnJSARmD72n6dZjyUQwdkW21GvS/XgNoeqJubJARQs6GrfDRGRNsL/XpxSo5t3E1UiWS6QAJ8beklL7abWq9wbemGqG+01wlc9yONcKPIclVPgqHTyNZammjafxIa4nTBRNIzvGnP96m7SYZzzdlQgy9lN7/Tb6fa5xJfpfsY6Ff0IW0rasEH3EDPschI2/WsCbFWMqNjoxka1xBWZrFj+ydDeB/PD4nNAOE6Rjk5jZEBtn6UTFQmqKct5swY+Uz1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1toQhrKZwPOIK0gZ8RRU0Bo+eut0PF1fnW0sGfcb+V0=;
 b=MKjB8ASH+WukwgbVqXo0Mhk5fxkAMMUF+JkOxMwSTEV0pPqJ6zF1V84AuEVHwRs788P2Nk0azz4nHPtdXqO/0TPdc8L13bJI1y+KFvwUOZREQ74PDmd5vDcjyod6Zw0QNHfTfAJdXPG8ng61hDM1fhFVZp4MWRYI72Uh+/K9VCkU1V8ohgcxprEh/X9R/8Ay/Mj3314DAnZ393fza6MB2jlBoJqWQBq0W/zoT/JK55P2tCZPTNha/nIdyPTPrnphq0OMTZIxWZzdjHNZCxjSIUDmJJ/T8mBgTGeczfKbcBQM70yrnJOwn892mnueqbMEt0rbBgZOCO4i3xroU0en8A==
Received: from CH2PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:52::17)
 by CH3PR12MB9249.namprd12.prod.outlook.com (2603:10b6:610:1bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 17:12:38 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:610:52:cafe::46) by CH2PR04CA0007.outlook.office365.com
 (2603:10b6:610:52::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:12:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.0 via Frontend Transport; Tue, 3 Nov 2026 17:12:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:04 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 04/15] net/mlx5: LAG, treat virt LAG as a software managed LAG
Date: Tue, 3 Nov 2026 19:09:58 +0200
Message-ID: <20261103171009.563034-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d40b1a-bcf6-4439-9617-08df39cda7e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|11063799006|56012099006|261009223027099003|261102123227099003|261021123027099003|261021121427099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	za7CcrUUVqHt4NqX6zGTvPL4U4+N03V/ZU9kK+PRw7JXElrdKMUOEdm5usktx2PnjesFAxgXaUTwFmWV2SlzxWtEUgEEgXVQUunRX+RRUXYbOcuPB86pCRq9gw9Jpej+UYdso3utImVeftEyoxJfv6Ud3ECaJSV/9g9YN3YYsc3nKbWoe5SjEt/GobEILpXpnjkzPLWnfjV72qQn7yJyaAxPL6K8KBjPqQEeB7qtBN2NE9dt/POJuDOGWp9lZqT0UXZEEy/71MPaQLORSpiSYx8n0iSmlFPCe8Mh7Y5GTMXAFek9y58nX3w8jAD2BqgwiSBaW5+dpu3BFn2pp0YrMeWGcp6aVHSWzndVsz9CJnQgdEQ2lEQUn8GS2UtoxphiYXnawTjXL+/nmCG0/ANCKLPyVXeDqFWNvzj8DezPVJ7pYQh4Nx583yJHGtcZcre+JAts9x38fpIF+MnfMyanfSlTnru/j9Uo7a+JYoi5zvte7EFPOoJNeE598Q6XsyV318XVkzpQhP0UO5VAHNY8+IYTkJ30scATBjzZTGcxQKS+YyEJkOzhd3QQohgrWXP4VeXFIWMg5iudQQaBhRLcCrK0kaIVExNp0h7+ZVwr2PzHb6+Bsi7KwQq5qU67KqDCqW/eCXYFjj9UZpxjGvvUU6L0ATmU6VVltV2M4h9YqTgEp7A7jDcdS36X4ganwcGfGnQ6I26+4yuoZ0bdTo4Jxg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(11063799006)(56012099006)(261009223027099003)(261102123227099003)(261021123027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	orhcHGWgqgpSn3CDCEfE4v466CpVBdnHp5j8lB2KtBmOApQ6me7v4Wy0hR+WZ3WplWY98P4z/svWwG7/KR4wPH7hst9OF66G8T0y6gCQXZZkCrHXyqvWvaoK1XKo//UgIoA3M9/NxB4JWye94IP9TWqZThJZ5UBLdP2OTZ++qQFOWqsAWBz9r+JazpjS55f2DBk3m26c6qNbkoFrNqsVqj1avPDf3w56x435DuGiz5oo584UmHfihTE4TH8qwASj79wfm7tt64WFKmPgZzzSG0TJ8rMIxImh5yyF0Kw7MEblbHJmMViFmpSEI91G8yQdiDyEcA/cdEp+kfVxQvjTmc09c2BXoT1EAkLIAGzjL5RwqIkZcraIWYiwfmN9U0zqq3b2om3SLsQFMQIvUzoz3HOnsrFOq7ZYMGOB0OB1xRJ79LKAA3gsfpdqR881tMeK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:12:35.5977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d40b1a-bcf6-4439-9617-08df39cda7e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_is_sw_managed() (renamed from mlx5_lag_is_sw_lag()) marks the
LAG paths the driver builds in software - the LAG demux and vport-LAG -
which must skip the FW vport-LAG commands. A virt LAG is
software-managed like an SD LAG.

In the same manner, block multipath LAG over virt LAG as well.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c  |  4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 46f125d24f15..b2ac5c671ae6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -173,9 +173,11 @@ static u32 mlx5_lag_dev_group_id(struct mlx5_core_dev *dev)
 	return 0;
 }
 
-static int mlx5_lag_is_sw_lag(struct mlx5_core_dev *dev)
+bool mlx5_lag_is_sw_managed(struct mlx5_core_dev *dev)
 {
-	return mlx5_lag_is_sd(dev);
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
+
+	return mlx5_lag_is_sd(dev) || (ldev && ldev->virt_lag);
 }
 
 int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev)
@@ -184,7 +186,7 @@ int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	int ret;
 
-	if (mlx5_lag_is_sw_lag(dev)) {
+	if (mlx5_lag_is_sw_managed(dev)) {
 		if (!ldev)
 			return -ENODEV;
 
@@ -206,7 +208,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 	u32 in[MLX5_ST_SZ_DW(destroy_vport_lag_in)] = {};
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 
-	if (mlx5_lag_is_sw_lag(dev)) {
+	if (mlx5_lag_is_sw_managed(dev)) {
 		if (!ldev)
 			return 0;
 
@@ -1912,7 +1914,7 @@ int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 
 	xa_init(&pf->lag_demux_rules);
 
-	if (mlx5_lag_is_sw_lag(dev))
+	if (mlx5_lag_is_sw_managed(dev))
 		return mlx5_lag_demux_ft_fg_init(dev, ft_attr, pf);
 
 	return mlx5_lag_demux_fw_init(dev, ft_attr, pf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index dff04f40d8f3..872cc769297c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -229,6 +229,7 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
 void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev);
 void mlx5_lag_clear_master(struct mlx5_lag *ldev);
 bool mlx5_lag_is_sd(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_sw_managed(struct mlx5_core_dev *dev);
 int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 			struct mlx5_flow_table_attr *ft_attr);
 void mlx5_lag_demux_cleanup(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 65c76bd748c6..2077fc5d80c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -26,8 +26,8 @@ static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 	if (__mlx5_lag_is_active(ldev) && !__mlx5_lag_is_multipath(ldev))
 		return false;
 
-	if (__mlx5_lag_is_sd(ldev, mlx5_lag_pf(ldev, idx0)->dev) ||
-	    __mlx5_lag_is_sd(ldev, mlx5_lag_pf(ldev, idx1)->dev))
+	if (mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx0)->dev) ||
+	    mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx1)->dev))
 		return false;
 
 	if (ldev->ports > MLX5_LAG_MULTIPATH_OFFLOADS_SUPPORTED_PORTS)
-- 
2.44.0


Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAA94963CD;
	Wed, 23 Sep 2026 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160100; cv=fail; b=pSKCSWJRwgAf++vtPtLObv8LLt6xRIwMWr+6dNGCual28OzD3/20QPJSq5oYoqinKS466FL2S4xBSnFCJlm56z89tsyx32znfSiERp8yepFwRUe2bE4TR7nIARL10tpywfWUd0VYjk6TgPAAIMnC3gT/LA8nrHVbczPlddwY4uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160100; c=relaxed/simple;
	bh=5Ilo5HKxyKSYQq6hguHk9rmk9PS+/DgjRzXLk/cRqtE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6Leh3Sw7RwUVQ+ESc68QY9io0j398hcsxmyLSophOTyDdH3lmhOWzSNfs7WbdJsotbcIyxNA0zHh7ekHPLN3iA0/lBjTaobIvD2F9P/q/1HuvTCR5Rh0WWci2I9AL/9ZvUxr9cpXxdXEBcBn7TyIhuSqmCdsdIQ3boP0oY1R5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3pqFlr2; arc=fail smtp.client-ip=52.101.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3pqFlr2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlyShHTgVyazZHYd2M1pxZdUgxxfaN8QsohAQd3aNaoMjLod2XYtWsnuzRS2gNYoue4hCeXKCdK+4wl6checNxZfVC0Bx94qExrdJrq6XvV9pH5IBUEGFsgjJKofiFi74g3R7CIIgcpjoqnmA7kpfTmeyY7Kzh1rn6J21C1jJfShMncJ4Jh+/vQC3XGfdJrzwYa4HZ0+5Ij31G7ra4mtdJb+5nO3bA+lSppViVKB6U+n4xyHHvLPm2G2aaWTmm6kNG+GBFgc8GGHogfn3YYawv1Z1M6nKHc+ChAHYAbmWVA6eusxJeopN6b+IadiT8g6a1oOX+IaUMylPhtxZCxOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofOb54ENEozI639ygaieFAt+x2FITipklt6eNWD997w=;
 b=mCGE5uTq1o6sarDJkC1Zq8AbHt8ZdJUfVn7wHRkxfnkT6kezQSuH5CT0XhLM+svI5yjYxec43LGXvh1e6kMVBdi1klWOcl3v7FJIr+6b0/Hn259Qi8VCYoKfQzICY+PGF9WCZZu7l0PdkCbKJ33Lm3IH5jM52m1GJq3Tug0X1y4A5+5Mqe1vqU3GwHCH39ESpqEBdQsX1wmUruJUlSe6/YO0upp5lx/Zz9kyGT6BvvlLasatIALvWC1F17Q0tuTjWU2S5gRWMNaf7TR3ru2RdeJJDGCI5Y/6jwru4xklfB/vmBGsEcF0k+fD16jwylxTPeNNh9jd6yTJ73j6Xj1Gww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofOb54ENEozI639ygaieFAt+x2FITipklt6eNWD997w=;
 b=l3pqFlr2aVfgAGzVL+5HHHdHRSkdDVWX3UHlS2O7zpxxtqRx1fZjkVU4Gnn8bR2xs5B5/Wg5fNVrq2EUgvko6CZBty63KBb9BNFb3BQFYEo4Ld5p70zpeCt0nZALTAgn/PrmF4XxjhAtRM8JUVNxI3rq0VX3fTeMwIzxulBhCcmhJcylUtPvALODcc6JvG6YVyp4wVFKnXM0amv9pRipmXbfrUgsZ/85qjHYXADcRg2tMtLB69TqD9RkwwoDPq0h0fRw6bPE+75Ida4sspfGTQutyqL4/MfvTfcbJ5Odr/JDlN+DEyujWUWTwJohkxPi+/DEE4rLzjfTTuZPO4n8Tw==
Received: from SJ0PR05CA0066.namprd05.prod.outlook.com (2603:10b6:a03:332::11)
 by EA3PR12MB828978.namprd12.prod.outlook.com (2603:10b6:303:308::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 10:41:15 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::20) by SJ0PR05CA0066.outlook.office365.com
 (2603:10b6:a03:332::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Wed, 23
 Sep 2026 10:41:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:41:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:54 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:49 -0700
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
Subject: [PATCH net-next 12/13] net/mlx5: E-switch, correct stale VF/PF wording in esw-allowed comments
Date: Wed, 23 Sep 2026 13:38:29 +0300
Message-ID: <20260923103830.1183-13-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|EA3PR12MB828978:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb52e79-634e-43ce-44c4-08df195f3198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|10067099003|56012099006|11063799006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wGiyzdIsFsJ2qU3zxHaRzFFO9cGCY2WaWR5dA3/pncDKAf74q9uaaDpniD3ZO9yqPHAiOIRB7vINWpvhYVf1Kfkr/XMrjEBGvtbZ7PfXSe2bCXRp6Pc1Q4k53zhzsZpL1JeCBbb7hPcl/ypRVw11+sudPx/eEN9KbHLWYHymUlsNHzKBhsV1xHYzxqoX8y7ZVqZpnmqrdjoiO2X0vrIIv3NwFDoni9HrVc1ekrmDiNYoK9ZJZIOYCB22WXoIa43W/XbuTVzO4xaSZfTHeECQM9Dg4Uk5EWbHk08LPPCQyPBLExvq/T4xd0avSrkGcnYlvfEsb14Y0/w3BbrMjNx7Vyzng41sQjoqMJTsJK3lSZPoE5J5J4DT52xuwBvdAGTgVWCDEVQp62wsi19OeBlPtw/aKyYAPNCLy5XCp38K8TgCvBJ1efp//PkHdVYQYoPlZrtHTNDMm5IyA0ZNk/rDTY2RX6+Ygr12Mo21Kz7B97wEUZ5zj2GSrfjVJEcSTgTcSxvaY02AJTrQ3ZtoHIQa5029SQL6zFdm3A2ouexzvjREYOC6d0Rp0ncdS5xtWqCWwc2rP0es7QnrKFA5uIs6Chqdc67RPZdnbGfJiLdAE6Y9ErgA/kHM9DR3N3nw0MyZw321T2jPt6s4yUTGKxzMaxh6qGykclbZ+3LY8ukNeGTkJkfzO2L0T+65tNkJ/KvP7yvxImNxe/xRfRuYxawQ1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yN5OsIG4i2N6O6jMCofxMCD/haAeA8UaUstRhp1XMi3n2uNJokHE6M6OM/RP7zenhUjhhUue1e7TLDadJBxB7qCjxQEH+lVR+aOgorPA5Tnb+0UO9MWtv0T8aIihrT1QD12ZxpW5jUoh8nQtoTK+A5QgHfwKpYJoTBcUFRQeLSdHAmYs4Khou+x5AeXlTIkCJnn/8y/2mGOpVO8CYmpEGXWRNmb97xSwAifEFO9vNC7yytFbAj5Zr3iHSrYwNIjBcapdrYqjTHnb4JGYSKw478F1vt68vyJ0V5jE3PdWeYo8mbBrxW8a6dYYLAyVVMUYTow2fIDUU1xzJjFxZok11TaPPUJDxu4oQaaFjeDA5/Vt+dTig2kys8jLyLdbdPPFDEm+JHzkVAyDneoCGWMhoNp92rhdreSfErBACDCXuRwzD+Utv9BCF1hrK9if2Jh2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:41:15.3298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb52e79-634e-43ce-44c4-08df195f3198
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA3PR12MB828978

From: Shay Drory <shayd@nvidia.com>

mlx5_esw_hold() and mlx5_eswitch_unblock_ipsec() bail out on
!mlx5_esw_allowed(), and their comments explained that as "a VF has no
eswitch" / "core dev is not a PF". New FW will let a VF act as a nested
e-switch manager - such a VF has an eswitch and passes
mlx5_esw_allowed() - so that equivalence no longer holds. Reword the
comments to describe the actual condition, the device is not an e-switch
manager, with no functional change.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index e7561f0f89b0..6f3676c86d3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2958,7 +2958,7 @@ bool mlx5_esw_hold(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
-	/* e.g. VF doesn't have eswitch so nothing to do */
+	/* Not an eswitch manager, so there is no mode lock to take */
 	if (!mlx5_esw_allowed(esw))
 		return true;
 
@@ -3106,7 +3106,7 @@ void mlx5_eswitch_unblock_ipsec(struct mlx5_core_dev *dev)
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
 	if (!mlx5_esw_allowed(esw))
-		/* Failure means no eswitch => core dev is not a PF */
+		/* Not an eswitch manager, so nothing was blocked */
 		return;
 
 	mutex_lock(&esw->state_lock);
-- 
2.44.0


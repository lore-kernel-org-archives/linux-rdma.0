Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161662;
	b=DVS6noX0NkJ8YIXsqxab4qNGMV5Fil9qoRNICcb2EHXyNnUmW7Pd8MMS5FEZCPMb6aGQ
	 Rwe0QVrwhb1Kreqede1YT1ER7chmc5nozkSh6mMvE/+CDoQOkbqdKFxqADvkqeyHj9ErU
	 n9X8BXqBGJ8MYfKBL43cR6t915HL652m1QdqAz6INbYO5YYe3SBFbTF4eTr8xlHYhtA7c
	 63GOnAzentUAdhX7pNDcPhUev97B+P0fBaF/55UtSejkx/bqnYheSw1rBsGbZUKJgr0YO
	 bEOj4251w6T8JCGs6FlvPiVYf7YzJNuz6yVs2Yn5/n4xBF86C77BgaBNeAqzdF45rag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161662;
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
	bh=OUmcE7nf5rs72L1hxT4h7yFUkjUJ/xCDJnlFMjzmeoM=;
	b=jlGuFwnXQpuW+3uKU/asIkYvGrmsQKxwoJNwUj7lHMKns5AOqBnSqMvu7ItBIppZjWYP
	 ZykPaiJ/J5n7kWnAma99Ux4WHjaWkScAKrdx48D1Z01BvIVfN8vxrWEgBkbhRt3pYoMey
	 yv3n3/PKA4K5i3S60J2SX+toleiIxTDfeJ1NzjsSkGofxvCijlIxu+HenC6PWTpo9k5P1
	 4qBlnLg/FdLi2TkEYrp6T6o3UoILoIja2XcOvSdUpUOyHucfRoxbbg9gGqOFyD6HULWpQ
	 sWSUZCN+fbjqusPdSJcVy8QiRUFC8lJl6xFIqs1/6hb9y7oDdVNk/zGMo22yUG9sLHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JcenrBTJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.48
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9659606A32A;
	Fri, 20 Nov 2026 08:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9659606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JcenrBTJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqpMMH5tj6C+4O7nEQtLXUJO9wqdUpIv+tw3caKpacSlaCis7bZZXhBCvdlf4VQHzXSVk+NUif3y6+zX/IJaiWucDfEbPB70xOLt4BoyPftlu3ydb98ssHxv4ux7cXtGdQ8u/aUOxBICYeL0OvwQFtPaKEEsJ79K4bwzxQJUpgRrSIw0LN5vCyj7DsKL6+8e7lM77h8Jw8P90DhNvN1bH6NP67ghfLhTBU1rSrq3TnbLem+o1r251vgXKL7JRJzfOshvIMdUHnATR4T0AROCs6ovQ10zNIxazY1rLogKIvjbjV6FWTqJcizDcqVncUB8e099oLGG5UUpARuHhhLbLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUmcE7nf5rs72L1hxT4h7yFUkjUJ/xCDJnlFMjzmeoM=;
 b=snp5K+eVPHRFZRtD5SJ4xOSTF14Pjqn8F56UeROUbdwvuu33caGsD8nmAufIuwfHlQd3yQWHTxj6/uAy23sGCXADIASC+seyVjaSWPrmmPRTfUptUjMcFXWNv52I1TK78oj20YAEjaqyQFjzzwGSs6WqnM0jH8v8AyxQj7gYcwGgslrhhe3MusZ8aEencdiAC1oy0y3mcxTG4pTsRXJCshojeozCA4dxayJfMKY01r40a7YnkWxGRWNe4AeaCWTHg3MmOBvfpFTXeu0k6ZAhuHIx99z+Rqj5S2t+uFSnkGkO9chsHcUosCmjkU/mRLz878xR4K2ALW4SRSv1mj8ksg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUmcE7nf5rs72L1hxT4h7yFUkjUJ/xCDJnlFMjzmeoM=;
 b=JcenrBTJrUlLGB2fm3QEuWxFgaKlqBPwPUpK/A4ZI2u/WBKyu+x2axR77eWNxe8a0sDWjhRQEIefDuDV49EPS8XxQ6f4b+Db/p3KSEVlr8KQZiCrXySDViYLSxz/jUR1y62Qmyn0sWWy0eVkpkzKh9YJJJccJaY+gJ1+9SNK5eCeounBkM/4+BZqs41Ur1+CC7KYqRB1yisWguf4yNX6H5qjLHDLW3DELWn/NyJvoqDZvCsbERD6huXbOFxP5nBH7EP7HiHt0VqrM9WV4ltAIzX8txte3UJoO2c7aGe2IDvDQ05bgCf4rTsXYcJGCDYNH3K0YwyhsrPYKPlf2QjpeA==
Received: from CH0PR03CA0225.namprd03.prod.outlook.com (2603:10b6:610:e7::20)
 by PHXPR12MB999258.namprd12.prod.outlook.com (2603:10b6:510:3ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:00:58 +0000
Received: from BN1PEPF00018548.namprd05.prod.outlook.com
 (2603:10b6:610:e7:cafe::77) by CH0PR03CA0225.outlook.office365.com
 (2603:10b6:610:e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:00:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018548.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:00:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:35 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:30 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 3/5] net/mlx5: E-switch, drop master egress rule under a SW vport LAG
Date: Fri, 20 Nov 2026 09:59:56 +0200
Message-ID: <20261120075959.2533702-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018548:EE_|PHXPR12MB999258:EE_
X-MS-Office365-Filtering-Correlation-Id: 461c1676-e8e1-4e75-a690-08df46dc68fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261026140227099003|261022105027099003|261026121527099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	npGaU6EaKaxcngO1U7344rGD9JJqKO1sbvTevI1OsuIKFs8X6jf45gZ9xq454zzf+FTb7aJJDWlAOFa6ONI3ea1RgnCTFGshnyssarfZ2m0AXgvq8gH+PAIxpoB6TDApeIwDOIqVRjKsxtZ7SeFt+iAQvbX7eXEZ4Kkw+ujD6rkoGq2b0OgtS24PgRhzRbWnwaxaQwktPt1hA0bRoD3NQQ6bQNsEBUpFBiAMS9MX7GTmU9kgQvDm/DhIgWar9tm1M09XGhDJMe5ivoc6sZtI+IC+lnKS8rV2Ca9ireiK+Ge/0HQCWll8C/BHzbFYESlzwGWhSZB2E6fmd4wUdw/onQ50UfoiSWQMODz5zxc1S4PPj4IyQNaouIUS/TD1CV0RPANgAmsjYpWrfjJ21mdzrLyftzoUbnVEtenfEhpRhUOeLjs4ZP/D+8E1KyxW1uM7+eZYBq3/7JTtoa+KMMAyGvyCUDD3KCF2YkXy6EuZPvgKu+g1GYOp70NI6adusWAfY/lNSWwGBQenl7BaJmgc8lQutHl8nAbAh6mnjZQc0L6JWGoeMrVxOZ2ymkyPUODMrZRDwPi7frVatW+XJLiYt+DK8vx4li58fQJWwfPJ3cpKkEBqjGzB53z7ZPy3wyk3AA9V0xu3Kt91Ufw5v56F4QNLccUAHcaUbhjKf+w5TsIb86BnipxgWmlg++ZMN+7Gf7UTIN6sHkV3Zjxe+UdqjA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261026140227099003)(261022105027099003)(261026121527099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dh6H9rRTAsWPCxhW6zJBy2WUlA55vbih924PKzuT1fxvOZeajnztqAqXKXSWZtAYEpYaLozMYZL5g0fObHQHiZP67Nr0k/cE+rQ6buHmnhP96lnumxjhaZup+m7DFwPrBjS9bqTvJLTm6Hsagkq37hQVCNGG3Tdj+LQdtEgddiktUMR5nt4RojQKRCHg+HllNSMCEd0kh2oWNFNW2Qp0VNqFbPuiCaz5OPMLeT4fuvCBTAB+yIVMSkWngVSQFHmt6Fj4zct/+zl0ev5xn50Q/NTA6UJHXOnvFn+Ydz0pvvxKx/BJEgcFU7/w8VyV2br1vaDWey2fjUHvRFbrRAGPPVESbYRqOS2YeiYrlcgzaX3as7aJ+n5a05UPA41aQ9oJQ9gI+oda5BIXFW8cvuXolD9lfIBqGbzJbWoFDToxLHbGzJRw5JwFMS9wVdE/cJcK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:00:57.6340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 461c1676-e8e1-4e75-a690-08df46dc68fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018548.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999258

From: Shay Drory <shayd@nvidia.com>

VPORT_LAG steers all traffic of a LAG slave to the LAG master. The
eswitch master egress rule does the opposite direction: it bounces
traffic that reached the master's manager vport into the slave eswitch.
With a FW vport LAG the FW steers that bounced packet to the LAG master,
so the two coexist.

The software vport LAG emulation cannot. It is a catch-all rule in the
slave eswitch's egress ACL that forwards to the master's manager vport,
while the master egress rule redirects the packet after the FDB - past
the point where the slave egress rule is evaluated - so the bounced
packet never reaches it.

The two therefore cannot coexist: drop the master egress rule when the
software vport LAG is installed, and restore it when it is removed. Both
rules are keyed by the peer vhca_id, so each slave swaps its own pair
independently. Restoring needs the ACL size, so pass ldev->max_fns down
to mlx5_eswitch_offloads_vport_lag_del_one(), as the single FDB path
already does.

Also, release the MPESW metadata after the shared FDB is destroyed,
mirroring the creation order. Releasing it first makes all slaves fall
back to the same default uplink metadata, so the restored master egress
rules collide.

Note that vport LAG on its own only gets traffic to the LAG master; the
distribution to the other slaves esw managers, which was managed by
master egress rules, is done by the LAG demux.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 24 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  6 +++--
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 48eb6acc1e87..bcf053b0a38d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -958,7 +958,8 @@ bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 cont
 int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
 					    struct mlx5_eswitch *slave_esw);
 void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
-					     struct mlx5_eswitch *slave_esw);
+					     struct mlx5_eswitch *slave_esw,
+					     int max_slaves);
 int mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
 					     struct mlx5_eswitch *slave_esw, int max_slaves);
 void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 57f58e79478e..2072921c1fff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3380,12 +3380,32 @@ void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
 					    struct mlx5_eswitch *slave_esw)
 {
-	return esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
+	int err;
+
+	err = esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
+	if (err)
+		return err;
+
+	esw_unset_master_egress_rule(master_esw->dev, slave_esw->dev);
+
+	return 0;
 }
 
 void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
-					     struct mlx5_eswitch *slave_esw)
+					     struct mlx5_eswitch *slave_esw,
+					     int max_slaves)
 {
+	int err;
+
+	if (mlx5_sd_is_primary(slave_esw->dev)) {
+		err = esw_set_master_egress_rule(master_esw->dev,
+						 slave_esw->dev, max_slaves);
+		if (err)
+			esw_warn(master_esw->dev,
+				 "Failed to restore master egress rule (%d)\n",
+				 err);
+	}
+
 	esw_unset_slave_egress_rule(master_esw->dev, slave_esw->dev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 8a867a04916a..2d3e61541d8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -208,10 +208,10 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_MPESW)
 		return;
 
-	mlx5_mpesw_metadata_cleanup(ldev);
 	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_restore_sd_fdb(ldev);
+	mlx5_mpesw_metadata_cleanup(ldev);
 
 	/* Pair with the master mark taken at MPESW create for VFs. */
 	if (ldev->virt_lag)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 404278a15ef7..90209e4b99f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -126,7 +126,8 @@ int mlx5_lag_create_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 		if (j == master_idx)
 			continue;
 		slave_esw = mlx5_lag_fn(ldev, j)->dev->priv.eswitch;
-		mlx5_eswitch_offloads_vport_lag_del_one(master_esw, slave_esw);
+		mlx5_eswitch_offloads_vport_lag_del_one(master_esw, slave_esw,
+							ldev->max_fns);
 	}
 	return err;
 }
@@ -153,7 +154,8 @@ int mlx5_lag_destroy_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 			continue;
 		dev = mlx5_lag_fn(ldev, i)->dev;
 		mlx5_eswitch_offloads_vport_lag_del_one(master_esw,
-							dev->priv.eswitch);
+							dev->priv.eswitch,
+							ldev->max_fns);
 	}
 	return 0;
 }
-- 
2.44.0


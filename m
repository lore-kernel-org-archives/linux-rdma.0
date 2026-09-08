Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010033.outbound.protection.outlook.com [52.101.85.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1605138F938;
	Tue,  8 Sep 2026 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850446; cv=fail; b=o/Q0HnNBhJjvOIDHQAF6rFGE/hDXO0ccEYtMXKCZBTHFCz5rw6N/Cafmmcrcwl4nn5j8wtAQw8D5gMgEmWqOAmu7KVQsltcMo2QW9/eeMov4M1imo36VNQwjxK6CjZm2AZ3hFwbRV4ercsfW6wiWmwkyzIX1aGD8OpKw8nzyTCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850446; c=relaxed/simple;
	bh=iqjSEvvhYRQuJhUWRecF/67q8wladK+EYFXmXG8fMK8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjO4wDudsapPs0/y0ufXBXCC3QxzTXbw2Zo4IZA2Ot7Gbm9R73cQDuhM6X+nFQTKt65o4Sw/QF2p9ogHGUHc9KajdS/58B7+DZRu6VmJu6QEjk25wpkK1xqsEwgoigrwnsQsHSO897Oqw938ssRtPuIi5TtbvGYGGl0KkByNYCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tz48Gbln; arc=fail smtp.client-ip=52.101.85.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tz48Gbln"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWurmlJGzorUipt6ceLfOB8gNN/RrATGWqYo9FHYbhRdmqJd3bPOuTyBmwZffDTs6AKp7KdUSdRmx2fKwBPOQ4cTEJ7wue1iM/2QShpKYYfYfe85y4is7F2uo9beRs0NQkXXIjuS2pVMoUZ/qWl3VVxcNEO2pu5LawO2KBO5TXQuj1UO4Zk7rkX6uKpDcmFKm/JZI7/WTawhOM8S0d7WirpnDXUcJSXYijKERBtWioYtYdP5fOAeEr4/2gWBmczlVyhGIcE5m5OAs/w8AmrbxbR/dzTkBTTdVHg3T13zc93NFroTpzMl6EOFEDbHQzoxFVivnI/f+1r82y53WtxQ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhL7clVwrzojO7vicEjP9ZbfyKXmx8cmdGKqAHizwzI=;
 b=QeK/XkL01aiXAvYyq8xuUQxsKGQUXNDmYzxRyaMF/zIU8jEelhvqpGU71/qkI3iLxx4Evofd5dONfP3QU2V6pqb4pqPxWaMHWbeE9YhOkgzrO5hFTZkIpljNxgemIxAdKi6xpWvNqC0e+s2c+jrCsPSgqodaQMYjsarsWRL5akAcjdroVH21H9QWp80YRKUTxngx2cqDPxYz7ZepcJnS9GDf6IY7INPUJtTrB9+lJ9d6o9zOfThiR85Nq8NP98Cf/qqASjZ6rrpddE0e+CZ4o1S5lVMqLUFYusxVdmes1KVCuMPG3FnqiDd/JlF9lRL/P9J0u4g4Ndo/KZNX5skD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhL7clVwrzojO7vicEjP9ZbfyKXmx8cmdGKqAHizwzI=;
 b=tz48GblnV/nGygRJj8i0yl/MV+nW6WHtaoLDEtnGY+ucj6MEi84IofgTFLal5jr8leOISr/pfeQXH2A5OmQFa+Q3GKVtcKAZ3REFz/a70afgRlMo2IWBECzv+4StKo+1ZOFn5/hRSgI6JCmIAre78t5bKVkG811rhazHu5RdWIz7vPv2ldtzZzcEQMxF2Qy9YufwAg2FUcEdlpGlPf+vRzyPXLIqURuX0E+Lb2W+/qOjpeTHW8ye1KdfLD0QUAxK26rvUX+D1R6yCE0OxAICGE2pQZ19VzgeP8RGBQFPL3WSLY4gwJzitmd+SbdpfDbc6jDNpOZf6AQ//MiuHPM/5A==
Received: from MN0PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:52c::16)
 by PH6PR12MB366721.namprd12.prod.outlook.com (2603:10b6:510:3de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:54:02 +0000
Received: from BL6PEPF00022571.namprd02.prod.outlook.com
 (2603:10b6:208:52c:cafe::32) by MN0PR05CA0021.outlook.office365.com
 (2603:10b6:208:52c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 06:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022571.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:44 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:36 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 03/14] net/mlx5e: psp: Block TC offload when PSP is enabled
Date: Tue, 8 Sep 2026 09:52:33 +0300
Message-ID: <20260908065244.3799142-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022571:EE_|PH6PR12MB366721:EE_
X-MS-Office365-Filtering-Correlation-Id: 969cf2f5-f9bc-490f-c442-08df0d75f6cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|7416014|376014|11063799006|56012099006|3023799007|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2UPTthDuWDmvRoxHvePQrOw8MuFLsYQ+Hk/fCQd5N5l9fplnBnx7iu7Iqy7c/B4CcDJMUyjfy4NuvLLlUuTlXUG1q69CQ1aayu+e1KzlegWdJLDqw/ToW6PjoC89wqHiEFRoPLOk1szCUCuAEOub5gzQ/nsB/9q/p33WkkNi+QFxj1z4lExczmrX7wGCU+PyD/48qx2/cyjjCtgQXmNYp6TLkNqSV3uMPSi4GEP/IPei/vGUMswwhXcY8Jf+npUuieTsLEAfKX5NDX3bOricuLscNJUvgk3wzK5pq/wrPQG1/1h1On5kmZzZrRqeJu5++4quMiYYmIDbqb0deuSe1ui7kdugnDMDrZevDAbWe5IrkzMbPhV2PBQOstXE9iIIx1TN6sx0iVVwnbHSxNQ9iwOmRaEVTbVB8Yu1DvyK16rsmopQY/n2kopF8oy43DokPGz3hqZFnn9L27LUWY52YITwbeIKdBCkGrBvJy3TSqgwQUkk9emhLcMK8eFo4q6/4R2fykEes4W9mxlyKdfG0V/5h5+qMTsW3iakVcuZbpDHZJjzut9AL0yOnZtbmcL1ezzZdmNeQKk740MeTVX03vJfvN+2Sk6njpmruPyYmzCAICvQ6kNcnlV3P92WE6RvLPUTaRY9kP05Lp9tRlDKq7e6frjMgSSiMuw4IO/syiYnXQkY/uPaWly1RvsktnVF+h2ow6IKRpW2Mv3r3eAd+w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(7416014)(376014)(11063799006)(56012099006)(3023799007)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	U8ObDX6IylYKCAEW/7JchhQQbjuSvRMutzGO+4VTcJvfZUXqs9HduwfuN/QszoV4UZUGrlFI+c3Rj0R9fpC9OtjdCgR28BH1VfyodbMhjNkSfFOii4PFz3DjtQwwMNPjSy0M/65LcPBwyQqmsWJ3ESLxzLVKeMSbN96pfAp1vlk5/BuczZrSy2f3mtwKX6dmvKh8HBWKnO4JKiqSS762gupo6vc9o7R9hqHNCbheFtxg5S5hc/EejJTwMH5mJcY/vtax6RK2z8+7+8tj0sedXsJQZq0IhF+Felw+ILyXasanqdpESjKdt2OUaxytdBYs2/WWvHvjia8RmsMbG7gzaTDwDVu4qHWG5I1ulzcAkoj7c2lZ83Zp032xF9Q3xDcZMDXfHSgVZ9eBPy+8ElbPlOQ7H191SsqhSnqCu8EyhLmRripImKSL6SAaNiGTYJ2d
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:01.1178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 969cf2f5-f9bc-490f-c442-08df0d75f6cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022571.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH6PR12MB366721

From: Cosmin Ratiu <cratiu@nvidia.com>

Make use of the mutual exclusion mechanism from the previous patch to
make sure only PSP or TC offload is active on a device. Later in the
series, the PSP protocol marker will move to the flow_tag, which is also
used by TC offload.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 73b232379263..6cc4b9d54f6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -6,6 +6,7 @@
 #include "mlx5_core.h"
 #include "psp.h"
 #include "lib/crypto.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/psp.h"
 #include "fs_core.h"
 
@@ -526,6 +527,7 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
+	bool tc_blocked = fs->rx.ft;
 	int i;
 
 	/* disconnect */
@@ -535,6 +537,8 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 	}
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+	if (tc_blocked)
+		mlx5e_accel_unblock_tc_offload(fs->mdev);
 }
 
 static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
@@ -543,10 +547,16 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
 	int i, err;
 
+	err = mlx5e_accel_block_tc_offload(fs->mdev);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "TC offload active, cannot enable PSP");
+		return err;
+	}
+
 	err = accel_psp_fs_rx_ft_create(fs, &fs->rx);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed creating RX steering table");
-		return err;
+		goto err_unblock_tc;
 	}
 
 	err = accel_psp_fs_rx_check_ft_create(fs, &fs->check);
@@ -583,6 +593,8 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 err_ft:
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+err_unblock_tc:
+	mlx5e_accel_unblock_tc_offload(fs->mdev);
 	return err;
 }
 
-- 
2.44.0


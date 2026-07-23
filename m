Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DC734027B;
	Thu, 23 Jul 2026 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819753; cv=fail; b=g006eu/ZIOU0jUVvF3s3M779Az4d7bAfuXIbL0WovR+SGLQhubHMd25HWC12wT5Gf7N1slyi49e0u0jtJdr9xFi1Ru/AUQcS0fRwgp25uhDjwWlvcJIIQaAtvnk91q3lhmnIG+jhiSb1jQd5bQpdwuudlmWyNh55Gj2VSZCxAKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819753; c=relaxed/simple;
	bh=l3F1pMtP+cPCu4jLR9IQeZbNvQ0HgaoAq6gfknQ0FLQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=DrORN4w8r3CcGnF2KxXn5virQUW0sRz449dhZQcoLpve56gCmvnTAW3WBSHyyj2tHLJfwvk+3fH6FoYK0XMUPWxe+ZDFBlmyXJnZc+wxeJYZThOqpTz4U11yQhTiKjSq1Mb1sU8dMnvzOYiRa/YwF4cDZQQchd7xE7lkqQFyuQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U6ujYPYg; arc=fail smtp.client-ip=52.101.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U6ujYPYg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KOre0hNVUqjoUy0NMGPCjwyL8+limlIpLQ9ABpC2x24NDGaI5EJD0f5Kd6sDxkpQZwFZYHjm5yejpfg7E7C05H0G6Jf+VJH5uTWF/ewRKTA8Xt3zxMSoyEne/aTkYIAmhcAp9hakN4Zi4YynUtKQpudzE1kLJiMSLedbVX2HuKDRSUxbyyfcRsW4+mlry8tNAzVnThEUk/X1VKdLfpzuCPOHSaIupvd8EbkYQAaeAC8xR2altvn8TMmoQgvXd8Cq4CxzFOt/UKL0PqTfPznLeGYBzHKtM4acAKYnbi/g0ZJNZxV6jgJ/Oz6A7KUqT/swtyaKzON8RPDNNFBg/+IKRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWXMe2wxF4v+/x3HcHepYnRWctfsNteRCRE6rCjcOJg=;
 b=PPy15+8gjw4yvMtJtSH2m1VKFWanZRg71FT9OZN9Llr0KtzliSOLrCmYpxoEgX/SL45ZhICdvQ90YfLzY8ofQX7YhLgweyPmlBi+G25ibO9K3xwzc0FxLLjoIXdD+BtSTIZqMTFkqHJB3Tlw+UVY951hfuu0p1YDQlLW6bqoFhNrYo2wRIj5yPd13JC74o9c4rUUGnROyBOs7qKB1klHA/j32ahdzF4w/c9wU+E94HkoYPMlGUMs3sjtSV8tYpGo4jxw1dY0+4TM9Yf/i5RxT7X/1YYAl8zUXncV5mSED1bq7bkfiuNkoYJ22Nk9m56leKGlWsT0i0nOmPtAtrCGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWXMe2wxF4v+/x3HcHepYnRWctfsNteRCRE6rCjcOJg=;
 b=U6ujYPYgg5j/vQBVa5J9tsp1wOu65rgEg7EwJiehzMkjsUHF+3lxyhGRoAzuLOAeour3vx1zAKsyYG3rDzMJXN4v5iZ19L+iBxTxyn0nMwoYFBxyA7wi7vn9AAA6L/JSHXvuXlSEq9DtZbxQcskSoQYT3CufiekKrBceU8p+Llt8Jnfi2cRtEOuNwzNiJ+X6GIu2dVYo8Klq/b6/zRi6/qUiUZJjIuYXZLW9QbRCV/NSc8ldKbiob+8hIn3ydn90uv4sG0BrPscUOQzKmT98BAD7yRlIj9hfpSwYcomNMHTyRJzI+D4ohi++vME+g+nvpmNc8X7ouFvNm7tWMh9ksw==
Received: from CY5PR15CA0131.namprd15.prod.outlook.com (2603:10b6:930:68::22)
 by SA1PR12MB8886.namprd12.prod.outlook.com (2603:10b6:806:375::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Thu, 23 Jul
 2026 15:15:42 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:68:cafe::ac) by CY5PR15CA0131.outlook.office365.com
 (2603:10b6:930:68::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 15:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 15:15:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 08:15:18 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 08:15:17 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 08:15:15 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Thu, 23 Jul 2026 18:15:14 +0300
Subject: [PATCH rdma-next] RDMA/mlx5: Expose RoCE acceleration counters on
 all functions
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260723-expose-roce-accl-counters-v1-1-967618b550cd@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAEwYmoC/x3MQQrCMBBG4auUWTsQE4zFq4iLMP2rA5qUSSuB0
 rsbXH6L93aqMEWl27CT4atVS+44nwaSV8pPsE7d5J2P7uoDoy2lgq0IOIm8WcqWV1jl0cUgImG
 Ol5F6vxhmbf/3nWz6JM5oKz2O4weSXpnqdgAAAA==
X-Change-ID: 20260723-expose-roce-accl-counters-8063ccc3f658
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Gur
	<michaelgur@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784819715; l=2083;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=LyrsMvS5bvarC//GgczdZc0tkc49P//DKjASzFOPny4=;
 b=AOcWEEEjqhIZlRePJFB41IAmRM/mi6ViyYpwtWN/eizll6XCi05DdJRP/BnJwkVuahxDV79b4
 Ea92BAexrixBmlPHE+a6RtjNuU4vFzHCPAIijLjaSHdNMA6ElWhFLtD
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|SA1PR12MB8886:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a280a2e-5c4d-4716-577d-08dee8cd4352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|18002099003|10067099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	eL1eflWLcwKTGjDMRSmNkle6pETwRyBAFfq1QgX9kW+umkklcI93uMjl+jXVVUAn/e7h1MHovLE3+CT7OaqwNIaFeVx6cPSTm7fA2AESdSL+v5tpFd9JFvI08Np04QlP1bZMTNpInaR6y8fQQNbQcHQMVkywSxFX6YJaui3j9KoTyLgZt39H+Jt28XqkWj32TCa4UOd2v0o3MdtrBi1FCAO+SEqX0MLQqHcHCpszuYeJMd27OfAxVSwzEqAn1TdnDZvQA2v62WBum2K2fs96ba5+mG4M9SyhcmzCxdduiF85IF2gDPu4sBuXPaBD7RUp1U7cuJ5Z/vdqOkgTU3KaJAOQV3SG8ndBM1rMDK346O7aSe6UWokt5stqhLrKEshePNFzghrKGeOPDl2aqEsm29qwnZfIlkr8ndlw6W/U2L95y+xnuP9DSgLbbGdShu6akO1WhG/FusK6JhVuKLkqf8JvjQ8TtbSS1LheOWnaJu9szAlA7NHmYh1PW1HQROlX3c0zMYzhMObTGNyAfXqaOPLGnoZQAeS5CR0jgaq443K3dYHQWu04vGdOnTlYhGjhAmaM19z3OLuuXN/ZZEp/uTy1HkoX0YSGXEgpwnvq4BWSd5mj59tDAD4ClhmiMYGiheCYt/qDZHY2M5U+STzYQomtQA6BVH6MoaVetVCA5AwECoA35M3l1IHfWr0dVzMItdGuo1d8Nv0waOPWfokgUQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(18002099003)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8yjw8kBQHOtZnvIhQupOB/+o2p78yuxYeSDdz6cWMKXrmzNh7lZDwohirl/1dbSI1gg1lYCcmJOm46xmcaMUVfWOPn5JZD+oHVt/S33UOnE9J7WXWybndY73uO+Hinf71ZeFnRykw9K0WoQWwwOOVJYJclfNqsst1932/C+cf3X8EZY1n1lI0S/T8l4vngbUNmj6Zw+2k+3gCBKOFFylsf4i5URoLUn/a4ltop95NQN3sB5eOOAesPetu+sSWQN5oSNlOCC1SkgizMKBwonHn2abvhVZKNMX5aSKHkuf6J0Z94yg+1CSdMU3c2bm1KFnYnbDNa5WrnVr5r7xFHKIsm8SrJUx34FEO+w7dXgdLHFi44P/3igcJlxXme6sc+rg2dLY4Kvk5xDeAUmp9ZKbhEr0IOWov22PD7a7IcC2ewKOtjiTuZVS63EJJPwNtl+V
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:15:42.7517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a280a2e-5c4d-4716-577d-08dee8cd4352
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8886

From: Michael Gur <michaelgur@nvidia.com>

Decouple RoCE acceleration counters exposure from the roce_accl device
cap. The device cap is intended to protect the access to the roce_accl
register and was disabled on VFs for that purpose.
Reading the acceleration counters, however, does not involve that
register, the counters are read-only statistics that carry no
configuration risk. Gating their exposure on the capability therefore
needlessly hides useful diagnostic data on VFs.
Expose the counters on all functions regardless of the capability.

Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 5a79e834ddea0c15b0b634a13de66acc1adff0cc..2250b195571c5c9ac92e924029e1e2faaaff1046 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -742,11 +742,9 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 	names = is_vport ? vport_roce_accl_cnts : roce_accl_cnts;
 	size = is_vport ? ARRAY_SIZE(vport_roce_accl_cnts) :
 			  ARRAY_SIZE(roce_accl_cnts);
-	if (MLX5_CAP_GEN(dev->mdev, roce_accl)) {
-		for (i = 0; i < size; i++, j++) {
-			descs[j].name = names[i].name;
-			offsets[j] = names[i].offset;
-		}
+	for (i = 0; i < size; i++, j++) {
+		descs[j].name = names[i].name;
+		offsets[j] = names[i].offset;
 	}
 
 	if (is_vport)
@@ -826,8 +824,7 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 
 	size = is_vport ? ARRAY_SIZE(vport_roce_accl_cnts) :
 			  ARRAY_SIZE(roce_accl_cnts);
-	if (MLX5_CAP_GEN(dev->mdev, roce_accl))
-		num_counters += size;
+	num_counters += size;
 
 	cnts->num_q_counters = num_counters;
 

---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260723-expose-roce-accl-counters-8063ccc3f658

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>


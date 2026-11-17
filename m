Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924135;
	b=NTXoBME09CE0fZ5EM1pyOVcocI6kwWimsT1U5bgfqQ+id5eLToWr97dEaLAT+5gW5y0h
	 wnSBdbFXaLewUIvstcsymBpu2JmdVHqqiTc8vkuihYNYRFJpk10ag64qU+se73vaA+IeX
	 ilt3O69TQ47ZUvqy3/RrWWUXBeL3XP49JW1o54S1qgp8HhECMupb0oIHqde25+A5peibW
	 h98O3Tc18uO+ZLfZeyQ2wtMY/qP4PbpjLjnkl4Z6mBa5bBwOvCsfvrsPerSZfDTilDHWY
	 08l9dKAgT6n4jGO1fDaDUawMumkgRHLFVncNO6d5ykqhqEUTAu3Uq8hI9ew4xduYhwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924135;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=nxtlQVMdU2/Z9OETw1gBLYuyHN+90faQl42A7TAoNPE=;
	b=kzEQeM4NcUYEbzkrtjIw7aQ4umzziL3+rh5g8awPHUlzLOMcsPNkGeKDWXtndmtAUcLe
	 7jOYI2DZRRFA7gxXAgsM/yPG5JzDLwzSvC9kR+UiagkuHbmGu/JmFwk7dnQt53DCxW//A
	 Ru1qnXNELrR2B+mUsNplQ4XsYfDropva5vIrhdhFRJNNTg8LzJpFGsLRtxBJfrea9alEq
	 6XWEakeyP49v/qKoz6wASpFSJEfkSlyfDpY1uN3g8HKdBBQYMCNxnltUHuf0c92YX1JMM
	 Hn30OSEUQ7K0f9Agj7SgSShsEOlo0jHoSdSvIsWBdzFOYmtIoMWuV3zlGZVmVhhO9mA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K7+wjeEU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.10
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E4F606A333;
	Tue, 17 Nov 2026 14:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21E4F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K7+wjeEU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPY+9oOhPVLGpkCyOBN296qh2AB0gjIrExD6Ti80pj0OGdxeKcV8imNzb/+/+WtLLm3Ao7bVRrxvxM/RZxJLQZokaXU+0xhDVtuEHykfpIxSmEKiiIpPxknCwzYLTn/CP/Ig8uAlNHSRBPnZD9KelUiIRF4D9uYCS3fJlc7+kPmdJzPeA0U5LXy/v3vxNM+1pVq9GDBC6hS2x8Y74B8SUx68vSG+46jKU7oWXnsyo20J1+fF+aaZssAemVBRqNzxgoHYbMGIBRN1G+8hCpxLrzS7kh1lU0mO/pekiXbXxr7zYtbNl7OeBnEE6wSYC38jZckuDrlZG6z3ks6Dt9GA2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxtlQVMdU2/Z9OETw1gBLYuyHN+90faQl42A7TAoNPE=;
 b=EFJylGbHO7kyZFMYbOM9qZkoD316lhsmGDRxPq0T0SEMfIFt/tpSN0qMWXRbpg11Q+adZ/ueID8pc3JCC5YhDw7US93LP2b+GqKqTVQWaj43XMhKxCMbQCMejvN0Qa3R270u4w18yMApnD8VBZLxCVk2a+fb1MzmjV+4hzuONF6zVABCsNRsfWDPp/GcFnLZVEqPWlCNDmsjgu/+f/yb0Sp6alaDEXg+tGITeaVZxGZ8nGqh5WPyrLGFjrOxuvw3N7jqD0CK6cwfLFqdyHxh7oj8pC90+r9mqByNGl/AUV0Erp/O8LVvhbLey1YB0W656quL1HKPeWajtXlfgNdcfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxtlQVMdU2/Z9OETw1gBLYuyHN+90faQl42A7TAoNPE=;
 b=K7+wjeEUrBGyYm6YV2icXLJQNvoYioLFMtLumgbo93FaUHxWF2SFtjkk+YZLPxXATn0HxQQl/Kn+VdozsElbiT3D7GppLHOPj6cmC+1Mlv55EthKatkMpB56HPCFdYxGXQ18eHfVSdLwomKEtR3hKswlouGSyW+8WhUXgwFjhddqeXJOeKKz5/Ve+0J5foSqbVGImvh1M5p6AdQTGBY/Kx1FnDzCz2xjFJ18IB1oT9r16MX3tOAv4spkVkWPmZGUpeGBocHIarCw61ak1KwZf9wbMZ8E8Swgt63SFUoNANyfEkPRoH1T+s/4TekWNAed2kGYz0RmAFvemcyxZDznjw==
Received: from PH0P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::34)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:09 +0000
Received: from MW2PEPF00014676.namprd04.prod.outlook.com
 (2603:10b6:510:d3:cafe::a6) by PH0P220CA0020.outlook.office365.com
 (2603:10b6:510:d3::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 14:02:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF00014676.mail.protection.outlook.com (10.167.249.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:35 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:34 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:32 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:16 +0200
Subject: [PATCH rdma-next 05/11] RDMA/mlx5: Cache the MR core device and
 resolve the MW's via its PD
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-mlx5-sd-prep-v1-5-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=56699;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=FlhlHQl+OmWONwukdHRPt/KChhZmRc1JY3jQgXLyTJ4=;
 b=2ikS4c2LCbt0NwbCto04TX3If/6Wxwjmaiq4oXk+gMujvrQqlf5zQ92cu7/jlPR7fEuykQlUY
 JE91+7Z797cDQzh0sD/V+IYlGO3b+z0Ee61fuynJlHfvKJGe3/cys+u
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014676:EE_|MW6PR12MB8959:EE_
X-MS-Office365-Filtering-Correlation-Id: aa2655c4-ce4c-4200-1491-08df44b35ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|6133799003|261009221727099003|261009221227099003|261009223027099003|261009223327099003|261009220027099003|260925022911599003|11063799006|260925021911599003|56012099006|260925021311599003|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	her+C0RuhQA5OavUdsToyQHwc/GKpgX2M8GP2QT5T36GcanZQRjt7bIaEABONxRfsQFJbTfZD7A1vwZ9bmVdxdCRw8RjjML1xzGcs69IcTjB3MBCISYNZwe9PhfB+DXmoL4N2BHYfbRiwsWBCdnecmqsTFPsX4gcWygSfbUJXkxO8VtbfACAjouHyrYQwe0y9bAxruskGY3QPzr01/duxi4JKas1c9tp23/pIZEQbt174PLnVD3lCP5+dhscqouHfwFP1hjf+4Gvi4sMsybYagMlUBOHgicm+BR/LNXmDZbeiN/BGkjBDh3E2p/pq6qBNCszSxfeMBOv+X/E7dctaTx2ByZFkUlPBBnr1GNdE7R1Oe4bOYgM3Rg0IV2kboejrPIsGxzmimsV9cWbOqgO/HDLBsAvoOIpmz4soBoEsgE4A1nK9kla225d0I0iV16l3/0EzlmTEn47OzHRmN/1AWxJbtTn+3Ks3mXyD6RB/+D8hm93hiexo3WP2FD7rFB66vMXVpKgN4waaap6Co1KWbMpeq1HCFGlfwGYYkCkg4yLAjRBkB5d+KsZiYCQlFzJDqUpii/4bvCnfYYKKw9W+Ns2Timlcm62IGSA2wXoaT9HUqdv8WQdLiQD+2gW+qjq8oJXt5asgHb143+NMQ6UmDsx5fUKO1I4Hjpatrj6o3IrlYDwdKj5qQeq0TA/kUDjfebJ4wQUr9xVLMUu4ukghA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(261009221727099003)(261009221227099003)(261009223027099003)(261009223327099003)(261009220027099003)(260925022911599003)(11063799006)(260925021911599003)(56012099006)(260925021311599003)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Suq+H59c+qkOrDcRbbC+j3Oq37zsAF+cjhAsJKCNqyrAMK7vOsVjh+q7V6sLZJEDYOqpcdfOKdnfNaEwBXXUG6hbQI5ZZUN51AfiJwQngp5f1FulRoehvK0Od8/P+G/XvCpmgVly+G3/8ZwjiFNAfOaAh+dOqmcyI3EuwH0gbBhponIEXXNVS9wPW7tRkpJCF8op+k5sBFZABDvvZluR57fBxVPe2nFpaV+1FYhp1Wz6EgbCJ8dVgK63N81Lyk5dimAwi3je2g0G66okNGI4JqjJAOtdOqJdwPM6j16gDgH4O4mJ3yDNx0iUk5OT+o/Pd9O4aO+8kdl6rBuQPW/ZJOBpy+uF/0q875CaMufhjWPENUduk6CTF4pW0h1mU3iJMcd7RdTJJ8s/yoGvyxBaeQqNTx2fNUrWCUHQSs+rduiwDVBFZiTQkCNAuX+xr4Hn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:09.0640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2655c4-ce4c-4200-1491-08df44b35ee4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014676.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959

From: Akiva Goldberger <agoldberger@nvidia.com>

Add mr_to_mdev() and mw_to_mdev() to reach the core device of an MR or
an MW from the resource itself instead of dev->mdev.

An MW resolves its core device through its PD, like the other resources
in this series. An MR cannot: ib_mr->pd is not a fixed pointer, since
IB_MR_REREG_PD replaces it in place, and ODP page faults, prefetch and
mmu notifier invalidation reach an MR without the uobject lock that
protects it. Store the core device in the MR when it is created instead.
MRs taken from the MR cache get it from their caller, which resolves it
from the PD or from the parent implicit ODP MR.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  49 ++++++----
 drivers/infiniband/hw/mlx5/mr.c      | 172 ++++++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/odp.c     |  34 ++++---
 drivers/infiniband/hw/mlx5/umr.c     | 127 +++++++++++++-------------
 drivers/infiniband/hw/mlx5/umr.h     |  22 ++---
 drivers/infiniband/hw/mlx5/wr.c      |   3 +-
 7 files changed, 226 insertions(+), 183 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index aa27fce2e197c22a9b2ebdfae5c96cbd0a41102f..6d390e784b2f9eed524db40b8c9e2927c7de50a0 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2382,7 +2382,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	MLX5_SET(umem, umem, page_offset,
 		 ib_umem_dma_offset(obj->umem, page_size));
 
-	if (mlx5_umem_needs_ats(dev, obj->umem, access))
+	if (mlx5_umem_needs_ats(dev->mdev, obj->umem, access))
 		MLX5_SET(umem, umem, ats, 1);
 
 	mlx5_ib_populate_pas(obj->umem, page_size, mtt,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index feca1db57921f34dcdb687d1eca59fecc2fd385f..f110803cd30694f05ce7d5bf9fdd35e6b5c003fd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -680,6 +680,7 @@ struct mlx5_ib_mkey {
 struct mlx5_ib_mr {
 	struct ib_mr ibmr;
 	struct mlx5_ib_mkey mmkey;
+	struct mlx5_core_dev *mdev;
 
 	struct ib_umem *umem;
 	/* The mr is data direct related */
@@ -1290,6 +1291,16 @@ static inline struct mlx5_core_dev *srq_to_mdev(struct mlx5_core_srq *msrq)
 	return pd_to_mdev(to_mibsrq(msrq)->ibsrq.pd);
 }
 
+static inline struct mlx5_core_dev *mr_to_mdev(struct mlx5_ib_mr *mr)
+{
+	return mr->mdev;
+}
+
+static inline struct mlx5_core_dev *mw_to_mdev(struct ib_mw *ibmw)
+{
+	return pd_to_mdev(ibmw->pd);
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
@@ -1429,6 +1440,7 @@ int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
 int mlx5r_frmr_pools_init(struct ib_device *device);
 void mlx5r_frmr_pools_cleanup(struct ib_device *device);
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_dev *mdev,
 				       int access_flags, int access_mode,
 				       int ndescs);
 
@@ -1716,10 +1728,10 @@ static inline bool rt_supported(int ts_cap)
  *
  * For now assume if the umem is a dma_buf then it is P2P.
  */
-static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
+static inline bool mlx5_umem_needs_ats(struct mlx5_core_dev *mdev,
 				       struct ib_umem *umem, int access_flags)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
+	if (!MLX5_CAP_GEN(mdev, ats) || !umem->is_dmabuf)
 		return false;
 	return access_flags & IB_ACCESS_RELAXED_ORDERING;
 }
@@ -1733,39 +1745,39 @@ static inline u32 smi_to_native_portnum(struct mlx5_ib_dev *dev, u32 port)
 	return (port - 1) / dev->num_ports + 1;
 }
 
-static inline unsigned int get_max_log_entity_size_cap(struct mlx5_ib_dev *dev,
-						       int access_mode)
+static inline unsigned int
+get_max_log_entity_size_cap(struct mlx5_core_dev *mdev, int access_mode)
 {
 	int max_log_size = 0;
 
 	if (access_mode == MLX5_MKC_ACCESS_MODE_MTT)
 		max_log_size =
-			MLX5_CAP_GEN_2(dev->mdev, max_mkey_log_entity_size_mtt);
+			MLX5_CAP_GEN_2(mdev, max_mkey_log_entity_size_mtt);
 	else if (access_mode == MLX5_MKC_ACCESS_MODE_KSM)
 		max_log_size = MLX5_CAP_GEN_2(
-			dev->mdev, max_mkey_log_entity_size_fixed_buffer);
+			mdev, max_mkey_log_entity_size_fixed_buffer);
 
 	if (!max_log_size ||
 	    (max_log_size > 31 &&
-	     !MLX5_CAP_GEN_2(dev->mdev, umr_log_entity_size_5)))
+	     !MLX5_CAP_GEN_2(mdev, umr_log_entity_size_5)))
 		max_log_size = 31;
 
 	return max_log_size;
 }
 
-static inline unsigned int get_min_log_entity_size_cap(struct mlx5_ib_dev *dev,
-						       int access_mode)
+static inline unsigned int
+get_min_log_entity_size_cap(struct mlx5_core_dev *mdev, int access_mode)
 {
 	int min_log_size = 0;
 
 	if (access_mode == MLX5_MKC_ACCESS_MODE_KSM &&
-	    MLX5_CAP_GEN_2(dev->mdev,
+	    MLX5_CAP_GEN_2(mdev,
 			   min_mkey_log_entity_size_fixed_buffer_valid))
 		min_log_size = MLX5_CAP_GEN_2(
-			dev->mdev, min_mkey_log_entity_size_fixed_buffer);
+			mdev, min_mkey_log_entity_size_fixed_buffer);
 	else
 		min_log_size =
-			MLX5_CAP_GEN_2(dev->mdev, log_min_mkey_entity_size);
+			MLX5_CAP_GEN_2(mdev, log_min_mkey_entity_size);
 
 	min_log_size = max(min_log_size, MLX5_ADAPTER_PAGE_SHIFT);
 	return min_log_size;
@@ -1776,14 +1788,16 @@ static inline unsigned int get_min_log_entity_size_cap(struct mlx5_ib_dev *dev,
  * specifies both the page_offset and the on-the-wire IOVA
  */
 static __always_inline unsigned long
-mlx5_umem_mkc_find_best_pgsz(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+mlx5_umem_mkc_find_best_pgsz(struct mlx5_core_dev *mdev, struct ib_umem *umem,
 			     u64 iova, int access_mode)
 {
 	unsigned int max_log_entity_size_cap, min_log_entity_size_cap;
 	unsigned long bitmap;
 
-	max_log_entity_size_cap = get_max_log_entity_size_cap(dev, access_mode);
-	min_log_entity_size_cap = get_min_log_entity_size_cap(dev, access_mode);
+	max_log_entity_size_cap =
+		get_max_log_entity_size_cap(mdev, access_mode);
+	min_log_entity_size_cap =
+		get_min_log_entity_size_cap(mdev, access_mode);
 
 	bitmap = GENMASK_ULL(max_log_entity_size_cap, min_log_entity_size_cap);
 
@@ -1795,10 +1809,11 @@ mlx5_umem_mkc_find_best_pgsz(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 }
 
 static inline unsigned long
-mlx5_umem_dmabuf_find_best_pgsz(struct ib_umem_dmabuf *umem_dmabuf,
+mlx5_umem_dmabuf_find_best_pgsz(struct mlx5_core_dev *mdev,
+				struct ib_umem_dmabuf *umem_dmabuf,
 				int access_mode)
 {
-	return mlx5_umem_mkc_find_best_pgsz(to_dev(umem_dmabuf->umem.ibdev),
+	return mlx5_umem_mkc_find_best_pgsz(mdev,
 					    &umem_dmabuf->umem,
 					    umem_dmabuf->umem.iova,
 					    access_mode);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1262d3ebc59213bfc3188042d25c625c6cfa43c2..c30da9eb9659ebfa635d9480c0a44591618980c7 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -46,9 +46,9 @@
 #include "umr.h"
 #include "dmah.h"
 
-static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
+static int mkey_max_umr_order(struct mlx5_core_dev *mdev)
 {
-	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
+	if (MLX5_CAP_GEN(mdev, umr_extended_translation_offset))
 		return MLX5_MAX_UMR_EXTENDED_SHIFT;
 	return MLX5_MAX_UMR_SHIFT;
 }
@@ -62,7 +62,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 					  struct ib_pd *pd)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 
 	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
@@ -71,13 +71,13 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lr, 1);
 
 	if (acc & IB_ACCESS_RELAXED_ORDERING) {
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
+		if (MLX5_CAP_GEN(mdev, relaxed_ordering_write))
 			MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
 
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
-		    (MLX5_CAP_GEN(dev->mdev,
+		if (MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+		    (MLX5_CAP_GEN(mdev,
 				  relaxed_ordering_read_pci_enabled) &&
-		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
+		     pcie_relaxed_ordering_enabled(mdev->pdev)))
 			MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
 	}
 
@@ -97,12 +97,13 @@ static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 }
 
 static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
+			       struct mlx5_core_dev *mdev,
 			       struct mlx5_ib_mkey *mkey, u32 *in, int inlen)
 {
 	int ret;
 
 	assign_mkey_variant(dev, &mkey->key, in);
-	ret = mlx5_core_create_mkey(dev->mdev, &mkey->key, in, inlen);
+	ret = mlx5_core_create_mkey(mdev, &mkey->key, in, inlen);
 	if (!ret)
 		init_waitqueue_head(&mkey->wait);
 
@@ -113,7 +114,8 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	WARN_ON(xa_load(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key)));
 
-	return mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
+	return mlx5_core_destroy_mkey(mr_to_mdev(mr),
+				      mr->mmkey.key);
 }
 
 static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
@@ -135,25 +137,25 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 	return ret;
 }
 
-static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
+static int get_unchangeable_access_flags(struct mlx5_core_dev *mdev,
 					 int access_flags)
 {
 	int ret = 0;
 
 	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+	    MLX5_CAP_GEN(mdev, atomic) &&
+	    MLX5_CAP_GEN(mdev, umr_modify_atomic_disabled))
 		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(mdev, relaxed_ordering_write) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_write_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    (MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+	     MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled)) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	return ret;
@@ -167,10 +169,12 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 #define MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK GENMASK_ULL(15, 0)
 
 static struct mlx5_ib_mr *
-_mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+_mlx5_frmr_pool_alloc(struct ib_pd *pd, struct ib_umem *umem,
 		      int access_flags, int access_mode,
 		      unsigned long page_size, u16 st_index, u8 ph)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_mr *mr;
 	int err;
 
@@ -178,9 +182,12 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(dev, umem, access_flags);
+	mr->mdev = pd_to_mdev(pd);
+
+	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(mdev, umem,
+						    access_flags);
 	mr->ibmr.frmr.key.access_flags =
-		get_unchangeable_access_flags(dev, access_flags);
+		get_unchangeable_access_flags(mdev, access_flags);
 	mr->ibmr.frmr.key.num_dma_blocks =
 		ib_umem_num_dma_blocks(umem, page_size);
 	mr->ibmr.frmr.key.vendor_key =
@@ -207,12 +214,13 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 }
 
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_dev *mdev,
 				       int access_flags, int access_mode,
 				       int ndescs)
 {
 	struct ib_frmr_key key = {
 		.access_flags =
-			get_unchangeable_access_flags(dev, access_flags),
+			get_unchangeable_access_flags(mdev, access_flags),
 		.vendor_key = access_mode == MLX5_MKC_ACCESS_MODE_MTT ?
 				      0 :
 				      MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK,
@@ -226,6 +234,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = mdev;
+
 	init_waitqueue_head(&mr->mmkey.wait);
 
 	mr->ibmr.frmr.key = key;
@@ -323,7 +333,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	/* check HW capabilities of users requested frmr key */
 	if ((in->ats && !MLX5_CAP_GEN(dev->mdev, ats)) ||
-	    ilog2(in->num_dma_blocks) > mkey_max_umr_order(dev))
+	    ilog2(in->num_dma_blocks) > mkey_max_umr_order(dev->mdev))
 		return -EOPNOTSUPP;
 
 	if (in->vendor_key & ~MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED)
@@ -331,7 +341,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	out->ats = in->ats;
 	out->access_flags =
-		get_unchangeable_access_flags(dev, in->access_flags);
+		get_unchangeable_access_flags(dev->mdev, in->access_flags);
 	out->vendor_key = in->vendor_key;
 	out->num_dma_blocks = in->num_dma_blocks;
 
@@ -370,6 +380,8 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -382,9 +394,10 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	MLX5_SET(mkc, mkc, length64, 1);
 	set_mkc_access_pd_addr_fields(mkc, acc | IB_ACCESS_RELAXED_ORDERING, 0,
 				      pd);
-	MLX5_SET(mkc, mkc, ma_translation_mode, MLX5_CAP_GEN(dev->mdev, ats));
+	MLX5_SET(mkc, mkc, ma_translation_mode,
+		 MLX5_CAP_GEN(pd_to_mdev(pd), ats));
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -450,12 +463,12 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	if (umem->is_dmabuf)
 		page_size = mlx5_umem_dmabuf_default_pgsz(umem, iova);
 	else
-		page_size = mlx5_umem_mkc_find_best_pgsz(dev, umem, iova,
-							 access_mode);
+		page_size = mlx5_umem_mkc_find_best_pgsz(pd_to_mdev(pd), umem,
+							 iova, access_mode);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
 
-	mr = _mlx5_frmr_pool_alloc(dev, umem, access_flags, access_mode,
+	mr = _mlx5_frmr_pool_alloc(pd, umem, access_flags, access_mode,
 				   page_size, st_index, ph);
 	if (IS_ERR(mr))
 		return mr;
@@ -474,6 +487,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 			    u32 crossed_lkey)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	int access_mode = MLX5_MKC_ACCESS_MODE_CROSSING;
 	struct mlx5_ib_mr *mr;
 	void *mkc;
@@ -481,13 +495,15 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 	u32 *in;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev->mdev, crossing_vhca_mkey))
+	if (!MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mr = kzalloc_obj(*mr);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
@@ -497,7 +513,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, crossing_target_vhca_id,
-		 MLX5_CAP_GEN(dev->mdev, vhca_id));
+		 MLX5_CAP_GEN(mdev, vhca_id));
 	MLX5_SET(mkc, mkc, translations_octword_size, crossed_lkey);
 	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode & 0x3);
 	MLX5_SET(mkc, mkc, access_mode_4_2, (access_mode >> 2) & 0x7);
@@ -508,7 +524,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 
 	MLX5_SET(mkc, mkc, free, 0);
 	MLX5_SET(mkc, mkc, umr_en, 0);
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_2;
 
@@ -536,13 +552,14 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				     int access_mode, u16 st_index, u8 ph)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_mr *mr;
 	__be64 *pas;
 	void *mkc;
 	int inlen;
 	u32 *in;
 	int err;
-	bool pg_cap = !!(MLX5_CAP_GEN(dev->mdev, pg)) &&
+	bool pg_cap = !!(MLX5_CAP_GEN(mdev, pg)) &&
 		(access_mode == MLX5_MKC_ACCESS_MODE_MTT) &&
 		(ph == MLX5_IB_NO_PH);
 	bool ksm_mode = (access_mode == MLX5_MKC_ACCESS_MODE_KSM);
@@ -553,6 +570,8 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	mr->ibmr.pd = pd;
 	mr->access_flags = access_flags;
 	mr->page_shift = order_base_2(page_size);
@@ -601,7 +620,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 		MLX5_SET(mkc, mkc, translations_octword_size,
 			 get_octo_len(iova, umem->length, mr->page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, mr->page_shift);
-	if (mlx5_umem_needs_ats(dev, umem, access_flags))
+	if (mlx5_umem_needs_ats(mdev, umem, access_flags))
 		MLX5_SET(mkc, mkc, ma_translation_mode, 1);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
@@ -615,7 +634,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 			MLX5_SET(mkc, mkc, pcie_tph_steering_tag_index, st_index);
 	}
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err) {
 		mlx5_ib_warn(dev, "create mkey failed\n");
 		goto err_2;
@@ -651,6 +670,8 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -664,7 +685,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 	MLX5_SET64(mkc, mkc, len, length);
 	set_mkc_access_pd_addr_fields(mkc, acc, start_addr, pd);
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -752,14 +773,15 @@ static struct ib_mr *create_real_mr(struct ib_pd *pd, struct ib_umem *umem,
 			st_index = mdmah->st_index;
 	}
 
-	xlt_with_umr = mlx5r_umr_can_load_pas(dev, umem->length);
+	xlt_with_umr = mlx5r_umr_can_load_pas(pd_to_mdev(pd), umem->length);
 	if (xlt_with_umr) {
 		mr = alloc_cacheable_mr(pd, umem, iova, access_flags,
 					MLX5_MKC_ACCESS_MODE_MTT,
 					st_index, ph);
 	} else {
 		unsigned long page_size = mlx5_umem_mkc_find_best_pgsz(
-				dev, umem, iova, MLX5_MKC_ACCESS_MODE_MTT);
+				pd_to_mdev(pd), umem, iova,
+				MLX5_MKC_ACCESS_MODE_MTT);
 
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(pd, umem, iova, access_flags, page_size,
@@ -774,7 +796,7 @@ static struct ib_mr *create_real_mr(struct ib_pd *pd, struct ib_umem *umem,
 
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
-	atomic_add(ib_umem_num_pages(umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(umem), &mr_to_mdev(mr)->priv.reg_pages);
 
 	if (xlt_with_umr) {
 		/*
@@ -820,7 +842,7 @@ static struct ib_mr *create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	/* ODP requires xlt update via umr to work. */
-	if (!mlx5r_umr_can_load_pas(dev, length))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd), length))
 		return ERR_PTR(-EINVAL);
 
 	odp = ib_umem_odp_get(&dev->ib_dev, start, length, access_flags,
@@ -956,7 +978,8 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
-	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(mr->umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	umem_dmabuf->private = mr;
 	if (!pinned_mode) {
 		err = mlx5r_odp_create_eq(dev, &dev->odp_pf_eq);
@@ -1061,7 +1084,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 		    offset, virt_addr, length, fd, access_flags, mlx5_access_flags);
 
 	/* dmabuf requires xlt update via umr to work. */
-	if (!mlx5r_umr_can_load_pas(dev, length))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd), length))
 		return ERR_PTR(-EINVAL);
 
 	if (mlx5_access_flags & MLX5_IB_UAPI_REG_DMABUF_ACCESS_DATA_DIRECT)
@@ -1076,7 +1099,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
  * True if the change in access flags can be done via UMR, only some access
  * flags can be updated.
  */
-static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
+static bool can_use_umr_rereg_access(struct mlx5_core_dev *mdev,
 				     unsigned int current_access_flags,
 				     unsigned int target_access_flags)
 {
@@ -1086,7 +1109,7 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
 		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
-	return mlx5r_umr_can_reconfig(dev, current_access_flags,
+	return mlx5r_umr_can_reconfig(mdev, current_access_flags,
 				      target_access_flags);
 }
 
@@ -1095,13 +1118,12 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 				  int new_access_flags, u64 iova,
 				  unsigned long *page_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	u8 access_mode;
 
 	/* We only track the allocated sizes of MRs from the frmr pools */
 	if (!mr->ibmr.frmr.pool)
 		return false;
-	if (!mlx5r_umr_can_load_pas(dev, new_umem->length))
+	if (!mlx5r_umr_can_load_pas(mr_to_mdev(mr), new_umem->length))
 		return false;
 
 	access_mode = mr->ibmr.frmr.key.vendor_key &
@@ -1110,7 +1132,8 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 			      MLX5_MKC_ACCESS_MODE_MTT;
 
 	*page_size =
-		mlx5_umem_mkc_find_best_pgsz(dev, new_umem, iova, access_mode);
+		mlx5_umem_mkc_find_best_pgsz(mr_to_mdev(mr), new_umem, iova,
+					     access_mode);
 	if (WARN_ON(!*page_size))
 		return false;
 	return (mr->ibmr.frmr.key.num_dma_blocks) >=
@@ -1121,7 +1144,6 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			 int access_flags, int flags, struct ib_umem *new_umem,
 			 u64 iova, unsigned long page_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	int upd_flags = MLX5_IB_UPD_XLT_ADDR | MLX5_IB_UPD_XLT_ENABLE;
 	struct ib_umem *old_umem = mr->umem;
 	int err;
@@ -1156,9 +1178,11 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 		return err;
 	}
 
-	atomic_sub(ib_umem_num_pages(old_umem), &dev->mdev->priv.reg_pages);
+	atomic_sub(ib_umem_num_pages(old_umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	ib_umem_release(old_umem);
-	atomic_add(ib_umem_num_pages(new_umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(new_umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	return 0;
 }
 
@@ -1212,7 +1236,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		struct ib_umem *umem;
 
 		/* Fast path for PD/access change */
-		if (can_use_umr_rereg_access(dev, mr->access_flags,
+		if (can_use_umr_rereg_access(mr_to_mdev(mr), mr->access_flags,
 					     new_access_flags)) {
 			err = mlx5r_umr_rereg_pd_access(mr, new_pd,
 							new_access_flags);
@@ -1233,7 +1257,8 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			return ERR_PTR(err);
 		umem = mr->umem;
 		mr->umem = NULL;
-		atomic_sub(ib_umem_num_pages(umem), &dev->mdev->priv.reg_pages);
+		atomic_sub(ib_umem_num_pages(umem),
+			   &mr_to_mdev(mr)->priv.reg_pages);
 
 		return create_real_mr(new_pd, umem, mr->ibmr.iova,
 				      new_access_flags, NULL);
@@ -1247,7 +1272,8 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		goto recreate;
 
 	if (!(new_access_flags & IB_ACCESS_ON_DEMAND) &&
-	    can_use_umr_rereg_access(dev, mr->access_flags, new_access_flags)) {
+	    can_use_umr_rereg_access(mr_to_mdev(mr), mr->access_flags,
+				     new_access_flags)) {
 		struct ib_umem *new_umem;
 		unsigned long page_size;
 
@@ -1280,13 +1306,11 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 }
 
 static int
-mlx5_alloc_priv_descs(struct ib_device *device,
-		      struct mlx5_ib_mr *mr,
+mlx5_alloc_priv_descs(struct mlx5_ib_mr *mr,
 		      int ndescs,
 		      int desc_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(device);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct device *ddev = &mr_to_mdev(mr)->pdev->dev;
 	int size = ndescs * desc_size;
 	int add_size;
 	int ret;
@@ -1322,11 +1346,9 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
 	if (!mr->umem && !mr->data_direct &&
 	    mr->ibmr.type != IB_MR_TYPE_DM && mr->descs) {
-		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
-		struct mlx5_ib_dev *dev = to_dev(device);
 
-		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
+		dma_unmap_single(&mr_to_mdev(mr)->pdev->dev, mr->desc_map, size,
 				 DMA_TO_DEVICE);
 		kfree(mr->descs_alloc);
 		mr->descs = NULL;
@@ -1437,6 +1459,7 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct mlx5_ib_dev *dev = to_dev(ibmr->device);
 	int rc;
 
@@ -1467,11 +1490,11 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 			mr->klm_mr = NULL;
 		}
 
-		if (mlx5_core_destroy_psv(dev->mdev,
+		if (mlx5_core_destroy_psv(mdev,
 					  mr->sig->psv_memory.psv_idx))
 			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
 				     mr->sig->psv_memory.psv_idx);
-		if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_wire.psv_idx))
+		if (mlx5_core_destroy_psv(mdev, mr->sig->psv_wire.psv_idx))
 			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 				     mr->sig->psv_wire.psv_idx);
 		kfree(mr->sig);
@@ -1488,7 +1511,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 
 		if (!is_odp)
 			atomic_sub(ib_umem_num_pages(mr->umem),
-				   &dev->mdev->priv.reg_pages);
+				   &mdev->priv.reg_pages);
 		ib_umem_release(mr->umem);
 		if (is_odp)
 			mlx5_ib_free_odp_mr(mr);
@@ -1534,7 +1557,6 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 				   int access_mode, int page_shift)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
@@ -1549,7 +1571,8 @@ static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
 	if (access_mode == MLX5_MKC_ACCESS_MODE_PA ||
 	    access_mode == MLX5_MKC_ACCESS_MODE_MTT)
-		MLX5_SET(mkc, mkc, ma_translation_mode, MLX5_CAP_GEN(dev->mdev, ats));
+		MLX5_SET(mkc, mkc, ma_translation_mode,
+			 MLX5_CAP_GEN(pd_to_mdev(pd), ats));
 }
 
 static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
@@ -1563,13 +1586,13 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	mr->desc_size = desc_size;
 	mr->max_descs = ndescs;
 
-	err = mlx5_alloc_priv_descs(pd->device, mr, ndescs, desc_size);
+	err = mlx5_alloc_priv_descs(mr, ndescs, desc_size);
 	if (err)
 		return err;
 
 	mlx5_set_umr_free_mkey(pd, in, ndescs, access_mode, page_shift);
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_free_descs;
 
@@ -1599,6 +1622,8 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	mr->ibmr.pd = pd;
 	mr->ibmr.device = pd->device;
 
@@ -1648,6 +1673,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				      u32 *in, int inlen)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	u32 psv_index[2];
 	void *mkc;
 	int err;
@@ -1657,7 +1683,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 		return -ENOMEM;
 
 	/* create mem & wire PSVs */
-	err = mlx5_core_create_psv(dev->mdev, to_mpd(pd)->pdn, 2, psv_index);
+	err = mlx5_core_create_psv(mdev, to_mpd(pd)->pdn, 2, psv_index);
 	if (err)
 		goto err_free_sig;
 
@@ -1709,10 +1735,10 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
 	mr->klm_mr = NULL;
 err_destroy_psv:
-	if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_memory.psv_idx))
+	if (mlx5_core_destroy_psv(mdev, mr->sig->psv_memory.psv_idx))
 		mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
 			     mr->sig->psv_memory.psv_idx);
-	if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_wire.psv_idx))
+	if (mlx5_core_destroy_psv(mdev, mr->sig->psv_wire.psv_idx))
 		mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 			     mr->sig->psv_wire.psv_idx);
 err_free_sig:
@@ -1736,6 +1762,8 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -1829,7 +1857,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	MLX5_SET(mkc, mkc, en_rinval, !!((ibmw->type == IB_MW_TYPE_2)));
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
-	err = mlx5_ib_create_mkey(dev, &mw->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mw_to_mdev(ibmw), &mw->mmkey, in, inlen);
 	if (err)
 		goto free;
 
@@ -1855,7 +1883,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	return 0;
 
 free_mkey:
-	mlx5_core_destroy_mkey(dev->mdev, mw->mmkey.key);
+	mlx5_core_destroy_mkey(mw_to_mdev(ibmw), mw->mmkey.key);
 free:
 	kfree(in);
 	return err;
@@ -1874,7 +1902,7 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 		 */
 		mlx5r_deref_wait_odp_mkey(&mmw->mmkey);
 
-	return mlx5_core_destroy_mkey(dev->mdev, mmw->mmkey.key);
+	return mlx5_core_destroy_mkey(mw_to_mdev(mw), mmw->mmkey.key);
 }
 
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index a4318b11cd81b73f3907015d54d15ef14df61b2b..bb1de90df73e1c1bfa6211531ea401239e0daf9f 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -107,7 +107,7 @@ static u8 mlx5_imr_ksm_page_shift;
 static void populate_ksm(struct mlx5_ksm *pksm, size_t idx, size_t nentries,
 			struct mlx5_ib_mr *imr, int flags)
 {
-	struct mlx5_core_dev *mdev = mr_to_dev(imr)->mdev;
+	struct mlx5_core_dev *mdev = mr_to_mdev(imr);
 	struct mlx5_ksm *end = pksm + nentries;
 	u64 step = MLX5_CAP_ODP(mdev, mem_page_fault) ? mlx5_imr_mtt_size : 0;
 	__be32 key = MLX5_CAP_ODP(mdev, mem_page_fault) ?
@@ -254,7 +254,7 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 		return;
 	}
 
-	if (MLX5_CAP_ODP(mr_to_dev(mr)->mdev, mem_page_fault))
+	if (MLX5_CAP_ODP(mr_to_mdev(mr), mem_page_fault))
 		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->mmkey.key));
 	xa_unlock(&imr->implicit_children);
@@ -367,7 +367,8 @@ static void internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 
 	memset(caps, 0, sizeof(*caps));
 
-	if (!MLX5_CAP_GEN(dev->mdev, pg) || !mlx5r_umr_can_load_pas(dev, 0))
+	if (!MLX5_CAP_GEN(dev->mdev, pg) ||
+	    !mlx5r_umr_can_load_pas(dev->mdev, 0))
 		return;
 
 	caps->general_caps = IB_ODP_SUPPORT;
@@ -425,7 +426,7 @@ static void internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	    !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled) &&
 	    mlx5_imr_ksm_entries != 0 &&
 	    !(mlx5_imr_ksm_page_shift >
-	      get_max_log_entity_size_cap(dev, MLX5_MKC_ACCESS_MODE_KSM)))
+	      get_max_log_entity_size_cap(dev->mdev, MLX5_MKC_ACCESS_MODE_KSM)))
 		caps->general_caps |= IB_ODP_SUPPORT_IMPLICIT;
 }
 
@@ -481,7 +482,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_mr_cache_alloc(dev, imr->access_flags,
+	mr = mlx5_mr_cache_alloc(dev, mr_to_mdev(imr), imr->access_flags,
 				 MLX5_MKC_ACCESS_MODE_MTT,
 				 mlx5_imr_mtt_entries);
 	if (IS_ERR(mr)) {
@@ -529,7 +530,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 		goto out_lock;
 	}
 
-	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
+	if (MLX5_CAP_ODP(mr_to_mdev(imr), mem_page_fault)) {
 		ret = xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
 			       &mr->mmkey, GFP_KERNEL);
 		if (xa_is_err(ret)) {
@@ -557,8 +558,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
  * The null mkey is created with the properties to enable getting the page
  * fault for every time it is accessed and having all relevant access flags.
  */
-static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
-				       struct mlx5_ib_mr *imr,
+static int alloc_implicit_mr_null_mkey(struct mlx5_ib_mr *imr,
 				       struct mlx5_ib_pd *pd)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + 64;
@@ -590,7 +590,8 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 	MLX5_SET64(mkc, mkc, start_addr, 0);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
-	err = mlx5_core_create_mkey(dev->mdev, &imr->null_mmkey.key, in, inlen);
+	err = mlx5_core_create_mkey(mr_to_mdev(imr), &imr->null_mmkey.key, in,
+				    inlen);
 	if (err)
 		goto free_in;
 
@@ -609,14 +610,16 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	struct mlx5_ib_mr *imr;
 	int err;
 
-	if (!mlx5r_umr_can_load_pas(dev, mlx5_imr_mtt_entries * PAGE_SIZE))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd),
+				    mlx5_imr_mtt_entries * PAGE_SIZE))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	umem_odp = ib_umem_odp_alloc_implicit(&dev->ib_dev, access_flags);
 	if (IS_ERR(umem_odp))
 		return ERR_CAST(umem_odp);
 
-	imr = mlx5_mr_cache_alloc(dev, access_flags, MLX5_MKC_ACCESS_MODE_KSM,
+	imr = mlx5_mr_cache_alloc(dev, pd_to_mdev(pd), access_flags,
+				  MLX5_MKC_ACCESS_MODE_KSM,
 				  mlx5_imr_ksm_entries);
 	if (IS_ERR(imr)) {
 		ib_umem_odp_release(umem_odp);
@@ -633,8 +636,8 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	imr->is_odp_implicit = true;
 	xa_init(&imr->implicit_children);
 
-	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
-		err = alloc_implicit_mr_null_mkey(dev, imr, pd);
+	if (MLX5_CAP_ODP(pd_to_mdev(pd), mem_page_fault)) {
+		err = alloc_implicit_mr_null_mkey(imr, pd);
 		if (err)
 			goto out_mr;
 
@@ -683,7 +686,7 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
 		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->null_mmkey.key));
 
-		mlx5_core_destroy_mkey(mr_to_dev(mr)->mdev,
+		mlx5_core_destroy_mkey(mr_to_mdev(mr),
 				       mr->null_mmkey.key);
 	}
 }
@@ -858,7 +861,8 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
 		return err;
 	}
 
-	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf, access_mode);
+	page_size = mlx5_umem_dmabuf_find_best_pgsz(mr_to_mdev(mr), umem_dmabuf,
+						    access_mode);
 	if (!page_size) {
 		ib_umem_dmabuf_unmap_pages(umem_dmabuf);
 		err = -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index f030885505df5e1fbfb9413d1ff7a2a3d041580d..f9485591130d3276c7344855d7545f89b7d3fb49 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -34,20 +34,20 @@ static __be64 get_umr_disable_mr_mask(void)
 	return cpu_to_be64(result);
 }
 
-static __be64 get_umr_update_translation_mask(struct mlx5_ib_dev *dev)
+static __be64 get_umr_update_translation_mask(struct mlx5_core_dev *mdev)
 {
 	u64 result;
 
 	result = MLX5_MKEY_MASK_LEN |
 		 MLX5_MKEY_MASK_PAGE_SIZE |
 		 MLX5_MKEY_MASK_START_ADDR;
-	if (MLX5_CAP_GEN_2(dev->mdev, umr_log_entity_size_5))
+	if (MLX5_CAP_GEN_2(mdev, umr_log_entity_size_5))
 		result |= MLX5_MKEY_MASK_PAGE_SIZE_5;
 
 	return cpu_to_be64(result);
 }
 
-static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
+static __be64 get_umr_update_access_mask(struct mlx5_core_dev *mdev)
 {
 	u64 result;
 
@@ -56,13 +56,13 @@ static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
 		 MLX5_MKEY_MASK_RR |
 		 MLX5_MKEY_MASK_RW;
 
-	if (MLX5_CAP_GEN(dev->mdev, atomic))
+	if (MLX5_CAP_GEN(mdev, atomic))
 		result |= MLX5_MKEY_MASK_A;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	if (MLX5_CAP_GEN(mdev, relaxed_ordering_write_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	if (MLX5_CAP_GEN(mdev, relaxed_ordering_read_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
 
 	return cpu_to_be64(result);
@@ -77,22 +77,22 @@ static __be64 get_umr_update_pd_mask(void)
 	return cpu_to_be64(result);
 }
 
-static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
+static int umr_check_mkey_mask(struct mlx5_core_dev *mdev, u64 mask)
 {
 	if (mask & MLX5_MKEY_MASK_PAGE_SIZE &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+	    MLX5_CAP_GEN(mdev, umr_modify_entity_size_disabled))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_A &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+	    MLX5_CAP_GEN(mdev, umr_modify_atomic_disabled))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_write_umr))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_READ &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_read_umr))
 		return -EPERM;
 
 	return 0;
@@ -243,8 +243,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 		with_data ? sizeof(struct mlx5r_umr_wqe) :
 			    sizeof(struct mlx5r_umr_wqe) -
 				    sizeof(struct mlx5_wqe_data_seg);
-	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_ctrl_seg *ctrl;
 	union {
@@ -352,14 +351,18 @@ static inline void mlx5r_umr_init_context(struct mlx5r_umr_context *context)
 	init_completion(&context->done);
 }
 
-static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
-				   struct mlx5r_umr_wqe *wqe, bool with_data)
+static int mlx5r_umr_post_send_wait(struct mlx5_ib_mr *mr,
+				    struct mlx5r_umr_wqe *wqe, bool with_data)
 {
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5r_umr_context umr_context;
+	u32 mkey = mr->mmkey.key;
 	int err;
 
-	err = umr_check_mkey_mask(dev, be64_to_cpu(wqe->ctrl_seg.mkey_mask));
+	err = umr_check_mkey_mask(mdev,
+				  be64_to_cpu(wqe->ctrl_seg.mkey_mask));
 	if (WARN_ON(err))
 		return err;
 
@@ -425,7 +428,7 @@ int mlx5r_umr_revoke_mr(struct mlx5_ib_mr *mr)
 	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 
-	if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+	if (mr_to_mdev(mr)->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
 	wqe.ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
@@ -438,16 +441,16 @@ int mlx5r_umr_revoke_mr(struct mlx5_ib_mr *mr)
 	MLX5_SET(mkc, &wqe.mkey_seg, mkey_7_0,
 		 mlx5_mkey_variant(mr->mmkey.key));
 
-	return mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	return mlx5r_umr_post_send_wait(mr, &wqe, false);
 }
 
-static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
+static void mlx5r_umr_set_access_flags(struct mlx5_core_dev *mdev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
 	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
-			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
+		       (MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+			pcie_relaxed_ordering_enabled(mdev->pdev));
 
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
@@ -462,22 +465,22 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			      int access_flags)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
-	wqe.ctrl_seg.mkey_mask = get_umr_update_access_mask(dev);
+	wqe.ctrl_seg.mkey_mask = get_umr_update_access_mask(mdev);
 	wqe.ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
 	wqe.ctrl_seg.flags = MLX5_UMR_CHECK_FREE;
 	wqe.ctrl_seg.flags |= MLX5_UMR_INLINE;
 
-	mlx5r_umr_set_access_flags(dev, &wqe.mkey_seg, access_flags);
+	mlx5r_umr_set_access_flags(mdev, &wqe.mkey_seg, access_flags);
 	MLX5_SET(mkc, &wqe.mkey_seg, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, &wqe.mkey_seg, qpn, 0xffffff);
 	MLX5_SET(mkc, &wqe.mkey_seg, mkey_7_0,
 		 mlx5_mkey_variant(mr->mmkey.key));
 
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, false);
 	if (err)
 		return err;
 
@@ -550,11 +553,9 @@ static void mlx5r_umr_free_xlt(void *xlt, size_t length)
 	kfree(xlt);
 }
 
-static void mlx5r_umr_unmap_free_xlt(struct mlx5_ib_dev *dev, void *xlt,
+static void mlx5r_umr_unmap_free_xlt(struct device *ddev, void *xlt,
 				     struct ib_sge *sg)
 {
-	struct device *ddev = &dev->mdev->pdev->dev;
-
 	dma_unmap_single(ddev, sg->addr, sg->length, DMA_TO_DEVICE);
 	mlx5r_umr_free_xlt(xlt, sg->length);
 }
@@ -562,11 +563,11 @@ static void mlx5r_umr_unmap_free_xlt(struct mlx5_ib_dev *dev, void *xlt,
 /*
  * Create an XLT buffer ready for submission.
  */
-static void *mlx5r_umr_create_xlt(struct mlx5_ib_dev *dev, struct ib_sge *sg,
-				  size_t nents, size_t ent_size,
-				  unsigned int flags)
+static void *mlx5r_umr_create_xlt(struct mlx5_ib_mr *mr, struct device *ddev,
+				  struct ib_sge *sg, size_t nents,
+				  size_t ent_size, unsigned int flags)
 {
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	dma_addr_t dma;
 	void *xlt;
 
@@ -600,12 +601,11 @@ mlx5r_umr_set_update_xlt_ctrl_seg(struct mlx5_wqe_umr_ctrl_seg *ctrl_seg,
 		cpu_to_be16(mlx5r_umr_get_xlt_octo(sg->length));
 }
 
-static void mlx5r_umr_set_update_xlt_mkey_seg(struct mlx5_ib_dev *dev,
-					      struct mlx5_mkey_seg *mkey_seg,
+static void mlx5r_umr_set_update_xlt_mkey_seg(struct mlx5_mkey_seg *mkey_seg,
 					      struct mlx5_ib_mr *mr, u32 pdn,
 					      unsigned int page_shift)
 {
-	mlx5r_umr_set_access_flags(dev, mkey_seg, mr->access_flags);
+	mlx5r_umr_set_access_flags(mr_to_mdev(mr), mkey_seg, mr->access_flags);
 	MLX5_SET(mkc, mkey_seg, pd, pdn);
 	MLX5_SET64(mkc, mkey_seg, start_addr, mr->ibmr.iova);
 	MLX5_SET64(mkc, mkey_seg, len, mr->ibmr.length);
@@ -633,11 +633,11 @@ static void mlx5r_umr_update_offset(struct mlx5_wqe_umr_ctrl_seg *ctrl_seg,
 	ctrl_seg->flags |= MLX5_UMR_TRANSLATION_OFFSET_EN;
 }
 
-static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
-				       struct mlx5r_umr_wqe *wqe,
+static void mlx5r_umr_final_update_xlt(struct mlx5r_umr_wqe *wqe,
 				       struct mlx5_ib_mr *mr, struct ib_sge *sg,
 				       unsigned int flags)
 {
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	bool update_pd_access, update_translation;
 
 	if (flags & MLX5_IB_UPD_XLT_ENABLE)
@@ -648,7 +648,7 @@ static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
 			   flags & MLX5_IB_UPD_XLT_ACCESS;
 
 	if (update_pd_access) {
-		wqe->ctrl_seg.mkey_mask |= get_umr_update_access_mask(dev);
+		wqe->ctrl_seg.mkey_mask |= get_umr_update_access_mask(mdev);
 		wqe->ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
 	}
 
@@ -656,7 +656,8 @@ static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
 		flags & MLX5_IB_UPD_XLT_ENABLE || flags & MLX5_IB_UPD_XLT_ADDR;
 
 	if (update_translation) {
-		wqe->ctrl_seg.mkey_mask |= get_umr_update_translation_mask(dev);
+		wqe->ctrl_seg.mkey_mask |=
+			get_umr_update_translation_mask(mdev);
 		if (!mr->ibmr.length)
 			MLX5_SET(mkc, &wqe->mkey_seg, length64, 1);
 		if (flags & MLX5_IB_UPD_XLT_KEEP_PGSZ)
@@ -674,11 +675,8 @@ static void _mlx5r_umr_init_wqe(struct mlx5_ib_mr *mr,
 				unsigned int flags, u32 pdn,
 				unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-
 	mlx5r_umr_set_update_xlt_ctrl_seg(&wqe->ctrl_seg, flags, sg);
-	mlx5r_umr_set_update_xlt_mkey_seg(dev, &wqe->mkey_seg, mr, pdn,
-					  page_shift);
+	mlx5r_umr_set_update_xlt_mkey_seg(&wqe->mkey_seg, mr, pdn, page_shift);
 	mlx5r_umr_set_update_xlt_data_seg(&wqe->data_seg, sg);
 }
 
@@ -688,7 +686,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 {
 	size_t ent_size = dd ? sizeof(struct mlx5_ksm) : sizeof(struct mlx5_mtt);
 	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct device *ddev = &mr_to_mdev(mr)->pdev->dev;
 	struct mlx5r_umr_wqe wqe = {};
 	size_t processed_blocks = 0;
 	struct ib_block_iter biter;
@@ -712,7 +710,8 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 	if (nblocks)
 		total_blocks = nblocks;
 
-	entry = mlx5r_umr_create_xlt(dev, &sg, total_blocks, ent_size, flags);
+	entry = mlx5r_umr_create_xlt(mr, ddev, &sg, total_blocks, ent_size,
+				     flags);
 	if (!entry)
 		return -ENOMEM;
 
@@ -744,7 +743,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 			dma_sync_single_for_device(ddev, sg.addr, sg.length,
 						   DMA_TO_DEVICE);
 
-			err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe,
+			err = mlx5r_umr_post_send_wait(mr, &wqe,
 						       true);
 			if (err)
 				goto err;
@@ -790,14 +789,14 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 	final_size = curr_entry - entry;
 	sg.length = ALIGN(final_size, MLX5_UMR_FLEX_ALIGNMENT);
 	memset(curr_entry, 0, sg.length - final_size);
-	mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
+	mlx5r_umr_final_update_xlt(&wqe, mr, &sg, flags);
 
 	dma_sync_single_for_device(ddev, sg.addr, sg.length, DMA_TO_DEVICE);
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, true);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, true);
 
 err:
 	sg.length = orig_sg_length;
-	mlx5r_umr_unmap_free_xlt(dev, entry, &sg);
+	mlx5r_umr_unmap_free_xlt(ddev, entry, &sg);
 	return err;
 }
 
@@ -842,9 +841,9 @@ int mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags, u32 pdn)
 	return mlx5r_umr_update_mr_pas_range(mr, flags, pdn, 0, 0);
 }
 
-static bool umr_can_use_indirect_mkey(struct mlx5_ib_dev *dev)
+static bool umr_can_use_indirect_mkey(struct mlx5_core_dev *mdev)
 {
-	return !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled);
+	return !MLX5_CAP_GEN(mdev, umr_indirect_mkey_disabled);
 }
 
 int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
@@ -854,8 +853,8 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 			       ? sizeof(struct mlx5_klm)
 			       : sizeof(struct mlx5_mtt);
 	const int page_align = MLX5_UMR_FLEX_ALIGNMENT / desc_size;
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
+	struct device *ddev = &mdev->pdev->dev;
 	const int page_mask = page_align - 1;
 	struct mlx5r_umr_wqe wqe = {};
 	size_t pages_mapped = 0;
@@ -868,7 +867,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	void *xlt;
 
 	if ((flags & MLX5_IB_UPD_XLT_INDIRECT) &&
-	    !umr_can_use_indirect_mkey(dev))
+	    !umr_can_use_indirect_mkey(mdev))
 		return -EPERM;
 
 	if (WARN_ON(!mr->umem->is_odp))
@@ -883,7 +882,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	}
 	pages_to_map = ALIGN(npages, page_align);
 
-	xlt = mlx5r_umr_create_xlt(dev, &sg, npages, desc_size, flags);
+	xlt = mlx5r_umr_create_xlt(mr, ddev, &sg, npages, desc_size, flags);
 	if (!xlt)
 		return -ENOMEM;
 
@@ -898,8 +897,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	}
 
 	mlx5r_umr_set_update_xlt_ctrl_seg(&wqe.ctrl_seg, flags, &sg);
-	mlx5r_umr_set_update_xlt_mkey_seg(dev, &wqe.mkey_seg, mr, pdn,
-					  page_shift);
+	mlx5r_umr_set_update_xlt_mkey_seg(&wqe.mkey_seg, mr, pdn, page_shift);
 	mlx5r_umr_set_update_xlt_data_seg(&wqe.data_seg, &sg);
 
 	for (pages_mapped = 0;
@@ -925,12 +923,12 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		sg.length = ALIGN(size_to_map, MLX5_UMR_FLEX_ALIGNMENT);
 
 		if (pages_mapped + pages_iter >= pages_to_map)
-			mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
+			mlx5r_umr_final_update_xlt(&wqe, mr, &sg, flags);
 		mlx5r_umr_update_offset(&wqe.ctrl_seg, idx * desc_size);
-		err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, true);
+		err = mlx5r_umr_post_send_wait(mr, &wqe, true);
 	}
 	sg.length = orig_sg_length;
-	mlx5r_umr_unmap_free_xlt(dev, xlt, &sg);
+	mlx5r_umr_unmap_free_xlt(ddev, xlt, &sg);
 	return err;
 }
 
@@ -943,12 +941,12 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 				   unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
 	/* Build UMR wqe: we touch only PAGE_SIZE, so use the dedicated mask */
-	wqe.ctrl_seg.mkey_mask = get_umr_update_translation_mask(dev);
+	wqe.ctrl_seg.mkey_mask =
+		get_umr_update_translation_mask(mr_to_mdev(mr));
 
 	/* MR must be free while page size is modified */
 	wqe.ctrl_seg.flags = MLX5_UMR_CHECK_FREE | MLX5_UMR_INLINE;
@@ -959,7 +957,7 @@ int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 	MLX5_SET64(mkc, &wqe.mkey_seg, start_addr, mr->ibmr.iova);
 	MLX5_SET64(mkc, &wqe.mkey_seg, len, mr->ibmr.length);
 
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, false);
 	if (!err)
 		mr->page_shift = page_shift;
 
@@ -996,7 +994,6 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr, unsigned int flags,
 			       u32 pdn, bool dd)
 {
 	unsigned int old_page_shift = mr->page_shift;
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	unsigned int max_page_shift;
 	size_t page_shift_nblocks;
 	unsigned int max_log_size;
@@ -1006,7 +1003,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr, unsigned int flags,
 	access_mode = dd ? MLX5_MKC_ACCESS_MODE_KSM : MLX5_MKC_ACCESS_MODE_MTT;
 	flags |= MLX5_IB_UPD_XLT_KEEP_PGSZ | MLX5_IB_UPD_XLT_ZAP |
 		 MLX5_IB_UPD_XLT_ATOMIC;
-	max_log_size = get_max_log_entity_size_cap(dev, access_mode);
+	max_log_size = get_max_log_entity_size_cap(mr_to_mdev(mr), access_mode);
 	max_page_shift = order_base_2(mr->ibmr.length);
 	max_page_shift = min(max(max_page_shift, page_shift), max_log_size);
 	/* Count blocks in units of max_page_shift, we will zap exactly this
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index bda7123781a953abbdea578d960ae7c870be66b2..eb01a2300e6169c9b0f35a09313e07b04d151337 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -20,7 +20,7 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev);
 int mlx5r_umr_init(struct mlx5_ib_dev *dev);
 void mlx5r_umr_cleanup(struct mlx5_ib_dev *dev);
 
-static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
+static inline bool mlx5r_umr_can_load_pas(struct mlx5_core_dev *mdev,
 					  size_t length)
 {
 	/*
@@ -31,14 +31,14 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
 	 * quirky hardware by just saying it can't use PAS lists with UMR at
 	 * all.
 	 */
-	if (MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+	if (MLX5_CAP_GEN(mdev, umr_modify_entity_size_disabled))
 		return false;
 
 	/*
 	 * length is the size of the MR in bytes when mlx5_ib_update_xlt() is
 	 * used.
 	 */
-	if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset) &&
+	if (!MLX5_CAP_GEN(mdev, umr_extended_translation_offset) &&
 	    length >= MLX5_MAX_UMR_PAGES * PAGE_SIZE)
 		return false;
 	return true;
@@ -49,26 +49,26 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
  * Older HW cannot use UMR to update certain elements of the MKC. See
  * get_umr_update_access_mask() and umr_check_mkey_mask()
  */
-static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
+static inline bool mlx5r_umr_can_reconfig(struct mlx5_core_dev *mdev,
 					  unsigned int current_access_flags,
 					  unsigned int target_access_flags)
 {
 	unsigned int diffs = current_access_flags ^ target_access_flags;
 
 	if ((diffs & IB_ACCESS_REMOTE_ATOMIC) &&
-	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+	    MLX5_CAP_GEN(mdev, atomic) &&
+	    MLX5_CAP_GEN(mdev, umr_modify_atomic_disabled))
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(mdev, relaxed_ordering_write) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_write_umr))
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    (MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+	     MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled)) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_read_umr))
 		return false;
 
 	return true;
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 3d3fdbce1354f4390b1ebbd14114c0efd93f46df..7d1a64d24df181ad5b23580c00d68a3b48baf960 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -639,7 +639,6 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
 	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
-	struct mlx5_ib_dev *dev = to_dev(pd->ibpd.device);
 	int mr_list_size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
 	bool umr_inline = mr_list_size <= MLX5_IB_SQ_UMR_INLINE_THRESHOLD;
 	bool atomic = wr->access & IB_ACCESS_REMOTE_ATOMIC;
@@ -649,7 +648,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	 * Relaxed Ordering is set implicitly in mlx5_set_umr_free_mkey() and
 	 * kernel ULPs are not aware of it, so we don't set it here.
 	 */
-	if (!mlx5r_umr_can_reconfig(dev, 0, wr->access)) {
+	if (!mlx5r_umr_can_reconfig(mr_to_mdev(mr), 0, wr->access)) {
 		mlx5_ib_warn(
 			to_dev(qp->ibqp.device),
 			"Fast update for MR access flags is not possible\n");

-- 
2.49.0


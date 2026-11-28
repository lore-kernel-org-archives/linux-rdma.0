Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870923;
	b=ieYYhRDknDKRf4QOB8T1b9Pn0tGXMruVagjrmCnljT/rlCbZKlGwTcl8ylrKpNepQE5w
	 new/gHbz7wtsWFlFKoZd0ReQAZ7VZIR94ZztGlOnpr1Pt1Hu1YVnwazIoeEij07CQo9iN
	 2glGJCtWcgwP9vQB/dk/1MHk9DfdeDW/LoKlusCkv7ZtidflkMQBn+jgWz9UFfFZBqJaz
	 Gli7DCPkcuxHhWmqZfkabe3HsOa7wr4z7JXKX2H8XheeFVpB/SFkKaqlXUM4uEBjZJnVP
	 7nbwllNh8x7YcR7Xj19v3fn4WtZS5O4kQBgt/v7/38vkljF/UXE9q4Jc9dkIFMVKNhg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870923;
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
	bh=NWidHt1ckBuwUwf/z9/K9jPjWPLiLpkxAS/9FHnQFYQ=;
	b=uv7C2l/uWqGbtArK79O7TcLH/i+hJ6J5lu+WHC55dLC+vltTbi/nvT3JGk+hSE0M66a0
	 57LzXd30chDH680rSYscsKy+t0NfAn2Yz7VxBvjSJFxtB3QNWc0OrXfc4Z3+Ii95LFQV3
	 WIwBO82pCaTGYLc9whJRqbZKASDsQ2OKfYON8VHF7kLCgg3nLaVZbBU80a+l6Ihwm6G+B
	 zFGMLhVLCbeL3i/+82jY08UJjHJprB/ZrOdoCLb4xBgOqJvM5R8h8eLcQdWbV3mK3BM6K
	 jm7Ox9Y3FJDIF2Jpkz57skavIg3PhadD89JwckTidV3kD/Ay6pTEjuDncK5EqvFbtZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAtc8Kjp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.46
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42A1606A686;
	Sat, 28 Nov 2026 13:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A42A1606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAtc8Kjp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hy0Q3TlOgtwOzpQDmOunpne9mB6py2PDlTXFS8lRTekCj4o2Tmdm+0clCPVuS/8pLszYNlOxLGDLZiSUOga0wHidXmi7ruOR0glMDZZQ7M2mzZdT4GaY6NXQ47bwQTOikG7zjyuKqgDsw2Gh9CQUl+HDB2Ua063GKRNJ6EWVxC1qyIWFaL+7/Zc96M4xxoHPinWviCr53P8sJMVY/gUHMQ2wroc1SFBQ2N4JRAeGWe15sTMU6Mfsit0GvHVVXCzjxfhOrNC3bkOQHPnkE18KzgLu8xJ8uX6M5SN+CJ0UsJ+D/MnMGuGpZsfHz07IpTdya5+EgXFvr4lrlaQgXkoROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWidHt1ckBuwUwf/z9/K9jPjWPLiLpkxAS/9FHnQFYQ=;
 b=HyCWTHaXb/IhGmZaLKXmmU56LJn8onmMvaDzi3atnAFRW0uuAR2GkKgLImx6BiAOB0Prza7Mg3cMRSKLioMO6kXk9FwtxX6btQZ/xjRefv8pp4EckgeVtfGsdsRlUiDC5Npc01zo4xmDVUdAd2FnGXnberqI/SFvBjNtz2HO8BnxHLfm4Uxev4W7VsCiMDEElIkHyGl8AMBM93yG06tPktOf6X90dPlDFQ9FMBAMwRXHnfZ9LQNEbloGKKhpEsn4tEDntabRBsV0nf5P+b1M/FZJSUz6orJRtkLWr4pQnLKZ7KWo78vqK44WTQpiL20jPTtEDgb9+6u9ae9zfCZQsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWidHt1ckBuwUwf/z9/K9jPjWPLiLpkxAS/9FHnQFYQ=;
 b=YAtc8Kjpz2TWVlMp2LgdvFMV+99vLzaOgZ5Ge01GBtMSa9MlfE2lOEkIPIShMsgjtVgkoIw5wPF0ApNRQlUMNGk6g9UmKWAm+tVID9os/2Onk7CG4OwIx5mBSVHEvmXYUIo/HHxhsy4W8vXgU/c6PCXO7IgDOHSkDGFNd0+2aArZLCZTdE4AOEYx3W1kvvpj/wZXmOMjS8DfWpQjmpgl0mDMpTzkNMd29MEUsLk7muiwiOFxmqP8i3WGvQ31APRl90cewI2GRNUthU6ByOWF3uMHjdsDyHGXOchT6VbsWWMyvB4zXDuuTC2DMW/WoFz+b8UeFaeqqls6gm9WqDTfPQ==
Received: from BN0PR04CA0105.namprd04.prod.outlook.com (2603:10b6:408:ec::20)
 by SA1PR12MB8141.namprd12.prod.outlook.com (2603:10b6:806:339::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:01:54 +0000
Received: from BN6PEPF0000006F.namprd03.prod.outlook.com
 (2603:10b6:408:ec:cafe::99) by BN0PR04CA0105.outlook.office365.com
 (2603:10b6:408:ec::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN6PEPF0000006F.mail.protection.outlook.com (10.167.248.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:45 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:45 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:43 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:23 +0200
Subject: [PATCH rdma-next v2 10/11] RDMA/mlx5: Resolve the bfreg UAR-index
 core device from the ucontext
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
Message-ID: <20261128-mlx5-sd-prep-v2-10-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=9455;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=x8qjNs6ktxgb1w8wFLP72DVRVCqi4JvbwbwsQ7jnxEk=;
 b=Z6nJPzb7dERjqWKDCm1hdinl7+IPu0ftfOPKmH+OQ9J7+AAwa00BEbwkgiiMJ7Jr4FfyP9pP8
 OQOwJFLUP5uD7OJIHbLIMcgFsBLgQSp05RzpVGDDqtTEdzf+6Sgvuex
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF0000006F:EE_|SA1PR12MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b81469-cb78-423c-f035-08df4d4fc6c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|23010399003|11063799006|261009223027099003|22082099003|18002099003|260925022911599003|260925021911599003|260925021311599003|10067099003|56012099006|261028144727099003|261026140227099003|261022105027099003|261102123227099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	YIj497iYJH/4i+U6mkfnVjqSWbPVRQgIhJPn/VkpSLSa8Q5aTjD8j+g1Le0nsna771r4hMygUxCUpmR/g7cbNqsg5YRESNlNo+TqroSlK+DvE8MHPjj1iRN5Zp5ReBaAYEk8n9z2hlTLlo4q0NCbNCM/jG15PJH5+Pt1nS6BZ04mwKfgIg+W3bama2LOE1F/TB90PCrsMUmYceCKqAU613F2yuxat5xj4LEwimrR68AcanVWsesO2AuOWJ12eil9NuBed/SKFiV0+2tA4kga5w66yot69TOHBfui+FbB02wteLtqfgtk6p+5YmUL7d/tG2Y8hK7VQEVCQaBTSpxHuB3e+iVo8aa/xEXjT9QN0x4kQt4pXyjaNfJZD1xf3KdiBCat8uOgB9E8EHRNR8k7WpZkmanFjSKql2KlonVEPfBZD2cCr5FCGA9xKgOt30/ME7NvSgJfmZD+1iQ7yf83mLkFQ/+x4U797seA/QvNbVDR50cOpGuYhOgaVBNEI/32njyBNrr3F8hi+npC4Rq5QOCqZ7wvg7rF0GaqcCYPwlgN2VlKDI0Q4Fj6RScWA9IG4N7toRKerrOWSGrqyGpfMDC7f2mj+MJjv7Mjp1nVqsw1LYgbbzKFKSNgrqV+qEmibYnMxhag7x+zYDPPbDoVg8uTJFTigMFkHYoGUr7rQD/K99t3ksBOkqi1YmQV97yixM9DAsd0UDSyHF64c6D5zQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(11063799006)(261009223027099003)(22082099003)(18002099003)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(56012099006)(261028144727099003)(261026140227099003)(261022105027099003)(261102123227099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2+mF59bwirfKngB1To6336nQcq+5tVHcNpPX/HfyNH2Zp3Qy05eJZkueVyWoTNO5WAtniR/uUoERQMrot7Bc97ZW/1tMmuXpNtpdrNKXdiZEhbXvviWqXSO0BZ+zHwf0xGLo0FGD8ygEM7gIdbt8MII+rkR8cSj6Z+SN06xmb8t0OO7p7hkPYtypfMjU2hM7TeMThi7K9llR71OMGOrBgzrJ6fU+8e9bCLjFzUteh4e1PXMCNOhJl2jc4LVNWlDaQv3RxX0CdTDHshRb/AWC+y30TIDm1booVMigMEccLBIjOi93NYtWRcXr049QgAMC+MMVyuCjAZJ6Y5nBG1hhWi89dcGWmIPwMIkPCSH7H2O6sO9JUNiAMqvomWKqthN8M1PzJO88gP06EDQBn4abLLjWsO/dLY8l22rmDneshGvJBI0aUQZGgpvKIMWWkXLd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:54.0634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b81469-cb78-423c-f035-08df4d4fc6c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF0000006F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8141

From: Akiva Goldberger <agoldberger@nvidia.com>

bfregn_to_uar_index() and its get_uars_per_sys_page() helper took an
mlx5_ib_dev only to reach dev->mdev. A bfreg is allocated on the owning
ucontext's core device, so take a struct mlx5_core_dev and have the QP and
DEVX callers resolve it from the ucontext via uctx_to_mdev().

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |  5 ++--
 drivers/infiniband/hw/mlx5/main.c    |  5 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +++---
 drivers/infiniband/hw/mlx5/qp.c      | 49 ++++++++++++++++++++----------------
 4 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 7e3ba5d2f5b2300ee82de71a68192360d8819a34..b8161abbe68426dc0ae2421159925f88d57851c6 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1076,20 +1076,19 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_UAR)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
 	u32 user_idx;
 	s32 dev_idx;
 
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
 
 	if (uverbs_copy_from(&user_idx, attrs,
 			     MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX))
 		return -EFAULT;
 
-	dev_idx = bfregn_to_uar_index(dev, &c->bfregi, user_idx, true);
+	dev_idx = bfregn_to_uar_index(uctx_to_mdev(c), &c->bfregi, user_idx,
+				      true);
 	if (dev_idx < 0)
 		return dev_idx;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 89262ccd44f3458d0cfd94323b95e855000bc2f5..c56968ff31f1c5a9fe6e85be81ba9f013a08eea7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1916,7 +1916,7 @@ static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
 	if (req->total_num_bfregs > MLX5_MAX_BFREGS)
 		return -ENOMEM;
 
-	uars_per_sys_page = get_uars_per_sys_page(dev, lib_uar_4k);
+	uars_per_sys_page = get_uars_per_sys_page(dev->mdev, lib_uar_4k);
 	bfregs_per_sys_page = uars_per_sys_page * MLX5_NON_FP_BFREGS_PER_UAR;
 	/* This holds the required static allocation asked by the user */
 	req->total_num_bfregs = ALIGN(req->total_num_bfregs, bfregs_per_sys_page);
@@ -2630,7 +2630,8 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (dyn_uar) {
 		int uars_per_page;
 
-		uars_per_page = get_uars_per_sys_page(dev, bfregi->lib_uar_4k);
+		uars_per_page = get_uars_per_sys_page(dev->mdev,
+						      bfregi->lib_uar_4k);
 		bfreg_dyn_idx = idx * (uars_per_page * MLX5_NON_FP_BFREGS_PER_UAR);
 		if (bfreg_dyn_idx >= bfregi->total_num_bfregs) {
 			mlx5_ib_warn(dev, "invalid bfreg_dyn_idx %u, max=%u\n",
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0ffd2ab5b5ade17c43fb7323381268edb5677b75..462166c34d78ae7d3d93f6362e047ebf886e0ac3 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1663,15 +1663,16 @@ static inline int get_srq_user_index(struct mlx5_ib_ucontext *ucontext,
 	return verify_assign_uidx(cqe_version, ucmd->uidx, user_index);
 }
 
-static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_support)
+static inline int get_uars_per_sys_page(struct mlx5_core_dev *mdev,
+					bool lib_support)
 {
-	return lib_support && MLX5_CAP_GEN(dev->mdev, uar_4k) ?
+	return lib_support && MLX5_CAP_GEN(mdev, uar_4k) ?
 				MLX5_UARS_IN_PAGE : 1;
 }
 
 extern void *xlt_emergency_page;
 
-int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+int bfregn_to_uar_index(struct mlx5_core_dev *mdev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
 			bool dyn_bfreg);
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 87fd27c9279f5df2ee612af1b4451b3eef920f49..9bbd3c506b9f4bb2213b1c2a66d12826e404f12c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -715,40 +715,43 @@ enum {
 	NUM_NON_BLUE_FLAME_BFREGS = 1,
 };
 
-static int max_bfregs(struct mlx5_ib_dev *dev, struct mlx5_bfreg_info *bfregi)
+static int max_bfregs(struct mlx5_core_dev *mdev,
+		      struct mlx5_bfreg_info *bfregi)
 {
-	return get_uars_per_sys_page(dev, bfregi->lib_uar_4k) *
+	return get_uars_per_sys_page(mdev, bfregi->lib_uar_4k) *
 	       bfregi->num_static_sys_pages * MLX5_NON_FP_BFREGS_PER_UAR;
 }
 
-static int num_med_bfreg(struct mlx5_ib_dev *dev,
+static int num_med_bfreg(struct mlx5_core_dev *mdev,
 			 struct mlx5_bfreg_info *bfregi)
 {
-	return max(0, max_bfregs(dev, bfregi) - bfregi->num_low_latency_bfregs -
+	return max(0, max_bfregs(mdev, bfregi) -
+			      bfregi->num_low_latency_bfregs -
 			      NUM_NON_BLUE_FLAME_BFREGS);
 }
 
-static int first_med_bfreg(struct mlx5_ib_dev *dev,
+static int first_med_bfreg(struct mlx5_core_dev *mdev,
 			   struct mlx5_bfreg_info *bfregi)
 {
-	return num_med_bfreg(dev, bfregi) ? 1 : -ENOMEM;
+	return num_med_bfreg(mdev, bfregi) ? 1 : -ENOMEM;
 }
 
-static int first_hi_bfreg(struct mlx5_ib_dev *dev,
+static int first_hi_bfreg(struct mlx5_core_dev *mdev,
 			  struct mlx5_bfreg_info *bfregi)
 {
 	int med;
 
-	med = num_med_bfreg(dev, bfregi);
+	med = num_med_bfreg(mdev, bfregi);
 	return ++med;
 }
 
-static int alloc_high_class_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_high_class_bfreg(struct mlx5_core_dev *mdev,
 				  struct mlx5_bfreg_info *bfregi)
 {
 	int i;
 
-	for (i = first_hi_bfreg(dev, bfregi); i < max_bfregs(dev, bfregi); i++) {
+	for (i = first_hi_bfreg(mdev, bfregi); i < max_bfregs(mdev, bfregi);
+	     i++) {
 		if (!bfregi->count[i]) {
 			bfregi->count[i]++;
 			return i;
@@ -758,16 +761,16 @@ static int alloc_high_class_bfreg(struct mlx5_ib_dev *dev,
 	return -ENOMEM;
 }
 
-static int alloc_med_class_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_med_class_bfreg(struct mlx5_core_dev *mdev,
 				 struct mlx5_bfreg_info *bfregi)
 {
-	int minidx = first_med_bfreg(dev, bfregi);
+	int minidx = first_med_bfreg(mdev, bfregi);
 	int i;
 
 	if (minidx < 0)
 		return minidx;
 
-	for (i = minidx; i < first_hi_bfreg(dev, bfregi); i++) {
+	for (i = minidx; i < first_hi_bfreg(mdev, bfregi); i++) {
 		if (bfregi->count[i] < bfregi->count[minidx])
 			minidx = i;
 		if (!bfregi->count[minidx])
@@ -778,7 +781,7 @@ static int alloc_med_class_bfreg(struct mlx5_ib_dev *dev,
 	return minidx;
 }
 
-static int alloc_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_bfreg(struct mlx5_core_dev *mdev,
 		       struct mlx5_bfreg_info *bfregi)
 {
 	int bfregn = -ENOMEM;
@@ -788,9 +791,9 @@ static int alloc_bfreg(struct mlx5_ib_dev *dev,
 
 	mutex_lock(&bfregi->lock);
 	if (bfregi->ver >= 2) {
-		bfregn = alloc_high_class_bfreg(dev, bfregi);
+		bfregn = alloc_high_class_bfreg(mdev, bfregi);
 		if (bfregn < 0)
-			bfregn = alloc_med_class_bfreg(dev, bfregi);
+			bfregn = alloc_med_class_bfreg(mdev, bfregi);
 	}
 
 	if (bfregn < 0) {
@@ -846,7 +849,7 @@ static void mlx5_ib_lock_cqs(struct mlx5_ib_cq *send_cq,
 static void mlx5_ib_unlock_cqs(struct mlx5_ib_cq *send_cq,
 			       struct mlx5_ib_cq *recv_cq);
 
-int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+int bfregn_to_uar_index(struct mlx5_core_dev *mdev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
 			bool dyn_bfreg)
 {
@@ -857,7 +860,7 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 	if (bfregi->lib_uar_dyn)
 		return -EINVAL;
 
-	bfregs_per_sys_page = get_uars_per_sys_page(dev, bfregi->lib_uar_4k) *
+	bfregs_per_sys_page = get_uars_per_sys_page(mdev, bfregi->lib_uar_4k) *
 				MLX5_NON_FP_BFREGS_PER_UAR;
 	index_of_sys_page = bfregn / bfregs_per_sys_page;
 
@@ -869,7 +872,7 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 
 		if (bfregn > bfregi->num_dyn_bfregs ||
 		    bfregi->sys_pages[index_of_sys_page] == MLX5_IB_INVALID_UAR_INDEX) {
-			mlx5_ib_dbg(dev, "Invalid dynamic uar index\n");
+			dev_dbg(mdev->device, "Invalid dynamic uar index\n");
 			return -EINVAL;
 		}
 	}
@@ -994,7 +997,8 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		bfregn = MLX5_IB_INVALID_BFREG;
 		break;
 	case MLX5_QP_FLAG_BFREG_INDEX:
-		uar_index = bfregn_to_uar_index(dev, &context->bfregi,
+		uar_index = bfregn_to_uar_index(uctx_to_mdev(context),
+						&context->bfregi,
 						ucmd->bfreg_index, true);
 		if (uar_index < 0)
 			return uar_index;
@@ -1003,7 +1007,7 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	case 0:
 		if (qp->flags & IB_QP_CREATE_CROSS_CHANNEL)
 			return -EINVAL;
-		bfregn = alloc_bfreg(dev, &context->bfregi);
+		bfregn = alloc_bfreg(uctx_to_mdev(context), &context->bfregi);
 		if (bfregn < 0)
 			return bfregn;
 		break;
@@ -1013,7 +1017,8 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	mlx5_ib_dbg(dev, "bfregn 0x%x, uar_index 0x%x\n", bfregn, uar_index);
 	if (bfregn != MLX5_IB_INVALID_BFREG)
-		uar_index = bfregn_to_uar_index(dev, &context->bfregi, bfregn,
+		uar_index = bfregn_to_uar_index(uctx_to_mdev(context),
+						&context->bfregi, bfregn,
 						false);
 
 	qp->rq.offset = 0;

-- 
2.49.0


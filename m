Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870923;
	b=dowCsCnzyEofN1CSjH1qFf7zWBoZ2oDJksVlU32Smng/XQs2rcMK+O2fKNM7NaSdUCLC
	 9lBPUNpOj+OTCguB/NJD/LmGmrHBU45dn4xnpcANgfgLLJ0td/XCzM3WuvzbfAhThbVep
	 ryUVlQ3dAEEZG0MD+oLyeaYsLYycwJIOUezT2PpKKckn9A/uHp5bfKJ91LlATpzhZvqjb
	 nsbqOt/HXDxPHSi9fc7IUEp+cjB85aBsi/mwlMAzfxcrx2eSAlCtr94aY3PMS8ZihZ/5J
	 tzMEl3qnUFRn46UOBqi1RmHwflK8KrP4HTNqDqDxYBZdiTl7EzrRzJ3q/dMDZBazYTA==
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
	bh=kedGLHSRtgcVp3RRjTfEEKHnX1ZxNnFYCqRsjKjri5w=;
	b=QEHb3Apk4HjEK3vtCueEmtDgUsNLVqMegb6i3idVPIFJMTIcoo94h/GQegdlbmnjgJih
	 ITOu/bNwb7HiP8hOEewjrxFtABuhN7DiNZqEOIsiOoEty7E32mHpok8NTj/xJ2HTa7UJA
	 TUIhVMWdqyWiElFtjBQOxGvQ29BwjEHBlvXSF/swsvdDxZQgobbIv35px0FbV4PLjI1vS
	 LJj71S5Wpbl+Jhxxriw6QxMsyxxRnozvekY/oObBCy7Xhj8xNfY0eoz6IoiQ5LW9+QEmN
	 L0rDvqjebkZa6YhRCj5uhMYsebQQVObfTJi5tqDWXM74H0NOJgyZprkjfezjIvIA7OQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ds2ZpLKN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.39
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0FD606A689;
	Sat, 28 Nov 2026 13:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB0FD606A689
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ds2ZpLKN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lh0ZEJAtR/eVyYwYP7VcSX+/25JK4QxOKWAAPSJ/wjYpqkO5d4DNDB/xuV3Pu5U/vqcyfYSW9XKe5XvMSBx1x8tcydjJpoPEprQgVVhjy48LnW79P+VqfbQCTDRBQK2WcsLyyf04aXeX9Tw1DGKphdJVO1UkMxSvy3jDOVUmi8sr6Clu6QFOItpeOoeSwFSjFMwWUacZ4F2/Eqis7+Y/6HocrvtSPkHluzmHUrwPRbC/yRkOLSptoe0l9yqznYzHiHm82iLg5WovLYaGSOCvCmxUoerNloFrJ6miW5E4kV3Pih1ZDCZFBQl/fEvIpuIYqVsSAoU0qDnzuv5iPn6AeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kedGLHSRtgcVp3RRjTfEEKHnX1ZxNnFYCqRsjKjri5w=;
 b=a3pGWkwkHkLKaiKmUV95KUT8LSqQ+9KbtKmPRCTgqJY/TIH9muAXDWiSyjDqdyT8x5VEVyhEBQdBAftbNUwTVCFfmQdM75+DECkG1p1N8DeU8tF8mqI5HO+WHprR5wIS1E31el3alxYEKLUw623ipKFRbeCaNIVLmIRcnRCd0z7H/+i/DvaScNnumjPyfaToKbkmFHhFUe6Au9pxF/lsfZobONcpba+CwCwcWPZ/pRbv3sFK8sGvRgsQJktRNstBhawDtziubjrCVQ54vYWhjCwMwaAUkp7blsZm61LnkfaIsCLjzRQfk2F278AtztmlA9dZ6dSLbcQBn+ihHIhYyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kedGLHSRtgcVp3RRjTfEEKHnX1ZxNnFYCqRsjKjri5w=;
 b=Ds2ZpLKNtHKuk+1fthF4Q0P+YqA293AH6jJY0yaD6tI7343v17hB6qS95SruqWv2pqASpPt/blxUBN56br4hHBDG/GezcZhRtd1KQASVT4LHB4w3nNg7yUr6lNW1GXqfahtg4n5YIAiVkylUTtt0x/eP0aKdQgi0POt4T5XbotNwZUzRR/ZTveK8koFx6nKVtrKSynx0Wap/FfqZiI3RpBtlEMHsQm7ycCeFm9+NPvabXP3Kqkeeh/5O/rJkwUqHzcG/zHM0+SfZoRWb/lV45zZmzxOc+q02B1zHjD6LaosX1+X3tKvnzPCdLZE5TZ3ywPMkfyCEQWZ6qKgmvs66sw==
Received: from BN0PR04CA0098.namprd04.prod.outlook.com (2603:10b6:408:ec::13)
 by PH8PR12MB6868.namprd12.prod.outlook.com (2603:10b6:510:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Sat, 28 Nov
 2026 13:01:50 +0000
Received: from BN6PEPF0000006F.namprd03.prod.outlook.com
 (2603:10b6:408:ec:cafe::51) by BN0PR04CA0098.outlook.office365.com
 (2603:10b6:408:ec::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN6PEPF0000006F.mail.protection.outlook.com (10.167.248.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:40 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:38 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:21 +0200
Subject: [PATCH rdma-next v2 08/11] RDMA/mlx5: Resolve core device from
 ucontext for DEVX resources
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
Message-ID: <20261128-mlx5-sd-prep-v2-8-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=27856;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=LumiSZfIdGtPVGdWK39FDuAFMQ4WypuMg8EtJlLSoGM=;
 b=21W4UBGosxgVPtTmASI7HRQCJlzIUMzT+L/etKRn68FIVzeccDtgYUZHkj8+WKGjsCI9CUFlN
 3lEYLXZOJ71B/7mFYfDNPOKGbirKSg3+Al4Q0Xi4P5u3f+i73e9AkGV
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF0000006F:EE_|PH8PR12MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: c3d2e3c8-cf94-49c1-83d9-08df4d4fc4bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|22082099003|18002099003|3023799007|260925022911599003|261022105027099003|260925021311599003|261021123027099003|10067099003|11063799006|5023799004|56012099006|261026121527099003|261028144727099003|261021121427099003|261009223027099003|261022075727099003|261026140227099003|260925021911599003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	7mi473Wty/etvznmZ7/CgprWA9yJTOPsAkj+C7emfbxThbGcoQcMocuHJ3cZ3RovttXDxKdK2EWZeEau/u+16j3QQv6reYb65+TvSTwtH+uAi5YOoZYNr0k5OPOwznjiJbQF8Xj5elPGaslQ2Q1a4ywgrdnxo5jVjGI2uWAxWDAcgq+lbgZLANTqVYy5k0pBJw9WVW+7flb14hbPAil4Z7LU/cfnnA8O1atUVMe0fivmE+Q26OUTGxqZfMVYguoXZ+P2s33c+xTFcZwwCn8RQpGIYyBMNXUvWWy9jmig7QBOxncH723qY/Y9Cstqw9ahtdLEsdG0B8AmValRZSBfMDzfKrORrtE80kwHMWzWp8qn204SebQ/mG11Oam7tJEQMNEPAs+k7scYsFbhc9dgbUzkV9GLwrl9gReY3OWkEOl7BtyWaYvRP8Rg5RGP7lQZKZct7bXEflBLV9gnDsBbY3GVkHUQJsJ5Yq6lBUW3e682gkVF2l7SCgsRKX+nKBBicRpsbr9u9Fxk8VCiY1BUrCVwN9zX1KLX8Ctc4WCBo5WTXouCHSjtDsy2fEl3c0UCfbh/WvuIXbjKCn1gZCH7zP1Nxc8j4LGCbUByWyoHLYHy6c2muxWSwNtiPfXE6cwwB8GlriRi+/IrvhthGSJZLFQarjOH+4rnTo7IEsTWI7V0aa8SeoMKKWTmuoMYDhBN/MQwegnkWxpKR5carRa4XA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(22082099003)(18002099003)(3023799007)(260925022911599003)(261022105027099003)(260925021311599003)(261021123027099003)(10067099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261028144727099003)(261021121427099003)(261009223027099003)(261022075727099003)(261026140227099003)(260925021911599003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KOTX1FY4y06V9+Q2enOCGO5xw1Hki49UkYSRtsTyLtlvut02wCnoYZaP2yAi36epnfjjZkLQfdpafQqfWz5gTFyX8NAxxC4aUkFVuqv1K8PFSdeNeLX6mH2MWQG5mGR36vPo788hlCJYH6nBT0WRK9FjoSUMhs2Tlrw1Iu6mk5CpFHmGZ62y2jAatDYeeTxJ9YBNqfO1smjOJ4pjUtjtOraU3baJNQ7s9Fx1IB9v39p38jq0SiAxC52d9Z+x7zgfrZGvANYbGLXjK4XbLmFQ9AwTHe+qmiJ7a0x5b4dAp9EWC6fjiLi/10wk6HMqW1nQMKxG8Mli8rLdpdoN7Jym+PqGzvH5sk149v6P2ReyFXkToye4L3gyUYy1FjYgg2yftSnsB0KShU/gHn0BEe6YK92o1AZ9rJ3RnpaXkBooQ6xYFbGxDsJe5tLriQUVBrSg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:50.6765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d2e3c8-cf94-49c1-83d9-08df4d4fc4bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF0000006F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6868

From: Akiva Goldberger <agoldberger@nvidia.com>

DEVX objects are all attached to a user context, which is tied to the
specific core device it was opened on. Resolve the core device from the
user context instead of through the IB dev. The DEVX UID of a user
context is created and destroyed on that same core device.

The DEVX umem and packet pacing objects kept their own copy of the core
device for cleanup. Drop it, and like the other DEVX objects resolve the
core device from the user context, which at cleanup is the one the
uobject was created in.

Introduces the uctx_to_mdev helper to easily translate between the user
context and the core device.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c      | 115 +++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/devx.h      |  10 +--
 drivers/infiniband/hw/mlx5/dm.c        |   7 +-
 drivers/infiniband/hw/mlx5/dmah.c      |  10 ++-
 drivers/infiniband/hw/mlx5/main.c      |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h   |   6 +-
 drivers/infiniband/hw/mlx5/qos.c       |  11 ++--
 drivers/infiniband/hw/mlx5/std_types.c |   6 +-
 8 files changed, 96 insertions(+), 76 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d2c8e4ed9e846fa17c77ccfff22c345d36322617..7e3ba5d2f5b2300ee82de71a68192360d8819a34 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -105,7 +105,6 @@ struct devx_async_event_file {
 };
 
 struct devx_umem {
-	struct mlx5_core_dev		*mdev;
 	struct ib_umem			*umem;
 	u32				dinlen;
 	u32				dinbox[MLX5_ST_SZ_DW(destroy_umem_in)];
@@ -123,17 +122,17 @@ devx_ufile2uctx(const struct uverbs_attr_bundle *attrs)
 	return to_mucontext(ib_uverbs_get_ucontext(attrs));
 }
 
-static int set_uctx_ucaps(struct mlx5_ib_dev *dev, u64 req_ucaps, u32 *cap)
+static int set_uctx_ucaps(struct mlx5_core_dev *mdev, u64 req_ucaps, u32 *cap)
 {
 	if (UCAP_ENABLED(req_ucaps, RDMA_UCAP_MLX5_CTRL_LOCAL)) {
-		if (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RDMA_CTRL)
+		if (MLX5_CAP_GEN(mdev, uctx_cap) & MLX5_UCTX_CAP_RDMA_CTRL)
 			*cap |= MLX5_UCTX_CAP_RDMA_CTRL;
 		else
 			return -EOPNOTSUPP;
 	}
 
 	if (UCAP_ENABLED(req_ucaps, RDMA_UCAP_MLX5_CTRL_OTHER_VHCA)) {
-		if (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
+		if (MLX5_CAP_GEN(mdev, uctx_cap) &
 		    MLX5_UCTX_CAP_RDMA_CTRL_OTHER_VHCA)
 			*cap |= MLX5_UCTX_CAP_RDMA_CTRL_OTHER_VHCA;
 		else
@@ -143,7 +142,8 @@ static int set_uctx_ucaps(struct mlx5_ib_dev *dev, u64 req_ucaps, u32 *cap)
 	return 0;
 }
 
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			bool is_user, u64 req_ucaps)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(create_uctx_out)] = {};
@@ -153,22 +153,22 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	u32 cap = 0;
 
 	/* 0 means not supported */
-	if (!MLX5_CAP_GEN(dev->mdev, log_max_uctx))
+	if (!MLX5_CAP_GEN(mdev, log_max_uctx))
 		return -EINVAL;
 
 	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
 	if (is_user &&
-	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX) &&
+	    (MLX5_CAP_GEN(mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX) &&
 	    rdma_dev_has_raw_cap(&dev->ib_dev))
 		cap |= MLX5_UCTX_CAP_RAW_TX;
 	if (is_user &&
-	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
+	    (MLX5_CAP_GEN(mdev, uctx_cap) &
 	     MLX5_UCTX_CAP_INTERNAL_DEV_RES) &&
 	    capable(CAP_SYS_RAWIO))
 		cap |= MLX5_UCTX_CAP_INTERNAL_DEV_RES;
 
 	if (req_ucaps) {
-		err = set_uctx_ucaps(dev, req_ucaps, &cap);
+		err = set_uctx_ucaps(mdev, req_ucaps, &cap);
 		if (err)
 			return err;
 	}
@@ -176,7 +176,7 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	MLX5_SET(create_uctx_in, in, opcode, MLX5_CMD_OP_CREATE_UCTX);
 	MLX5_SET(uctx, uctx, cap, cap);
 
-	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (err)
 		return err;
 
@@ -184,7 +184,7 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	return uid;
 }
 
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
+void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_uctx_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(destroy_uctx_out)] = {};
@@ -192,7 +192,7 @@ void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
 	MLX5_SET(destroy_uctx_in, in, opcode, MLX5_CMD_OP_DESTROY_UCTX);
 	MLX5_SET(destroy_uctx_in, in, uid, uid);
 
-	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
 static bool is_legacy_unaffiliated_event_num(u16 event_num)
@@ -631,10 +631,8 @@ static u64 devx_get_obj_id(const void *in)
 	return obj_id;
 }
 
-static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
-				 struct ib_uobject *uobj, const void *in)
+static bool devx_is_valid_obj_id(struct ib_uobject *uobj, const void *in)
 {
-	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	u64 obj_id = devx_get_obj_id(in);
 
 	if (!obj_id)
@@ -659,7 +657,7 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 			opcode = MLX5_CMD_OP_CREATE_XRQ;
 			break;
 		default:
-			if (!dev->mdev->issi)
+			if (!srq_to_mdev(srq)->issi)
 				opcode = MLX5_CMD_OP_CREATE_SRQ;
 			else
 				opcode = MLX5_CMD_OP_CREATE_RMP;
@@ -992,12 +990,12 @@ static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
 	return c->devx_uid;
 }
 
-static bool devx_is_general_cmd(void *in, struct mlx5_ib_dev *dev)
+static bool devx_is_general_cmd(void *in, struct mlx5_core_dev *mdev)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 
 	/* Pass all cmds for vhca_tunnel as general, tracking is done in FW */
-	if ((MLX5_CAP_GEN_64(dev->mdev, vhca_tunnel_commands) &&
+	if ((MLX5_CAP_GEN_64(mdev, vhca_tunnel_commands) &&
 	     MLX5_GET(general_obj_in_cmd_hdr, in, vhca_tunnel_id)) ||
 	    (opcode >= MLX5_CMD_OP_GENERAL_START &&
 	     opcode < MLX5_CMD_OP_GENERAL_END))
@@ -1031,7 +1029,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
 	int user_vector;
 	int dev_eqn;
 	int err;
@@ -1043,9 +1040,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
 
-	err = mlx5_comp_eqn_get(dev->mdev, user_vector, &dev_eqn);
+	err = mlx5_comp_eqn_get(uctx_to_mdev(c), user_vector, &dev_eqn);
 	if (err < 0)
 		return err;
 
@@ -1108,7 +1104,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
+	struct mlx5_core_dev *mdev;
 	void *cmd_in = uverbs_attr_get_alloced_ptr(
 		attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN);
 	int cmd_out_len = uverbs_attr_get_len(attrs,
@@ -1120,14 +1116,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
 
 	/* Only white list of some general HCA commands are allowed for this method. */
-	if (!devx_is_general_cmd(cmd_in, dev))
+	if (!devx_is_general_cmd(cmd_in, mdev))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1135,7 +1131,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1448,6 +1444,8 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 			    enum rdma_remove_reason why,
 			    struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct mlx5_devx_event_table *devx_event_table;
 	struct devx_obj *obj = uobject->object;
@@ -1469,12 +1467,12 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	if (obj->flags & DEVX_OBJ_FLAGS_HW_FREED)
 		ret = 0;
 	else if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		ret = mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
+		ret = mlx5_core_destroy_dct(obj->ib_dev, mdev,
 					    &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		ret = mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
+		ret = mlx5_core_destroy_cq(mdev, &obj->core_cq);
 	else
-		ret = mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox,
+		ret = mlx5_cmd_exec(mdev, obj->dinbox,
 				    obj->dinlen, out, sizeof(out));
 	if (ret)
 		return ret;
@@ -1513,9 +1511,9 @@ static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
 	rcu_read_unlock();
 }
 
-static bool is_apu_cq(struct mlx5_ib_dev *dev, const void *in)
+static bool is_apu_cq(struct mlx5_core_dev *mdev, const void *in)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, apu) ||
+	if (!MLX5_CAP_GEN(mdev, apu) ||
 	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), apu_cq))
 		return false;
 
@@ -1536,6 +1534,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct devx_obj *obj;
 	u16 obj_type = 0;
@@ -1573,18 +1572,18 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
 		obj->flags |= DEVX_OBJ_FLAGS_DCT;
-		err = mlx5_core_create_dct(dev, dev->mdev, &obj->core_dct,
+		err = mlx5_core_create_dct(dev, mdev, &obj->core_dct,
 					   cmd_in, cmd_in_len, cmd_out,
 					   cmd_out_len);
 	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
-		   !is_apu_cq(dev, cmd_in)) {
+		   !is_apu_cq(mdev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
-		err = mlx5_create_cq(dev->mdev, &obj->core_cq,
+		err = mlx5_create_cq(mdev, &obj->core_cq,
 				     cmd_in, cmd_in_len, cmd_out,
 				     cmd_out_len);
 	} else {
-		err = mlx5_cmd_do(dev->mdev, cmd_in, cmd_in_len,
+		err = mlx5_cmd_do(mdev, cmd_in, cmd_in_len,
 				  cmd_out, cmd_out_len);
 	}
 
@@ -1633,12 +1632,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
-				      &obj->core_dct);
+		mlx5_core_destroy_dct(obj->ib_dev, mdev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
+		mlx5_core_destroy_cq(mdev, &obj->core_cq);
 	else
-		mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox, obj->dinlen, out,
+		mlx5_cmd_exec(mdev, obj->dinbox, obj->dinlen, out,
 			      sizeof(out));
 obj_free:
 	kfree(obj);
@@ -1655,7 +1653,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	void *cmd_out;
 	int err, err2;
 	int uid;
@@ -1670,7 +1668,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	if (!devx_is_obj_modify_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1680,7 +1678,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1705,7 +1703,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	void *cmd_out;
 	int err, err2;
 	int uid;
-	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 
 	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
 		return -EINVAL;
@@ -1717,7 +1715,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	if (!devx_is_obj_query_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1725,7 +1723,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1767,12 +1765,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC)(
 
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DEVX_ASYNC_CMD_FD_ALLOC_HANDLE);
-	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
+	struct mlx5_ib_ucontext *c =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
 
 	ev_file = container_of(uobj, struct devx_async_cmd_event_file,
 			       uobj);
 	devx_init_event_queue(&ev_file->ev_queue);
-	mlx5_cmd_init_async_ctx(dev->mdev, &ev_file->async_ctx);
+	mlx5_cmd_init_async_ctx(uctx_to_mdev(c), &ev_file->async_ctx);
 	return 0;
 }
 
@@ -1863,7 +1863,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	if (err)
 		return err;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	fd_uobj = uverbs_attr_get_uobject(attrs,
@@ -2148,7 +2148,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 	event_type_num_list = uverbs_attr_get_alloced_ptr(attrs,
 			MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST);
 
-	if (!is_valid_events(dev->mdev, num_events, event_type_num_list, obj))
+	if (!is_valid_events(uctx_to_mdev(c), num_events, event_type_num_list,
+			     obj))
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&sub_list);
@@ -2333,7 +2334,7 @@ static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
 	return page_size;
 }
 
-static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
+static int devx_umem_reg_cmd_alloc(struct mlx5_core_dev *mdev,
 				   struct uverbs_attr_bundle *attrs,
 				   struct devx_umem *obj,
 				   struct devx_umem_reg_cmd *cmd,
@@ -2391,7 +2392,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	MLX5_SET(umem, umem, page_offset,
 		 ib_umem_dma_offset(obj->umem, page_size));
 
-	if (mlx5_umem_needs_ats(dev->mdev, obj->umem, access))
+	if (mlx5_umem_needs_ats(mdev, obj->umem, access))
 		MLX5_SET(umem, umem, ats, 1);
 
 	mlx5_ib_populate_pas(obj->umem, page_size, mtt,
@@ -2411,6 +2412,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	int access_flags;
 	int err;
 
@@ -2434,17 +2436,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	if (err)
 		goto err_obj_free;
 
-	err = devx_umem_reg_cmd_alloc(dev, attrs, obj, &cmd, access_flags);
+	err = devx_umem_reg_cmd_alloc(mdev, attrs, obj, &cmd, access_flags);
 	if (err)
 		goto err_umem_release;
 
 	MLX5_SET(create_umem_in, cmd.in, uid, c->devx_uid);
-	err = mlx5_cmd_exec(dev->mdev, cmd.in, cmd.inlen, cmd.out,
+	err = mlx5_cmd_exec(mdev, cmd.in, cmd.inlen, cmd.out,
 			    sizeof(cmd.out));
 	if (err)
 		goto err_umem_release;
 
-	obj->mdev = dev->mdev;
 	uobj->object = obj;
 	devx_obj_build_destroy_cmd(cmd.in, cmd.out, obj->dinbox, &obj->dinlen, &obj_id);
 	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_DEVX_UMEM_REG_HANDLE);
@@ -2464,11 +2465,13 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 			     enum rdma_remove_reason why,
 			     struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	struct devx_umem *obj = uobject->object;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	int err;
 
-	err = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
+	err = mlx5_cmd_exec(mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
 	if (err)
 		return err;
 
@@ -2654,7 +2657,7 @@ int mlx5_ib_devx_init(struct mlx5_ib_dev *dev)
 	struct mlx5_devx_event_table *table = &dev->devx_event_table;
 	int uid;
 
-	uid = mlx5_ib_devx_create(dev, false, 0);
+	uid = mlx5_ib_devx_create(dev, dev->mdev, false, 0);
 	if (uid > 0) {
 		dev->devx_whitelist_uid = uid;
 		xa_init(&table->event_xa);
@@ -2687,7 +2690,7 @@ void mlx5_ib_devx_cleanup(struct mlx5_ib_dev *dev)
 		mutex_unlock(&dev->devx_event_table.event_xa_lock);
 		xa_destroy(&table->event_xa);
 
-		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
+		mlx5_ib_devx_destroy(dev->mdev, dev->devx_whitelist_uid);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/devx.h b/drivers/infiniband/hw/mlx5/devx.h
index ee9e7d3af93ffcec1b7b6142e2e755075acbba1e..0fb2dcf6bafd1bfdd972051296acff4e0f944383 100644
--- a/drivers/infiniband/hw/mlx5/devx.h
+++ b/drivers/infiniband/hw/mlx5/devx.h
@@ -24,18 +24,20 @@ struct devx_obj {
 	struct list_head event_sub; /* holds devx_event_subscription entries */
 };
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps);
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid);
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			bool is_user, u64 req_ucaps);
+void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid);
 int mlx5_ib_devx_init(struct mlx5_ib_dev *dev);
 void mlx5_ib_devx_cleanup(struct mlx5_ib_dev *dev);
 void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile);
 #else
-static inline int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user,
+static inline int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
+				      struct mlx5_core_dev *mdev, bool is_user,
 				      u64 req_ucaps)
 {
 	return -EOPNOTSUPP;
 }
-static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid) {}
+static inline void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid) {}
 static inline int mlx5_ib_devx_init(struct mlx5_ib_dev *dev)
 {
 	return 0;
diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 67df5944abece4601dc48db4e2672c6de1b3867d..643aa7529f0d69af4064942e59ed16b5a68a01f9 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -209,6 +209,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
+	struct mlx5_ib_ucontext *c = to_mucontext(uobj->context);
 	struct mlx5_ib_dev *dev = to_dev(uobj->context->device);
 	struct ib_dm *ibdm = uobj->object;
 	struct mlx5_ib_dm *mdm = to_mdm(ibdm);
@@ -227,7 +228,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 	if (op >= BITS_PER_TYPE(u32))
 		return -EOPNOTSUPP;
 
-	if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
+	if (!(MLX5_CAP_DEV_MEM(uctx_to_mdev(c), memic_operations) & BIT(op)))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&dm->ops_xa_lock);
@@ -363,7 +364,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 					    struct uverbs_attr_bundle *attrs,
 					    int type)
 {
-	struct mlx5_core_dev *mdev = to_dev(ctx->device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(to_mucontext(ctx));
 	enum mlx5_sw_icm_type icm_type;
 	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
@@ -480,7 +481,7 @@ static int mlx5_dm_icm_dealloc(struct mlx5_ib_ucontext *ctx,
 			       struct mlx5_ib_dm_icm *dm)
 {
 	enum mlx5_sw_icm_type type = get_icm_type(dm->base.type);
-	struct mlx5_core_dev *mdev = to_dev(dm->base.ibdm.device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(ctx);
 	int err;
 
 	err = mlx5_dm_sw_icm_dealloc(mdev, type, dm->base.size, ctx->devx_uid,
diff --git a/drivers/infiniband/hw/mlx5/dmah.c b/drivers/infiniband/hw/mlx5/dmah.c
index 84641e06d63c1ebc20ac57dbc11c36a46554b638..a9419324f03d5606e51b08ea372ce0fbe4b436fc 100644
--- a/drivers/infiniband/hw/mlx5/dmah.c
+++ b/drivers/infiniband/hw/mlx5/dmah.c
@@ -13,7 +13,10 @@
 static int mlx5_ib_alloc_dmah(struct ib_dmah *ibdmah,
 			      struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
+	struct mlx5_ib_ucontext *uctx =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(uctx);
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
 	u16 st_bits = BIT(IB_DMAH_CPU_ID_EXISTS) |
 		      BIT(IB_DMAH_MEM_TYPE_EXISTS);
@@ -39,8 +42,11 @@ static int mlx5_ib_alloc_dmah(struct ib_dmah *ibdmah,
 static int mlx5_ib_dealloc_dmah(struct ib_dmah *ibdmah,
 				struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_ib_ucontext *uctx =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
-	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(uctx);
 
 	if (ibdmah->valid_fields & BIT(IB_DMAH_CPU_ID_EXISTS))
 		return mlx5_st_dealloc_index(mdev, dmah->st_index);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 90d19c49bc00bc3d53b5f30d2f87ef062dcd6406..89262ccd44f3458d0cfd94323b95e855000bc2f5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2238,7 +2238,8 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		return -EINVAL;
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
-		err = mlx5_ib_devx_create(dev, true, uctx->enabled_caps);
+		err = mlx5_ib_devx_create(dev, uctx_to_mdev(context), true,
+					  uctx->enabled_caps);
 		if (err < 0)
 			goto out_ctx;
 		context->devx_uid = err;
@@ -2340,7 +2341,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 
 out_devx:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
-		mlx5_ib_devx_destroy(dev, context->devx_uid);
+		mlx5_ib_devx_destroy(uctx_to_mdev(context), context->devx_uid);
 
 out_ctx:
 	return err;
@@ -2386,7 +2387,7 @@ static void mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 		if (uctx_rdma_ctrl_is_enabled(ibcontext->enabled_caps))
 			mlx5_cmd_remove_privileged_uid(dev->mdev,
 						       context->devx_uid);
-		mlx5_ib_devx_destroy(dev, context->devx_uid);
+		mlx5_ib_devx_destroy(uctx_to_mdev(context), context->devx_uid);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a4948e3556597af569c91b1dfc828e0dcb8d05a6..76882a692994e2473a46893876244436d6f69a63 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -276,7 +276,6 @@ struct mlx5_ib_steering_anchor {
 
 struct mlx5_ib_pp {
 	u16 index;
-	struct mlx5_core_dev *mdev;
 };
 
 enum mlx5_ib_optional_counter_type {
@@ -1316,6 +1315,11 @@ static inline struct mlx5_core_dev *mw_to_mdev(struct ib_mw *ibmw)
 	return pd_to_mdev(ibmw->pd);
 }
 
+static inline struct mlx5_core_dev *uctx_to_mdev(struct mlx5_ib_ucontext *uctx)
+{
+	return to_dev(uctx->ibucontext.device)->mdev;
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
diff --git a/drivers/infiniband/hw/mlx5/qos.c b/drivers/infiniband/hw/mlx5/qos.c
index fea229c29611d46dae2ecaa39f786f9063063233..420dfdc6f1fd3fd257f3c7ee6d7ef6d5ab3d3ed2 100644
--- a/drivers/infiniband/hw/mlx5/qos.c
+++ b/drivers/infiniband/hw/mlx5/qos.c
@@ -27,7 +27,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 		MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE);
-	struct mlx5_ib_dev *dev;
+	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_ucontext *c;
 	struct mlx5_ib_pp *pp_entry;
 	void *in_ctx;
@@ -44,7 +44,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	if (!c->devx_uid)
 		return -EINVAL;
 
-	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 	pp_entry = kzalloc_obj(*pp_entry);
 	if (!pp_entry)
 		return -ENOMEM;
@@ -63,13 +63,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	uid = (flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX) ?
 		c->devx_uid : MLX5_SHARED_RESOURCE_UID;
 
-	err = mlx5_rl_add_rate_raw(dev->mdev, rl_raw, uid,
+	err = mlx5_rl_add_rate_raw(mdev, rl_raw, uid,
 			(flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX),
 			&pp_entry->index);
 	if (err)
 		goto err;
 
-	pp_entry->mdev = dev->mdev;
 	uobj->object = pp_entry;
 	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE);
 
@@ -86,9 +85,11 @@ static int pp_obj_cleanup(struct ib_uobject *uobject,
 			  enum rdma_remove_reason why,
 			  struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	struct mlx5_ib_pp *pp_entry = uobject->object;
 
-	mlx5_rl_remove_rate_raw(pp_entry->mdev, pp_entry->index);
+	mlx5_rl_remove_rate_raw(mdev, pp_entry->index);
 	kfree(pp_entry);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index 3f15feca98b529fda3d2619a4c260b2398d895ee..40048a64f2a08dea48622562d473b1cbe9631b05 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -155,6 +155,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_QUERY_PORT)(
 {
 	struct mlx5_ib_uapi_query_port info = {};
 	struct mlx5_ib_ucontext *c;
+	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_dev *dev;
 	u32 port_num;
 	int ret;
@@ -167,15 +168,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_QUERY_PORT)(
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 
 	if (!rdma_is_port_valid(&dev->ib_dev, port_num))
 		return -EINVAL;
 
-	if (mlx5_eswitch_mode(dev->mdev) == MLX5_ESWITCH_OFFLOADS) {
+	if (mlx5_eswitch_mode(mdev) == MLX5_ESWITCH_OFFLOADS) {
 		ret = fill_switchdev_info(dev, port_num, &info);
 		if (ret)
 			return ret;
-	} else if (mlx5_core_mp_enabled(dev->mdev)) {
+	} else if (mlx5_core_mp_enabled(mdev)) {
 		ret = fill_multiport_info(dev, port_num, &info);
 		if (ret)
 			return ret;

-- 
2.49.0


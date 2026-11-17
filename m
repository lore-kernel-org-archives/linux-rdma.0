Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935617;
	b=1vQokaQ+s2FZyC34wdoeiiRMrae6Rxk30bYP0eO3sOQVHxkCDSNF93GV/bGYjeMGE/jR
	 xRQGM42YVca4V1fCWf+Yql++aWkcQFouiHC6ZydO67m0et3nPnuBzdq4AnYocXF2p2rVJ
	 u2iYklsXipm62y1MqCxlhQYlmdx1NOzUOKWEH9eHCnj1gNoE5S+I74cgttp8smEADxbqt
	 qxGW07F3oFMXVYNLy7ZlfQwPMnpZlHmtRKsBA5zNi1YIrgXv2/bvJ4i1f928xqr8lp6M2
	 16SUWCCyEQ80qdysHg2U+Ue1GYdcJtrvXqi2FVT4qYgKpBLCFVEg0At/h+BMROY29YA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935617;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=zLoEYKfjOZOPtqfv2yXSyfHCccz35/eboXPpP+Au6F0=;
	b=CL91tfyidRAnH3A+WGgRyChHZqLOImRdNoKiHXV3YafXgUpBgERAZzfSt9syK34YVuBG
	 Pe4JpRfinmKacw7KxzpK0UAMVmo6bkxdi7GccTUlJRhOgBtKtkqugFlzB3PgpVtwepETt
	 Ufa4664l8XzxmopS53NleKFqkdMISyJOKNIx+gUcxYwNdpvT6UwYaxNsVa3sEOBBQrZ9p
	 X6rw8FTCNp+Jwftq7qWTAqi5vTxOL9eiGjbkY+EHPo372m3FVsV0QzozHqi6VbczE3Or/
	 2Vsk0L0xdKtWKWHY6EIfVo4qXvWEKBmSVr0BuG/yT2Upz4gz4x2WfBscYwhvxsn/MPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SFLQ1ppo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.45
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB98606A330;
	Tue, 17 Nov 2026 17:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EB98606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SFLQ1ppo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BIxWoNqhwLNTq8PWSbDkG/+J+J/350hrQ464yTZgafBon8b9lnLyMn2+WZJAMIcLFeFg+6b62iH/qtScpf/XaiNvyuFixr/N4w1UrcNUzWz3z4RCFkORZaBGjFVuDSYLPwuzbfQddfQMOAy1LDkbgnu57U7pZQOHBsvOuLL5jNYuYL3gVo9E5sp/9QVSp7+lB2dZMhJUrERdYij6FpXDsH1ywizsXzQ/Ev2K6uPQ2IGuFg9ACmSveMb4qgkK5zwoKJgS5vIuTv1bITk5otEJ/RsqV+Ln5GVgsbsJGnLoSm218zmdA1BkFhwm2dqycpx5Qp+4wocNs7DB1FpSRR/noQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLoEYKfjOZOPtqfv2yXSyfHCccz35/eboXPpP+Au6F0=;
 b=v7VS/Rx6zQkbLx0ZW5YJAkyA+JvMjqeWQT2cUAaxjNCUCxwGZYXSe9ITbdu6eWXekBncPfzQ81eO7IiObLjAjM/MS54yVZ1i/K0UiluxkXuSs3f//kRUrJLhmQ0bUKnf9m1DQYGGAJdumzEwcHDmhwHnC55MCqMdBigiTzL60BPDv5mCEHMqP7aU3HZMz18yAfVAjJSwVgA+nHcYRwYeDK4iZNuSr4abRdN6hFiN69t31DFMW9PVsSNYKU558oLDf9SMrojvhUeHVnd9NAoLohzqlKx9vWpqWoIEXFK0oD9x7PKAEcoZl4jCUsvIlsYl3WWmH7w9AyqVVY+NuG2rog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLoEYKfjOZOPtqfv2yXSyfHCccz35/eboXPpP+Au6F0=;
 b=SFLQ1ppo9yieBs30K5l6R0UHpOCXOjJ4uQ1EDbENJagPzrfVoID3iabrXLJ3nrUPYckfZQwnpkmyXMwwwHJJbxpWHUVjGF4RNCTQGiBaSIJ3uWbkC6T6wgKEo3v1JyOhsaB/v1wu2M9tSV+DcBaXkmU0YOfj0zpyBg+6cbPcoR6sRRsmlr4+lJLo6tm+umyDxm8PWrATPCFnoUQ2uQKdOMLo0rRf0MuPphfhcCh4optcfFztJmv6/M+h+10oyT6WgZFf+H52rj/1Pf4IimIt9frwOF/xv1OugJnTEN5GjzOynbX1VAqKZCLtwXt0DiJUuy+zcBwsERrL114nwIBUVg==
Received: from SJ0PR03CA0155.namprd03.prod.outlook.com (2603:10b6:a03:338::10)
 by CY1PR12MB9675.namprd12.prod.outlook.com (2603:10b6:930:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:31 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::58) by SJ0PR03CA0155.outlook.office365.com
 (2603:10b6:a03:338::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 17:11:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:11:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:11:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:11:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 18/21] RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
Date: Tue, 17 Nov 2026 19:09:11 +0200
Message-ID: <20261117170914.27410-19-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|CY1PR12MB9675:EE_
X-MS-Office365-Filtering-Correlation-Id: c37f9ff5-581c-4396-c6eb-08df44cdd36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|261009223027099003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	0BDup/O/Cp/7TM+oHhxqwWcpWSlRaGQTHCnsUVnNd5B5KbO6zlrju/rxy6zZCT2n3DEdcc9uzmfdgdSc/xMsA2DtPvJaQlGBVP+Mu6MUZAWx3GeV4p3C4IiwMgE9Xh2iFblxSTZGozW4uIoytPHWSiWlbiONie5bRoMPM6lOv2ijK3XKcl3zoN9MUjykJaEf6NzagOprdibCBtV4tSR6GXng/ox+7ehpX0Saxmr00gm+cKQz+omoblSiW5nqLeGWNur+PwkHfMzrYpLkB3+Phv4ysAUwYc1pfMMXWclNWsjGiKwDHTNYRrYzgvNVpQDTTd6djxYxAc/cz0AOkbnA/uTei16QUATN/Pfta2La6ibwQL2ht9lmPta4MJcFbKAkCqB+NAJMJ5rwTosU4/ZJTIsBhFy83Z7x1clDtZwQdNGkvTsIJNVLfnsOBYr4DJhlAg9svG9MZOfLqVSYeFevlg+QNELXaO6yg58JMbIPyYOMczmRbSnKpc9WpK+431quFOe3EiOPY+r4GKVE7zt+ugVuT4eu3842o3rndAD0pUGJ4nBe0DmINOL8U3sRLTJgCIQJTUMsYBeKP2MwlF36cK+eA/NphIVLCi0tXjvzgyEY6v1Gw/3kDA6zAr0RPy4tYcaGgFR+hrdtUUrv1Db58PVD1gL+ioGrmqZ72wRpsOeEjmjgKwOi8kpzIpZ7DmaXWVS37cz9g+l4aRlYRC50tQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261009223027099003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4MrjMorjNpiRAjbBLSn/8b7DMxbc+hlOm+7hvbUmeC+xAgxy6p1Slp1QvqOHuYlvXQT7VBcnuh1c2hTZkCNrWhbQa+edQjdZhq4MFG+3KPYT8HXdDVEVaqew1WRyejEWkeh0z7BRaqi6ILGuwD4pyJl27kXxiA4LHFiOFG0yT6kbbaiNOtXTiW+sEXwZ2iUPBN//m21LTnZxxKCSD2VEXq7OhQa490DdB7WwG9uIo+sT7RVZjZxiT1gA6f+TcIOatUw7qN1oDKCxuxf4htCS/J6yVBi/z7IV1jZOQzj/+ib+WUOE6ANc6o4fs9jLSZuwCyw8f9qzHywKH8MEPH+5FcHBzcInTMKZ5nwBp7KK3G12HzebuYr8wEGOnbKROLYqq8sqfetgPY+uBP0KXQTA1koUNcbiiZvrh8lDe/15IyJ0p6/lmJtY5f8WDQxz5+s0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:31.5770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c37f9ff5-581c-4396-c6eb-08df44cdd36b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9675

The CQ create and resize paths check the requested size against
1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
report 31 or more, which makes the shift undefined. A large limit also
lets the rounded up CQ size exceed INT_MAX, and it is then truncated
when passed on as an int.

Such a size also overflows the CQ buffer size, entries * cqe_size,
which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
user CQ buffer smaller than the CQ the NIC is given then passes the
umem size check, and a kernel CQ gets a zero-sized buffer that
init_cq_frag_buf() writes to.

Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
reject sizes above INT_MAX. Compute the buffer size with
check_mul_overflow(), as resize_user() already does.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 52 ++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 831bdf238319..7180357f9dd7 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -897,10 +897,14 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
 	struct mlx5_frag_buf *frag_buf = &buf->frag_buf;
 	u8 log_wq_stride = 6 + (cqe_size == 128 ? 1 : 0);
 	u8 log_wq_sz     = ilog2(cqe_size);
+	int size;
 	int err;
 
+	if (check_mul_overflow(nent, cqe_size, &size))
+		return -EINVAL;
+
 	err = mlx5_frag_buf_alloc_node(dev->mdev,
-				       nent * cqe_size,
+				       size,
 				       frag_buf,
 				       dev->mdev->priv.numa_node);
 	if (err)
@@ -943,6 +947,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 {
 	struct mlx5_ib_create_cq ucmd;
 	unsigned long page_size;
+	size_t buf_size;
 	unsigned int page_offset_quantized;
 	__be64 *pas;
 	int ncont;
@@ -966,9 +971,13 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	*cqe_size = ucmd.cqe_size;
 
+	if (check_mul_overflow((size_t)entries, (size_t)ucmd.cqe_size,
+			       &buf_size))
+		return -EINVAL;
+
 	cq->buf.umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, attrs,
 						ucmd.buf_addr,
-						entries * ucmd.cqe_size,
+						buf_size,
 						IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(cq->buf.umem))
 		return PTR_ERR(cq->buf.umem);
@@ -1167,6 +1176,15 @@ static void notify_soft_wc_handler(struct work_struct *work)
 	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 }
 
+/*
+ * Next power of 2 above entries. It can be 2^32, which doesn't fit the
+ * unsigned long of roundup_pow_of_two() on 32-bit archs.
+ */
+static u64 cq_roundup_entries(u64 entries)
+{
+	return 1ULL << fls64(entries);
+}
+
 int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 			   const struct ib_cq_init_attr *attr,
 			   struct uverbs_attr_bundle *attrs)
@@ -1174,7 +1192,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	struct ib_udata *udata = &attrs->driver_udata;
 	struct ib_device *ibdev = ibcq->device;
 	struct mlx5_ib_create_cq_resp uresp = {};
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1186,15 +1204,17 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	int cqe_size;
 	int eqn;
 	int err;
+	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
 
-	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (attr->cqe > max_cq_entries)
 		return -EINVAL;
 
 	if (check_cq_create_flags(attr->flags))
 		return -EOPNOTSUPP;
 
-	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	entries = cq_roundup_entries(entries);
+	/* cq->ibcq.cqe and create_cq_user() take an int */
+	if (entries > max_cq_entries || entries > INT_MAX)
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
@@ -1262,7 +1282,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct uverbs_attr_bundle *attrs)
 {
 	struct ib_device *ibdev = ibcq->device;
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1274,12 +1294,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	int cqe_size;
 	int eqn;
 	int err;
+	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
 
-	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (attr->cqe > max_cq_entries)
 		return -EINVAL;
 
-	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	entries = cq_roundup_entries(entries);
+	/* cq->ibcq.cqe and create_cq_kernel() take an int */
+	if (entries > max_cq_entries || entries > INT_MAX)
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
@@ -1577,18 +1599,22 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	int inlen;
 	int cqe_size;
 	unsigned long flags;
+	u64 entries64 = entries;
+	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
 
 	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
 		pr_info("Firmware does not support resize CQ\n");
 		return -ENOSYS;
 	}
 
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (entries64 > max_cq_entries)
 		return -EINVAL;
 
-	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)) + 1)
+	entries64 = cq_roundup_entries(entries64);
+	/* resize_user() and resize_kernel() take an int */
+	if (entries64 > max_cq_entries + 1 || entries64 > INT_MAX)
 		return -EINVAL;
+	entries = entries64;
 
 	if (entries == ibcq->cqe + 1)
 		return 0;
-- 
2.18.1


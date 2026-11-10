Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318344;
	b=deW/NwYOq5V/IKrHIJ3//xXLKRMVF1By80GFaO/CLlPaurOmn74VNgTOS7SrYhK061q8
	 QyKuzWMEm+IN/+kdn44II9RF54wGbzvQxuuh284q9It37vY3+hRMBlkwOIziQLQj/eZeh
	 zsHCsGPVWwYo+olF/YfDgnvEZm2CokUdKAIphn4WKeRJQ7ohW3R1osy/Mhq1vRyVeLz0w
	 C6QK/dvQ++FbBo/TlL6FTz5g67hyiCSkVVLj6ng0NuivgxOlkcawlWIjQT/x5guaM2srk
	 kOl7XuWCTHpc7ZPE5u7SFNfuJn1LVkYhZke0jPDbqTxpwN0tmH88RDthtov7dMFhhaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318344;
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
	bh=UcWIyot2XYcxWirDz0honGSdLN+omMzkVGmY6UrXQIQ=;
	b=WSbsMETbJXI7i6WyJDvYC6Z4ksPIAtF+Nbo3VDMo5zvk5wEb4fkphay2zRMRLnSTJ7cB
	 igPqzlnlSiJCcj9NsSTMzm9bKodnE8Ko9Z2DcRacF6xnoNOKiAdXcMa0xIcskkckODixK
	 Ci2YVks6cVWWUfp0EXlU01Tr0n+vYKAnevp4Ta5/3hDA34RFIvKMdqeO3uvufWJEGZk0a
	 X8zY+eV9A5gZHBpz6xp//o04ONyP8exVAfZ4rv8sHwVtmnOkt5uHIX8Ay52y0YAGSk6W/
	 EWcOzN9FRzga1MUB/bfl+pFAQ9S3QixW70/ezuO4ps+yguc22RO+mZMi4/DpnF+mk3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z5X2W+0V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE56606A33F;
	Tue, 10 Nov 2026 13:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACE56606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z5X2W+0V
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udf9aXSfoyZGppoS1NAChhoyttv2x9L8Gixo+jWvbcRHfZ+pOxjd598+/7E+jj440M3rf91jmaOqa92e81B8sz7bEC63c3ycznQo82Hqj5P1vmIWGj+WbM3nUATcxWvHmi6GfJFo1rNeHiqcYTp4SvXuQr4vgk8l6546G2yAvXRSHyQj3RRADLk7DVcif4SNvODNkCdlpszvzFSDO8knVACsqFBHOMdX3g4V6JYzVWN+pDQmRZDYatNysw5eQtVOSlp/5QRCI7q36ByifhYF5ww9uMCWCx0MCtLTsnguQBk2L60ns4ffxIeGEGJTaZLT2VRjJvOir53RUV0FyBEjpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcWIyot2XYcxWirDz0honGSdLN+omMzkVGmY6UrXQIQ=;
 b=koxtUY9tsYDgxY2Dz+7sc4GM7k1s8Kh1Ts7Rr+7sLZW1uUINgGFhyFl1i5MdvLt4a0w0AJPdj4Z5XCbnwH05yt5s/gVRcg9v1cOVOlDjxrwEg58HnfMMLL2toaFEeZLbqeVnMo7uYurn6Flf7iogAw0PKplz4SmfpuMzpuLAy4rZtQT1hB7EMdRzJv6QUg+yKmF1qXStNKzF7M0K0sgVRhRbk/7c0wKTOCqBf/2/c92IvhpFP6uzxuJ8o3RO7zMmlnnB506GdFI5vKZuQyEcgVRRjPMQqsIOE/pLe2nOZvyBIH324cvTzUi45enGpIPYVD0329x8z5LipC6pLKdDHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcWIyot2XYcxWirDz0honGSdLN+omMzkVGmY6UrXQIQ=;
 b=Z5X2W+0VKpORYy1lqMRGyY5SO7kRwpArR4m/OWK/rp4BquhEHyMXACbszzikpuYiqs/zQ/LE77pp8g3WN8C1iLZFuKTfg9AN4pFL7uWmP60136TyoBAze+cLftUuVCIWGmZ2dllK3um2bTXA+h096uZ8IxJ5Q43YRXR512/Ub4mFk+CCCFlgWIq0k4P1Nmcm7T2ltGMaPWP8aa+0N2e5gpQvA+Td8rwhjMcnJ3VppQDogpOqH5WsWSv0UI9wLOB6s2CIYJb2zscqbFR28kL87IP4vOwyu8i0zVW0yq9VD8Oi410eZhAixP03LPnAtfo3zuKA3oR9lICbUm+YPoRYBg==
Received: from MW4PR04CA0093.namprd04.prod.outlook.com (2603:10b6:303:83::8)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:45:36 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:303:83:cafe::82) by MW4PR04CA0093.outlook.office365.com
 (2603:10b6:303:83::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:19 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:15 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 20/24] RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
Date: Tue, 10 Nov 2026 15:43:16 +0200
Message-ID: <20261110134320.34408-21-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|IA1PR12MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b67ec70-3458-47d6-b148-08df3f30e64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|10067099003|11063799006|56012099006|261021135927099003|261026140227099003|261021121427099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003|261028144727099003|261102123227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	F6lI9mwJ0A4/SEx8qkbD/Ja1KDcCU/bPQV5uWNyDDTxh7GkcsKDOW93CtWsKrmBBfF6Zir3ST6mCi2gitAGO6X3OaBxuw1pH7jFvoFfRf+2V6Lbk4KsgHFwM1M0xv3gsNE3ON8EG45+Q/gCDJ2CawtL0zGe8mAbLRgWOUCrT5H50mY8d8/U8V9rw+V7O9cbQuu0O1y0bG4DSo5vTMrdlI02UclBkjWf9Gp9RI8NfQxi9D7FQKubKvd77eq1O4er0hJcb6fC1upeu10D6/XD0FuLGAs8bjufICRuEpM+JT5/apjjHXbJodqQyabYpyV+6GtTPnJUE6xGByI4bG8l2MZ+4QcBrKxSsk2bg7W58lRmeUA3TUYaQWQZzHUK8jc/R7yFyRh0vU+zTcCfGcSNtIZbH0qYM6I1DykGHtaVoEWAkQlAhGKBk/VHd5q9mWxM8u6ZaJIztBWIqedUfFUbcx1Qphs3kOldCfJ8FLiqRxzC8KiE7Mu44QywUTU2JDoYt85yoOBL5vBcJ09mI5j3cHxcfry5dkSwJdHK1zuv8yx6YSDTOCpZM6sm6Y2KMzuSbKdBOwyFrCehJjsUHjoUQcnwZyCoh/fKAdm1LZgr/ETnn51VBeEwQEcSn4lyRXeP1Ig2mT/WsmZLWqdMEm5q6vl7Iap8OTeybn2nL8//sXcmpjGF8UFuwLyM8dMclHQ3f73MpuXDR8rXCIp9iD0Wa1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(10067099003)(11063799006)(56012099006)(261021135927099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(261028144727099003)(261102123227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dtSSj9kRYrNDRnnAeu7DNe+OxxgIGGmDE3G/Dbx3DiohdPlgGZiYmxEtvR5SUF2WiDwOyNUWBMzjQ12o80Ylfgn+y46RvLT3RSe4Dxiy60kZsuEPTx0lwjB5ap52XqsogHQf3fwU23Egc6iIGCP6uGaL23PhODqvGypcbSBYnKIwS7Hcc8AXzBccS6nIZbkQ65wXAK1FxcK6ChD80eUCAcu69AkoedvQmKrWlXpX+Rib+SDC3SXl+rjPlfffuPVKF2KwaARp2k/2saRD4sbkw4UnmPB4t/miVUzaRstszyqgHTexncK1VVUY1PeLFp1toBK4D76WSXpd5ywH1EFPg3fl8XSknNmcJ4dTn59bNCwATsWyMPUh1ZlarUko2aMQYL2pNdUKWqVtiXA3rqbL1gBzV6mYghUmdeEPhPiwxcIqE7hvbATiW95GHDd+Dlo5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:36.4301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b67ec70-3458-47d6-b148-08df3f30e64c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331

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
index 85ae8ba311e1..cdb7b54c9deb 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -879,10 +879,14 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
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
@@ -925,6 +929,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 {
 	struct mlx5_ib_create_cq ucmd;
 	unsigned long page_size;
+	size_t buf_size;
 	unsigned int page_offset_quantized;
 	__be64 *pas;
 	int ncont;
@@ -948,9 +953,13 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
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
@@ -1149,6 +1158,15 @@ static void notify_soft_wc_handler(struct work_struct *work)
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
@@ -1156,7 +1174,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	struct ib_udata *udata = &attrs->driver_udata;
 	struct ib_device *ibdev = ibcq->device;
 	struct mlx5_ib_create_cq_resp uresp = {};
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1168,15 +1186,17 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
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
@@ -1246,7 +1266,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct uverbs_attr_bundle *attrs)
 {
 	struct ib_device *ibdev = ibcq->device;
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1258,12 +1278,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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
@@ -1565,18 +1587,22 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
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


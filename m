Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724134;
	b=5BNoJtT/K0JdJyBaR+MqaSK5dtyaxI3p+l+nUJIGvNgCqT/paLBp48pPSxvNJTUvFb/X
	 AWYlmqQ0Uu42Z5k88F6DoDXIT+pUoNs5CWfI9FUXWyu1RMQaVBpa2/3RR46JWoAgjMDUI
	 6nrR+qnt96ZSs9ELoP5MacHoI4cWjfHD2tNTBs9gx36mbwIO0Bgwrwm6NA7IhZDpJk4bt
	 7Fem6FvckneE6d093D0epNUG8RnmbqEi+u7EaJjTra8R1QOZBxVLAHvMcz0k2MWSaWuTR
	 b8yxdKW+gmrReZhvdqUeUPxM9tKyHUHiVRBL9xbOvKh3v/luOdng2/eqCohWnnHWtvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724134;
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
	bh=YiyGG3x+S3OMTo+6G0y6tKrPjz29JIoLt4yuPuq0TjQ=;
	b=Tub7Q7ilo0bQCDeKLnU+opguF6XEeS3KZlim3ELrW4aP7QZn6GRfQIbfSDe20UVVRu1y
	 S+OOhg84TVBsFR8hdPiIJrAeHe56ZkJJmk7Y9/Eyco42l6f2BT/KjHbpzrM2nFQ9bJrXV
	 AW+1+VVxjRZyuqDSiTnW51Q00+lKaxmVAgIEJidEmtHfw5a4e/RA0w15YxhZmVGDYHzeJ
	 h8+OrdX7F1hx3fNJQXBfEFbUHMT2+kk0BEQYmvtiMJYwWUVKZsCnpXte4voPJBZIpkdG4
	 GiL8yb6R1ennbcWSlc48wVmsuamyNKQHqy4ivyxKCO8swk9xQt0cB4i3mcCOiXr01iA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HBkU4efH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.67
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013067.outbound.protection.outlook.com [40.93.196.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE1E6082BCC;
	Tue,  3 Nov 2026 16:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECE1E6082BCC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HBkU4efH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UBs4K76DpfUBD8ixmniLfqYM7wCsahQ33+fOdySmgT37QqmqvublcgQMlboa58Y/MXsf4+mcQsNjO2A9kFoajv8eKVQfjsERxddUJcld42V3A/z1ilw+ql25YAn0lwZhTbUHn09daCNj2Qu71sm43T1oAw5H5acfHq0YkEh4WsC7wk1TS1HebomSgxC2Kr+wJd6jeorg8l5EgNP2bBPDX/veE/jnHVwYgtkn3PA+p2yIWNS8UdU8lgfuxk0k9Ufk1tDvvMMqfMCTKg1MWvRjEFZpKDPEZaFZt8y2chI71rDnQu1Y/pSVxbJGA3hlAonNJ2PEWGvRXCI71JPlSRk+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiyGG3x+S3OMTo+6G0y6tKrPjz29JIoLt4yuPuq0TjQ=;
 b=x3dA6mW89cfvcvChMSaoHL9597C25QCMkrk2wpDVItVRiQLaKBCLR5i4FuaJ7gyDxUDRcs3Pn0agbNbJtgVrtwl5ycq7HnhhvTrbTwSN1sYN8nM2dAD6O2fhMuWqf5S8xqcsAY9FcQ+UAzA7hrjOXAZa+cPujc5lDVJswsq5Zvtrmt/Tioti2L+NosGCB4dMdpEXoUsoo29b0f68VY7oN1MRfSt1JB3fNUgA8IzU65dO36aGGzZHNgwhnUPaDVGe+dJ4iuvYv3z9K4ouLc5zM6Es6QV1qLJU00XNhYnhw2yaXnr2kLxN6dFtPnIm6nMPGvnK7G3Uqb6u/Kj1sg3Bwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiyGG3x+S3OMTo+6G0y6tKrPjz29JIoLt4yuPuq0TjQ=;
 b=HBkU4efH9PvGYI5pqBIeTMWmfkN43bc3oHdBRWgeSexk7Nlm93C1KBfmnY8Vvft7giN20xp43674iCuVf6i6HKa2Eyzt5+NxyVNxYfThMBjTgGzmD4Gsl5ZPi8I+ZetFpF7PCyQg8gx+mHoOobR4sQscqsAUr9UfnFslX401HBS0a7Jfvvop7zfOBuNywm0PXA0I+7yDmRilF6igHMPa3JTbK4QsQSVAearYTUx/217cXWdPWwudCieoPtnWv2qD3oBWredkCPORQR4ReWWLCByJFsFZEKmOAZVKSIm6P7lX89GmHIWozdq9NLQ00LAHslWeLWWqjy/nT5ztJ+PXXA==
Received: from SJ0PR13CA0111.namprd13.prod.outlook.com (2603:10b6:a03:2c5::26)
 by MW6PR12MB8999.namprd12.prod.outlook.com (2603:10b6:303:247::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:08 +0000
Received: from SJ1PEPF000037AE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::94) by SJ0PR13CA0111.outlook.office365.com
 (2603:10b6:a03:2c5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AE.mail.protection.outlook.com (10.167.244.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:48 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:47 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 19/23] RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
Date: Tue, 3 Nov 2026 18:39:45 +0200
Message-ID: <20261103163949.1554-20-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AE:EE_|MW6PR12MB8999:EE_
X-MS-Office365-Filtering-Correlation-Id: 2409c20c-9dbf-4beb-6316-08df39c96698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|1800799024|261021121427099003|261021123027099003|261022105027099003|261021135927099003|261022075727099003|261009223027099003|261028144727099003|261026121527099003|261026140227099003|11063799006|22082099003|18002099003|261102123227099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	T/c0HWyRQKRLoPQ+x473mZO//A47QP37xzToVWqjifHnwth91vEQeruTOsDZmJvPYv/fdn8pd1Rqj2RAjGUwsKeufn4+wFEB8HSWfhF/zVapsgd3bGb6KRD1OROsh2kAyocL+NFnEtbrsDxKgjjLmZB52RbL36H4hUTmcnOWrgONLKNpi5BLRhO5vNEf6vTHp6v5kWMya5iQYHYrbMJnGAMUJsbE+aU9TPnHibx16oSJ/zqE0Wz9G6fEQGS+6ozP1hsyDB5X/LV7y9aLuffLvpAf0N5LlKvTSPUDiWs2hf76ubymCFwWl7JzL+QEjWgNXECkrRzpuvNopop+BE6l2e6/JEosXc+6NQ1Ud+n2tSfDlB6192YoetWl1bO63cJj+YBWDCyILtP7zffk17nFZYrpRZcucl2KZN1poPkm4dVlCia+2YJH4Vs+iAUMCESVr7mufYSFns8JnngY4xQajsvJ6ne9q1YYVgEv6ukbs0RqaAui453+LCKixvbfpPgReAcNOt48PGmu47YVi62LzwGD63KGnvOzl9UIl1d2pG3z5bLKb3wnXUAwgWPOaFC3iq+lz+tpa0Ohc68FObYcaS3qLf0Bapxh48TB+h36q8yZB5KVYvm8RUwsjTFgEa5qZXPcBOHobp5XJuxWimpbR+LY8MzQT9ssPZWUd/LhgCGVPSWR1DskpbFCPXPGvBTJrhhjVyGrS+YBmNzj9RsycA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(1800799024)(261021121427099003)(261021123027099003)(261022105027099003)(261021135927099003)(261022075727099003)(261009223027099003)(261028144727099003)(261026121527099003)(261026140227099003)(11063799006)(22082099003)(18002099003)(261102123227099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1F7xokBagd43B2l+MlMsJCH1Yxgqoa+FywWc4jIqz/HDnYCteeTpyFrOs3UlbE7o7bBm08qk4XUOsOK2IaUxK2m0Kv68i22L8R3+e4O4VQl1pAsjaYzk/2xM53zj1V4Fw7Mj4GtiBIfPUFotdd1/TdWZ0Q2S44f6QYP4yhSiFidedqvtMt9VZTm0TlSZlTv4+vB9yYOpQgmsRehDI/1sfPbFvRU9uj3zeuymEKzw8Vv/5sADhvhxp/PrqwwgmBpp4S9mASbNGJt8+oqCqi8fXyHJxGRI606wWY1m/BVW3RpLSfd9W/LXnygNxy4qzZhnE3fgxXY9kPqCNwrdWYpQ8ddbupr2XVJyAg0qeA46FKUi+osageYSSHgtERCpgG0BFRP7xRgfTCgbktFg+aMg1P8Lddk14FJbiQMDoiSSfgdSN5+BSdieCt/1QQckQGeN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:08.2075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2409c20c-9dbf-4beb-6316-08df39c96698
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8999

The CQ create and resize paths check the requested size against
1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
report 31 or more, which makes the shift undefined. A large limit also
lets the rounded up CQ size exceed INT_MAX, and it is then truncated
when passed on as an int.

Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
reject sizes above INT_MAX.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 39 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index f955eb762051..25344dfba1c1 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1117,6 +1117,15 @@ static void notify_soft_wc_handler(struct work_struct *work)
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
@@ -1124,7 +1133,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	struct ib_udata *udata = &attrs->driver_udata;
 	struct ib_device *ibdev = ibcq->device;
 	struct mlx5_ib_create_cq_resp uresp = {};
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1136,15 +1145,17 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
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
@@ -1214,7 +1225,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct uverbs_attr_bundle *attrs)
 {
 	struct ib_device *ibdev = ibcq->device;
-	int entries = attr->cqe;
+	u64 entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -1226,12 +1237,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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
@@ -1532,18 +1545,22 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
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


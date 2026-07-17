Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013044.outbound.protection.outlook.com [40.93.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5F3BFE21;
	Fri, 17 Jul 2026 09:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784280287; cv=fail; b=jUn9dEUBCDqQqU6IKeUXJcgBKZlEsFQqpsKFFjyIFPaS2H0Oe+AmMtP7ZgZxDl9icGYr/cyNVbMGPkh9JVPT9LziEc4PQU35yGbvfuXZaA0/ZsbX7248US1KMIrsO4blkz9MYHkwla2LIVSWLG4A2ybtpumpfy1flhFbK25UmH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784280287; c=relaxed/simple;
	bh=lWnvE0Y1rdaHf3TkqBgBjipA32TrDwqmsmEByNBlvII=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VoZR95l8WM6oMhVLLgQQLCUXqPcDpFEsYAUmE6fKGn1wMT+uOH4P3gpe5Q+Y/+MYZ7czrf8hykUwqFWvYLyfa6it4pA52F38NYoeKxnpXjQU94nkTC+sUCn0MrBWzGGL+S9/Me6SMeN+dBj7XinIsY4xqhIkK1HWboIOwZrtQiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0x8HlWw/; arc=fail smtp.client-ip=40.93.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0x8HlWw/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSJnJ8JD2dVUmFQI+c1O4gxVPTg+nCH20Y5AaTtpBgirVVmtay3ENIxHMvNBzWlWEwieEok2DP6J/inIUPHFgJ7EreVUeHNQys//f1trTAaz4VbP4IfkZKZD16frO/4bgKfk0Yp3vgwjpl6paueennaajcXZht7U9yhZ0DCzpSfHHVxaiyK+cPTckPguX/uR1Te95UwaJTSs/RE67/oN9ioc98NfHTcWHJrEAwcmlPjGU5rPkExC4FumkuwnJ1eRkFIzfYrBXEYUl4sIHqZansfsnZ8SHA/183EmryJ29pI/znRtgmrF76SnvpnqozR52GEuEt6OdVL2mqrg7M1CUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0oPoM4t9rDtIuZGTjIiOE8m/MRclPalszjDCSMiZmE=;
 b=i0uo1s0FstDp4WksPEnyE7ZVRhcigXup6t2npDF06CxrFKm5cG9O3aSpgyJNyYF2ovgHHCOsI9VhC+VbuW0U/ScbOFqNd51JaMuU1pDc8VjKBP6gDXPqMNFvwdShUL8z8z6SwSHYflfNIO4vu10Wl6ZnZ4n4ZkqwSYzwQR/9lccF0W2U0R4A56Cr6pZnewMU2YEVkUHvapNOtgU9MIvonr7Q5ptSet/26LOFx9/eROtPptxdFOGNMpD4gKEYj/xogHLYqpxYHgElx4keYdPYcfTyrnb6xQvcmUKpJ8LSNlqf3r4KDmR6d0Z8mu3oiATLKu6VNTTGD8LxUuPF+lrD2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0oPoM4t9rDtIuZGTjIiOE8m/MRclPalszjDCSMiZmE=;
 b=0x8HlWw/iqKiQvMCvCMb7IAv3LZbchVhvx1gJHFNf6lLrqyeBDxfYe7Vsjs7xSrbNrhvcHLbVUPcq0dhgX5wkH4n0oB/XU/gWP1nMg9YAfGCy0RVy5Eg9Nu2kXsYkjYhMKYZCHpJKh1ZnIlAkEEBJyCKVyjfpeU4wFxxiF5zCWc=
Received: from MN2PR06CA0011.namprd06.prod.outlook.com (2603:10b6:208:23d::16)
 by SA1PR12MB7040.namprd12.prod.outlook.com (2603:10b6:806:24f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 09:24:37 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::53) by MN2PR06CA0011.outlook.office365.com
 (2603:10b6:208:23d::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Fri,
 17 Jul 2026 09:24:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 09:24:33 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 17 Jul
 2026 04:24:32 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 17 Jul
 2026 04:24:32 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Fri, 17 Jul 2026 04:24:30 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 1/1] RDMA/ionic: Add robust udata compatibility checks to all uapi verbs
Date: Fri, 17 Jul 2026 14:53:45 +0530
Message-ID: <20260717092345.2533564-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|SA1PR12MB7040:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b510ab1-7c13-43b8-2736-08dee3e5366f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	tgn3NK3rRmq04TurfHEYPkTGSPsbqZO73fNIIxjQoQcqfIwzB80gwu4qVToL2CE05bvhauyUU/jrt6I03EeZnA+wx1dUaYkGG7lKmE7eZO6f1vW2tjJ3eVctGLhE7tEMnpkv4/yNWGVkbRj6/1BxhKfuVIJnaJm/FO+uhUgA0pNdI+oQhqB7pG3xq6kVHJkx7io0bMFGLH4SXTyOcvDfbsYrGT2/HIvQEvjyrRh5W68bdMzDoxR/l3ZSYpBdEYIg92i64LbWX2Bsv+ZDk3QW91662sBgr7x175yGmnfwpgCu6SQXEVfiDlPLpL/4x62UQfqheN3xCxB74wWaVipUFhtj742RgncjMIZV83xLQepdVu91TmT9Lq4H3FcdAN6VwnXQlSlD1WsYy1bKrUO7YbtLlHoUcWmmWqeQJPBSmcr4ngPJ6iwoXzMXJHQNrK9kxc5YZeDrKo5uGwArHmpGb47BhAY/4B7dpug/nvhhr1BnqvYX7SjvY8UGLYcaQkBo9dd6tol3kbgoc2G2DPaK+55bkdNoawRUSwjT+nUL/6oUR26OC7HxQQJ9TlvUATV3O3aKYGFUAgbZUPwtNNU7IISV2/19l+nkms3izqy8fnXaaMjTXiW/F8uuHU4F5jnXTgQas5UVz8xOp3cbuQBxY7se0EEKU84hQRXKZrY8jazz97CRY+2hWxLtc9Gbal2t+ga36Q28DRnVSuMgYsXTIg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dJUUhlwNskBQrmGOR+lqTPgHD5aEol9KMFAfQDpZ0oy0PbJHlClV0UKNqC6ewzOmvgINv2Glu9X+AkdbOdcjwxVB/tvasn5h41Ln/SW9X84qICYHN0/uEwZm9i76tVzWGIrJj7syC03hliaybHYvWDdICCzi6akOpub4BXffza1WHsLxq5/UbW3Z4Iy07GLFlu9pkeXRnPN9QDtj4EbDlnE1Y2LopW8pylL0a8hZwgDiQj7C8FvB1/chjGdDLHKIDMLVErifVoVs76Ffdio+svaqC2OEqPQAE7m95rWXoJ7dyp/cDptE9xqnbh3fKBiFlCo9qJ/vXjo42FVxHT2LXChjOSZop/27hAGRSg48/MEsJVvKSKSJwNBWw+lLporgjRW8JQue9j5F70nd18jPWjFM4raVG9KUeUJ4oKDmafeKLFmqnbPtke58FSJ5WAr3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 09:24:33.3019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b510ab1-7c13-43b8-2736-08dee3e5366f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7040

Enable the robust udata contract by setting uverbs_robust_udata and
adding proper input validation and output handling to all verbs that
accept struct ib_udata.

For verbs with no driver request or response struct, add
ib_no_udata_io(). For create_ah, which already responds with
ionic_ah_resp, add the missing input validation via
ib_is_udata_in_empty().

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 38 +++++++++++++++++++
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  1 +
 2 files changed, 39 insertions(+)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 9d91f7667d4f..42b02ee643ad 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -487,6 +487,11 @@ int ionic_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct ionic_ibdev *dev = to_ionic_ibdev(ibpd->device);
 	struct ionic_pd *pd = to_ionic_pd(ibpd);
+	int rc;
+
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
 
 	return ionic_get_pdid(dev, &pd->pdid);
 }
@@ -495,6 +500,11 @@ int ionic_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct ionic_ibdev *dev = to_ionic_ibdev(ibpd->device);
 	struct ionic_pd *pd = to_ionic_pd(ibpd);
+	int rc;
+
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
 
 	ionic_put_pdid(dev, pd->pdid);
 
@@ -741,6 +751,10 @@ int ionic_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	u32 flags = init_attr->flags;
 	int rc;
 
+	rc = ib_is_udata_in_empty(udata);
+	if (rc)
+		return rc;
+
 	rc = ionic_get_ahid(dev, &ah->ahid);
 	if (rc)
 		return rc;
@@ -877,6 +891,10 @@ struct ib_mr *ionic_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	unsigned long pg_sz;
 	int rc;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return ERR_PTR(rc);
+
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -1008,6 +1026,10 @@ int ionic_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	struct ionic_mr *mr = to_ionic_mr(ibmr);
 	int rc;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
+
 	if (!mr->ibmr.lkey)
 		goto out;
 
@@ -1120,6 +1142,10 @@ int ionic_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	struct ionic_mr *mr = to_ionic_mw(ibmw);
 	int rc;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
+
 	rc = ionic_get_mrid(dev, &mr->mrid);
 	if (rc)
 		return rc;
@@ -1292,6 +1318,10 @@ int ionic_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct ionic_vcq *vcq = to_ionic_vcq(ibcq);
 	int udma_idx, rc_tmp, rc = 0;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
+
 	for (udma_idx = dev->lif_cfg.udma_count; udma_idx; ) {
 		--udma_idx;
 
@@ -2585,6 +2615,10 @@ int ionic_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int mask,
 	struct ionic_qp *qp = to_ionic_qp(ibqp);
 	int rc;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
+
 	rc = ionic_check_modify_qp(qp, attr, mask);
 	if (rc)
 		return rc;
@@ -2658,6 +2692,10 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	struct ionic_cq *cq;
 	int rc;
 
+	rc = ib_no_udata_io(udata);
+	if (rc)
+		return rc;
+
 	rc = ionic_destroy_qp_cmd(dev, qp->qpid);
 	if (rc)
 		return rc;
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index b0449c75f893..ad4e9abb5bf4 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -216,6 +216,7 @@ static const struct ib_device_ops ionic_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_IONIC,
 	.uverbs_abi_ver = IONIC_ABI_VERSION,
+	.uverbs_robust_udata = true,
 
 	.alloc_ucontext = ionic_alloc_ucontext,
 	.dealloc_ucontext = ionic_dealloc_ucontext,
-- 
2.43.0


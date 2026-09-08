Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E55563FDD
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881455; cv=fail; b=mGH+XxQygeNohcyotall5WagC+8ThrtK1x89GdbRvgL17hc3rjYqDFLcqwyEfwqtJpXz516L19aYSSxLxr3r3whtodmpCjR848dgKTv/G/yYPw5emyFrwHYYSyDHbv9iBF63SPzTFwZWZZVMAI8tosL1yaGnRJaBWTkawuGRGrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881455; c=relaxed/simple;
	bh=G5aVfKahN11RGoMtCEZWEWFb4UUjlRtLhOmKo+cYBNA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RuWAocQCNct27pDPnuVNnCemyGZBqexAIaTCiuQymgiJesP8mrpkv7MwFx/einjniu/HJxCJKPBr+b9tThr07hsoDAqu0l6NP2qsq2LQ5z1Uuc8+GExeitpYAbQ1uZ9IuDODstiOcbW9tLpgoRTUxYwozlaYheQ99yEKyZM2yGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=krYgMnis; arc=fail smtp.client-ip=40.107.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="krYgMnis"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwogmKDCETO6mYigPaMuzvBOuee6D3Qwg71KOS86Z8b9vmKtFO+hDMvMplkR+ZZWFUliQNIaO6r+sPqQNIFpu9Pmy+xRl7634itdcRsfTZkVmLB1pQ0NWv7wzJrIGRwUvJ4wrL7zKufyP2L0CymsyRksPQWf3OcxmYOlh6l7caIyrNFSOsciRqD1WWrSqo937kHTEkqDzTwR946gTfO3hx+ibZFRLTunEDu/olHLM4YGg9/bcrwKqwg6wPxRXxJHGuf0W5tVq+7HuUfiCsqdpbnzBUAkS+1qG8ZoWpGf2MeVZNQR/YoiUUlUx3g0byok+u5tNxrd/uUGHC0a+XyErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+SmmHkfKin1sS6lwHDa2JNE39PMWEyeUsFT1eS8C4Q=;
 b=pY8sk4k3KHpnnjQ+sTX6P5yeF28SAnctm2wX0ptgWqgrD9IniZVCax/fMWdD28vLe7CQg+l281nAwqIap0iG9BKwHn1L10pQgMSR00L/1lHB12ECxTk2x4fBR77YP87qVfcD+eGHgQo3gBkBqtHlaoBpxWbo7ENJkjoo8JA/Y4cGCnqR+bAP1Zr/buIoGpjI9blpbmItRj260FyCz8R71UpjpAj35vdgaei4WXWvNs4ciI1R8ekoYucbmiu1TXrli0QR1k1E3Yr+xSmOV8K+0cG+f9zrlcNizahMJqkY/uoYJ6eX7GHY8riWn9HIRZiW79kd7N3BQt0IUOZ7oY3XcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+SmmHkfKin1sS6lwHDa2JNE39PMWEyeUsFT1eS8C4Q=;
 b=krYgMnisRuxLagnVQjxwSd43KkuflI3+F7bPAr5ALg1mZ7lLvPTvAv0xm/Lf2BKVooX5lJTblpb0QjsC18M8ffWU5sp3iTttKAZCMNcQ0d0aSuxIyaoDD/xwtoOSYPAmpn3nt+ZneIUIVt5DVst77fPqBh/GauqkDQQUWp6Ozi9Qm22jsQ/77SqLYtL0TSQDlQcdoGwXFtE6BQozCKePRaa05O1NVjJVIjnrLhzaPnCg1wWREbHf+eiHi+lrt1FwG0aZf0DsbzeveEYzKoY6b5dnTd5x13ZflEuKBBS134pcVwOuKweyZv2kdAeX9biKaQzJjtrIbEYBuhWwQajZpw==
Received: from BN9PR03CA0510.namprd03.prod.outlook.com (2603:10b6:408:130::35)
 by IA1PR12MB6089.namprd12.prod.outlook.com (2603:10b6:208:3ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:30:24 +0000
Received: from BN2PEPF0000A88F.namprd04.prod.outlook.com
 (2603:10b6:408:130:cafe::d) by BN9PR03CA0510.outlook.office365.com
 (2603:10b6:408:130::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A88F.mail.protection.outlook.com (10.167.248.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:49 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:44 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 04/15] RDMA/umem: Reuse ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
Date: Tue, 8 Sep 2026 18:28:40 +0300
Message-ID: <20260908152851.1307294-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A88F:EE_|IA1PR12MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: d777dcaf-af7d-4b06-2903-08df0dbe1953
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cLKml+Ligdcwz79VVhbPQOnt2ZS/VLbmO3YJ//b8dMyM8t7bW1+RK/ul5JVzrV+XWQ+o3z8Jo0PY7DsGG1cPWtDAB5V+PsPrXUGVOgoI25HMXM5nmHl2X0j+cMi0W3Bo/ahm+Jl7RNoZ5au3myfffc+s6Tn6ChFeXxuDuaN2os02Pda4WG/DNkuhCLYfa7TGB1LKybSXbPtdoVYIHL95CMQioVcHGCGqJrFn9O+rvLAdpSwFyP0oOaG0o3wOJb1N3AphMGyzLPNoWooHpmP7MY9ewRTJ/aj225TyxlAz0voGHhc3+QaDzl34fK+CKJ9zy7Uvs3rLG/5GHdbper/93JmesrAe3CsDjXfjoAMjd45UDflptv3li/L5zs6QxFPu3JLoIGP8uNZwoiK+z6s6W0+3/ukdsN4DiFwQxcmykDQLU5Ai98ZpL4CugweacpbnpOI9U1TpGwPM0rhiZBe8w1iW1GJrRANgZe+6/JLKW9L+4qFCppLK03F/y+iwSH0N7zWMsenjKr7BrsXV+ZcpKiIg2FYnQevGswtrPK2EyY34Gpp6CyKny5iSafP01eIEB+FAq5SkUAiRCzXCamIvtT9SntrJ0kwjigXLNO/WbtTzIPR/PZQ9IOYj3NmMQ7/u8b9TuncyuyllP0NQUhpW0hfOe4tRQH990cWRUeRVdJ1VQt+Be5sR9xtJomWAVTWkcKYQBlozww4087oN7g/reA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	su7FDuEdfP6DIXvT1Wfpl5gXbvKO+P4Var6Sov2M01mTC6DxBIqfn2Mpyixk+BtA5SfaPugkTOT0njvFSEBgyHRqBvW4ECfTpYpjPwSvrqbj5wu6cSPrD+P8QjGM1mF42OWDZ8T4rZUizYPBVj/FNULR7yjOHIs4ZanbElSgFjbQEmjOsn88RhSZwwTWSOCb1kQCzvsDAt0BdYiO+0RX0bYSad+VPZXGT3slaasvM7QuPGtdKEbWoR4kxWPDV10KFxV51bjps2KSqF047h0ci8jvg8/gBFaHTt9qufJiWFymr32yo7duhyza6S5rduTcIuA8/0mgOysL5kJcbv549D2ttdfUfCLehCdrbOf9HMFxoMIwyjJdeR4eYRg6GbNcWm+1hAtIHYkzT3FthOWiDrc9Nh9CDXljgyMINJjsUovu0uBwXDTkCP/8m7ctMUr+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:22.7915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d777dcaf-af7d-4b06-2903-08df0dbe1953
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A88F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6089

Several drivers pin a CQ ring buffer directly from a plain UHW VA
instead of going through the per-command UMEM attribute machinery,
calling the generic ib_umem_get_va() with IB_ACCESS_LOCAL_WRITE:

  - mlx5's resize_user() (CQ resize)
  - mlx4's legacy fallback in mlx4_ib_create_user_cq() (no UMEM
    attribute source available) and mlx4_alloc_resize_umem() (CQ
    resize)
  - bnxt_re_resize_cq() (CQ resize)
  - ionic's ionic_create_cq_common()
  - qedr_create_cq(), via the shared qedr_init_user_queue() helper
  - mana_ib_create_cq(), via the shared mana_ib_create_queue() helper
  - erdma_init_user_cq(), via the shared get_mtt_entries() helper
  - hns_roce_cq.c's alloc_cq_buf(), via the shared
    hns_roce_mtr_create() helper

ib_umem_get_cq_buf_or_va() already falls back to a plain VA pin whenever
its attrs argument is NULL (ib_umem_resolve_desc() returns -ENOENT
immediately for attrs == NULL, before ever touching
attr_id/legacy_filler) -- the same attrs=NULL idiom ib_umem_get_va()
itself already uses via ib_umem_get_attr_or_va(device, NULL, 0, addr,
size, access). Switch these call sites to
ib_umem_get_cq_buf_or_va(device, NULL, addr, size, access) instead of
ib_umem_get_va(), so all CQ buffer pinning -- attribute-based or plain
VA, initial creation or resize -- goes through the same CQ-specific
helper.

qedr_init_user_queue(), mana_ib_create_queue(), get_mtt_entries()
(erdma), and hns_roce_mtr_create() are shared between CQ and other
callers (QP, SRQ, and for qedr/erdma/hns also MR), so each gains a new
is_cq parameter: true from the CQ call site, false from the others,
which must keep deriving direction from access flags rather than always
mapping DMA_FROM_DEVICE.

Also update bnxt_re_resize_cq()'s and qedr_init_user_queue()'s error
messages to name the new call instead of the old ib_umem_get_va().

vmw_pvrdma's pvrdma_create_cq() is deliberately NOT converted here.
Unlike every other driver checked, PVRDMA embeds a pvrdma_ring_state
producer/consumer header directly inside the same buffer as the CQEs
(cq->ring_state = cq->pdir.pages[0]), and the driver itself writes
cons_head back into it after polling (pvrdma_idx_ring_inc(&cq->ring_
state->rx.cons_head, ...)). That makes the buffer genuinely
bidirectional, not device-write/CPU-read-only like every other audited
driver's CQ. Forcing it onto ib_umem_get_cq_buf_or_va()'s hardcoded
DMA_FROM_DEVICE (added in the next commit) would break that CPU write.
PVRDMA's CQ stays on the generic ib_umem_get_va() path, where it already
passes IB_ACCESS_LOCAL_WRITE and so continues to correctly derive
DMA_BIDIRECTIONAL. See the dedicated vmw_pvrdma fix later in this series
for its QP and SRQ rings, which have the same embedded ring-state issue.

This is a pure refactor with no functional change: today
ib_umem_get_cq_buf_or_va() maps every buffer DMA_BIDIRECTIONAL, same as
ib_umem_get_va(). It prepares for the next commit, which changes
ib_umem_get_cq_buf_or_va() (and ib_umem_get_cq_buf()) to map CQ buffers
DMA_FROM_DEVICE -- once these call sites are already routed through it,
that change picks them all up automatically, with no follow-up gap to
close.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++++----
 drivers/infiniband/hw/erdma/erdma_verbs.c     | 17 +++++++++-----
 drivers/infiniband/hw/hns/hns_roce_cq.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       | 22 +++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |  4 ++--
 .../infiniband/hw/ionic/ionic_controlpath.c   |  5 ++--
 drivers/infiniband/hw/mana/cq.c               |  2 +-
 drivers/infiniband/hw/mana/main.c             |  9 ++++++--
 drivers/infiniband/hw/mana/mana_ib.h          |  2 +-
 drivers/infiniband/hw/mana/qp.c               |  9 ++++----
 drivers/infiniband/hw/mana/wq.c               |  3 ++-
 drivers/infiniband/hw/mlx4/cq.c               | 14 ++++++-----
 drivers/infiniband/hw/mlx5/cq.c               |  6 ++---
 drivers/infiniband/hw/qedr/verbs.c            | 23 +++++++++++++------
 17 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..e1197868c7a9 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3749,12 +3749,13 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe,
 	if (rc)
 		goto fail;
 
-	cq->resize_umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
-					 entries * sizeof(struct cq_base),
-					 IB_ACCESS_LOCAL_WRITE);
+	cq->resize_umem = ib_umem_get_cq_buf_or_va(&rdev->ibdev, NULL,
+						   req.cq_va,
+						   entries * sizeof(struct cq_base),
+						   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(cq->resize_umem)) {
 		rc = PTR_ERR(cq->resize_umem);
-		ibdev_err(&rdev->ibdev, "%s: ib_umem_get_va failed! rc = %pe\n",
+		ibdev_err(&rdev->ibdev, "%s: ib_umem_get_cq_buf_or_va failed! rc = %pe\n",
 			  __func__, cq->resize_umem);
 		cq->resize_umem = NULL;
 		goto fail;
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index fca2553e47ad..3519b5044e8f 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -828,11 +828,16 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
 
 static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
 			   u64 start, u64 len, int access, u64 virt,
-			   unsigned long req_page_size, bool force_continuous)
+			   unsigned long req_page_size, bool force_continuous,
+			   bool is_cq)
 {
 	int ret = 0;
 
-	mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
+	if (is_cq)
+		mem->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL, start,
+						     len, access);
+	else
+		mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
 	if (IS_ERR(mem->umem)) {
 		ret = PTR_ERR(mem->umem);
 		mem->umem = NULL;
@@ -951,7 +956,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 
 	ret = get_mtt_entries(qp->dev, &qp->user_qp.sq_mem, va,
 			      qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
-			      (SZ_1M - SZ_4K), true);
+			      (SZ_1M - SZ_4K), true, false);
 	if (ret)
 		return ret;
 
@@ -960,7 +965,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 
 	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
 			      qp->attrs.rq_size << RQE_SHIFT, 0, va + rq_offset,
-			      (SZ_1M - SZ_4K), true);
+			      (SZ_1M - SZ_4K), true, false);
 	if (ret)
 		goto put_sq_mtt;
 
@@ -1250,7 +1255,7 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 		return ERR_PTR(-ENOMEM);
 
 	ret = get_mtt_entries(dev, &mr->mem, start, len, access, virt,
-			      SZ_2G - SZ_4K, false);
+			      SZ_2G - SZ_4K, false, false);
 	if (ret)
 		goto err_out_free;
 
@@ -1931,7 +1936,7 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 
 	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
 			      ureq->qbuf_len, IB_ACCESS_LOCAL_WRITE,
-			      ureq->qbuf_va, SZ_64M - SZ_4K, true);
+			      ureq->qbuf_va, SZ_64M - SZ_4K, true, true);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index ae314f136732..7dfaa01cda67 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -265,7 +265,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-				  udata, addr);
+				  udata, addr, true);
 	if (ret)
 		ibdev_err(ibdev, "failed to alloc CQ mtr, ret = %d.\n", ret);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index f4f899e87ea6..3accd77341ae 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1232,7 +1232,7 @@ int hns_roce_mtr_find(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 int hns_roce_mtr_create(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 			struct hns_roce_buf_attr *buf_attr,
 			unsigned int page_shift, struct ib_udata *udata,
-			unsigned long user_addr);
+			unsigned long user_addr, bool is_cq);
 void hns_roce_mtr_destroy(struct hns_roce_dev *hr_dev,
 			  struct hns_roce_mtr *mtr);
 int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 368e1d74c283..b8177d054a31 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6919,7 +6919,7 @@ static int alloc_eq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 
 	err = hns_roce_mtr_create(hr_dev, &eq->mtr, &buf_attr,
 				  hr_dev->caps.eqe_ba_pg_sz + PAGE_SHIFT, NULL,
-				  0);
+				  0, false);
 	if (err)
 		dev_err(hr_dev->dev, "failed to alloc EQE mtr, err %d\n", err);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 7d41ae897458..4799f667eeda 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -112,7 +112,7 @@ static int alloc_mr_pbl(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr,
 
 	err = hns_roce_mtr_create(hr_dev, &mr->pbl_mtr, &buf_attr,
 				  hr_dev->caps.pbl_ba_pg_sz + PAGE_SHIFT,
-				  udata, start);
+				  udata, start, false);
 	if (err) {
 		ibdev_err(ibdev, "failed to alloc pbl mtr, ret = %d.\n", err);
 		return err;
@@ -586,7 +586,8 @@ static void mtr_free_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr)
 
 static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 			  struct hns_roce_buf_attr *buf_attr,
-			  struct ib_udata *udata, unsigned long user_addr)
+			  struct ib_udata *udata, unsigned long user_addr,
+			  bool is_cq)
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	size_t total_size;
@@ -595,8 +596,14 @@ static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 
 	if (udata) {
 		mtr->kmem = NULL;
-		mtr->umem = ib_umem_get_va(ibdev, user_addr, total_size,
-					   buf_attr->user_access);
+		if (is_cq)
+			mtr->umem = ib_umem_get_cq_buf_or_va(ibdev, NULL,
+							     user_addr,
+							     total_size,
+							     buf_attr->user_access);
+		else
+			mtr->umem = ib_umem_get_va(ibdev, user_addr, total_size,
+						   buf_attr->user_access);
 		if (IS_ERR(mtr->umem)) {
 			ibdev_err(ibdev, "failed to get umem, ret = %pe.\n",
 				  mtr->umem);
@@ -1035,11 +1042,13 @@ static void mtr_free_mtt(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr)
  * @ba_page_shift: page shift for multi-hop base address table
  * @udata: user space context, if it's NULL, means kernel space
  * @user_addr: userspace virtual address to start at
+ * @is_cq: true when @mtr backs a CQ buffer, which the device writes
+ *         completion entries into
  */
 int hns_roce_mtr_create(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 			struct hns_roce_buf_attr *buf_attr,
 			unsigned int ba_page_shift, struct ib_udata *udata,
-			unsigned long user_addr)
+			unsigned long user_addr, bool is_cq)
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	int ret;
@@ -1052,7 +1061,8 @@ int hns_roce_mtr_create(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		mtr->umem = NULL;
 		mtr->kmem = NULL;
 	} else {
-		ret = mtr_alloc_bufs(hr_dev, mtr, buf_attr, udata, user_addr);
+		ret = mtr_alloc_bufs(hr_dev, mtr, buf_attr, udata, user_addr,
+				     is_cq);
 		if (ret) {
 			ibdev_err(ibdev,
 				  "failed to alloc mtr bufs, ret = %d.\n", ret);
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index e333a8c4acb5..c6c0dfdbdbc3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -808,7 +808,7 @@ static int alloc_qp_buf(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 	}
 	ret = hns_roce_mtr_create(hr_dev, &hr_qp->mtr, &buf_attr,
 				  PAGE_SHIFT + hr_dev->caps.mtt_ba_pg_sz,
-				  udata, addr);
+				  udata, addr, false);
 	if (ret) {
 		ibdev_err(ibdev, "failed to create WQE mtr, ret = %d.\n", ret);
 		goto err_inline;
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 4a54394f96be..b5e9ac9cfd59 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -180,7 +180,7 @@ static int alloc_srq_idx(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 
 	ret = hns_roce_mtr_create(hr_dev, &idx_que->mtr, &buf_attr,
 				  hr_dev->caps.idx_ba_pg_sz + PAGE_SHIFT,
-				  udata, addr);
+				  udata, addr, false);
 	if (ret) {
 		ibdev_err(ibdev,
 			  "failed to alloc SRQ idx mtr, ret = %d.\n", ret);
@@ -235,7 +235,7 @@ static int alloc_srq_wqe_buf(struct hns_roce_dev *hr_dev,
 
 	ret = hns_roce_mtr_create(hr_dev, &srq->buf_mtr, &buf_attr,
 				  hr_dev->caps.srqwqe_ba_pg_sz + PAGE_SHIFT,
-				  udata, addr);
+				  udata, addr, false);
 	if (ret)
 		ibdev_err(ibdev,
 			  "failed to alloc SRQ buf mtr, ret = %d.\n", ret);
diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 37f71fb43811..f392c635338b 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -110,8 +110,9 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 		if (rc)
 			goto err_qdesc;
 
-		cq->umem = ib_umem_get_va(&dev->ibdev, req_cq->addr,
-					  req_cq->size, IB_ACCESS_LOCAL_WRITE);
+		cq->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL,
+						    req_cq->addr, req_cq->size,
+						    IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(cq->umem)) {
 			rc = PTR_ERR(cq->umem);
 			goto err_qdesc;
diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 6f9ac8b4aac8..de81a4b994e0 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -40,7 +40,7 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 		cq->cqe = attr->cqe;
 		err = mana_ib_create_queue(mdev, ucmd.buf_addr, cq->cqe * COMP_ENTRY_SIZE,
-					   &cq->queue);
+					   &cq->queue, true);
 		if (err) {
 			ibdev_dbg(ibdev, "Failed to create queue for create cq, %d\n", err);
 			return err;
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 83a97f1c5caa..46cb51ea08b9 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -293,7 +293,7 @@ int mana_ib_create_kernel_queue(struct mana_ib_dev *mdev, u32 size, enum gdma_qu
 }
 
 int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
-			 struct mana_ib_queue *queue)
+			 struct mana_ib_queue *queue, bool is_cq)
 {
 	struct ib_umem *umem;
 	int err;
@@ -302,7 +302,12 @@ int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
 	queue->id = INVALID_QUEUE_ID;
 	queue->gdma_region = GDMA_INVALID_DMA_REGION;
 
-	umem = ib_umem_get_va(&mdev->ib_dev, addr, size, IB_ACCESS_LOCAL_WRITE);
+	if (is_cq)
+		umem = ib_umem_get_cq_buf_or_va(&mdev->ib_dev, NULL, addr,
+						size, IB_ACCESS_LOCAL_WRITE);
+	else
+		umem = ib_umem_get_va(&mdev->ib_dev, addr, size,
+				      IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(umem)) {
 		ibdev_dbg(&mdev->ib_dev, "Failed to get umem, %pe\n", umem);
 		return PTR_ERR(umem);
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 1be33ed8bd3b..fc71d0b7d57e 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -730,7 +730,7 @@ int mana_ib_gd_destroy_dma_region(struct mana_ib_dev *dev,
 int mana_ib_create_kernel_queue(struct mana_ib_dev *mdev, u32 size, enum gdma_queue_type type,
 				struct mana_ib_queue *queue);
 int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
-			 struct mana_ib_queue *queue);
+			 struct mana_ib_queue *queue, bool is_cq);
 void mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue);
 
 struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index fac43b3a5eb7..88e792cb0f85 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -340,7 +340,8 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	ibdev_dbg(&mdev->ib_dev, "ucmd sq_buf_addr 0x%llx port %u\n",
 		  ucmd.sq_buf_addr, ucmd.port);
 
-	err = mana_ib_create_queue(mdev, ucmd.sq_buf_addr, ucmd.sq_buf_size, &qp->raw_sq);
+	err = mana_ib_create_queue(mdev, ucmd.sq_buf_addr, ucmd.sq_buf_size, &qp->raw_sq,
+				   false);
 	if (err) {
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed to create queue for create qp-raw, err %d\n", err);
@@ -579,7 +580,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 			if (ucmd.comp_mask & MANA_IB_RC_MMQ_CREATE) {
 				flags &= ~MANA_RC_FLAG_NO_MMQ;
 				err = mana_ib_create_queue(mdev, ucmd.mmq_buf, ucmd.mmq_size,
-							   &qp->rc_qp.queues[i]);
+							   &qp->rc_qp.queues[i], false);
 				if (err)
 					goto destroy_queues;
 			} else {
@@ -589,7 +590,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 			continue;
 		}
 		err = mana_ib_create_queue(mdev, ucmd.queue_buf[j], ucmd.queue_size[j],
-					   &qp->rc_qp.queues[i]);
+					   &qp->rc_qp.queues[i], false);
 		if (err)
 			goto destroy_queues;
 		j++;
@@ -663,7 +664,7 @@ static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i) {
 		err = mana_ib_create_queue(mdev, ucmd.queue_buf[i], ucmd.queue_size[i],
-					   &qp->uc_qp.queues[i]);
+					   &qp->uc_qp.queues[i], false);
 		if (err)
 			goto destroy_queues;
 	}
diff --git a/drivers/infiniband/hw/mana/wq.c b/drivers/infiniband/hw/mana/wq.c
index 6b066d605dcb..4042f26632c0 100644
--- a/drivers/infiniband/hw/mana/wq.c
+++ b/drivers/infiniband/hw/mana/wq.c
@@ -25,7 +25,8 @@ struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
 
 	ibdev_dbg(&mdev->ib_dev, "ucmd wq_buf_addr 0x%llx\n", ucmd.wq_buf_addr);
 
-	err = mana_ib_create_queue(mdev, ucmd.wq_buf_addr, ucmd.wq_buf_size, &wq->queue);
+	err = mana_ib_create_queue(mdev, ucmd.wq_buf_addr, ucmd.wq_buf_size, &wq->queue,
+				   false);
 	if (err) {
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed to create queue for create wq, %d\n", err);
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 887912469742..74d1b07f9cc1 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -185,9 +185,10 @@ int mlx4_ib_create_user_cq(struct ib_cq *ibcq,
 			goto err_umem;
 		}
 	} else {
-		cq->umem = ib_umem_get_va(&dev->ib_dev, ucmd.buf_addr,
-					  entries * cqe_size,
-					  IB_ACCESS_LOCAL_WRITE);
+		cq->umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, NULL,
+						    ucmd.buf_addr,
+						    entries * cqe_size,
+						    IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(cq->umem)) {
 			err = PTR_ERR(cq->umem);
 			goto err_cq;
@@ -354,9 +355,10 @@ static int mlx4_alloc_resize_umem(struct mlx4_ib_dev *dev, struct mlx4_ib_cq *cq
 	if (!cq->resize_buf)
 		return -ENOMEM;
 
-	cq->resize_umem = ib_umem_get_va(&dev->ib_dev, ucmd.buf_addr,
-					 entries * cqe_size,
-					 IB_ACCESS_LOCAL_WRITE);
+	cq->resize_umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, NULL,
+						   ucmd.buf_addr,
+						   entries * cqe_size,
+						   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(cq->resize_umem)) {
 		err = PTR_ERR(cq->resize_umem);
 		goto err_buf;
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 49b4bf148a4a..ec4833c59c65 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1245,9 +1245,9 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	if (ucmd.cqe_size && SIZE_MAX / ucmd.cqe_size <= entries - 1)
 		return -EINVAL;
 
-	umem = ib_umem_get_va(&dev->ib_dev, ucmd.buf_addr,
-			      (size_t)ucmd.cqe_size * entries,
-			      IB_ACCESS_LOCAL_WRITE);
+	umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, NULL, ucmd.buf_addr,
+					(size_t)ucmd.cqe_size * entries,
+					IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(umem)) {
 		err = PTR_ERR(umem);
 		return err;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 012a0ab98d6b..4fecb90b1b8b 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -775,16 +775,23 @@ static inline int qedr_init_user_queue(struct ib_udata *udata,
 				       struct qedr_userq *q, u64 buf_addr,
 				       size_t buf_len, bool requires_db_rec,
 				       int access,
-				       int alloc_and_init)
+				       int alloc_and_init, bool is_cq)
 {
 	u32 fw_pages;
 	int rc;
 
 	q->buf_addr = buf_addr;
 	q->buf_len = buf_len;
-	q->umem = ib_umem_get_va(&dev->ibdev, q->buf_addr, q->buf_len, access);
+	if (is_cq)
+		q->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL,
+						   q->buf_addr, q->buf_len,
+						   access);
+	else
+		q->umem = ib_umem_get_va(&dev->ibdev, q->buf_addr, q->buf_len,
+					 access);
 	if (IS_ERR(q->umem)) {
-		DP_ERR(dev, "create user queue: failed ib_umem_get_va, got %ld\n",
+		DP_ERR(dev, "create user queue: failed %s, got %ld\n",
+		       is_cq ? "ib_umem_get_cq_buf_or_va" : "ib_umem_get_va",
 		       PTR_ERR(q->umem));
 		return PTR_ERR(q->umem);
 	}
@@ -946,7 +953,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 		rc = qedr_init_user_queue(udata, dev, &cq->q, ureq.addr,
 					  ureq.len, true, IB_ACCESS_LOCAL_WRITE,
-					  1);
+					  1, true);
 		if (rc)
 			goto err0;
 
@@ -1438,7 +1445,7 @@ static int qedr_init_srq_user_params(struct ib_udata *udata,
 	int rc;
 
 	rc = qedr_init_user_queue(udata, srq->dev, &srq->usrq, ureq->srq_addr,
-				  ureq->srq_len, false, access, 1);
+				  ureq->srq_len, false, access, 1, false);
 	if (rc)
 		return rc;
 
@@ -1831,7 +1838,8 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	if (qedr_qp_has_sq(qp)) {
 		/* SQ - read access only (0) */
 		rc = qedr_init_user_queue(udata, dev, &qp->usq, ureq.sq_addr,
-					  ureq.sq_len, true, 0, alloc_and_init);
+					  ureq.sq_len, true, 0, alloc_and_init,
+					  false);
 		if (rc)
 			return rc;
 	}
@@ -1839,7 +1847,8 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	if (qedr_qp_has_rq(qp)) {
 		/* RQ - read access only (0) */
 		rc = qedr_init_user_queue(udata, dev, &qp->urq, ureq.rq_addr,
-					  ureq.rq_len, true, 0, alloc_and_init);
+					  ureq.rq_len, true, 0, alloc_and_init,
+					  false);
 		if (rc) {
 			ib_umem_release(qp->usq.umem);
 			qp->usq.umem = NULL;
-- 
2.18.1


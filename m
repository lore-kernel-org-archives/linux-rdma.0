Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668554;
	b=bvKybQ6PkjctzldfBkgssKCcgziGGLtAcCKJA2DOpOFNQv5BVbQabV5baH+n/kWqQk/S
	 ZWWI5wXss88RHNCgdakCtw7seV3szkVZTkm1582N1kjA92ajMFCR/rNUBU4mXIz8Ghgjx
	 Kt1WAWmns+e6UvsdoAMiMtNE03fjvjmhBo34ksn+rdsD2BjGyBHEcCpYHXpsd6il/VLd5
	 3B//54LMd77TwRKKG1yQTRaWggJhYcZi9YRHxCSpv7lz6SUuCK9JlM/3Cfw5hkxcpjpcy
	 2bQmvmbshdGTL/q7TrRZoCb9sUkE+AXSSRmqYNAHpSTMMCWGrc032rmvuqiRnzR+JRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668554;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
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
	bh=AXJZ5rPsjYFVaHKzdTYuBt2Ki+JzVvCpy2Xr4jR5US0=;
	b=4PQ7mF+zDpcl+rvn7+iNZnf0CayfEn62idUMhp80JshSqD97VMaEuHbDjXttmCNw6BLb
	 FikGKY0KT9s8KRMrS8D0h1FBhc63T0GCMmajizEe8TVQvvfxQYSq4IKWgzQl6Bup4yO91
	 gCwR/QPK5YvV+o21/pYFEg7wpX1fbbbuFQ7EGeC+g0YDrG/MH1ampkWFsCcsvSZb6StTP
	 rdtN48wdzrjAGPvwR86qAjmFw3jF1H/4pLGugHWOGGuOGwjXkTegfEVgRvk/Oaeb+wlie
	 wfTOOO/diWHmdKh0VRB4hIi2fcfnyZWDYqGFw66R7OoSk8Xm/ndBWlhtekQ6bDNy6kA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LD0dBoTi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.59
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A7606A31C;
	Thu, 26 Nov 2026 04:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E55A7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LD0dBoTi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7shnr6KPX2pG6Ih1TmBWf8Xnr/DQE0Zz2CzFWucdPYO/m4eOpLh/nexf6XfaL7j6V/8ZIQeumhRvf3zKt9nsWVgkJ6H0APQcHK222Et09qIu5eh/UAkDNrqqf9EPwHJ7fT1ZW54v/US392chZFRZUEHAEVrR2coItWXJpjgNJFLSjFKXlhaYWNJxZqOoRevIx2yALt/lX9MaDPkDHyF+T9FOLFd70HLdcEFMNeswyDyzhVkF2bpQ0uoiyVn+gUeaACL3UzdAhfrQyVpCMld0TLeYbf+ibj5Itd3h7ODX1UpR8WIjZAuLJX3V6F5Yy6Mbm5MxU1nv6v5wkdQKrhixQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXJZ5rPsjYFVaHKzdTYuBt2Ki+JzVvCpy2Xr4jR5US0=;
 b=pd+FVPv78pJHtZpQfpuLmk00yUDc7ZDlBaaqf1FDeWCpZGpjM+JAGu2l2KhLHRPh7bNcNarLv58/Nk4dQF7TQZurERDp8dwEs7CJS9+RokhosCrtlZa2JKJRSRq1s/B+engYbNj2uO4y1eEDMOQHrecdNUDPq/TN1Q9sRT7l1ZQb59m/PpZEFswSfsK+Gi0wp5HB+UJBIoesUkhT5iygYpWL67V7u0E6O2hJFt7KgIAE2b7uuiwq0JWOc2j0knjprAPMy1G310Gvvxs6nmvLAgTXRbzV1bMy9PzDP7ljcwvf+WrqMYiRi2DkcaPJvETro942D6YgF5Jt9V32BiHJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXJZ5rPsjYFVaHKzdTYuBt2Ki+JzVvCpy2Xr4jR5US0=;
 b=LD0dBoTiSJwgwtUcFiop8vC88DmYh/QCN5vjfG8y5sNwgny6JJHkawPL/gyG/INS93dAnA7VWBlQTFlIRij1YLCnwQsYPvcuKUgjpq4wNGCg8vjXtRg+shOCVo57JtlldevufjLiz0oe7tqoZAa++q9iFmy5Ct0bpt30bALn56c=
Received: from DS1P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:44b::19) by
 CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 04:48:32 +0000
Received: from DS8PEPF000000DF.namprd05.prod.outlook.com
 (2603:10b6:8:44b:cafe::41) by DS1P222CA0026.outlook.office365.com
 (2603:10b6:8:44b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 04:48:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS8PEPF000000DF.mail.protection.outlook.com (10.167.23.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 04:48:32 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:31 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 22:48:29 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v2 3/3] RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes
Date: Thu, 26 Nov 2026 10:18:10 +0530
Message-ID: <20261126044811.3458258-4-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
References: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS8PEPF000000DF:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: aead8e65-d7c6-4476-2bdd-08df4b7885c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|56012099006|11063799006|10067099003|261026121527099003|261021121427099003|261021123027099003|261021135927099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bUb/OblwtiSmAwbha4ZfcrQGqvQKTeIhrCS/MNwLd3sIG6o9Xge8w+ADq63ZuvIhmJY8MmX0IiYMoa61DzGhaPdfjuIbDTihUVd5836OS8rufaBar71ma06VEyeQFIQbkYXPpxBMrIKwuHDjvju1FeEgV7bk/u7Taxd9mS/TymMgJTw0qn/FRkJIOx8OQlPtKPczRgw/1v9ZNSkvEhTwQRfSSDCgYhxbu4IPWMuwpumppQ5P8S7n7PAvYekVhSRySaCDe1G7slNS0lAhLWpQrnzj6BS9MeupZoeYiNnNM4e9H0CpL8q2q/A7l9yHVBWxbApeeCXmcNaTvR8CiipHjHJRXD3k7XrGq/cB/aLF4uqvWVB9djr+WrHAmyHSQrUJEbejvB8zuZf91Xb4bzQfgKvsFMsRdNr4WV0sQLPUN2QgI33fE1cnNQapRMzrBXollK4Gd00MOZsSqtaRXGD1rbWq2i3DGw6mT64lLvOqNNc2wENi6wiC8tDEe9h9CVDA/GFfMiXP8dQ9g7H6c7Dyt0TXMfTAzWwL5QAGckytlvMgBYlvjH8/JnB5Rq8BDDYUwysDUZp1Z2e2FiOU+01UoEo/ANmskuuMlJBPAJ9W8aVqI/WPtq0OFU1m8kDqNhbZZbw3HMsB+E67wmNPJVeDVrCh6pgREtD0LYHFF7VHUv0t4ys9lz8vz1LjAeKY9zMzjwHYPWZ6AMwyUlEGV5KAdQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(56012099006)(11063799006)(10067099003)(261026121527099003)(261021121427099003)(261021123027099003)(261021135927099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kGTAYyHzIm7Vi8FwzQ6E2lgovQIt+gO9TDjj/59Dx3Q0JetSfiTR/c680O36wJ9XIIApm6f3eJ/+1d3aCngdGxvZEagv+CN3uW79nS+7QwzfSWT1l/FRerDgCnP3y5xguMQEQEOCBuSZaG9XQ9FsPe7mpZgi0hZcHjMpiYUZZiQKTrp4HImtK1wnbhD1HDjefs1bUhnKboD3MfDZkJlp+0darpZbu+XYKod68eN3Cx6AEC2uu4hwvw9cZFR5EuGK7+kEYXQXphauWNIObHUt5UGwAf1tLIjAp0yIUVQWt9FIlF81Pm5GvCx4oX0G/Nrsbe7vqIsbcctGdWku27ttIkKCzeTxvmxDy6lNdxAARuEqlDFgXZe5U7Faw+4h4A+brOtsM78UTftpNCRcT9d+3ixrBkIe3qgs12ikn+M13wZhV/uow6cU2tIQrkXub5Jl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 04:48:32.1794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aead8e65-d7c6-4476-2bdd-08df4b7885c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS8PEPF000000DF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

Userspace passes each QP ring to create_qp as a
struct ib_uverbs_buffer_desc on the core attributes
UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM and
UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM. Those attributes are already
optional on UVERBS_METHOD_QP_CREATE. The get_context bit
IONIC_CTX_CMASK_CQ_QP_BUF_UMEM tells userspace it may send them.

ionic_get_user_q_umem() resolves one ring:

- No attribute: validate the qdesc address and pin it with
  ib_umem_get_va, as before.
- VA descriptor: length equals the qdesc size and the address matches
  the qdesc.
- DMABUF descriptor: the descriptor locates the ring, so qdesc.addr
  must be zero. Check queue geometry only and require a page-aligned
  dma-buf offset.

Any other descriptor is -EINVAL. The descriptor is copied from
userspace once, and that validated copy is pinned with
ib_umem_get_desc(), so the checks apply to the buffer that is pinned.

Access is 0, so the VA mapping direction stays DMA_TO_DEVICE. SRQ
creation passes no attribute bundle and keeps ib_umem_get_va. An SRQ
QP still only checks that the RQ qdesc is zero.

ionic_qp_req is not changed, so a provider that does not send the
attributes still creates a QP on the write path.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 81 +++++++++++++++----
 1 file changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index bb27e7700553..a197aff8fee5 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2009,10 +2009,60 @@ static void ionic_qp_sq_destroy_cmb(struct ionic_ibdev *dev,
 	ionic_put_cmb(dev->lif_cfg.lif, qp->sq_cmb_pgid, qp->sq_cmb_order);
 }
 
+static int ionic_get_user_q_umem(struct ionic_ibdev *dev, struct ionic_qdesc *q,
+				 const struct uverbs_attr_bundle *attrs,
+				 u16 attr_id, struct ib_umem **umem_out)
+{
+	struct ib_uverbs_buffer_desc desc;
+	struct ib_umem *umem;
+	int rc;
+
+	if (attrs && uverbs_attr_is_valid(attrs, attr_id)) {
+		rc = uverbs_get_buffer_desc(attrs, attr_id, &desc);
+		if (rc)
+			return rc;
+
+		if (desc.length != q->size)
+			return -EINVAL;
+
+		if (desc.type == IB_UVERBS_BUFFER_TYPE_DMABUF) {
+			/* The descriptor locates the ring, not the qdesc */
+			if (q->addr || !IS_ALIGNED(desc.addr, PAGE_SIZE))
+				return -EINVAL;
+
+			rc = ionic_validate_qdesc_geom(q);
+		} else if (desc.type == IB_UVERBS_BUFFER_TYPE_VA &&
+			   desc.addr == q->addr) {
+			rc = ionic_validate_qdesc(q);
+		} else {
+			rc = -EINVAL;
+		}
+		if (rc)
+			return rc;
+
+		/* Pin the copy that was checked; the attribute is user memory
+		 * and may have changed since.
+		 */
+		umem = ib_umem_get_desc(&dev->ibdev, &desc, 0);
+	} else {
+		rc = ionic_validate_qdesc(q);
+		if (rc)
+			return rc;
+
+		umem = ib_umem_get_va(&dev->ibdev, q->addr, q->size, 0);
+	}
+	if (IS_ERR(umem))
+		return PTR_ERR(umem);
+
+	*umem_out = umem;
+	return 0;
+}
+
 static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 			    struct ionic_qp *qp, struct ionic_qdesc *sq,
 			    struct ionic_tbl_buf *buf, int max_wr, int max_sge,
-			    int max_data, int sq_spec, struct ib_udata *udata)
+			    int max_data, int sq_spec, struct ib_udata *udata,
+			    const struct uverbs_attr_bundle *attrs)
 {
 	u32 wqe_size;
 	int rc = 0;
@@ -2056,7 +2106,9 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(sq);
+		rc = ionic_get_user_q_umem(dev, sq, attrs,
+					   UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+					   &qp->sq_umem);
 		if (rc)
 			return rc;
 
@@ -2070,10 +2122,6 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 
 		qp->sq_meta = NULL;
 		qp->sq_msn_idx = NULL;
-
-		qp->sq_umem = ib_umem_get_va(&dev->ibdev, sq->addr, sq->size, 0);
-		if (IS_ERR(qp->sq_umem))
-			return PTR_ERR(qp->sq_umem);
 	} else {
 		qp->sq_umem = NULL;
 
@@ -2276,7 +2324,8 @@ static void ionic_rq_destroy_cmb(struct ionic_ibdev *dev,
 static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 			 struct ionic_rq *rq, struct ionic_qdesc *qdesc,
 			 struct ionic_tbl_buf *buf, int max_wr, int max_sge,
-			 int rq_spec, struct ib_udata *udata)
+			 int rq_spec, struct ib_udata *udata,
+			 const struct uverbs_attr_bundle *attrs)
 {
 	u32 wqe_size;
 	int rc = 0;
@@ -2294,7 +2343,9 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(qdesc);
+		rc = ionic_get_user_q_umem(dev, qdesc, attrs,
+					   UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
+					   &rq->umem);
 		if (rc)
 			return rc;
 
@@ -2307,10 +2358,6 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		rq->q.stride_log2 = qdesc->stride_log2;
 
 		rq->meta = NULL;
-
-		rq->umem = ib_umem_get_va(&dev->ibdev, qdesc->addr, qdesc->size, 0);
-		if (IS_ERR(rq->umem))
-			return PTR_ERR(rq->umem);
 	} else {
 		rq->umem = NULL;
 
@@ -2396,6 +2443,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	struct ionic_qp *qp = to_ionic_qp(ibqp);
 	struct ionic_ctx *ctx =
 		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
+	const struct uverbs_attr_bundle *attrs = NULL;
 	struct ionic_qp_resp resp = {};
 	struct ionic_qp_req req = {};
 	struct ionic_cq *cq;
@@ -2404,6 +2452,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	int rc;
 
 	if (udata) {
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 		rc = ib_copy_validate_udata_in(udata, req, rsvd);
 		if (rc)
 			return rc;
@@ -2482,7 +2532,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	rc = ionic_qp_sq_init(dev, ctx, qp, &req.sq, &sq_buf,
 			      attr->cap.max_send_wr, attr->cap.max_send_sge,
-			      attr->cap.max_inline_data, req.sq_spec, udata);
+			      attr->cap.max_inline_data, req.sq_spec, udata,
+			      attrs);
 	if (rc)
 		goto err_sq;
 
@@ -2501,7 +2552,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		qp->rq.qid = qp->qpid;
 		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
 				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
-				   req.rq_spec, udata);
+				   req.rq_spec, udata, attrs);
 	}
 	if (rc)
 		goto err_rq;
@@ -3108,7 +3159,7 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
 
 	rc = ionic_rq_init(dev, ctx, &srq->rq, &req.rq, &buf,
 			   attr->attr.max_wr, attr->attr.max_sge,
-			   req.rq_spec, udata);
+			   req.rq_spec, udata, NULL);
 	if (rc)
 		return rc;
 
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668516;
	b=fqx3Qs1uzrlOtQHi1rp0ZNFZNa+94OCJBkRILQCtugUVJNq7Gryjn7I2wQgBHPIUFiiq
	 fgbS5bmlhTPtqQE02aCkWXW0UZxKYjXSXNWYnl2xH6R0T5LnMqrE6AQRUizY7/PM5xx8+
	 KL9qn4DAFOUI8g6n6lta5kAK9JRHND2dxUEst2OJtJZ01HoHo4uJQHRLF3RsTlmkbGhn5
	 e7oV1jeBJnwSDZDIJ+uKAMgCH630gY+wbCrkHyxUmSKbH1P3Li+XT/8QPoO/3TJdS50sl
	 23Umjq6uQUDNtFylGTlh5pMpn1u91aQG+/NxM2t2D/+nzUlRZQW0w2DH1iIlUd+xOOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668516;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=JdUVocIaPl0pjzhTKBSk2LGYry+/Fvjorh7O97BiCe8=;
	b=l/glI6kY4EDQNexdrbRZ9b+RWc9XeusBrPe1/GCEJlJIkgAb1zCwrfPLuZuWdHlNcQDg
	 EifyHbAZc1uN/9mHJ8OmwiGStV32iASbvwMICjNY4p+4l/Pvr1krlNN6BpIN+F+Om6Rmo
	 6V6i6XnQ+A+6vsP27hnApG7YNgIFgDK9n98z9l0SabGxSIQiBUJdgD9xxxmEakNMTOSX2
	 xp4wBlf60w1R0WbBtparDUM9F2aWnZYoaLY6sKPvbHq8oh2E7+9Bb5DB7rhT0mKkktIRj
	 wHzdFKLbSUcKANR2P0eVstYs7FZG+/n0535A/KoEFkH0bVPKJbHYeipiQyoIooyw81g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TTPtFigd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.31
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010031.outbound.protection.outlook.com [52.101.56.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F212B606A32C;
	Thu, 26 Nov 2026 04:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F212B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TTPtFigd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJTW/rRtflf+B7wFD3kMPHl3ZX51qxcxWuos2x5h3QFLznCh/kWOhoFs43pEqw3ejNLqlk3ZJLcEBndOz15V/DawGeNfxJAN1oVd4zOEkNrmCC6HGnDhwJXb+EjeQRkx89K/kUPohhH7nR9/Q4mxegLLxP6iUCUYjpb1zail7cwO+acJCwCMoFQyzQc7o4HWL7xBYL1BPqt8JgRAcX4ztcysJ6bTF5z0WltuMqhMlmZDBr8MnM0SHEMbXj6p1N050lc/Dr9xZqKjDsO121l7Y5BNayGYTTlHRUW8UCahPmDkybsYg4j6Kklan9c5mfeS50kTPiK0+XnmxIPMGhNa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdUVocIaPl0pjzhTKBSk2LGYry+/Fvjorh7O97BiCe8=;
 b=f9k0jNRORPsoRxocoHDvYP73ZSEiR+GShvNncUM0Nsw45EudYldzjZ8zttMygAE/wJsR0lwvdToX6ZZP5KRa64CZ82BAVOmejf5jM5FQysdGIPEyvAQdpmxWc9517GtuAT121+YBnE2GxqUneLyYt7uuasWfor5zuzTrWP7NyLMjDFQWz/q+Eib0P6rwWtbFdZShdz9qXfryc+jEC+g+zLkckqvWZIPaoKlgkOoZMP/s/0mmYqrTHRTkVDwcYTQbfwOraQvov3vvtXNElVmOWYSFIaxSPTg6C7XWrJDQJ+ziyFoaMfUpIdPo6Z4lMcxMeVL+vWgiSCvkgwkGdwT+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdUVocIaPl0pjzhTKBSk2LGYry+/Fvjorh7O97BiCe8=;
 b=TTPtFigdyAbOaTmctp+IEjmq4dvtWCrgiFwpI3eCATnzWfZsqETRKN9uYEsluY4WzBByjDYz9X3R+KlTXS0xC273sn5nYXeE12TiE0mSmXamn0tmeQa9fs9bjBSIzMCK07Hux+UcxLVQRtPFapml0wL55ShXlKrW1D1QDT/yGE0=
Received: from CH2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:610:50::25)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 04:48:30 +0000
Received: from DS8PEPF000000E1.namprd05.prod.outlook.com
 (2603:10b6:610:50:cafe::86) by CH2PR16CA0015.outlook.office365.com
 (2603:10b6:610:50::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 04:48:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS8PEPF000000E1.mail.protection.outlook.com (10.167.23.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 04:48:30 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:29 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:29 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 22:48:27 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v2 2/3] RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes
Date: Thu, 26 Nov 2026 10:18:09 +0530
Message-ID: <20261126044811.3458258-3-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS8PEPF000000E1:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: a7052fbb-2d41-418a-4aca-08df4b7884a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|261021121427099003|261102123227099003|10067099003|56012099006|11063799006|261022075727099003|261021135927099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qgGlEwS5ptXeFkQfe2AMsBSH0eIKw12hriU4umhBZo4k6s0ifuskeFUrov7WJoSlN5NXIVAbnivx53VnG+OziCvilQUkemcXLEl4dDlW4GnYZG1WD4LKNiUVHrJ103XAJVZBrkBade8SS/u2wS7muwEOHrJdedQHWqrg6Vd3cIy8vQQ+ACRDeDW+7O0UXiTTstLAtTHm/zD4FIsQ6JGPiq/98JWrT2ZeEJryxtAS5qqiU7ui72Tjc5sGFLmnxB2/LxdXsV5VapIYloBxfxI7XXL068AsAJ4PY57wP4J8W06alf7kEvsL8u4gwIk17mXpw+yw2ELR5v0ExIoXJCokldlUY+7S/a7B1K5tR0cjarjWuxJpLttlcZaZPhmQEGyyBvI9j5Y3MEX0n7Nwor64cilhHqoy3UH8xy7+7vr4+3Ptb5vLFaS62ZyhvONHfFbA1kWP3nQ8oQuHsg3b9LvipbevJwQyNpegkknqb0bdCY/qsAO4ovR0JRp+m6VSRYnk+wQ28v83drDNETbipfQSlDs9d3VmIcdWCt1EzQ2CxVopqbSvQbe/er4IESy3ksY8wAnS2lwLvsDfWPMfKnA3bqKclEitr/sMf40zmLv2pXgnSCQK8qyiCgYtDB7Uc8srshDPPVopj7fFkp+J5o2MXoq7faZtXRVdhiGRJn7ZcpU/EjF+d+5D4KzZpiiw6adRW6smWrwPgKcNoNskvQwYsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(261021121427099003)(261102123227099003)(10067099003)(56012099006)(11063799006)(261022075727099003)(261021135927099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xrglDK9Y3BfP+KyL2pISMMMEdQmF+sWmAjM/T5Eg97GvYDmPldLBci5ciUgV5t1GyhKs7TRW/UeQ9WQ13DAcMVgaeIaz3olbsP913eonwt/zq9u1Idk3KeKY/1mJlsgz1blHYnNC7vOkLgPz5MTsOvroNW9NoF1wGnRKsSgSfanNqLq6YCbVbuWEpFvfwqmv51SOj8nRWcjQ6zs3MEu/dLB2Am5K6EU8twlOOU3ov9v+5Ve85dctjxhixUaEStE0sKrFyyTWcmNk0oCKfXAfccmX2WtuVEZv5+ACl4Yf1AOlI494SIs4YMNgMmTsWOdkmSM54npEiNdnMmppV4NSTPiVik4TipSbdMJNT7mPjNAdfBgu7eKZyIajw850gn+FSZm20tai8p+CgxSu4Wk9dXLilizRP7GWziLeCHCu2FMPJLO8eUAFrSSX7DKwbadE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 04:48:30.2719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7052fbb-2d41-418a-4aca-08df4b7884a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS8PEPF000000E1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536

Userspace can now pass each enabled CQ ring to create_cq as a
struct ib_uverbs_buffer_desc in a per-UDMA driver attribute, instead
of only as a raw address in ionic_cq_req.

Advertise support with IONIC_CTX_CMASK_CQ_QP_BUF_UMEM in the get_context
response. Register two optional UVERBS_ATTR_UMEM attributes,
IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0 and _1, on UVERBS_METHOD_CQ_CREATE
through ibdev->driver_def.

For each UDMA index in udma_mask, ionic_cq_get_user_umem() validates
the qdesc and resolves the ring buffer:

- No attribute: pin req_cq->addr as before, with DMA_FROM_DEVICE.
- VA descriptor: desc.addr must equal req_cq->addr; pin as before.
- DMABUF descriptor: the descriptor locates the ring, so req_cq->addr
  must be zero. desc.addr is a page-aligned dma-buf offset; pin
  req_cq->size bytes from desc.fd at that offset.

A dma-buf ring has no qdesc address, so split the queue geometry checks
out of ionic_validate_qdesc() into ionic_validate_qdesc_geom() and
apply only those to a DMABUF descriptor. The other two cases keep the
address check.

An attribute for a UDMA index that is not in udma_mask, or any other
buffer type, is rejected with -EINVAL. The kernel admin CQ path passes
no attribute bundle and is unchanged.

ionic_cq_req and ionic_cq_resp are not changed, so older providers
continue to use the write command path.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c     |   2 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 116 +++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  17 +++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |   2 +
 include/uapi/rdma/ionic-abi.h                 |   1 +
 include/uapi/rdma/ionic_user_ioctl_cmds.h     |  15 +++
 6 files changed, 132 insertions(+), 21 deletions(-)
 create mode 100644 include/uapi/rdma/ionic_user_ioctl_cmds.h

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index 0ccd869ad8e6..67ce56acb4dc 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -575,7 +575,7 @@ static struct ionic_vcq *ionic_create_rdma_admincq(struct ionic_ibdev *dev,
 	vcq->udma_mask = 1;
 	cq = &vcq->cq[0];
 
-	rc = ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL,
+	rc = ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL, NULL,
 				    NULL, 0);
 	if (rc)
 		goto err_init;
diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 8a304d576852..bb27e7700553 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -14,13 +14,9 @@
 #define ionic_set_ecn(tos)   (((tos) | 2u) & ~1u)
 #define ionic_clear_ecn(tos)  ((tos) & ~3u)
 
-static int ionic_validate_qdesc(struct ionic_qdesc *q)
+static int ionic_validate_qdesc_geom(const struct ionic_qdesc *q)
 {
-	if (!q->addr || !q->size || !q->mask ||
-	    !q->depth_log2 || !q->stride_log2)
-		return -EINVAL;
-
-	if (q->addr & (PAGE_SIZE - 1))
+	if (!q->size || !q->mask || !q->depth_log2 || !q->stride_log2)
 		return -EINVAL;
 
 	/* Keep the shift counts below within the width of their types */
@@ -39,6 +35,14 @@ static int ionic_validate_qdesc(struct ionic_qdesc *q)
 	return 0;
 }
 
+static int ionic_validate_qdesc(const struct ionic_qdesc *q)
+{
+	if (!q->addr || !IS_ALIGNED(q->addr, PAGE_SIZE))
+		return -EINVAL;
+
+	return ionic_validate_qdesc_geom(q);
+}
+
 static u32 ionic_get_eqid(struct ionic_ibdev *dev, u32 comp_vector, u8 udma_idx)
 {
 	/* EQ per vector per udma, and the first eqs reserved for async events.
@@ -80,11 +84,79 @@ static void ionic_put_cqid(struct ionic_ibdev *dev, u32 cqid)
 	ionic_resid_put(&dev->inuse_cqid, bitid);
 }
 
+static const u16 ionic_cq_buf_attrs[] = {
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0,
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1,
+};
+
+static int ionic_cq_get_user_umem(struct ionic_ibdev *dev, struct ionic_cq *cq,
+				  const struct ionic_qdesc *req_cq,
+				  const struct uverbs_attr_bundle *attrs,
+				  int udma_idx)
+{
+	struct ib_umem_dmabuf *umem_dmabuf;
+	struct ib_uverbs_buffer_desc desc;
+	struct ib_umem *umem;
+	u16 attr_id;
+	int rc;
+
+	if (udma_idx < 0 || udma_idx >= ARRAY_SIZE(ionic_cq_buf_attrs))
+		return -EINVAL;
+
+	attr_id = ionic_cq_buf_attrs[udma_idx];
+	if (attrs && uverbs_attr_is_valid(attrs, attr_id)) {
+		rc = uverbs_get_buffer_desc(attrs, attr_id, &desc);
+		if (rc)
+			return rc;
+
+		if (desc.length < req_cq->size)
+			return -EINVAL;
+
+		if (desc.type == IB_UVERBS_BUFFER_TYPE_DMABUF) {
+			/* The descriptor locates the ring, not the qdesc */
+			if (req_cq->addr || !IS_ALIGNED(desc.addr, PAGE_SIZE))
+				return -EINVAL;
+
+			rc = ionic_validate_qdesc_geom(req_cq);
+			if (rc)
+				return rc;
+
+			umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ibdev,
+								desc.addr,
+								req_cq->size,
+								desc.fd,
+								IB_ACCESS_LOCAL_WRITE);
+			if (IS_ERR(umem_dmabuf))
+				return PTR_ERR(umem_dmabuf);
+
+			cq->umem = &umem_dmabuf->umem;
+			return 0;
+		}
+
+		if (desc.type != IB_UVERBS_BUFFER_TYPE_VA ||
+		    desc.addr != req_cq->addr)
+			return -EINVAL;
+	}
+
+	rc = ionic_validate_qdesc(req_cq);
+	if (rc)
+		return rc;
+
+	umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL, req_cq->addr,
+					req_cq->size, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem))
+		return PTR_ERR(umem);
+
+	cq->umem = umem;
+	return 0;
+}
+
 int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   struct ionic_tbl_buf *buf,
 			   const struct ib_cq_init_attr *attr,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
+			   const struct uverbs_attr_bundle *attrs,
 			   struct ionic_qdesc *req_cq,
 			   int udma_idx)
 {
@@ -113,18 +185,10 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 	INIT_LIST_HEAD(&cq->flush_rq);
 
 	if (udata) {
-		rc = ionic_validate_qdesc(req_cq);
+		rc = ionic_cq_get_user_umem(dev, cq, req_cq, attrs, udma_idx);
 		if (rc)
 			goto err_qdesc;
 
-		cq->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL,
-						    req_cq->addr, req_cq->size,
-						    IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(cq->umem)) {
-			rc = PTR_ERR(cq->umem);
-			goto err_qdesc;
-		}
-
 		cq->q.ptr = NULL;
 		cq->q.size = req_cq->size;
 		cq->q.mask = req_cq->mask;
@@ -435,7 +499,8 @@ int ionic_alloc_ucontext(struct ib_ucontext *ibctx, struct ib_udata *udata)
 	resp.udma_count = dev->lif_cfg.udma_count;
 	resp.expdb_mask = dev->lif_cfg.expdb_mask;
 	resp.rcq_sign_bit = dev->lif_cfg.rcq_sign_bit;
-	resp.comp_mask |= IONIC_CTX_CMASK_IONIC_FLAGS;
+	resp.comp_mask |= IONIC_CTX_CMASK_IONIC_FLAGS |
+			  IONIC_CTX_CMASK_CQ_QP_BUF_UMEM;
 
 	if (dev->lif_cfg.sq_expdb)
 		resp.expdb_qtypes |= IONIC_EXPDB_SQ;
@@ -1369,13 +1434,24 @@ int ionic_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		goto err_init;
 	}
 
-	for (; udma_idx < dev->lif_cfg.udma_count; ++udma_idx) {
+	for (udma_idx = 0; udma_idx < ARRAY_SIZE(ionic_cq_buf_attrs);
+	     udma_idx++) {
+		if (vcq->udma_mask & BIT(udma_idx))
+			continue;
+
+		if (uverbs_attr_is_valid(attrs, ionic_cq_buf_attrs[udma_idx])) {
+			rc = -EINVAL;
+			udma_idx = 0;
+			goto err_init;
+		}
+	}
+
+	for (udma_idx = 0; udma_idx < dev->lif_cfg.udma_count; ++udma_idx) {
 		if (!(vcq->udma_mask & BIT(udma_idx)))
 			continue;
 
-		rc = ionic_create_cq_common(vcq, &buf, attr, ctx, udata,
-					    &req.cq[udma_idx],
-					    udma_idx);
+		rc = ionic_create_cq_common(vcq, &buf, attr, ctx, udata, attrs,
+					    &req.cq[udma_idx], udma_idx);
 		if (rc)
 			goto err_init;
 
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index b4d4544bb7ac..e64c8e891f30 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -11,6 +11,9 @@
 
 #include "ionic_ibdev.h"
 
+#define UVERBS_MODULE_NAME ionic_rdma
+#include <rdma/uverbs_named_ioctl.h>
+
 #define DRIVER_DESCRIPTION "AMD Pensando RoCE HCA driver"
 #define DEVICE_DESCRIPTION "AMD Pensando RoCE HCA"
 
@@ -217,6 +220,18 @@ static void ionic_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 */
 }
 
+ADD_UVERBS_ATTRIBUTES_SIMPLE(
+	ionic_cq_create,
+	UVERBS_OBJECT_CQ,
+	UVERBS_METHOD_CQ_CREATE,
+	UVERBS_ATTR_UMEM(IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0, UA_OPTIONAL),
+	UVERBS_ATTR_UMEM(IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1, UA_OPTIONAL));
+
+static const struct uapi_definition ionic_uapi_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_CQ, &ionic_cq_create),
+	{},
+};
+
 static const struct ib_device_ops ionic_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_IONIC,
@@ -376,6 +391,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	ionic_stats_init(dev);
 
+	ibdev->driver_def = ionic_uapi_defs;
+
 	rc = ib_register_device(ibdev, "ionic_%d", ibdev->dev.parent);
 	if (rc)
 		goto err_register;
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 127b79cdfc45..b25fe2f6c4b1 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -10,6 +10,7 @@
 #include <rdma/uverbs_ioctl.h>
 
 #include <rdma/ionic-abi.h>
+#include <rdma/ionic_user_ioctl_cmds.h>
 #include <ionic_api.h>
 #include <ionic_regs.h>
 
@@ -491,6 +492,7 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   const struct ib_cq_init_attr *attr,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
+			   const struct uverbs_attr_bundle *attrs,
 			   struct ionic_qdesc *req_cq,
 			   int udma_idx);
 int ionic_post_create_cq_cmd(struct ionic_cq *cq,
diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
index ac48fcd19a4f..f503552bf23a 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -24,6 +24,7 @@
 
 enum ionic_ctx_resp_comp_mask {
 	IONIC_CTX_CMASK_IONIC_FLAGS = 1 << 0,
+	IONIC_CTX_CMASK_CQ_QP_BUF_UMEM = 1 << 1,
 };
 
 struct ionic_ctx_req {
diff --git a/include/uapi/rdma/ionic_user_ioctl_cmds.h b/include/uapi/rdma/ionic_user_ioctl_cmds.h
new file mode 100644
index 000000000000..98bb8d7238e6
--- /dev/null
+++ b/include/uapi/rdma/ionic_user_ioctl_cmds.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (C) 2026, Advanced Micro Devices, Inc */
+
+#ifndef IONIC_USER_IOCTL_CMDS_H
+#define IONIC_USER_IOCTL_CMDS_H
+
+#include <linux/types.h>
+#include <rdma/ib_user_ioctl_cmds.h>
+
+enum ionic_ib_create_cq_attrs {
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_0 = UVERBS_ID_DRIVER_NS_WITH_UHW,
+	IONIC_IB_ATTR_CREATE_CQ_BUF_UMEM_1,
+};
+
+#endif
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795015415;
	b=X3kjXuT3HQFwbFxxMuOHtFQdV5644UJcI8rcy5LFPvvewz+ee+D5Mwtf4do7DvJgsEST
	 1sboKEoHKxf8rg4RmXuovblpX+RcC0ntBSvfH8fr40Xo31+3h0cUqxfU95+d5DV0FO2Gd
	 nYc5RUhniZjjD3lzeT+KbclbZzT8/mlAHnRJpcf1OOdRQ5DmjETEKgZez+5aA36ECHg0g
	 Lri1SghCQimNFO6X9ZcqvOMM6e7Y2QVAUQzdF/whVM4gva9MVDvNVNgEb3esbzAKmDBt1
	 dgKsMy4I1s08zuuXo4ilDojUve9HZ1lZiikAtnLWLVFjNvv5iHXZb8VAK1WtRYLkVSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015415;
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
	bh=6IFDaLKXh/5Q5C5rJ7nprQti3MkdNGqfgqMvJaBZ+vk=;
	b=HVxDN9Oi0E1GZuQ4tuywCryZMS+5AMRmRn2lEAaPPx3m71y3PbzcI2xAdfLyOvrdwsN2
	 miJFzLyjHyRgbQydSUWytIjyQz7WEckOy4HOhqAgFlu0/OwRLbK1GZ9O2xJKPaysi/FD2
	 LW9C854FDNvRN7MlCIVWC15PWr3HFwGyQGX+/YxIYSa72OQAudjt4pZyCA+Y2weNKMwpN
	 ymRMIfozNKY8xDqU5nsRPhRkX+R6at4jw10bmp/bVjg1uw0f74xXM2BSowccBA3aY2iOG
	 bctraAua1bJqRBn+opD0xkDrIaIB+vqdQlMwaFWwIUa0PGzSl5Wri4qwMxxkxh/SObw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=no+S0o0E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.58
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011058.outbound.protection.outlook.com [52.101.52.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13570606A320;
	Wed, 18 Nov 2026 15:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13570606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=no+S0o0E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ug3YN5J6GFd5lXBbkDhi31CNiyd2PwhPriUJSseod4DdtQJ152zalYsQsxQODaZNpWUrcs+GC6fRNkDMt6Sw0AT5HXtRY1tj3ZTluEJ3xc6M9em3aUd+y+QPBuaYVZ4Kgmjq38U4yIFXI33pnWIKR07+oBYzSBQIIyRDNrbIzlEYsui0INzQ+Gvm/NJu3g+Wc5Pf/qrX/ZwsvBkFyiylcxE0e4mNdSoCJVD2h4JOBA3tpC9Wkz4Pfj9GRGkkRJhzk0VHZj6afWKOOVJVUYc+1ZKP5EIAU+dhSPOI4ky+y8+ehcSH4yJSOpLQWVCvmkN4LDN/rcqAYW9dJBcADvMi3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IFDaLKXh/5Q5C5rJ7nprQti3MkdNGqfgqMvJaBZ+vk=;
 b=ldgO0yCqfFpiV+R9dWYnK78Ztcsgcf1xSaidcQ4+FnZGnfEXk2tU4qr8p8oMX0CMhv466V1ApZbm+l+0KXsZblQ0VrXzHyOa+3ny+cE/gJWuEtBg9mDi8lyPvBYyU5ckLNK/Jx/HwCOC2AvvBr7U86DkySLnNpC85nv6+YVBLkSClWgiNExrdZN6Fn6ZmGDaZJdcYRUiz2tbqCKZOt5++D61gmxP/5FekImQnGLq923E1LHYjdyuXRiNPVV/ZWAtCtwXhN3Fxm3tzOfk7W1TT45aUf6M5x+EyRV8XFfZgmohaZqLGADjKBVBMgqJwwtUtnXKGO+y5uT381uDat5fOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IFDaLKXh/5Q5C5rJ7nprQti3MkdNGqfgqMvJaBZ+vk=;
 b=no+S0o0EGPHgWaZeyqMQjcMtRc3VckC+AS/3Q5lLZj3xLdiBQA54oBOY28aWE8dlIqYQ/W4cnDnFyCUkFWxOBFHKWcL/Fv/9KiwT522XDlCdZZnilsLyAt4sFVbJbVzgYLuQJYKigzv7MlqZfl0rw1t2tzLW8oVpOauFpIzcvog=
Received: from PH8PR21CA0005.namprd21.prod.outlook.com (2603:10b6:510:2ce::21)
 by SA1PR12MB8163.namprd12.prod.outlook.com (2603:10b6:806:332::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 15:23:29 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:510:2ce:cafe::97) by PH8PR21CA0005.outlook.office365.com
 (2603:10b6:510:2ce::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.1 via Frontend Transport; Wed, 18
 Nov 2026 15:23:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 15:23:28 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:23:27 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:23:26 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:23:24 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v1 2/2] RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes
Date: Wed, 18 Nov 2026 20:53:13 +0530
Message-ID: <20261118152313.113714-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118152313.113714-1-abhijit.gangurde@amd.com>
References: <20261118152313.113714-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|SA1PR12MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df16cf1-2861-46c6-036f-08df4587e5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|23010399003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261026121527099003|261021121427099003|261021135927099003|261021123027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	U2Axuqrs4So6Ar75SVR0AgjWv63+Dfi8PDOO4SWhN9sv8KOneXxyBLk7mQi/M5S7D5uuGHLypOr4aGIgNOjjMEM8QE9jJPpM6aqeT+p8q0lQ2uL3J1RfcsSifZ2MsNTtJYXgyb3dZwnuiQWEErJmX10+N3W5Vi2E5sih9K0bVWdjfo79/eR/O/bY4OLvwZkuL3ppjqL6vuFjiepa/6euZ6WNqmTFEzkTUzm8zWp2nf2/p9fBI+QBslhX170zw/eCddokCWXmfBwhxLW85O3HAsydBQgF8RagAEbVGALk4ZhXdwlkjs7BnwIhhmhUHn8Apq5b7YfQ0/P+YgCeTwPHdwHhMNW3pq3LwyjS7cboWVXa2W3dde7us/W4vPBGjLotEv9KZGCjtpA6lMTgjuwA8cXUOnrbM+UC2J5DsSBdbQZD05tIUPiqLY2nS21WAnOGgephuwj9CCGB6Wrza6KmGNrAXUZC0kPW/cQFVikoWsQO4T5NUKKAcmQoYJUoHRf0rUPm224GKhmm/8MrjFJw4HKJiagSLOb80N7FKWqIaRj3eSKI/B9vTZ0Q35MoSaZP/QfNcgpzsgf9YuVQW0QHXQktGmiqoC8eRVFGSq7gxWImdim5VhTXwjyhZaalcqKS2zxQlNTr+9xF2J6F6ROhk6qQYJvvU2F1qe/oVKxmCIRDrHbmU1TFS/vnsrlesu8e+r1q1eqKbkxdoD/PMqaBPw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(23010399003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261021135927099003)(261021123027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bercxbb09m7NCwsvpdIiDfvqZqdQEkBzC7JS6QD6gans/LheUDxZ9MbxIur4f9fxHUnS17WC8q1h5UrWQCo5bSQPpBvtZSWKYt5PjdQ8KJ09ygx/pz4rZcNu/Shpg9A/IivNf4nqFmZHwCbLomzn+KIcczhcr4q1B7FolKsV1CBHVxVtS30R1u8hAf5Nvw9FQMDZy8THMGZ6XCpBLadj3GLOl7wkVdEa7mGw9Y9UJ+pkMhMfMGKnj2+h9BK5XuzDqknFknFT4dRtaTu4feQ5k0lzKpAnVw6PCm4D0y7/w/VEfzeT2SLepQaRtdsXFNmmX9K21p2wbtJLOZ7hQl+i9UWWmzLiXveLJXtrzOfdwYhyR09Aw5sFgvjJdRYzUNFBVtnI64j4IdP1QIJsP1tVOAQFVnVNg74JsMpdrVvLR/XA1JGmqGOxqD5m/wkrWVMZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 15:23:28.9590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df16cf1-2861-46c6-036f-08df4587e5f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8163

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
  the qdesc; pin through ib_umem_get_attr_or_va.
- DMABUF descriptor: qdesc.addr is zero. Check queue geometry only,
  require a page-aligned dma-buf offset, and pin through
  ib_umem_get_attr_or_va.

Any other descriptor is -EINVAL. Access is 0, so the VA mapping
direction stays DMA_TO_DEVICE. SRQ creation passes no attribute
bundle and keeps ib_umem_get_va. An SRQ QP still only checks that
the RQ qdesc is zero.

ionic_qp_req is not changed, so a provider that does not send the
attributes still creates a QP on the write path.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 94 ++++++++++++++-----
 1 file changed, 73 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 11458262f280..02f1972126ed 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -14,13 +14,9 @@
 #define ionic_set_ecn(tos)   (((tos) | 2u) & ~1u)
 #define ionic_clear_ecn(tos)  ((tos) & ~3u)
 
-static int ionic_validate_qdesc(struct ionic_qdesc *q)
+static int ionic_validate_qdesc_geom(struct ionic_qdesc *q)
 {
-	if (!q->addr || !q->size || !q->mask ||
-	    !q->depth_log2 || !q->stride_log2)
-		return -EINVAL;
-
-	if (q->addr & (PAGE_SIZE - 1))
+	if (!q->size || !q->mask || !q->depth_log2 || !q->stride_log2)
 		return -EINVAL;
 
 	if (q->mask != BIT(q->depth_log2) - 1)
@@ -32,6 +28,14 @@ static int ionic_validate_qdesc(struct ionic_qdesc *q)
 	return 0;
 }
 
+static int ionic_validate_qdesc(struct ionic_qdesc *q)
+{
+	if (!q->addr || (q->addr & (PAGE_SIZE - 1)))
+		return -EINVAL;
+
+	return ionic_validate_qdesc_geom(q);
+}
+
 static u32 ionic_get_eqid(struct ionic_ibdev *dev, u32 comp_vector, u8 udma_idx)
 {
 	/* EQ per vector per udma, and the first eqs reserved for async events.
@@ -1993,10 +1997,57 @@ static void ionic_qp_sq_destroy_cmb(struct ionic_ibdev *dev,
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
+			if (desc.addr & (PAGE_SIZE - 1))
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
+		umem = ib_umem_get_attr_or_va(&dev->ibdev, attrs, attr_id,
+					      q->addr, q->size, 0);
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
@@ -2040,7 +2091,9 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(sq);
+		rc = ionic_get_user_q_umem(dev, sq, attrs,
+					   UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+					   &qp->sq_umem);
 		if (rc)
 			return rc;
 
@@ -2054,10 +2107,6 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 
 		qp->sq_meta = NULL;
 		qp->sq_msn_idx = NULL;
-
-		qp->sq_umem = ib_umem_get_va(&dev->ibdev, sq->addr, sq->size, 0);
-		if (IS_ERR(qp->sq_umem))
-			return PTR_ERR(qp->sq_umem);
 	} else {
 		qp->sq_umem = NULL;
 
@@ -2260,7 +2309,8 @@ static void ionic_rq_destroy_cmb(struct ionic_ibdev *dev,
 static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 			 struct ionic_rq *rq, struct ionic_qdesc *qdesc,
 			 struct ionic_tbl_buf *buf, int max_wr, int max_sge,
-			 int rq_spec, struct ib_udata *udata)
+			 int rq_spec, struct ib_udata *udata,
+			 const struct uverbs_attr_bundle *attrs)
 {
 	u32 wqe_size;
 	int rc = 0;
@@ -2278,7 +2328,9 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(qdesc);
+		rc = ionic_get_user_q_umem(dev, qdesc, attrs,
+					   UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
+					   &rq->umem);
 		if (rc)
 			return rc;
 
@@ -2291,10 +2343,6 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		rq->q.stride_log2 = qdesc->stride_log2;
 
 		rq->meta = NULL;
-
-		rq->umem = ib_umem_get_va(&dev->ibdev, qdesc->addr, qdesc->size, 0);
-		if (IS_ERR(rq->umem))
-			return PTR_ERR(rq->umem);
 	} else {
 		rq->umem = NULL;
 
@@ -2380,6 +2428,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	struct ionic_qp *qp = to_ionic_qp(ibqp);
 	struct ionic_ctx *ctx =
 		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
+	const struct uverbs_attr_bundle *attrs = NULL;
 	struct ionic_qp_resp resp = {};
 	struct ionic_qp_req req = {};
 	struct ionic_cq *cq;
@@ -2388,6 +2437,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	int rc;
 
 	if (udata) {
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 		rc = ib_copy_validate_udata_in(udata, req, rsvd);
 		if (rc)
 			return rc;
@@ -2466,7 +2517,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	rc = ionic_qp_sq_init(dev, ctx, qp, &req.sq, &sq_buf,
 			      attr->cap.max_send_wr, attr->cap.max_send_sge,
-			      attr->cap.max_inline_data, req.sq_spec, udata);
+			      attr->cap.max_inline_data, req.sq_spec, udata,
+			      attrs);
 	if (rc)
 		goto err_sq;
 
@@ -2485,7 +2537,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		qp->rq.qid = qp->qpid;
 		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
 				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
-				   req.rq_spec, udata);
+				   req.rq_spec, udata, attrs);
 	}
 	if (rc)
 		goto err_rq;
@@ -3092,7 +3144,7 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
 
 	rc = ionic_rq_init(dev, ctx, &srq->rq, &req.rq, &buf,
 			   attr->attr.max_wr, attr->attr.max_sge,
-			   req.rq_spec, udata);
+			   req.rq_spec, udata, NULL);
 	if (rc)
 		return rc;
 
-- 
2.43.0


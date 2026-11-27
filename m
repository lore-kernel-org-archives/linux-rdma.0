Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795752541;
	b=4eSOOxkFcC/nM54RzucNSHe9fW4zEv6O87Gt1QGD64z6hh0FGFWwsmOhdWPgzcuw22a5
	 moeL9naMMmXmclWNZg+up+OEy8eJa0MF0m7/bDx6G1q1IRT+mgY+vs166vTAbHg50rrRK
	 Um6HNCEcFMo7upLZef6NFJhZ3cs6tiUePGTaOvKRKGlfj4ZsJSD3JpdhQmZJPpIpU+lOg
	 wqiANuVLPvJPojbfaIpmsE/XgiCk+rzzV1Te7CyO0M3lp/12datnVK3TU3OeeurC9oRLV
	 8+xLTxWbRK0HmGGl331gSTE19ltzQ7rYbTbzFrW4S1k9AV6NL8QuHkB64jBbeJr05Kw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752541;
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
	bh=c0Q57YfrFdrvn+Tms9ZV7SeWMGFz67M1jj7rUoVoqec=;
	b=Z8v2IBU/9ftuSFDjTr1G894eMoQoJvRHMoTDZrCJk6SgYBXFs1skDLuHJUaveefC8h9J
	 n0v8Y6IXbRyMey4LCyhqDG7/qvmELvwalsxiaTIWRVVv79qWW3pz5aUGe+RUmNvebnOaz
	 al9j5263vXFJWobCu/YBHsJ9RP7AmfQV2j7R9z7EIRYSFT5Z0hKtfKdeSTpfLDxmtrFjk
	 17fML6UoOvUy/Do/BGnim9pAr8TE0EA0x7u/pdwSi3TqiIoWDhmzity3neEvxTX+sODu0
	 aFnc4gIAiw8F4gCrTHG2BDKLOLyFswoTdjrbjE7yx/t9Hk9yKOeOct3ukViub8joKuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=k4ASRvnd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.37
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49BE606A324;
	Fri, 27 Nov 2026 04:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A49BE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=k4ASRvnd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxGE/aDsvGfUl13tPAAFymZXS0/D0R1+mPQ3alevVgSG6yG7Caavbavf9PhkiHmRnxbVgTutgo2MEDj11MxeMjjtkpFIQ2FjXQamrtW9J3bQbtmzpQdXJgJWOWtT6fnzyDgQFcncTLpItCpcN9zcb1ezWJaNwvKx7m2dKwePU87C8Le95sv/xtpOPl5pkI52a5XB5LHq4BOnjx3Au1eVVbz+bN72Sj/o3lqoiybRid0j7/43VfXHL0UU+J4jkYs7rNTGc7JVXgSOjobwdfJQ0GSwbRrYXyZwn3S7ikGRsQIyw+xuG1YtGcNlMu/kUNbb1VOzjvZiGnyRApqsZGawZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0Q57YfrFdrvn+Tms9ZV7SeWMGFz67M1jj7rUoVoqec=;
 b=jZo0CQR8YIzDirz9cFN+SJManMkWvp2HJnncTzrFrADbfA5yO+aampl4FXcdXIj5Rh7K7yrkudMSMOMI7Af2fjmO2Hw4/65iCS/GbPiBDvq7F2CslWr2CWdB+ztak7Kuu643vom59Cu7TbGlJfhn5xqQSrX/vqDI/4subtnGHMHXs700SSF9wEOkmfkxDfeXYO6pubLxBny9SsAHJzqbyhc3Q3f93ZKolIp2hU3uAg0wuK5EQArJvJkHezEaoidM2L6Eb8VQBSRnFyadwZZ2cezhq+2hAj+kpDr6Vbj6LTprqsXEdMCfPgwblHAP5tWwfdHEzcYEWpLwB1nPjl+UMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0Q57YfrFdrvn+Tms9ZV7SeWMGFz67M1jj7rUoVoqec=;
 b=k4ASRvnd6+QHXVoIdLs8QPjYgnoj7cAa2p0UffWKwp0rN0mIAwPSJ+MyhGfPnaCxVMdUg1XEJPTdxYrUDtmSNc2xRf/WYMqcj+z4ENZT2PCvNQtM33i87jgasJOqci9G0VfD6pjh2af2M/1ZMd2KTOgJFNk4vAxOWGrbdzb2V50=
Received: from CH0PR04CA0114.namprd04.prod.outlook.com (2603:10b6:610:75::29)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 04:08:52 +0000
Received: from DS2PEPF00007107.namprd05.prod.outlook.com
 (2603:10b6:610:75:cafe::69) by CH0PR04CA0114.outlook.office365.com
 (2603:10b6:610:75::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.9 via Frontend Transport; Fri, 27
 Nov 2026 04:08:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00007107.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:08:51 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:08:51 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:08:49 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v3 3/3] RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes
Date: Fri, 27 Nov 2026 09:38:32 +0530
Message-ID: <20261127040832.16908-4-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127040832.16908-1-abhijit.gangurde@amd.com>
References: <20261127040832.16908-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00007107:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ccff1c5-47d3-48aa-c327-08df4c3c2549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|10067099003|56012099006|261021121427099003|261026121527099003|261021135927099003|261021123027099003|261102123227099003|22082099003|18002099003|11063799006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	I+SvMpvbrhJnUps6w2P0l1tQWFGf+iBe5f/wJOH1Kc/GWEsdNvfaOArtdupzil19ASuMyiOaEz8BNRZEmOHc8OqCU0prVzEoCjArfLKAD68/iM1rCcIuJcZ5RHJ4gc64FwXCRpnZ8M3dhLvCKkIjpdO/cN8xGAAR2OvXXCfccoy2NLcXdoQKMbxps1aydkefJ0srLxGb2n84We29/wrxyycxIbWFN/2mHdf0aGMGLFaD7m75/ljjO0HsVL7BY8J+Fs/uJj5oKkrlBSmyMMEwSwCeypbGtXdZzedfUctiGtZ3fYlEOktY+XpHIv5ipXj2GsP6PYak7udf8sBC55UQKEXkNhFENFhddfcS5rKPE6UxEapTtgFnfubtgc7w4M1CHqK427GSdHJlOqUSlcOq3Qbzq0pXWOwMVVMAHubxyrkHZ3lrZW/j8BDphEjiyKEnMEio7NK/xSnnNUnlXUZJkV3OIbccURayJFba8gYLN4pNYSJTmWGDV4pYqj5yehFnkYbJ13cKV9AKkpDfpJiSDbvG8/JTLbT+xdmtH3b5cHJstpPd7hUULaqa7Kw2d+EfwTap3+LVxc/ZyW1JQrBGkrls4qc5oF3Vvxkp3Sd2lSQOfd8ayI/KcHg4Zz3RTa27Aue3TLy+KW9XEReuRrUW7MFvna9oI4Cy82RnaP4OZDUbgjpPnWfEvDtgpLkET1e64Iaj4YBno0lMvSDCEGx9uQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(10067099003)(56012099006)(261021121427099003)(261026121527099003)(261021135927099003)(261021123027099003)(261102123227099003)(22082099003)(18002099003)(11063799006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3viMBelGb9Gi0gDgnZKYWdP/gHQaW4O/yiW4T4enT2T/E4ZKLuCGrNB1cPH8oL/30TzCW18DEpz1pJOTckbdOhvnwU2baY5LBvAe9ARXuFb/FHpcNMS+SQk8UjsCrtBKm5LlbniDlYj8BCzRbSUW+TreK2wwLh0SDPu3GaQUEZg3uxB1PBq996nknxwQs8Qt7qTmYPKUZQkQlpO5NrOOwyKOdrk3qMpPOp7rEmd/pqeATNgRPn+id/EqNOZAyXvas/qhwbpbG9Z/zNM2x0exwn7Ps/IvcG41A5ucq1jhP1lv+ClY3PPI7wKkPIn68dMo3eo2Nj6WqyUEgjkLUO+4fe7xHzb3YUYGQfpBwMl5vQ9Djl9r6/yXh6lrjAdiwIKBqMw999A7kF0OyUfCzqlKQb2usnAiyt2Zo8PVAJcMXjXSvbtqt5kWL7mFLbdH7g43
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:08:51.6774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccff1c5-47d3-48aa-c327-08df4c3c2549
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00007107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874

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
index 7438a8182e46..14d63aa26999 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2039,10 +2039,60 @@ static void ionic_qp_sq_destroy_cmb(struct ionic_ibdev *dev,
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
@@ -2086,7 +2136,9 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(sq);
+		rc = ionic_get_user_q_umem(dev, sq, attrs,
+					   UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+					   &qp->sq_umem);
 		if (rc)
 			return rc;
 
@@ -2100,10 +2152,6 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 
 		qp->sq_meta = NULL;
 		qp->sq_msn_idx = NULL;
-
-		qp->sq_umem = ib_umem_get_va(&dev->ibdev, sq->addr, sq->size, 0);
-		if (IS_ERR(qp->sq_umem))
-			return PTR_ERR(qp->sq_umem);
 	} else {
 		qp->sq_umem = NULL;
 
@@ -2305,7 +2353,8 @@ static void ionic_rq_destroy_cmb(struct ionic_ibdev *dev,
 static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 			 struct ionic_rq *rq, struct ionic_qdesc *qdesc,
 			 struct ionic_tbl_buf *buf, int max_wr, int max_sge,
-			 int rq_spec, struct ib_udata *udata)
+			 int rq_spec, struct ib_udata *udata,
+			 const struct uverbs_attr_bundle *attrs)
 {
 	u32 wqe_size;
 	int rc = 0;
@@ -2323,7 +2372,9 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(qdesc);
+		rc = ionic_get_user_q_umem(dev, qdesc, attrs,
+					   UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
+					   &rq->umem);
 		if (rc)
 			return rc;
 
@@ -2336,10 +2387,6 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		rq->q.stride_log2 = qdesc->stride_log2;
 
 		rq->meta = NULL;
-
-		rq->umem = ib_umem_get_va(&dev->ibdev, qdesc->addr, qdesc->size, 0);
-		if (IS_ERR(rq->umem))
-			return PTR_ERR(rq->umem);
 	} else {
 		rq->umem = NULL;
 
@@ -2425,6 +2472,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	struct ionic_qp *qp = to_ionic_qp(ibqp);
 	struct ionic_ctx *ctx =
 		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
+	const struct uverbs_attr_bundle *attrs = NULL;
 	struct ionic_qp_resp resp = {};
 	struct ionic_qp_req req = {};
 	struct ionic_cq *cq;
@@ -2433,6 +2481,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	int rc;
 
 	if (udata) {
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 		rc = ib_copy_validate_udata_in(udata, req, rsvd);
 		if (rc)
 			return rc;
@@ -2511,7 +2561,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	rc = ionic_qp_sq_init(dev, ctx, qp, &req.sq, &sq_buf,
 			      attr->cap.max_send_wr, attr->cap.max_send_sge,
-			      attr->cap.max_inline_data, req.sq_spec, udata);
+			      attr->cap.max_inline_data, req.sq_spec, udata,
+			      attrs);
 	if (rc)
 		goto err_sq;
 
@@ -2530,7 +2581,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		qp->rq.qid = qp->qpid;
 		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
 				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
-				   req.rq_spec, udata);
+				   req.rq_spec, udata, attrs);
 	}
 	if (rc)
 		goto err_rq;
@@ -3137,7 +3188,7 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
 
 	rc = ionic_rq_init(dev, ctx, &srq->rq, &req.rq, &buf,
 			   attr->attr.max_wr, attr->attr.max_sge,
-			   req.rq_spec, udata);
+			   req.rq_spec, udata, NULL);
 	if (rc)
 		return rc;
 
-- 
2.43.0


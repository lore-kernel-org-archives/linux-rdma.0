Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5A6497B96;
	Thu, 15 Oct 2026 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068682; cv=none; b=Rffp23Bm17gUw+0m+ue43f64UKNq1eERDfcmIZ5NxmKq38rYx5NLpPZ/AcMwU9w2W90cozYBPF5wCEfl0+DLdMto60TrPOgXlLA43+J1cPhomlcKlGFR8eV4zdajPke5VEWBh4wmt4i5vFIuvCkEwv6wK301O5Cpq5lvRHdHZdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068682; c=relaxed/simple;
	bh=Vm3iRqkKrNPwPnR7wRlpZK/VTV0M8vg1Z/WnL4NmG4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeR62/ZcvNlDFFtpPIPvYUUVkACYlrk7CxXblhjtppAB2sun2bLXetRMhZQHtl92TpSDNEINvDjaGqOj51Rg9A+eBmE7oGSnoX1NdLoVZuCCj4QPGHOhvnpeA37w+ekMyADmNbbfmzEcWruIDhSnPhwfAD5R4eKigBNKgUEf40o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=LD6B5RpV; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="LD6B5RpV"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 6D20011C74;
	Thu, 15 Oct 2026 15:51:19 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=Rs5WrghBVaC8yPDhDCq+
	TGuRHJdSTH9tyryW/qhN7gg=; b=LD6B5RpVPmJhW2QMdq59/jCn1Pq3DC7s1XRj
	lg6rFmmDpS8uFUGUgrSwPZI0Zpq6upFapjgn7B/invKLn4zSMPFsLT1rcJybFgvW
	OXQyaJV3GGQm7WKgxlr1YSHIe9UT26Z84MucMNWb/ff99dcoWx4gXw79J0X2/gyU
	Dznb2KCUn34zxzgys7kT/lnjTf8sKWmvS85GQ1tle9AIyQA2uc9+WTK+lQ6wgbve
	zarYsjtJeVRLBOdkPtirQW+b1lGDlmKyKD4pNftTHvkxtE3Tnv5WU0R0t59RH1G5
	/uv4qwrFH45dxXsjpXmY0PFQDl38T1kM2TE7rA6v/buWI82MZQ==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id E8F5811BFE;
	Thu, 15 Oct 2026 15:51:18 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 15:51:18 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, Bart Van
 Assche <bvanassche@acm.org>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack
 Wang <jinpu.wang@ionos.com>, <linux-rdma@vger.kernel.org>
CC: Andrei-Alexandru Bleortu <me@andrei-z.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 1/3] IB/iser: Post header-only PDUs inline
Date: Thu, 15 Oct 2026 15:51:16 +0300
Message-ID: <20261015125118.2966247-2-me@andrei-z.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015125118.2966247-1-me@andrei-z.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

iser_post_send() posts every PDU by reference, and the QP asks for no
inline data. Before the HCA can send a SCSI command it therefore has
to DMA-read the 76 bytes of iSER and iSCSI headers from host memory,
and that read is on the latency path of every command.

Ask for ISER_HEADERS_LEN bytes of inline data when creating the QP,
and create the QP without inline data if the device refuses. Post a
PDU without a data segment with IB_SEND_INLINE when it fits in the
inline size the device granted. PDUs with a data segment are posted
by reference as before.

Providers copy inline data from sg_list[].addr as a kernel virtual
address. The inline path therefore points tx_sg[0] at the headers'
virtual address, and the by-reference path now sets it to the DMA
address on every post. The mapping is still synced and unmapped through
tx_desc->dma_addr.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |  2 ++
 drivers/infiniband/ulp/iser/iser_verbs.c | 29 ++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 1d7ac24c4c00..ebd994d425a3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -362,6 +362,7 @@ struct iser_fr_pool {
  * @device:              reference to iser device
  * @fr_pool:             connection fast registration pool
  * @pi_support:          Indicate device T10-PI support
+ * @max_inline_data:     inline data size granted to the QP
  * @reg_cqe:             completion handler
  */
 struct ib_conn {
@@ -372,6 +373,7 @@ struct ib_conn {
 	struct iser_device          *device;
 	struct iser_fr_pool          fr_pool;
 	bool			     pi_support;
+	u32			     max_inline_data;
 	struct ib_cqe		     reg_cqe;
 };
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ab2a27d23478..6319d7fd17cf 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -230,7 +230,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
 	struct iser_device	*device;
 	struct ib_device	*ib_dev;
-	struct ib_qp_init_attr	init_attr;
+	struct ib_qp_init_attr	init_attr, attr;
 	int			ret = -ENOMEM;
 	unsigned int max_send_wr, cq_size;
 
@@ -271,11 +271,23 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 		init_attr.create_flags |= IB_QP_CREATE_INTEGRITY_EN;
 	iser_conn->max_cmds = ISER_GET_MAX_XMIT_CMDS(max_send_wr - 1);
 
-	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
+	/*
+	 * Ask for enough inline data to post the iSER and iSCSI headers
+	 * inline (see iser_post_send()).  If the device cannot provide it,
+	 * create the QP without inline data.
+	 */
+	attr = init_attr;
+	attr.cap.max_inline_data = ISER_HEADERS_LEN;
+	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &attr);
+	if (ret) {
+		attr = init_attr;
+		ret = rdma_create_qp(ib_conn->cma_id, device->pd, &attr);
+	}
 	if (ret)
 		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
+	ib_conn->max_inline_data = attr.cap.max_inline_data;
 	iser_info("setting conn %p cma_id %p qp %p max_send_wr %d\n", ib_conn,
 		  ib_conn->cma_id, ib_conn->cma_id->qp, max_send_wr);
 	return ret;
@@ -870,6 +882,19 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 	wr->opcode = IB_WR_SEND;
 	wr->send_flags = IB_SEND_SIGNALED;
 
+	/*
+	 * Post a header-only PDU inline if it fits in the granted inline
+	 * size, so the HCA does not have to DMA-read it from host memory.
+	 * The CPU copies inline data from a kernel virtual address, so point
+	 * the SGE at the headers.
+	 */
+	tx_desc->tx_sg[0].addr = tx_desc->dma_addr;
+	if (tx_desc->num_sge == 1 &&
+	    tx_desc->tx_sg[0].length <= ib_conn->max_inline_data) {
+		tx_desc->tx_sg[0].addr = (uintptr_t)&tx_desc->iser_header;
+		wr->send_flags |= IB_SEND_INLINE;
+	}
+
 	if (tx_desc->inv_wr.next)
 		first_wr = &tx_desc->inv_wr;
 	else if (tx_desc->reg_wr.wr.next)
-- 
2.56.0



Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C796F5038E8;
	Thu, 15 Oct 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068684; cv=none; b=ltPZYA3FFzQHSOIf1NazN0Db4LcDIGoiITZb/eqOytrCASSdFmfAnaOzHETylxkE4BKuUI8jOB0GCo41135Jhbx+DFJge1bJtzAkMbXR/hGaOI2WYuMZpDb+UxjfgcvgipsPrRS+GndUMU6yY09To1GOEyjuc150UQPOlVto9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068684; c=relaxed/simple;
	bh=Hok8IYh2hUr15CKnSYNR/eX3ixGPr6/mHgtOFU8ZpRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYHCq7fL+s5cs6lgBvOUT0la8FfyyqxxalEDTdwDZ1HZztWIroCTWlRah76tbXUgNjDu4naWeB0SNmJ+hjvJccfEjnqkrWm49C0VZWkP9BtvZLbhC4ps0Z59r9gRDWH6ym7MJrqE3lyENVpJznFHmntlQyWYARtsLMfIdNwLH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=jdVW7Cm/; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="jdVW7Cm/"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 018CF21A84;
	Thu, 15 Oct 2026 15:51:21 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=wRpEnCnzQ7K4SgQuxvHE
	YcH5E8zGzMsm22KjnhjBopg=; b=jdVW7Cm/hxdHWKbkl74CLPMRj2c5PfnuaafC
	AtiYxJdaq3V/CF6umEt9m41nFAmZ7Iqn5XTnfctY9QJlSKmzZo06S1xDpN/VU/8a
	bVKipZuBeO6gvNJLDMeHjZ6YMsLv2AokRf4ExEnQ4KuM+WWhRXfylydoRCNKNM1m
	w8meRNxa18EG65Fg601fu9wRvIo1b1PPJ6Rh0Zzp3fkjJ8NTGWFFh7sNFWkiSmm7
	0V7fH1ejcE+Ta8J06BKhtz6+Qdjk8/0Fc6RDBx8ZfECZM84Ox7F/+3TayEZCKeDz
	yTa53E1uvdKwIxbwsi24t727AKEdqGp6fydQ9ycm49eIL4Plmw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 737D221B05;
	Thu, 15 Oct 2026 15:51:19 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 15:51:19 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, Bart Van
 Assche <bvanassche@acm.org>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack
 Wang <jinpu.wang@ionos.com>, <linux-rdma@vger.kernel.org>
CC: Andrei-Alexandru Bleortu <me@andrei-z.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 3/3] RDMA/rtrs: Post client read requests inline
Date: Thu, 15 Oct 2026 15:51:18 +0300
Message-ID: <20261015125118.2966247-4-me@andrei-z.com>
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

The RTRS client sends a read request as an RDMA Write with Immediate of
a small message: the user message, the RTRS header and one memory
descriptor, about 60 bytes for RNBD. The message is posted by reference
and the QP asks for no inline data, so the HCA has to DMA-read it from
host memory before sending. That read is on the latency path of every
read.

Let rtrs_cq_qp_create() take the amount of inline data to ask for.
The client asks for RTRS_CLT_MAX_INLINE_DATA, enough for a read
request with one descriptor and up to 64 bytes of user message, and
the server asks for none. If the device refuses, the QP is created
without inline data. The client posts a read request with
IB_SEND_INLINE when it fits in the inline size the device granted.
Write requests, whose message travels behind the data in the same
WR, are not changed.

Providers copy inline data from sg_list[].addr as a kernel virtual
address, so the inline path puts req->iu->buf in the on-stack SGE.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 17 +++++++++++++++--
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 10 +++++++++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs.c     | 22 +++++++++++++++++-----
 4 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index bf3a0377da3f..4a552e0459b2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -489,6 +489,17 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 				      req->iu->dma_addr,
 				      req->sg_size, DMA_TO_DEVICE);
 
+	/*
+	 * Post the request inline if it fits in the granted inline size, so
+	 * the HCA does not have to DMA-read it from host memory.  The CPU
+	 * copies inline data from a kernel virtual address, so put
+	 * req->iu->buf in the SGE.
+	 */
+	if (req->sg_size <= con->c.max_inline_data) {
+		sge.addr = (uintptr_t)req->iu->buf;
+		flags |= IB_SEND_INLINE;
+	}
+
 	return rtrs_iu_post_rdma_write_imm(&con->c, req->iu, &sge, 1,
 					    rbuf->rkey, rbuf->addr + off,
 					    imm, flags, wr, NULL);
@@ -1714,11 +1725,13 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 	if (con->c.cid >= clt_path->s.irq_con_num)
 		err = rtrs_cq_qp_create(&clt_path->s, &con->c, max_send_sge,
 					cq_vector, cq_num, max_send_wr,
-					max_recv_wr, IB_POLL_DIRECT);
+					max_recv_wr, RTRS_CLT_MAX_INLINE_DATA,
+					IB_POLL_DIRECT);
 	else
 		err = rtrs_cq_qp_create(&clt_path->s, &con->c, max_send_sge,
 					cq_vector, cq_num, max_send_wr,
-					max_recv_wr, IB_POLL_SOFTIRQ);
+					max_recv_wr, RTRS_CLT_MAX_INLINE_DATA,
+					IB_POLL_SOFTIRQ);
 	/*
 	 * In case of error we do not bother to clean previous allocations,
 	 * since destroy_con_cq_qp() must be called.
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 59529d593869..bcba80d3c214 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -97,6 +97,7 @@ struct rtrs_con {
 	int                     nr_cqe;
 	atomic_t		wr_cnt;
 	atomic_t		sq_wr_avail;
+	u32			max_inline_data;
 };
 
 struct rtrs_path {
@@ -286,6 +287,13 @@ struct rtrs_msg_rdma_read {
 	struct rtrs_sg_desc    desc[];
 };
 
+/*
+ * Inline data the client asks for on its QPs: enough for a read request
+ * with one memory descriptor and a user message of up to 64 bytes.
+ */
+#define RTRS_CLT_MAX_INLINE_DATA (sizeof(struct rtrs_msg_rdma_read) + \
+				  sizeof(struct rtrs_sg_desc) + 64)
+
 /**
  * struct rtrs_msg_rdma_write - Message transferred to server with RDMA-Write
  * @type:		always @RTRS_MSG_WRITE
@@ -325,7 +333,7 @@ int rtrs_post_recv_empty(struct rtrs_con *con, struct ib_cqe *cqe);
 int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
 		      u32 max_send_sge, int cq_vector, int nr_cqe,
 		      u32 max_send_wr, u32 max_recv_wr,
-		      enum ib_poll_context poll_ctx);
+		      u32 max_inline_data, enum ib_poll_context poll_ctx);
 void rtrs_cq_qp_destroy(struct rtrs_con *con);
 
 void rtrs_init_hb(struct rtrs_path *path, struct ib_cqe *cqe,
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 5314599d29fe..30fa4c7f64dc 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1759,7 +1759,7 @@ static int create_con(struct rtrs_srv_path *srv_path,
 
 	/* TODO: SOFTIRQ can be faster, but be careful with softirq context */
 	err = rtrs_cq_qp_create(&srv_path->s, &con->c, 1, cq_vector, cq_num,
-				 max_send_wr, max_recv_wr,
+				 max_send_wr, max_recv_wr, 0,
 				 IB_POLL_WORKQUEUE);
 	if (err) {
 		rtrs_err(s, "rtrs_cq_qp_create(), err: %pe\n", ERR_PTR(err));
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index a642626e0ecb..08b8b1abb1d3 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -253,9 +253,10 @@ static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 }
 
 static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
-		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
+		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge,
+		     u32 max_inline_data)
 {
-	struct ib_qp_init_attr init_attr = {};
+	struct ib_qp_init_attr init_attr = {}, attr;
 	struct rdma_cm_id *cm_id = con->cm_id;
 	int ret;
 
@@ -271,13 +272,24 @@ static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 	init_attr.recv_cq = con->cq;
 	init_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 
-	ret = rdma_create_qp(cm_id, pd, &init_attr);
+	/*
+	 * If the device cannot provide the requested inline data, create the
+	 * QP without it.
+	 */
+	attr = init_attr;
+	attr.cap.max_inline_data = max_inline_data;
+	ret = rdma_create_qp(cm_id, pd, &attr);
+	if (ret && max_inline_data) {
+		attr = init_attr;
+		ret = rdma_create_qp(cm_id, pd, &attr);
+	}
 	if (ret) {
 		rtrs_err(con->path, "Creating QP failed, err: %pe\n",
 			 ERR_PTR(ret));
 		return ret;
 	}
 	con->qp = cm_id->qp;
+	con->max_inline_data = attr.cap.max_inline_data;
 
 	return ret;
 }
@@ -296,7 +308,7 @@ static void destroy_cq(struct rtrs_con *con)
 int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
 		       u32 max_send_sge, int cq_vector, int nr_cqe,
 		       u32 max_send_wr, u32 max_recv_wr,
-		       enum ib_poll_context poll_ctx)
+		       u32 max_inline_data, enum ib_poll_context poll_ctx)
 {
 	int err;
 
@@ -305,7 +317,7 @@ int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
 		return err;
 
 	err = create_qp(con, path->dev->ib_pd, max_send_wr, max_recv_wr,
-			max_send_sge);
+			max_send_sge, max_inline_data);
 	if (err) {
 		destroy_cq(con);
 		return err;
-- 
2.56.0



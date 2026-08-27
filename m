Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C508447D920;
	Thu, 27 Aug 2026 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841498; cv=none; b=q3fnYh+aQPLcuh24M42PfZvlMmAl35cPcIiBU62/Ky+p6EwiN82I+NaG4r9kGAoKYhDw3n4LJUYXQIolzwDvnfpyQZvtnVrt3fBiH/9RbQVycXUY1rZO7vkAuDabWGCP6C35HXozXfc/7OqpcCL8aZ5KE5RGzl50zKmkh9Lh9dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841498; c=relaxed/simple;
	bh=DNcUsC4frMri/5zOYTJa2QEgpJjJ52EexLoD2ilgcO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXvtSrlbMgmGSgWlnh1Erwmrvm79+mlPxj/6vaeF1v7rS5NYxIO6/Cz1YXGsQeutcs9p9xIn7M35itTFqngx/kH+KU02Yovl7ztpFgYmBvH0wb1SuJTTllgC0V2YsacNyEwyqOFz+OeX5JmuMfEUcU/J10xmbF4ttqzOQg/plis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cXPwFIBv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cXPwFIBv"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id A118C20B7168; Thu, 27 Aug 2026 07:37:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A118C20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787841456;
	bh=yzQ/bLJpGIBRN2IoX/veAFxwm5xHoRpPqeAb4sd1cPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXPwFIBvVfxarNTKC8kWVyb3NJDBw6GSeIIPcmeNqmTjtQ/dq2/AyBA9AuJ49wvjG
	 e0iz1nlnBGSU6uC9nkVTBVHrdjE9eFvw4snllgiNepk6AG061j4pxbZjMBGqLj0nJA
	 xBPsaI4h3gWzqBCrzILbr1c4F+7KTdkjRAboJBOE=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 1/3] RDMA/mana_ib: Extend RC QP udata request and response
Date: Thu, 27 Aug 2026 07:37:34 -0700
Message-ID: <20260827143736.2013093-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Extend the RC QP creation UAPI to support optional fixed-size WQEs and an
MMQ. Add a compatibility mask to the request, return the MMQ ID in the
response, and advertise the extended ABI through ucontext capabilities.

Use compatibility-aware udata validation so existing userspace remains
supported. Rename the legacy FMR queue definitions to MMQ and add the
corresponding hardware creation flags.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v1->v2: use << instead of BIT() in the mana-abi.h
 drivers/infiniband/hw/mana/main.c    |  1 +
 drivers/infiniband/hw/mana/mana_ib.h |  6 ++++--
 drivers/infiniband/hw/mana/qp.c      | 10 +++++-----
 include/uapi/rdma/mana-abi.h         | 11 +++++++++++
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index e4414d208..9d043f48e 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -247,6 +247,7 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 
 	ucontext->doorbell = doorbell_page;
 	ucmd_resp.comp_mask = MANA_IB_UCNTX_ALLOC_PDN_SUPPORT;
+	ucmd_resp.comp_mask |= MANA_IB_UCNTX_RC_EXT_SUPPORT;
 	ret = ib_respond_udata(udata, ucmd_resp);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index f69866696..547ddf9dd 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -172,7 +172,7 @@ struct mana_ib_cq {
 enum mana_rc_queue_type {
 	MANA_RC_SEND_QUEUE_REQUESTER = 0,
 	MANA_RC_SEND_QUEUE_RESPONDER,
-	MANA_RC_SEND_QUEUE_FMR,
+	MANA_RC_SEND_QUEUE_MMQ,
 	MANA_RC_RECV_QUEUE_REQUESTER,
 	MANA_RC_RECV_QUEUE_RESPONDER,
 	MANA_RC_QUEUE_TYPE_MAX,
@@ -372,7 +372,9 @@ struct mana_rnic_destroy_cq_resp {
 }; /* HW Data */
 
 enum mana_rnic_create_rc_flags {
-	MANA_RC_FLAG_NO_FMR = 2,
+	MANA_RC_FLAG_NO_MMQ = BIT(1),
+	MANA_RC_FLAG_FIXED_SIZE_WQE = BIT(3),
+	MANA_RC_FLAG_MSN_IN_WQE = BIT(4),
 };
 
 struct mana_rnic_create_qp_req {
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 8b7be1255..aa5f8c607 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -549,14 +549,14 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	mana_ucontext = rdma_udata_to_drv_context(udata, struct mana_ib_ucontext, ibucontext);
 	doorbell = mana_ucontext->doorbell;
-	flags = MANA_RC_FLAG_NO_FMR;
-	err = ib_copy_validate_udata_in(udata, ucmd, queue_size);
+	flags = MANA_RC_FLAG_NO_MMQ;
+	err = ib_copy_validate_udata_in_cm(udata, ucmd, queue_size,
+					   MANA_IB_RC_QP_FIXED_WQE | MANA_IB_RC_MMQ_CREATE);
 	if (err)
 		return err;
 
 	for (i = 0, j = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
-		/* skip FMR for user-level RC QPs */
-		if (i == MANA_RC_SEND_QUEUE_FMR) {
+		if (i == MANA_RC_SEND_QUEUE_MMQ) {
 			qp->rc_qp.queues[i].id = INVALID_QUEUE_ID;
 			qp->rc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
 			continue;
@@ -580,7 +580,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	if (udata) {
 		for (i = 0, j = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
-			if (i == MANA_RC_SEND_QUEUE_FMR)
+			if (i == MANA_RC_SEND_QUEUE_MMQ)
 				continue;
 			resp.queue_id[j] = qp->rc_qp.queues[i].id;
 			j++;
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index 32cbbfc80..c9a241766 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -48,13 +48,23 @@ struct mana_ib_create_qp_resp {
 	__u32 reserved;
 };
 
+enum mana_ib_create_rc_qp_flags {
+	MANA_IB_RC_QP_FIXED_WQE = 1 << 0,
+	MANA_IB_RC_MMQ_CREATE = 1 << 1,
+};
+
 struct mana_ib_create_rc_qp {
 	__aligned_u64 queue_buf[4];
 	__u32 queue_size[4];
+	__aligned_u64 mmq_buf;
+	__u32 mmq_size;
+	__u32 comp_mask;
 };
 
 struct mana_ib_create_rc_qp_resp {
 	__u32 queue_id[4];
+	__u32 mmq_id;
+	__u32 reserved;
 };
 
 struct mana_ib_create_uc_qp {
@@ -100,6 +110,7 @@ struct mana_ib_create_qp_rss_resp {
 
 enum mana_ib_ucontext_support {
 	MANA_IB_UCNTX_ALLOC_PDN_SUPPORT = 1 << 0,
+	MANA_IB_UCNTX_RC_EXT_SUPPORT = 1 << 1,
 };
 
 struct mana_ib_alloc_ucontext_resp {
-- 
2.43.0


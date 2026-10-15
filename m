Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80948AE1B;
	Thu, 15 Oct 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068683; cv=none; b=U9504l11ZCkATTH0LDEa45dY29qtqA67WzOHCGmqMUn1j+G4tIRNyFEecJ+FOH9ImrJFoh1iuwN1sgUI+hmDA3iFEUTmeYJsoCDR6YGGeiwMAvGrPntyKQy+NGG/4Z6Wx6oRtz+dziAVjqIvwAe4Q/R7W3E3L0WMqicaAgXg8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068683; c=relaxed/simple;
	bh=zeUQLJ3WdWW/+kkj9r9MQJeuHYkUD9DQByY/WBzlR8U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uto7paRp+oHjEcFAHWyKdxVCQpkyKuVyFKUyzz3WZVRC7yPb1aFX18OrO/337Qa1bJsInJWMmZp+CZzBhRC7jWPmZfudQWtwZM56xnW+LJBzkTdCPmaxrP3jyAzqBEeABV6Hdx+DQBJuZVWMuXDOvf+zNDdRq01Nzr0Oua5CV1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=fOaJxA2D; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="fOaJxA2D"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id BB2792143B;
	Thu, 15 Oct 2026 15:51:20 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=ZHjGt8XoH9E/ek9eDaPx
	iNoSQh0iuiLQX+ZTGJUll6I=; b=fOaJxA2DyjixVsxdranVpaHCi1inhv+0k8QB
	kry0LTBiFyy7Hsuc+kf2L24ocZZMTVMzByhz+hHeF9Ch8YaaKCazuD6WAozjWIeJ
	JU44zsBwp26Z/V4f257681ZaWWDKS9j/NP0/NkK3CJd+rH6gslVzItuFeLwnsUQz
	ihnrsuhZJZRmN0sRegcbIqWN3VgQWUHwHcyGUA3yiTF3RKacK9ZgXMEzpvAZxwMJ
	z6jztD3CLzwT+qMI0yxzEYV1QxbkearPevdcU3c13PJQ9mCZh9t3zJFnAVfCHPgm
	MHlmFLjMi5k+iMn70WvDjeqYGR2/J+wNVt2vxIY2Jn7vwovj5A==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 46E50211F5;
	Thu, 15 Oct 2026 15:51:19 +0300 (EEST)
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
Subject: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
Date: Thu, 15 Oct 2026 15:51:17 +0300
Message-ID: <20261015125118.2966247-3-me@andrei-z.com>
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

srp_post_send() posts every information unit by reference, and the QP
asks for no inline data. Before the HCA can send an SRP_CMD it
therefore has to DMA-read the IU from host memory, and that read is
on the latency path of every command.

Ask for SRP_MAX_INLINE_DATA bytes of inline data when creating the QP,
enough for an SRP_CMD with an additional CDB and an indirect table of
two descriptors (116 bytes). If the device refuses, ask for less. Intel
irdma has a fixed limit of 216, 101 or 48 bytes, depending on the
generation, and Alibaba erdma one of 96. On those devices, found by
vendor ID, try these limits first, then step down 16 bytes at a time to
none. libfabric's verbs provider also probes the inline limit by trial
QP creation. The RDMA/CM and IB/CM QP creation paths move into
srp_create_qp() so the retries cover both. Post an IU without immediate
data with IB_SEND_INLINE when it fits in the inline size the device
granted.

Providers copy inline data from sg_list[].addr as a kernel virtual
address, so the inline path points iu->sge[0] at iu->buf.
srp_post_send() resets it to iu->dma on every post, and iu->dma keeps
the mapping.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 102 ++++++++++++++++++++++++----
 drivers/infiniband/ulp/srp/ib_srp.h |   9 +++
 2 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 955f36efeebd..caac6960bc1d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -43,6 +43,7 @@
 #include <linux/jiffies.h>
 #include <linux/lockdep.h>
 #include <linux/inet.h>
+#include <linux/pci_ids.h>
 #include <net/net_namespace.h>
 #include <rdma/ib_cache.h>
 
@@ -522,6 +523,66 @@ static void srp_destroy_qp(struct srp_rdma_ch *ch)
 	ib_destroy_qp(ch->qp);
 }
 
+#define SRP_INLINE_STEP	16
+
+/*
+ * The verbs API cannot report a device's inline data limit. Some drivers
+ * have a fixed one: Intel irdma 216, 101 or 48 depending on the
+ * generation, Alibaba erdma 96. Try those first, by vendor ID, then step
+ * down SRP_INLINE_STEP bytes at a time to zero. libfabric's verbs
+ * provider also probes the limit (vrb_find_max_inline()).
+ */
+static const struct {
+	u32	vendor_id;
+	u32	max_inline;
+} srp_inline_limits[] = {
+	{ PCI_VENDOR_ID_INTEL, 216 },
+	{ PCI_VENDOR_ID_INTEL, 101 },
+	{ PCI_VENDOR_ID_INTEL, 48 },
+	{ PCI_VENDOR_ID_ALIBABA, 96 },
+};
+
+/*
+ * Inline data size to ask for: on the first try, @size capped at the
+ * vendor's first known limit; after a refusal, the vendor's next smaller
+ * known limit, else one step smaller.
+ */
+static u32 srp_inline_size(u32 vendor_id, u32 size, bool refused)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(srp_inline_limits); i++)
+		if (srp_inline_limits[i].vendor_id == vendor_id &&
+		    (!refused || srp_inline_limits[i].max_inline < size))
+			return min(srp_inline_limits[i].max_inline, size);
+	return refused ? size - min(size, SRP_INLINE_STEP) : size;
+}
+
+static int srp_create_qp(struct srp_rdma_ch *ch,
+			 struct ib_qp_init_attr *init_attr, struct ib_qp **qpp)
+{
+	struct srp_target_port *target = ch->target;
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_qp *qp;
+	int ret;
+
+	if (target->using_rdma_cm) {
+		ret = rdma_create_qp(ch->rdma_cm.cm_id, dev->pd, init_attr);
+		qp = ch->rdma_cm.cm_id->qp;
+	} else {
+		qp = ib_create_qp(dev->pd, init_attr);
+		if (!IS_ERR(qp)) {
+			ret = srp_init_ib_qp(target, qp);
+			if (ret)
+				ib_destroy_qp(qp);
+		} else {
+			ret = PTR_ERR(qp);
+		}
+	}
+	*qpp = qp;
+	return ret;
+}
+
 static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
@@ -529,8 +590,10 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	const struct ib_device_attr *attr = &dev->dev->attrs;
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
+	struct ib_qp_cap cap;
 	struct ib_qp *qp;
 	struct srp_fr_pool *fr_pool = NULL;
+	u32 inline_size;
 	const int m = 1 + dev->use_fast_reg * target->mr_per_cmd * 2;
 	int ret;
 
@@ -565,18 +628,21 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 
 	ch->max_imm_sge = min(init_attr->cap.max_send_sge - 1U, 255U);
 
-	if (target->using_rdma_cm) {
-		ret = rdma_create_qp(ch->rdma_cm.cm_id, dev->pd, init_attr);
-		qp = ch->rdma_cm.cm_id->qp;
-	} else {
-		qp = ib_create_qp(dev->pd, init_attr);
-		if (!IS_ERR(qp)) {
-			ret = srp_init_ib_qp(target, qp);
-			if (ret)
-				ib_destroy_qp(qp);
-		} else {
-			ret = PTR_ERR(qp);
-		}
+	/*
+	 * Ask for enough inline data to post command IUs inline (see
+	 * srp_post_send()), or for as much as the device accepts.
+	 */
+	cap = init_attr->cap;
+	inline_size = srp_inline_size(attr->vendor_id, SRP_MAX_INLINE_DATA,
+				      false);
+	for (;;) {
+		init_attr->cap = cap;
+		init_attr->cap.max_inline_data = inline_size;
+		ret = srp_create_qp(ch, init_attr, &qp);
+		if (!ret || !inline_size)
+			break;
+		inline_size = srp_inline_size(attr->vendor_id, inline_size,
+					      true);
 	}
 	if (ret) {
 		pr_err("QP creation failed for dev %s: %d\n",
@@ -604,6 +670,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	ch->qp = qp;
 	ch->recv_cq = recv_cq;
 	ch->send_cq = send_cq;
+	ch->max_inline_data = init_attr->cap.max_inline_data;
 
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
@@ -1915,6 +1982,17 @@ static int srp_post_send(struct srp_rdma_ch *ch, struct srp_iu *iu, int len)
 	wr.opcode     = IB_WR_SEND;
 	wr.send_flags = IB_SEND_SIGNALED;
 
+	/*
+	 * Post an IU without immediate data inline if it fits in the granted
+	 * inline size, so the HCA does not have to DMA-read it from host
+	 * memory.  The CPU copies inline data from a kernel virtual address,
+	 * so point the SGE at iu->buf.
+	 */
+	if (iu->num_sge == 1 && len <= ch->max_inline_data) {
+		iu->sge[0].addr = (uintptr_t)iu->buf;
+		wr.send_flags |= IB_SEND_INLINE;
+	}
+
 	return ib_post_send(ch->qp, &wr, NULL);
 }
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 349576ff3845..b8712e04be5e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -74,6 +74,14 @@ enum {
 	SRP_IMM_DATA_OFFSET	= sizeof(struct srp_cmd) +
 				  SRP_MAX_ADD_CDB_LEN +
 				  sizeof(struct srp_imm_buf),
+	/*
+	 * Inline data to ask for: enough for an SRP_CMD with an additional
+	 * CDB and an indirect table of two memory descriptors.
+	 */
+	SRP_MAX_INLINE_DATA	= sizeof(struct srp_cmd) +
+				  SRP_MAX_ADD_CDB_LEN +
+				  sizeof(struct srp_indirect_buf) +
+				  2 * sizeof(struct srp_direct_buf),
 };
 
 enum {
@@ -162,6 +170,7 @@ struct srp_rdma_ch {
 	uint32_t		max_ti_iu_len;
 	u8			max_imm_sge;
 	bool			use_imm_data;
+	u32			max_inline_data;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
-- 
2.56.0



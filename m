Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA0C37D100
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 06:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763864; cv=none; b=I9hOlexYjZbH16RS3JenOGoSHFaFJ3rAy9uzJgaWtm+nrWC6rQe5fIGa2Ax9IR4Wxd4bbi+wG78G179YJfbVhC/zz7O4KPdjk1OnsfI1uauBw6CJSUUukWqcDGOwcPmVS6A/gcA4eZBpoadI/SPg2qzTtCQYZeNP/8FHTWwSz/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763864; c=relaxed/simple;
	bh=Cl7wDkCMVcRO50+XUrv7w5aGp+oQtzAC+zb2ShtlOv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpmD3r1s478MyXSPY25GwVyko+Z4Bxio74/PsdKUe1TwZHtMbThLw14SSrqUgLqiESx0/wWCu+H+ylYH/GHnP6NAmwS29guURYRRvdSXF3ResZaOYxRXYUu3zqi+SWcBD1NyCmbT1xuvluNaAeGlYEmgv985zHAQeWeMStKqA6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLWD1Tk+; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLWD1Tk+"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8556ec44e9aso2663645b3a.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 23:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763862; x=1789368662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mmhyAEINnN2YsOh4vcMY7x4YEo1YGZUiTHUVYVx8t24=;
        b=XLWD1Tk+n2lsOY3olhrzhdMJGAFattEePGwqDqEPtCWXFxQkk+rMuuYtLTh+G1vBhu
         vs+iqMyvGZIpSSeBdDmVkZK0wvxbs3N2ANM4ZLG1KJqpAC8J/VwB6+ReKnUeONVcV5q1
         B63Ks8NeYWD9R+TiZY7AQEpDpRUN3WBLJWKoZAxD/pp/fswoXUE9XOpTY84Z2sz8lbfL
         YbBUvly+gvg1g5lDr7U6ysbIwJodXghYTO96FTPBq/LM/MoIwQzT2UK2QHSkO+uycFhw
         nW6so8oQrY9Meuus/14MD4iT3GGh7nD4O8ysfiO5wQ5raLjZy3GXNnF7nlOUqlc57V33
         5ATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763862; x=1789368662;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmhyAEINnN2YsOh4vcMY7x4YEo1YGZUiTHUVYVx8t24=;
        b=pJ+K/a7vVNOiDwqT6GE/28mJ9CdzrDOR4xe7iiSz8clXT/cxLOyYth5EqhYcmj2HL4
         Vt/Pv70Tr+YphGdE+t0gvrsgyBqrzMQYq0xJwLCcTq1XjH6enhZz4GausCKl4n4xVA6K
         EgCEBOu9r4XRpxpGfCT5ukjR7et7uqxtk5lgS4o3Zg3ch3c/nUB4UjaUonSK6zjMNrIe
         YIfjvRWroTzo23fX3JTRy7sZudnvdqZGCagG67G3R+u4O6gUdFOVXcCMp5wZ1KFByc4p
         MqqdzH107hbb+QqzzCf/aTE3qk38VNWbTG0Dsf+9FW7iqXIiJC4UK6LI1HVJptcZ7o8u
         b9xA==
X-Gm-Message-State: AFuF++luwe1HtXQpIFPx3hrHMz7++iqKuLMCHKOdADIaSYVKZbA7s9v4
	Yy53J8UiqLsMm0cbIpCojG0rIDzY84VKymdlQoxLPN12t9ZDXVdO1U8z
X-Gm-Gg: AYBFou2atmrjTCmxrWuT1+ur4B2khV4cBdGJQI49uWRAtax4CGIEMN3YyVza7hBaUQP
	L8vdCO4J4tuI6R2bYCKKL53f95GpFqXPKhxlRqWaIXvdACjn0Q5Cjp04BcG26gx15CR0MZkEyTd
	hlFCXAdkKKmBk0kLhN58RX5O8Uyxw+iUxT5k2695D+nwSDq7sRPJRVRxuEihYIiTOEErO54dhUe
	DygL14zA3V4wLK8gNQ91UjaQfKZ+94fWaw7Q+tjeig616nJ233/NlgLHzIl9ytlXFGeIqxIF+c1
	tbbQOcNfEupGBjth7mWc9+rG/4flDoiYTHBnB0OznsIzONNEZF98KKra30goOfVsJIYNnSD7Snt
	33w+iOB+yuaPNriKMFlpFq9bLwk3MumHOGsC2TRg+5KAYViGtvGCJR8K8vZ7Voq+3BxQPvInMU0
	s9SjPgaI8BctzHFhAIDneS5eTYeuVfN95ZDGW8/t00dp/KBkG88WEFR5VtJyNC+IJ+VpK6Klqal
	pcYp6cbFHhlFoyCKAC4pGkm
X-Received: by 2002:a05:6a20:7283:b0:3a0:bc61:62e6 with SMTP id adf61e73a8af0-3da39d0d473mr32732066637.8.1788763862086;
        Sun, 06 Sep 2026 23:51:02 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-338778fb926sm473120eec.31.2026.09.06.23.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:51:01 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 1/2] RDMA: fix typos in comments
Date: Mon,  7 Sep 2026 12:20:46 +0530
Message-ID: <20260907065047.26773-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907065047.26773-1-hemanth.selam@gmail.com>
References: <20260907065047.26773-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/infiniband/core/device.c              | 2 +-
 drivers/infiniband/core/uverbs_uapi.c         | 2 +-
 drivers/infiniband/core/verbs.c               | 2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 2 +-
 drivers/infiniband/hw/cxgb4/cq.c              | 2 +-
 drivers/infiniband/hw/erdma/erdma_main.c      | 2 +-
 drivers/infiniband/hw/hfi1/affinity.c         | 2 +-
 drivers/infiniband/hw/hfi1/firmware.c         | 2 +-
 drivers/infiniband/hw/mlx4/mcg.c              | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c              | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   | 6 +++---
 drivers/infiniband/hw/qedr/verbs.c            | 2 +-
 drivers/infiniband/hw/usnic/usnic_abi.h       | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  | 2 +-
 drivers/infiniband/hw/usnic/usnic_transport.h | 2 +-
 drivers/infiniband/sw/rdmavt/qp.c             | 2 +-
 drivers/infiniband/sw/rdmavt/srq.c            | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c     | 2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c      | 6 +++---
 drivers/infiniband/ulp/iser/iser_verbs.c      | 2 +-
 include/rdma/ib_verbs.h                       | 4 ++--
 include/rdma/uverbs_ioctl.h                   | 2 +-
 22 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7a3ed5ecac00..99beb404dde0 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -893,7 +893,7 @@ static int setup_port_data(struct ib_device *device)
  * ib_port_immutable_read() - Read rdma port's immutable data
  * @dev: IB device
  * @port: port number whose immutable data to read. It starts with index 1 and
- *        valid upto including rdma_end_port().
+ *        valid up to including rdma_end_port().
  */
 const struct ib_port_immutable*
 ib_port_immutable_read(struct ib_device *dev, unsigned int port)
diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index d150099b99d2..b67db3790f03 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -729,7 +729,7 @@ void uverbs_disassociate_api(struct uverbs_api *uapi)
 			 *
 			 * release_cleanup is the exception because
 			 * uverbs_uobject_fd_release() needs it. In this case
-			 * the module reference held by the fops will guarentee
+			 * the module reference held by the fops will guarantee
 			 * the type_class remains valid too.
 			 */
 			if (type_attrs &&
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 04abc80c1327..11fd60d41f18 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2358,7 +2358,7 @@ EXPORT_SYMBOL(ib_dereg_mr_user);
  * @max_num_sg:    maximum sg entries available for registration.
  *
  * Notes:
- * Memory registeration page/sg lists must not exceed max_num_sg.
+ * Memory registration page/sg lists must not exceed max_num_sg.
  * For mr_type IB_MR_TYPE_MEM_REG, the total length cannot exceed
  * max_num_sg * used_page_size.
  *
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..ef08d42f377e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2903,7 +2903,7 @@ static int bnxt_re_build_qp1_send_v2(struct bnxt_re_qp *qp,
 	qp->send_psn &= BTH_PSN_MASK;
 	qp->qp1_hdr.bth.psn = cpu_to_be32(qp->send_psn);
 	/* DETH */
-	/* Use the priviledged Q_Key for QP1 */
+	/* Use the privileged Q_Key for QP1 */
 	qp->qp1_hdr.deth.qkey = cpu_to_be32(IB_QP1_QKEY);
 	qp->qp1_hdr.deth.source_qpn = IB_QP1;
 
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index d1517f2560b9..2a7be0a1f168 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -1182,7 +1182,7 @@ void c4iw_flush_srqidx(struct c4iw_qp *qhp, u32 srqidx)
 	struct c4iw_cq *rchp = to_c4iw_cq(qhp->ibqp.recv_cq);
 	unsigned long flag;
 
-	/* locking heirarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&rchp->lock, flag);
 	spin_lock(&qhp->lock);
 
diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 7e87a815e853..a591d9891756 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -50,7 +50,7 @@ static int erdma_enum_and_get_netdev(struct erdma_dev *dev)
 	struct net_device *netdev;
 	int ret = -EPROBE_DEFER;
 
-	/* Already binded to a net_device, so we skip. */
+	/* Already bound to a net_device, so we skip. */
 	if (dev->netdev)
 		return 0;
 
diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 2b20907c9c12..d4bf75dcd102 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -386,7 +386,7 @@ static void _dev_comp_vect_mappings_destroy(struct hfi1_devdata *dd)
 
 /*
  * This function creates the table for looking up CPUs for completion vectors.
- * num_comp_vectors needs to have been initilized before calling this function.
+ * num_comp_vectors needs to have been initialized before calling this function.
  */
 static int _dev_comp_vect_mappings_create(struct hfi1_devdata *dd,
 					  struct hfi1_affinity_node *entry)
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 3c228aeaaf81..a69de0a91238 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -77,7 +77,7 @@ struct css_header {
 /* size of platform configuration partition */
 #define MAX_PLATFORM_CONFIG_FILE_SIZE 4096
 
-/* size of file of plaform configuration encoded in format version 4 */
+/* size of file of platform configuration encoded in format version 4 */
 #define PLATFORM_CONFIG_FORMAT_4_FILE_SIZE 528
 
 /* the file itself */
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index dc7c0daaaba5..bba178ffe1b2 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -433,7 +433,7 @@ static u16 cmp_rec(struct ib_sa_mcmember_data *src,
 }
 
 /* release group, return 1 if this was last release and group is destroyed
- * timout work is canceled sync */
+ * timeout work is canceled sync */
 static int release_group(struct mcast_group *group, int from_timeout_handler)
 {
 	struct mlx4_ib_demux_ctx *ctx = group->demux;
@@ -694,7 +694,7 @@ static void mlx4_ib_mcg_work_handler(struct work_struct *work)
 			cur_join_state = group->rec.scope_join_state & 0xf;
 
 			if (method == IB_MGMT_METHOD_GET_RESP) {
-				/* successfull join */
+				/* successful join */
 				if (!cur_join_state && resp_join_state)
 					--rc;
 			} else if (!resp_join_state)
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b8618610737a..8dcbb0e5ccd7 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -300,7 +300,7 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 	/*
 	 * Iteration one - zap the HW's MTTs. The notifiers_count ensures that
 	 * while we are doing the invalidation, no page fault will attempt to
-	 * overwrite the same MTTs.  Concurent invalidations might race us,
+	 * overwrite the same MTTs.  Concurrent invalidations might race us,
 	 * but they will write 0s as well, so no difference in the end result.
 	 */
 	for (addr = start; addr < end; addr += BIT(umem_odp->page_shift)) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cfe3d19b73b3..97c2e18e67ad 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1392,9 +1392,9 @@ int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	qp = get_ocrdma_qp(ibqp);
 	dev = get_ocrdma_dev(ibqp->device);
 
-	/* syncronize with multiple context trying to change, retrive qps */
+	/* synchronize with multiple context trying to change, retrieve qps */
 	mutex_lock(&dev->dev_lock);
-	/* syncronize with wqe, rqe posting and cqe processing contexts */
+	/* synchronize with wqe, rqe posting and cqe processing contexts */
 	spin_lock_irqsave(&qp->q_lock, flags);
 	old_qps = get_ibqp_state(qp->state);
 	if (attr_mask & IB_QP_STATE)
@@ -1599,7 +1599,7 @@ static void ocrdma_discard_cqes(struct ocrdma_qp *qp, struct ocrdma_cq *cq)
 	 */
 
 	cur_getp = cq->getp;
-	/* find upto when do we reap the cq. */
+	/* find up to when do we reap the cq. */
 	stop_getp = cur_getp;
 	do {
 		if (is_hw_sq_empty(qp) && (!qp->srq && is_hw_rq_empty(qp)))
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 012a0ab98d6b..973d0fa7cdce 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1075,7 +1075,7 @@ int qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	/* We don't want the IRQ handler to handle a non-existing CQ so we
 	 * wait until all CNQ interrupts, if any, are received. This will always
 	 * happen and will always happen very fast. If not, then a serious error
-	 * has occured. That is why we can use a long delay.
+	 * has occurred. That is why we can use a long delay.
 	 * We spin for a short time so we don’t lose time on context switching
 	 * in case all the completions are handled in that span. Otherwise
 	 * we sleep for a while and check again. Since the CNQ may be
diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
index 86a82a4da0aa..a684bc54f3d4 100644
--- a/drivers/infiniband/hw/usnic/usnic_abi.h
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -72,7 +72,7 @@ struct usnic_ib_create_qp_resp {
 	u64				bar_bus_addr;
 	u32				bar_len;
 /*
- * WQ, RQ, CQ are explicitly specified bc exposing a generic resources inteface
+ * WQ, RQ, CQ are explicitly specified bc exposing a generic resources interface
  * expands the scope of ABI to many files.
  */
 	u32				wq_cnt;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 1a1647d0e345..ebba3027cf48 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -181,7 +181,7 @@ find_free_vf_and_create_qp_grp(struct ib_qp *qp,
 	}
 
 	if (usnic_ib_share_vf) {
-		/* Try to find resouces on a used vf which is in pd */
+		/* Try to find resources on a used vf which is in pd */
 		dev_list = usnic_uiom_get_dev_list(pd->umem_pd);
 		if (IS_ERR(dev_list))
 			return PTR_ERR(dev_list);
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/infiniband/hw/usnic/usnic_transport.h
index 9a7a2d9755c0..c963c92218d3 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.h
+++ b/drivers/infiniband/hw/usnic/usnic_transport.h
@@ -50,7 +50,7 @@ int usnic_transport_sock_to_str(char *buf, int buf_sz,
 u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num);
 void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num);
 /*
- * Do a fget on the socket refered to by sock_fd and returns the socket.
+ * Do a fget on the socket referred to by sock_fd and returns the socket.
  * Socket will not be destroyed before usnic_transport_put_socket has
  * been called.
  */
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index c40cce69e945..d8ee485c49a6 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -814,7 +814,7 @@ int rvt_alloc_rq(struct rvt_rq *rq, u32 size, int node,
  *
  * This function is called from both rvt_create_qp() and
  * rvt_reset_qp().   The difference is that the reset
- * patch the necessary locks to protect against concurent
+ * patch the necessary locks to protect against concurrent
  * access.
  */
 static void rvt_init_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index d022aa56c5bf..8122b46ed4ab 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -286,7 +286,7 @@ int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 }
 
 /**
- * rvt_destroy_srq - destory an srq
+ * rvt_destroy_srq - destroy an srq
  * @ibsrq: srq object to destroy
  * @udata: user data for libibverbs.so
  */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index ba3b45152907..697cad0d063d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -140,7 +140,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 		goto out_early;
 	}
 
-	/* RTNL childs don't need proprietary sysfs entries */
+	/* RTNL children don't need proprietary sysfs entries */
 	if (type == IPOIB_LEGACY_CHILD) {
 		if (ipoib_cm_add_mode_attr(ndev))
 			goto sysfs_failed;
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7df441685780..31e3a8ab6c48 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -498,7 +498,7 @@ static int iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
  * iscsi_iser_conn_start() - start iscsi-iser connection
  * @cls_conn: iscsi class connection
  *
- * Notes: Here iser intialize (or re-initialize) stop_completion as
+ * Notes: Here iser initialize (or re-initialize) stop_completion as
  *        from this point iscsi must call conn_stop in session/connection
  *        teardown so iser transport must wait for it.
  */
@@ -593,7 +593,7 @@ static inline unsigned int iser_dif_prot_caps(int prot_caps)
  * @qdepth:         session command queue depth
  * @initial_cmdsn:  initiator command sequnce number
  *
- * Allocates and adds a scsi host, expose DIF supprot if
+ * Allocates and adds a scsi host, expose DIF support if
  * exists, and sets up an iscsi session.
  */
 static struct iscsi_cls_session *
@@ -866,7 +866,7 @@ static int iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
  * @ep:    iscsi endpoint handle
  *
  * This routine is not blocked by iser and RDMA termination process
- * completion as we queue a deffered work for iser/RDMA destruction
+ * completion as we queue a deferred work for iser/RDMA destruction
  * and cleanup or actually call it immediately in case we didn't pass
  * iscsi conn bind/start stage, thus it is safe.
  */
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 55fe68e5b837..ab2a27d23478 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -347,7 +347,7 @@ void iser_release_work(struct work_struct *work)
 
 	/* Wait for conn_stop to complete */
 	wait_for_completion(&iser_conn->stop_completion);
-	/* Wait for IB resouces cleanup to complete */
+	/* Wait for IB resources cleanup to complete */
 	wait_for_completion(&iser_conn->ib_completion);
 
 	mutex_lock(&iser_conn->state_mutex);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cb3b6163961b..d6eaa3fee66e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3532,7 +3532,7 @@ static inline bool rdma_cap_ib_cm(const struct ib_device *device, u32 port_num)
  * @port_num: Port number to check
  *
  * Similar to above, but specific to iWARP connections which have a different
- * managment protocol than InfiniBand.
+ * management protocol than InfiniBand.
  *
  * Return: true if the port supports an iWARP CM (this does not guarantee that
  * a CM is actually running however).
@@ -3577,7 +3577,7 @@ static inline bool rdma_cap_ib_sa(const struct ib_device *device, u32 port_num)
  * to this group.  And it should leave the group only after all queue pairs
  * attached to the group have been detached.
  *
- * Return: true if the port must undertake the additional adminstrative
+ * Return: true if the port must undertake the additional administrative
  * overhead of registering/unregistering with the SM and tracking of the
  * total number of queue pairs attached to the multicast group.
  */
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 80f3ba6663d0..1aaaadb8daf6 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -1142,7 +1142,7 @@ static inline int ib_is_udata_in_empty(struct ib_udata *udata)
  * @_udata: The system calls ib_udata struct
  *
  * Used when there is no driver response data to return. Provides forward
- * compatability by zeroing any buffer the user may have provided.
+ * compatibility by zeroing any buffer the user may have provided.
  */
 static inline int ib_respond_empty_udata(struct ib_udata *udata)
 {

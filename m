Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF4E49365E;
	Thu,  3 Sep 2026 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435580; cv=none; b=cBuS9x7XfLeb7UcUCcg68+P93fi+14RbqrIFnru/YPJ+gfe9j4JrAzju1DmVIPtBcJcY64Zz+Lqtt2oqd/DehxYxjUpmEvKNsHO8vRsEWs1EO6dqwjJWC+He6vO9VaIANX0M+xJD0Sh5Fzh2lgtxIgOZOs4svZnQmDEApv0aY0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435580; c=relaxed/simple;
	bh=AJIc5N0F/9oRP1GVO7re1aTaqN+tiE6xeHhjPBDj5AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSU9B8J124D5C+geSh5ZXA1cMHnixerIdcsB71K50FsoAMK+X/k2VUKPXIW6s/oSvX68OesexVs/nu7bVrLUaEozrFP6Qz+CkqCndCtwDmTnfOHnnf5jyZUtvmjxzSf9Ygvkk0ZlTHD23uoQwYrehXgGx//5kSGDyl1VthMaZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7X51+zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7X51+zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186241F00A3A;
	Thu,  3 Sep 2026 11:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435559;
	bh=E2t47qhW08QRVg919yYZxedVwTq3QyOUhueS1OAKMgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7X51+zv1ayBdqd0eM2Omc1MSSokNdyN1FjUm5IWRAaQE/e1wplqZKKrTX/lXdoQ8
	 RaRZX/e7SmJc/ez06ezdLK4R3TawR/5kKfnip/T6t3miqUVkqtVITiSR8HxCumFPLD
	 BoZnp3a99J87Om3AENw7bwbIol2++66B+Ro0cvspRD+Mqua6Xw1YTGWcMmbiUTpUEk
	 0XkspHfy459YEiWe7g+dxFXy1K4VfL1C2i38EnG90wwQwDn7bCuMkLgpJA7DHKpU+8
	 d1/uIfQiF6kzLix3bGDwqpHQNWDlOHM5NZZMhOaeJjsGlp2RAOib+r39wp5/Exp41B
	 j7rXgxut5id5g==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Remove unused post_sq arguments
Date: Thu,  3 Sep 2026 14:39:00 +0300
Message-ID: <20260903-64-bit-iova-is-silently-truncated-to-v1-2-96e878ea6873@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
References: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

The only callers of irdma_sc_qp_flush_wqes() and
irdma_sc_mr_fast_register() always request their respective send queues to
be posted, so their post_sq false branches are unreachable.

Remove both arguments and post the queues unconditionally. Drop the
redundant QP flush request assignments as well.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/irdma/ctrl.c   | 17 +++++------------
 drivers/infiniband/hw/irdma/hw.c     |  2 --
 drivers/infiniband/hw/irdma/protos.h |  3 +--
 drivers/infiniband/hw/irdma/type.h   |  3 +--
 drivers/infiniband/hw/irdma/verbs.c  |  4 ++--
 5 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 7af1c68b2fb2..0db73fd7d01b 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1689,11 +1689,9 @@ static int irdma_sc_mw_alloc(struct irdma_sc_dev *dev,
  * irdma_sc_mr_fast_register - Posts RDMA fast register mr WR to iwarp qp
  * @qp: sc qp struct
  * @info: fast mr info
- * @post_sq: flag for cqp db to ring
  */
 int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
-			      struct irdma_fast_reg_stag_info *info,
-			      bool post_sq)
+			      struct irdma_fast_reg_stag_info *info)
 {
 	u64 temp, hdr;
 	__le64 *wqe;
@@ -1753,8 +1751,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 	print_hex_dump_debug("WQE: FAST_REG WQE", DUMP_PREFIX_OFFSET, 16, 8,
 			     wqe, IRDMA_QP_WQE_MIN_SIZE, false);
 
-	if (post_sq)
-		irdma_uk_qp_post_wr(&qp->qp_uk);
+	irdma_uk_qp_post_wr(&qp->qp_uk);
 
 	return 0;
 }
@@ -2623,11 +2620,9 @@ static int irdma_sc_manage_ws_node(struct irdma_sc_cqp *cqp,
  * @qp: sc qp
  * @info: dlush information
  * @scratch: u64 saved to be used during cqp completion
- * @post_sq: flag for cqp db to ring
  */
 int irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp,
-			   struct irdma_qp_flush_info *info, u64 scratch,
-			   bool post_sq)
+			   struct irdma_qp_flush_info *info, u64 scratch)
 {
 	u64 temp = 0;
 	__le64 *wqe;
@@ -2695,8 +2690,7 @@ int irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp,
 
 	print_hex_dump_debug("WQE: QP_FLUSH WQE", DUMP_PREFIX_OFFSET, 16, 8,
 			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
-	if (post_sq)
-		irdma_sc_cqp_post_sq(cqp);
+	irdma_sc_cqp_post_sq(cqp);
 
 	return 0;
 }
@@ -6112,8 +6106,7 @@ static int irdma_exec_cqp_cmd(struct irdma_sc_dev *dev,
 	case IRDMA_OP_QP_FLUSH_WQES:
 		status = irdma_sc_qp_flush_wqes(pcmdinfo->in.u.qp_flush_wqes.qp,
 						&pcmdinfo->in.u.qp_flush_wqes.info,
-						pcmdinfo->in.u.qp_flush_wqes.scratch,
-						pcmdinfo->post_sq);
+						pcmdinfo->in.u.qp_flush_wqes.scratch);
 		break;
 	case IRDMA_OP_GEN_AE:
 		status = irdma_sc_gen_ae(pcmdinfo->in.u.gen_ae.qp,
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index c345cc654256..cae4f316def4 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -2742,7 +2742,6 @@ int irdma_hw_flush_wqes(struct irdma_pci_f *rf, struct irdma_sc_qp *qp,
 	hw_info = &cqp_request->info.in.u.qp_flush_wqes.info;
 	memcpy(hw_info, info, sizeof(*hw_info));
 	cqp_info->cqp_cmd = IRDMA_OP_QP_FLUSH_WQES;
-	cqp_info->post_sq = 1;
 	cqp_info->in.u.qp_flush_wqes.qp = qp;
 	cqp_info->in.u.qp_flush_wqes.scratch = (uintptr_t)cqp_request;
 	status = irdma_handle_cqp_op(rf, cqp_request);
@@ -2789,7 +2788,6 @@ int irdma_hw_flush_wqes(struct irdma_pci_f *rf, struct irdma_sc_qp *qp,
 				hw_info = &new_req->info.in.u.qp_flush_wqes.info;
 				memcpy(hw_info, info, sizeof(*hw_info));
 				cqp_info->cqp_cmd = IRDMA_OP_QP_FLUSH_WQES;
-				cqp_info->post_sq = 1;
 				cqp_info->in.u.qp_flush_wqes.qp = qp;
 				cqp_info->in.u.qp_flush_wqes.scratch = (uintptr_t)new_req;
 
diff --git a/drivers/infiniband/hw/irdma/protos.h b/drivers/infiniband/hw/irdma/protos.h
index 324cfbf21764..561a0287b945 100644
--- a/drivers/infiniband/hw/irdma/protos.h
+++ b/drivers/infiniband/hw/irdma/protos.h
@@ -19,8 +19,7 @@ void irdma_sc_rt_init(struct irdma_sc_dev *dev);
 void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp);
 __le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch);
 int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
-			      struct irdma_fast_reg_stag_info *info,
-			      bool post_sq);
+			      struct irdma_fast_reg_stag_info *info);
 /* HMC/FPM functions */
 int irdma_sc_init_iw_hmc(struct irdma_sc_dev *dev, u8 hmc_fn_id);
 /* stats misc */
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index 81c5c5da1988..8b4d2c0b283f 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -1381,8 +1381,7 @@ int irdma_sc_qp_create(struct irdma_sc_qp *qp,
 int irdma_sc_qp_destroy(struct irdma_sc_qp *qp, u64 scratch,
 			bool remove_hash_idx, bool ignore_mw_bnd, bool post_sq);
 int irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp,
-			   struct irdma_qp_flush_info *info, u64 scratch,
-			   bool post_sq);
+			   struct irdma_qp_flush_info *info, u64 scratch);
 int irdma_sc_qp_init(struct irdma_sc_qp *qp, struct irdma_qp_init_info *info);
 int irdma_sc_qp_modify(struct irdma_sc_qp *qp,
 		       struct irdma_modify_qp_info *info, u64 scratch,
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c0a9fc862d43..7d3540824e3a 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4283,8 +4283,8 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
 			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
 				stag_info.chunk_size = 1;
-			err = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
-							true);
+			err = irdma_sc_mr_fast_register(&iwqp->sc_qp,
+							&stag_info);
 			break;
 		}
 		default:

-- 
2.55.0


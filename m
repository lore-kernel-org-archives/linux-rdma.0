Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8F946AEDD;
	Thu,  3 Sep 2026 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435576; cv=none; b=ZvFbX35A/otgDf3iA03IOGpzeGXWn4CM9QAknG5PwCqepWdf1LHvM0nuwvcRapUk2104R2jxoRy7XR7QdRSEOGfHUcdl1FF4Lj4BBnetZE2dSoFqOPw1OrBR6YbPqR42kxg2ksI/QkKBk5pmbY6AUwLnWVXYm+xCxrrLdENY/NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435576; c=relaxed/simple;
	bh=+eGKrjAdf/usdpm9svEeuhgvbqxokZfK9NXaPYOJcjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m05L+KvyzPH+GfarH68JFSuUFr8wERb6XfkWaIZWTt5SZHUuHSMVChfr1JbkmHllCZP0QqzTghs5SR76wJIsfcyJ08ZWSPS3xlOF+a49qUuLnTwQ8BplqinB2Nww8Deea8SM+mRXC7K1WsoAAS/E6z6IhIljf8qCZjlKzvQstrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EinuM/ho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EinuM/ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74E01F00A3F;
	Thu,  3 Sep 2026 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435563;
	bh=SUTZGyWimozvW0WvqmA/xAl8RNSzNd4gpZU4oHnaoho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EinuM/hoTq54ofM+oxWfeJOd7SPL5rmpBCvCqCuzKf0j/j1gomGbLieyCnuwm+coQ
	 FVopD5j7+t3SDzZhcv1htA6x7qpqqi90NLEcIypr8G66E0Lkny5fAko44kIddPYTlP
	 MQGjjv41Xmpzo9VFz1aBcEu5zfEQNylemUTFCJwDMtY1dwJGPJtmvfSx+jH/EIp6Go
	 vySZD0MAgSdQdL4Un3fZ1NkSqFMExdSJuQBk1n0YMs3Mu3Joa6UGV4Qobx+nQy7W32
	 y+VTBgIxOI+LUA+Sd7P7JWicJWGiN6F9MlQEmdYwtWuHWvIvqI4jeCBGSwD1cV4G/E
	 5sq+gMTfLw+Hg==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 1/2] RDMA/irdma: Preserve fast-registration IOVA on 32-bit
Date: Thu,  3 Sep 2026 14:38:59 +0300
Message-ID: <20260903-64-bit-iova-is-silently-truncated-to-v1-1-96e878ea6873@nvidia.com>
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

ib_mr::iova is u64, but the fast-registration path passes it through
void * and uintptr_t. These conversions truncate the upper 32 bits on
32-bit kernels before the WQE is built.

Store the IOVA as u64 and write it directly to the WQE. The sole caller
always uses VA-based addressing, so remove the unused FBO selection and
set the VA-based bit unconditionally.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/irdma/ctrl.c  | 6 ++----
 drivers/infiniband/hw/irdma/type.h  | 4 +---
 drivers/infiniband/hw/irdma/verbs.c | 3 +--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 335ae3c82e17..7af1c68b2fb2 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1723,9 +1723,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 		  info->wr_id, wqe_idx,
 		  &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
 
-	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
-		(uintptr_t)info->va : info->fbo;
-	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 0, info->va);
 
 	temp = FIELD_GET(IRDMAQPSQ_FIRSTPMPBLIDXHI,
 			 info->first_pm_pbl_index >> 16);
@@ -1742,7 +1740,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 	      FIELD_PREP(IRDMAQPSQ_LPBLSIZE, info->chunk_size) |
 	      FIELD_PREP(IRDMAQPSQ_HPAGESIZE, page_size) |
 	      FIELD_PREP(IRDMAQPSQ_STAGRIGHTS, info->access_rights) |
-	      FIELD_PREP(IRDMAQPSQ_VABASEDTO, info->addr_type) |
+	      IRDMAQPSQ_VABASEDTO |
 	      FIELD_PREP(IRDMAQPSQ_READFENCE, info->read_fence) |
 	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, info->local_fence) |
 	      FIELD_PREP(IRDMAQPSQ_SIGCOMPL, info->signaled) |
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index 5557d9338796..81c5c5da1988 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -1173,13 +1173,11 @@ struct irdma_reg_ns_stag_info {
 struct irdma_fast_reg_stag_info {
 	u64 wr_id;
 	u64 reg_addr_pa;
-	u64 fbo;
-	void *va;
+	u64 va;
 	u64 total_len;
 	u32 page_size;
 	u32 chunk_size;
 	u32 first_pm_pbl_index;
-	enum irdma_addressing_type addr_type;
 	irdma_stag_index stag_idx;
 	u16 access_rights;
 	u32 pd_id;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 9cfd84dd6869..c0a9fc862d43 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4276,8 +4276,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.stag_idx = reg_wr(ib_wr)->key >> 8;
 			stag_info.page_size = reg_wr(ib_wr)->mr->page_size;
 			stag_info.wr_id = ib_wr->wr_id;
-			stag_info.addr_type = IRDMA_ADDR_TYPE_VA_BASED;
-			stag_info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
+			stag_info.va = iwmr->ibmr.iova;
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;

-- 
2.55.0


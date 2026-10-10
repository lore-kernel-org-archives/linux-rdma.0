Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370003CCA13;
	Sat, 10 Oct 2026 06:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615287; cv=none; b=kTmJtGxLsIKOdSeh+NXshoI4QUKyWPL4g4JNsf+T5lIIgTrOwyFUn6HtOtakMvZLVh8ckI/+X14bzfEAjH32HIilkAVswYpSORCvQHCMgD4kIrT0zWv/46d05V0IfDTRIGf8EqGacYsvFbtOlG6lg5yNxIi7zLsuW5UY018eMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615287; c=relaxed/simple;
	bh=niC3ykvqlBv/Cm5Iu0Q9tc/bMWrB6l0NbYLzXfnRI6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfeufJ2VDwyNhKXUduyTFFLS605Gtkk6H+f6FxEER9BVGj3F4dRCL1EKFDdufiLf7pUYyDSpbVrgPCsPLTrr8cQ3SqS+EiOtgQy+gR1Ng3F87fVww3KckgWvG0Voy/WDLgXZ+9uSAaCztuhZaH8Tofo0NzJiWRxZI4UOSz+/FHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Y6ibKT0U; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Y6ibKT0U"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id AD10020B7168; Fri,  9 Oct 2026 23:54:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AD10020B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791615283;
	bh=uyNVKhmWV9ZEhAXObss1/ot6wg3NWoQ7DX7Kxti9j/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6ibKT0UTjFFWmmzxBPhN9q3oauozgoMELWNK3h8hKTOER2s9HHqgaXGnuJpzUGtd
	 DvhRBBA/c51bvFcdWKQae0SnlTL4j8pZV/I9jmlszhOuXhWEazxWq7FKZdGKaJDjiz
	 sc4IOe8NnXpstvRCtfkwt0YfPzi+0Y4JF1fQF/rU=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 01/10] RDMA/mana_ib: Allocate and map fast-registration MRs
Date: Fri,  9 Oct 2026 23:54:34 -0700
Message-ID: <20261010065443.3554193-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement alloc_mr and map_mr_sg for memory-registration MRs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v4:
- Use an explicit 64-byte FMR MST alignment

 drivers/infiniband/hw/mana/device.c  |  2 +
 drivers/infiniband/hw/mana/main.c    |  3 +-
 drivers/infiniband/hw/mana/mana_ib.h | 48 ++++++++++++++++
 drivers/infiniband/hw/mana/mr.c      | 84 +++++++++++++++++++++++++++-
 include/net/mana/gdma.h              | 15 +++++
 5 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index 62c7803ca6c6..cdaada7f6e8a 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -19,6 +19,7 @@ static const struct ib_device_ops mana_ib_dev_ops = {
 
 	.add_gid = mana_ib_gd_add_gid,
 	.alloc_mw = mana_ib_alloc_mw,
+	.alloc_mr = mana_ib_alloc_mr,
 	.alloc_pd = mana_ib_alloc_pd,
 	.alloc_ucontext = mana_ib_alloc_ucontext,
 	.create_ah = mana_ib_create_ah,
@@ -40,6 +41,7 @@ static const struct ib_device_ops mana_ib_dev_ops = {
 	.get_dma_mr = mana_ib_get_dma_mr,
 	.get_link_layer = mana_ib_get_link_layer,
 	.get_port_immutable = mana_ib_get_port_immutable,
+	.map_mr_sg = mana_ib_map_mr_sg,
 	.mmap = mana_ib_mmap,
 	.modify_qp = mana_ib_modify_qp,
 	.modify_wq = mana_ib_modify_wq,
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 672bd3f650dd..ceb4ec58023a 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -133,7 +133,7 @@ int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 			     sizeof(resp));
 
 	if (!udata)
-		flags |= GDMA_PD_FLAG_ALLOW_GPA_MR;
+		flags |= GDMA_PD_FLAG_ALLOW_GPA_MR | GDMA_PD_FLAG_ALLOW_FMR_MR;
 
 	req.flags = flags;
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
@@ -647,6 +647,7 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
 	props->max_ah = INT_MAX;
 	props->max_pkeys = 1;
 	props->local_ca_ack_delay = MANA_CA_ACK_DELAY;
+	props->max_fast_reg_page_list_len = MANA_MAX_FMR_PAGES;
 	if (!mana_ib_is_rnic(dev))
 		props->raw_packet_caps = IB_RAW_PACKET_CAP_IP_CSUM;
 
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 74edb6e707a1..5ca6e2acf974 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -39,6 +39,8 @@
  */
 #define MANA_IB_MAX_MR		0xFFFFFFu
 
+#define MANA_MAX_FMR_PAGES	504
+
 /*
  * The CA timeout is approx. 260ms (4us * 2^(DELAY))
  */
@@ -51,6 +53,8 @@
 
 #define MANA_GSI_QPN		(1)
 
+#define MANA_PTE_VALID_MASK	0x1ULL
+
 struct mana_ib_adapter_caps {
 	u32 max_sq_id;
 	u32 max_rq_id;
@@ -150,10 +154,46 @@ struct mana_ib_mw {
 	mana_handle_t mw_handle;
 };
 
+#define MANA_FMR_MST_ALIGNMENT 64
+
+struct mana_fmr_mst_entry {
+	u32 reserved1;
+	u32 reserved2		: 8;
+	u32 page_size		: 5;
+	u32 reserved3		: 3;
+	u32 access_right	: 8;
+	u32 addr_type		: 2;
+	u32 reserved4		: 6;
+	u32 reserved5[2];
+	u64 start_va;
+	u64 length;
+	u32 reserved6[8];
+}; /* HW DATA */
+
+static inline u32 mana_ib_fmr_header_offset(u32 num_ptes)
+{
+	/* The header follows the PTEs with the required MST alignment. */
+	return ALIGN(sizeof(u64) * num_ptes, MANA_FMR_MST_ALIGNMENT);
+}
+
+static inline u32 mana_ib_fmr_buf_sz(u32 num_ptes)
+{
+	return mana_ib_fmr_header_offset(num_ptes) + sizeof(struct mana_fmr_mst_entry);
+}
+
+struct mana_ib_fmr {
+	u64 *ptes;
+	dma_addr_t dma_handle;
+	size_t size;
+	u32 max_ptes;
+	u32 pte_count;
+};
+
 struct mana_ib_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
 	mana_handle_t mr_handle;
+	struct mana_ib_fmr fmr;
 };
 
 struct mana_ib_dm {
@@ -840,8 +880,16 @@ int mana_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 
 int mana_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl);
 
+enum gdma_mr_access_flags
+mana_ib_verbs_to_gdma_access_flags(int access_flags);
+
 struct ib_mr *mana_ib_get_dma_mr(struct ib_pd *ibpd, int access_flags);
 
+struct ib_mr *mana_ib_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
+			       u32 max_num_sg);
+int mana_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		      unsigned int *sg_offset);
+
 struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 iova, int access_flags,
 				  struct ib_dmah *dmah,
diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
index 1233685b4b89..34dcc50d0be9 100644
--- a/drivers/infiniband/hw/mana/mr.c
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -10,7 +10,7 @@
 
 #define VALID_DMA_MR_FLAGS (IB_ACCESS_LOCAL_WRITE)
 
-static enum gdma_mr_access_flags
+enum gdma_mr_access_flags
 mana_ib_verbs_to_gdma_access_flags(int access_flags)
 {
 	enum gdma_mr_access_flags flags = GDMA_ACCESS_FLAG_LOCAL_READ;
@@ -55,6 +55,11 @@ static int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr *mr,
 		req.gva.virtual_address = mr_params->gva.virtual_address;
 		req.gva.access_flags = mr_params->gva.access_flags;
 		break;
+	case GDMA_MR_TYPE_FMR:
+		/* page_size is deprecated field and must be 0. */
+		req.fmr.page_size = 0;
+		req.fmr.rsvd_pte_count = mr_params->fmr.rsvd_pte_count;
+		break;
 	case GDMA_MR_TYPE_ZBVA:
 		req.zbva.dma_region_handle = mr_params->zbva.dma_region_handle;
 		req.zbva.access_flags = mr_params->zbva.access_flags;
@@ -294,6 +299,77 @@ err_free:
 	return ERR_PTR(err);
 }
 
+struct ib_mr *mana_ib_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
+			       u32 max_num_sg)
+{
+	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct gdma_create_mr_params mr_params = {};
+	struct gdma_context *gc;
+	struct mana_ib_dev *dev;
+	struct mana_ib_mr *mr;
+	int err;
+
+	dev = container_of(ibpd->device, struct mana_ib_dev, ib_dev);
+	gc = mdev_to_gc(dev);
+
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	mr = kzalloc_obj(*mr);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->fmr.max_ptes = max_num_sg;
+	mr->fmr.size = mana_ib_fmr_buf_sz(max_num_sg);
+	mr->fmr.ptes = dma_alloc_coherent(gc->dev, mr->fmr.size, &mr->fmr.dma_handle,
+					  GFP_KERNEL);
+	if (!mr->fmr.ptes) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	mr_params.pd_handle = pd->pd_handle;
+	mr_params.mr_type = GDMA_MR_TYPE_FMR;
+	mr_params.fmr.rsvd_pte_count = max_num_sg;
+
+	err = mana_ib_gd_create_mr(dev, mr, &mr_params);
+	if (err)
+		goto err_dma;
+
+	return &mr->ibmr;
+
+err_dma:
+	dma_free_coherent(gc->dev, mr->fmr.size, mr->fmr.ptes,
+			  mr->fmr.dma_handle);
+
+err_free:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
+static int mana_ib_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct mana_ib_mr *mr = container_of(ibmr, struct mana_ib_mr, ibmr);
+
+	if (mr->fmr.pte_count >= mr->fmr.max_ptes)
+		return -ENOMEM;
+
+	mr->fmr.ptes[mr->fmr.pte_count] = addr | MANA_PTE_VALID_MASK;
+	mr->fmr.pte_count++;
+
+	return 0;
+}
+
+int mana_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		      unsigned int *sg_offset)
+{
+	struct mana_ib_mr *mr = container_of(ibmr, struct mana_ib_mr, ibmr);
+
+	mr->fmr.pte_count = 0;
+
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mana_ib_set_page);
+}
+
 static int mana_ib_gd_create_mw(struct mana_ib_dev *dev, struct mana_ib_pd *pd, struct ib_mw *ibmw)
 {
 	struct mana_ib_mw *mw = container_of(ibmw, struct mana_ib_mw, ibmw);
@@ -352,6 +428,7 @@ int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mana_ib_mr *mr = container_of(ibmr, struct mana_ib_mr, ibmr);
 	struct ib_device *ibdev = ibmr->device;
+	struct gdma_context *gc;
 	struct mana_ib_dev *dev;
 	int err;
 
@@ -360,11 +437,16 @@ int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		return err;
 
 	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gc = mdev_to_gc(dev);
 
 	err = mana_ib_gd_destroy_mr(dev, mr->mr_handle);
 	if (err)
 		return err;
 
+	if (mr->fmr.ptes)
+		dma_free_coherent(gc->dev, mr->fmr.size, mr->fmr.ptes,
+				  mr->fmr.dma_handle);
+
 	if (mr->umem)
 		ib_umem_release(mr->umem);
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 2a28fcaa637d..332f394b82e1 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -865,6 +865,8 @@ enum gdma_mr_access_flags {
 	GDMA_ACCESS_FLAG_REMOTE_WRITE = BIT_ULL(3),
 	GDMA_ACCESS_FLAG_REMOTE_ATOMIC = BIT_ULL(4),
 	GDMA_ACCESS_FLAG_BIND_MW = BIT_ULL(5),
+	GDMA_ACCESS_FLAG_INVALIDATE = BIT_ULL(6),
+	GDMA_ACCESS_FLAG_FMR = BIT_ULL(7),
 };
 
 /* GDMA_CREATE_DMA_REGION */
@@ -917,6 +919,7 @@ struct gdma_destroy_dma_region_req {
 
 enum gdma_pd_flags {
 	GDMA_PD_FLAG_ALLOW_GPA_MR = BIT(0),
+	GDMA_PD_FLAG_ALLOW_FMR_MR = BIT(1),
 	GDMA_PD_FLAG_SHORT_PDN = BIT(2),
 };
 
@@ -953,6 +956,11 @@ enum gdma_mr_type {
 	 * address that is set up in the MST
 	 */
 	GDMA_MR_TYPE_GVA = 2,
+	/* Fast Memory - MRs are initially put in the free state,
+	 * and the specified number of PTEs are reserved for future fast
+	 * memory registrations
+	 */
+	GDMA_MR_TYPE_FMR = 3,
 	/* Guest zero-based address MRs */
 	GDMA_MR_TYPE_ZBVA = 4,
 	/* Device address MRs */
@@ -982,6 +990,9 @@ struct gdma_create_mr_params {
 			u64 length;
 			enum gdma_mr_access_flags access_flags;
 		} da;
+		struct {
+			u32 rsvd_pte_count;
+		} fmr;
 	};
 };
 
@@ -1006,6 +1017,10 @@ struct gdma_create_mr_request {
 			u64 offset;
 			enum gdma_mr_access_flags access_flags;
 		} __packed da;
+		struct {
+			u32 page_size;
+			u32 rsvd_pte_count;
+		} __packed fmr;
 	} __packed;
 	u32 reserved_2;
 	union {

-- 
2.43.0

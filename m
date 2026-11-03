Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704664;
	b=QDqBBvc9MTGV0yoHIBFl+9OPrdhDlvzFm0jm9ZsMTZJ1XMHnkFQmddvckz7H0K9+gpk8
	 Oc26akUY9Wn9DlkAp0D0FKC5JVXF8964uJFyo7/j6w8RVIf2U5hex/+7HzeiadWLB9QSw
	 BGRYxUf9Q3A0/KGfFLsggzxRDlmMJ/6LDcqNlLTfQ2Wih1Wbc6XpU0Wii4h1Y5eZeq+/A
	 AOT3Jx8nRe+h6wNv/JJ3Zz4tT+8Q0//amFEL8NpsndEuXg4KCqYo6yOc1K1kZEXz+6Ukw
	 H4EAtRvIJrtnWhsVMUCUpuMOW8YnI3/JoX63UIC+mKf4ABbmlY8NWZMEHO9694yIdYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704664;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bEuYIRZvDtvBEBZICTqM+tPT23TNfC5S5qTvcTBWToc=;
	b=3NuQRoal8+5w2c3Oh8hFNJj1tJDLrsD20IPcLwp/s+WT6CgI/rLj1AEllB9RmbofPP7x
	 9LEtDgPl1t2ELDwEvb2HcQwP/pLppINQ/vMLgQKpmTCWIONrvg3V4UPjFSL05G7sO7Pgo
	 96Qp1+3FwtJ2wwKTZQrhM7MI+N4QjcrcaPH5jEQuNaBQWEHIRdvVwVZfGB2ALifrMwclC
	 yInYcJvhDqwy9fsoejCqrp5nvO20V6QE8RqDaI9hHudhStIo4enuyBhOlpwBgHCaoJHui
	 VExWaIYtMOBrJbMEWBcqjLOn5g7kT4FgpilHniyU1zkVbWqTsgWghKa2a5Hz4ufqyTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=oeMwHpjq;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAAC606D81A;
	Tue,  3 Nov 2026 11:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DAAC606D81A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=oeMwHpjq
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 46A7B20B7168; Tue,  3 Nov 2026 03:17:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 46A7B20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793704649;
	bh=bEuYIRZvDtvBEBZICTqM+tPT23TNfC5S5qTvcTBWToc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeMwHpjqJ3y9PoiAwVKygBa5RSksHJ09UmpZQXIcHHdvGl4uM19VJSeQIXcI6tBuR
	 jmViiN5fXSkJN5j4IYalxf7Mv6UhbpiPWZqQ8tEXad67kF/l4sD1K4kSArG9NPtE0x
	 lsHwGgZTd0rKUac1qxBoSlt9h81EY5c6Jmsj5tPE=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v8 1/9] RDMA/mana_ib: Allocate and map fast-registration MRs
Date: Tue,  3 Nov 2026 03:17:21 -0800
Message-ID: <20261103111729.729886-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
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

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement alloc_mr and map_mr_sg for memory-registration MRs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v5:
- Reject max_num_sg above MANA_MAX_FMR_PAGES
v4:
- Use an explicit 64-byte FMR MST alignment

 drivers/infiniband/hw/mana/device.c  |  2 +
 drivers/infiniband/hw/mana/main.c    |  3 +-
 drivers/infiniband/hw/mana/mana_ib.h | 48 +++++++++++++++
 drivers/infiniband/hw/mana/mr.c      | 87 +++++++++++++++++++++++++++-
 include/net/mana/gdma.h              | 15 +++++
 5 files changed, 153 insertions(+), 2 deletions(-)

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
index 1233685b4b89..2be252778e17 100644
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
@@ -294,6 +299,80 @@ err_free:
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
+	if (max_num_sg > MANA_MAX_FMR_PAGES)
+		return ERR_PTR(-EINVAL);
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
@@ -352,6 +431,7 @@ int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mana_ib_mr *mr = container_of(ibmr, struct mana_ib_mr, ibmr);
 	struct ib_device *ibdev = ibmr->device;
+	struct gdma_context *gc;
 	struct mana_ib_dev *dev;
 	int err;
 
@@ -360,11 +440,16 @@ int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
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

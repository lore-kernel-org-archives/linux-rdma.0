Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608298;
	b=Xcs90UwQHn4TlbwcQNpZtVrrskzkrcz4AYN9W3p21C7Bwcc2XSdpXBvIV9yjZibrbsyT
	 U4FLDpjeMEjG2+iGAqVXFtbyE735NFaRISsgBAA7W+rjQYPw3CNm/1t9kZWSSv+UznB+5
	 6W+u4Cv7JEls3x9nHUDPMcl85dJZk87VDabQFSMofqI8aXdWytHip3+2j0VX7sNmJuS0w
	 kRsARr9mh4uegfjkoOViZ9N50qiVW6hzxo7LSxBXtGfbGpN53oeN9mcHLUiaVVkiGgEVr
	 fJU/ZMPJu8D6Ol80HSH9JxZReLngSGKkjAYDJtf5cAg+NnY2lM+MGQdjWHklU221nFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608298;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=5BmDnZukl6XTD6FDjqjao8Nbmw5xmn8qfWV5l5vHd8w=;
	b=XV/jKDtMaFK3/IIiBACLQHsXG9wr6KjULBp2fE6V0cyk+PbTmYtKTBACTOLWdkXnzFiV
	 I32B36fmk5eP3zT4Yzh8r8l9+SgOCqphpnEk0LDvbiEqe8PlJRi3HyuDB47Rbcdbut+bH
	 yLtsaCYHqJiOmTMrF2i5ggWSQjAUwBa3m2SdwW48fY327jDEC1WnUaFJYyD61kYeHtdB4
	 IJoVL0RsBl1/0XjPg9cmNy0jdhRDjHT3JbZyr6fPrTOa2Q9p0kfbXtxnuDP4oMXRkNfb0
	 62FMpsABD0oz3KCNRy+R+sRQREBpiFJreybuhs0k1x8eXS5YR4IM9OGeLznCXqcScSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF82606A33B;
	Mon,  2 Nov 2026 08:31:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF82606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJ4gB3Tkvz5B0rj;
	Mon, 02 Nov 2026 16:31:34 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl2.zte.com.cn with SMTP id 6A28VGWn034529;
	Mon, 2 Nov 2026 16:31:16 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Mon, 2 Nov 2026 16:31:18 +0800
X-Zmail-TransId: 3e816ae84a56028-fc64b
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev,
        Markus.Elfring@web.de
Cc: lkp@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v8 7/7] RDMA/zrdma: Implement context, PD, and mmap operations
Date: Mon,  2 Nov 2026 16:20:26 +0800
Message-ID: <20261102082026.2645777-8-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 6A28VGWn034529
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 02 Nov 2026 16:31:34 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE84A66.000/4jJ4gB3Tkvz5B0rj

Add implementation for allocation/deallocation of Protection Domains (PD),
User Contexts, and memory mapping (mmap) for doorbells.

The SRQ doorbell area is not page aligned on 16K and 64K page systems, so
the mapping length is extended to the page boundary and the size
reported to userspace is the very same length. The V1 and V2 contexts do
not know the size of the SRQ doorbell area, so only the first page is
mapped for them.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 329 ++++++++++++++++++++++
 1 file changed, 329 insertions(+)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 821ccbc2054ea..239d607f7d182 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -10,6 +10,7 @@
 #include <linux/ctype.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
+#include <rdma/ib_user_verbs.h>
 
 /* Release everything the probe path may have allocated. The hook is
  * called from ib_dealloc_device(), so it must tolerate a partially
@@ -392,15 +393,343 @@ int zxdh_ib_register_device(struct zxdh_device *zdev)
 	return ret;
 }
 
+static void zxdh_sc_pd_init(struct zxdh_sc_dev *dev, struct zxdh_sc_pd *pd,
+			    u32 pd_id, int abi_ver)
+{
+	pd->pd_id = pd_id;
+	pd->abi_ver = abi_ver;
+	pd->dev = dev;
+}
+
+static int zxdh_alloc_pd(struct ib_pd *pd, struct ib_udata *udata)
+{
+	struct zxdh_device *zdev = to_zdev(pd->device);
+	struct zxdh_sc_dev *dev = &zdev->rf->sc_dev;
+	struct zxdh_alloc_pd_resp uresp = {};
+	struct zxdh_pd *zpd = to_zpd(pd);
+	struct zxdh_pci_f *rf = zdev->rf;
+	struct zxdh_sc_pd *sc_pd;
+	u32 pd_id;
+	int err;
+
+	/* The user has to provide a buffer for the whole response. A short
+	 * buffer is reported instead of being silently truncated, and no
+	 * resource is taken for it.
+	 */
+	if (udata && udata->outlen < sizeof(uresp))
+		return -ENOSPC;
+
+	err = zxdh_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
+			      &rf->next_pd, "PD");
+	if (err) {
+		pr_warn_ratelimited("zrdma: PD allocation failed err=%d\n",
+				    err);
+		return err;
+	}
+
+	sc_pd = &zpd->sc_pd;
+	if (udata) {
+		struct zxdh_ucontext *ucontext;
+
+		ucontext = rdma_udata_to_drv_context(udata,
+						     struct zxdh_ucontext,
+						     ibucontext);
+
+		zxdh_sc_pd_init(dev, sc_pd, pd_id, ucontext->abi_ver);
+		uresp.pd_id = pd_id;
+		if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
+			err = -EFAULT;
+			goto error;
+		}
+	} else {
+		/* A protection domain that the kernel allocates has no user
+		 * context, it uses the default ABI version.
+		 */
+		zxdh_sc_pd_init(dev, sc_pd, pd_id, ZXDH_ABI_VER);
+	}
+
+	return 0;
+
+error:
+	zxdh_free_rsrc(rf, rf->allocated_pds, pd_id);
+
+	return err;
+}
+
+static struct rdma_user_mmap_entry *
+zxdh_mmap_entry_insert(struct zxdh_ucontext *ucontext, u64 bar_offset,
+		       size_t length, enum zxdh_mmap_flag mmap_flag,
+		       u64 *mmap_offset)
+{
+	struct zxdh_user_mmap_entry *entry =
+		kzalloc(sizeof(*entry), GFP_KERNEL);
+	int ret;
+
+	if (!entry)
+		return NULL;
+
+	entry->bar_offset = bar_offset;
+	entry->mmap_flag = mmap_flag;
+
+	ret = rdma_user_mmap_entry_insert(&ucontext->ibucontext,
+					  &entry->rdma_entry, length);
+	if (ret) {
+		kfree(entry);
+		return NULL;
+	}
+	*mmap_offset = rdma_user_mmap_get_offset(&entry->rdma_entry);
+
+	return &entry->rdma_entry;
+}
+
+/* The SRQ doorbell area starts at SRQ_DB_BAR_OFF, which is not page
+ * aligned once the page size is 16K or 64K. The mapping therefore has to
+ * start at the page holding the doorbell and has to be large enough to
+ * cover the whole doorbell area.
+ */
+static u64 zxdh_get_srq_db_mmap_size(void)
+{
+	return round_up((SRQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM) +
+			SRQ_DB_MMAP_SIZE, PAGE_SIZE);
+}
+
+static int zxdh_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
+{
+	struct zxdh_ucontext *ucontext = to_ucontext(uctx);
+	struct zxdh_alloc_ucontext_resp uresp = {};
+	struct ib_device *ibdev = uctx->device;
+	struct zxdh_device *zdev = to_zdev(ibdev);
+	struct zxdh_alloc_ucontext_req req = {};
+	u64 srq_db_mmap_size;
+
+	if (ib_copy_from_udata(&req, udata, min(sizeof(req), udata->inlen)))
+		return -EINVAL;
+
+	if (req.userspace_ver != ZXDH_CONTEXT_VER_V1 &&
+	    req.userspace_ver != ZXDH_CONTEXT_VER_V2 &&
+	    req.userspace_ver != ZXDH_CONTEXT_VER_V3) {
+		pr_err("zrdma: Invalid userspace_ver%d\n", req.userspace_ver);
+		return -EINVAL;
+	}
+
+	/* The response carries the keys of the doorbell mappings, so the
+	 * user has to provide a buffer for the whole of it. A short buffer
+	 * is reported instead of being silently truncated.
+	 */
+	if (udata->outlen < sizeof(uresp))
+		return -ENOSPC;
+
+	ucontext->zdev = zdev;
+	ucontext->abi_ver = req.userspace_ver;
+
+	uresp.srq_db_bar_off = SRQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
+
+	ucontext->sq_db_mmap_entry =
+		zxdh_mmap_entry_insert(ucontext, SQ_DB_BAR_OFF, PAGE_SIZE,
+				       ZXDH_MMAP_IO_NC,
+				       &uresp.sq_db_mmap_key);
+	if (!ucontext->sq_db_mmap_entry)
+		return -ENOMEM;
+
+	ucontext->cq_db_mmap_entry =
+		zxdh_mmap_entry_insert(ucontext, CQ_DB_BAR_OFF, PAGE_SIZE,
+				       ZXDH_MMAP_IO_NC,
+				       &uresp.cq_db_mmap_key);
+	if (!ucontext->cq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		ucontext->sq_db_mmap_entry = NULL;
+		return -ENOMEM;
+	}
+
+	/* The mapping length and the size reported to userspace have to
+	 * match, otherwise rdma_user_mmap_entry_get() rejects the mmap.
+	 *
+	 * The V1 and V2 contexts do not know the size of the SRQ doorbell
+	 * area, so only the first page is mapped for them. The V3 context
+	 * gets the size of the whole area in the response.
+	 */
+	if (ucontext->abi_ver == ZXDH_CONTEXT_VER_V1 ||
+	    ucontext->abi_ver == ZXDH_CONTEXT_VER_V2)
+		srq_db_mmap_size = PAGE_SIZE;
+	else
+		srq_db_mmap_size = zxdh_get_srq_db_mmap_size();
+
+	ucontext->srq_db_mmap_entry =
+		zxdh_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
+				       srq_db_mmap_size,
+				       ZXDH_MMAP_IO_NC_BY_SIZE,
+				       &uresp.srq_db_mmap_key);
+	if (!ucontext->srq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		ucontext->sq_db_mmap_entry = NULL;
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		ucontext->cq_db_mmap_entry = NULL;
+		pr_err("zrdma: srq_db_mmap_entry is NULL!\n");
+		return -ENOMEM;
+	}
+
+	uresp.srq_db_mmap_size = srq_db_mmap_size;
+	uresp.kernel_ver = ZXDH_CONTEXT_VER_V3;
+	uresp.hw_rev = ZXDH_GEN_2;
+	uresp.chip_rev = CHIP_VERSION;
+	uresp.rdma_tool_flags =
+		ZXDH_QP_EXTEND_OP | ZXDH_CAPTURE | ZXDH_GET_HW_DATA |
+		ZXDH_GET_HW_OBJECT_DATA | ZXDH_CHECK_HW_HEALTH |
+		ZXDH_RDMA_TOOL_CFG_DEV_PARAM | ZXDH_RDMA_TOOL_READ_RAM |
+		ZXDH_RDMA_TOOL_DEVX_MODIFY_CQ | ZXDH_RDMA_SET_CREDIT_CAP |
+		ZXDH_RDMA_SWITCH | ZXDH_RDMA_TOOL_DEVX_EXT_MEM |
+		ZXDH_RDMA_TOOL_PRIV_EXT |
+		ZXDH_RDMA_TOOL_IOVA_CAP;
+
+	uresp.feature_flags = ZXDH_FEATURE_RTS_AE | ZXDH_FEATURE_CQ_RESIZE |
+			      ZXDH_FEATURE_64_BYTE_CQE;
+	uresp.max_hw_wq_frags = MAX_HW_WQ_FRAGS;
+	uresp.max_hw_read_sges = MAX_HW_READ_SGES;
+	uresp.max_hw_inline = MAX_HW_INLINE;
+	uresp.max_hw_srq_wr = MAX_HW_SRQ_WR;
+	uresp.max_hw_rq_quanta = MAX_HW_RQ_QUANTA;
+	uresp.max_hw_srq_quanta = MAX_HW_SRQ_QUANTA;
+	uresp.max_hw_wq_quanta = MAX_HW_WQ_QUANTA;
+	uresp.max_hw_sq_chunk = MAX_HW_SQ_CHUNK;
+	uresp.max_hw_cq_size = MAX_HW_CQ_SIZE;
+	uresp.min_hw_cq_size = MIN_HW_CQ_SIZE;
+	uresp.db_addr_type = ZXDH_DB_ADDR_BAR;
+	uresp.sq_db_bar_off = SQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
+	uresp.cq_db_bar_off = CQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
+
+	if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		ucontext->sq_db_mmap_entry = NULL;
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		ucontext->cq_db_mmap_entry = NULL;
+		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
+		ucontext->srq_db_mmap_entry = NULL;
+		return -EFAULT;
+	}
+
+	atomic_set(&ucontext->tx_port_affinity,
+		   atomic_add_return(1, &zdev->tx_port_affinity));
+
+	INIT_LIST_HEAD(&ucontext->cq_reg_mem_list);
+	spin_lock_init(&ucontext->cq_reg_mem_list_lock);
+	INIT_LIST_HEAD(&ucontext->qp_reg_mem_list);
+	spin_lock_init(&ucontext->qp_reg_mem_list_lock);
+	INIT_LIST_HEAD(&ucontext->srq_reg_mem_list);
+	spin_lock_init(&ucontext->srq_reg_mem_list_lock);
+
+	return 0;
+}
+
+static int zxdh_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct zxdh_pd *zpd = to_zpd(ibpd);
+	struct zxdh_device *zdev = to_zdev(ibpd->device);
+
+	zxdh_free_rsrc(zdev->rf, zdev->rf->allocated_pds, zpd->sc_pd.pd_id);
+	return 0;
+}
+
+static void zxdh_dealloc_ucontext(struct ib_ucontext *context)
+{
+	struct zxdh_ucontext *ucontext = to_ucontext(context);
+
+	if (!ucontext)
+		return;
+
+	if (ucontext->sq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		ucontext->sq_db_mmap_entry = NULL;
+	}
+	if (ucontext->cq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		ucontext->cq_db_mmap_entry = NULL;
+	}
+	if (ucontext->srq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
+		ucontext->srq_db_mmap_entry = NULL;
+	}
+}
+
+static void zxdh_mmap_free(struct rdma_user_mmap_entry *entry)
+{
+	struct zxdh_user_mmap_entry *zentry = to_zxdh_mmap_entry(entry);
+
+	kfree(zentry);
+}
+
+static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct rdma_user_mmap_entry *rdma_entry;
+	struct zxdh_user_mmap_entry *entry;
+	struct zxdh_ucontext *ucontext;
+	u64 pfn;
+	int ret;
+
+	ucontext = to_ucontext(context);
+
+	rdma_entry = rdma_user_mmap_entry_get(&ucontext->ibucontext, vma);
+	if (!rdma_entry) {
+		pr_err("zrdma: pgoff[0x%lx] does not have valid entry\n",
+		       vma->vm_pgoff);
+		return -EINVAL;
+	}
+
+	entry = to_zxdh_mmap_entry(rdma_entry);
+
+	pfn = (entry->bar_offset +
+	       pci_resource_start(ucontext->zdev->rf->pcidev, 0)) >>
+	      PAGE_SHIFT;
+
+	switch (entry->mmap_flag) {
+	case ZXDH_MMAP_IO_NC:
+		ret = rdma_user_mmap_io(context, vma, pfn, PAGE_SIZE,
+					pgprot_noncached(vma->vm_page_prot),
+					rdma_entry);
+		break;
+	case ZXDH_MMAP_IO_NC_BY_SIZE:
+		ret = rdma_user_mmap_io(context, vma, pfn,
+					vma->vm_end - vma->vm_start,
+					pgprot_noncached(vma->vm_page_prot),
+					rdma_entry);
+		break;
+	case ZXDH_MMAP_IO_WC:
+		ret = rdma_user_mmap_io(context, vma, pfn, PAGE_SIZE,
+					pgprot_writecombine(vma->vm_page_prot),
+					rdma_entry);
+		break;
+	default:
+		pr_err("zrdma: unsupported mmap_flag[%d]\n",
+		       entry->mmap_flag);
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		pr_err("zrdma: bar_offset [0x%llx] mmap_flag[%d] err[%d]\n",
+		       entry->bar_offset, entry->mmap_flag, ret);
+
+	rdma_user_mmap_entry_put(rdma_entry);
+
+	return ret;
+}
+
 const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
 	.uverbs_abi_ver = ZXDH_ABI_VER,
 	.dealloc_driver = zxdh_ib_dealloc_device,
+	.alloc_pd = zxdh_alloc_pd,
+	.alloc_ucontext = zxdh_alloc_ucontext,
+	.dealloc_pd = zxdh_dealloc_pd,
+	.dealloc_ucontext = zxdh_dealloc_ucontext,
 	.query_device = zxdh_query_device,
 	.query_port = zxdh_query_port,
 	.query_pkey = zxdh_query_pkey,
 	.get_link_layer = zxdh_get_link_layer,
 	.get_port_immutable = zxdh_roce_port_immutable,
 	.get_dev_fw_str = zxdh_get_dev_fw_str,
+	.mmap = zxdh_mmap,
+	.mmap_free = zxdh_mmap_free,
+
+	INIT_RDMA_OBJ_SIZE(ib_pd, zxdh_pd, ibpd),
+	INIT_RDMA_OBJ_SIZE(ib_ucontext, zxdh_ucontext, ibucontext),
 };
-- 
2.43.5


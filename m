Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684A042B33E;
	Tue, 11 Aug 2026 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441381; cv=none; b=qygCaE2FCytMDjEAZsMmeAV1AxMYcNiHw1n80X+lfEf1MvN9XyWVPIUrx4ozmLJCyEe44MTUJo+WqhLwSU/l3D+QnI0thAUiu90huGuGi4nZEokeyEDhLFJ5HLyyzyLsPTiUPiTAA8vaci2ZbLWDn/eVNAKkZjxzL5R+iZULmPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441381; c=relaxed/simple;
	bh=orndQq12vEmFMBEGGIFlyhuzxnppMtEakXAYWkLTD10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trUB2gL8gD4ulsl0pLD37ItFbwEUzR7OlumxL0qgOsGHwifMjMT3BSPQhIPuUWmLqXTz1v6H6Swq48CTADFYjn8B1ud4X2zvo5AzwqbZLN8kHg+t+H+QBQQ4JXLVNTmh0O9lq4fHBnZWsTQJGfzryC0VjPh/MOPSf2fUl9p4Zv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hK69m6YNSz58fdM;
	Tue, 11 Aug 2026 17:42:52 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 67B9gh1U073927;
	Tue, 11 Aug 2026 17:42:43 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:45 +0800
X-Zmail-TransId: 3e816a7aee95013-444ad
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 6/7] RDMA/zrdma: Implement context, PD, and mmap operations
Date: Tue, 11 Aug 2026 17:37:39 +0800
Message-ID: <20260811093740.2607476-7-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 67B9gh1U073927
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 11 Aug 2026 17:42:52 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEE9C.000/4hK69m6YNSz58fdM

Add implementation for allocation/deallocation of Protection Domains (PD),
User Contexts, and memory mapping (mmap) for doorbells. This patch also
includes the basic device initialization logic required for registration.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 347 +++++++++++++++++++++-
 1 file changed, 339 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 6db536c94e01..2194d34b6438 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -7,24 +7,353 @@
 #include "zrdma_main.h"
 #include "zrdma_verbs.h"
 #include "zrdma_ctrl.h"
+#include <rdma/ib_mad.h>
+#include <rdma/ib_cache.h>
+#include <rdma/ib_user_verbs.h>
+#include <linux/etherdevice.h>
 
-static const struct ib_device_ops zxdh_dev_ops = {
-	.owner = THIS_MODULE,
-	.driver_id = RDMA_DRIVER_ZRDMA,
-	.uverbs_abi_ver = ZXDH_ABI_VER,
-};
+static void zxdh_sc_pd_init(struct zxdh_sc_dev *dev, struct zxdh_sc_pd *pd,
+			    u32 pd_id, int abi_ver)
+{
+	pd->pd_id = pd_id;
+	pd->abi_ver = abi_ver;
+	pd->dev = dev;
+}
+
+static void zxdh_ib_dealloc_device(struct ib_device *ibdev)
+{
+	struct zxdh_device *zdev = to_zdev(ibdev);
+
+	kfree(zdev->rf);
+	zdev->rf = NULL;
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
+	err = zxdh_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
+			      &rf->next_pd);
+	if (err) {
+		pr_warn("zrdma: zxdh_alloc_rsrc failed err=%d\n", err);
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
+		if (ib_copy_to_udata(udata, &uresp,
+				     min(sizeof(uresp), udata->outlen))) {
+			err = -EFAULT;
+			goto error;
+		}
+	} else {
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
+zxdh_user_mmap_entry_insert(struct zxdh_ucontext *ucontext, u64 bar_offset,
+			    enum zxdh_mmap_flag mmap_flag, u64 *mmap_offset)
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
+					  &entry->rdma_entry, PAGE_SIZE);
+	if (ret) {
+		kfree(entry);
+		return NULL;
+	}
+	*mmap_offset = rdma_user_mmap_get_offset(&entry->rdma_entry);
+
+	return &entry->rdma_entry;
+}
+
+static struct rdma_user_mmap_entry *
+zxdh_mp_mmap_entry_insert(struct zxdh_ucontext *ucontext, u64 phy_addr,
+			  size_t length, enum zxdh_mmap_flag mmap_flag,
+			  u64 *mmap_offset)
+{
+	struct zxdh_user_mmap_entry *entry =
+		kzalloc(sizeof(*entry), GFP_KERNEL);
+	int ret;
+
+	if (!entry)
+		return NULL;
+
+	entry->bar_offset = phy_addr;
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
+static int zxdh_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
+{
+	struct zxdh_ucontext *ucontext = to_ucontext(uctx);
+	struct zxdh_alloc_ucontext_resp uresp = {};
+	struct ib_device *ibdev = uctx->device;
+	struct zxdh_device *zdev = to_zdev(ibdev);
+	struct zxdh_alloc_ucontext_req req = {};
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
+	ucontext->zdev = zdev;
+	ucontext->abi_ver = req.userspace_ver;
+
+	uresp.srq_db_bar_off = SRQ_DB_OFFSET;
+
+	ucontext->sq_db_mmap_entry =
+		zxdh_user_mmap_entry_insert(ucontext, SQ_DB_BAR_OFF,
+					    ZXDH_MMAP_IO_NC,
+					    &uresp.sq_db_mmap_key);
+	if (!ucontext->sq_db_mmap_entry)
+		return -ENOMEM;
+
+	ucontext->cq_db_mmap_entry =
+		zxdh_user_mmap_entry_insert(ucontext, CQ_DB_BAR_OFF,
+					    ZXDH_MMAP_IO_NC,
+					    &uresp.cq_db_mmap_key);
+	if (!ucontext->cq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		return -ENOMEM;
+	}
+
+	if (ucontext->abi_ver == ZXDH_CONTEXT_VER_V1 ||
+	    ucontext->abi_ver == ZXDH_CONTEXT_VER_V2) {
+		ucontext->srq_db_mmap_entry =
+			zxdh_mp_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
+						  PAGE_SIZE,
+						  ZXDH_MMAP_IO_NC_BY_SIZE,
+						  &uresp.srq_db_mmap_key);
+	} else {
+		ucontext->srq_db_mmap_entry =
+			zxdh_mp_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
+						  SRQ_DB_MMAP_SIZE,
+						  ZXDH_MMAP_IO_NC_BY_SIZE,
+						  &uresp.srq_db_mmap_key);
+	}
+	if (!ucontext->srq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		pr_err("zrdma: srq_db_mmap_entry is NULL!\n");
+		return -ENOMEM;
+	}
+
+	uresp.srq_db_mmap_size = SRQ_DB_MMAP_SIZE;
+	uresp.kernel_ver = ZXDH_CONTEXT_VER_V3;
+	uresp.hw_rev = ZXDH_GEN_2;
+	uresp.chip_rev = CHIP_VERSION;
+	uresp.rdma_tool_flags =
+		ZXDH_QP_EXTEND_OP | ZXDH_CAPTURE | ZXDH_GET_HW_DATA |
+		ZXDH_GET_HW_OBJECT_DATA | ZXDH_CHECK_HW_HEALTH |
+		ZXDH_RDMA_TOOL_CFG_DEV_PARAM | ZXDH_RDMA_TOOL_READ_RAM |
+		ZXDH_RDMA_TOOL_DEVX_MODIFY_CQ | ZXDH_RDMA_SET_CREDIT_CAP |
+		ZXDH_RDMA_SWITCH | ZXDH_RDMA_TOOL_DEVX_EXT_MEM |
+		ZXDH_RDMA_TOOL_PRIV_EXT;
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
+	if (ib_copy_to_udata(udata, &uresp,
+			     min(sizeof(uresp), udata->outlen))) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
+		return -EFAULT;
+	}
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
+	if (ucontext->sq_db_mmap_entry)
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+	if (ucontext->cq_db_mmap_entry)
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+	if (ucontext->srq_db_mmap_entry)
+		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
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
+		pr_err("[zxdh_rdma] VERBS: unsupported mmap_flag[%d]\n",
+		       entry->mmap_flag);
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		pr_err("[zxdh_rdma] VERBS: bar_offset [0x%llx] mmap_flag[%d] err[%d]\n",
+		       entry->bar_offset, entry->mmap_flag, ret);
+
+	rdma_user_mmap_entry_put(rdma_entry);
+
+	return ret;
+}
+
+static void zxdh_init_roce_device(struct zxdh_device *zdev)
+{
+	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
+	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
+			    zdev->netdev->dev_addr);
+}
 
 static int zxdh_init_rdma_device(struct zxdh_device *zdev)
 {
+	struct pci_dev *pcidev = zdev->rf->pcidev;
+
+	if (zdev->roce_mode)
+		zxdh_init_roce_device(zdev);
+	else
+		return -EPFNOSUPPORT;
+
 	zdev->ibdev.phys_port_cnt = 1;
 	zdev->ibdev.num_comp_vectors = zdev->rf->ceqs_count;
-	zdev->ibdev.dev.parent = &zdev->rf->pcidev->dev;
-
-	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
+	zdev->ibdev.dev.parent = &pcidev->dev;
 
 	return 0;
 }
 
+static const struct ib_device_ops zxdh_dev_ops = {
+	.owner = THIS_MODULE,
+	.driver_id = RDMA_DRIVER_ZRDMA,
+	.uverbs_abi_ver = ZXDH_ABI_VER,
+	.alloc_pd = zxdh_alloc_pd,
+	.alloc_ucontext = zxdh_alloc_ucontext,
+	.dealloc_driver = zxdh_ib_dealloc_device,
+	.dealloc_pd = zxdh_dealloc_pd,
+	.dealloc_ucontext = zxdh_dealloc_ucontext,
+	.mmap = zxdh_mmap,
+	.mmap_free = zxdh_mmap_free,
+
+	INIT_RDMA_OBJ_SIZE(ib_pd, zxdh_pd, ibpd),
+	INIT_RDMA_OBJ_SIZE(ib_ucontext, zxdh_ucontext, ibucontext),
+};
+
 int zxdh_ib_register_device(struct zxdh_device *zdev)
 {
 	int ret;
@@ -33,6 +362,8 @@ int zxdh_ib_register_device(struct zxdh_device *zdev)
 	if (ret)
 		return ret;
 
+	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
+
 	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
 	if (ret)
 		pr_err("zrdma: Register RDMA device fail\n");
-- 
2.27.0


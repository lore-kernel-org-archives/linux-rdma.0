Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067766;
	b=KzU7w8JRUQMCxrZKxf83wgB6OrdtYjqyaeGgF/63b1zrWZVWGLiGcO3EVAb5lsVnEWl1
	 071xAswd9P6rA4uJ9oOnBxoUYkO6BxIFIh3lWxl7q8vaf1HPjY9vIMyD+9IqsW2PCOiRl
	 oK0I8/Sc3D3O6Gpd8qs+HxC2Ivusa/6nG1jhUFr9iljQnVJqsRWlEi3K31dVTyJHLdqHb
	 ChnrmoIXCRJoG84to4kQG1jlYfHJx+pptAQvQN04wqmf7uN1EM5FlOa5g262jwuipajU/
	 VdpMTRRJ/dZyqQ4K3E+fnrXH5ba1NPztkbXNT46b5UY0fxh3Zuo0gJ8D4TIoePyA+Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067766;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=sJoVS9pF5YHyL/dm89+RlfKRd/ZXTVWGaYne7AmwE0A=;
	b=jJTAtWVhz9RzBnK48T5+ydsVr96j4Y6+Z/zqtwxDy6lO8q+PAOLwwxQv/Nv80YPE9gDT
	 wcnO4OdEdUzXTkCAqC9b9MblVY5UC2dwWm2gvpCNP4kHq1yjjhCZLb6HsrbHfRlxqxqNA
	 2hsWMzDAI4oDYeQIqk998armPme7Gv3gr74I6wHERsG5yna7kS9teqIz/nX2gaU0s5Dm2
	 Fl9DQazoAC1rh36XskgZYBvFvgUNm25fbyMOVmKSFitdOJ0aDgTrNnw0rXteQt+WNORQ8
	 tKgfY1vb9mWgObBmvP5em4ZIm4kxbPHeV2z/NZ66UlOS46Lvfciv92lc35pat0xvZzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AA0606A31B;
	Tue, 27 Oct 2026 02:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0AA0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jDDmL2hDBz5B7RR;
	Tue, 27 Oct 2026 10:22:42 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 69R2MTp9088282;
	Tue, 27 Oct 2026 10:22:29 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 27 Oct 2026 10:22:30 +0800
X-Zmail-TransId: 3e816ae00ae6027-4be75
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v7 6/7] RDMA/zrdma: Implement context, PD, and mmap operations
Date: Tue, 27 Oct 2026 10:11:18 +0800
Message-ID: <20261027021119.2325798-7-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 69R2MTp9088282
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 27 Oct 2026 10:22:42 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE00AF2.001/4jDDmL2hDBz5B7RR

Add implementation for allocation/deallocation of Protection Domains (PD),
User Contexts, and memory mapping (mmap) for doorbells. This patch also
includes the basic device initialization logic required for registration.

The SRQ doorbell area is not page aligned on 16K and 64K page systems, so
the mapping length is extended to the page boundary and the size
reported to userspace is the very same length. Otherwise the tail of the
doorbell area would fall outside of the mapping and the mmap would be
rejected by rdma_user_mmap_entry_get().

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 355 +++++++++++++++++++++-
 1 file changed, 347 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index d47dfafa717a..abac97e69413 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -7,13 +7,10 @@
 #include "zrdma_main.h"
 #include "zrdma_verbs.h"
 #include "zrdma_ctrl.h"
-
-const struct ib_device_ops zxdh_dev_ops = {
-	.owner = THIS_MODULE,
-	.driver_id = RDMA_DRIVER_ZRDMA,
-	.uverbs_abi_ver = ZXDH_ABI_VER,
-	.dealloc_driver = zxdh_ib_dealloc_device,
-};
+#include <rdma/ib_mad.h>
+#include <rdma/ib_cache.h>
+#include <rdma/ib_user_verbs.h>
+#include <linux/etherdevice.h>
 
 /* Release everything the probe path may have allocated. The hook is
  * called from ib_dealloc_device(), so it must tolerate a partially
@@ -43,11 +40,337 @@ void zxdh_ib_dealloc_device(struct ib_device *ibdev)
 	zdev->hdl = NULL;
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
+	ucontext->zdev = zdev;
+	ucontext->abi_ver = req.userspace_ver;
+
+	uresp.srq_db_bar_off = SRQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
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
+	/* The mapping length and the size reported to userspace have to
+	 * match, otherwise rdma_user_mmap_entry_get() rejects the mmap.
+	 */
+	if (ucontext->abi_ver == ZXDH_CONTEXT_VER_V1 ||
+	    ucontext->abi_ver == ZXDH_CONTEXT_VER_V2)
+		srq_db_mmap_size = PAGE_SIZE;
+	else
+		srq_db_mmap_size = zxdh_get_srq_db_mmap_size();
+
+	ucontext->srq_db_mmap_entry =
+		zxdh_mp_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
+					  srq_db_mmap_size,
+					  ZXDH_MMAP_IO_NC_BY_SIZE,
+					  &uresp.srq_db_mmap_key);
+	if (!ucontext->srq_db_mmap_entry) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
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
+	if (ib_copy_to_udata(udata, &uresp,
+			     min(sizeof(uresp), udata->outlen))) {
+		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
+		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
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
+
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
+	zdev->ibdev.dev.parent = &pcidev->dev;
 
 	return 0;
 }
@@ -66,3 +389,19 @@ int zxdh_ib_register_device(struct zxdh_device *zdev)
 
 	return ret;
 }
+
+const struct ib_device_ops zxdh_dev_ops = {
+	.owner = THIS_MODULE,
+	.driver_id = RDMA_DRIVER_ZRDMA,
+	.uverbs_abi_ver = ZXDH_ABI_VER,
+	.dealloc_driver = zxdh_ib_dealloc_device,
+	.alloc_pd = zxdh_alloc_pd,
+	.alloc_ucontext = zxdh_alloc_ucontext,
+	.dealloc_pd = zxdh_dealloc_pd,
+	.dealloc_ucontext = zxdh_dealloc_ucontext,
+	.mmap = zxdh_mmap,
+	.mmap_free = zxdh_mmap_free,
+
+	INIT_RDMA_OBJ_SIZE(ib_pd, zxdh_pd, ibpd),
+	INIT_RDMA_OBJ_SIZE(ib_ucontext, zxdh_ucontext, ibucontext),
+};
-- 
2.27.0


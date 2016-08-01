From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 3/7] IB/core: Helpers for mapping DMA-BUF in MRs
Date: Mon,  1 Aug 2016 09:57:29 +0300
Message-ID: <1470034653-9097-4-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

DMA-BUF API allows devices to export buffers for other devices to
access. This can provide a means to implement peer to peer communication
for RDMA. A device with internal memory would expose its memory to the
PCIe BAR, and export that region as a DMA-BUF object. Then, the user or
ULP would register a memory region that is backed by the DMA-BUF object.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 60 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |  9 +++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6298f54b4137..633831e77a62 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -44,6 +44,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <net/addrconf.h>
+#include <linux/dma-buf.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -1922,3 +1923,62 @@ void ib_drain_qp(struct ib_qp *qp)
 		ib_drain_rq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
+
+int ib_mr_attach_dmabuf(struct ib_mr *mr, struct dma_buf *dmabuf, int access)
+{
+	struct device *dev = mr->device->dma_device;
+	struct dma_buf_attachment *attach;
+	struct sg_table *sg;
+	int err;
+	int n;
+
+	get_dma_buf(dmabuf);
+
+	attach = dma_buf_attach(dmabuf, dev);
+	if (IS_ERR(attach)) {
+		dev_err(dev, "unable to attach to DMA-BUF object (from %s): %ld",
+			dmabuf->exp_name, PTR_ERR(attach));
+		err = PTR_ERR(attach);
+		goto put_dma_buf;
+	}
+
+	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sg)) {
+		dev_err(dev, "unable to map a DMA-BUF object (from %s): %ld",
+			dmabuf->exp_name, PTR_ERR(sg));
+		err = PTR_ERR(sg);
+		goto detach;
+	}
+
+	n = ib_map_mr_sg_zbva(mr, sg->sgl, sg->nents, NULL, PAGE_SIZE);
+	if (unlikely(n != sg->nents)) {
+		dev_err(dev, "failed to map sg (%d/%d) of DMA-BUF object (from %s)\n",
+			n, sg->nents, dmabuf->exp_name);
+		err = n < 0 ? n : -EINVAL;
+		goto unmap;
+	}
+
+	mr->attach = attach;
+	mr->sg = sg;
+	return 0;
+
+unmap:
+	dma_buf_unmap_attachment(attach, sg, DMA_BIDIRECTIONAL);
+detach:
+	dma_buf_detach(dmabuf, attach);
+put_dma_buf:
+	dma_buf_put(dmabuf);
+	return err;
+}
+EXPORT_SYMBOL(ib_mr_attach_dmabuf);
+
+void ib_mr_detach_dmabuf(struct dma_buf_attachment *attach,
+			 struct sg_table *sg)
+{
+	struct dma_buf *dmabuf = attach->dmabuf;
+
+	dma_buf_unmap_attachment(attach, sg, DMA_BIDIRECTIONAL);
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+EXPORT_SYMBOL(ib_mr_detach_dmabuf);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7e440d41487a..da23ec0a06d7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1465,6 +1465,9 @@ struct ib_mr {
 		struct ib_uobject	*uobject;	/* user */
 		struct list_head	qp_entry;	/* FR */
 	};
+	/* For MRs that expose a DMA-BUF */
+	struct dma_buf_attachment *attach;
+	struct sg_table *sg;
 };
 
 struct ib_mw {
@@ -3189,4 +3192,10 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
 void ib_drain_qp(struct ib_qp *qp);
+
+struct dma_buf;
+int ib_mr_attach_dmabuf(struct ib_mr *mr, struct dma_buf *dmabuf, int access);
+void ib_mr_detach_dmabuf(struct dma_buf_attachment *attach,
+			 struct sg_table *sg);
+
 #endif /* IB_VERBS_H */
-- 
1.7.11.2

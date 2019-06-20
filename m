From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 20/28] IB/core: Introduce API for initializing a RW ctx from a DMA address
Date: Thu, 20 Jun 2019 10:12:32 -0600
Message-ID: <20190620161240.22738-21-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Introduce rdma_rw_ctx_dma_init() and rdma_rw_ctx_dma_destroy() which
peform the same operation as rdma_rw_ctx_init() and
rdma_rw_ctx_destroy() respectively except they operate on a DMA
address and length instead of an SGL.

This will be used for struct page-less P2PDMA, but there's also
been opinions expressed to migrate away from SGLs and struct
pages in the RDMA APIs and this will likely fit with that
effort.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/infiniband/core/rw.c | 74 ++++++++++++++++++++++++++++++------
 include/rdma/rw.h            |  6 +++
 2 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 32ca8429eaae..cefa6b930bc8 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -319,6 +319,39 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_rw_ctx_init);
 
+/**
+ * rdma_rw_ctx_dma_init - initialize a RDMA READ/WRITE context from a
+ *	DMA address instead of SGL
+ * @ctx:	context to initialize
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @addr:	DMA address to READ/WRITE from/to
+ * @len:	length of memory to operate on
+ * @remote_addr:remote address to read/write (relative to @rkey)
+ * @rkey:	remote key to operate on
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ *
+ * Returns the number of WQEs that will be needed on the workqueue if
+ * successful, or a negative error code.
+ */
+int rdma_rw_ctx_dma_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, dma_addr_t addr, u32 len, u64 remote_addr,
+		u32 rkey, enum dma_data_direction dir)
+{
+	struct scatterlist sg;
+
+	sg_dma_address(&sg) = addr;
+	sg_dma_len(&sg) = len;
+
+	if (rdma_rw_io_needs_mr(qp->device, port_num, dir, 1))
+		return rdma_rw_init_mr_wrs(ctx, qp, port_num, &sg, 1, 0,
+					   remote_addr, rkey, dir);
+	else
+		return rdma_rw_init_single_wr(ctx, qp, &sg, 0, remote_addr,
+					      rkey, dir);
+}
+EXPORT_SYMBOL(rdma_rw_ctx_dma_init);
+
 /**
  * rdma_rw_ctx_signature_init - initialize a RW context with signature offload
  * @ctx:	context to initialize
@@ -566,17 +599,7 @@ int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_rw_ctx_post);
 
-/**
- * rdma_rw_ctx_destroy - release all resources allocated by rdma_rw_ctx_init
- * @ctx:	context to release
- * @qp:		queue pair to operate on
- * @port_num:	port num to which the connection is bound
- * @sg:		scatterlist that was used for the READ/WRITE
- * @sg_cnt:	number of entries in @sg
- * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
- */
-void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
-		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir)
+static void __rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp)
 {
 	int i;
 
@@ -596,6 +619,21 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		BUG();
 		break;
 	}
+}
+
+/**
+ * rdma_rw_ctx_destroy - release all resources allocated by rdma_rw_ctx_init
+ * @ctx:	context to release
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @sg:		scatterlist that was used for the READ/WRITE
+ * @sg_cnt:	number of entries in @sg
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ */
+void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir)
+{
+	__rdma_rw_ctx_destroy(ctx, qp);
 
 	/* P2PDMA contexts do not need to be unmapped */
 	if (!is_pci_p2pdma_page(sg_page(sg)))
@@ -603,6 +641,20 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
+/**
+ * rdma_rw_ctx_dma_destroy - release all resources allocated by
+ *	rdma_rw_ctx_dma_init
+ * @ctx:	context to release
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ */
+void rdma_rw_ctx_dma_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+			     u8 port_num)
+{
+	__rdma_rw_ctx_destroy(ctx, qp);
+}
+EXPORT_SYMBOL(rdma_rw_ctx_dma_destroy);
+
 /**
  * rdma_rw_ctx_destroy_signature - release all resources allocated by
  *	rdma_rw_ctx_init_signature
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index 494f79ca3e62..e47f8053af6e 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -58,6 +58,12 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt,
 		enum dma_data_direction dir);
 
+int rdma_rw_ctx_dma_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, dma_addr_t addr, u32 len, u64 remote_addr,
+		u32 rkey, enum dma_data_direction dir);
+void rdma_rw_ctx_dma_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+			     u8 port_num);
+
 int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
 		struct scatterlist *prot_sg, u32 prot_sg_cnt,
-- 
2.20.1

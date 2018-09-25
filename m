From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 12/13] nvmet: Introduce helper functions to allocate and
 free request SGLs
Date: Tue, 25 Sep 2018 10:22:30 -0600
Message-ID: <20180925162231.4354-13-logang@deltatee.com>
References: <20180925162231.4354-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180925162231.4354-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add helpers to allocate and free the SGL in a struct nvmet_req:

int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq)
void nvmet_req_free_sgl(struct nvmet_req *req)

This will be expanded in a future patch to implement peer-to-peer
memory DMAs and should be common with all target drivers. The presently
unused 'sq' argument in the alloc function will be necessary to
decide whether to use peer-to-peer memory and obtain the correct
provider to allocate the memory.

The new helpers are used in nvmet-rdma. Seeing we use req.transfer_len
as the length of the SGL it is set earlier and cleared on any error.
It also seems to be unnecessary to accumulate the length as the map_sgl
functions should only ever be called once per request.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/target/core.c  | 18 ++++++++++++++++++
 drivers/nvme/target/nvmet.h |  2 ++
 drivers/nvme/target/rdma.c  | 20 ++++++++++++--------
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index b5ec96abd048..bddd1599b826 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -725,6 +725,24 @@ void nvmet_req_execute(struct nvmet_req *req)
 }
 EXPORT_SYMBOL_GPL(nvmet_req_execute);
 
+int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq)
+{
+	req->sg = sgl_alloc(req->transfer_len, GFP_KERNEL, &req->sg_cnt);
+	if (!req->sg)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvmet_req_alloc_sgl);
+
+void nvmet_req_free_sgl(struct nvmet_req *req)
+{
+	sgl_free(req->sg);
+	req->sg = NULL;
+	req->sg_cnt = 0;
+}
+EXPORT_SYMBOL_GPL(nvmet_req_free_sgl);
+
 static inline bool nvmet_cc_en(u32 cc)
 {
 	return (cc >> NVME_CC_EN_SHIFT) & 0x1;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index ec9af4ee03b6..7d6cb61021e4 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -336,6 +336,8 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 void nvmet_req_uninit(struct nvmet_req *req);
 void nvmet_req_execute(struct nvmet_req *req);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
+int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq);
+void nvmet_req_free_sgl(struct nvmet_req *req);
 
 void nvmet_cq_setup(struct nvmet_ctrl *ctrl, struct nvmet_cq *cq, u16 qid,
 		u16 size);
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index bfc4da660bb4..b0d0cedc74bb 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -503,7 +503,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	}
 
 	if (rsp->req.sg != rsp->cmd->inline_sg)
-		sgl_free(rsp->req.sg);
+		nvmet_req_free_sgl(&rsp->req);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
@@ -652,24 +652,24 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 {
 	struct rdma_cm_id *cm_id = rsp->queue->cm_id;
 	u64 addr = le64_to_cpu(sgl->addr);
-	u32 len = get_unaligned_le24(sgl->length);
 	u32 key = get_unaligned_le32(sgl->key);
 	int ret;
 
+	rsp->req.transfer_len = get_unaligned_le24(sgl->length);
+
 	/* no data command? */
-	if (!len)
+	if (!rsp->req.transfer_len)
 		return 0;
 
-	rsp->req.sg = sgl_alloc(len, GFP_KERNEL, &rsp->req.sg_cnt);
-	if (!rsp->req.sg)
-		return NVME_SC_INTERNAL;
+	ret = nvmet_req_alloc_sgl(&rsp->req, &rsp->queue->nvme_sq);
+	if (ret < 0)
+		goto error_out;
 
 	ret = rdma_rw_ctx_init(&rsp->rw, cm_id->qp, cm_id->port_num,
 			rsp->req.sg, rsp->req.sg_cnt, 0, addr, key,
 			nvmet_data_dir(&rsp->req));
 	if (ret < 0)
-		return NVME_SC_INTERNAL;
-	rsp->req.transfer_len += len;
+		goto error_out;
 	rsp->n_rdma += ret;
 
 	if (invalidate) {
@@ -678,6 +678,10 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 	}
 
 	return 0;
+
+error_out:
+	rsp->req.transfer_len = 0;
+	return NVME_SC_INTERNAL;
 }
 
 static u16 nvmet_rdma_map_sgl(struct nvmet_rdma_rsp *rsp)
-- 
2.19.0

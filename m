From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 12/14] nvmet: Introduce helper functions to allocate and
 free request SGLs
Date: Mon, 23 Apr 2018 17:30:44 -0600
Message-ID: <20180423233046.21476-13-logang@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180423233046.21476-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add helpers to allocate and free the SGL in a struct nvmet_req:

int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq)
void nvmet_req_free_sgl(struct nvmet_req *req)

This will be expanded in a future patch to implement peer-to-peer
memory DMAs and should be common with all target drivers. The presently
unused 'sq' argument in the alloc function will be necessary to
decide whether to use peer-to-peer memory and obtain the correct
provider to allocate the memory.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/core.c  | 18 ++++++++++++++++++
 drivers/nvme/target/nvmet.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e95424f172fd..75d44bc3e8d3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -575,6 +575,24 @@ void nvmet_req_execute(struct nvmet_req *req)
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
index 15fd84ab21f8..10b162615a5e 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -273,6 +273,8 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 void nvmet_req_uninit(struct nvmet_req *req);
 void nvmet_req_execute(struct nvmet_req *req);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
+int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq);
+void nvmet_req_free_sgl(struct nvmet_req *req);
 
 void nvmet_cq_setup(struct nvmet_ctrl *ctrl, struct nvmet_cq *cq, u16 qid,
 		u16 size);
-- 
2.11.0

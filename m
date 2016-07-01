From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 13/18] IB/hfi1: Improve SDMA engine assignment for
 user SDMA
Date: Fri, 01 Jul 2016 16:01:56 -0700
Message-ID: <20160701230155.20160.89455.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently each user context is assigned a single SDMA engine
based on the VL, context id, and subcontext id. That means for
MPI applications, each rank can only use one SDMA engine for
all messages. This may create unwanted backup for independent
messages going to different destinations upon congestion at one
destination.

This patch adds the packet "dlid" to the formula of SDMA engine
selection for user SDMA requests. A simple hash table is used
to maintain even distribution among the available SDMA engines
regardless how the "dlid" values are distributed.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 47ffd27..d16ed52 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -496,6 +496,27 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 	return 0;
 }
 
+static u8 dlid_to_selector(u16 dlid)
+{
+	static u8 mapping[256];
+	static int initialized;
+	static u8 next;
+	int hash;
+
+	if (!initialized) {
+		memset(mapping, 0xFF, 256);
+		initialized = 1;
+	}
+
+	hash = ((dlid >> 8) ^ dlid) & 0xFF;
+	if (mapping[hash] == 0xFF) {
+		mapping[hash] = next;
+		next = (next + 1) & 0x7F;
+	}
+
+	return mapping[hash];
+}
+
 int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 				   unsigned long dim, unsigned long *count)
 {
@@ -511,6 +532,8 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	struct user_sdma_request *req;
 	u8 opcode, sc, vl;
 	int req_queued = 0;
+	u16 dlid;
+	u8 selector;
 
 	if (iovec[idx].iov_len < sizeof(info) + sizeof(req->hdr)) {
 		hfi1_cdbg(
@@ -686,9 +709,13 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		idx++;
 	}
 
+	dlid = be16_to_cpu(req->hdr.lrh[1]);
+	selector = dlid_to_selector(dlid);
+
 	/* Have to select the engine */
 	req->sde = sdma_select_engine_vl(dd,
-					 (u32)(uctxt->ctxt + fd->subctxt),
+					 (u32)(uctxt->ctxt + fd->subctxt +
+					       selector),
 					 vl);
 	if (!req->sde || !sdma_running(req->sde)) {
 		ret = -ECOMM;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

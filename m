From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/hfi1: Convert kzalloc_node and kcalloc to use
 kcalloc_node
Date: Thu, 01 Feb 2018 12:37:30 -0800
Message-ID: <20180201203727.13590.84553.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Kzalloc_node API doesn't check for overflows in size multiplication.
While kcalloc API check for overflows in size multiplication
but these implementations are not NUMA-aware.

This conversion allowed for correcting an allocation used in the hot
path to be on the local NUMA and ensure us overflow free multiplication
for the size of a memory allocation.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   17 +++++++++--------
 drivers/infiniband/hw/hfi1/pio.c  |   15 ++++++++-------
 drivers/infiniband/hw/hfi1/sdma.c |    3 ++-
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8c4f040..33eba23 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -172,7 +172,7 @@ int hfi1_create_kctxts(struct hfi1_devdata *dd)
 	u16 i;
 	int ret;
 
-	dd->rcd = kzalloc_node(dd->num_rcv_contexts * sizeof(*dd->rcd),
+	dd->rcd = kcalloc_node(dd->num_rcv_contexts, sizeof(*dd->rcd),
 			       GFP_KERNEL, dd->node);
 	if (!dd->rcd)
 		return -ENOMEM;
@@ -439,15 +439,16 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, int numa,
 		 * The resulting value will be rounded down to the closest
 		 * multiple of dd->rcv_entries.group_size.
 		 */
-		rcd->egrbufs.buffers = kzalloc_node(
-			rcd->egrbufs.count * sizeof(*rcd->egrbufs.buffers),
-			GFP_KERNEL, numa);
+		rcd->egrbufs.buffers =
+			kcalloc_node(rcd->egrbufs.count,
+				     sizeof(*rcd->egrbufs.buffers),
+				     GFP_KERNEL, numa);
 		if (!rcd->egrbufs.buffers)
 			goto bail;
-		rcd->egrbufs.rcvtids = kzalloc_node(
-				rcd->egrbufs.count *
-				sizeof(*rcd->egrbufs.rcvtids),
-				GFP_KERNEL, numa);
+		rcd->egrbufs.rcvtids =
+			kcalloc_node(rcd->egrbufs.count,
+				     sizeof(*rcd->egrbufs.rcvtids),
+				     GFP_KERNEL, numa);
 		if (!rcd->egrbufs.rcvtids)
 			goto bail;
 		rcd->egrbufs.size = eager_buffer_size;
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 4c1198b..40dac4d 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -455,8 +455,8 @@ int init_send_contexts(struct hfi1_devdata *dd)
 	dd->hw_to_sw = kmalloc_array(TXE_NUM_CONTEXTS, sizeof(u8),
 					GFP_KERNEL);
 	dd->send_contexts = kcalloc(dd->num_send_contexts,
-					sizeof(struct send_context_info),
-					GFP_KERNEL);
+				    sizeof(struct send_context_info),
+				    GFP_KERNEL);
 	if (!dd->send_contexts || !dd->hw_to_sw) {
 		kfree(dd->hw_to_sw);
 		kfree(dd->send_contexts);
@@ -856,8 +856,9 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 		 * so head == tail can mean empty.
 		 */
 		sc->sr_size = sci->credits + 1;
-		sc->sr = kzalloc_node(sizeof(union pio_shadow_ring) *
-				sc->sr_size, GFP_KERNEL, numa);
+		sc->sr = kcalloc_node(sc->sr_size,
+				      sizeof(union pio_shadow_ring),
+				      GFP_KERNEL, numa);
 		if (!sc->sr) {
 			sc_free(sc);
 			return NULL;
@@ -1958,9 +1959,9 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 	hfi1_init_ctxt(dd->vld[15].sc);
 	dd->vld[15].mtu = enum_to_mtu(OPA_MTU_2048);
 
-	dd->kernel_send_context = kzalloc_node(dd->num_send_contexts *
-					sizeof(struct send_context *),
-					GFP_KERNEL, dd->node);
+	dd->kernel_send_context = kcalloc_node(dd->num_send_contexts,
+					       sizeof(struct send_context *),
+					       GFP_KERNEL, dd->node);
 	if (!dd->kernel_send_context)
 		goto freesc15;
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 37424a8..d8ddbfd 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1389,7 +1389,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		    num_engines, descq_cnt);
 
 	/* alloc memory for array of send engines */
-	dd->per_sdma = kcalloc(num_engines, sizeof(*dd->per_sdma), GFP_KERNEL);
+	dd->per_sdma = kcalloc_node(num_engines, sizeof(*dd->per_sdma),
+				    GFP_KERNEL, dd->node);
 	if (!dd->per_sdma)
 		return ret;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

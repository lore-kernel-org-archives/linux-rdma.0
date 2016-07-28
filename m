From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Handle kzalloc failure in init_pervl_scs
Date: Wed, 27 Jul 2016 21:06:15 -0400
Message-ID: <20160728010614.GA3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Checking the return value of the memory allocation call in
init_pervl_scs() was missed.  Recently the kmalloc() was changed to
kzalloc() which identified the problem.

While fixing this issue 2 other bugs were noticed.  First, the array
being allocated is accessed in the nomem path which can be reached before
it is allocated.  Second, kernel_send_context was not released on error.
Fix both of these by creating a more common memory unwind label structure.

Fixes: 35f6befc8441 ("staging/rdma/hfi1: Add qp to send context mapping for PIO")
Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index a99fccadf624..ac1bf4a73571 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1952,13 +1952,17 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 	dd->vld[15].sc = sc_alloc(dd, SC_VL15,
 				  dd->rcd[0]->rcvhdrqentsize, dd->node);
 	if (!dd->vld[15].sc)
-		goto nomem;
+		return -ENOMEM;
+
 	hfi1_init_ctxt(dd->vld[15].sc);
 	dd->vld[15].mtu = enum_to_mtu(OPA_MTU_2048);
 
 	dd->kernel_send_context = kzalloc_node(dd->num_send_contexts *
 					sizeof(struct send_context *),
 					GFP_KERNEL, dd->node);
+	if (!dd->kernel_send_context)
+		goto freesc15;
+
 	dd->kernel_send_context[0] = dd->vld[15].sc;
 
 	for (i = 0; i < num_vls; i++) {
@@ -2010,12 +2014,21 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 	if (pio_map_init(dd, ppd->port - 1, num_vls, NULL))
 		goto nomem;
 	return 0;
+
 nomem:
-	sc_free(dd->vld[15].sc);
-	for (i = 0; i < num_vls; i++)
+	for (i = 0; i < num_vls; i++) {
 		sc_free(dd->vld[i].sc);
+		dd->vld[i].sc = NULL;
+	}
+
 	for (i = num_vls; i < INIT_SC_PER_VL * num_vls; i++)
 		sc_free(dd->kernel_send_context[i + 1]);
+
+	kfree(dd->kernel_send_context);
+	dd->kernel_send_context = NULL;
+
+freesc15:
+	sc_free(dd->vld[15].sc);
 	return -ENOMEM;
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

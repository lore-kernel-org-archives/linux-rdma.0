From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] ib/ehca: Catch failing ioremap()
Date: Mon, 5 Jul 2010 18:19:25 +0200
Message-ID: <20100705181925.2e34d798@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When ioremap() fails with a NULL pointer, catch the error and pass it to the
caller of create_qp() or create_cq() instead of trying to dereference the NULL
pointer later on.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---

Hi Roland, another patch for 2.6.36...

 drivers/infiniband/hw/ehca/hcp_if.c   |   32 ++++++++++++++++++++++++++++----
 drivers/infiniband/hw/ehca/hcp_phyp.c |   11 +++++------
 drivers/infiniband/hw/ehca/hcp_phyp.h |    2 +-
 3 files changed, 34 insertions(+), 11 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_if.c
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_if.c
@@ -269,6 +269,7 @@ u64 hipz_h_alloc_resource_cq(const struc
 			     struct ehca_cq *cq,
 			     struct ehca_alloc_cq_parms *param)
 {
+	int rc;
 	u64 ret;
 	unsigned long outs[PLPAR_HCALL9_BUFSIZE];
 
@@ -283,8 +284,19 @@ u64 hipz_h_alloc_resource_cq(const struc
 	param->act_nr_of_entries = (u32)outs[3];
 	param->act_pages = (u32)outs[4];
 
-	if (ret == H_SUCCESS)
-		hcp_galpas_ctor(&cq->galpas, 0, outs[5], outs[6]);
+	if (ret == H_SUCCESS) {
+		rc = hcp_galpas_ctor(&cq->galpas, 0, outs[5], outs[6]);
+		if (rc) {
+			ehca_gen_err("Could not establish HW access. rc=%d paddr=%#lx",
+				     rc, outs[5]);
+
+			ehca_plpar_hcall_norets(H_FREE_RESOURCE,
+						adapter_handle.handle,     /* r4 */
+						cq->ipz_cq_handle.handle,  /* r5 */
+						0, 0, 0, 0, 0);
+			ret = H_NO_MEM;
+		}
+	}
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
 		ehca_gen_err("Not enough resources. ret=%lli", ret);
@@ -295,6 +307,7 @@ u64 hipz_h_alloc_resource_cq(const struc
 u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 			     struct ehca_alloc_qp_parms *parms, int is_user)
 {
+	int rc;
 	u64 ret;
 	u64 allocate_controls, max_r10_reg, r11, r12;
 	unsigned long outs[PLPAR_HCALL9_BUFSIZE];
@@ -358,8 +371,19 @@ u64 hipz_h_alloc_resource_qp(const struc
 	parms->rqueue.queue_size =
 		(u32)EHCA_BMASK_GET(H_ALL_RES_QP_RQUEUE_SIZE_PAGES, outs[4]);
 
-	if (ret == H_SUCCESS)
-		hcp_galpas_ctor(&parms->galpas, is_user, outs[6], outs[6]);
+	if (ret == H_SUCCESS) {
+		rc = hcp_galpas_ctor(&parms->galpas, is_user, outs[6], outs[6]);
+		if (rc) {
+			ehca_gen_err("Could not establish HW access. rc=%d paddr=%#lx",
+				     rc, outs[6]);
+
+			ehca_plpar_hcall_norets(H_FREE_RESOURCE,
+						adapter_handle.handle,     /* r4 */
+						parms->qp_handle.handle,  /* r5 */
+						0, 0, 0, 0, 0);
+			ret = H_NO_MEM;
+		}
+	}
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
 		ehca_gen_err("Not enough resources. ret=%lli", ret);
--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_phyp.c
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_phyp.c
@@ -42,10 +42,9 @@
 #include "ehca_classes.h"
 #include "hipz_hw.h"
 
-int hcall_map_page(u64 physaddr, u64 *mapaddr)
+u64 hcall_map_page(u64 physaddr)
 {
-	*mapaddr = (u64)(ioremap(physaddr, EHCA_PAGESIZE));
-	return 0;
+	return (u64)ioremap(physaddr, EHCA_PAGESIZE);
 }
 
 int hcall_unmap_page(u64 mapaddr)
@@ -58,9 +57,9 @@ int hcp_galpas_ctor(struct h_galpas *gal
 		    u64 paddr_kernel, u64 paddr_user)
 {
 	if (!is_user) {
-		int ret = hcall_map_page(paddr_kernel, &galpas->kernel.fw_handle);
-		if (ret)
-			return ret;
+		galpas->kernel.fw_handle = hcall_map_page(paddr_kernel);
+		if (!galpas->kernel.fw_handle)
+			return -ENOMEM;
 	} else
 		galpas->kernel.fw_handle = 0;
 
--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_phyp.h
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_phyp.h
@@ -83,7 +83,7 @@ int hcp_galpas_ctor(struct h_galpas *gal
 
 int hcp_galpas_dtor(struct h_galpas *galpas);
 
-int hcall_map_page(u64 physaddr, u64 * mapaddr);
+u64 hcall_map_page(u64 physaddr);
 
 int hcall_unmap_page(u64 mapaddr);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

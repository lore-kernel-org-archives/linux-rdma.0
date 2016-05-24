From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] IB/hfi1: Fix credit return threshold adjustment
Date: Tue, 24 May 2016 12:51:12 -0700
Message-ID: <20160524195111.19706.76829.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The credit return threshold adjustment on mtu change algorithm does not
take into account all the kernel send contexts that are assigned per VL.
Use the pio send context map to adjust the credit return thresholds for
all the allocated and assigned kernel send contexts based on the MTU
adjustment per VL.

The pio send context map can be changed dynamically based on the actual
number of operational vls which is set by the fabric manager. When this
happens update the credit return threshold values for all the remapped
kernel send contexts.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    7 +++++--
 drivers/infiniband/hw/hfi1/pio.c  |   21 +++++++++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 3b876da..be4fd3e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9777,7 +9777,7 @@ static void set_send_length(struct hfi1_pportdata *ppd)
 	u64 len1 = 0, len2 = (((dd->vld[15].mtu + max_hb) >> 2)
 			      & SEND_LEN_CHECK1_LEN_VL15_MASK) <<
 		SEND_LEN_CHECK1_LEN_VL15_SHIFT;
-	int i;
+	int i, j;
 	u32 thres;
 
 	for (i = 0; i < ppd->vls_supported; i++) {
@@ -9801,7 +9801,10 @@ static void set_send_length(struct hfi1_pportdata *ppd)
 			    sc_mtu_to_threshold(dd->vld[i].sc,
 						dd->vld[i].mtu,
 						dd->rcd[0]->rcvhdrqentsize));
-		sc_set_cr_threshold(dd->vld[i].sc, thres);
+		for (j = 0; j < INIT_SC_PER_VL; j++)
+			sc_set_cr_threshold(
+					pio_select_send_context_vl(dd, j, i),
+					    thres);
 	}
 	thres = min(sc_percent_to_threshold(dd->vld[15].sc, 50),
 		    sc_mtu_to_threshold(dd->vld[15].sc,
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index d5edb1a..d5a9a5c 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1832,6 +1832,7 @@ int pio_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_scontexts)
 	int scontext = 1;
 	int num_kernel_send_contexts = 0;
 	u8 lvl_scontexts[OPA_MAX_VLS];
+	u32 thres;
 	struct pio_vl_map *oldmap, *newmap;
 
 	if (!vl_scontexts) {
@@ -1872,11 +1873,27 @@ int pio_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_scontexts)
 			if (!newmap->map[i])
 				goto bail;
 			newmap->map[i]->mask = (1 << ilog2(sz)) - 1;
-			/* assign send contexts */
+			/*
+			 * assign send contexts and
+			 * adjust credit return threshold
+			 */
 			for (j = 0; j < sz; j++) {
-				if (dd->kernel_send_context[scontext])
+				if (dd->kernel_send_context[scontext]) {
 					newmap->map[i]->ksc[j] =
 					dd->kernel_send_context[scontext];
+					thres = min(sc_percent_to_threshold(
+						    dd->kernel_send_context
+						    [scontext], 50),
+						    sc_mtu_to_threshold(
+						    dd->kernel_send_context
+						    [scontext], dd->vld[i].mtu,
+						    dd->rcd[0]->rcvhdrqentsize)
+						    );
+					sc_set_cr_threshold(
+						dd->
+						kernel_send_context[scontext],
+						thres);
+				}
 				if (++scontext >= first_scontext +
 						  vl_scontexts[i])
 					/* wrap back to first send context */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

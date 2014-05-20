From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v4 5/9] IB/srp: Introduce srp_finish_mapping()
Date: Tue, 20 May 2014 15:05:46 +0200
Message-ID: <537B532A.4060304@acm.org>
References: <537B5286.1060504@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537B5286.1060504-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 42 ++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index be84c94..c2e0ad3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -935,16 +935,6 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
-	if (!state->npages)
-		return 0;
-
-	if (state->npages == 1) {
-		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
-			     target->rkey);
-		state->npages = state->fmr_len = 0;
-		return 0;
-	}
-
 	fmr = ib_fmr_pool_map_phys(dev->fmr_pool, state->pages,
 				   state->npages, io_addr);
 	if (IS_ERR(fmr))
@@ -954,10 +944,32 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	state->nfmr++;
 
 	srp_map_desc(state, 0, state->fmr_len, fmr->fmr->rkey);
-	state->npages = state->fmr_len = 0;
+
 	return 0;
 }
 
+static int srp_finish_mapping(struct srp_map_state *state,
+			      struct srp_target_port *target)
+{
+	int ret = 0;
+
+	if (state->npages == 0)
+		return 0;
+
+	if (state->npages == 1)
+		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
+			     target->rkey);
+	else
+		ret = srp_map_finish_fmr(state, target);
+
+	if (ret == 0) {
+		state->npages = 0;
+		state->fmr_len = 0;
+	}
+
+	return ret;
+}
+
 static void srp_map_update_start(struct srp_map_state *state,
 				 struct scatterlist *sg, int sg_index,
 				 dma_addr_t dma_addr)
@@ -998,7 +1010,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * avoided using FMR on such page fragments.
 	 */
 	if (dma_addr & ~dev->fmr_page_mask || dma_len > dev->fmr_max_size) {
-		ret = srp_map_finish_fmr(state, target);
+		ret = srp_finish_mapping(state, target);
 		if (ret)
 			return ret;
 
@@ -1017,7 +1029,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 
 	while (dma_len) {
 		if (state->npages == SRP_FMR_SIZE) {
-			ret = srp_map_finish_fmr(state, target);
+			ret = srp_finish_mapping(state, target);
 			if (ret)
 				return ret;
 
@@ -1040,7 +1052,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 */
 	ret = 0;
 	if (len != dev->fmr_page_size) {
-		ret = srp_map_finish_fmr(state, target);
+		ret = srp_finish_mapping(state, target);
 		if (!ret)
 			srp_map_update_start(state, NULL, 0, 0);
 	}
@@ -1083,7 +1095,7 @@ backtrack:
 		}
 	}
 
-	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(state, target))
+	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_finish_mapping(state, target))
 		goto backtrack;
 
 	req->nfmr = state->nfmr;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

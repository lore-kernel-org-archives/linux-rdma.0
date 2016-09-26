From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] IB/srp: Avoid that certain sg-lists trigger an infinite
 loop with FMR
Date: Mon, 26 Sep 2016 12:58:49 -0700
Message-ID: <22a7b1b4-1a65-1a92-ef77-6f404de278fd@sandisk.com>
References: <c5bd10df-225d-df4c-c765-97551348dbbd@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c5bd10df-225d-df4c-c765-97551348dbbd-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that mapping an sg-list in which the first element has a
non-zero offset triggers an infinite loop when using FMR. This
patch makes the FMR mapping code similar to that of ib_sg_to_pages().

Note: older Mellanox HCAs do not support non-zero offsets for FMR.
See also commit 8c4037b501ac ("IB/srp: always avoid non-zero offsets
into an FMR").

Reported-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 06bb7a905635..29ec5e2f247e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1416,7 +1416,9 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 
 	while (dma_len) {
 		unsigned offset = dma_addr & ~dev->mr_page_mask;
-		if (state->npages == dev->max_pages_per_mr || offset != 0) {
+
+		if (state->npages == dev->max_pages_per_mr ||
+		    (state->npages > 0 && offset != 0)) {
 			ret = srp_map_finish_fmr(state, ch);
 			if (ret)
 				return ret;
@@ -1433,12 +1435,12 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	}
 
 	/*
-	 * If the last entry of the MR wasn't a full page, then we need to
+	 * If the end of the MR is not on a page boundary then we need to
 	 * close it out and start a new one -- we can only merge at page
 	 * boundaries.
 	 */
 	ret = 0;
-	if (len != dev->mr_page_size)
+	if ((dma_addr & ~dev->mr_page_mask) != 0)
 		ret = srp_map_finish_fmr(state, ch);
 	return ret;
 }
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

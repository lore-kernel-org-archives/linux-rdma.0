From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] IB/hfi1: Pass packet ptr to set_armed_active
Date: Tue,  9 Aug 2016 11:19:55 -0400
Message-ID: <1470755996-14187-2-git-send-email-ira.weiny@intel.com>
References: <1470755996-14187-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470755996-14187-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The "packet" parameter was being passed on the stack,
change it to a pointer.


Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 8246dc7d0573..c4156870a8bb 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -888,14 +888,14 @@ void set_all_slowpath(struct hfi1_devdata *dd)
 }
 
 static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
-				      struct hfi1_packet packet,
+				      struct hfi1_packet *packet,
 				      struct hfi1_devdata *dd)
 {
 	struct work_struct *lsaw = &rcd->ppd->linkstate_active_work;
-	struct hfi1_message_header *hdr = hfi1_get_msgheader(packet.rcd->dd,
-							     packet.rhf_addr);
+	struct hfi1_message_header *hdr = hfi1_get_msgheader(packet->rcd->dd,
+							     packet->rhf_addr);
 
-	if (hdr2sc(hdr, packet.rhf) != 0xf) {
+	if (hdr2sc(hdr, packet->rhf) != 0xf) {
 		int hwstate = read_logical_state(dd);
 
 		if (hwstate != LSTATE_ACTIVE) {
@@ -979,7 +979,7 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 			/* Auto activate link on non-SC15 packet receive */
 			if (unlikely(rcd->ppd->host_link_state ==
 				     HLS_UP_ARMED) &&
-			    set_armed_to_active(rcd, packet, dd))
+			    set_armed_to_active(rcd, &packet, dd))
 				goto bail;
 			last = process_rcv_packet(&packet, thread);
 		}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] IB/hfi1: Validate header in set_armed_active
Date: Tue,  9 Aug 2016 11:19:56 -0400
Message-ID: <1470755996-14187-3-git-send-email-ira.weiny@intel.com>
References: <1470755996-14187-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470755996-14187-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Validate the etype to insure that the header is correct.


Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index c4156870a8bb..303f10555729 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -894,8 +894,9 @@ static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
 	struct work_struct *lsaw = &rcd->ppd->linkstate_active_work;
 	struct hfi1_message_header *hdr = hfi1_get_msgheader(packet->rcd->dd,
 							     packet->rhf_addr);
+	u8 etype = rhf_rcv_type(packet->rhf);
 
-	if (hdr2sc(hdr, packet->rhf) != 0xf) {
+	if (etype == RHF_RCV_TYPE_IB && hdr2sc(hdr, packet->rhf) != 0xf) {
 		int hwstate = read_logical_state(dd);
 
 		if (hwstate != LSTATE_ACTIVE) {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

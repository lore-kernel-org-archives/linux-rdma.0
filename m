From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] staging/rdma/hfi1: Fix xmit discard error weight
Date: Thu, 18 Feb 2016 11:12:08 -0800
Message-ID: <20160218191204.20983.36676.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Count only the errors that apply to xmit discards.  Update
the comment to better explain the limitations of the count.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 93bf465..6e44d52 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5566,12 +5566,28 @@ static void handle_send_egress_err_info(struct hfi1_devdata *dd,
 		int weight, i;
 
 		/*
-		 * Count all, in case multiple bits are set.  Reminder:
-		 * since there is only one info register for many sources,
-		 * these may be attributed to the wrong VL if they occur
-		 * too close together.
+		 * Count all applicable bits as individual errors and
+		 * attribute them to the packet that triggered this handler.
+		 * This may not be completely accurate due to limitations
+		 * on the available hardware error information.  There is
+		 * a single information register and any number of error
+		 * packets may have occurred and contributed to it before
+		 * this routine is called.  This means that:
+		 * a) If multiple packets with the same error occur before
+		 *    this routine is called, earlier packets are missed.
+		 *    There is only a single bit for each error type.
+		 * b) Errors may not be attributed to the correct VL.
+		 *    The driver is attributing all bits in the info register
+		 *    to the packet that triggered this call, but bits
+		 *    could be an accumulation of different packets with
+		 *    different VLs.
+		 * c) A single error packet may have multiple counts attached
+		 *    to it.  There is no way for the driver to know if
+		 *    multiple bits set in the info register are due to a
+		 *    single packet or multiple packets.  The driver assumes
+		 *    multiple packets.
 		 */
-		weight = hweight64(info);
+		weight = hweight64(info & PORT_DISCARD_EGRESS_ERRS);
 		for (i = 0; i < weight; i++) {
 			__count_port_discards(ppd);
 			if (vl >= 0 && vl < TXE_NUM_DATA_VL)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

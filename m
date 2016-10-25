From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] IB/hfi1: Fix status error code for unsupported packets
Date: Tue, 25 Oct 2016 13:12:17 -0700
Message-ID: <20161025201216.15765.19453.stgit@scvm10.sc.intel.com>
References: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025194241.15765.8903.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Set the status code BAD_L2 when unsupported type of packet
is received and dropped.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.h   |    3 +++
 drivers/infiniband/hw/hfi1/driver.c |   17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 9234525..043fd21 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -320,6 +320,9 @@
 /* DC_DC8051_CFG_MODE.GENERAL bits */
 #define DISABLE_SELF_GUID_CHECK 0x2
 
+/* Bad L2 frame error code */
+#define BAD_L2_ERR      0x6
+
 /*
  * Eager buffer minimum and maximum sizes supported by the hardware.
  * All power-of-two sizes in between are supported as well.
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 6563e4d..dadd35e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1360,12 +1360,25 @@ int process_receive_ib(struct hfi1_packet *packet)
 
 int process_receive_bypass(struct hfi1_packet *packet)
 {
+	struct hfi1_devdata *dd = packet->rcd->dd;
+
 	if (unlikely(rhf_err_flags(packet->rhf)))
 		handle_eflags(packet);
 
-	dd_dev_err(packet->rcd->dd,
+	dd_dev_err(dd,
 		   "Bypass packets are not supported in normal operation. Dropping\n");
-	incr_cntr64(&packet->rcd->dd->sw_rcv_bypass_packet_errors);
+	incr_cntr64(&dd->sw_rcv_bypass_packet_errors);
+	if (!(dd->err_info_rcvport.status_and_code & OPA_EI_STATUS_SMASK)) {
+		u64 *flits = packet->ebuf;
+
+		if (flits && !(packet->rhf & RHF_LEN_ERR)) {
+			dd->err_info_rcvport.packet_flit1 = flits[0];
+			dd->err_info_rcvport.packet_flit2 =
+				packet->tlen > sizeof(flits[0]) ? flits[1] : 0;
+		}
+		dd->err_info_rcvport.status_and_code |=
+			(OPA_EI_STATUS_SMASK | BAD_L2_ERR);
+	}
 	return RHF_RCV_CONTINUE;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

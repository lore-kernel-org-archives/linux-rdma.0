From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Default some module parameters optimally
Date: Fri, 23 Dec 2011 11:12:10 -0500
Message-ID: <20111223161210.17995.66362.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Minimize the need for users to have to set module parameters to
get good performance.

The following two parameters are changed:
- rcvhdrcnt to twice the rcvegrcnt
- pcie_caps=0x51

The rcvhdrcnt at twice the egrcount allows the preemptive NAK code during
reception to function in 100% of the cases rather than a sender
jiffies-based timeout.

The pcie_caps default of 0x51 will set the proposed MaxPayload
and MaxReceiveReqest to 256 and 4096 respectively.  The capabilities
on the root complex will be used to limit those values.

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 +-
 drivers/infiniband/hw/qib/qib_pcie.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5a070e8..5036106 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3602,7 +3602,7 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 	if (qib_rcvhdrcnt)
 		dd->rcvhdrcnt = max(dd->cspec->rcvegrcnt, qib_rcvhdrcnt);
 	else
-		dd->rcvhdrcnt = max(dd->cspec->rcvegrcnt,
+		dd->rcvhdrcnt = 2 * max(dd->cspec->rcvegrcnt,
 				    dd->num_pports > 1 ? 1024U : 2048U);
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 97a8bdf..f695061 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -560,9 +560,9 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
  * BIOS may not set PCIe bus-utilization parameters for best performance.
  * Check and optionally adjust them to maximize our throughput.
  */
-static int qib_pcie_caps;
+static int qib_pcie_caps = 0x51;
 module_param_named(pcie_caps, qib_pcie_caps, int, S_IRUGO);
-MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (4lsb), ReadReq (D4..7)");
+MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
 
 static int qib_tune_pcie_caps(struct qib_devdata *dd)
 {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

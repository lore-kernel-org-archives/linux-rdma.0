From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: unwind pcie change
Date: Thu, 12 Jan 2012 21:29:59 -0500
Message-ID: <20120113022959.14320.23730.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 8d4548f2b ("IB/qib: Default some module parameters optimally")
introduced an issue with older root complexes.  They cannot handle
the pcie_caps of 0x51 (MaxReadReq 4096, MaxPayload=256).

A typical diagnostic in this situation reported by syslog contains
the text:

  [PCIe Poisoned TLP][Send DMA memory read]

Restore the module paramter default to zero with will avoid
any changes in the root complex.

Reviewed-by: Mark Debbage <mark.debbage-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 0de55c0..790646e 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -577,7 +577,7 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
  * BIOS may not set PCIe bus-utilization parameters for best performance.
  * Check and optionally adjust them to maximize our throughput.
  */
-static int qib_pcie_caps = 0x51;
+static int qib_pcie_caps;
 module_param_named(pcie_caps, qib_pcie_caps, int, S_IRUGO);
 MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

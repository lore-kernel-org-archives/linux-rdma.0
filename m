From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] firmware,IB/qib: revert firmware file move
Date: Fri, 05 Apr 2013 14:30:13 -0400
Message-ID: <20130405183013.4047.7691.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vinit Abhay Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit e2eed58 ("IB/qib: change QLogic to Intel") moved a firmware file
potentially breaking the ABI.

This patch reverts that aspect of the fix as well as reverting the
firmware name as used in qib.

Reported-by: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sd7220.c |    2 +-
 firmware/Makefile                      |    2 +-
 firmware/qlogic/sd7220.fw.ihex         |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename firmware/{intel/sd7220.fw.ihex => qlogic/sd7220.fw.ihex} (100%)

diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index 08a6c6d..911205d 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -44,7 +44,7 @@
 #include "qib.h"
 #include "qib_7220.h"
 
-#define SD7220_FW_NAME "intel/sd7220.fw"
+#define SD7220_FW_NAME "qlogic/sd7220.fw"
 MODULE_FIRMWARE(SD7220_FW_NAME);
 
 /*
diff --git a/firmware/Makefile b/firmware/Makefile
index 5d8ee13..cbb09ce 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -82,7 +82,7 @@ fw-shipped-$(CONFIG_SCSI_ADVANSYS) += advansys/mcode.bin advansys/38C1600.bin \
 fw-shipped-$(CONFIG_SCSI_QLOGIC_1280) += qlogic/1040.bin qlogic/1280.bin \
 					 qlogic/12160.bin
 fw-shipped-$(CONFIG_SCSI_QLOGICPTI) += qlogic/isp1000.bin
-fw-shipped-$(CONFIG_INFINIBAND_QIB) += intel/sd7220.fw
+fw-shipped-$(CONFIG_INFINIBAND_QIB) += qlogic/sd7220.fw
 fw-shipped-$(CONFIG_SND_KORG1212) += korg/k1212.dsp
 fw-shipped-$(CONFIG_SND_MAESTRO3) += ess/maestro3_assp_kernel.fw \
 				     ess/maestro3_assp_minisrc.fw
diff --git a/firmware/intel/sd7220.fw.ihex b/firmware/qlogic/sd7220.fw.ihex
similarity index 100%
rename from firmware/intel/sd7220.fw.ihex
rename to firmware/qlogic/sd7220.fw.ihex

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

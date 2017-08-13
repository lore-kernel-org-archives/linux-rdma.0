From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/8] IB/hfi1: Remove HFI1_VERBS_31BIT_PSN option
Date: Sun, 13 Aug 2017 08:08:58 -0700
Message-ID: <20170813150857.23208.57220.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove HFI1_VERBS_31BIT_PSN Kconfig option leaving only 31-bit PSNs
available. The option was implemented in the early days of the driver
and is no longer needed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Kconfig |    7 -------
 drivers/infiniband/hw/hfi1/verbs.h |    5 -----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index f6ea088..7b146b6 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -13,13 +13,6 @@ config HFI1_DEBUG_SDMA_ORDER
 	---help---
 	This is a debug flag to test for out of order
 	sdma completions for unit testing
-config HFI1_VERBS_31BIT_PSN
-	bool "HFI1 enable 31 bit PSN"
-	depends on INFINIBAND_HFI1
-	default y
-	---help---
-	Setting this enables 31 BIT PSN
-	For verbs RC/UC
 config SDMA_VERBOSITY
 	bool "Config SDMA Verbosity"
 	depends on INFINIBAND_HFI1
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 56ead87..87d1285 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -280,13 +280,8 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
  * necessarily be at least one bit less than
  * the container holding the PSN.
  */
-#ifndef CONFIG_HFI1_VERBS_31BIT_PSN
-#define PSN_MASK 0xFFFFFF
-#define PSN_SHIFT 8
-#else
 #define PSN_MASK 0x7FFFFFFF
 #define PSN_SHIFT 1
-#endif
 #define PSN_MODIFY_MASK 0xFFFFFF
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] vmw_pvrdma: Remove usage of BIT() from vmw_pvrdma
Date: Wed, 13 Dec 2017 16:51:02 -0800
Message-ID: <20171214005052.GA14016@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

BIT() should not be used in the UAPI headers. It has been removed
in the kernel vmw_pvrdma-abi.h, so update the fixup-include header
accordingly, and remove the definition for BIT() in vmw_pvrdma code.

Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
There's a stray whitespace change in there, as this is the first time
I've actually copied the header file from the kernel into this repo.
It's now completely sync'd up, aside from the extra copyright license
line found in the kernel headers. I can remove the whitespace change
if that is desired.
---
 buildlib/RDMA_LinuxHeaders.cmake             |  2 +-
 buildlib/fixup-include/rdma-vmw_pvrdma-abi.h | 14 +++++++-------
 providers/vmw_pvrdma/pvrdma.h                |  2 --
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
index ea60b9b..3bd2bed 100644
--- a/buildlib/RDMA_LinuxHeaders.cmake
+++ b/buildlib/RDMA_LinuxHeaders.cmake
@@ -95,4 +95,4 @@ rdma_check_kheader("rdma/ib_user_mad.h" "${DEFAULT_TEST}" NO_SHIM OPTIONAL)
 rdma_check_kheader("rdma/rdma_netlink.h" "int main(int argc,const char *argv[]) { return RDMA_NL_IWPM_REMOTE_INFO && RDMA_NL_IWCM; }")
 rdma_check_kheader("rdma/rdma_user_cm.h" "${DEFAULT_TEST}" NO_SHIM OPTIONAL)
 rdma_check_kheader("rdma/rdma_user_rxe.h" "${DEFAULT_TEST}")
-rdma_check_kheader("rdma/vmw_pvrdma-abi.h" "int main(int argc,const char *argv[]) { return PVRDMA_UAR_SRQ_OFFSET; }")
+rdma_check_kheader("rdma/vmw_pvrdma-abi.h" "int main(int argc,const char *argv[]) { return PVRDMA_UAR_SRQ_RECV; }")
diff --git a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
index 9fba845..0550c35 100644
--- a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
+++ b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
@@ -51,14 +51,14 @@
 #define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
 #define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
 #define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
-#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
-#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
+#define PVRDMA_UAR_QP_SEND		(1 << 30)	/* Send bit. */
+#define PVRDMA_UAR_QP_RECV		(1 << 31)	/* Recv bit. */
 #define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell. */
-#define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
-#define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
-#define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
+#define PVRDMA_UAR_CQ_ARM_SOL		(1 << 29)	/* Arm solicited bit. */
+#define PVRDMA_UAR_CQ_ARM		(1 << 30)	/* Arm bit. */
+#define PVRDMA_UAR_CQ_POLL		(1 << 31)	/* Poll bit. */
 #define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
-#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
+#define PVRDMA_UAR_SRQ_RECV		(1 << 30)	/* Recv bit. */
 
 enum pvrdma_wr_opcode {
 	PVRDMA_WR_RDMA_WRITE,
@@ -127,7 +127,7 @@ enum pvrdma_wc_flags {
 	PVRDMA_WC_IP_CSUM_OK		= 1 << 3,
 	PVRDMA_WC_WITH_SMAC		= 1 << 4,
 	PVRDMA_WC_WITH_VLAN		= 1 << 5,
-	PVRDMA_WC_WITH_NETWORK_HDR_TYPE = 1 << 6,
+	PVRDMA_WC_WITH_NETWORK_HDR_TYPE	= 1 << 6,
 	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
 };
 
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index 5a7b171..0034aea 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -58,8 +58,6 @@
 #include <ccan/minmax.h>
 #include <util/compiler.h>
 
-#define BIT(nr) (1UL << (nr))
-
 #include "pvrdma-abi-fix.h"
 #include "pvrdma_ring.h"
 
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

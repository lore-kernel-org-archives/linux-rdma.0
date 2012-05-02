From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: compile qib_verbs.c for optimal memcpy performance
Date: Wed, 2 May 2012 11:24:02 -0400
Message-ID: <20120502152402.29436.77513.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch changes the compilation for qib_verbs.c when the
patch is x86_64 and the -mstringop-strategy is supported by
the compiler.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index f12d7bb..4c7f6c3 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -13,3 +13,7 @@ ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o
 
 ib_qib-$(CONFIG_X86_64) += qib_wc_x86_64.o
 ib_qib-$(CONFIG_PPC64) += qib_wc_ppc64.o
+
+ifeq ($(CONFIG_X86_64),y)
+CFLAGS_qib_verbs.o += $(call cc-option,-mstringop-strategy=rep_8byte)
+endif


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

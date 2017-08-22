From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/16] IB/hfi1: Move structure definitions from
 user_exp_rcv.c to user_exp_rcv.h
Date: Mon, 21 Aug 2017 18:27:23 -0700
Message-ID: <20170822012721.32701.77352.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean up user_exp_rcv.c file by moving structure definitions into header
file user_exp_rcv.h. Since these structure definitions depend on the
structure definitions in mmu_rb.h, move #include "mmu_rb.h" above
the include "user_exp_rcv.h" or include of header files that include
user_exp_rcv.h

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |    2 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   18 +-----------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   16 ++++++++++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c    |    2 +-
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index ab8eb2b..e0fd8fc 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -58,10 +58,10 @@
 #include "device.h"
 #include "common.h"
 #include "trace.h"
+#include "mmu_rb.h"
 #include "user_sdma.h"
 #include "user_exp_rcv.h"
 #include "aspm.h"
-#include "mmu_rb.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 026790e..6f6c14d 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -47,25 +47,9 @@
 #include <asm/page.h>
 #include <linux/string.h>
 
+#include "mmu_rb.h"
 #include "user_exp_rcv.h"
 #include "trace.h"
-#include "mmu_rb.h"
-
-struct tid_rb_node {
-	struct mmu_rb_node mmu;
-	unsigned long phys;
-	struct tid_group *grp;
-	u32 rcventry;
-	dma_addr_t dma_addr;
-	bool freed;
-	unsigned npages;
-	struct page *pages[0];
-};
-
-struct tid_pageset {
-	u16 idx;
-	u16 count;
-};
 
 static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 			    struct exp_tid_set *set,
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 7461d11..e383cc0 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -51,6 +51,11 @@
 
 #include "exp_rcv.h"
 
+struct tid_pageset {
+	u16 idx;
+	u16 count;
+};
+
 struct tid_user_buf {
 	unsigned long vaddr;
 	unsigned long length;
@@ -60,6 +65,17 @@ struct tid_user_buf {
 	unsigned int n_psets;
 };
 
+struct tid_rb_node {
+	struct mmu_rb_node mmu;
+	unsigned long phys;
+	struct tid_group *grp;
+	u32 rcventry;
+	dma_addr_t dma_addr;
+	bool freed;
+	unsigned int npages;
+	struct page *pages[0];
+};
+
 static inline int num_user_pages(unsigned long addr,
 				 unsigned long len)
 {
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 2837407..8a1653a 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -64,11 +64,11 @@
 
 #include "hfi.h"
 #include "sdma.h"
+#include "mmu_rb.h"
 #include "user_sdma.h"
 #include "verbs.h"  /* for the headers */
 #include "common.h" /* for struct hfi1_tid_info */
 #include "trace.h"
-#include "mmu_rb.h"
 
 static uint hfi1_sdma_comp_ring_size = 128;
 module_param_named(sdma_comp_size, hfi1_sdma_comp_ring_size, uint, S_IRUGO);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: ira.weiny@intel.com
Subject: [PATCH 4/9] staging/rdma/hfi1: Move macros to a common header
Date: Fri, 30 Oct 2015 18:41:53 -0400
Message-ID: <1446244918-12089-5-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

In preparation of implementing TID caching move EXP_TID macros to a common
header user_exp_rcv.h

Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c     | 13 +-----
 drivers/staging/rdma/hfi1/user_exp_rcv.h | 74 ++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_sdma.h    | 10 +----
 3 files changed, 76 insertions(+), 21 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.h

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index b8aeef0e0d39..3b15eb4d5bf9 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -58,6 +58,7 @@
 #include "common.h"
 #include "trace.h"
 #include "user_sdma.h"
+#include "user_exp_rcv.h"
 #include "eprom.h"
 
 #undef pr_fmt
@@ -160,18 +161,6 @@ enum mmap_types {
 	HFI1_MMAP_TOKEN_SET(SUBCTXT, subctxt) | \
 	HFI1_MMAP_TOKEN_SET(OFFSET, (offset_in_page(addr))))
 
-#define EXP_TID_SET(field, value)			\
-	(((value) & EXP_TID_TID##field##_MASK) <<	\
-	 EXP_TID_TID##field##_SHIFT)
-#define EXP_TID_CLEAR(tid, field) {					\
-		(tid) &= ~(EXP_TID_TID##field##_MASK <<			\
-			   EXP_TID_TID##field##_SHIFT);			\
-			}
-#define EXP_TID_RESET(tid, field, value) do {				\
-		EXP_TID_CLEAR(tid, field);				\
-		(tid) |= EXP_TID_SET(field, value);			\
-	} while (0)
-
 #define dbg(fmt, ...)				\
 	pr_info(fmt, ##__VA_ARGS__)
 
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.h b/drivers/staging/rdma/hfi1/user_exp_rcv.h
new file mode 100644
index 000000000000..4f4876e1d353
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.h
@@ -0,0 +1,74 @@
+#ifndef _HFI1_USER_EXP_RCV_H
+#define _HFI1_USER_EXP_RCV_H
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#define EXP_TID_TIDLEN_MASK   0x7FFULL
+#define EXP_TID_TIDLEN_SHIFT  0
+#define EXP_TID_TIDCTRL_MASK  0x3ULL
+#define EXP_TID_TIDCTRL_SHIFT 20
+#define EXP_TID_TIDIDX_MASK   0x3FFULL
+#define EXP_TID_TIDIDX_SHIFT  22
+#define EXP_TID_GET(tid, field)	\
+	(((tid) >> EXP_TID_TID##field##_SHIFT) & EXP_TID_TID##field##_MASK)
+
+#define EXP_TID_SET(field, value)			\
+	(((value) & EXP_TID_TID##field##_MASK) <<	\
+	 EXP_TID_TID##field##_SHIFT)
+#define EXP_TID_CLEAR(tid, field) ({					\
+		(tid) &= ~(EXP_TID_TID##field##_MASK <<			\
+			   EXP_TID_TID##field##_SHIFT);			\
+		})
+#define EXP_TID_RESET(tid, field, value) do {				\
+		EXP_TID_CLEAR(tid, field);				\
+		(tid) |= EXP_TID_SET(field, (value));			\
+	} while (0)
+
+#endif /* _HFI1_USER_EXP_RCV_H */
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index fa4422553e23..0046ffa774fe 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -52,15 +52,7 @@
 
 #include "common.h"
 #include "iowait.h"
-
-#define EXP_TID_TIDLEN_MASK   0x7FFULL
-#define EXP_TID_TIDLEN_SHIFT  0
-#define EXP_TID_TIDCTRL_MASK  0x3ULL
-#define EXP_TID_TIDCTRL_SHIFT 20
-#define EXP_TID_TIDIDX_MASK   0x7FFULL
-#define EXP_TID_TIDIDX_SHIFT  22
-#define EXP_TID_GET(tid, field)	\
-	(((tid) >> EXP_TID_TID##field##_SHIFT) & EXP_TID_TID##field##_MASK)
+#include "user_exp_rcv.h"
 
 extern uint extended_psn;
 
-- 
1.8.2

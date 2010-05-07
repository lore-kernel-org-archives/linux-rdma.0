From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 48/52] IB/qib: Add qib_wc_ppc64.c
Date: Thu, 06 May 2010 17:03:04 -0700
Message-ID: <20100507000303.3441.65206.stgit@chromite.mv.qlogic.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506235849.3441.85930.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

creates the qib_wc_ppc64.c file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_wc_ppc64.c |   62 ++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_wc_ppc64.c

diff --git a/drivers/infiniband/hw/qib/qib_wc_ppc64.c b/drivers/infiniband/hw/qib/qib_wc_ppc64.c
new file mode 100644
index 0000000..673cf4c
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_wc_ppc64.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2006, 2007, 2008 QLogic Corporation. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+/*
+ * This file is conditionally built on PowerPC only.  Otherwise weak symbol
+ * versions of the functions exported from here are used.
+ */
+
+#include "qib.h"
+
+/**
+ * qib_enable_wc - enable write combining for MMIO writes to the device
+ * @dd: qlogic_ib device
+ *
+ * Nothing to do on PowerPC, so just return without error.
+ */
+int qib_enable_wc(struct qib_devdata *dd)
+{
+	return 0;
+}
+
+/**
+ * qib_unordered_wc - indicate whether write combining is unordered
+ *
+ * Because our performance depends on our ability to do write
+ * combining mmio writes in the most efficient way, we need to
+ * know if we are on a processor that may reorder stores when
+ * write combining.
+ */
+int qib_unordered_wc(void)
+{
+	return 1;
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 44/52] IB/qib: Add qib_user_sdma.h
Date: Thu, 06 May 2010 17:02:43 -0700
Message-ID: <20100507000242.3441.25203.stgit@chromite.mv.qlogic.com>
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

creates the qib_user_sdma.h file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_user_sdma.h |   52 +++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_user_sdma.h

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.h b/drivers/infiniband/hw/qib/qib_user_sdma.h
new file mode 100644
index 0000000..ce8cbaf
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2007, 2008 QLogic Corporation. All rights reserved.
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
+#include <linux/device.h>
+
+struct qib_user_sdma_queue;
+
+struct qib_user_sdma_queue *
+qib_user_sdma_queue_create(struct device *dev, int unit, int port, int sport);
+void qib_user_sdma_queue_destroy(struct qib_user_sdma_queue *pq);
+
+int qib_user_sdma_writev(struct qib_ctxtdata *pd,
+			 struct qib_user_sdma_queue *pq,
+			 const struct iovec *iov,
+			 unsigned long dim);
+
+int qib_user_sdma_make_progress(struct qib_pportdata *ppd,
+				struct qib_user_sdma_queue *pq);
+
+void qib_user_sdma_queue_drain(struct qib_pportdata *ppd,
+			       struct qib_user_sdma_queue *pq);
+
+u32 qib_user_sdma_complete_counter(const struct qib_user_sdma_queue *pq);
+u32 qib_user_sdma_inflight_counter(struct qib_user_sdma_queue *pq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

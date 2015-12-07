From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/37] IB/rdmavt: Add completion queue function stubs
Date: Mon, 07 Dec 2015 15:44:21 -0500
Message-ID: <20151207204420.8144.85665.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Create stubs for completion queue creation, polling,
resizing, calling for notification, and destroying.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/Makefile |    2 -
 drivers/infiniband/sw/rdmavt/cq.c     |  116 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/cq.h     |   65 ++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    7 ++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 190 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/cq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/cq.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 6f530d1..00f0188 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,4 +7,4 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o
+rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
new file mode 100644
index 0000000..c35d42e
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -0,0 +1,116 @@
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
+#include "cq.h"
+
+/**
+ * rvt_create_cq - create a completion queue
+ * @ibdev: the device this completion queue is attached to
+ * @attr: creation attributes
+ * @context: unused by the QLogic_IB driver
+ * @udata: user data for libibverbs.so
+ *
+ * Returns a pointer to the completion queue or negative errno values
+ * for failure.
+ *
+ * Called by ib_create_cq() in the generic verbs code.
+ */
+struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
+			    const struct ib_cq_init_attr *attr,
+			    struct ib_ucontext *context,
+			    struct ib_udata *udata)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+/**
+ * rvt_destroy_cq - destroy a completion queue
+ * @ibcq: the completion queue to destroy.
+ *
+ * Returns 0 for success.
+ *
+ * Called by ib_destroy_cq() in the generic verbs code.
+ */
+int rvt_destroy_cq(struct ib_cq *ibcq)
+{
+	return -EINVAL;
+}
+
+int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
+{
+	return -EINVAL;
+}
+
+/**
+ * rvt_resize_cq - change the size of the CQ
+ * @ibcq: the completion queue
+ *
+ * Returns 0 for success.
+ */
+int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
+{
+	return -EINVAL;
+}
+
+/**
+ * rvt_poll_cq - poll for work completion entries
+ * @ibcq: the completion queue to poll
+ * @num_entries: the maximum number of entries to return
+ * @entry: pointer to array where work completions are placed
+ *
+ * Returns the number of completion entries polled.
+ *
+ * This may be called from interrupt context.  Also called by ib_poll_cq()
+ * in the generic verbs code.
+ */
+int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
+{
+	return -EINVAL;
+}
diff --git a/drivers/infiniband/sw/rdmavt/cq.h b/drivers/infiniband/sw/rdmavt/cq.h
new file mode 100644
index 0000000..70d2c41
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/cq.h
@@ -0,0 +1,65 @@
+#ifndef DEF_RVTCQ_H
+#define DEF_RVTCQ_H
+
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
+#include <rdma/rdma_vt.h>
+
+struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
+			    const struct ib_cq_init_attr *attr,
+			    struct ib_ucontext *context,
+			    struct ib_udata *udata);
+int rvt_destroy_cq(struct ib_cq *ibcq);
+int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
+int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
+int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
+
+#endif          /* DEF_RVTCQ_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 8dd2fbd..f996389 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -267,6 +267,13 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, dealloc_fmr);
 	CDR(rdi, mmap);
 
+	/* Completion queues */
+	CDR(rdi, create_cq);
+	CDR(rdi, destroy_cq);
+	CDR(rdi, poll_cq);
+	CDR(rdi, req_notify_cq);
+	CDR(rdi, resize_cq);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index e285546..625893e 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -60,5 +60,6 @@
 #include "srq.h"
 #include "mcast.h"
 #include "mmap.h"
+#include "cq.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

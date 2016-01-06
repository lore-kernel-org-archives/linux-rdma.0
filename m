From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 19/36] IB/rdmavt: Add completion queue function stubs
Date: Wed, 06 Jan 2016 10:00:42 -0800
Message-ID: <20160106175943.8747.10516.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
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
Changes since v1:
Change stubs to return EOPNOTSUPP

 drivers/infiniband/sw/rdmavt/Makefile |    2 -
 drivers/infiniband/sw/rdmavt/cq.c     |  113 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/cq.h     |   62 ++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    7 ++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 184 insertions(+), 1 deletions(-)
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
index 0000000..8d96194
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+	return ERR_PTR(-EOPNOTSUPP);
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
+	return -EOPNOTSUPP;
+}
+
+int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
+{
+	return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/infiniband/sw/rdmavt/cq.h b/drivers/infiniband/sw/rdmavt/cq.h
new file mode 100644
index 0000000..63a517d
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/cq.h
@@ -0,0 +1,62 @@
+#ifndef DEF_RVTCQ_H
+#define DEF_RVTCQ_H
+
+/*
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
index a122ee8..7fd879f 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -260,6 +260,13 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, dealloc_fmr);
 	CHECK_DRIVER_OVERRIDE(rdi, mmap);
 
+	/* Completion queues */
+	CHECK_DRIVER_OVERRIDE(rdi, create_cq);
+	CHECK_DRIVER_OVERRIDE(rdi, destroy_cq);
+	CHECK_DRIVER_OVERRIDE(rdi, poll_cq);
+	CHECK_DRIVER_OVERRIDE(rdi, req_notify_cq);
+	CHECK_DRIVER_OVERRIDE(rdi, resize_cq);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index 6a5f5bf..fdb52a8 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -57,5 +57,6 @@
 #include "srq.h"
 #include "mcast.h"
 #include "mmap.h"
+#include "cq.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

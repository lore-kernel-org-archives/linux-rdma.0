From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 11/36] IB/rdmavt: Add queue pair function stubs
Date: Wed, 06 Jan 2016 09:56:15 -0800
Message-ID: <20160106175544.8747.13499.stgit@scvm10.sc.intel.com>
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

Adds the stubs for create, modify, destroy and query functions for queue
pairs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Change stubs to return EOPNOTSUPP

 drivers/infiniband/sw/rdmavt/Makefile |    2 -
 drivers/infiniband/sw/rdmavt/qp.c     |  120 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/qp.h     |   67 ++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    6 ++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 195 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/qp.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index c6751bb..9a9a095 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,5 +7,5 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o dma.o pd.o
+rdmavt-y := vt.o dma.o pd.o qp.o
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
new file mode 100644
index 0000000..a59f28d
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -0,0 +1,120 @@
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
+#include "qp.h"
+
+/**
+ * rvt_create_qp - create a queue pair for a device
+ * @ibpd: the protection domain who's device we create the queue pair for
+ * @init_attr: the attributes of the queue pair
+ * @udata: user data for libibverbs.so
+ *
+ * Returns the queue pair on success, otherwise returns an errno.
+ *
+ * Called by the ib_create_qp() core verbs function.
+ */
+struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
+			    struct ib_qp_init_attr *init_attr,
+			    struct ib_udata *udata)
+{
+	/*
+	 * Queue pair creation is mostly an rvt issue. However, drivers have
+	 * their own unique idea of what queue pare numbers mean. For instance
+	 * there is a reserved range for PSM.
+	 *
+	 * VI-DRIVER-API: make_qpn()
+	 * Returns a valid QPN for verbs to use
+	 */
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/**
+ * qib_modify_qp - modify the attributes of a queue pair
+ * @ibqp: the queue pair who's attributes we're modifying
+ * @attr: the new attributes
+ * @attr_mask: the mask of attributes to modify
+ * @udata: user data for libibverbs.so
+ *
+ * Returns 0 on success, otherwise returns an errno.
+ */
+int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		  int attr_mask, struct ib_udata *udata)
+{
+	/*
+	 * VT-DRIVER-API: qp_mtu()
+	 * OPA devices have a per VL MTU the driver has a mapping of IB SL to SC
+	 * to VL and the mapping table of MTUs per VL. This is not something
+	 * that IB has and should not live in the rvt.
+	 */
+	return -EOPNOTSUPP;
+}
+
+/**
+ * rvt_destroy_qp - destroy a queue pair
+ * @ibqp: the queue pair to destroy
+ *
+ * Returns 0 on success.
+ *
+ * Note that this can be called while the QP is actively sending or
+ * receiving!
+ */
+int rvt_destroy_qp(struct ib_qp *ibqp)
+{
+	/*
+	 * VT-DRIVER-API: qp_flush()
+	 * Driver provies a mechanism to flush and wait for that flush to
+	 * finish.
+	 */
+
+	return -EOPNOTSUPP;
+}
+
+int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		 int attr_mask, struct ib_qp_init_attr *init_attr)
+{
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/infiniband/sw/rdmavt/qp.h b/drivers/infiniband/sw/rdmavt/qp.h
new file mode 100644
index 0000000..43acba0
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/qp.h
@@ -0,0 +1,67 @@
+#ifndef DEF_RVTQP_H
+#define DEF_RVTQP_H
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
+struct rvt_qp {
+	struct ib_qp *ibqp;
+	/* Other stuff */
+};
+
+struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
+			    struct ib_qp_init_attr *init_attr,
+			    struct ib_udata *udata);
+int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		  int attr_mask, struct ib_udata *udata);
+int rvt_destroy_qp(struct ib_qp *ibqp);
+int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		 int attr_mask, struct ib_qp_init_attr *init_attr);
+
+#endif          /* DEF_RVTQP_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index cd19429..07b0ada 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -220,6 +220,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, alloc_ucontext);
 	CHECK_DRIVER_OVERRIDE(rdi, dealloc_ucontext);
 
+	/* Queue Pairs */
+	CHECK_DRIVER_OVERRIDE(rdi, create_qp);
+	CHECK_DRIVER_OVERRIDE(rdi, modify_qp);
+	CHECK_DRIVER_OVERRIDE(rdi, destroy_qp);
+	CHECK_DRIVER_OVERRIDE(rdi, query_qp);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index ba2f806..8758f25 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -51,5 +51,6 @@
 #include <rdma/rdma_vt.h>
 #include "dma.h"
 #include "pd.h"
+#include "qp.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

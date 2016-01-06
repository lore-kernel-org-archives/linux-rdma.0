From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 14/36] IB/rdmavt: Add SRQ stubs
Date: Wed, 06 Jan 2016 09:57:58 -0800
Message-ID: <20160106175726.8747.3983.stgit@scvm10.sc.intel.com>
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

Adds the stubs for create, modify, query, and destory for shared
request queues.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Change stubs to return EOPNOTSUPP

 drivers/infiniband/sw/rdmavt/Makefile |    2 -
 drivers/infiniband/sw/rdmavt/srq.c    |   86 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/srq.h    |   61 +++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    6 ++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 155 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/srq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/srq.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 084ee6a..204be84 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,4 +7,4 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o dma.o mr.o pd.o qp.o
+rdmavt-y := vt.o ah.o dma.o mr.o pd.o qp.o srq.o
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
new file mode 100644
index 0000000..bbb623a
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -0,0 +1,86 @@
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
+#include "srq.h"
+
+/**
+ * rvt_create_srq - create a shared receive queue
+ * @ibpd: the protection domain of the SRQ to create
+ * @srq_init_attr: the attributes of the SRQ
+ * @udata: data from libibverbs when creating a user SRQ
+ */
+struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
+			      struct ib_srq_init_attr *srq_init_attr,
+			      struct ib_udata *udata)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/**
+ * rvt_modify_srq - modify a shared receive queue
+ * @ibsrq: the SRQ to modify
+ * @attr: the new attributes of the SRQ
+ * @attr_mask: indicates which attributes to modify
+ * @udata: user data for libibverbs.so
+ */
+int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		   enum ib_srq_attr_mask attr_mask,
+		   struct ib_udata *udata)
+{
+	return -EOPNOTSUPP;
+}
+
+int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
+
+int rvt_destroy_srq(struct ib_srq *ibsrq)
+{
+	return -EOPNOTSUPP;
+}
+
diff --git a/drivers/infiniband/sw/rdmavt/srq.h b/drivers/infiniband/sw/rdmavt/srq.h
new file mode 100644
index 0000000..0c3c5a7
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/srq.h
@@ -0,0 +1,61 @@
+#ifndef DEF_RVTSRQ_H
+#define DEF_RVTSRQ_H
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
+struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
+			      struct ib_srq_init_attr *srq_init_attr,
+			      struct ib_udata *udata);
+int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		   enum ib_srq_attr_mask attr_mask,
+		   struct ib_udata *udata);
+int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
+int rvt_destroy_srq(struct ib_srq *ibsrq);
+
+#endif          /* DEF_RVTSRQ_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 004ca14..9b318e9 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -232,6 +232,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, modify_ah);
 	CHECK_DRIVER_OVERRIDE(rdi, query_ah);
 
+	/* Shared Receive Queue */
+	CHECK_DRIVER_OVERRIDE(rdi, create_srq);
+	CHECK_DRIVER_OVERRIDE(rdi, modify_srq);
+	CHECK_DRIVER_OVERRIDE(rdi, destroy_srq);
+	CHECK_DRIVER_OVERRIDE(rdi, query_srq);
+
 	/* Mem Region */
 	CHECK_DRIVER_OVERRIDE(rdi, get_dma_mr);
 	CHECK_DRIVER_OVERRIDE(rdi, reg_user_mr);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index 78b9549..5019534 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -54,5 +54,6 @@
 #include "qp.h"
 #include "ah.h"
 #include "mr.h"
+#include "srq.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

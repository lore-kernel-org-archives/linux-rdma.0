From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 03/36] IB/rdmavt: Add protection domain to rdmavt.
Date: Wed, 06 Jan 2016 09:51:48 -0800
Message-ID: <20160106175123.8747.48221.stgit@scvm10.sc.intel.com>
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

Add datastructure for and allocation/deallocation of protection domains for
RDMAVT.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
update comment about protection domain limit

 drivers/infiniband/sw/rdmavt/Makefile |    3 +
 drivers/infiniband/sw/rdmavt/pd.c     |  103 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/pd.h     |   58 +++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |   12 ++++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 include/rdma/rdma_vt.h                |   34 ++++++++++-
 6 files changed, 206 insertions(+), 5 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.c
 create mode 100644 drivers/infiniband/sw/rdmavt/pd.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 134d2d0..c6751bb 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,4 +7,5 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o dma.o
+rdmavt-y := vt.o dma.o pd.o
+
diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
new file mode 100644
index 0000000..e6e153f
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -0,0 +1,103 @@
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
+#include <linux/slab.h>
+#include "pd.h"
+
+struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
+			   struct ib_ucontext *context,
+			   struct ib_udata *udata)
+{
+	struct rvt_dev_info *dev = ib_to_rvt(ibdev);
+	struct rvt_pd *pd;
+	struct ib_pd *ret;
+
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		ret = ERR_PTR(-ENOMEM);
+		goto bail;
+	}
+	/*
+	 * While we could continue allocating protecetion domains, being
+	 * constrained only by system resources. The IBTA spec defines that
+	 * there is a max_pd limit that can be set and we need to check for
+	 * that.
+	 */
+
+	spin_lock(&dev->n_pds_lock);
+	if (dev->n_pds_allocated == dev->dparms.max_pds) {
+		spin_unlock(&dev->n_pds_lock);
+		kfree(pd);
+		ret = ERR_PTR(-ENOMEM);
+		goto bail;
+	}
+
+	dev->n_pds_allocated++;
+	spin_unlock(&dev->n_pds_lock);
+
+	/* ib_alloc_pd() will initialize pd->ibpd. */
+	pd->user = udata ? 1 : 0;
+
+	ret = &pd->ibpd;
+
+bail:
+	return ret;
+}
+
+int rvt_dealloc_pd(struct ib_pd *ibpd)
+{
+	struct rvt_pd *pd = ibpd_to_rvtpd(ibpd);
+	struct rvt_dev_info *dev = ib_to_rvt(ibpd->device);
+
+	spin_lock(&dev->n_pds_lock);
+	dev->n_pds_allocated--;
+	spin_unlock(&dev->n_pds_lock);
+
+	kfree(pd);
+
+	return 0;
+}
diff --git a/drivers/infiniband/sw/rdmavt/pd.h b/drivers/infiniband/sw/rdmavt/pd.h
new file mode 100644
index 0000000..56d75e6
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/pd.h
@@ -0,0 +1,58 @@
+#ifndef DEF_RDMAVTPD_H
+#define DEF_RDMAVTPD_H
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
+struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
+			   struct ib_ucontext *context,
+			   struct ib_udata *udata);
+int rvt_dealloc_pd(struct ib_pd *ibpd);
+
+#endif          /* DEF_RDMAVTPD_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d82fdda..b65cde4 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -76,9 +76,21 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	 * come up with a better mechanism that simplifies the code at some
 	 * point.
 	 */
+
+	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
 
+	/* Protection Domain */
+	rdi->ibdev.alloc_pd =
+		rdi->ibdev.alloc_pd ? : rvt_alloc_pd;
+	rdi->ibdev.dealloc_pd =
+		rdi->ibdev.dealloc_pd ? : rvt_dealloc_pd;
+
+	spin_lock_init(&rdi->n_pds_lock);
+	rdi->n_pds_allocated = 0;
+
+	/* We are now good to announce we exist */
 	return ib_register_device(&rdi->ibdev, rdi->port_callback);
 }
 EXPORT_SYMBOL(rvt_register_device);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index cfe59a7..ba2f806 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -50,5 +50,6 @@
 
 #include <rdma/rdma_vt.h>
 #include "dma.h"
+#include "pd.h"
 
 #endif          /* DEF_RDMAVT_H */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 0438bf2..6bf5fd4 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -54,16 +54,42 @@
  */
 
 #include "ib_verbs.h"
+
+/*
+ * Things that are driver specific, module parameters in hfi1 and qib
+ */
+struct rvt_driver_params {
+	int max_pds;
+};
+
+/* Protection domain */
+struct rvt_pd {
+	struct ib_pd ibpd;
+	int user;               /* non-zero if created from user space */
+};
+
 struct rvt_dev_info {
 	struct ib_device ibdev;
+
+	/* Driver specific */
+	struct rvt_driver_params dparms;
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 
-	/*
-	 * TODO:
-	 *	need to reflect module parameters that may vary by dev
-	 */
+	/* Internal use */
+	int n_pds_allocated;
+	spinlock_t n_pds_lock; /* Protect pd allocated count */
 };
 
+static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct rvt_pd, ibpd);
+}
+
+static inline struct rvt_dev_info *ib_to_rvt(struct ib_device *ibdev)
+{
+	return  container_of(ibdev, struct rvt_dev_info, ibdev);
+}
+
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

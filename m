From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/37] IB/rdmavt: Add memory region stubs
Date: Mon, 07 Dec 2015 15:43:54 -0500
Message-ID: <20151207204353.8144.75932.stgit@phlsvslse11.ph.intel.com>
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

Adds the function stubs for allocating, and registering memory regions, as
well as deregistering them.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/Makefile |    2 
 drivers/infiniband/sw/rdmavt/mr.c     |  185 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mr.h     |   75 +++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |   11 ++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 273 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.c
 create mode 100644 drivers/infiniband/sw/rdmavt/mr.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 628c684..084ee6a 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,4 +7,4 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o dma.o pd.o qp.o
+rdmavt-y := vt.o ah.o dma.o mr.o pd.o qp.o
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
new file mode 100644
index 0000000..a4f4581
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -0,0 +1,185 @@
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
+#include <linux/slab.h>
+#include "mr.h"
+
+/**
+ * rvt_get_dma_mr - get a DMA memory region
+ * @pd: protection domain for this memory region
+ * @acc: access flags
+ *
+ * Returns the memory region on success, otherwise returns an errno.
+ * Note that all DMA addresses should be created via the
+ * struct ib_dma_mapping_ops functions (see dma.c).
+ */
+struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	/*
+	 * Alloc mr and init it.
+	 * Alloc lkey.
+	 */
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * rvt_reg_phys_mr - register a physical memory region
+ * @pd: protection domain for this memory region
+ * @buffer_list: pointer to the list of physical buffers to register
+ * @num_phys_buf: the number of physical buffers to register
+ * @iova_start: the starting address passed over IB which maps to this MR
+ *
+ * Returns the memory region on success, otherwise returns an errno.
+ */
+struct ib_mr *rvt_reg_phys_mr(struct ib_pd *pd,
+			      struct ib_phys_buf *buffer_list,
+			      int num_phys_buf, int acc, u64 *iova_start)
+{
+	/* Alloc mr and build it up */
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * rvt_reg_user_mr - register a userspace memory region
+ * @pd: protection domain for this memory region
+ * @start: starting userspace address
+ * @length: length of region to register
+ * @mr_access_flags: access flags for this memory region
+ * @udata: unused by the driver
+ *
+ * Returns the memory region on success, otherwise returns an errno.
+ */
+struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			      u64 virt_addr, int mr_access_flags,
+			      struct ib_udata *udata)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * rvt_dereg_mr - unregister and free a memory region
+ * @ibmr: the memory region to free
+ *
+ * Returns 0 on success.
+ *
+ * Note that this is called to free MRs created by rvt_get_dma_mr()
+ * or rvt_reg_user_mr().
+ */
+int rvt_dereg_mr(struct ib_mr *ibmr)
+{
+	return -EINVAL;
+}
+
+/**
+ * rvt_alloc_mr - Allocate a memory region usable with the
+ * @pd: protection domain for this memory region
+ * @mr_type: mem region type
+ * @max_num_sg: Max number of segments allowed
+ *
+ * Return the memory region on success, otherwise return an errno.
+ */
+struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_num_sg)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * rvt_alloc_fmr - allocate a fast memory region
+ * @pd: the protection domain for this memory region
+ * @mr_access_flags: access flags for this memory region
+ * @fmr_attr: fast memory region attributes
+ *
+ * Returns the memory region on success, otherwise returns an errno.
+ */
+struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
+			     struct ib_fmr_attr *fmr_attr)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * rvt_map_phys_fmr - set up a fast memory region
+ * @ibmfr: the fast memory region to set up
+ * @page_list: the list of pages to associate with the fast memory region
+ * @list_len: the number of pages to associate with the fast memory region
+ * @iova: the virtual address of the start of the fast memory region
+ *
+ * This may be called from interrupt context.
+ */
+
+int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
+		     int list_len, u64 iova)
+{
+	return -EINVAL;
+}
+
+/**
+ * rvt_unmap_fmr - unmap fast memory regions
+ * @fmr_list: the list of fast memory regions to unmap
+ *
+ * Returns 0 on success.
+ */
+int rvt_unmap_fmr(struct list_head *fmr_list)
+{
+	return -EINVAL;
+}
+
+/**
+ * rvt_dealloc_fmr - deallocate a fast memory region
+ * @ibfmr: the fast memory region to deallocate
+ *
+ * Returns 0 on success.
+ */
+int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
+{
+	return -EINVAL;
+}
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
new file mode 100644
index 0000000..1d3d14b
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -0,0 +1,75 @@
+#ifndef DEF_RVTMR_H
+#define DEF_RVTMR_H
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
+/* Mem Regions */
+struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc);
+struct ib_mr *rvt_reg_phys_mr(struct ib_pd *pd,
+			      struct ib_phys_buf *buffer_list,
+			      int num_phys_buf, int acc, u64 *iova_start);
+struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			      u64 virt_addr, int mr_access_flags,
+			      struct ib_udata *udata);
+int rvt_dereg_mr(struct ib_mr *ibmr);
+struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_num_sg);
+struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
+			     struct ib_fmr_attr *fmr_attr);
+int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
+		     int list_len, u64 iova);
+int rvt_unmap_fmr(struct list_head *fmr_list);
+int rvt_dealloc_fmr(struct ib_fmr *ibfmr);
+
+#endif          /* DEF_RVTMR_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index f750178..de64d18 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -238,6 +238,17 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, modify_ah);
 	CDR(rdi, query_ah);
 
+	/* Mem Region */
+	CDR(rdi, get_dma_mr);
+	CDR(rdi, reg_phys_mr);
+	CDR(rdi, reg_user_mr);
+	CDR(rdi, dereg_mr);
+	CDR(rdi, alloc_mr);
+	CDR(rdi, alloc_fmr);
+	CDR(rdi, map_phys_fmr);
+	CDR(rdi, unmap_fmr);
+	CDR(rdi, dealloc_fmr);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index af1df1b..7aad71b 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -56,5 +56,6 @@
 #include "pd.h"
 #include "qp.h"
 #include "ah.h"
+#include "mr.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

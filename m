From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 37/37] IB/rxe, IB/rdmavt: Use dma_virt_ops instead of duplicating it
Date: Fri, 20 Jan 2017 13:04:37 -0800
Message-ID: <20170120210437.26389-38-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the rxe and rdmavt drivers use dma_virt_ops. Update the
comments that refer to the source files removed by this patch.
Remove struct ib_dma_mapping_ops. Remove ib_device.dma_ops.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/Kconfig  |   1 +
 drivers/infiniband/sw/rdmavt/Makefile |   2 +-
 drivers/infiniband/sw/rdmavt/dma.c    | 198 ----------------------------------
 drivers/infiniband/sw/rdmavt/dma.h    |  53 ---------
 drivers/infiniband/sw/rdmavt/mr.c     |   8 +-
 drivers/infiniband/sw/rdmavt/vt.c     |   4 +-
 drivers/infiniband/sw/rdmavt/vt.h     |   1 -
 drivers/infiniband/sw/rxe/Kconfig     |   1 +
 drivers/infiniband/sw/rxe/Makefile    |   1 -
 drivers/infiniband/sw/rxe/rxe_dma.c   | 183 -------------------------------
 drivers/infiniband/sw/rxe/rxe_loc.h   |   2 -
 drivers/infiniband/sw/rxe/rxe_verbs.c |   3 +-
 include/rdma/ib_verbs.h               | 103 ++----------------
 13 files changed, 18 insertions(+), 542 deletions(-)
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
 delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c

diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
index 1da8d01a6855..fdd001ce13d8 100644
--- a/drivers/infiniband/sw/rdmavt/Kconfig
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -1,5 +1,6 @@
 config INFINIBAND_RDMAVT
 	tristate "RDMA verbs transport library"
 	depends on 64BIT
+	select DMA_VIRT_OPS
 	---help---
 	This is a common software verbs provider for RDMA networks.
diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index ccaa7992ac97..2a821d2fb569 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,7 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o \
+rdmavt-y := vt.o ah.o cq.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o \
 	trace.o
 
 CFLAGS_trace.o = -I$(src)
diff --git a/drivers/infiniband/sw/rdmavt/dma.c b/drivers/infiniband/sw/rdmavt/dma.c
deleted file mode 100644
index f2cefb0d9180..000000000000
--- a/drivers/infiniband/sw/rdmavt/dma.c
+++ /dev/null
@@ -1,198 +0,0 @@
-/*
- * Copyright(c) 2016 Intel Corporation.
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-#include <linux/types.h>
-#include <linux/scatterlist.h>
-#include <rdma/ib_verbs.h>
-
-#include "dma.h"
-
-#define BAD_DMA_ADDRESS ((u64)0)
-
-/*
- * The following functions implement driver specific replacements
- * for the ib_dma_*() functions.
- *
- * These functions return kernel virtual addresses instead of
- * device bus addresses since the driver uses the CPU to copy
- * data instead of using hardware DMA.
- */
-
-static int rvt_mapping_error(struct ib_device *dev, u64 dma_addr)
-{
-	return dma_addr == BAD_DMA_ADDRESS;
-}
-
-static u64 rvt_dma_map_single(struct ib_device *dev, void *cpu_addr,
-			      size_t size, enum dma_data_direction direction)
-{
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return BAD_DMA_ADDRESS;
-
-	return (u64)cpu_addr;
-}
-
-static void rvt_dma_unmap_single(struct ib_device *dev, u64 addr, size_t size,
-				 enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static u64 rvt_dma_map_page(struct ib_device *dev, struct page *page,
-			    unsigned long offset, size_t size,
-			    enum dma_data_direction direction)
-{
-	u64 addr;
-
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return BAD_DMA_ADDRESS;
-
-	addr = (u64)page_address(page);
-	if (addr)
-		addr += offset;
-
-	return addr;
-}
-
-static void rvt_dma_unmap_page(struct ib_device *dev, u64 addr, size_t size,
-			       enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static int rvt_map_sg(struct ib_device *dev, struct scatterlist *sgl,
-		      int nents, enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	u64 addr;
-	int i;
-	int ret = nents;
-
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return 0;
-
-	for_each_sg(sgl, sg, nents, i) {
-		addr = (u64)page_address(sg_page(sg));
-		if (!addr) {
-			ret = 0;
-			break;
-		}
-		sg->dma_address = addr + sg->offset;
-#ifdef CONFIG_NEED_SG_DMA_LENGTH
-		sg->dma_length = sg->length;
-#endif
-	}
-	return ret;
-}
-
-static void rvt_unmap_sg(struct ib_device *dev,
-			 struct scatterlist *sg, int nents,
-			 enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static int rvt_map_sg_attrs(struct ib_device *dev, struct scatterlist *sgl,
-			    int nents, enum dma_data_direction direction,
-			    unsigned long attrs)
-{
-	return rvt_map_sg(dev, sgl, nents, direction);
-}
-
-static void rvt_unmap_sg_attrs(struct ib_device *dev,
-			       struct scatterlist *sg, int nents,
-			       enum dma_data_direction direction,
-			       unsigned long attrs)
-{
-	return rvt_unmap_sg(dev, sg, nents, direction);
-}
-
-static void rvt_sync_single_for_cpu(struct ib_device *dev, u64 addr,
-				    size_t size, enum dma_data_direction dir)
-{
-}
-
-static void rvt_sync_single_for_device(struct ib_device *dev, u64 addr,
-				       size_t size,
-				       enum dma_data_direction dir)
-{
-}
-
-static void *rvt_dma_alloc_coherent(struct ib_device *dev, size_t size,
-				    u64 *dma_handle, gfp_t flag)
-{
-	struct page *p;
-	void *addr = NULL;
-
-	p = alloc_pages(flag, get_order(size));
-	if (p)
-		addr = page_address(p);
-	if (dma_handle)
-		*dma_handle = (u64)addr;
-	return addr;
-}
-
-static void rvt_dma_free_coherent(struct ib_device *dev, size_t size,
-				  void *cpu_addr, u64 dma_handle)
-{
-	free_pages((unsigned long)cpu_addr, get_order(size));
-}
-
-struct ib_dma_mapping_ops rvt_default_dma_mapping_ops = {
-	.mapping_error = rvt_mapping_error,
-	.map_single = rvt_dma_map_single,
-	.unmap_single = rvt_dma_unmap_single,
-	.map_page = rvt_dma_map_page,
-	.unmap_page = rvt_dma_unmap_page,
-	.map_sg = rvt_map_sg,
-	.unmap_sg = rvt_unmap_sg,
-	.map_sg_attrs = rvt_map_sg_attrs,
-	.unmap_sg_attrs = rvt_unmap_sg_attrs,
-	.sync_single_for_cpu = rvt_sync_single_for_cpu,
-	.sync_single_for_device = rvt_sync_single_for_device,
-	.alloc_coherent = rvt_dma_alloc_coherent,
-	.free_coherent = rvt_dma_free_coherent
-};
diff --git a/drivers/infiniband/sw/rdmavt/dma.h b/drivers/infiniband/sw/rdmavt/dma.h
deleted file mode 100644
index 979f07e09195..000000000000
--- a/drivers/infiniband/sw/rdmavt/dma.h
+++ /dev/null
@@ -1,53 +0,0 @@
-#ifndef DEF_RDMAVTDMA_H
-#define DEF_RDMAVTDMA_H
-
-/*
- * Copyright(c) 2016 Intel Corporation.
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-extern struct ib_dma_mapping_ops rvt_default_dma_mapping_ops;
-
-#endif          /* DEF_RDMAVTDMA_H */
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 52fd15276ee6..14d0ac6efd08 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -305,8 +305,8 @@ static void __rvt_free_mr(struct rvt_mr *mr)
  * @acc: access flags
  *
  * Return: the memory region on success, otherwise returns an errno.
- * Note that all DMA addresses should be created via the
- * struct ib_dma_mapping_ops functions (see dma.c).
+ * Note that all DMA addresses should be created via the functions in
+ * struct dma_virt_ops.
  */
 struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
 {
@@ -782,7 +782,7 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 
 	/*
 	 * We use LKEY == zero for kernel virtual addresses
-	 * (see rvt_get_dma_mr and dma.c).
+	 * (see rvt_get_dma_mr() and dma_virt_ops).
 	 */
 	rcu_read_lock();
 	if (sge->lkey == 0) {
@@ -880,7 +880,7 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 
 	/*
 	 * We use RKEY == zero for kernel virtual addresses
-	 * (see rvt_get_dma_mr and dma.c).
+	 * (see rvt_get_dma_mr() and dma_virt_ops).
 	 */
 	rcu_read_lock();
 	if (rkey == 0) {
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d430c2f7cec4..19666e52b3b1 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -47,6 +47,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/dma-mapping.h>
 #include "vt.h"
 #include "trace.h"
 
@@ -777,8 +778,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	}
 
 	/* DMA Operations */
-	rdi->ibdev.dma_ops =
-		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
+	rdi->ibdev.dev.dma_ops = rdi->ibdev.dev.dma_ops ? : &dma_virt_ops;
 
 	/* Protection Domain */
 	spin_lock_init(&rdi->n_pds_lock);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index 6b01eaa4461b..f363505312be 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -50,7 +50,6 @@
 
 #include <rdma/rdma_vt.h>
 #include <linux/pci.h>
-#include "dma.h"
 #include "pd.h"
 #include "qp.h"
 #include "ah.h"
diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
index 1e4e628fe7b0..7d1ac27ed251 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -2,6 +2,7 @@ config RDMA_RXE
 	tristate "Software RDMA over Ethernet (RoCE) driver"
 	depends on INET && PCI && INFINIBAND
 	depends on NET_UDP_TUNNEL
+	select DMA_VIRT_OPS
 	---help---
 	This driver implements the InfiniBand RDMA transport over
 	the Linux network stack. It enables a system with a
diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
index 3b3fb9d1c470..ec35ff022a42 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -14,7 +14,6 @@ rdma_rxe-y := \
 	rxe_qp.o \
 	rxe_cq.o \
 	rxe_mr.o \
-	rxe_dma.o \
 	rxe_opcode.o \
 	rxe_mmap.o \
 	rxe_icrc.o \
diff --git a/drivers/infiniband/sw/rxe/rxe_dma.c b/drivers/infiniband/sw/rxe/rxe_dma.c
deleted file mode 100644
index a0f8af5851ae..000000000000
--- a/drivers/infiniband/sw/rxe/rxe_dma.c
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
- * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *	- Redistributions of source code must retain the above
- *	  copyright notice, this list of conditions and the following
- *	  disclaimer.
- *
- *	- Redistributions in binary form must reproduce the above
- *	  copyright notice, this list of conditions and the following
- *	  disclaimer in the documentation and/or other materials
- *	  provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include "rxe.h"
-#include "rxe_loc.h"
-
-#define DMA_BAD_ADDER ((u64)0)
-
-static int rxe_mapping_error(struct ib_device *dev, u64 dma_addr)
-{
-	return dma_addr == DMA_BAD_ADDER;
-}
-
-static u64 rxe_dma_map_single(struct ib_device *dev,
-			      void *cpu_addr, size_t size,
-			      enum dma_data_direction direction)
-{
-	WARN_ON(!valid_dma_direction(direction));
-	return (uintptr_t)cpu_addr;
-}
-
-static void rxe_dma_unmap_single(struct ib_device *dev,
-				 u64 addr, size_t size,
-				 enum dma_data_direction direction)
-{
-	WARN_ON(!valid_dma_direction(direction));
-}
-
-static u64 rxe_dma_map_page(struct ib_device *dev,
-			    struct page *page,
-			    unsigned long offset,
-			    size_t size, enum dma_data_direction direction)
-{
-	u64 addr;
-
-	WARN_ON(!valid_dma_direction(direction));
-
-	if (offset + size > PAGE_SIZE) {
-		addr = DMA_BAD_ADDER;
-		goto done;
-	}
-
-	addr = (uintptr_t)page_address(page);
-	if (addr)
-		addr += offset;
-
-done:
-	return addr;
-}
-
-static void rxe_dma_unmap_page(struct ib_device *dev,
-			       u64 addr, size_t size,
-			       enum dma_data_direction direction)
-{
-	WARN_ON(!valid_dma_direction(direction));
-}
-
-static int rxe_map_sg(struct ib_device *dev, struct scatterlist *sgl,
-		      int nents, enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	u64 addr;
-	int i;
-	int ret = nents;
-
-	WARN_ON(!valid_dma_direction(direction));
-
-	for_each_sg(sgl, sg, nents, i) {
-		addr = (uintptr_t)page_address(sg_page(sg));
-		if (!addr) {
-			ret = 0;
-			break;
-		}
-		sg->dma_address = addr + sg->offset;
-#ifdef CONFIG_NEED_SG_DMA_LENGTH
-		sg->dma_length = sg->length;
-#endif
-	}
-
-	return ret;
-}
-
-static void rxe_unmap_sg(struct ib_device *dev,
-			 struct scatterlist *sg, int nents,
-			 enum dma_data_direction direction)
-{
-	WARN_ON(!valid_dma_direction(direction));
-}
-
-static int rxe_map_sg_attrs(struct ib_device *dev, struct scatterlist *sgl,
-			    int nents, enum dma_data_direction direction,
-			    unsigned long attrs)
-{
-	return rxe_map_sg(dev, sgl, nents, direction);
-}
-
-static void rxe_unmap_sg_attrs(struct ib_device *dev,
-			       struct scatterlist *sg, int nents,
-			       enum dma_data_direction direction,
-			       unsigned long attrs)
-{
-	rxe_unmap_sg(dev, sg, nents, direction);
-}
-
-static void rxe_sync_single_for_cpu(struct ib_device *dev,
-				    u64 addr,
-				    size_t size, enum dma_data_direction dir)
-{
-}
-
-static void rxe_sync_single_for_device(struct ib_device *dev,
-				       u64 addr,
-				       size_t size, enum dma_data_direction dir)
-{
-}
-
-static void *rxe_dma_alloc_coherent(struct ib_device *dev, size_t size,
-				    u64 *dma_handle, gfp_t flag)
-{
-	struct page *p;
-	void *addr = NULL;
-
-	p = alloc_pages(flag, get_order(size));
-	if (p)
-		addr = page_address(p);
-
-	if (dma_handle)
-		*dma_handle = (uintptr_t)addr;
-
-	return addr;
-}
-
-static void rxe_dma_free_coherent(struct ib_device *dev, size_t size,
-				  void *cpu_addr, u64 dma_handle)
-{
-	free_pages((unsigned long)cpu_addr, get_order(size));
-}
-
-struct ib_dma_mapping_ops rxe_dma_mapping_ops = {
-	.mapping_error		= rxe_mapping_error,
-	.map_single		= rxe_dma_map_single,
-	.unmap_single		= rxe_dma_unmap_single,
-	.map_page		= rxe_dma_map_page,
-	.unmap_page		= rxe_dma_unmap_page,
-	.map_sg			= rxe_map_sg,
-	.unmap_sg		= rxe_unmap_sg,
-	.map_sg_attrs		= rxe_map_sg_attrs,
-	.unmap_sg_attrs		= rxe_unmap_sg_attrs,
-	.sync_single_for_cpu	= rxe_sync_single_for_cpu,
-	.sync_single_for_device	= rxe_sync_single_for_device,
-	.alloc_coherent		= rxe_dma_alloc_coherent,
-	.free_coherent		= rxe_dma_free_coherent
-};
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index efe4c6a35442..267f89d91da7 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -221,8 +221,6 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 		      struct ib_srq_attr *attr, enum ib_srq_attr_mask mask,
 		      struct ib_udata *udata);
 
-extern struct ib_dma_mapping_ops rxe_dma_mapping_ops;
-
 void rxe_release(struct kref *kref);
 
 int rxe_completer(void *arg);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index b707fc3bca2a..fd27d2b7fdc1 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/dma-mapping.h>
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
@@ -1237,7 +1238,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->dev.parent = rxe->ifc_ops->dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	dev->node_guid = rxe->ifc_ops->node_guid(rxe);
-	dev->dma_ops = &rxe_dma_mapping_ops;
+	dev->dev.dma_ops = &dma_virt_ops;
 
 	dev->uverbs_abi_ver = RXE_UVERBS_ABI_VERSION;
 	dev->uverbs_cmd_mask = BIT_ULL(IB_USER_VERBS_CMD_GET_CONTEXT)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f09ed2f81c91..24b49b747e90 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1783,53 +1783,6 @@ struct ib_cache {
 	u8                     *lmc_cache;
 };
 
-struct ib_dma_mapping_ops {
-	int		(*mapping_error)(struct ib_device *dev,
-					 u64 dma_addr);
-	u64		(*map_single)(struct ib_device *dev,
-				      void *ptr, size_t size,
-				      enum dma_data_direction direction);
-	void		(*unmap_single)(struct ib_device *dev,
-					u64 addr, size_t size,
-					enum dma_data_direction direction);
-	u64		(*map_page)(struct ib_device *dev,
-				    struct page *page, unsigned long offset,
-				    size_t size,
-				    enum dma_data_direction direction);
-	void		(*unmap_page)(struct ib_device *dev,
-				      u64 addr, size_t size,
-				      enum dma_data_direction direction);
-	int		(*map_sg)(struct ib_device *dev,
-				  struct scatterlist *sg, int nents,
-				  enum dma_data_direction direction);
-	void		(*unmap_sg)(struct ib_device *dev,
-				    struct scatterlist *sg, int nents,
-				    enum dma_data_direction direction);
-	int		(*map_sg_attrs)(struct ib_device *dev,
-					struct scatterlist *sg, int nents,
-					enum dma_data_direction direction,
-					unsigned long attrs);
-	void		(*unmap_sg_attrs)(struct ib_device *dev,
-					  struct scatterlist *sg, int nents,
-					  enum dma_data_direction direction,
-					  unsigned long attrs);
-	void		(*sync_single_for_cpu)(struct ib_device *dev,
-					       u64 dma_handle,
-					       size_t size,
-					       enum dma_data_direction dir);
-	void		(*sync_single_for_device)(struct ib_device *dev,
-						  u64 dma_handle,
-						  size_t size,
-						  enum dma_data_direction dir);
-	void		*(*alloc_coherent)(struct ib_device *dev,
-					   size_t size,
-					   u64 *dma_handle,
-					   gfp_t flag);
-	void		(*free_coherent)(struct ib_device *dev,
-					 size_t size, void *cpu_addr,
-					 u64 dma_handle);
-};
-
 struct iw_cm_verbs;
 
 struct ib_port_immutable {
@@ -2089,7 +2042,6 @@ struct ib_device {
 							   struct ib_rwq_ind_table_init_attr *init_attr,
 							   struct ib_udata *udata);
 	int                        (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
-	struct ib_dma_mapping_ops   *dma_ops;
 
 	struct module               *owner;
 	struct device                dev;
@@ -2964,8 +2916,6 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
  */
 static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->mapping_error(dev, dma_addr);
 	return dma_mapping_error(&dev->dev, dma_addr);
 }
 
@@ -2980,8 +2930,6 @@ static inline u64 ib_dma_map_single(struct ib_device *dev,
 				    void *cpu_addr, size_t size,
 				    enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_single(dev, cpu_addr, size, direction);
 	return dma_map_single(&dev->dev, cpu_addr, size, direction);
 }
 
@@ -2996,10 +2944,7 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 				       u64 addr, size_t size,
 				       enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_single(dev, addr, size, direction);
-	else
-		dma_unmap_single(&dev->dev, addr, size, direction);
+	dma_unmap_single(&dev->dev, addr, size, direction);
 }
 
 /**
@@ -3016,8 +2961,6 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
 				  size_t size,
 					 enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_page(dev, page, offset, size, direction);
 	return dma_map_page(&dev->dev, page, offset, size, direction);
 }
 
@@ -3032,10 +2975,7 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
 				     u64 addr, size_t size,
 				     enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_page(dev, addr, size, direction);
-	else
-		dma_unmap_page(&dev->dev, addr, size, direction);
+	dma_unmap_page(&dev->dev, addr, size, direction);
 }
 
 /**
@@ -3049,8 +2989,6 @@ static inline int ib_dma_map_sg(struct ib_device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_sg(dev, sg, nents, direction);
 	return dma_map_sg(&dev->dev, sg, nents, direction);
 }
 
@@ -3065,10 +3003,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 				   struct scatterlist *sg, int nents,
 				   enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_sg(dev, sg, nents, direction);
-	else
-		dma_unmap_sg(&dev->dev, sg, nents, direction);
+	dma_unmap_sg(&dev->dev, sg, nents, direction);
 }
 
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
@@ -3076,9 +3011,6 @@ static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      enum dma_data_direction direction,
 				      unsigned long dma_attrs)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_sg_attrs(dev, sg, nents, direction,
-						  dma_attrs);
 	return dma_map_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
 }
 
@@ -3087,11 +3019,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 enum dma_data_direction direction,
 					 unsigned long dma_attrs)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->unmap_sg_attrs(dev, sg, nents, direction,
-						  dma_attrs);
-	else
-		dma_unmap_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
+	dma_unmap_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
@@ -3133,10 +3061,7 @@ static inline void ib_dma_sync_single_for_cpu(struct ib_device *dev,
 					      size_t size,
 					      enum dma_data_direction dir)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->sync_single_for_cpu(dev, addr, size, dir);
-	else
-		dma_sync_single_for_cpu(&dev->dev, addr, size, dir);
+	dma_sync_single_for_cpu(&dev->dev, addr, size, dir);
 }
 
 /**
@@ -3151,10 +3076,7 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->sync_single_for_device(dev, addr, size, dir);
-	else
-		dma_sync_single_for_device(&dev->dev, addr, size, dir);
+	dma_sync_single_for_device(&dev->dev, addr, size, dir);
 }
 
 /**
@@ -3169,14 +3091,6 @@ static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
 					   dma_addr_t *dma_handle,
 					   gfp_t flag)
 {
-	if (dev->dma_ops) {
-		u64 handle;
-		void *ret;
-
-		ret = dev->dma_ops->alloc_coherent(dev, size, &handle, flag);
-		*dma_handle = handle;
-		return ret;
-	}
 	return dma_alloc_coherent(&dev->dev, size, dma_handle, flag);
 }
 
@@ -3191,10 +3105,7 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 					size_t size, void *cpu_addr,
 					dma_addr_t dma_handle)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
-	else
-		dma_free_coherent(&dev->dev, size, cpu_addr, dma_handle);
+	dma_free_coherent(&dev->dev, size, cpu_addr, dma_handle);
 }
 
 /**
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

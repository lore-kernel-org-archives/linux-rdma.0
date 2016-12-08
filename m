From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] IB: Switch from struct ib_dma_mapping_ops to struct
 dma_mapping_ops
Date: Wed, 7 Dec 2016 17:11:49 -0800
Message-ID: <25d066c2-59d7-2be7-dd56-e29e99b43620@sandisk.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <07c07529-4636-fafb-2598-7358d8a1460d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Additionally, use dma_noop_ops instead of duplicating it.

This patch eliminates one branch from every ib_dma_map_*() call.
---
 drivers/infiniband/hw/hfi1/dma.c      | 183 -------------------------------
 drivers/infiniband/hw/qib/qib_dma.c   | 169 -----------------------------
 drivers/infiniband/hw/qib/qib_keys.c  |   2 +-
 drivers/infiniband/sw/rdmavt/Makefile |   2 +-
 drivers/infiniband/sw/rdmavt/dma.c    | 198 ----------------------------------
 drivers/infiniband/sw/rdmavt/dma.h    |  53 ---------
 drivers/infiniband/sw/rdmavt/mr.c     |   4 +-
 drivers/infiniband/sw/rdmavt/vt.c     |   4 +-
 drivers/infiniband/sw/rdmavt/vt.h     |   1 -
 drivers/infiniband/sw/rxe/Makefile    |   1 -
 drivers/infiniband/sw/rxe/rxe_dma.c   | 183 -------------------------------
 drivers/infiniband/sw/rxe/rxe_loc.h   |   2 -
 drivers/infiniband/sw/rxe/rxe_verbs.c |   2 +-
 include/rdma/ib_verbs.h               | 117 +++-----------------
 14 files changed, 22 insertions(+), 899 deletions(-)
 delete mode 100644 drivers/infiniband/hw/hfi1/dma.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_dma.c
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
 delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c

diff --git a/drivers/infiniband/hw/hfi1/dma.c b/drivers/infiniband/hw/hfi1/dma.c
deleted file mode 100644
index 7e8dab892848..000000000000
--- a/drivers/infiniband/hw/hfi1/dma.c
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- * Copyright(c) 2015, 2016 Intel Corporation.
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
-
-#include "verbs.h"
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
-static int hfi1_mapping_error(struct ib_device *dev, u64 dma_addr)
-{
-	return dma_addr == BAD_DMA_ADDRESS;
-}
-
-static u64 hfi1_dma_map_single(struct ib_device *dev, void *cpu_addr,
-			       size_t size, enum dma_data_direction direction)
-{
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return BAD_DMA_ADDRESS;
-
-	return (u64)cpu_addr;
-}
-
-static void hfi1_dma_unmap_single(struct ib_device *dev, u64 addr, size_t size,
-				  enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static u64 hfi1_dma_map_page(struct ib_device *dev, struct page *page,
-			     unsigned long offset, size_t size,
-			    enum dma_data_direction direction)
-{
-	u64 addr;
-
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return BAD_DMA_ADDRESS;
-
-	if (offset + size > PAGE_SIZE)
-		return BAD_DMA_ADDRESS;
-
-	addr = (u64)page_address(page);
-	if (addr)
-		addr += offset;
-
-	return addr;
-}
-
-static void hfi1_dma_unmap_page(struct ib_device *dev, u64 addr, size_t size,
-				enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static int hfi1_map_sg(struct ib_device *dev, struct scatterlist *sgl,
-		       int nents, enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	u64 addr;
-	int i;
-	int ret = nents;
-
-	if (WARN_ON(!valid_dma_direction(direction)))
-		return BAD_DMA_ADDRESS;
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
-static void hfi1_unmap_sg(struct ib_device *dev,
-			  struct scatterlist *sg, int nents,
-			 enum dma_data_direction direction)
-{
-	/* This is a stub, nothing to be done here */
-}
-
-static void hfi1_sync_single_for_cpu(struct ib_device *dev, u64 addr,
-				     size_t size, enum dma_data_direction dir)
-{
-}
-
-static void hfi1_sync_single_for_device(struct ib_device *dev, u64 addr,
-					size_t size,
-					enum dma_data_direction dir)
-{
-}
-
-static void *hfi1_dma_alloc_coherent(struct ib_device *dev, size_t size,
-				     u64 *dma_handle, gfp_t flag)
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
-static void hfi1_dma_free_coherent(struct ib_device *dev, size_t size,
-				   void *cpu_addr, u64 dma_handle)
-{
-	free_pages((unsigned long)cpu_addr, get_order(size));
-}
-
-struct ib_dma_mapping_ops hfi1_dma_mapping_ops = {
-	.mapping_error = hfi1_mapping_error,
-	.map_single = hfi1_dma_map_single,
-	.unmap_single = hfi1_dma_unmap_single,
-	.map_page = hfi1_dma_map_page,
-	.unmap_page = hfi1_dma_unmap_page,
-	.map_sg = hfi1_map_sg,
-	.unmap_sg = hfi1_unmap_sg,
-	.sync_single_for_cpu = hfi1_sync_single_for_cpu,
-	.sync_single_for_device = hfi1_sync_single_for_device,
-	.alloc_coherent = hfi1_dma_alloc_coherent,
-	.free_coherent = hfi1_dma_free_coherent
-};
diff --git a/drivers/infiniband/hw/qib/qib_dma.c b/drivers/infiniband/hw/qib/qib_dma.c
deleted file mode 100644
index 59fe092b4b0f..000000000000
--- a/drivers/infiniband/hw/qib/qib_dma.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright (c) 2006, 2009, 2010 QLogic, Corporation. All rights reserved.
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
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
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
-#include <linux/types.h>
-#include <linux/scatterlist.h>
-
-#include "qib_verbs.h"
-
-#define BAD_DMA_ADDRESS ((u64) 0)
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
-static int qib_mapping_error(struct ib_device *dev, u64 dma_addr)
-{
-	return dma_addr == BAD_DMA_ADDRESS;
-}
-
-static u64 qib_dma_map_single(struct ib_device *dev, void *cpu_addr,
-			      size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	return (u64) cpu_addr;
-}
-
-static void qib_dma_unmap_single(struct ib_device *dev, u64 addr, size_t size,
-				 enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
-static u64 qib_dma_map_page(struct ib_device *dev, struct page *page,
-			    unsigned long offset, size_t size,
-			    enum dma_data_direction direction)
-{
-	u64 addr;
-
-	BUG_ON(!valid_dma_direction(direction));
-
-	if (offset + size > PAGE_SIZE) {
-		addr = BAD_DMA_ADDRESS;
-		goto done;
-	}
-
-	addr = (u64) page_address(page);
-	if (addr)
-		addr += offset;
-	/* TODO: handle highmem pages */
-
-done:
-	return addr;
-}
-
-static void qib_dma_unmap_page(struct ib_device *dev, u64 addr, size_t size,
-			       enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
-static int qib_map_sg(struct ib_device *dev, struct scatterlist *sgl,
-		      int nents, enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	u64 addr;
-	int i;
-	int ret = nents;
-
-	BUG_ON(!valid_dma_direction(direction));
-
-	for_each_sg(sgl, sg, nents, i) {
-		addr = (u64) page_address(sg_page(sg));
-		/* TODO: handle highmem pages */
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
-static void qib_unmap_sg(struct ib_device *dev,
-			 struct scatterlist *sg, int nents,
-			 enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
-static void qib_sync_single_for_cpu(struct ib_device *dev, u64 addr,
-				    size_t size, enum dma_data_direction dir)
-{
-}
-
-static void qib_sync_single_for_device(struct ib_device *dev, u64 addr,
-				       size_t size,
-				       enum dma_data_direction dir)
-{
-}
-
-static void *qib_dma_alloc_coherent(struct ib_device *dev, size_t size,
-				    u64 *dma_handle, gfp_t flag)
-{
-	struct page *p;
-	void *addr = NULL;
-
-	p = alloc_pages(flag, get_order(size));
-	if (p)
-		addr = page_address(p);
-	if (dma_handle)
-		*dma_handle = (u64) addr;
-	return addr;
-}
-
-static void qib_dma_free_coherent(struct ib_device *dev, size_t size,
-				  void *cpu_addr, u64 dma_handle)
-{
-	free_pages((unsigned long) cpu_addr, get_order(size));
-}
-
-struct ib_dma_mapping_ops qib_dma_mapping_ops = {
-	.mapping_error = qib_mapping_error,
-	.map_single = qib_dma_map_single,
-	.unmap_single = qib_dma_unmap_single,
-	.map_page = qib_dma_map_page,
-	.unmap_page = qib_dma_unmap_page,
-	.map_sg = qib_map_sg,
-	.unmap_sg = qib_unmap_sg,
-	.sync_single_for_cpu = qib_sync_single_for_cpu,
-	.sync_single_for_device = qib_sync_single_for_device,
-	.alloc_coherent = qib_dma_alloc_coherent,
-	.free_coherent = qib_dma_free_coherent
-};
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 2c3c93572c17..d2f64a03733e 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -160,7 +160,7 @@ int qib_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 
 	/*
 	 * We use RKEY == zero for kernel virtual addresses
-	 * (see qib_get_dma_mr and qib_dma.c).
+	 * (see qib_get_dma_mr).
 	 */
 	rcu_read_lock();
 	if (rkey == 0) {
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
index 46b64970058e..e12f1345bbab 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -303,8 +303,8 @@ static void __rvt_free_mr(struct rvt_mr *mr)
  * @acc: access flags
  *
  * Return: the memory region on success, otherwise returns an errno.
- * Note that all DMA addresses should be created via the
- * struct ib_dma_mapping_ops functions (see dma.c).
+ * Note that all DMA addresses should be created via the functions in
+ * struct dma_noop_ops.
  */
 struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
 {
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d430c2f7cec4..1014a813a942 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -777,8 +777,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	}
 
 	/* DMA Operations */
-	rdi->ibdev.dma_ops =
-		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
+	if (rdi->ibdev.dma_device->dma_ops == NULL)
+		set_dma_ops(rdi->ibdev.dma_device, &dma_noop_ops);
 
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
index 73849a5a91b3..a075023332dc 100644
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
index 19841c863daf..c4a5154928b7 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1226,7 +1226,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->dma_device = rxe->ifc_ops->dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	dev->node_guid = rxe->ifc_ops->node_guid(rxe);
-	dev->dma_ops = &rxe_dma_mapping_ops;
+	set_dma_ops(dev->dma_device, &dma_noop_ops);
 
 	dev->uverbs_abi_ver = RXE_UVERBS_ABI_VERSION;
 	dev->uverbs_cmd_mask = BIT_ULL(IB_USER_VERBS_CMD_GET_CONTEXT)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a487745..663a28f37570 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1763,53 +1763,6 @@ struct ib_cache {
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
@@ -2070,7 +2023,6 @@ struct ib_device {
 							   struct ib_rwq_ind_table_init_attr *init_attr,
 							   struct ib_udata *udata);
 	int                        (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
-	struct ib_dma_mapping_ops   *dma_ops;
 
 	struct module               *owner;
 	struct device                dev;
@@ -2927,8 +2879,6 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
  */
 static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->mapping_error(dev, dma_addr);
 	return dma_mapping_error(dev->dma_device, dma_addr);
 }
 
@@ -2943,8 +2893,6 @@ static inline u64 ib_dma_map_single(struct ib_device *dev,
 				    void *cpu_addr, size_t size,
 				    enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_single(dev, cpu_addr, size, direction);
 	return dma_map_single(dev->dma_device, cpu_addr, size, direction);
 }
 
@@ -2959,10 +2907,7 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 				       u64 addr, size_t size,
 				       enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_single(dev, addr, size, direction);
-	else
-		dma_unmap_single(dev->dma_device, addr, size, direction);
+	dma_unmap_single(dev->dma_device, addr, size, direction);
 }
 
 static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
@@ -2997,8 +2942,6 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
 				  size_t size,
 					 enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_page(dev, page, offset, size, direction);
 	return dma_map_page(dev->dma_device, page, offset, size, direction);
 }
 
@@ -3013,10 +2956,7 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
 				     u64 addr, size_t size,
 				     enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_page(dev, addr, size, direction);
-	else
-		dma_unmap_page(dev->dma_device, addr, size, direction);
+	dma_unmap_page(dev->dma_device, addr, size, direction);
 }
 
 /**
@@ -3030,8 +2970,6 @@ static inline int ib_dma_map_sg(struct ib_device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_sg(dev, sg, nents, direction);
 	return dma_map_sg(dev->dma_device, sg, nents, direction);
 }
 
@@ -3046,10 +2984,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 				   struct scatterlist *sg, int nents,
 				   enum dma_data_direction direction)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->unmap_sg(dev, sg, nents, direction);
-	else
-		dma_unmap_sg(dev->dma_device, sg, nents, direction);
+	dma_unmap_sg(dev->dma_device, sg, nents, direction);
 }
 
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
@@ -3057,12 +2992,8 @@ static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      enum dma_data_direction direction,
 				      unsigned long dma_attrs)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->map_sg_attrs(dev, sg, nents, direction,
-						  dma_attrs);
-	else
-		return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
-					dma_attrs);
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
+				dma_attrs);
 }
 
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
@@ -3070,12 +3001,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 enum dma_data_direction direction,
 					 unsigned long dma_attrs)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->unmap_sg_attrs(dev, sg, nents, direction,
-						  dma_attrs);
-	else
-		dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction,
-				   dma_attrs);
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
@@ -3117,10 +3043,7 @@ static inline void ib_dma_sync_single_for_cpu(struct ib_device *dev,
 					      size_t size,
 					      enum dma_data_direction dir)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->sync_single_for_cpu(dev, addr, size, dir);
-	else
-		dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
+	dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
 }
 
 /**
@@ -3135,10 +3058,7 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->sync_single_for_device(dev, addr, size, dir);
-	else
-		dma_sync_single_for_device(dev->dma_device, addr, size, dir);
+	dma_sync_single_for_device(dev->dma_device, addr, size, dir);
 }
 
 /**
@@ -3153,16 +3073,12 @@ static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
 					   u64 *dma_handle,
 					   gfp_t flag)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->alloc_coherent(dev, size, dma_handle, flag);
-	else {
-		dma_addr_t handle;
-		void *ret;
-
-		ret = dma_alloc_coherent(dev->dma_device, size, &handle, flag);
-		*dma_handle = handle;
-		return ret;
-	}
+	dma_addr_t handle;
+	void *ret;
+
+	ret = dma_alloc_coherent(dev->dma_device, size, &handle, flag);
+	*dma_handle = handle;
+	return ret;
 }
 
 /**
@@ -3176,10 +3092,7 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 					size_t size, void *cpu_addr,
 					u64 dma_handle)
 {
-	if (dev->dma_ops)
-		dev->dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
-	else
-		dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
+	dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
 }
 
 /**
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

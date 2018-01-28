From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] IB/cxgb3: remove cxio_dbg.c
Date: Sun, 28 Jan 2018 15:11:29 +0000
Message-ID: <1517152289-25052-1-git-send-email-clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, hal.rosenstock@gmail.com, sean.hefty@intel.com, swise@chelsio.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
List-Id: linux-rdma@vger.kernel.org

cxio_dbg.c is uncompiled since commit 2b540355cd2f ("RDMA/cxgb3: cleanups")
10 years after, we could remove it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/infiniband/hw/cxgb3/cxio_dbg.c | 206 ---------------------------------
 1 file changed, 206 deletions(-)
 delete mode 100644 drivers/infiniband/hw/cxgb3/cxio_dbg.c

diff --git a/drivers/infiniband/hw/cxgb3/cxio_dbg.c b/drivers/infiniband/hw/cxgb3/cxio_dbg.c
deleted file mode 100644
index 97dbe728520a..000000000000
--- a/drivers/infiniband/hw/cxgb3/cxio_dbg.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/*
- * Copyright (c) 2006 Chelsio, Inc. All rights reserved.
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
-#ifdef DEBUG
-#include <linux/types.h>
-#include <linux/slab.h>
-#include "common.h"
-#include "cxgb3_ioctl.h"
-#include "cxio_hal.h"
-#include "cxio_wr.h"
-
-void cxio_dump_tpt(struct cxio_rdev *rdev, u32 stag)
-{
-	struct ch_mem_range *m;
-	u64 *data;
-	int rc;
-	int size = 32;
-
-	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m)
-		return;
-
-	m->mem_id = MEM_PMRX;
-	m->addr = (stag>>8) * 32 + rdev->rnic_info.tpt_base;
-	m->len = size;
-	pr_debug("%s TPT addr 0x%x len %d\n", __func__, m->addr, m->len);
-	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
-	if (rc) {
-		pr_debug("%s toectl returned error %d\n", __func__, rc);
-		kfree(m);
-		return;
-	}
-
-	data = (u64 *)m->buf;
-	while (size > 0) {
-		pr_debug("TPT %08x: %016llx\n",
-			 m->addr, (unsigned long long)*data);
-		size -= 8;
-		data++;
-		m->addr += 8;
-	}
-	kfree(m);
-}
-
-void cxio_dump_pbl(struct cxio_rdev *rdev, u32 pbl_addr, uint len, u8 shift)
-{
-	struct ch_mem_range *m;
-	u64 *data;
-	int rc;
-	int size, npages;
-
-	shift += 12;
-	npages = (len + (1ULL << shift) - 1) >> shift;
-	size = npages * sizeof(u64);
-
-	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m)
-		return;
-
-	m->mem_id = MEM_PMRX;
-	m->addr = pbl_addr;
-	m->len = size;
-	pr_debug("%s PBL addr 0x%x len %d depth %d\n",
-		 __func__, m->addr, m->len, npages);
-	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
-	if (rc) {
-		pr_debug("%s toectl returned error %d\n", __func__, rc);
-		kfree(m);
-		return;
-	}
-
-	data = (u64 *)m->buf;
-	while (size > 0) {
-		pr_debug("PBL %08x: %016llx\n",
-			 m->addr, (unsigned long long)*data);
-		size -= 8;
-		data++;
-		m->addr += 8;
-	}
-	kfree(m);
-}
-
-void cxio_dump_wqe(union t3_wr *wqe)
-{
-	__be64 *data = (__be64 *)wqe;
-	uint size = (uint)(be64_to_cpu(*data) & 0xff);
-
-	if (size == 0)
-		size = 8;
-	while (size > 0) {
-		pr_debug("WQE %p: %016llx\n",
-			 data, (unsigned long long)be64_to_cpu(*data));
-		size--;
-		data++;
-	}
-}
-
-void cxio_dump_wce(struct t3_cqe *wce)
-{
-	__be64 *data = (__be64 *)wce;
-	int size = sizeof(*wce);
-
-	while (size > 0) {
-		pr_debug("WCE %p: %016llx\n",
-			 data, (unsigned long long)be64_to_cpu(*data));
-		size -= 8;
-		data++;
-	}
-}
-
-void cxio_dump_rqt(struct cxio_rdev *rdev, u32 hwtid, int nents)
-{
-	struct ch_mem_range *m;
-	int size = nents * 64;
-	u64 *data;
-	int rc;
-
-	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m)
-		return;
-
-	m->mem_id = MEM_PMRX;
-	m->addr = ((hwtid)<<10) + rdev->rnic_info.rqt_base;
-	m->len = size;
-	pr_debug("%s RQT addr 0x%x len %d\n", __func__, m->addr, m->len);
-	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
-	if (rc) {
-		pr_debug("%s toectl returned error %d\n", __func__, rc);
-		kfree(m);
-		return;
-	}
-
-	data = (u64 *)m->buf;
-	while (size > 0) {
-		pr_debug("RQT %08x: %016llx\n",
-			 m->addr, (unsigned long long)*data);
-		size -= 8;
-		data++;
-		m->addr += 8;
-	}
-	kfree(m);
-}
-
-void cxio_dump_tcb(struct cxio_rdev *rdev, u32 hwtid)
-{
-	struct ch_mem_range *m;
-	int size = TCB_SIZE;
-	u32 *data;
-	int rc;
-
-	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m)
-		return;
-
-	m->mem_id = MEM_CM;
-	m->addr = hwtid * size;
-	m->len = size;
-	pr_debug("%s TCB %d len %d\n", __func__, m->addr, m->len);
-	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
-	if (rc) {
-		pr_debug("%s toectl returned error %d\n", __func__, rc);
-		kfree(m);
-		return;
-	}
-
-	data = (u32 *)m->buf;
-	while (size > 0) {
-		printk("%2u: %08x %08x %08x %08x %08x %08x %08x %08x\n",
-			m->addr,
-			*(data+2), *(data+3), *(data),*(data+1),
-			*(data+6), *(data+7), *(data+4), *(data+5));
-		size -= 32;
-		data += 8;
-		m->addr += 32;
-	}
-	kfree(m);
-}
-#endif
-- 
2.13.6

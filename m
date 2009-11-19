From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 45/53] IB/qib: Add qib_user_pages.c
Date: Thu, 19 Nov 2009 15:40:53 -0800
Message-ID: <20091119234053.30356.69959.stgit@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233655.30356.57433.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

creates the qib_user_pages.c file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_user_pages.c |  163 ++++++++++++++++++++++++++++
 1 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_user_pages.c

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
new file mode 100644
index 0000000..a0406a2
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
+ * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
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
+
+#include <linux/mm.h>
+#include <linux/device.h>
+
+#include "qib.h"
+
+static void __qib_release_user_pages(struct page **p, size_t num_pages,
+				     int dirty)
+{
+	size_t i;
+
+	for (i = 0; i < num_pages; i++) {
+		qib_cdbg(MM, "%lu/%lu put_page %p\n", (unsigned long) i,
+			 (unsigned long) num_pages, p[i]);
+		if (dirty)
+			set_page_dirty_lock(p[i]);
+		put_page(p[i]);
+	}
+}
+
+/*
+ * Call with current->mm->mmap_sem held.
+ */
+static int __get_user_pages(unsigned long start_page, size_t num_pages,
+			    struct page **p, struct vm_area_struct **vma)
+{
+	unsigned long lock_limit;
+	size_t got;
+	int ret;
+
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
+		PAGE_SHIFT;
+
+	if (num_pages > lock_limit) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
+	qib_cdbg(VERBOSE, "pin %lx pages from vaddr %lx\n",
+		 (unsigned long) num_pages, start_page);
+
+	for (got = 0; got < num_pages; got += ret) {
+		ret = get_user_pages(current, current->mm,
+				     start_page + got * PAGE_SIZE,
+				     num_pages - got, 1, 1,
+				     p + got, vma);
+		if (ret < 0)
+			goto bail_release;
+	}
+
+	current->mm->locked_vm += num_pages;
+
+	ret = 0;
+	goto bail;
+
+bail_release:
+	__qib_release_user_pages(p, got, 0);
+bail:
+	return ret;
+}
+
+/**
+ * qib_map_page - a safety wrapper around pci_map_page()
+ *
+ * A dma_addr of all 0's is interpreted by the chip as "disabled".
+ * Unfortunately, it can also be a valid dma_addr returned on some
+ * architectures.
+ *
+ * The powerpc iommu assigns dma_addrs in ascending order, so we don't
+ * have to bother with retries or mapping a dummy page to insure we
+ * don't just get the same mapping again.
+ *
+ * I'm sure we won't be so lucky with other iommu's, so FIXME.
+ */
+dma_addr_t qib_map_page(struct pci_dev *hwdev, struct page *page,
+			unsigned long offset, size_t size, int direction)
+{
+	dma_addr_t phys;
+
+	phys = pci_map_page(hwdev, page, offset, size, direction);
+
+	if (phys == 0) {
+		pci_unmap_page(hwdev, phys, size, direction);
+		phys = pci_map_page(hwdev, page, offset, size, direction);
+		/*
+		 * FIXME: If we get 0 again, we should keep this page,
+		 * map another, then free the 0 page.
+		 */
+	}
+
+	return phys;
+}
+
+/**
+ * qib_get_user_pages - lock user pages into memory
+ * @start_page: the start page
+ * @num_pages: the number of pages
+ * @p: the output page structures
+ *
+ * This function takes a given start page (page aligned user virtual
+ * address) and pins it and the following specified number of pages.  For
+ * now, num_pages is always 1, but that will probably change at some point
+ * (because caller is doing expected sends on a single virtually contiguous
+ * buffer, so we can do all pages at once).
+ */
+int qib_get_user_pages(unsigned long start_page, size_t num_pages,
+		       struct page **p)
+{
+	int ret;
+
+	down_write(&current->mm->mmap_sem);
+
+	ret = __get_user_pages(start_page, num_pages, p, NULL);
+
+	up_write(&current->mm->mmap_sem);
+
+	return ret;
+}
+
+void qib_release_user_pages(struct page **p, size_t num_pages)
+{
+	if (current->mm) /* during close after signal, mm can be NULL */
+		down_write(&current->mm->mmap_sem);
+
+	__qib_release_user_pages(p, num_pages, 1);
+
+	if (current->mm) {
+		current->mm->locked_vm -= num_pages;
+		up_write(&current->mm->mmap_sem);
+	}
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

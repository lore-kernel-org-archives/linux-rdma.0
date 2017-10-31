From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/15] IB/core: disable memory registration of fileystem-dax
 vmas
Date: Tue, 31 Oct 2017 16:22:29 -0700
Message-ID: <150949214929.24061.10464887309708944817.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <150949209290.24061.6283157778959640151.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow RDMA to create long standing memory registrations
against filesytem-dax vmas. Device-dax vmas do not have this problem and
are explicitly allowed.

This is temporary until a "memory registration with layout-lease"
mechanism can be implemented, and is limited to non-ODP (On Demand
Paging) capable RDMA devices.

Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/umem.c |   49 +++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 21e60b1e2ff4..c30d286c1f24 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -147,19 +147,21 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->hugetlb   = 1;
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
-	if (!page_list) {
-		put_pid(umem->pid);
-		kfree(umem);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!page_list)
+		goto err_pagelist;
 
 	/*
-	 * if we can't alloc the vma_list, it's not so bad;
-	 * just assume the memory is not hugetlb memory
+	 * If DAX is enabled we need the vma to protect against
+	 * registering filesystem-dax memory. Otherwise we can tolerate
+	 * a failure to allocate the vma_list and just assume that all
+	 * vmas are not hugetlb-vmas.
 	 */
 	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
-	if (!vma_list)
+	if (!vma_list) {
+		if (IS_ENABLED(CONFIG_FS_DAX))
+			goto err_vmalist;
 		umem->hugetlb = 0;
+	}
 
 	npages = ib_umem_num_pages(umem);
 
@@ -199,15 +201,34 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		if (ret < 0)
 			goto out;
 
-		umem->npages += ret;
 		cur_base += ret * PAGE_SIZE;
 		npages   -= ret;
 
 		for_each_sg(sg_list_start, sg, ret, i) {
-			if (vma_list && !is_vm_hugetlb_page(vma_list[i]))
-				umem->hugetlb = 0;
+			struct vm_area_struct *vma;
+			struct inode *inode;
 
 			sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
+			umem->npages++;
+
+			if (!vma_list)
+				continue;
+			vma = vma_list[i];
+
+			if (!is_vm_hugetlb_page(vma))
+				umem->hugetlb = 0;
+
+			if (!vma_is_dax(vma))
+				continue;
+
+			/* device-dax is safe for rdma... */
+			inode = file_inode(vma->vm_file);
+			if (inode->i_mode == S_IFCHR)
+				continue;
+
+			/* ...filesystem-dax is not. */
+			ret = -EOPNOTSUPP;
+			goto out;
 		}
 
 		/* preparing for next loop */
@@ -242,6 +263,12 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	free_page((unsigned long) page_list);
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
+err_vmalist:
+	free_page((unsigned long) page_list);
+err_pagelist:
+	put_pid(umem->pid);
+	kfree(umem);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(ib_umem_get);

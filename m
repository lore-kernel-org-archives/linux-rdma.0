From: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband/mthca : Fix userland mapping of mthca
 infiniband cards in Xen dom0
Date: Wed, 22 Dec 2010 17:11:00 +0100
Message-ID: <1293034260.30522.426.camel@trax>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Infiniband allows the mapping of PCI memory regions to userland to
achieve faster speeds. Using this feature with mthca cards in a Xen dom0
kernel leads to a pretty bad crash, and the process being killed (see
http://xen.1045712.n5.nabble.com/Infiniband-from-userland-in-dom0-process-killed-bad-pagetable-td3259124.html )

This patch fixes the issue by setting the VM_IO flag on the vma, and
refreshing the vm_page_prot field. The vm_page_prot will then have the
_PAGE_IOMAP bit set, and Xen will therefore map the actual PCI space
rather than a piece of non-existent RAM.

Signed-off-by: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>
---
This has been heavily tested on a Fedora Core modified 2.6.32 kernel
(with pvops patches : http://fedorapeople.org/~myoung/dom0/src/ ).I have
also checked that it does not break anything on a stock kernel
(2.6.37-rc7 from kernel.org), although only outside of Xen.

There has also been some discussion about this issue on the Xen mailing
list :
http://lists.xensource.com/archives/html/xen-devel/2010-11/msg01739.html


diff -uNrp kernel-2.6.32.fc12.orig/drivers/infiniband/hw/mthca/mthca_provider.c kernel-2.6.32.fc12.new/drivers/infiniband/hw/mthca/mthca_provider.c
--- kernel-2.6.32.fc12.orig/drivers/infiniband/hw/mthca/mthca_provider.c	2010-12-16 16:39:06.901130993 +0100
+++ kernel-2.6.32.fc12.new/drivers/infiniband/hw/mthca/mthca_provider.c	2010-12-16 17:02:07.944127489 +0100
@@ -391,6 +391,8 @@ static int mthca_mmap_uar(struct ib_ucon
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
+	vma->vm_flags |= VM_IO;
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	if (io_remap_pfn_range(vma, vma->vm_start,



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

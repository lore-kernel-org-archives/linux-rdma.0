From: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2]: Powerpc: Fix EHCA driver on relocatable kernel
Date: Thu, 19 Aug 2010 23:10:19 -0500
Message-ID: <20100820041019.GT16505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ppc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

the eHCA driver registers a MR for all of kernel memory, but makes the
assumption that valid memory exists at KERNELBASE.  This assumption
may not be true in the case of a relocatable kernel, so use KERNELBASE
+ PHYSICAL_START to get the true beginning of usable kernel memory.

This patch depends on the earlier patch which exports the necessary
symbol for PHYSICAL_START in a relocatable kernel.

cc: Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
cc: Hoan-Ham Hguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>


Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_mrmw.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_mrmw.c	2010-08-09 22:16:57.688652613 -0500
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_mrmw.c	2010-08-19 22:53:03.451507146 -0500
@@ -171,7 +171,7 @@
 		}
 
 		ret = ehca_reg_maxmr(shca, e_maxmr,
-				     (void *)ehca_map_vaddr((void *)KERNELBASE),
+				     (void *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START)),
 				     mr_access_flags, e_pd,
 				     &e_maxmr->ib.ib_mr.lkey,
 				     &e_maxmr->ib.ib_mr.rkey);
@@ -1636,7 +1636,7 @@
 
 	/* register internal max-MR on HCA */
 	size_maxmr = ehca_mr_len;
-	iova_start = (u64 *)ehca_map_vaddr((void *)KERNELBASE);
+	iova_start = (u64 *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START));
 	ib_pbuf.addr = 0;
 	ib_pbuf.size = size_maxmr;
 	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
@@ -2209,7 +2209,7 @@
 {
 	/* a MR is treated as max-MR only if it fits following: */
 	if ((size == ehca_mr_len) &&
-	    (iova_start == (void *)ehca_map_vaddr((void *)KERNELBASE))) {
+	    (iova_start == (void *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START)))) {
 		ehca_gen_dbg("this is a max-MR");
 		return 1;
 	} else
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

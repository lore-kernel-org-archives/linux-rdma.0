From: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2]: Powerpc: Fix EHCA driver on relocatable kernel
Date: Thu, 19 Aug 2010 23:08:09 -0500
Message-ID: <20100820040809.GS16505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some modules (like eHCA) want to map all of kernel memory, for this to
work with a relocated kernel, we need to export kernstart_addr so
modules can use PHYSICAL_START and memstart_addr so they could use
MEMORY_START.  Note that the 32bit code already exports these symbols.

Signed-off-By: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Index: common/arch/powerpc/mm/init_64.c
===================================================================
--- common.orig/arch/powerpc/mm/init_64.c	2010-08-16 02:38:33.000000000 -0500
+++ common/arch/powerpc/mm/init_64.c	2010-08-16 02:39:25.000000000 -0500
@@ -79,7 +79,9 @@
 #endif /* CONFIG_PPC_STD_MMU_64 */
 
 phys_addr_t memstart_addr = ~0;
+EXPORT_SYMBOL(memstart_addr);
 phys_addr_t kernstart_addr;
+EXPORT_SYMBOL(kernstart_addr);
 
 void free_initmem(void)
 {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

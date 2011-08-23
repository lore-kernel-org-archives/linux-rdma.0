From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] mm: Distinguish between mlocked and pinned pages
Date: Tue, 23 Aug 2011 09:59:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1108230958510.21267@router.home>
References: <alpine.DEB.2.00.1108101516430.20403@router.home> <20110817155412.cc302033.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110817155412.cc302033.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 17 Aug 2011, Andrew Morton wrote:

> This is an obvious place.  Could I ask that you split all these up into
> one-definition-per-line and we can start in on properly documenting
> each field?

Subject: mm: Add comments to explain mm_struct fields

Explain comments to explain the page statistics field in the
mm_struct.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

---
 include/linux/mm_types.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-08-23 09:43:32.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-08-23 09:52:09.000000000 -0500
@@ -281,8 +281,15 @@ struct mm_struct {
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */

-	unsigned long total_vm, locked_vm, pinned_vm, shared_vm, exec_vm;
-	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
+	unsigned long total_vm;		/* Total pages mapped */
+	unsigned long locked_vm		/* Pages that have PG_mlocked set */
+	unsigned long pinned_vm;	/* Refcount permanently increased */
+	unsigned long shared_vm;	/* Shared pages (files) */
+	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
+	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
+	unsigned long reserved_vm;	/* VM_RESERVED|VM_IO pages */
+	unsigned long def_flags;
+	unsigned long nr_ptes;		/* Page table pages */
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
 	unsigned long arg_start, arg_end, env_start, env_end;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

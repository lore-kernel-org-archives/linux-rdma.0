From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 2/2] Page order diagnostics
Date: Fri, 16 Feb 2018 10:01:12 -0600
Message-ID: <20180216160121.583566579@linux.com>
References: <20180216160110.641666320@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=order_stats
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is beneficial to know about the contiguous memory segments
available on a system and the number of allocations failing
for each page order.

This patch adds details per order statistics to /proc/meminfo
so the current memory use can be determined.

Also adds counters to /proc/vmstat to show allocation
failures for each page order.

Signed-off-by: Christoph Laeter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/include/linux/mmzone.h
===================================================================
--- linux.orig/include/linux/mmzone.h
+++ linux/include/linux/mmzone.h
@@ -185,6 +185,10 @@ enum node_stat_item {
 	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
+#ifdef CONFIG_ORDER_STATS
+	NR_ORDER,
+	NR_ORDER_MAX = NR_ORDER + MAX_ORDER - 1,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -828,6 +828,10 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
+#ifdef CONFIG_ORDER_STATS
+	dec_node_page_state(page, NR_ORDER + order);
+#endif
+
 continue_merging:
 	while (order < max_order - 1) {
 		buddy_pfn = __find_buddy_pfn(pfn, order);
@@ -1285,6 +1289,9 @@ static void __init __free_pages_boot_cor
 	page_zone(page)->managed_pages += nr_pages;
 	set_page_refcounted(page);
 	__free_pages(page, order);
+#ifdef CONFIG_ORDER_STATS
+	inc_node_page_state(page, NR_ORDER + order);
+#endif
 }
 
 #if defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) || \
@@ -1855,6 +1862,9 @@ struct page *__rmqueue_smallest(struct z
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
+#ifdef CONFIG_ORDER_STATS
+		inc_node_page_state(page, NR_ORDER + order);
+#endif
 		set_pcppage_migratetype(page, migratetype);
 		return page;
 	}
@@ -4169,6 +4179,11 @@ nopage:
 fail:
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
+
+#ifdef CONFIG_ORDER_STATS
+	count_vm_event(ORDER0_ALLOC_FAIL + order);
+#endif
+
 got_pg:
 	return page;
 }
Index: linux/fs/proc/meminfo.c
===================================================================
--- linux.orig/fs/proc/meminfo.c
+++ linux/fs/proc/meminfo.c
@@ -51,6 +51,7 @@ static int meminfo_proc_show(struct seq_
 	long available;
 	unsigned long pages[NR_LRU_LISTS];
 	int lru;
+	int order;
 
 	si_meminfo(&i);
 	si_swapinfo(&i);
@@ -155,6 +156,11 @@ static int meminfo_proc_show(struct seq_
 		    global_zone_page_state(NR_FREE_CMA_PAGES));
 #endif
 
+#ifdef CONFIG_ORDER_STATS
+	for (order= 0; order < MAX_ORDER; order++)
+		seq_printf(m, "Order%2d Pages:     %5lu\n",
+			order, global_node_page_state(NR_ORDER + order));
+#endif
 	hugetlb_report_meminfo(m);
 
 	arch_report_meminfo(m);
Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -752,6 +752,15 @@ config PERCPU_STATS
 	  information includes global and per chunk statistics, which can
 	  be used to help understand percpu memory usage.
 
+config ORDER_STATS
+	bool "Statistics for different sized allocations"
+	default n
+	help
+	  Create statistics about the contiguous memory segments allocated
+	  through the page allocator. This creates statistics about the
+	  memory segments in use in /proc/meminfo and the node meminfo files
+	  as well as allocation failure statistics in /proc/vmstat.
+
 config GUP_BENCHMARK
 	bool "Enable infrastructure for get_user_pages_fast() benchmarking"
 	default n
Index: linux/include/linux/vm_event_item.h
===================================================================
--- linux.orig/include/linux/vm_event_item.h
+++ linux/include/linux/vm_event_item.h
@@ -111,6 +111,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		SWAP_RA,
 		SWAP_RA_HIT,
 #endif
+#ifdef CONFIG_ORDER_STATS
+		ORDER0_ALLOC_FAIL,
+		ORDER_MAX_FAIL = ORDER0_ALLOC_FAIL + MAX_ORDER -1,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c
+++ linux/mm/vmstat.c
@@ -1289,6 +1289,52 @@ const char * const vmstat_text[] = {
 	"swap_ra",
 	"swap_ra_hit",
 #endif
+#ifdef CONFIG_ORDER_STATS
+	"order0_failure",
+	"order1_failure",
+	"order2_failure",
+	"order3_failure",
+	"order4_failure",
+	"order5_failure",
+	"order6_failure",
+	"order7_failure",
+	"order8_failure",
+	"order9_failure",
+	"order10_failure",
+#ifdef CONFIG_FORCE_MAX_ZONEORDER
+#if MAX_ORDER > 11
+	"order11_failure"
+#endif
+#if MAX_ORDER > 12
+	"order12_failure"
+#endif
+#if MAX_ORDER > 13
+	"order13_failure"
+#endif
+#if MAX_ORDER > 14
+	"order14_failure"
+#endif
+#if MAX_ORDER > 15
+	"order15_failure"
+#endif
+#if MAX_ORDER > 16
+	"order16_failure"
+#endif
+#if MAX_ORDER > 17
+	"order17_failure"
+#endif
+#if MAX_ORDER > 18
+	"order18_failure"
+#endif
+#if MAX_ORDER > 19
+	"order19_failure"
+#endif
+#if MAX_ORDER > 20
+#error Please add more lines...
+#endif
+
+#endif /* CONFIG_FORCE_MAX_ZONEORDER */
+#endif /* CONFIG_ORDER_STATS */
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

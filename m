From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Cosmetic commentary changes
Date: Mon, 16 Nov 2009 13:42:22 -0500
Message-ID: <20091116184222.GA2417@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Make routine names in comments consistent with actual (changed) names

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 1b1da19..76b1d6a 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -1975,7 +1975,7 @@ static inline int port_group_compare_load_down(const ftree_port_group_t * p1,
  * as it is much faster.
  *
  * Important note:
- * This function and __osm_ftree_bubble_sort_down must NOT be factorized.
+ * This function and bubble_sort_down must NOT be factorized.
  * Although most of the code is the same and a function pointer could be used
  * for the compareason function, it would prevent the compareason function to be inlined
  * and cost a great deal to performances.
@@ -2047,13 +2047,13 @@ bubble_sort_siblings(ftree_port_group_t ** p_group_array, uint32_t nmemb)
 
 /*
  * Function: Sorts an array of port group. Order is decide through
- * __osm_ftree_port_group_compare_load_down ( up counters, least load remote switch, biggest GUID)
+ * port_group_compare_load_down ( up counters, least load remote switch, biggest GUID)
  * Given   : A port group array and its length. Each port group points to a remote switch (not a HCA)
  * As the list is mostly sorted, we used a bubble sort instead of qsort
  * as it is much faster.
  *
  * Important note:
- * This function and __osm_ftree_bubble_sort_up must NOT be factorized.
+ * This function and bubble_sort_up must NOT be factorized.
  * Although most of the code is the same and a function pointer could be used
  * for the compareason function, it would prevent the compareason function to be inlined
  * and cost a great deal to performances.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: john.hubbard@gmail.com
Subject: [PATCH v2 3/6] mm: introduce zone_gup_lock, for dma-pinned pages
Date: Sun,  1 Jul 2018 17:56:51 -0700
Message-ID: <20180702005654.20369-4-jhubbard@nvidia.com>
References: <20180702005654.20369-1-jhubbard@nvidia.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702005654.20369-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

The page->dma_pinned_flags and _count fields require
lock protection. A lock at approximately the granularity
of the zone_lru_lock is called for, but adding to the
locking contention of zone_lru_lock is undesirable,
because that is a pre-existing hot spot. Fortunately,
these new dma_pinned_* fields can use an independent
lock, so this patch creates an entirely new lock, right
next to the zone_lru_lock.

Why "zone_gup_lock"?

Most of the naming refers to "DMA-pinned pages", but
"zone DMA lock" has other meanings already, so this is
called zone_gup_lock instead. The "dma pinning" is a result
of get_user_pages (gup) being called, so the name still
helps explain its use.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mmzone.h | 7 +++++++
 mm/page_alloc.c        | 1 +
 2 files changed, 8 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 32699b2dc52a..5b4ceef82657 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -662,6 +662,8 @@ typedef struct pglist_data {
 
 	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
 
+	spinlock_t pinned_dma_lock;
+
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
 	enum zone_type kcompactd_classzone_idx;
@@ -740,6 +742,11 @@ static inline spinlock_t *zone_lru_lock(struct zone *zone)
 	return &zone->zone_pgdat->lru_lock;
 }
 
+static inline spinlock_t *zone_gup_lock(struct zone *zone)
+{
+	return &zone->zone_pgdat->pinned_dma_lock;
+}
+
 static inline struct lruvec *node_lruvec(struct pglist_data *pgdat)
 {
 	return &pgdat->lruvec;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1521100f1e63..9c493442b57c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6211,6 +6211,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat)
 	int nid = pgdat->node_id;
 
 	pgdat_resize_init(pgdat);
+	spin_lock_init(&pgdat->pinned_dma_lock);
 #ifdef CONFIG_NUMA_BALANCING
 	spin_lock_init(&pgdat->numabalancing_migrate_lock);
 	pgdat->numabalancing_migrate_nr_pages = 0;
-- 
2.18.0

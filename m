From: john.hubbard@gmail.com
Subject: [PATCH 5/6] mm: introduce zone_gup_lock, for dma-pinned pages
Date: Thu, 11 Oct 2018 23:00:13 -0700
Message-ID: <20181012060014.10242-6-jhubbard@nvidia.com>
References: <20181012060014.10242-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012060014.10242-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
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
 include/linux/mmzone.h | 6 ++++++
 mm/page_alloc.c        | 1 +
 2 files changed, 7 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d4b0c79d2924..971a63f84ad5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -661,6 +661,7 @@ typedef struct pglist_data {
 	enum zone_type kswapd_classzone_idx;
 
 	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
+	spinlock_t pinned_dma_lock;
 
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
@@ -730,6 +731,11 @@ static inline spinlock_t *zone_lru_lock(struct zone *zone)
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
index e2ef1c17942f..850f90223cc7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6225,6 +6225,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_page_ext_init(pgdat);
 	spin_lock_init(&pgdat->lru_lock);
+	spin_lock_init(&pgdat->pinned_dma_lock);
 	lruvec_init(node_lruvec(pgdat));
 }
 
-- 
2.19.1

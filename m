From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] indexer: Free index_map resources when cleared
Date: Fri, 23 May 2014 18:20:17 -0700
Message-ID: <1400894417-23657-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Free memory allocated for index map entries when they are no
longer in use.  To handle this, count the number of entries
stored by the index map item arrays and release the arrays when
no items are being tracked.

This reduces valgrind noise.

Problem reported by: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/indexer.c |    5 +++++
 src/indexer.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/src/indexer.c b/src/indexer.c
index c8e8bce..b9e400b 100644
--- a/src/indexer.c
+++ b/src/indexer.c
@@ -151,6 +151,7 @@ int idm_set(struct index_map *idm, int index, void *item)
 
 	entry = idm->array[idx_array_index(index)];
 	entry[idx_entry_index(index)] = item;
+	idm->count[idx_array_index(index)]++;
 	return index;
 }
 
@@ -162,5 +163,9 @@ void *idm_clear(struct index_map *idm, int index)
 	entry = idm->array[idx_array_index(index)];
 	item = entry[idx_entry_index(index)];
 	entry[idx_entry_index(index)] = NULL;
+	if (--idm->count[idx_array_index(index)] == 0) {
+		free(idm->array[idx_array_index(index)]);
+		idm->array[idx_array_index(index)] = NULL;
+	}
 	return item;
 }
diff --git a/src/indexer.h b/src/indexer.h
index 0c5f388..fc8eae2 100644
--- a/src/indexer.h
+++ b/src/indexer.h
@@ -85,6 +85,7 @@ static inline void *idx_at(struct indexer *idx, int index)
 struct index_map
 {
 	void **array[IDX_ARRAY_SIZE];
+	int count[IDX_ARRAY_SIZE];
 };
 
 int idm_set(struct index_map *idm, int index, void *item);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

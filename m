From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2] Clean index map on exit
Date: Fri, 11 Apr 2014 20:22:13 +0200
Message-ID: <B9523649-97F2-4979-8590-F63788B4AC9D@gmx.net>
Reply-To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>

librdmacm already has a cleanup function which releases all resources it
holds. Missing from that cleanup are entries with struct index_map,
which are dynamically allocated, whereas the map itself is declared
static. Because librdmacm plays otherwise nicely with valgrind this
patch aims to free the memory held by index map entries, mainly to
reduce valgrind noise.
This patch adds the function idm_free() to free all entries of an index
map. A call to this function is added in the ucma_cleanup destructor.
The ucma_idm struct index_map is cleaned using idm_free().
There is another struct index_map in preload.c and rsocket.c, but there
are no destructors yet and I don't feel competent enough to add them.

Signed-off-by: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
---
 src/cma.c     | 1 +
 src/indexer.c | 8 ++++++++
 src/indexer.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/src/cma.c b/src/cma.c
index 0cf4203..a533bf9 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -139,6 +139,7 @@ static void ucma_cleanup(void)
 			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
 		}
 
+		idm_free(&ucma_idm);
 		fastlock_destroy(&idm_lock);
 		free(cma_dev_array);
 		cma_dev_cnt = 0;
diff --git a/src/indexer.c b/src/indexer.c
index c8e8bce..8dd8a82 100644
--- a/src/indexer.c
+++ b/src/indexer.c
@@ -164,3 +164,11 @@ void *idm_clear(struct index_map *idm, int index)
 	entry[idx_entry_index(index)] = NULL;
 	return item;
 }
+
+void idm_free(struct index_map *idm)
+{
+	size_t i;
+	for (i = 0; i < IDX_ARRAY_SIZE; i++) {
+		free(idm->array[i]);
+	}
+}
diff --git a/src/indexer.h b/src/indexer.h
index 0c5f388..829d46b 100644
--- a/src/indexer.h
+++ b/src/indexer.h
@@ -89,6 +89,7 @@ struct index_map
 
 int idm_set(struct index_map *idm, int index, void *item);
 void *idm_clear(struct index_map *idm, int index);
+void idm_free(struct index_map *idm);
 
 static inline void *idm_at(struct index_map *idm, int index)
 {
-- 
1.8.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

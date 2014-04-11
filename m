From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] Clean index map on exit
Date: Fri, 11 Apr 2014 18:58:10 +0200
Message-ID: <EB3C2705-3925-49DD-8DB2-07BAE9E60A05@gmx.net>
Reply-To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>,
	  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds the function idm_free() to free all entries of an index
map. A call to this function is added in the ucma_cleanup destructor.
The ucma_idm struct index_map is cleaned.

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
index c8e8bce..4d1fd77 100644
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
+	free(idm->array[i]);
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

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_vendor_ibumad.c: Better match table eviction strategy
Date: Tue, 10 Jun 2014 10:16:13 -0400
Message-ID: <5397132D.4020603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rather than just evict LRU transaction when the match table is full,
evict the LRU non SMP transaction and if none exist then evict the
LRU SMP transaction.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |   56 +++++++++++++++++++++++++++++++---------
 1 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index d9ed13a..94a2783 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -187,15 +187,21 @@ static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid,
 	return 0;
 }
 
+/*
+ * If match table full, evict LRU (least recently used) transaction.
+ * Maintain 2 LRUs: one for SMPs, and one for others (GS).
+ * Evict LRU GS transaction if one is available and only evict LRU SMP
+ * transaction if no other choice.
+ */
 static void
 put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid,
 	 uint8_t mgmt_class)
 {
-	umad_match_t *m, *e, *old_lru, *lru = 0;
+	umad_match_t *m, *e, *old_lru, *lru = 0, *lru_smp = 0;
 	osm_madw_t *p_req_madw;
 	osm_umad_bind_info_t *p_bind;
 	ib_net64_t old_tid;
-	uint32_t oldest = ~0;
+	uint32_t oldest = ~0, oldest_smp = ~0;
 	uint8_t old_mgmt_class;
 
 	pthread_mutex_lock(&p_vend->match_tbl_mutex);
@@ -210,15 +216,30 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid,
 			pthread_mutex_unlock(&p_vend->match_tbl_mutex);
 			return;
 		}
-		if (oldest >= m->version) {
-			oldest = m->version;
-			lru = m;
+		if (m->mgmt_class == IB_MCLASS_SUBN_DIR ||
+		    m->mgmt_class == IB_MCLASS_SUBN_LID) {
+			if (oldest_smp >= m->version) {
+				oldest_smp = m->version;
+				lru_smp = m;
+			}
+		} else {
+			if (oldest >= m->version) {
+				oldest = m->version;
+				lru = m;
+			}
 		}
 	}
 
-	old_lru = lru;
-	old_tid = lru->tid;
-	old_mgmt_class = lru->mgmt_class;
+	if (oldest != ~0) {
+		old_lru = lru;
+		old_tid = lru->tid;
+		old_mgmt_class = lru->mgmt_class;
+	} else {
+		CL_ASSERT(oldest_smp != ~0);
+		old_lru = lru_smp;
+		old_tid = lru_smp->tid;
+		old_mgmt_class = lru_smp->mgmt_class;
+	}
 	p_req_madw = old_lru->v;
 	p_bind = p_req_madw->h_bind;
 	p_req_madw->status = IB_CANCELED;
@@ -226,11 +247,20 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid,
 	pthread_mutex_lock(&p_vend->cb_mutex);
 	(*p_bind->send_err_callback) (p_bind->client_context, p_req_madw);
 	pthread_mutex_unlock(&p_vend->cb_mutex);
-	lru->tid = tid;
-	lru->mgmt_class = mgmt_class;
-	lru->v = p_madw;
-	lru->version =
-	    cl_atomic_inc((atomic32_t *) & p_vend->mtbl.last_version);
+	if (mgmt_class == IB_MCLASS_SUBN_DIR ||
+	    mgmt_class == IB_MCLASS_SUBN_LID) {
+		lru_smp->tid = tid;
+		lru_smp->mgmt_class = mgmt_class;
+		lru_smp->v = p_madw;
+		lru_smp->version =
+		    cl_atomic_inc((atomic32_t *) & p_vend->mtbl.last_version);
+	} else {
+		lru->tid = tid;
+		lru->mgmt_class = mgmt_class;
+		lru->v = p_madw;
+		lru->version =
+		    cl_atomic_inc((atomic32_t *) & p_vend->mtbl.last_version);
+	}
 	pthread_mutex_unlock(&p_vend->match_tbl_mutex);
 	OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5402: "
 		"evicting entry %p (tid was 0x%" PRIx64
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

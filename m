From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 23/27] opensm/osm_vendor_ibumad: Add management class into match criteria
Date: Tue, 31 Jul 2012 19:04:51 +0300
Message-ID: <1343750695-28063-23-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/vendor/osm_vendor_ibumad.h |  1 +
 libvendor/osm_vendor_ibumad.c      | 43 +++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/vendor/osm_vendor_ibumad.h b/include/vendor/osm_vendor_ibumad.h
index 0a25583..c33a187 100644
--- a/include/vendor/osm_vendor_ibumad.h
+++ b/include/vendor/osm_vendor_ibumad.h
@@ -140,6 +140,7 @@ typedef struct _umad_match {
 	ib_net64_t tid;
 	void *v;
 	uint32_t version;
+	uint8_t mgmt_class;
 } umad_match_t;
 
 #define DEFAULT_OSM_UMAD_MAX_PENDING	1000
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index f2432e0..d9ed13a 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -157,7 +157,8 @@ Exit:
 	OSM_LOG_EXIT(p_vend->p_log);
 }
 
-static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid)
+static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid,
+			    uint8_t mgmt_class)
 {
 	umad_match_t *m, *e;
 	ib_net64_t mtid = (*tid & CL_HTON64(0x00000000ffffffffULL));
@@ -167,13 +168,14 @@ static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid)
 	 * Since mtid == 0 is the empty key, we should not
 	 * waste time looking for it
 	 */
-	if (mtid == 0)
+	if (mtid == 0 || mgmt_class == 0)
 		return 0;
 
 	pthread_mutex_lock(&p_vend->match_tbl_mutex);
 	for (m = p_vend->mtbl.tbl, e = m + p_vend->mtbl.max; m < e; m++) {
-		if (m->tid == mtid) {
+		if (m->tid == mtid && m->mgmt_class == mgmt_class) {
 			m->tid = 0;
+			m->mgmt_class = 0;
 			*tid = mtid;
 			res = m->v;
 			pthread_mutex_unlock(&p_vend->match_tbl_mutex);
@@ -186,18 +188,21 @@ static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid)
 }
 
 static void
-put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid)
+put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid,
+	 uint8_t mgmt_class)
 {
 	umad_match_t *m, *e, *old_lru, *lru = 0;
 	osm_madw_t *p_req_madw;
 	osm_umad_bind_info_t *p_bind;
 	ib_net64_t old_tid;
 	uint32_t oldest = ~0;
+	uint8_t old_mgmt_class;
 
 	pthread_mutex_lock(&p_vend->match_tbl_mutex);
 	for (m = p_vend->mtbl.tbl, e = m + p_vend->mtbl.max; m < e; m++) {
-		if (m->tid == 0) {
+		if (m->tid == 0 && m->mgmt_class == 0) {
 			m->tid = tid;
+			m->mgmt_class = mgmt_class;
 			m->v = p_madw;
 			m->version =
 			    cl_atomic_inc((atomic32_t *) & p_vend->mtbl.
@@ -213,6 +218,7 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid)
 
 	old_lru = lru;
 	old_tid = lru->tid;
+	old_mgmt_class = lru->mgmt_class;
 	p_req_madw = old_lru->v;
 	p_bind = p_req_madw->h_bind;
 	p_req_madw->status = IB_CANCELED;
@@ -221,13 +227,15 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid)
 	(*p_bind->send_err_callback) (p_bind->client_context, p_req_madw);
 	pthread_mutex_unlock(&p_vend->cb_mutex);
 	lru->tid = tid;
+	lru->mgmt_class = mgmt_class;
 	lru->v = p_madw;
 	lru->version =
 	    cl_atomic_inc((atomic32_t *) & p_vend->mtbl.last_version);
 	pthread_mutex_unlock(&p_vend->match_tbl_mutex);
 	OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5402: "
-		"evicting entry %p (tid was 0x%" PRIx64 ")\n", old_lru,
-		cl_ntoh64(old_tid));
+		"evicting entry %p (tid was 0x%" PRIx64
+		" mgmt class 0x%x)\n", old_lru,
+		cl_ntoh64(old_tid), old_mgmt_class);
 }
 
 static void
@@ -356,12 +364,14 @@ static void *umad_receiver(void *p_ptr)
 
 		/* if status != 0 then we are handling recv timeout on send */
 		if (umad_status(p_madw->vend_wrap.umad)) {
-			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
+			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id,
+						    mad->mgmt_class))) {
 				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
 					"ERR 5412: "
 					"Failed to obtain request madw for timed out MAD"
-					" (method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
-					mad->method, cl_ntoh16(mad->attr_id),
+					" (class=0x%X method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
+					mad->mgmt_class, mad->method,
+					cl_ntoh16(mad->attr_id),
 					cl_ntoh64(mad->trans_id));
 			} else {
 				p_req_madw->status = IB_TIMEOUT;
@@ -382,11 +392,13 @@ static void *umad_receiver(void *p_ptr)
 
 		p_req_madw = 0;
 		if (ib_mad_is_response(mad) &&
-		    !(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
+		    !(p_req_madw = get_madw(p_vend, &mad->trans_id,
+					    mad->mgmt_class))) {
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5413: "
 				"Failed to obtain request madw for received MAD"
-				"(method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
-				mad->method, cl_ntoh16((mad)->attr_id),
+				" (class=0x%X method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
+				mad->mgmt_class, mad->method,
+				cl_ntoh16((mad)->attr_id),
 				cl_ntoh64(mad->trans_id));
 			osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
 			continue;
@@ -1067,7 +1079,7 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 
 Resp:
 	if (resp_expected)
-		put_madw(p_vend, p_madw, p_mad->trans_id);
+		put_madw(p_vend, p_madw, p_mad->trans_id, p_mad->mgmt_class);
 
 #ifdef VENDOR_RMPP_SUPPORT
 	sent_mad_size = p_madw->mad_size;
@@ -1084,7 +1096,8 @@ Resp:
 			"Send p_madw = %p of size %d TID 0x%" PRIx64 " failed %d (%m)\n",
 			p_madw, sent_mad_size, tid, ret);
 		if (resp_expected) {
-			get_madw(p_vend, &p_mad->trans_id);	/* remove from aging table */
+			get_madw(p_vend, &p_mad->trans_id,
+				 p_mad->mgmt_class);	/* remove from aging table */
 			p_madw->status = IB_ERROR;
 			pthread_mutex_lock(&p_vend->cb_mutex);
 			(*p_bind->send_err_callback) (p_bind->client_context, p_madw);	/* cb frees madw */
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

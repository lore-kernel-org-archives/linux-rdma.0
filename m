From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] fixed unsused-but-set warning for DEBUG variables
Date: Mon, 11 Jul 2011 20:45:54 +0300
Message-ID: <20110711174554.GC2084@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some variables are used only when compiling opensm with DEBUG flag.
In general compilation, this might produce unused-but-set warning.
Setting thais variables with __attribute__((unused)) removes this
warning.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_event_wheel.c           |    2 +-
 complib/cl_map.c                   |    8 +++++---
 include/complib/cl_passivelock.h   |    6 +++---
 include/vendor/osm_vendor_sa_api.h |   12 ++++++------
 opensm/osm_ucast_lash.c            |    4 +---
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/complib/cl_event_wheel.c b/complib/cl_event_wheel.c
index eb894a6..2557c40 100644
--- a/complib/cl_event_wheel.c
+++ b/complib/cl_event_wheel.c
@@ -229,7 +229,7 @@ cl_status_t cl_event_wheel_init_ex(IN cl_event_wheel_t * const p_event_wheel,
 void cl_event_wheel_dump(IN cl_event_wheel_t * const p_event_wheel)
 {
 	cl_list_item_t *p_list_item;
-	cl_event_wheel_reg_info_t *p_event;
+	cl_event_wheel_reg_info_t __attribute__((__unused__)) *p_event;
 
 	p_list_item = cl_qlist_head(&p_event_wheel->events_wheel);
 
diff --git a/complib/cl_map.c b/complib/cl_map.c
index f5fb1f3..81426ee 100644
--- a/complib/cl_map.c
+++ b/complib/cl_map.c
@@ -626,7 +626,8 @@ static void __cl_qmap_delta_move(IN OUT cl_qmap_t * const p_dest,
 				 IN OUT cl_qmap_t * const p_src,
 				 IN OUT cl_map_item_t ** const pp_item)
 {
-	cl_map_item_t *p_temp, *p_next;
+	cl_map_item_t __attribute__((__unused__)) *p_temp;
+	cl_map_item_t *p_next;
 
 	/*
 	 * Get the next item so that we can ensure that pp_item points to
@@ -870,7 +871,7 @@ static void __cl_map_revert(IN OUT cl_map_t * const p_map1,
 			    IN OUT cl_map_t * const p_new,
 			    IN OUT cl_map_t * const p_old)
 {
-	cl_status_t status;
+	cl_status_t __attribute__((__unused__)) status;
 
 	/* Restore the initial state. */
 	status = cl_map_merge(p_map1, p_old);
@@ -1562,7 +1563,8 @@ static void __cl_fmap_delta_move(IN OUT cl_fmap_t * const p_dest,
 				 IN OUT cl_fmap_t * const p_src,
 				 IN OUT cl_fmap_item_t ** const pp_item)
 {
-	cl_fmap_item_t *p_temp, *p_next;
+	cl_fmap_item_t __attribute__((__unused__)) *p_temp;
+	cl_fmap_item_t *p_next;
 
 	/*
 	 * Get the next item so that we can ensure that pp_item points to
diff --git a/include/complib/cl_passivelock.h b/include/complib/cl_passivelock.h
index aea3bab..0fad6ef 100644
--- a/include/complib/cl_passivelock.h
+++ b/include/complib/cl_passivelock.h
@@ -234,7 +234,7 @@ static inline cl_status_t cl_plock_init(IN cl_plock_t * const p_lock)
 */
 static inline void cl_plock_acquire(IN cl_plock_t * const p_lock)
 {
-	cl_status_t status;
+	cl_status_t __attribute__((unused)) status;
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);
 
@@ -266,7 +266,7 @@ static inline void cl_plock_acquire(IN cl_plock_t * const p_lock)
 */
 static inline void cl_plock_excl_acquire(IN cl_plock_t * const p_lock)
 {
-	cl_status_t status;
+	cl_status_t __attribute__((unused)) status;
 
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);
@@ -299,7 +299,7 @@ static inline void cl_plock_excl_acquire(IN cl_plock_t * const p_lock)
 */
 static inline void cl_plock_release(IN cl_plock_t * const p_lock)
 {
-	cl_status_t status;
+	cl_status_t __attribute__((unused)) status;
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);
 
diff --git a/include/vendor/osm_vendor_sa_api.h b/include/vendor/osm_vendor_sa_api.h
index dd37c3a..653d847 100644
--- a/include/vendor/osm_vendor_sa_api.h
+++ b/include/vendor/osm_vendor_sa_api.h
@@ -448,7 +448,7 @@ static inline ib_path_rec_t *osmv_get_query_path_rec(IN osm_madw_t *
 						     p_result_madw,
 						     IN uint32_t result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
@@ -490,7 +490,7 @@ static inline ib_portinfo_record_t *osmv_get_query_portinfo_rec(IN osm_madw_t *
 								IN uint32_t
 								result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
@@ -532,7 +532,7 @@ static inline ib_node_record_t *osmv_get_query_node_rec(IN osm_madw_t *
 							IN uint32_t
 							result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
@@ -574,7 +574,7 @@ static inline ib_service_record_t *osmv_get_query_svc_rec(IN osm_madw_t *
 							  IN uint32_t
 							  result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
@@ -615,7 +615,7 @@ static inline ib_member_rec_t *osmv_get_query_mc_rec(IN osm_madw_t *
 						     p_result_madw,
 						     IN uint32_t result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
@@ -660,7 +660,7 @@ static inline ib_inform_info_record_t *osmv_get_query_inform_info_rec(IN
 								      uint32_t
 								      result_index)
 {
-	ib_sa_mad_t *p_sa_mad;
+	ib_sa_mad_t __attribute__((__unused__)) *p_sa_mad;
 
 	CL_ASSERT(p_result_madw);
 	p_sa_mad = (ib_sa_mad_t *) osm_madw_get_mad_ptr(p_result_madw);
diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index 739eedd..8cc84b3 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -126,13 +126,11 @@ static osm_switch_t *get_osm_switch_from_port(const osm_port_t * port)
 static int cycle_exists(cdg_vertex_t * start, cdg_vertex_t * current,
 			cdg_vertex_t * prev, int visit_num)
 {
-	cdg_vertex_t *h;
 	int i, new_visit_num;
 	int cycle_found = 0;
 
 	if (current != NULL && current->visiting_number > 0) {
 		if (visit_num > current->visiting_number && current->seen == 0) {
-			h = start;
 			cycle_found = 1;
 		}
 	} else {
@@ -180,7 +178,7 @@ static void remove_semipermanent_depend_for_sp(lash_t * p_lash, int sw,
 	int i_next_switch, output_link, i, next_link, i_next_next_switch,
 	    depend = 0;
 	cdg_vertex_t *v;
-	int found;
+	int __attribute__((unused)) found;
 
 	output_link = switches[sw]->routing_table[dest_switch].out_link;
 	i_next_switch = get_next_switch(p_lash, sw, output_link);
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

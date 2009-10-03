From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: [PATCH v2] opensm: remove meanless 'const' keywords in APIs
Date: Sat, 3 Oct 2009 04:17:31 +0200
Message-ID: <20091003021731.GI17846@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E895E@orsmsx501.amr.corp.intel.com>
	<20091001203544.GA17846@me>
	<3F6F638B8D880340AB536D29CD4C1E1912C86E8B02@orsmsx501.amr.corp.intel.com>
	<20091002144153.GB17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <20091002144153.GB17846@me>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: linux-rdma <linux-rdma@vger.kernel.org>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org


In APIs remove meanless 'const' keywords related to function parameter
values. Such as:

type func(..., type * const ptr, ...)
type func(..., type const var, ... )

Make function prototypes and definitions to be consistent.

Signed-off-by: Sasha Khapyorsky <sashak@voltaire.com>
---
V2: add few missed 'const' removing in function definitions in *.c files
to be consistent with its prototypes.

 opensm/include/opensm/osm_db.h           |   17 ++--
 opensm/include/opensm/osm_db_pack.h      |   20 ++--
 opensm/include/opensm/osm_inform.h       |   19 ++--
 opensm/include/opensm/osm_lid_mgr.h      |   10 +-
 opensm/include/opensm/osm_log.h          |   47 ++++-----
 opensm/include/opensm/osm_mad_pool.h     |   30 +++---
 opensm/include/opensm/osm_madw.h         |   56 +++++------
 opensm/include/opensm/osm_mcast_tbl.h    |   53 ++++------
 opensm/include/opensm/osm_mcm_port.h     |    2 +-
 opensm/include/opensm/osm_multicast.h    |   19 ++--
 opensm/include/opensm/osm_node.h         |   81 ++++++---------
 opensm/include/opensm/osm_opensm.h       |   26 ++---
 opensm/include/opensm/osm_partition.h    |   12 +-
 opensm/include/opensm/osm_path.h         |   15 ++--
 opensm/include/opensm/osm_perfmgr.h      |   38 +++----
 opensm/include/opensm/osm_pkey.h         |   25 ++---
 opensm/include/opensm/osm_port.h         |  167 +++++++++++++-----------------
 opensm/include/opensm/osm_port_profile.h |    9 +-
 opensm/include/opensm/osm_qos_policy.h   |    2 +-
 opensm/include/opensm/osm_remote_sm.h    |   10 +-
 opensm/include/opensm/osm_router.h       |   14 +--
 opensm/include/opensm/osm_sa.h           |   38 +++----
 opensm/include/opensm/osm_sa_mad_ctrl.h  |   29 +++---
 opensm/include/opensm/osm_service.h      |   19 ++--
 opensm/include/opensm/osm_sm.h           |   80 ++++++---------
 opensm/include/opensm/osm_sm_mad_ctrl.h  |   32 +++---
 opensm/include/opensm/osm_subnet.h       |   38 +++----
 opensm/include/opensm/osm_switch.h       |  152 ++++++++++++----------------
 opensm/include/opensm/osm_ucast_mgr.h    |   14 ++--
 opensm/include/opensm/osm_vl15intf.h     |   22 ++---
 opensm/opensm/osm_db_files.c             |   14 ++--
 opensm/opensm/osm_db_pack.c              |    8 +-
 opensm/opensm/osm_inform.c               |    8 +-
 opensm/opensm/osm_lid_mgr.c              |   21 ++--
 opensm/opensm/osm_log.c                  |   30 +++---
 opensm/opensm/osm_mad_pool.c             |   25 ++---
 opensm/opensm/osm_mcast_tbl.c            |   42 +++-----
 opensm/opensm/osm_mcm_port.c             |    2 +-
 opensm/opensm/osm_multicast.c            |    4 +-
 opensm/opensm/osm_node.c                 |   51 ++++------
 opensm/opensm/osm_opensm.c               |   12 +--
 opensm/opensm/osm_perfmgr.c              |    2 +-
 opensm/opensm/osm_pkey.c                 |    4 +-
 opensm/opensm/osm_port.c                 |    6 +-
 opensm/opensm/osm_prtn.c                 |   14 +--
 opensm/opensm/osm_qos_parser_y.y         |    2 +-
 opensm/opensm/osm_remote_sm.c            |   10 +-
 opensm/opensm/osm_req.c                  |   28 ++---
 opensm/opensm/osm_resp.c                 |   22 ++--
 opensm/opensm/osm_router.c               |    8 +-
 opensm/opensm/osm_sa.c                   |   44 +++-----
 opensm/opensm/osm_sa_mad_ctrl.c          |    2 +-
 opensm/opensm/osm_sa_mcmember_record.c   |    2 +-
 opensm/opensm/osm_service.c              |   48 +++------
 opensm/opensm/osm_sm.c                   |    4 +-
 opensm/opensm/osm_sm_mad_ctrl.c          |    2 +-
 opensm/opensm/osm_subnet.c               |   31 +++---
 opensm/opensm/osm_switch.c               |   68 +++++-------
 opensm/opensm/osm_ucast_mgr.c            |   17 ++--
 opensm/opensm/osm_vl15intf.c             |    4 +-
 60 files changed, 710 insertions(+), 921 deletions(-)

diff --git a/opensm/include/opensm/osm_db.h b/opensm/include/opensm/osm_db.h
index 56bae31..fa331b4 100644
--- a/opensm/include/opensm/osm_db.h
+++ b/opensm/include/opensm/osm_db.h
@@ -144,7 +144,7 @@ typedef struct osm_db {
 *
 * SYNOPSIS
 */
-void osm_db_construct(IN osm_db_t * const p_db);
+void osm_db_construct(IN osm_db_t * p_db);
 /*
 * PARAMETERS
 *	p_db
@@ -166,7 +166,7 @@ void osm_db_construct(IN osm_db_t * const p_db);
 *
 * SYNOPSIS
 */
-void osm_db_destroy(IN osm_db_t * const p_db);
+void osm_db_destroy(IN osm_db_t * p_db);
 /*
 * PARAMETERS
 *	p_db
@@ -185,7 +185,7 @@ void osm_db_destroy(IN osm_db_t * const p_db);
 *
 * SYNOPSIS
 */
-int osm_db_init(IN osm_db_t * const p_db, IN osm_log_t * p_log);
+int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log);
 /*
 * PARAMETERS
 *
@@ -211,8 +211,7 @@ int osm_db_init(IN osm_db_t * const p_db, IN osm_log_t * p_log);
 *
 * SYNOPSIS
 */
-osm_db_domain_t *osm_db_domain_init(IN osm_db_t * const p_db,
-				    IN char *domain_name);
+osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name);
 /*
 * PARAMETERS
 *
@@ -344,7 +343,7 @@ int osm_db_keys(IN osm_db_domain_t * p_domain, OUT cl_list_t * p_key_list);
 * SYNOPSIS
 */
 /* lookup value by key */
-char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char *const p_key);
+char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char *p_key);
 /*
 * PARAMETERS
 *
@@ -371,9 +370,7 @@ char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char *const p_key);
 *
 * SYNOPSIS
 */
-int
-osm_db_update(IN osm_db_domain_t * p_domain,
-	      IN char *const p_key, IN char *const p_val);
+int osm_db_update(IN osm_db_domain_t * p_domain, IN char *p_key, IN char *p_val);
 /*
 * PARAMETERS
 *
@@ -405,7 +402,7 @@ osm_db_update(IN osm_db_domain_t * p_domain,
 *
 * SYNOPSIS
 */
-int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *const p_key);
+int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key);
 /*
 * PARAMETERS
 *
diff --git a/opensm/include/opensm/osm_db_pack.h b/opensm/include/opensm/osm_db_pack.h
index 83861a6..6251d92 100644
--- a/opensm/include/opensm/osm_db_pack.h
+++ b/opensm/include/opensm/osm_db_pack.h
@@ -72,7 +72,7 @@ BEGIN_C_DECLS
 *
 * SYNOPSIS
 */
-static inline osm_db_domain_t *osm_db_guid2lid_init(IN osm_db_t * const p_db)
+static inline osm_db_domain_t *osm_db_guid2lid_init(IN osm_db_t * p_db)
 {
 	return (osm_db_domain_init(p_db, "guid2lid"));
 }
@@ -122,9 +122,8 @@ typedef struct osm_db_guid_elem {
 *
 * SYNOPSIS
 */
-int
-osm_db_guid2lid_guids(IN osm_db_domain_t * const p_g2l,
-		      OUT cl_qlist_t * p_guid_list);
+int osm_db_guid2lid_guids(IN osm_db_domain_t * p_g2l,
+			  OUT cl_qlist_t * p_guid_list);
 /*
 * PARAMETERS
 *	p_g2l
@@ -153,10 +152,8 @@ osm_db_guid2lid_guids(IN osm_db_domain_t * const p_g2l,
 *
 * SYNOPSIS
 */
-int
-osm_db_guid2lid_get(IN osm_db_domain_t * const p_g2l,
-		    IN uint64_t guid,
-		    OUT uint16_t * p_min_lid, OUT uint16_t * p_max_lid);
+int osm_db_guid2lid_get(IN osm_db_domain_t * p_g2l, IN uint64_t guid,
+			OUT uint16_t * p_min_lid, OUT uint16_t * p_max_lid);
 /*
 * PARAMETERS
 *	p_g2l
@@ -188,9 +185,8 @@ osm_db_guid2lid_get(IN osm_db_domain_t * const p_g2l,
 *
 * SYNOPSIS
 */
-int
-osm_db_guid2lid_set(IN osm_db_domain_t * const p_g2l,
-		    IN uint64_t guid, IN uint16_t min_lid, IN uint16_t max_lid);
+int osm_db_guid2lid_set(IN osm_db_domain_t * p_g2l, IN uint64_t guid,
+			IN uint16_t min_lid, IN uint16_t max_lid);
 /*
 * PARAMETERS
 *	p_g2l
@@ -222,7 +218,7 @@ osm_db_guid2lid_set(IN osm_db_domain_t * const p_g2l,
 *
 * SYNOPSIS
 */
-int osm_db_guid2lid_delete(IN osm_db_domain_t * const p_g2l, IN uint64_t guid);
+int osm_db_guid2lid_delete(IN osm_db_domain_t * p_g2l, IN uint64_t guid);
 /*
 * PARAMETERS
 *	p_g2l
diff --git a/opensm/include/opensm/osm_inform.h b/opensm/include/opensm/osm_inform.h
index 1528642..7a186b5 100644
--- a/opensm/include/opensm/osm_inform.h
+++ b/opensm/include/opensm/osm_inform.h
@@ -155,7 +155,7 @@ osm_infr_t *osm_infr_new(IN const osm_infr_t * p_infr_rec);
 *
 * SYNOPSIS
 */
-void osm_infr_delete(IN osm_infr_t * const p_infr);
+void osm_infr_delete(IN osm_infr_t * p_infr);
 /*
 * PARAMETERS
 *	p_infr
@@ -176,7 +176,7 @@ void osm_infr_delete(IN osm_infr_t * const p_infr);
 */
 osm_infr_t *osm_infr_get_by_rec(IN osm_subn_t const *p_subn,
 				IN osm_log_t * p_log,
-				IN osm_infr_t * const p_infr_rec);
+				IN osm_infr_t * p_infr_rec);
 /*
 * PARAMETERS
 *	p_subn
@@ -194,13 +194,11 @@ osm_infr_t *osm_infr_get_by_rec(IN osm_subn_t const *p_subn,
 *	Inform Record, osm_infr_new, osm_infr_delete
 *********/
 
-void
-osm_infr_insert_to_db(IN osm_subn_t * p_subn,
-		      IN osm_log_t * p_log, IN osm_infr_t * p_infr);
+void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			   IN osm_infr_t * p_infr);
 
-void
-osm_infr_remove_from_db(IN osm_subn_t * p_subn,
-			IN osm_log_t * p_log, IN osm_infr_t * p_infr);
+void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			     IN osm_infr_t * p_infr);
 
 /****f* OpenSM: Inform Record/osm_report_notice
 * NAME
@@ -216,9 +214,8 @@ osm_infr_remove_from_db(IN osm_subn_t * p_subn,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_report_notice(IN osm_log_t * const p_log,
-		  IN osm_subn_t * p_subn, IN ib_mad_notice_attr_t * p_ntc);
+ib_api_status_t osm_report_notice(IN osm_log_t * p_log, IN osm_subn_t * p_subn,
+				  IN ib_mad_notice_attr_t * p_ntc);
 /*
 * PARAMETERS
 *	p_rcv
diff --git a/opensm/include/opensm/osm_lid_mgr.h b/opensm/include/opensm/osm_lid_mgr.h
index 7e41c0c..c9bdb20 100644
--- a/opensm/include/opensm/osm_lid_mgr.h
+++ b/opensm/include/opensm/osm_lid_mgr.h
@@ -143,7 +143,7 @@ typedef struct osm_lid_mgr {
 *
 * SYNOPSIS
 */
-void osm_lid_mgr_construct(IN osm_lid_mgr_t * const p_mgr);
+void osm_lid_mgr_construct(IN osm_lid_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -173,7 +173,7 @@ void osm_lid_mgr_construct(IN osm_lid_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-void osm_lid_mgr_destroy(IN osm_lid_mgr_t * const p_mgr);
+void osm_lid_mgr_destroy(IN osm_lid_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -205,7 +205,7 @@ void osm_lid_mgr_destroy(IN osm_lid_mgr_t * const p_mgr);
 * SYNOPSIS
 */
 ib_api_status_t
-osm_lid_mgr_init(IN osm_lid_mgr_t * const p_mgr, IN struct osm_sm * sm);
+osm_lid_mgr_init(IN osm_lid_mgr_t * p_mgr, IN struct osm_sm * sm);
 /*
 * PARAMETERS
 *	p_mgr
@@ -235,7 +235,7 @@ osm_lid_mgr_init(IN osm_lid_mgr_t * const p_mgr, IN struct osm_sm * sm);
 *
 * SYNOPSIS
 */
-int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * const p_mgr);
+int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -260,7 +260,7 @@ int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * const p_mgr);
+int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
diff --git a/opensm/include/opensm/osm_log.h b/opensm/include/opensm/osm_log.h
index 065e2a1..4fda9d5 100644
--- a/opensm/include/opensm/osm_log.h
+++ b/opensm/include/opensm/osm_log.h
@@ -132,7 +132,7 @@ typedef struct osm_log {
 *
 * SYNOPSIS
 */
-static inline void osm_log_construct(IN osm_log_t * const p_log)
+static inline void osm_log_construct(IN osm_log_t * p_log)
 {
 	cl_spinlock_construct(&p_log->lock);
 }
@@ -166,7 +166,7 @@ static inline void osm_log_construct(IN osm_log_t * const p_log)
 *
 * SYNOPSIS
 */
-static inline void osm_log_destroy(IN osm_log_t * const p_log)
+static inline void osm_log_destroy(IN osm_log_t * p_log)
 {
 	cl_spinlock_destroy(&p_log->lock);
 	if (p_log->out_port != stdout) {
@@ -206,13 +206,10 @@ static inline void osm_log_destroy(IN osm_log_t * const p_log)
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_log_init_v2(IN osm_log_t * const p_log,
-		IN const boolean_t flush,
-		IN const uint8_t log_flags,
-		IN const char *log_file,
-		IN const unsigned long max_size,
-		IN const boolean_t accum_log_file);
+ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
+				IN uint8_t log_flags, IN const char *log_file,
+				IN unsigned long max_size,
+				IN boolean_t accum_log_file);
 /*
 * PARAMETERS
 *	p_log
@@ -271,19 +268,15 @@ int osm_log_reopen_file(osm_log_t * p_log);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_log_init(IN osm_log_t * const p_log,
-	     IN const boolean_t flush,
-	     IN const uint8_t log_flags,
-	     IN const char *log_file, IN const boolean_t accum_log_file);
+ib_api_status_t osm_log_init(IN osm_log_t * p_log, IN boolean_t flush,
+			     IN uint8_t log_flags, IN const char *log_file,
+			     IN boolean_t accum_log_file);
 /*
  * Same as osm_log_init_v2() but without max_size parameter
  */
 
-void
-osm_log(IN osm_log_t * const p_log,
-	IN const osm_log_level_t verbosity,
-	IN const char *p_str, ...) STRICT_OSM_LOG_FORMAT;
+void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
+	     IN const char *p_str, ...) STRICT_OSM_LOG_FORMAT;
 
 /****f* OpenSM: Log/osm_log_get_level
 * NAME
@@ -294,10 +287,9 @@ osm_log(IN osm_log_t * const p_log,
 *
 * SYNOPSIS
 */
-static inline osm_log_level_t
-osm_log_get_level(IN const osm_log_t * const p_log)
+static inline osm_log_level_t osm_log_get_level(IN const osm_log_t * p_log)
 {
-	return (p_log->level);
+	return p_log->level;
 }
 
 /*
@@ -324,8 +316,8 @@ osm_log_get_level(IN const osm_log_t * const p_log)
 *
 * SYNOPSIS
 */
-static inline void
-osm_log_set_level(IN osm_log_t * const p_log, IN const osm_log_level_t level)
+static inline void osm_log_set_level(IN osm_log_t * p_log,
+				     IN osm_log_level_t level)
 {
 	p_log->level = level;
 	osm_log(p_log, OSM_LOG_ALL, "Setting log level to: 0x%02x\n", level);
@@ -359,9 +351,8 @@ osm_log_set_level(IN osm_log_t * const p_log, IN const osm_log_level_t level)
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_log_is_active(IN const osm_log_t * const p_log,
-		  IN const osm_log_level_t level)
+static inline boolean_t osm_log_is_active(IN const osm_log_t * p_log,
+					  IN osm_log_level_t level)
 {
 	return ((p_log->level & level) != 0);
 }
@@ -387,8 +378,8 @@ osm_log_is_active(IN const osm_log_t * const p_log,
 
 extern void osm_log_msg_box(osm_log_t *log, osm_log_level_t level,
 			    const char *func_name, const char *msg);
-extern void osm_log_raw(IN osm_log_t * const p_log,
-	    IN const osm_log_level_t verbosity, IN const char *p_buf);
+extern void osm_log_raw(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
+			IN const char *p_buf);
 
 #define OSM_LOG(log, level, fmt, ...) do { \
 		if (osm_log_is_active(log, (level))) \
diff --git a/opensm/include/opensm/osm_mad_pool.h b/opensm/include/opensm/osm_mad_pool.h
index 0aa5b46..7a741a4 100644
--- a/opensm/include/opensm/osm_mad_pool.h
+++ b/opensm/include/opensm/osm_mad_pool.h
@@ -109,7 +109,7 @@ typedef struct osm_mad_pool {
 *
 * SYNOPSIS
 */
-void osm_mad_pool_construct(IN osm_mad_pool_t * const p_pool);
+void osm_mad_pool_construct(IN osm_mad_pool_t * p_pool);
 /*
 * PARAMETERS
 *	p_pool
@@ -138,7 +138,7 @@ void osm_mad_pool_construct(IN osm_mad_pool_t * const p_pool);
 *
 * SYNOPSIS
 */
-void osm_mad_pool_destroy(IN osm_mad_pool_t * const p_pool);
+void osm_mad_pool_destroy(IN osm_mad_pool_t * p_pool);
 /*
 * PARAMETERS
 *	p_pool
@@ -166,7 +166,7 @@ void osm_mad_pool_destroy(IN osm_mad_pool_t * const p_pool);
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * const p_pool);
+ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * p_pool);
 /*
 * PARAMETERS
 *	p_pool
@@ -191,10 +191,10 @@ ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * const p_pool);
 *
 * SYNOPSIS
 */
-osm_madw_t *osm_mad_pool_get(IN osm_mad_pool_t * const p_pool,
+osm_madw_t *osm_mad_pool_get(IN osm_mad_pool_t * p_pool,
 			     IN osm_bind_handle_t h_bind,
-			     IN const uint32_t total_size,
-			     IN const osm_mad_addr_t * const p_mad_addr);
+			     IN uint32_t total_size,
+			     IN const osm_mad_addr_t * p_mad_addr);
 /*
 * PARAMETERS
 *	p_pool
@@ -235,8 +235,7 @@ osm_madw_t *osm_mad_pool_get(IN osm_mad_pool_t * const p_pool,
 *
 * SYNOPSIS
 */
-void osm_mad_pool_put(IN osm_mad_pool_t * const p_pool,
-		      IN osm_madw_t * const p_madw);
+void osm_mad_pool_put(IN osm_mad_pool_t * p_pool, IN osm_madw_t * p_madw);
 /*
 * PARAMETERS
 *	p_pool
@@ -266,12 +265,11 @@ void osm_mad_pool_put(IN osm_mad_pool_t * const p_pool,
 *
 * SYNOPSIS
 */
-osm_madw_t *osm_mad_pool_get_wrapper(IN osm_mad_pool_t * const p_pool,
+osm_madw_t *osm_mad_pool_get_wrapper(IN osm_mad_pool_t * p_pool,
 				     IN osm_bind_handle_t h_bind,
-				     IN const uint32_t total_size,
-				     IN const ib_mad_t * const p_mad,
-				     IN const osm_mad_addr_t *
-				     const p_mad_addr);
+				     IN uint32_t total_size,
+				     IN const ib_mad_t * p_mad,
+				     IN const osm_mad_addr_t * p_mad_addr);
 /*
 * PARAMETERS
 *	p_pool
@@ -316,7 +314,7 @@ osm_madw_t *osm_mad_pool_get_wrapper(IN osm_mad_pool_t * const p_pool,
 *
 * SYNOPSIS
 */
-osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * const p_pool);
+osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * p_pool);
 /*
 * PARAMETERS
 *	p_pool
@@ -347,9 +345,9 @@ osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * const p_pool);
 * SYNOPSIS
 */
 static inline uint32_t
-osm_mad_pool_get_outstanding(IN const osm_mad_pool_t * const p_pool)
+osm_mad_pool_get_outstanding(IN const osm_mad_pool_t * p_pool)
 {
-	return (p_pool->mads_out);
+	return p_pool->mads_out;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_madw.h b/opensm/include/opensm/osm_madw.h
index f47142d..afa7047 100644
--- a/opensm/include/opensm/osm_madw.h
+++ b/opensm/include/opensm/osm_madw.h
@@ -469,11 +469,10 @@ typedef struct osm_madw {
 *
 * SYNOPSIS
 */
-static inline void
-osm_madw_init(IN osm_madw_t * const p_madw,
-	      IN osm_bind_handle_t h_bind,
-	      IN const uint32_t mad_size,
-	      IN const osm_mad_addr_t * const p_mad_addr)
+static inline void osm_madw_init(IN osm_madw_t * p_madw,
+				 IN osm_bind_handle_t h_bind,
+				 IN uint32_t mad_size,
+				 IN const osm_mad_addr_t * p_mad_addr)
 {
 	memset(p_madw, 0, sizeof(*p_madw));
 	p_madw->h_bind = h_bind;
@@ -513,7 +512,7 @@ osm_madw_init(IN osm_madw_t * const p_madw,
 *
 * SYNOPSIS
 */
-static inline ib_smp_t *osm_madw_get_smp_ptr(IN const osm_madw_t * const p_madw)
+static inline ib_smp_t *osm_madw_get_smp_ptr(IN const osm_madw_t * p_madw)
 {
 	return ((ib_smp_t *) p_madw->p_mad);
 }
@@ -541,8 +540,7 @@ static inline ib_smp_t *osm_madw_get_smp_ptr(IN const osm_madw_t * const p_madw)
 *
 * SYNOPSIS
 */
-static inline ib_sa_mad_t *osm_madw_get_sa_mad_ptr(IN const osm_madw_t *
-						   const p_madw)
+static inline ib_sa_mad_t *osm_madw_get_sa_mad_ptr(IN const osm_madw_t * p_madw)
 {
 	return ((ib_sa_mad_t *) p_madw->p_mad);
 }
@@ -568,7 +566,7 @@ static inline ib_sa_mad_t *osm_madw_get_sa_mad_ptr(IN const osm_madw_t *
 * SYNOPSIS
 */
 static inline ib_perfmgt_mad_t *osm_madw_get_perfmgt_mad_ptr(IN const osm_madw_t
-							     * const p_madw)
+							     * p_madw)
 {
 	return ((ib_perfmgt_mad_t *) p_madw->p_mad);
 }
@@ -597,7 +595,7 @@ static inline ib_perfmgt_mad_t *osm_madw_get_perfmgt_mad_ptr(IN const osm_madw_t
 * SYNOPSIS
 */
 static inline osm_ni_context_t *osm_madw_get_ni_context_ptr(IN const osm_madw_t
-							    * const p_madw)
+							    * p_madw)
 {
 	return ((osm_ni_context_t *) & p_madw->context);
 }
@@ -625,7 +623,7 @@ static inline osm_ni_context_t *osm_madw_get_ni_context_ptr(IN const osm_madw_t
 * SYNOPSIS
 */
 static inline osm_pi_context_t *osm_madw_get_pi_context_ptr(IN const osm_madw_t
-							    * const p_madw)
+							    * p_madw)
 {
 	return ((osm_pi_context_t *) & p_madw->context);
 }
@@ -653,7 +651,7 @@ static inline osm_pi_context_t *osm_madw_get_pi_context_ptr(IN const osm_madw_t
 * SYNOPSIS
 */
 static inline osm_nd_context_t *osm_madw_get_nd_context_ptr(IN const osm_madw_t
-							    * const p_madw)
+							    * p_madw)
 {
 	return ((osm_nd_context_t *) & p_madw->context);
 }
@@ -682,7 +680,7 @@ static inline osm_nd_context_t *osm_madw_get_nd_context_ptr(IN const osm_madw_t
 */
 static inline osm_lft_context_t *osm_madw_get_lft_context_ptr(IN const
 							      osm_madw_t *
-							      const p_madw)
+							      p_madw)
 {
 	return ((osm_lft_context_t *) & p_madw->context);
 }
@@ -711,7 +709,7 @@ static inline osm_lft_context_t *osm_madw_get_lft_context_ptr(IN const
 */
 static inline osm_mft_context_t *osm_madw_get_mft_context_ptr(IN const
 							      osm_madw_t *
-							      const p_madw)
+							      p_madw)
 {
 	return ((osm_mft_context_t *) & p_madw->context);
 }
@@ -739,7 +737,7 @@ static inline osm_mft_context_t *osm_madw_get_mft_context_ptr(IN const
 * SYNOPSIS
 */
 static inline osm_si_context_t *osm_madw_get_si_context_ptr(IN const osm_madw_t
-							    * const p_madw)
+							    * p_madw)
 {
 	return ((osm_si_context_t *) & p_madw->context);
 }
@@ -768,7 +766,7 @@ static inline osm_si_context_t *osm_madw_get_si_context_ptr(IN const osm_madw_t
 */
 static inline osm_smi_context_t *osm_madw_get_smi_context_ptr(IN const
 							      osm_madw_t *
-							      const p_madw)
+							      p_madw)
 {
 	return ((osm_smi_context_t *) & p_madw->context);
 }
@@ -797,7 +795,7 @@ static inline osm_smi_context_t *osm_madw_get_smi_context_ptr(IN const
 */
 static inline osm_pkey_context_t *osm_madw_get_pkey_context_ptr(IN const
 								osm_madw_t *
-								const p_madw)
+								p_madw)
 {
 	return ((osm_pkey_context_t *) & p_madw->context);
 }
@@ -826,7 +824,7 @@ static inline osm_pkey_context_t *osm_madw_get_pkey_context_ptr(IN const
 */
 static inline osm_slvl_context_t *osm_madw_get_slvl_context_ptr(IN const
 								osm_madw_t *
-								const p_madw)
+								p_madw)
 {
 	return ((osm_slvl_context_t *) & p_madw->context);
 }
@@ -855,7 +853,7 @@ static inline osm_slvl_context_t *osm_madw_get_slvl_context_ptr(IN const
 */
 static inline osm_vla_context_t *osm_madw_get_vla_context_ptr(IN const
 							      osm_madw_t *
-							      const p_madw)
+							      p_madw)
 {
 	return ((osm_vla_context_t *) & p_madw->context);
 }
@@ -917,7 +915,7 @@ static inline osm_arbitrary_context_t *osm_madw_get_arbitrary_context_ptr(IN
 * SYNOPSIS
 */
 static inline osm_vend_wrap_t *osm_madw_get_vend_ptr(IN const osm_madw_t *
-						     const p_madw)
+						     p_madw)
 {
 	return ((osm_vend_wrap_t *) & p_madw->vend_wrap);
 }
@@ -945,7 +943,7 @@ static inline osm_vend_wrap_t *osm_madw_get_vend_ptr(IN const osm_madw_t *
 * SYNOPSIS
 */
 static inline osm_bind_handle_t
-osm_madw_get_bind_handle(IN const osm_madw_t * const p_madw)
+osm_madw_get_bind_handle(IN const osm_madw_t * p_madw)
 {
 	return ((osm_bind_handle_t) p_madw->h_bind);
 }
@@ -973,7 +971,7 @@ osm_madw_get_bind_handle(IN const osm_madw_t * const p_madw)
 * SYNOPSIS
 */
 static inline osm_mad_addr_t *osm_madw_get_mad_addr_ptr(IN const osm_madw_t *
-							const p_madw)
+							p_madw)
 {
 	return ((osm_mad_addr_t *) & p_madw->mad_addr);
 }
@@ -1000,7 +998,7 @@ static inline osm_mad_addr_t *osm_madw_get_mad_addr_ptr(IN const osm_madw_t *
 *
 * SYNOPSIS
 */
-static inline ib_mad_t *osm_madw_get_mad_ptr(IN const osm_madw_t * const p_madw)
+static inline ib_mad_t *osm_madw_get_mad_ptr(IN const osm_madw_t * p_madw)
 {
 	return ((ib_mad_t *) p_madw->p_mad);
 }
@@ -1028,8 +1026,7 @@ static inline ib_mad_t *osm_madw_get_mad_ptr(IN const osm_madw_t * const p_madw)
 *
 * SYNOPSIS
 */
-static inline cl_disp_msgid_t
-osm_madw_get_err_msg(IN const osm_madw_t * const p_madw)
+static inline cl_disp_msgid_t osm_madw_get_err_msg(IN const osm_madw_t * p_madw)
 {
 	return ((cl_disp_msgid_t) p_madw->fail_msg);
 }
@@ -1057,8 +1054,8 @@ osm_madw_get_err_msg(IN const osm_madw_t * const p_madw)
 *
 * SYNOPSIS
 */
-static inline void
-osm_madw_set_mad(IN osm_madw_t * const p_madw, IN const ib_mad_t * const p_mad)
+static inline void osm_madw_set_mad(IN osm_madw_t * p_madw,
+				    IN const ib_mad_t * p_mad)
 {
 	p_madw->p_mad = p_mad;
 }
@@ -1088,9 +1085,8 @@ osm_madw_set_mad(IN osm_madw_t * const p_madw, IN const ib_mad_t * const p_mad)
 *
 * SYNOPSIS
 */
-static inline void
-osm_madw_copy_context(IN osm_madw_t * const p_dest,
-		      IN const osm_madw_t * const p_src)
+static inline void osm_madw_copy_context(IN osm_madw_t * p_dest,
+					 IN const osm_madw_t * p_src)
 {
 	p_dest->context = p_src->context;
 }
diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 15b95cf..710d199 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -114,9 +114,8 @@ typedef struct osm_mcast_fwdbl {
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_mcast_tbl_init(IN osm_mcast_tbl_t * const p_tbl,
-		   IN uint8_t const num_ports, IN uint16_t const capacity);
+ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
+				   IN uint8_t num_ports, IN uint16_t capacity);
 /*
 * PARAMETERS
 *	num_ports
@@ -143,7 +142,7 @@ osm_mcast_tbl_init(IN osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** const pp_tbl);
+void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
 /*
 * PARAMETERS
 *	pp_tbl
@@ -168,7 +167,7 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** const pp_tbl);
 *
 * SYNOPSIS
 */
-void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * const p_tbl);
+void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl);
 /*
 * PARAMETERS
 *	p_tbl
@@ -191,9 +190,8 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * const p_tbl);
 *
 * SYNOPSIS
 */
-void
-osm_mcast_tbl_set(IN osm_mcast_tbl_t * const p_tbl,
-		  IN const uint16_t mlid_ho, IN const uint8_t port_num);
+void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
+		       IN uint8_t port_num);
 /*
 * PARAMETERS
 *	p_tbl
@@ -222,9 +220,7 @@ osm_mcast_tbl_set(IN osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-void
-osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * const p_tbl,
-			 IN const uint16_t mlid_ho);
+void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho);
 /*
 * PARAMETERS
 *	p_tbl
@@ -250,9 +246,8 @@ osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-boolean_t
-osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * const p_tbl,
-		      IN const uint16_t mlid_ho, IN const uint8_t port_num);
+boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
+				IN uint16_t mlid_ho, IN uint8_t port_num);
 /*
 * PARAMETERS
 *	p_tbl
@@ -281,9 +276,8 @@ osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-boolean_t
-osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * const p_tbl,
-			  IN const uint16_t mlid_ho);
+boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
+				    IN uint16_t mlid_ho);
 /*
 * PARAMETERS
 *	p_tbl
@@ -309,10 +303,10 @@ osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * const p_tbl,
-			IN const ib_net16_t * const p_block,
-			IN const int16_t block_num, IN const uint8_t position);
+ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN const ib_net16_t * p_block,
+					IN int16_t block_num,
+					IN uint8_t position);
 /*
 * PARAMETERS
 *	p_tbl
@@ -341,11 +335,9 @@ osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-boolean_t
-osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * const p_tbl,
-			IN const int16_t block_num,
-			IN const uint8_t position,
-			OUT ib_net16_t * const p_block);
+boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
+				  IN int16_t block_num, IN uint8_t position,
+				  OUT ib_net16_t * p_block);
 /*
 * PARAMETERS
 *	p_tbl
@@ -380,10 +372,9 @@ osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * const p_tbl,
 *
 * SYNOPSIS
 */
-static inline uint16_t
-osm_mcast_tbl_get_max_block(IN osm_mcast_tbl_t * const p_tbl)
+static inline uint16_t osm_mcast_tbl_get_max_block(IN osm_mcast_tbl_t * p_tbl)
 {
-	return (p_tbl->max_block);
+	return p_tbl->max_block;
 }
 
 /*
@@ -410,7 +401,7 @@ osm_mcast_tbl_get_max_block(IN osm_mcast_tbl_t * const p_tbl)
 * SYNOPSIS
 */
 static inline int16_t
-osm_mcast_tbl_get_max_block_in_use(IN osm_mcast_tbl_t * const p_tbl)
+osm_mcast_tbl_get_max_block_in_use(IN osm_mcast_tbl_t * p_tbl)
 {
 	return (p_tbl->max_block_in_use);
 }
@@ -439,7 +430,7 @@ osm_mcast_tbl_get_max_block_in_use(IN osm_mcast_tbl_t * const p_tbl)
 * SYNOPSIS
 */
 static inline uint8_t
-osm_mcast_tbl_get_max_position(IN osm_mcast_tbl_t * const p_tbl)
+osm_mcast_tbl_get_max_position(IN osm_mcast_tbl_t * p_tbl)
 {
 	return (p_tbl->max_position);
 }
diff --git a/opensm/include/opensm/osm_mcm_port.h b/opensm/include/opensm/osm_mcm_port.h
index 4d82df7..d22a287 100644
--- a/opensm/include/opensm/osm_mcm_port.h
+++ b/opensm/include/opensm/osm_mcm_port.h
@@ -154,7 +154,7 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t * port, IN struct osm_mgrp *mgrp,
 *
 * SYNOPSIS
 */
-void osm_mcm_port_delete(IN osm_mcm_port_t * const p_mcm);
+void osm_mcm_port_delete(IN osm_mcm_port_t * p_mcm);
 /*
 * PARAMETERS
 *	p_mcm
diff --git a/opensm/include/opensm/osm_multicast.h b/opensm/include/opensm/osm_multicast.h
index 15d7e78..a99bb62 100644
--- a/opensm/include/opensm/osm_multicast.h
+++ b/opensm/include/opensm/osm_multicast.h
@@ -142,7 +142,7 @@ typedef struct osm_mgrp {
 *
 * SYNOPSIS
 */
-osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid, IN ib_member_rec_t * mcmr);
+osm_mgrp_t *osm_mgrp_new(IN ib_net16_t mlid, IN ib_member_rec_t * mcmr);
 /*
 * PARAMETERS
 *	mlid
@@ -170,7 +170,7 @@ osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid, IN ib_member_rec_t * mcmr);
 *
 * SYNOPSIS
 */
-void osm_mgrp_delete(IN osm_mgrp_t * const p_mgrp);
+void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp);
 /*
 * PARAMETERS
 *	p_mgrp
@@ -194,9 +194,8 @@ void osm_mgrp_delete(IN osm_mgrp_t * const p_mgrp);
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_mgrp_is_guid(IN const osm_mgrp_t * const p_mgrp,
-		 IN const ib_net64_t port_guid)
+static inline boolean_t osm_mgrp_is_guid(IN const osm_mgrp_t * p_mgrp,
+					 IN ib_net64_t port_guid)
 {
 	return (cl_qmap_get(&p_mgrp->mcm_port_tbl, port_guid) !=
 		cl_qmap_end(&p_mgrp->mcm_port_tbl));
@@ -229,7 +228,7 @@ osm_mgrp_is_guid(IN const osm_mgrp_t * const p_mgrp,
 *
 * SYNOPSIS
 */
-static inline boolean_t osm_mgrp_is_empty(IN const osm_mgrp_t * const p_mgrp)
+static inline boolean_t osm_mgrp_is_empty(IN const osm_mgrp_t * p_mgrp)
 {
 	return (cl_qmap_count(&p_mgrp->mcm_port_tbl) == 0);
 }
@@ -258,9 +257,9 @@ static inline boolean_t osm_mgrp_is_empty(IN const osm_mgrp_t * const p_mgrp)
 *
 * SYNOPSIS
 */
-static inline ib_net16_t osm_mgrp_get_mlid(IN const osm_mgrp_t * const p_mgrp)
+static inline ib_net16_t osm_mgrp_get_mlid(IN const osm_mgrp_t * p_mgrp)
 {
-	return (p_mgrp->mlid);
+	return p_mgrp->mlid;
 }
 
 /*
@@ -321,8 +320,8 @@ osm_mcm_port_t *osm_mgrp_add_port(osm_subn_t *subn, osm_log_t *log,
 *
 * SYNOPSIS
 */
-osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * const p_mgrp,
-				      IN const ib_net64_t port_guid);
+osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
+				      IN ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_mgrp
diff --git a/opensm/include/opensm/osm_node.h b/opensm/include/opensm/osm_node.h
index c7befff..c9d7080 100644
--- a/opensm/include/opensm/osm_node.h
+++ b/opensm/include/opensm/osm_node.h
@@ -153,7 +153,7 @@ typedef struct osm_node {
 *
 * SYNOPSIS
 */
-void osm_node_delete(IN OUT osm_node_t ** const p_node);
+void osm_node_delete(IN OUT osm_node_t ** p_node);
 /*
 * PARAMETERS
 *	p_node
@@ -180,7 +180,7 @@ void osm_node_delete(IN OUT osm_node_t ** const p_node);
 *
 * SYNOPSIS
 */
-osm_node_t *osm_node_new(IN const osm_madw_t * const p_madw);
+osm_node_t *osm_node_new(IN const osm_madw_t * p_madw);
 /*
 * PARAMETERS
 *	p_madw
@@ -208,8 +208,8 @@ osm_node_t *osm_node_new(IN const osm_madw_t * const p_madw);
 *
 * SYNOPSIS
 */
-static inline osm_physp_t *osm_node_get_physp_ptr(IN osm_node_t * const p_node,
-						  IN const uint32_t port_num)
+static inline osm_physp_t *osm_node_get_physp_ptr(IN osm_node_t * p_node,
+						  IN uint32_t port_num)
 {
 
 	CL_ASSERT(port_num < p_node->physp_tbl_size);
@@ -245,9 +245,9 @@ static inline osm_physp_t *osm_node_get_physp_ptr(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-static inline uint8_t osm_node_get_type(IN const osm_node_t * const p_node)
+static inline uint8_t osm_node_get_type(IN const osm_node_t * p_node)
 {
-	return (p_node->node_info.node_type);
+	return p_node->node_info.node_type;
 }
 
 /*
@@ -276,9 +276,9 @@ static inline uint8_t osm_node_get_type(IN const osm_node_t * const p_node)
 *
 * SYNOPSIS
 */
-static inline uint8_t osm_node_get_num_physp(IN const osm_node_t * const p_node)
+static inline uint8_t osm_node_get_num_physp(IN const osm_node_t * p_node)
 {
-	return ((uint8_t) p_node->physp_tbl_size);
+	return (uint8_t) p_node->physp_tbl_size;
 }
 
 /*
@@ -306,8 +306,8 @@ static inline uint8_t osm_node_get_num_physp(IN const osm_node_t * const p_node)
 *
 * SYNOPSIS
 */
-osm_node_t *osm_node_get_remote_node(IN osm_node_t * const p_node,
-				     IN const uint8_t port_num,
+osm_node_t *osm_node_get_remote_node(IN osm_node_t * p_node,
+				     IN uint8_t port_num,
 				     OUT uint8_t * p_remote_port_num);
 /*
 * PARAMETERS
@@ -342,12 +342,11 @@ osm_node_t *osm_node_get_remote_node(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-static inline ib_net16_t
-osm_node_get_base_lid(IN const osm_node_t * const p_node,
-		      IN const uint32_t port_num)
+static inline ib_net16_t osm_node_get_base_lid(IN const osm_node_t * p_node,
+					       IN uint32_t port_num)
 {
 	CL_ASSERT(port_num < p_node->physp_tbl_size);
-	return (osm_physp_get_base_lid(&p_node->physp_table[port_num]));
+	return osm_physp_get_base_lid(&p_node->physp_table[port_num]);
 }
 
 /*
@@ -379,9 +378,8 @@ osm_node_get_base_lid(IN const osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-ib_net16_t
-osm_node_get_remote_base_lid(IN osm_node_t * const p_node,
-			     IN const uint32_t port_num);
+ib_net16_t osm_node_get_remote_base_lid(IN osm_node_t * p_node,
+					IN uint32_t port_num);
 /*
 * PARAMETERS
 *	p_node
@@ -410,11 +408,11 @@ osm_node_get_remote_base_lid(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_node_get_lmc(IN const osm_node_t * const p_node, IN const uint32_t port_num)
+static inline uint8_t osm_node_get_lmc(IN const osm_node_t * p_node,
+				       IN uint32_t port_num)
 {
 	CL_ASSERT(port_num < p_node->physp_tbl_size);
-	return (osm_physp_get_lmc(&p_node->physp_table[port_num]));
+	return osm_physp_get_lmc(&p_node->physp_table[port_num]);
 }
 
 /*
@@ -443,8 +441,8 @@ osm_node_get_lmc(IN const osm_node_t * const p_node, IN const uint32_t port_num)
 *
 * SYNOPSIS
 */
-void osm_node_init_physp(IN osm_node_t * const p_node, uint8_t port_num,
-			 IN const osm_madw_t * const p_madw);
+void osm_node_init_physp(IN osm_node_t * p_node, uint8_t port_num,
+			 IN const osm_madw_t * p_madw);
 /*
 * PARAMETERS
 *	p_node
@@ -474,10 +472,9 @@ void osm_node_init_physp(IN osm_node_t * const p_node, uint8_t port_num,
 *
 * SYNOPSIS
 */
-static inline ib_net64_t
-osm_node_get_node_guid(IN const osm_node_t * const p_node)
+static inline ib_net64_t osm_node_get_node_guid(IN const osm_node_t * p_node)
 {
-	return (p_node->node_info.node_guid);
+	return p_node->node_info.node_guid;
 }
 
 /*
@@ -503,11 +500,8 @@ osm_node_get_node_guid(IN const osm_node_t * const p_node)
 *
 * SYNOPSIS
 */
-void
-osm_node_link(IN osm_node_t * const p_node,
-	      IN const uint8_t port_num,
-	      IN osm_node_t * const p_remote_node,
-	      IN const uint8_t remote_port_num);
+void osm_node_link(IN osm_node_t * p_node, IN uint8_t port_num,
+		   IN osm_node_t * p_remote_node, IN uint8_t remote_port_num);
 /*
 * PARAMETERS
 *	p_node
@@ -542,11 +536,8 @@ osm_node_link(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-void
-osm_node_unlink(IN osm_node_t * const p_node,
-		IN const uint8_t port_num,
-		IN osm_node_t * const p_remote_node,
-		IN const uint8_t remote_port_num);
+void osm_node_unlink(IN osm_node_t * p_node, IN uint8_t port_num,
+		     IN osm_node_t * p_remote_node, IN uint8_t remote_port_num);
 /*
 * PARAMETERS
 *	p_node
@@ -581,11 +572,9 @@ osm_node_unlink(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-boolean_t
-osm_node_link_exists(IN osm_node_t * const p_node,
-		     IN const uint8_t port_num,
-		     IN osm_node_t * const p_remote_node,
-		     IN const uint8_t remote_port_num);
+boolean_t osm_node_link_exists(IN osm_node_t * p_node, IN uint8_t port_num,
+			       IN osm_node_t * p_remote_node,
+			       IN uint8_t remote_port_num);
 /*
 * PARAMETERS
 *	p_node
@@ -623,8 +612,7 @@ osm_node_link_exists(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-boolean_t
-osm_node_has_any_link(IN osm_node_t * const p_node, IN const uint8_t port_num);
+boolean_t osm_node_has_any_link(IN osm_node_t * p_node, IN uint8_t port_num);
 /*
 * PARAMETERS
 *	p_node
@@ -654,11 +642,10 @@ osm_node_has_any_link(IN osm_node_t * const p_node, IN const uint8_t port_num);
 *
 * SYNOPSIS
 */
-boolean_t
-osm_node_link_has_valid_ports(IN osm_node_t * const p_node,
-			      IN const uint8_t port_num,
-			      IN osm_node_t * const p_remote_node,
-			      IN const uint8_t remote_port_num);
+boolean_t osm_node_link_has_valid_ports(IN osm_node_t * p_node,
+					IN uint8_t port_num,
+					IN osm_node_t * p_remote_node,
+					IN uint8_t remote_port_num);
 /*
 * PARAMETERS
 *	p_node
diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index c121be4..36f1d29 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -246,7 +246,7 @@ typedef struct osm_opensm {
 *
 * SYNOPSIS
 */
-void osm_opensm_construct(IN osm_opensm_t * const p_osm);
+void osm_opensm_construct(IN osm_opensm_t * p_osm);
 /*
 * PARAMETERS
 *	p_osm
@@ -275,7 +275,7 @@ void osm_opensm_construct(IN osm_opensm_t * const p_osm);
 *
 * SYNOPSIS
 */
-void osm_opensm_destroy(IN osm_opensm_t * const p_osm);
+void osm_opensm_destroy(IN osm_opensm_t * p_osm);
 /*
 * PARAMETERS
 *	p_osm
@@ -303,9 +303,8 @@ void osm_opensm_destroy(IN osm_opensm_t * const p_osm);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_opensm_init(IN osm_opensm_t * const p_osm,
-		IN const osm_subn_opt_t * const p_opt);
+ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
+				IN const osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *	p_osm
@@ -333,7 +332,7 @@ osm_opensm_init(IN osm_opensm_t * const p_osm,
 *
 * SYNOPSIS
 */
-static inline void osm_opensm_sweep(IN osm_opensm_t * const p_osm)
+static inline void osm_opensm_sweep(IN osm_opensm_t * p_osm)
 {
 	osm_sm_sweep(&p_osm->sm);
 }
@@ -363,9 +362,8 @@ static inline void osm_opensm_sweep(IN osm_opensm_t * const p_osm)
 *
 * SYNOPSIS
 */
-static inline void
-osm_opensm_set_log_flags(IN osm_opensm_t * const p_osm,
-			 IN const osm_log_level_t log_flags)
+static inline void osm_opensm_set_log_flags(IN osm_opensm_t * p_osm,
+					    IN osm_log_level_t log_flags)
 {
 	osm_log_set_level(&p_osm->log, log_flags);
 }
@@ -395,8 +393,7 @@ osm_opensm_set_log_flags(IN osm_opensm_t * const p_osm,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_opensm_bind(IN osm_opensm_t * const p_osm, IN const ib_net64_t guid);
+ib_api_status_t osm_opensm_bind(IN osm_opensm_t * p_osm, IN ib_net64_t guid);
 /*
 * PARAMETERS
 *	p_osm
@@ -424,11 +421,10 @@ osm_opensm_bind(IN osm_opensm_t * const p_osm, IN const ib_net64_t guid);
 * SYNOPSIS
 */
 static inline cl_status_t
-osm_opensm_wait_for_subnet_up(IN osm_opensm_t * const p_osm,
-			      IN uint32_t const wait_us,
-			      IN boolean_t const interruptible)
+osm_opensm_wait_for_subnet_up(IN osm_opensm_t * p_osm, IN uint32_t wait_us,
+			      IN boolean_t interruptible)
 {
-	return (osm_sm_wait_for_subnet_up(&p_osm->sm, wait_us, interruptible));
+	return osm_sm_wait_for_subnet_up(&p_osm->sm, wait_us, interruptible);
 }
 
 /*
diff --git a/opensm/include/opensm/osm_partition.h b/opensm/include/opensm/osm_partition.h
index 38acdc9..690953d 100644
--- a/opensm/include/opensm/osm_partition.h
+++ b/opensm/include/opensm/osm_partition.h
@@ -138,7 +138,7 @@ typedef struct osm_prtn {
 *
 * SYNOPSIS
 */
-void osm_prtn_delete(IN OUT osm_prtn_t ** const pp_prtn);
+void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn);
 /*
 * PARAMETERS
 *	pp_prtn
@@ -164,7 +164,7 @@ void osm_prtn_delete(IN OUT osm_prtn_t ** const pp_prtn);
 *
 * SYNOPSIS
 */
-osm_prtn_t *osm_prtn_new(IN const char *name, IN const uint16_t pkey);
+osm_prtn_t *osm_prtn_new(IN const char *name, IN uint16_t pkey);
 /*
 * PARAMETERS
 *	name
@@ -192,8 +192,8 @@ osm_prtn_t *osm_prtn_new(IN const char *name, IN const uint16_t pkey);
 *
 * SYNOPSIS
 */
-static inline boolean_t osm_prtn_is_guid(IN const osm_prtn_t * const p_prtn,
-					 IN const ib_net64_t guid)
+static inline boolean_t osm_prtn_is_guid(IN const osm_prtn_t * p_prtn,
+					 IN ib_net64_t guid)
 {
 	return (cl_map_get(&p_prtn->full_guid_tbl, guid) != NULL) ||
 	    (cl_map_get(&p_prtn->part_guid_tbl, guid) != NULL);
@@ -225,8 +225,8 @@ static inline boolean_t osm_prtn_is_guid(IN const osm_prtn_t * const p_prtn,
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_prtn_make_partitions(IN osm_log_t * const p_log,
-					 IN osm_subn_t * const p_subn);
+ib_api_status_t osm_prtn_make_partitions(IN osm_log_t * p_log,
+					 IN osm_subn_t * p_subn);
 /*
 * PARAMETERS
 *	p_log
diff --git a/opensm/include/opensm/osm_path.h b/opensm/include/opensm/osm_path.h
index da55aa8..0418d19 100644
--- a/opensm/include/opensm/osm_path.h
+++ b/opensm/include/opensm/osm_path.h
@@ -107,7 +107,7 @@ typedef struct osm_dr_path {
 *
 * SYNOPSIS
 */
-static inline void osm_dr_path_construct(IN osm_dr_path_t * const p_path)
+static inline void osm_dr_path_construct(IN osm_dr_path_t * p_path)
 {
 	/* The first location in the path array is reserved. */
 	memset(p_path, 0, sizeof(*p_path));
@@ -146,9 +146,8 @@ static inline void osm_dr_path_construct(IN osm_dr_path_t * const p_path)
 * SYNOPSIS
 */
 static inline void
-osm_dr_path_init(IN osm_dr_path_t * const p_path,
-		 IN const osm_bind_handle_t h_bind,
-		 IN const uint8_t hop_count,
+osm_dr_path_init(IN osm_dr_path_t * p_path, IN osm_bind_handle_t h_bind,
+		 IN uint8_t hop_count,
 		 IN const uint8_t path[IB_SUBNET_PATH_HOPS_MAX])
 {
 	/* The first location in the path array is reserved. */
@@ -189,8 +188,8 @@ osm_dr_path_init(IN osm_dr_path_t * const p_path,
 *
 * SYNOPSIS
 */
-static inline int
-osm_dr_path_extend(IN osm_dr_path_t * const p_path, IN const uint8_t port_num)
+static inline int osm_dr_path_extend(IN osm_dr_path_t * p_path,
+				     IN uint8_t port_num)
 {
 	p_path->hop_count++;
 
@@ -230,9 +229,9 @@ osm_dr_path_extend(IN osm_dr_path_t * const p_path, IN const uint8_t port_num)
 * SYNOPSIS
 */
 static inline osm_bind_handle_t
-osm_dr_path_get_bind_handle(IN const osm_dr_path_t * const p_path)
+osm_dr_path_get_bind_handle(IN const osm_dr_path_t * p_path)
 {
-	return (p_path->h_bind);
+	return p_path->h_bind;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_perfmgr.h b/opensm/include/opensm/osm_perfmgr.h
index 855a2ff..852f5d1 100644
--- a/opensm/include/opensm/osm_perfmgr.h
+++ b/opensm/include/opensm/osm_perfmgr.h
@@ -152,8 +152,8 @@ typedef struct osm_perfmgr {
 *********/
 
 /****f* OpenSM: Creation Functions */
-void osm_perfmgr_shutdown(osm_perfmgr_t * const p_perfmgr);
-void osm_perfmgr_destroy(osm_perfmgr_t * const p_perfmgr);
+void osm_perfmgr_shutdown(osm_perfmgr_t * p_perfmgr);
+void osm_perfmgr_destroy(osm_perfmgr_t * p_perfmgr);
 
 /****f* OpenSM: Inline accessor functions */
 inline static void osm_perfmgr_set_state(osm_perfmgr_t * p_perfmgr,
@@ -164,42 +164,41 @@ inline static void osm_perfmgr_set_state(osm_perfmgr_t * p_perfmgr,
 		osm_sm_signal(p_perfmgr->sm, OSM_SIGNAL_PERFMGR_SWEEP);
 }
 
-inline static osm_perfmgr_state_t osm_perfmgr_get_state(osm_perfmgr_t
-							  * p_perfmgr)
+inline static osm_perfmgr_state_t osm_perfmgr_get_state(osm_perfmgr_t * perfmgr)
 {
-	return (p_perfmgr->state);
+	return perfmgr->state;
 }
 
 inline static char *osm_perfmgr_get_state_str(osm_perfmgr_t * p_perfmgr)
 {
 	switch (p_perfmgr->state) {
 	case PERFMGR_STATE_DISABLE:
-		return ("Disabled");
+		return "Disabled";
 		break;
 	case PERFMGR_STATE_ENABLED:
-		return ("Enabled");
+		return "Enabled";
 		break;
 	case PERFMGR_STATE_NO_DB:
-		return ("No Database");
+		return "No Database";
 		break;
 	}
-	return ("UNKNOWN");
+	return "UNKNOWN";
 }
 
 inline static char *osm_perfmgr_get_sweep_state_str(osm_perfmgr_t * perfmgr)
 {
 	switch (perfmgr->sweep_state) {
 	case PERFMGR_SWEEP_SLEEP:
-		return ("Sleeping");
+		return "Sleeping";
 		break;
 	case PERFMGR_SWEEP_ACTIVE:
-		return ("Active");
+		return "Active";
 		break;
 	case PERFMGR_SWEEP_SUSPENDED:
-		return ("Suspended");
+		return "Suspended";
 		break;
 	}
-	return ("UNKNOWN");
+	return "UNKNOWN";
 }
 
 inline static void osm_perfmgr_set_sweep_time_s(osm_perfmgr_t * p_perfmgr,
@@ -211,24 +210,23 @@ inline static void osm_perfmgr_set_sweep_time_s(osm_perfmgr_t * p_perfmgr,
 
 inline static uint16_t osm_perfmgr_get_sweep_time_s(osm_perfmgr_t * p_perfmgr)
 {
-	return (p_perfmgr->sweep_time_s);
+	return p_perfmgr->sweep_time_s;
 }
 
 void osm_perfmgr_clear_counters(osm_perfmgr_t * p_perfmgr);
 void osm_perfmgr_dump_counters(osm_perfmgr_t * p_perfmgr,
 			       perfmgr_db_dump_t dump_type);
-void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename,
-				FILE *fp);
+void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename, FILE *fp);
 
-ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * const p_perfmgr,
-				 const ib_net64_t port_guid);
+ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * p_perfmgr,
+				 ib_net64_t port_guid);
 
 void osm_perfmgr_process(osm_perfmgr_t * pm);
 
 /****f* OpenSM: PerfMgr/osm_perfmgr_init */
-ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * const perfmgr,
+ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * perfmgr,
 				 struct osm_opensm *osm,
-				 const osm_subn_opt_t * const p_opt);
+				 const osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *	perfmgr
diff --git a/opensm/include/opensm/osm_pkey.h b/opensm/include/opensm/osm_pkey.h
index d20b495..6d94852 100644
--- a/opensm/include/opensm/osm_pkey.h
+++ b/opensm/include/opensm/osm_pkey.h
@@ -439,9 +439,9 @@ osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 *
 * SYNOPSIS
 */
-boolean_t osm_physp_share_this_pkey(IN const struct osm_physp *const p_physp1,
-				    IN const struct osm_physp *const p_physp2,
-				    IN const ib_net16_t pkey);
+boolean_t osm_physp_share_this_pkey(IN const struct osm_physp * p_physp1,
+				    IN const struct osm_physp * p_physp2,
+				    IN ib_net16_t pkey);
 /*
 * PARAMETERS
 *
@@ -471,10 +471,8 @@ boolean_t osm_physp_share_this_pkey(IN const struct osm_physp *const p_physp1,
 *
 * SYNOPSIS
 */
-ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *const
-				      p_physp1,
-				      IN const struct osm_physp *const
-				      p_physp2);
+ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *p_physp1,
+				      IN const struct osm_physp *p_physp2);
 /*
 * PARAMETERS
 *
@@ -517,8 +515,8 @@ ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *const
 * SYNOPSIS
 */
 boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
-			       IN const struct osm_physp *const p_physp_1,
-			       IN const struct osm_physp *const p_physp_2);
+			       IN const struct osm_physp * p_physp_1,
+			       IN const struct osm_physp * p_physp_2);
 
 /*
 * PARAMETERS
@@ -564,8 +562,8 @@ boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 * SYNOPSIS
 */
 boolean_t osm_port_share_pkey(IN osm_log_t * p_log,
-			      IN const struct osm_port *const p_port_1,
-			      IN const struct osm_port *const p_port_2);
+			      IN const struct osm_port * p_port_1,
+			      IN const struct osm_port * p_port_2);
 
 /*
 * PARAMETERS
@@ -610,9 +608,8 @@ boolean_t osm_port_share_pkey(IN osm_log_t * p_log,
 *
 * SYNOPSIS
 */
-boolean_t osm_physp_has_pkey(IN osm_log_t * p_log,
-			     IN const ib_net16_t pkey,
-			     IN const struct osm_physp *const p_physp);
+boolean_t osm_physp_has_pkey(IN osm_log_t * p_log, IN ib_net16_t pkey,
+			     IN const struct osm_physp *p_physp);
 
 /*
 * PARAMETERS
diff --git a/opensm/include/opensm/osm_port.h b/opensm/include/opensm/osm_port.h
index eb77ed9..912fb05 100644
--- a/opensm/include/opensm/osm_port.h
+++ b/opensm/include/opensm/osm_port.h
@@ -189,7 +189,7 @@ typedef struct osm_physp {
 *
 * SYNOPSIS
 */
-void osm_physp_construct(IN osm_physp_t * const p_physp);
+void osm_physp_construct(IN osm_physp_t * p_physp);
 /*
 * PARAMETERS
 *	p_physp
@@ -213,14 +213,10 @@ void osm_physp_construct(IN osm_physp_t * const p_physp);
 *
 * SYNOPSIS
 */
-void
-osm_physp_init(IN osm_physp_t * const p_physp,
-	       IN const ib_net64_t port_guid,
-	       IN const uint8_t port_num,
-	       IN const struct osm_node *const p_node,
-	       IN const osm_bind_handle_t h_bind,
-	       IN const uint8_t hop_count,
-	       IN const uint8_t * const p_initial_path);
+void osm_physp_init(IN osm_physp_t * p_physp, IN ib_net64_t port_guid,
+		    IN uint8_t port_num, IN const struct osm_node *p_node,
+		    IN osm_bind_handle_t h_bind, IN uint8_t hop_count,
+		    IN const uint8_t * p_initial_path);
 /*
 * PARAMETERS
 *	p_physp
@@ -268,7 +264,7 @@ osm_physp_init(IN osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-void osm_physp_destroy(IN osm_physp_t * const p_physp);
+void osm_physp_destroy(IN osm_physp_t * p_physp);
 /*
 * PARAMETERS
 *	p_port
@@ -297,7 +293,7 @@ void osm_physp_destroy(IN osm_physp_t * const p_physp);
 *
 * SYNOPSIS
 */
-static inline boolean_t osm_physp_is_valid(IN const osm_physp_t * const p_physp)
+static inline boolean_t osm_physp_is_valid(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	return (p_physp->port_guid != 0);
@@ -328,11 +324,10 @@ static inline boolean_t osm_physp_is_valid(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_physp_is_healthy(IN const osm_physp_t * const p_physp)
+static inline boolean_t osm_physp_is_healthy(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
-	return (p_physp->healthy);
+	return p_physp->healthy;
 }
 
 /*
@@ -363,7 +358,7 @@ osm_physp_is_healthy(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-boolean_t osm_link_is_healthy(IN const osm_physp_t * const p_physp);
+boolean_t osm_link_is_healthy(IN const osm_physp_t * p_physp);
 /*
 * PARAMETERS
 *	p_physp
@@ -390,8 +385,8 @@ boolean_t osm_link_is_healthy(IN const osm_physp_t * const p_physp);
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_set_health(IN osm_physp_t * const p_physp, IN boolean_t is_healthy)
+static inline void osm_physp_set_health(IN osm_physp_t * p_physp,
+					IN boolean_t is_healthy)
 {
 	CL_ASSERT(p_physp);
 	p_physp->healthy = is_healthy;
@@ -426,9 +421,8 @@ osm_physp_set_health(IN osm_physp_t * const p_physp, IN boolean_t is_healthy)
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_set_port_info(IN osm_physp_t * const p_physp,
-			IN const ib_port_info_t * const p_pi)
+static inline void osm_physp_set_port_info(IN osm_physp_t * p_physp,
+					   IN const ib_port_info_t * p_pi)
 {
 	CL_ASSERT(p_pi);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
@@ -440,9 +434,8 @@ osm_physp_set_port_info(IN osm_physp_t * const p_physp,
 		ib_port_info_set_port_phys_state
 		    (ib_port_info_get_port_phys_state(p_pi),
 		     &p_physp->port_info);
-	} else {
+	} else
 		p_physp->port_info = *p_pi;
-	}
 }
 
 /*
@@ -471,11 +464,10 @@ osm_physp_set_port_info(IN osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-void
-osm_physp_set_pkey_tbl(IN osm_log_t * p_log,
-		       IN const osm_subn_t * p_subn,
-		       IN osm_physp_t * const p_physp,
-		       IN ib_pkey_table_t * p_pkey_tbl, IN uint16_t block_num);
+void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
+			    IN osm_physp_t * p_physp,
+			    IN ib_pkey_table_t * p_pkey_tbl,
+			    IN uint16_t block_num);
 /*
 * PARAMETERS
 *	p_log
@@ -515,7 +507,7 @@ osm_physp_set_pkey_tbl(IN osm_log_t * p_log,
 * SYNOPSIS
 */
 static inline const osm_pkey_tbl_t *osm_physp_get_pkey_tbl(IN const osm_physp_t
-							   * const p_physp)
+							   * p_physp)
 {
 	CL_ASSERT(osm_physp_is_valid(p_physp));
 	/*
@@ -523,7 +515,7 @@ static inline const osm_pkey_tbl_t *osm_physp_get_pkey_tbl(IN const osm_physp_t
 	   further limited by the size of the P_Key table specified by the
 	   PartitionCap on the node.
 	 */
-	return (&p_physp->pkeys);
+	return &p_physp->pkeys;
 };
 
 /*
@@ -549,9 +541,9 @@ static inline const osm_pkey_tbl_t *osm_physp_get_pkey_tbl(IN const osm_physp_t
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_set_slvl_tbl(IN osm_physp_t * const p_physp,
-		       IN ib_slvl_table_t * p_slvl_tbl, IN uint8_t in_port_num)
+static inline void osm_physp_set_slvl_tbl(IN osm_physp_t * p_physp,
+					  IN ib_slvl_table_t * p_slvl_tbl,
+					  IN uint8_t in_port_num)
 {
 	ib_slvl_table_t *p_tbl;
 
@@ -592,14 +584,14 @@ osm_physp_set_slvl_tbl(IN osm_physp_t * const p_physp,
 * SYNOPSIS
 */
 static inline ib_slvl_table_t *osm_physp_get_slvl_tbl(IN const osm_physp_t *
-						      const p_physp,
+						      p_physp,
 						      IN uint8_t in_port_num)
 {
 	ib_slvl_table_t *p_tbl;
 
 	CL_ASSERT(osm_physp_is_valid(p_physp));
 	p_tbl = cl_ptr_vector_get(&p_physp->slvl_by_port, in_port_num);
-	return (p_tbl);
+	return p_tbl;
 }
 
 /*
@@ -628,9 +620,9 @@ static inline ib_slvl_table_t *osm_physp_get_slvl_tbl(IN const osm_physp_t *
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_set_vla_tbl(IN osm_physp_t * const p_physp,
-		      IN ib_vl_arb_table_t * p_vla_tbl, IN uint8_t block_num)
+static inline void osm_physp_set_vla_tbl(IN osm_physp_t * p_physp,
+					 IN ib_vl_arb_table_t * p_vla_tbl,
+					 IN uint8_t block_num)
 {
 	CL_ASSERT(p_vla_tbl);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
@@ -669,13 +661,12 @@ osm_physp_set_vla_tbl(IN osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-static inline ib_vl_arb_table_t *osm_physp_get_vla_tbl(IN osm_physp_t *
-						       const p_physp,
+static inline ib_vl_arb_table_t *osm_physp_get_vla_tbl(IN osm_physp_t * p_physp,
 						       IN uint8_t block_num)
 {
 	CL_ASSERT(osm_physp_is_valid(p_physp));
 	CL_ASSERT((1 <= block_num) && (block_num <= 4));
-	return (&(p_physp->vl_arb[block_num - 1]));
+	return &(p_physp->vl_arb[block_num - 1]);
 }
 
 /*
@@ -705,11 +696,10 @@ static inline ib_vl_arb_table_t *osm_physp_get_vla_tbl(IN osm_physp_t *
 *
 * SYNOPSIS
 */
-static inline osm_physp_t *osm_physp_get_remote(IN const osm_physp_t *
-						const p_physp)
+static inline osm_physp_t *osm_physp_get_remote(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (p_physp->p_remote_physp);
+	return p_physp->p_remote_physp;
 }
 
 /*
@@ -736,11 +726,10 @@ static inline osm_physp_t *osm_physp_get_remote(IN const osm_physp_t *
 *
 * SYNOPSIS
 */
-static inline ib_net64_t
-osm_physp_get_port_guid(IN const osm_physp_t * const p_physp)
+static inline ib_net64_t osm_physp_get_port_guid(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (p_physp->port_guid);
+	return p_physp->port_guid;
 }
 
 /*
@@ -767,10 +756,10 @@ osm_physp_get_port_guid(IN const osm_physp_t * const p_physp)
 * SYNOPSIS
 */
 static inline ib_net64_t
-osm_physp_get_subnet_prefix(IN const osm_physp_t * const p_physp)
+osm_physp_get_subnet_prefix(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (p_physp->port_info.subnet_prefix);
+	return p_physp->port_info.subnet_prefix;
 }
 
 /*
@@ -797,9 +786,8 @@ osm_physp_get_subnet_prefix(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_physp_link_exists(IN const osm_physp_t * const p_physp,
-		      IN const osm_physp_t * const p_remote_physp)
+static inline boolean_t osm_physp_link_exists(IN const osm_physp_t * p_physp,
+					      IN const osm_physp_t * p_remote_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
@@ -836,9 +824,8 @@ osm_physp_link_exists(IN const osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_link(IN osm_physp_t * const p_physp,
-	       IN osm_physp_t * const p_remote_physp)
+static inline void osm_physp_link(IN osm_physp_t * p_physp,
+				  IN osm_physp_t * p_remote_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(p_remote_physp);
@@ -872,9 +859,8 @@ osm_physp_link(IN osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-static inline void
-osm_physp_unlink(IN osm_physp_t * const p_physp,
-		 IN osm_physp_t * const p_remote_physp)
+static inline void osm_physp_unlink(IN osm_physp_t * p_physp,
+				    IN osm_physp_t * p_remote_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(p_remote_physp);
@@ -910,14 +896,13 @@ osm_physp_unlink(IN osm_physp_t * const p_physp,
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_physp_has_any_link(IN const osm_physp_t * const p_physp)
+static inline boolean_t osm_physp_has_any_link(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	if (osm_physp_is_valid(p_physp))
 		return (p_physp->p_remote_physp != NULL);
 	else
-		return (FALSE);
+		return FALSE;
 }
 
 /*
@@ -944,12 +929,11 @@ osm_physp_has_any_link(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_physp_get_port_num(IN const osm_physp_t * const p_physp)
+static inline uint8_t osm_physp_get_port_num(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (p_physp->port_num);
+	return p_physp->port_num;
 }
 
 /*
@@ -975,11 +959,11 @@ osm_physp_get_port_num(IN const osm_physp_t * const p_physp)
 * SYNOPSIS
 */
 static inline struct osm_node *osm_physp_get_node_ptr(IN const osm_physp_t *
-						       const p_physp)
+						       p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return ((struct osm_node *)p_physp->p_node);
+	return p_physp->p_node;
 }
 
 /*
@@ -1004,12 +988,11 @@ static inline struct osm_node *osm_physp_get_node_ptr(IN const osm_physp_t *
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_physp_get_port_state(IN const osm_physp_t * const p_physp)
+static inline uint8_t osm_physp_get_port_state(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (ib_port_info_get_port_state(&p_physp->port_info));
+	return ib_port_info_get_port_state(&p_physp->port_info);
 }
 
 /*
@@ -1034,12 +1017,11 @@ osm_physp_get_port_state(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-static inline ib_net16_t
-osm_physp_get_base_lid(IN const osm_physp_t * const p_physp)
+static inline ib_net16_t osm_physp_get_base_lid(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (p_physp->port_info.base_lid);
+	return p_physp->port_info.base_lid;
 }
 
 /*
@@ -1064,11 +1046,11 @@ osm_physp_get_base_lid(IN const osm_physp_t * const p_physp)
 *
 * SYNOPSIS
 */
-static inline uint8_t osm_physp_get_lmc(IN const osm_physp_t * const p_physp)
+static inline uint8_t osm_physp_get_lmc(IN const osm_physp_t * p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return (ib_port_info_get_lmc(&p_physp->port_info));
+	return ib_port_info_get_lmc(&p_physp->port_info);
 }
 
 /*
@@ -1094,11 +1076,11 @@ static inline uint8_t osm_physp_get_lmc(IN const osm_physp_t * const p_physp)
 * SYNOPSIS
 */
 static inline osm_dr_path_t *osm_physp_get_dr_path_ptr(IN const osm_physp_t *
-						       const p_physp)
+							p_physp)
 {
 	CL_ASSERT(p_physp);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
-	return ((osm_dr_path_t *) & p_physp->dr_path);
+	return (osm_dr_path_t *) & p_physp->dr_path;
 }
 
 /*
@@ -1207,7 +1189,7 @@ typedef struct osm_port {
 *
 * SYNOPSIS
 */
-void osm_port_delete(IN OUT osm_port_t ** const pp_port);
+void osm_port_delete(IN OUT osm_port_t ** pp_port);
 /*
 * PARAMETERS
 *	pp_port
@@ -1234,7 +1216,7 @@ void osm_port_delete(IN OUT osm_port_t ** const pp_port);
 * SYNOPSIS
 */
 osm_port_t *osm_port_new(IN const ib_node_info_t * p_ni,
-			 IN struct osm_node *const p_parent_node);
+			 IN struct osm_node *p_parent_node);
 /*
 * PARAMETERS
 *	p_ni
@@ -1263,11 +1245,10 @@ osm_port_t *osm_port_new(IN const ib_node_info_t * p_ni,
 *
 * SYNOPSIS
 */
-static inline ib_net16_t
-osm_port_get_base_lid(IN const osm_port_t * const p_port)
+static inline ib_net16_t osm_port_get_base_lid(IN const osm_port_t * p_port)
 {
 	CL_ASSERT(p_port->p_physp && osm_physp_is_valid(p_port->p_physp));
-	return (osm_physp_get_base_lid(p_port->p_physp));
+	return osm_physp_get_base_lid(p_port->p_physp);
 }
 
 /*
@@ -1294,10 +1275,10 @@ osm_port_get_base_lid(IN const osm_port_t * const p_port)
 *
 * SYNOPSIS
 */
-static inline uint8_t osm_port_get_lmc(IN const osm_port_t * const p_port)
+static inline uint8_t osm_port_get_lmc(IN const osm_port_t * p_port)
 {
 	CL_ASSERT(p_port->p_physp && osm_physp_is_valid(p_port->p_physp));
-	return (osm_physp_get_lmc(p_port->p_physp));
+	return osm_physp_get_lmc(p_port->p_physp);
 }
 
 /*
@@ -1323,9 +1304,9 @@ static inline uint8_t osm_port_get_lmc(IN const osm_port_t * const p_port)
 *
 * SYNOPSIS
 */
-static inline ib_net64_t osm_port_get_guid(IN const osm_port_t * const p_port)
+static inline ib_net64_t osm_port_get_guid(IN const osm_port_t * p_port)
 {
-	return (p_port->guid);
+	return p_port->guid;
 }
 
 /*
@@ -1352,10 +1333,9 @@ static inline ib_net64_t osm_port_get_guid(IN const osm_port_t * const p_port)
 *
 * SYNOPSIS
 */
-void
-osm_port_get_lid_range_ho(IN const osm_port_t * const p_port,
-			  OUT uint16_t * const p_min_lid,
-			  OUT uint16_t * const p_max_lid);
+void osm_port_get_lid_range_ho(IN const osm_port_t * p_port,
+			       OUT uint16_t * p_min_lid,
+			       OUT uint16_t * p_max_lid);
 /*
 * PARAMETERS
 *	p_port
@@ -1386,8 +1366,8 @@ osm_port_get_lid_range_ho(IN const osm_port_t * const p_port,
 *
 * SYNOPSIS
 */
-uint8_t
-osm_physp_calc_link_mtu(IN osm_log_t * p_log, IN const osm_physp_t * p_physp);
+uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
+				IN const osm_physp_t * p_physp);
 /*
 * PARAMETERS
 *	p_log
@@ -1415,10 +1395,9 @@ osm_physp_calc_link_mtu(IN osm_log_t * p_log, IN const osm_physp_t * p_physp);
 *
 * SYNOPSIS
 */
-uint8_t
-osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
-			   IN const osm_subn_t * p_subn,
-			   IN const osm_physp_t * p_physp);
+uint8_t osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
+				   IN const osm_subn_t * p_subn,
+				   IN const osm_physp_t * p_physp);
 /*
 * PARAMETERS
 *	p_log
diff --git a/opensm/include/opensm/osm_port_profile.h b/opensm/include/opensm/osm_port_profile.h
index fd22719..80de53e 100644
--- a/opensm/include/opensm/osm_port_profile.h
+++ b/opensm/include/opensm/osm_port_profile.h
@@ -129,7 +129,7 @@ typedef long osm_port_mask_t[32 / sizeof(long)];
 *
 * SYNOPSIS
 */
-static inline void osm_port_prof_construct(IN osm_port_profile_t * const p_prof)
+static inline void osm_port_prof_construct(IN osm_port_profile_t * p_prof)
 {
 	CL_ASSERT(p_prof);
 	memset(p_prof, 0, sizeof(*p_prof));
@@ -157,8 +157,7 @@ static inline void osm_port_prof_construct(IN osm_port_profile_t * const p_prof)
 *
 * SYNOPSIS
 */
-static inline void
-osm_port_prof_path_count_inc(IN osm_port_profile_t * const p_prof)
+static inline void osm_port_prof_path_count_inc(IN osm_port_profile_t * p_prof)
 {
 	CL_ASSERT(p_prof);
 	p_prof->num_paths++;
@@ -186,9 +185,9 @@ osm_port_prof_path_count_inc(IN osm_port_profile_t * const p_prof)
 * SYNOPSIS
 */
 static inline uint32_t
-osm_port_prof_path_count_get(IN const osm_port_profile_t * const p_prof)
+osm_port_prof_path_count_get(IN const osm_port_profile_t * p_prof)
 {
-	return (p_prof->num_paths);
+	return p_prof->num_paths;
 }
 /*
 * PARAMETERS
diff --git a/opensm/include/opensm/osm_qos_policy.h b/opensm/include/opensm/osm_qos_policy.h
index c38624b..1d270ca 100644
--- a/opensm/include/opensm/osm_qos_policy.h
+++ b/opensm/include/opensm/osm_qos_policy.h
@@ -197,7 +197,7 @@ osm_qos_level_t * osm_qos_policy_get_qos_level_by_mpr(
 
 /***************************************************/
 
-int osm_qos_parse_policy_file(IN osm_subn_t * const p_subn);
+int osm_qos_parse_policy_file(IN osm_subn_t * p_subn);
 
 /***************************************************/
 
diff --git a/opensm/include/opensm/osm_remote_sm.h b/opensm/include/opensm/osm_remote_sm.h
index 4cc980b..684b76c 100644
--- a/opensm/include/opensm/osm_remote_sm.h
+++ b/opensm/include/opensm/osm_remote_sm.h
@@ -112,7 +112,7 @@ typedef struct osm_remote_sm {
 *
 * SYNOPSIS
 */
-void osm_remote_sm_construct(IN osm_remote_sm_t * const p_sm);
+void osm_remote_sm_construct(IN osm_remote_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -141,7 +141,7 @@ void osm_remote_sm_construct(IN osm_remote_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-void osm_remote_sm_destroy(IN osm_remote_sm_t * const p_sm);
+void osm_remote_sm_destroy(IN osm_remote_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -169,10 +169,8 @@ void osm_remote_sm_destroy(IN osm_remote_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-void
-osm_remote_sm_init(IN osm_remote_sm_t * const p_sm,
-		   IN const osm_port_t * const p_port,
-		   IN const ib_sm_info_t * const p_smi);
+void osm_remote_sm_init(IN osm_remote_sm_t * p_sm, IN const osm_port_t * p_port,
+			IN const ib_sm_info_t * p_smi);
 /*
 * PARAMETERS
 *	p_sm
diff --git a/opensm/include/opensm/osm_router.h b/opensm/include/opensm/osm_router.h
index 4901aca..7d455f6 100644
--- a/opensm/include/opensm/osm_router.h
+++ b/opensm/include/opensm/osm_router.h
@@ -116,7 +116,7 @@ typedef struct osm_router {
 *
 * SYNOPSIS
 */
-void osm_router_delete(IN OUT osm_router_t ** const pp_rtr);
+void osm_router_delete(IN OUT osm_router_t ** pp_rtr);
 /*
 * PARAMETERS
 *	p_rtr
@@ -140,7 +140,7 @@ void osm_router_delete(IN OUT osm_router_t ** const pp_rtr);
 *
 * SYNOPSIS
 */
-osm_router_t *osm_router_new(IN osm_port_t * const p_port);
+osm_router_t *osm_router_new(IN osm_port_t * p_port);
 /*
 * PARAMETERS
 *	p_node
@@ -164,10 +164,9 @@ osm_router_t *osm_router_new(IN osm_port_t * const p_port);
 *
 * SYNOPSIS
 */
-static inline osm_port_t *osm_router_get_port_ptr(IN const osm_router_t *
-						  const p_rtr)
+static inline osm_port_t *osm_router_get_port_ptr(IN const osm_router_t * p_rtr)
 {
-	return (p_rtr->p_port);
+	return p_rtr->p_port;
 }
 
 /*
@@ -193,10 +192,9 @@ static inline osm_port_t *osm_router_get_port_ptr(IN const osm_router_t *
 *
 * SYNOPSIS
 */
-static inline osm_node_t *osm_router_get_node_ptr(IN const osm_router_t *
-						  const p_rtr)
+static inline osm_node_t *osm_router_get_node_ptr(IN const osm_router_t * p_rtr)
 {
-	return (p_rtr->p_port->p_node);
+	return p_rtr->p_port->p_node;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index 5a0ae9f..71b5e5b 100644
--- a/opensm/include/opensm/osm_sa.h
+++ b/opensm/include/opensm/osm_sa.h
@@ -191,7 +191,7 @@ typedef struct osm_sa {
 *
 * SYNOPSIS
 */
-void osm_sa_construct(IN osm_sa_t * const p_sa);
+void osm_sa_construct(IN osm_sa_t * p_sa);
 /*
 * PARAMETERS
 *	p_sa
@@ -220,7 +220,7 @@ void osm_sa_construct(IN osm_sa_t * const p_sa);
 *
 * SYNOPSIS
 */
-void osm_sa_shutdown(IN osm_sa_t * const p_sa);
+void osm_sa_shutdown(IN osm_sa_t * p_sa);
 /*
 * PARAMETERS
 *	p_sa
@@ -243,7 +243,7 @@ void osm_sa_shutdown(IN osm_sa_t * const p_sa);
 *
 * SYNOPSIS
 */
-void osm_sa_destroy(IN osm_sa_t * const p_sa);
+void osm_sa_destroy(IN osm_sa_t * p_sa);
 /*
 * PARAMETERS
 *	p_sa
@@ -271,15 +271,12 @@ void osm_sa_destroy(IN osm_sa_t * const p_sa);
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_sa_init(IN osm_sm_t * const p_sm,
-			    IN osm_sa_t * const p_sa,
-			    IN osm_subn_t * const p_subn,
-			    IN osm_vendor_t * const p_vendor,
-			    IN osm_mad_pool_t * const p_mad_pool,
-			    IN osm_log_t * const p_log,
-			    IN osm_stats_t * const p_stats,
-			    IN cl_dispatcher_t * const p_disp,
-			    IN cl_plock_t * const p_lock);
+ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
+			    IN osm_subn_t * p_subn, IN osm_vendor_t * p_vendor,
+			    IN osm_mad_pool_t * p_mad_pool,
+			    IN osm_log_t * p_log, IN osm_stats_t * p_stats,
+			    IN cl_dispatcher_t * p_disp,
+			    IN cl_plock_t * p_lock);
 /*
 * PARAMETERS
 *	p_sa
@@ -325,8 +322,7 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * const p_sm,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sa_bind(IN osm_sa_t * const p_sa, IN const ib_net64_t port_guid);
+ib_api_status_t osm_sa_bind(IN osm_sa_t * p_sa, IN ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_sa
@@ -354,8 +350,8 @@ osm_sa_bind(IN osm_sa_t * const p_sa, IN const ib_net64_t port_guid);
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_sa_send(osm_sa_t *sa, IN osm_madw_t * const p_madw,
-			    IN boolean_t const resp_expected);
+ib_api_status_t osm_sa_send(osm_sa_t *sa, IN osm_madw_t * p_madw,
+			    IN boolean_t resp_expected);
 
 /****f* IBA Base: Types/osm_sa_send_error
 * NAME
@@ -367,8 +363,8 @@ ib_api_status_t osm_sa_send(osm_sa_t *sa, IN osm_madw_t * const p_madw,
 *
 * SYNOPSIS
 */
-void osm_sa_send_error(IN osm_sa_t * sa, IN const osm_madw_t * const p_madw,
-		       IN const ib_net16_t sa_status);
+void osm_sa_send_error(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
+		       IN ib_net16_t sa_status);
 /*
 * PARAMETERS
 *	sa
@@ -470,10 +466,8 @@ int osm_sa_db_file_load(struct osm_opensm *p_osm);
 */
 
 ib_api_status_t
-osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
-				     IN uint64_t comp_mask,
-				     IN ib_member_rec_t *
-				     const p_recvd_mcmember_rec,
+osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa, IN ib_net64_t comp_mask,
+				     IN ib_member_rec_t * p_recvd_mcmember_rec,
 				     OUT osm_mgrp_t ** pp_mgrp);
 /*
 * PARAMETERS
diff --git a/opensm/include/opensm/osm_sa_mad_ctrl.h b/opensm/include/opensm/osm_sa_mad_ctrl.h
index cc2ac53..8c2ed25 100644
--- a/opensm/include/opensm/osm_sa_mad_ctrl.h
+++ b/opensm/include/opensm/osm_sa_mad_ctrl.h
@@ -142,7 +142,7 @@ typedef struct osm_sa_mad_ctrl {
 *
 * SYNOPSIS
 */
-void osm_sa_mad_ctrl_construct(IN osm_sa_mad_ctrl_t * const p_ctrl);
+void osm_sa_mad_ctrl_construct(IN osm_sa_mad_ctrl_t * p_ctrl);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -173,7 +173,7 @@ void osm_sa_mad_ctrl_construct(IN osm_sa_mad_ctrl_t * const p_ctrl);
 *
 * SYNOPSIS
 */
-void osm_sa_mad_ctrl_destroy(IN osm_sa_mad_ctrl_t * const p_ctrl);
+void osm_sa_mad_ctrl_destroy(IN osm_sa_mad_ctrl_t * p_ctrl);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -204,14 +204,14 @@ void osm_sa_mad_ctrl_destroy(IN osm_sa_mad_ctrl_t * const p_ctrl);
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * const p_ctrl,
+ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 				     IN struct osm_sa * sa,
-				     IN osm_mad_pool_t * const p_mad_pool,
-				     IN osm_vendor_t * const p_vendor,
-				     IN osm_subn_t * const p_subn,
-				     IN osm_log_t * const p_log,
-				     IN osm_stats_t * const p_stats,
-				     IN cl_dispatcher_t * const p_disp);
+				     IN osm_mad_pool_t * p_mad_pool,
+				     IN osm_vendor_t * p_vendor,
+				     IN osm_subn_t * p_subn,
+				     IN osm_log_t * p_log,
+				     IN osm_stats_t * p_stats,
+				     IN cl_dispatcher_t * p_disp);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -256,9 +256,8 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * const p_ctrl,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sa_mad_ctrl_bind(IN osm_sa_mad_ctrl_t * const p_ctrl,
-		     IN const ib_net64_t port_guid);
+ib_api_status_t osm_sa_mad_ctrl_bind(IN osm_sa_mad_ctrl_t * p_ctrl,
+				     IN ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -287,7 +286,7 @@ osm_sa_mad_ctrl_bind(IN osm_sa_mad_ctrl_t * const p_ctrl,
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_sa_mad_ctrl_unbind(IN osm_sa_mad_ctrl_t * const p_ctrl);
+ib_api_status_t osm_sa_mad_ctrl_unbind(IN osm_sa_mad_ctrl_t * p_ctrl);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -313,9 +312,9 @@ ib_api_status_t osm_sa_mad_ctrl_unbind(IN osm_sa_mad_ctrl_t * const p_ctrl);
 * SYNOPSIS
 */
 static inline osm_bind_handle_t
-osm_sa_mad_ctrl_get_bind_handle(IN const osm_sa_mad_ctrl_t * const p_ctrl)
+osm_sa_mad_ctrl_get_bind_handle(IN const osm_sa_mad_ctrl_t * p_ctrl)
 {
-	return (p_ctrl->h_bind);
+	return p_ctrl->h_bind;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_service.h b/opensm/include/opensm/osm_service.h
index 1d97a68..0d6bcdb 100644
--- a/opensm/include/opensm/osm_service.h
+++ b/opensm/include/opensm/osm_service.h
@@ -146,9 +146,8 @@ osm_svcr_t *osm_svcr_new(IN const ib_service_record_t * p_svc_rec);
 *
 * SYNOPSIS
 */
-void
-osm_svcr_init(IN osm_svcr_t * const p_svcr,
-	      IN const ib_service_record_t * p_svc_rec);
+void osm_svcr_init(IN osm_svcr_t * p_svcr,
+		   IN const ib_service_record_t * p_svc_rec);
 /*
 * PARAMETERS
 *	p_svc_rec
@@ -169,7 +168,7 @@ osm_svcr_init(IN osm_svcr_t * const p_svcr,
 *
 * SYNOPSIS
 */
-void osm_svcr_delete(IN osm_svcr_t * const p_svcr);
+void osm_svcr_delete(IN osm_svcr_t * p_svcr);
 /*
 * PARAMETERS
 *	p_svc_rec
@@ -181,14 +180,12 @@ void osm_svcr_delete(IN osm_svcr_t * const p_svcr);
 
 osm_svcr_t *osm_svcr_get_by_rid(IN osm_subn_t const *p_subn,
 				IN osm_log_t * p_log,
-				IN ib_service_record_t * const p_svc_rec);
+				IN ib_service_record_t * p_svc_rec);
 
-void
-osm_svcr_insert_to_db(IN osm_subn_t * p_subn,
-		      IN osm_log_t * p_log, IN osm_svcr_t * p_svcr);
-void
-osm_svcr_remove_from_db(IN osm_subn_t * p_subn,
-			IN osm_log_t * p_log, IN osm_svcr_t * p_svcr);
+void osm_svcr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			   IN osm_svcr_t * p_svcr);
+void osm_svcr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			     IN osm_svcr_t * p_svcr);
 
 END_C_DECLS
 #endif				/* _OSM_SVCR_H_ */
diff --git a/opensm/include/opensm/osm_sm.h b/opensm/include/opensm/osm_sm.h
index de3f098..e653d49 100644
--- a/opensm/include/opensm/osm_sm.h
+++ b/opensm/include/opensm/osm_sm.h
@@ -186,7 +186,7 @@ typedef struct osm_sm {
 *
 * SYNOPSIS
 */
-void osm_sm_construct(IN osm_sm_t * const p_sm);
+void osm_sm_construct(IN osm_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -215,7 +215,7 @@ void osm_sm_construct(IN osm_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-void osm_sm_shutdown(IN osm_sm_t * const p_sm);
+void osm_sm_shutdown(IN osm_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -238,7 +238,7 @@ void osm_sm_shutdown(IN osm_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-void osm_sm_destroy(IN osm_sm_t * const p_sm);
+void osm_sm_destroy(IN osm_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -266,16 +266,12 @@ void osm_sm_destroy(IN osm_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sm_init(IN osm_sm_t * const p_sm,
-	    IN osm_subn_t * const p_subn,
-	    IN osm_db_t * const p_db,
-	    IN osm_vendor_t * const p_vendor,
-	    IN osm_mad_pool_t * const p_mad_pool,
-	    IN osm_vl15_t * const p_vl15,
-	    IN osm_log_t * const p_log,
-	    IN osm_stats_t * const p_stats,
-	    IN cl_dispatcher_t * const p_disp, IN cl_plock_t * const p_lock);
+ib_api_status_t osm_sm_init(IN osm_sm_t * p_sm, IN osm_subn_t * p_subn,
+			    IN osm_db_t * p_db, IN osm_vendor_t * p_vendor,
+			    IN osm_mad_pool_t * p_mad_pool,
+			    IN osm_vl15_t * p_vl15, IN osm_log_t * p_log,
+			    IN osm_stats_t * p_stats,
+			    IN cl_dispatcher_t * p_disp, IN cl_plock_t * p_lock);
 /*
 * PARAMETERS
 *	p_sm
@@ -324,7 +320,7 @@ osm_sm_init(IN osm_sm_t * const p_sm,
 *
 * SYNOPSIS
 */
-void osm_sm_signal(IN osm_sm_t * const p_sm, osm_signal_t signal);
+void osm_sm_signal(IN osm_sm_t * p_sm, osm_signal_t signal);
 /*
 * PARAMETERS
 *	p_sm
@@ -348,7 +344,7 @@ void osm_sm_signal(IN osm_sm_t * const p_sm, osm_signal_t signal);
 *
 * SYNOPSIS
 */
-void osm_sm_sweep(IN osm_sm_t * const p_sm);
+void osm_sm_sweep(IN osm_sm_t * p_sm);
 /*
 * PARAMETERS
 *	p_sm
@@ -372,8 +368,7 @@ void osm_sm_sweep(IN osm_sm_t * const p_sm);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sm_bind(IN osm_sm_t * const p_sm, IN const ib_net64_t port_guid);
+ib_api_status_t osm_sm_bind(IN osm_sm_t * p_sm, IN ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_sm
@@ -402,13 +397,10 @@ osm_sm_bind(IN osm_sm_t * const p_sm, IN const ib_net64_t port_guid);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_req_get(IN osm_sm_t * sm,
-	    IN const osm_dr_path_t * const p_path,
-	    IN const ib_net16_t attr_id,
-	    IN const ib_net32_t attr_mod,
-	    IN const cl_disp_msgid_t err_msg,
-	    IN const osm_madw_context_t * const p_context);
+ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN cl_disp_msgid_t err_msg,
+			    IN const osm_madw_context_t * p_context);
 /*
 * PARAMETERS
 *	sm
@@ -448,15 +440,11 @@ osm_req_get(IN osm_sm_t * sm,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_req_set(IN osm_sm_t * sm,
-	    IN const osm_dr_path_t * const p_path,
-	    IN const uint8_t * const p_payload,
-	    IN const size_t payload_size,
-	    IN const ib_net16_t attr_id,
-	    IN const ib_net32_t attr_mod,
-	    IN const cl_disp_msgid_t err_msg,
-	    IN const osm_madw_context_t * const p_context);
+ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+			    IN const uint8_t * p_payload,
+			    IN size_t payload_size, IN ib_net16_t attr_id,
+			    IN ib_net32_t attr_mod, IN cl_disp_msgid_t err_msg,
+			    IN const osm_madw_context_t * p_context);
 /*
 * PARAMETERS
 *	sm
@@ -501,10 +489,10 @@ osm_req_set(IN osm_sm_t * sm,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_resp_send(IN osm_sm_t * sm,
-	      IN const osm_madw_t * const p_req_madw,
-	      IN const ib_net16_t status, IN const uint8_t * const p_payload);
+ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
+			      IN const osm_madw_t * p_req_madw,
+			      IN ib_net16_t status,
+			      IN const uint8_t * p_payload);
 /*
 * PARAMETERS
 *	p_resp
@@ -561,13 +549,11 @@ void osm_sm_reroute_mlid(osm_sm_t * sm, ib_net16_t mlid);
 *
 * SYNOPSIS
 */
-static inline cl_status_t
-osm_sm_wait_for_subnet_up(IN osm_sm_t * const p_sm,
-			  IN uint32_t const wait_us,
-			  IN boolean_t const interruptible)
+static inline cl_status_t osm_sm_wait_for_subnet_up(IN osm_sm_t * p_sm,
+						    IN uint32_t wait_us,
+						    IN boolean_t interruptible)
 {
-	return (cl_event_wait_on(&p_sm->subnet_up_event,
-				 wait_us, interruptible));
+	return cl_event_wait_on(&p_sm->subnet_up_event, wait_us, interruptible);
 }
 
 /*
@@ -606,10 +592,10 @@ osm_sm_wait_for_subnet_up(IN osm_sm_t * const p_sm,
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_sm_is_greater_than(IN const uint8_t l_priority,
-		       IN const ib_net64_t l_guid,
-		       IN const uint8_t r_priority, IN const ib_net64_t r_guid)
+static inline boolean_t osm_sm_is_greater_than(IN uint8_t l_priority,
+					       IN ib_net64_t l_guid,
+					       IN uint8_t r_priority,
+					       IN ib_net64_t r_guid)
 {
 	return (l_priority > r_priority
 		|| (l_priority == r_priority
diff --git a/opensm/include/opensm/osm_sm_mad_ctrl.h b/opensm/include/opensm/osm_sm_mad_ctrl.h
index 1c41168..8456fd3 100644
--- a/opensm/include/opensm/osm_sm_mad_ctrl.h
+++ b/opensm/include/opensm/osm_sm_mad_ctrl.h
@@ -147,7 +147,7 @@ typedef struct osm_sm_mad_ctrl {
 *
 * SYNOPSIS
 */
-void osm_sm_mad_ctrl_construct(IN osm_sm_mad_ctrl_t * const p_ctrl);
+void osm_sm_mad_ctrl_construct(IN osm_sm_mad_ctrl_t * p_ctrl);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -178,7 +178,7 @@ void osm_sm_mad_ctrl_construct(IN osm_sm_mad_ctrl_t * const p_ctrl);
 *
 * SYNOPSIS
 */
-void osm_sm_mad_ctrl_destroy(IN osm_sm_mad_ctrl_t * const p_ctrl);
+void osm_sm_mad_ctrl_destroy(IN osm_sm_mad_ctrl_t * p_ctrl);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -209,16 +209,15 @@ void osm_sm_mad_ctrl_destroy(IN osm_sm_mad_ctrl_t * const p_ctrl);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sm_mad_ctrl_init(IN osm_sm_mad_ctrl_t * const p_ctrl,
-		     IN osm_subn_t * const p_subn,
-		     IN osm_mad_pool_t * const p_mad_pool,
-		     IN osm_vl15_t * const p_vl15,
-		     IN osm_vendor_t * const p_vendor,
-		     IN osm_log_t * const p_log,
-		     IN osm_stats_t * const p_stats,
-		     IN cl_plock_t * const p_lock,
-		     IN cl_dispatcher_t * const p_disp);
+ib_api_status_t osm_sm_mad_ctrl_init(IN osm_sm_mad_ctrl_t * p_ctrl,
+				     IN osm_subn_t * p_subn,
+				     IN osm_mad_pool_t * p_mad_pool,
+				     IN osm_vl15_t * p_vl15,
+				     IN osm_vendor_t * p_vendor,
+				     IN osm_log_t * p_log,
+				     IN osm_stats_t * p_stats,
+				     IN cl_plock_t * p_lock,
+				     IN cl_dispatcher_t * p_disp);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -266,9 +265,8 @@ osm_sm_mad_ctrl_init(IN osm_sm_mad_ctrl_t * const p_ctrl,
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_sm_mad_ctrl_bind(IN osm_sm_mad_ctrl_t * const p_ctrl,
-		     IN const ib_net64_t port_guid);
+ib_api_status_t osm_sm_mad_ctrl_bind(IN osm_sm_mad_ctrl_t * p_ctrl,
+				     IN ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -298,9 +296,9 @@ osm_sm_mad_ctrl_bind(IN osm_sm_mad_ctrl_t * const p_ctrl,
 * SYNOPSIS
 */
 static inline osm_bind_handle_t
-osm_sm_mad_ctrl_get_bind_handle(IN const osm_sm_mad_ctrl_t * const p_ctrl)
+osm_sm_mad_ctrl_get_bind_handle(IN const osm_sm_mad_ctrl_t * p_ctrl)
 {
-	return (p_ctrl->h_bind);
+	return p_ctrl->h_bind;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index a8c6b62..9488225 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -651,7 +651,7 @@ typedef struct osm_subn {
 *
 * SYNOPSIS
 */
-void osm_subn_construct(IN osm_subn_t * const p_subn);
+void osm_subn_construct(IN osm_subn_t * p_subn);
 /*
 * PARAMETERS
 *	p_subn
@@ -680,7 +680,7 @@ void osm_subn_construct(IN osm_subn_t * const p_subn);
 *
 * SYNOPSIS
 */
-void osm_subn_destroy(IN osm_subn_t * const p_subn);
+void osm_subn_destroy(IN osm_subn_t * p_subn);
 /*
 * PARAMETERS
 *	p_subn
@@ -708,10 +708,9 @@ void osm_subn_destroy(IN osm_subn_t * const p_subn);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_subn_init(IN osm_subn_t * const p_subn,
-	      IN struct osm_opensm *const p_osm,
-	      IN const osm_subn_opt_t * const p_opt);
+ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn,
+			      IN struct osm_opensm *p_osm,
+			      IN const osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *	p_subn
@@ -752,11 +751,10 @@ struct osm_mgrp;
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_get_gid_by_mad_addr(IN struct osm_log *p_log,
-			IN const osm_subn_t * p_subn,
-			IN struct osm_mad_addr *p_mad_addr,
-			OUT ib_gid_t * p_gid);
+ib_api_status_t osm_get_gid_by_mad_addr(IN struct osm_log *p_log,
+					IN const osm_subn_t * p_subn,
+					IN struct osm_mad_addr *p_mad_addr,
+					OUT ib_gid_t * p_gid);
 /*
 * PARAMETERS
 *	p_log
@@ -860,7 +858,7 @@ struct osm_port *osm_get_port_by_mad_addr(IN struct osm_log *p_log,
 * SYNOPSIS
 */
 struct osm_switch *osm_get_switch_by_guid(IN const osm_subn_t * p_subn,
-					   IN uint64_t guid);
+					  IN uint64_t guid);
 /*
 * PARAMETERS
 *	p_subn
@@ -889,7 +887,7 @@ struct osm_switch *osm_get_switch_by_guid(IN const osm_subn_t * p_subn,
 * SYNOPSIS
 */
 struct osm_node *osm_get_node_by_guid(IN osm_subn_t const *p_subn,
-				       IN uint64_t guid);
+				      IN uint64_t guid);
 /*
 * PARAMETERS
 *	p_subn
@@ -918,7 +916,7 @@ struct osm_node *osm_get_node_by_guid(IN osm_subn_t const *p_subn,
 * SYNOPSIS
 */
 struct osm_port *osm_get_port_by_guid(IN osm_subn_t const *p_subn,
-				       IN ib_net64_t guid);
+				      IN ib_net64_t guid);
 /*
 * PARAMETERS
 *	p_subn
@@ -1032,7 +1030,7 @@ struct osm_physp *osm_get_physp_by_mad_addr(IN struct osm_log *p_log,
 *
 * SYNOPSIS
 */
-void osm_subn_set_default_opt(IN osm_subn_opt_t * const p_opt);
+void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *
@@ -1058,7 +1056,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * const p_opt);
 *
 * SYNOPSIS
 */
-int osm_subn_parse_conf_file(char *conf_file, osm_subn_opt_t * const p_opt);
+int osm_subn_parse_conf_file(char *conf_file, osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *
@@ -1080,7 +1078,7 @@ int osm_subn_parse_conf_file(char *conf_file, osm_subn_opt_t * const p_opt);
 *
 * SYNOPSIS
 */
-int osm_subn_rescan_conf_files(IN osm_subn_t * const p_subn);
+int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn);
 /*
 * PARAMETERS
 *
@@ -1102,7 +1100,7 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * const p_subn);
 *
 * SYNOPSIS
 */
-int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * const p_opt);
+int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *
@@ -1125,7 +1123,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * const p_opt);
 *
 * SYNOPSIS
 */
-int osm_subn_write_conf_file(char *file_name, IN osm_subn_opt_t * const p_opt);
+int osm_subn_write_conf_file(char *file_name, IN osm_subn_opt_t * p_opt);
 /*
 * PARAMETERS
 *
@@ -1139,7 +1137,7 @@ int osm_subn_write_conf_file(char *file_name, IN osm_subn_opt_t * const p_opt);
 *	Assumes the conf file is part of the cache dir which defaults to
 *	OSM_DEFAULT_CACHE_DIR or OSM_CACHE_DIR the name is opensm.opts
 *********/
-int osm_subn_verify_config(osm_subn_opt_t * const p_opt);
+int osm_subn_verify_config(osm_subn_opt_t * p_opt);
 
 END_C_DECLS
 #endif				/* _OSM_SUBNET_H_ */
diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index 37c1c4f..502e5a7 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -196,7 +196,7 @@ struct osm_remote_guids_count {
 *
 * SYNOPSIS
 */
-void osm_switch_delete(IN OUT osm_switch_t ** const pp_sw);
+void osm_switch_delete(IN OUT osm_switch_t ** pp_sw);
 /*
 * PARAMETERS
 *	p_sw
@@ -220,8 +220,8 @@ void osm_switch_delete(IN OUT osm_switch_t ** const pp_sw);
 *
 * SYNOPSIS
 */
-osm_switch_t *osm_switch_new(IN osm_node_t * const p_node,
-			     IN const osm_madw_t * const p_madw);
+osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
+			     IN const osm_madw_t * p_madw);
 /*
 * PARAMETERS
 *	p_node
@@ -249,9 +249,9 @@ osm_switch_t *osm_switch_new(IN osm_node_t * const p_node,
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_switch_get_hop_count(IN const osm_switch_t * const p_sw,
-			 IN const uint16_t lid_ho, IN const uint8_t port_num)
+static inline uint8_t osm_switch_get_hop_count(IN const osm_switch_t * p_sw,
+					       IN uint16_t lid_ho,
+					       IN uint8_t port_num)
 {
 	return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
 	    OSM_NO_PATH : p_sw->hops[lid_ho][port_num];
@@ -284,10 +284,8 @@ osm_switch_get_hop_count(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-cl_status_t
-osm_switch_set_hops(IN osm_switch_t * const p_sw,
-		    IN const uint16_t lid_ho,
-		    IN const uint8_t port_num, IN const uint8_t num_hops);
+cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
+				IN uint8_t port_num, IN uint8_t num_hops);
 /*
 * PARAMETERS
 *	p_sw
@@ -340,9 +338,8 @@ void osm_switch_clear_hops(IN osm_switch_t * p_sw);
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_switch_get_least_hops(IN const osm_switch_t * const p_sw,
-			  IN const uint16_t lid_ho)
+static inline uint8_t osm_switch_get_least_hops(IN const osm_switch_t * p_sw,
+						IN uint16_t lid_ho)
 {
 	return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
 	    OSM_NO_PATH : p_sw->hops[lid_ho][0];
@@ -375,9 +372,8 @@ osm_switch_get_least_hops(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-uint8_t
-osm_switch_get_port_least_hops(IN const osm_switch_t * const p_sw,
-			       IN const osm_port_t * p_port);
+uint8_t osm_switch_get_port_least_hops(IN const osm_switch_t * p_sw,
+				       IN const osm_port_t * p_port);
 /*
 * PARAMETERS
 *	p_sw
@@ -406,9 +402,8 @@ osm_switch_get_port_least_hops(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_switch_get_port_by_lid(IN const osm_switch_t * const p_sw,
-			   IN const uint16_t lid_ho)
+static inline uint8_t osm_switch_get_port_by_lid(IN const osm_switch_t * p_sw,
+						 IN uint16_t lid_ho)
 {
 	if (lid_ho == 0 || lid_ho > IB_LID_UCAST_END_HO)
 		return OSM_NO_PATH;
@@ -440,8 +435,8 @@ osm_switch_get_port_by_lid(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-osm_physp_t *osm_switch_get_physp_ptr(IN const osm_switch_t * const p_sw,
-				      IN const uint32_t port_num);
+osm_physp_t *osm_switch_get_physp_ptr(IN const osm_switch_t * p_sw,
+				      IN uint32_t port_num);
 /*
 * PARAMETERS
 *	p_sw
@@ -472,8 +467,7 @@ osm_physp_t *osm_switch_get_physp_ptr(IN const osm_switch_t * const p_sw,
 * SYNOPSIS
 */
 static inline osm_physp_t *osm_switch_get_route_by_lid(IN const osm_switch_t *
-						       const p_sw,
-						       IN const ib_net16_t lid)
+						       p_sw, IN ib_net16_t lid)
 {
 	uint8_t port_num;
 
@@ -524,7 +518,7 @@ static inline osm_physp_t *osm_switch_get_route_by_lid(IN const osm_switch_t *
 *
 */
 static inline unsigned
-osm_switch_sp0_is_lmc_capable(IN const osm_switch_t * const p_sw,
+osm_switch_sp0_is_lmc_capable(IN const osm_switch_t * p_sw,
 			      IN osm_subn_t * p_subn)
 {
 	return (p_subn->opt.lmc_esp0 &&
@@ -559,7 +553,7 @@ osm_switch_sp0_is_lmc_capable(IN const osm_switch_t * const p_sw,
 * SYNOPSIS
 */
 static inline uint16_t
-osm_switch_get_max_block_id_in_use(IN const osm_switch_t * const p_sw)
+osm_switch_get_max_block_id_in_use(IN const osm_switch_t * p_sw)
 {
 	return cl_ntoh16(p_sw->switch_info.lin_top) / IB_SMP_DATA_SIZE;
 }
@@ -586,10 +580,8 @@ osm_switch_get_max_block_id_in_use(IN const osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-boolean_t
-osm_switch_get_lft_block(IN const osm_switch_t * const p_sw,
-			 IN const uint16_t block_id,
-			 OUT uint8_t * const p_block);
+boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
+				   IN uint16_t block_id, OUT uint8_t * p_block);
 /*
 * PARAMETERS
 *	p_sw
@@ -621,8 +613,7 @@ osm_switch_get_lft_block(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_switch_supports_mcast(IN const osm_switch_t * const p_sw)
+static inline boolean_t osm_switch_supports_mcast(IN const osm_switch_t * p_sw)
 {
 	return (p_sw->switch_info.mcast_cap != 0);
 }
@@ -649,9 +640,8 @@ osm_switch_supports_mcast(IN const osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-static inline void
-osm_switch_set_switch_info(IN osm_switch_t * const p_sw,
-			   IN const ib_switch_info_t * const p_si)
+static inline void osm_switch_set_switch_info(IN osm_switch_t * p_sw,
+					      IN const ib_switch_info_t * p_si)
 {
 	CL_ASSERT(p_sw);
 	CL_ASSERT(p_si);
@@ -682,8 +672,8 @@ osm_switch_set_switch_info(IN osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-static inline void
-osm_switch_count_path(IN osm_switch_t * const p_sw, IN const uint8_t port)
+static inline void osm_switch_count_path(IN osm_switch_t * p_sw,
+					 IN uint8_t port)
 {
 	osm_port_prof_path_count_inc(&p_sw->p_prof[port]);
 }
@@ -714,9 +704,8 @@ osm_switch_count_path(IN osm_switch_t * const p_sw, IN const uint8_t port)
 * SYNOPSIS
 */
 static inline ib_api_status_t
-osm_switch_set_lft_block(IN osm_switch_t * const p_sw,
-			 IN const uint8_t * const p_block,
-			 IN const uint32_t block_num)
+osm_switch_set_lft_block(IN osm_switch_t * p_sw, IN const uint8_t * p_block,
+			 IN uint32_t block_num)
 {
 	uint16_t lid_start =
 		(uint16_t) (block_num * IB_SMP_DATA_SIZE);
@@ -757,13 +746,12 @@ osm_switch_set_lft_block(IN osm_switch_t * const p_sw,
 * SYNOPSIS
 */
 static inline ib_api_status_t
-osm_switch_set_mft_block(IN osm_switch_t * const p_sw,
-			 IN const ib_net16_t * const p_block,
-			 IN const uint16_t block_num, IN const uint8_t position)
+osm_switch_set_mft_block(IN osm_switch_t * p_sw, IN const ib_net16_t * p_block,
+			 IN uint16_t block_num, IN uint8_t position)
 {
 	CL_ASSERT(p_sw);
-	return (osm_mcast_tbl_set_block(&p_sw->mcast_tbl, p_block,
-					block_num, position));
+	return osm_mcast_tbl_set_block(&p_sw->mcast_tbl, p_block, block_num,
+				       position);
 }
 /*
 * PARAMETERS
@@ -796,15 +784,14 @@ osm_switch_set_mft_block(IN osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-static inline boolean_t
-osm_switch_get_mft_block(IN osm_switch_t * const p_sw,
-			 IN const uint16_t block_num,
-			 IN const uint8_t position,
-			 OUT ib_net16_t * const p_block)
+static inline boolean_t osm_switch_get_mft_block(IN osm_switch_t * p_sw,
+						 IN uint16_t block_num,
+						 IN uint8_t position,
+						 OUT ib_net16_t * p_block)
 {
 	CL_ASSERT(p_sw);
-	return (osm_mcast_tbl_get_block(&p_sw->mcast_tbl,
-					block_num, position, p_block));
+	return osm_mcast_tbl_get_block(&p_sw->mcast_tbl, block_num, position,
+				       p_block);
 }
 /*
 * PARAMETERS
@@ -839,11 +826,10 @@ osm_switch_get_mft_block(IN osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-static inline uint16_t
-osm_switch_get_mft_max_block(IN osm_switch_t * const p_sw)
+static inline uint16_t osm_switch_get_mft_max_block(IN osm_switch_t * p_sw)
 {
 	CL_ASSERT(p_sw);
-	return (osm_mcast_tbl_get_max_block(&p_sw->mcast_tbl));
+	return osm_mcast_tbl_get_max_block(&p_sw->mcast_tbl);
 }
 /*
 * PARAMETERS
@@ -862,11 +848,10 @@ osm_switch_get_mft_max_block(IN osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-static inline int16_t
-osm_switch_get_mft_max_block_in_use(IN osm_switch_t * const p_sw)
+static inline int16_t osm_switch_get_mft_max_block_in_use(IN osm_switch_t * p_sw)
 {
 	CL_ASSERT(p_sw);
-	return (osm_mcast_tbl_get_max_block_in_use(&p_sw->mcast_tbl));
+	return osm_mcast_tbl_get_max_block_in_use(&p_sw->mcast_tbl);
 }
 /*
 * PARAMETERS
@@ -891,11 +876,10 @@ osm_switch_get_mft_max_block_in_use(IN osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-static inline uint8_t
-osm_switch_get_mft_max_position(IN osm_switch_t * const p_sw)
+static inline uint8_t osm_switch_get_mft_max_position(IN osm_switch_t * p_sw)
 {
 	CL_ASSERT(p_sw);
-	return (osm_mcast_tbl_get_max_position(&p_sw->mcast_tbl));
+	return osm_mcast_tbl_get_max_position(&p_sw->mcast_tbl);
 }
 /*
 * PARAMETERS
@@ -918,13 +902,11 @@ osm_switch_get_mft_max_position(IN osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-uint8_t
-osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
-			  IN osm_port_t * p_port,
-			  IN const uint16_t lid_ho,
-			  IN unsigned start_from,
-			  IN const boolean_t ignore_existing,
-			  IN const boolean_t dor);
+uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
+				  IN osm_port_t * p_port, IN uint16_t lid_ho,
+				  IN unsigned start_from,
+				  IN boolean_t ignore_existing,
+				  IN boolean_t dor);
 /*
 * PARAMETERS
 *	p_sw
@@ -966,11 +948,10 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-uint8_t
-osm_switch_recommend_mcast_path(IN osm_switch_t * const p_sw,
-				IN osm_port_t * p_port,
-				IN const uint16_t mlid_ho,
-				IN const boolean_t ignore_existing);
+uint8_t osm_switch_recommend_mcast_path(IN osm_switch_t * p_sw,
+					IN osm_port_t * p_port,
+					IN uint16_t mlid_ho,
+					IN boolean_t ignore_existing);
 /*
 * PARAMETERS
 *	p_sw
@@ -1007,9 +988,9 @@ osm_switch_recommend_mcast_path(IN osm_switch_t * const p_sw,
 * SYNOPSIS
 */
 static inline uint16_t
-osm_switch_get_mcast_fwd_tbl_size(IN const osm_switch_t * const p_sw)
+osm_switch_get_mcast_fwd_tbl_size(IN const osm_switch_t * p_sw)
 {
-	return (cl_ntoh16(p_sw->switch_info.mcast_cap));
+	return cl_ntoh16(p_sw->switch_info.mcast_cap);
 }
 /*
 * PARAMETERS
@@ -1033,11 +1014,10 @@ osm_switch_get_mcast_fwd_tbl_size(IN const osm_switch_t * const p_sw)
 *
 * SYNOPSIS
 */
-static inline uint32_t
-osm_switch_path_count_get(IN const osm_switch_t * const p_sw,
-			  IN const uint8_t port_num)
+static inline uint32_t osm_switch_path_count_get(IN const osm_switch_t * p_sw,
+						 IN uint8_t port_num)
 {
-	return (osm_port_prof_path_count_get(&p_sw->p_prof[port_num]));
+	return osm_port_prof_path_count_get(&p_sw->p_prof[port_num]);
 }
 /*
 * PARAMETERS
@@ -1064,8 +1044,8 @@ osm_switch_path_count_get(IN const osm_switch_t * const p_sw,
 *
 * SYNOPSIS
 */
-int
-osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids);
+int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw,
+				    IN uint16_t max_lids);
 /*
 * PARAMETERS
 *	p_sw
@@ -1092,10 +1072,9 @@ osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids);
 * SYNOPSIS
 */
 static inline osm_mcast_tbl_t *osm_switch_get_mcast_tbl_ptr(IN const
-							    osm_switch_t *
-							    const p_sw)
+							    osm_switch_t * p_sw)
 {
-	return ((osm_mcast_tbl_t *) & p_sw->mcast_tbl);
+	return (osm_mcast_tbl_t *) & p_sw->mcast_tbl;
 }
 /*
 * PARAMETERS
@@ -1121,16 +1100,15 @@ static inline osm_mcast_tbl_t *osm_switch_get_mcast_tbl_ptr(IN const
 * SYNOPSIS
 */
 static inline boolean_t
-osm_switch_is_in_mcast_tree(IN const osm_switch_t * const p_sw,
-			    IN const uint16_t mlid_ho)
+osm_switch_is_in_mcast_tree(IN const osm_switch_t * p_sw, IN uint16_t mlid_ho)
 {
 	const osm_mcast_tbl_t *p_tbl;
 
 	p_tbl = &p_sw->mcast_tbl;
 	if (p_tbl)
-		return (osm_mcast_tbl_is_any_port(&p_sw->mcast_tbl, mlid_ho));
+		return osm_mcast_tbl_is_any_port(&p_sw->mcast_tbl, mlid_ho);
 	else
-		return (FALSE);
+		return FALSE;
 }
 /*
 * PARAMETERS
diff --git a/opensm/include/opensm/osm_ucast_mgr.h b/opensm/include/opensm/osm_ucast_mgr.h
index 26d11ff..86eba4d 100644
--- a/opensm/include/opensm/osm_ucast_mgr.h
+++ b/opensm/include/opensm/osm_ucast_mgr.h
@@ -146,7 +146,7 @@ typedef struct osm_ucast_mgr {
 *
 * SYNOPSIS
 */
-void osm_ucast_mgr_construct(IN osm_ucast_mgr_t * const p_mgr);
+void osm_ucast_mgr_construct(IN osm_ucast_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -176,7 +176,7 @@ void osm_ucast_mgr_construct(IN osm_ucast_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-void osm_ucast_mgr_destroy(IN osm_ucast_mgr_t * const p_mgr);
+void osm_ucast_mgr_destroy(IN osm_ucast_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -207,8 +207,8 @@ void osm_ucast_mgr_destroy(IN osm_ucast_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_ucast_mgr_init(IN osm_ucast_mgr_t * const p_mgr, IN struct osm_sm * sm);
+ib_api_status_t osm_ucast_mgr_init(IN osm_ucast_mgr_t * p_mgr,
+				   IN struct osm_sm * sm);
 /*
 * PARAMETERS
 *	p_mgr
@@ -238,7 +238,7 @@ osm_ucast_mgr_init(IN osm_ucast_mgr_t * const p_mgr, IN struct osm_sm * sm);
 *
 * SYNOPSIS
 */
-void osm_ucast_mgr_set_fwd_tables(IN osm_ucast_mgr_t * const p_mgr);
+void osm_ucast_mgr_set_fwd_tables(IN osm_ucast_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -257,7 +257,7 @@ void osm_ucast_mgr_set_fwd_tables(IN osm_ucast_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-int osm_ucast_mgr_build_lid_matrices(IN osm_ucast_mgr_t * const p_mgr);
+int osm_ucast_mgr_build_lid_matrices(IN osm_ucast_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
@@ -280,7 +280,7 @@ int osm_ucast_mgr_build_lid_matrices(IN osm_ucast_mgr_t * const p_mgr);
 *
 * SYNOPSIS
 */
-int osm_ucast_mgr_process(IN osm_ucast_mgr_t * const p_mgr);
+int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr);
 /*
 * PARAMETERS
 *	p_mgr
diff --git a/opensm/include/opensm/osm_vl15intf.h b/opensm/include/opensm/osm_vl15intf.h
index 028eec0..6d6e318 100644
--- a/opensm/include/opensm/osm_vl15intf.h
+++ b/opensm/include/opensm/osm_vl15intf.h
@@ -176,7 +176,7 @@ typedef struct osm_vl15 {
 *
 * SYNOPSIS
 */
-void osm_vl15_construct(IN osm_vl15_t * const p_vl15);
+void osm_vl15_construct(IN osm_vl15_t * p_vl15);
 /*
 * PARAMETERS
 *	p_vl15
@@ -205,8 +205,7 @@ void osm_vl15_construct(IN osm_vl15_t * const p_vl15);
 *
 * SYNOPSIS
 */
-void
-osm_vl15_destroy(IN osm_vl15_t * const p_vl15, IN struct osm_mad_pool *p_pool);
+void osm_vl15_destroy(IN osm_vl15_t * p_vl15, IN struct osm_mad_pool *p_pool);
 /*
 * PARAMETERS
 *	p_vl15
@@ -242,12 +241,9 @@ osm_vl15_destroy(IN osm_vl15_t * const p_vl15, IN struct osm_mad_pool *p_pool);
 *
 * SYNOPSIS
 */
-ib_api_status_t
-osm_vl15_init(IN osm_vl15_t * const p_vl15,
-	      IN osm_vendor_t * const p_vend,
-	      IN osm_log_t * const p_log,
-	      IN osm_stats_t * const p_stats,
-	      IN const int32_t max_wire_smps);
+ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
+			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
+			      IN int32_t max_wire_smps);
 /*
 * PARAMETERS
 *	p_vl15
@@ -284,7 +280,7 @@ osm_vl15_init(IN osm_vl15_t * const p_vl15,
 *
 * SYNOPSIS
 */
-void osm_vl15_post(IN osm_vl15_t * const p_vl15, IN osm_madw_t * const p_madw);
+void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw);
 /*
 * PARAMETERS
 *	p_vl15
@@ -313,7 +309,7 @@ void osm_vl15_post(IN osm_vl15_t * const p_vl15, IN osm_madw_t * const p_madw);
 *
 * SYNOPSIS
 */
-void osm_vl15_poll(IN osm_vl15_t * const p_vl);
+void osm_vl15_poll(IN osm_vl15_t * p_vl);
 /*
 * PARAMETERS
 *	p_vl15
@@ -343,9 +339,7 @@ void osm_vl15_poll(IN osm_vl15_t * const p_vl);
 *
 * SYNOPSIS
 */
-void
-osm_vl15_shutdown(IN osm_vl15_t * const p_vl,
-		  IN osm_mad_pool_t * const p_mad_pool);
+void osm_vl15_shutdown(IN osm_vl15_t * p_vl, IN osm_mad_pool_t * p_mad_pool);
 /*
 * PARAMETERS
 *	p_vl15
diff --git a/opensm/opensm/osm_db_files.c b/opensm/opensm/osm_db_files.c
index c30f7a8..0c01597 100644
--- a/opensm/opensm/osm_db_files.c
+++ b/opensm/opensm/osm_db_files.c
@@ -119,7 +119,7 @@ typedef struct osm_db_imp {
 
 /***************************************************************************
  ***************************************************************************/
-void osm_db_construct(IN osm_db_t * const p_db)
+void osm_db_construct(IN osm_db_t * p_db)
 {
 	memset(p_db, 0, sizeof(osm_db_t));
 	cl_list_construct(&p_db->domains);
@@ -143,7 +143,7 @@ void osm_db_domain_destroy(IN osm_db_domain_t * p_db_domain)
 
 /***************************************************************************
  ***************************************************************************/
-void osm_db_destroy(IN osm_db_t * const p_db)
+void osm_db_destroy(IN osm_db_t * p_db)
 {
 	osm_db_domain_t *p_domain;
 
@@ -157,7 +157,7 @@ void osm_db_destroy(IN osm_db_t * const p_db)
 
 /***************************************************************************
  ***************************************************************************/
-int osm_db_init(IN osm_db_t * const p_db, IN osm_log_t * p_log)
+int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 {
 	osm_db_imp_t *p_db_imp;
 	struct stat dstat;
@@ -201,7 +201,7 @@ int osm_db_init(IN osm_db_t * const p_db, IN osm_log_t * p_log)
 
 /***************************************************************************
  ***************************************************************************/
-osm_db_domain_t *osm_db_domain_init(IN osm_db_t * const p_db, IN char *domain_name)
+osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name)
 {
 	osm_db_domain_t *p_domain;
 	osm_db_domain_imp_t *p_domain_imp;
@@ -537,7 +537,7 @@ int osm_db_keys(IN osm_db_domain_t * p_domain, OUT cl_list_t * p_key_list)
 
 /***************************************************************************
  ***************************************************************************/
-char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char * const p_key)
+char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char *p_key)
 {
 	osm_db_domain_imp_t *p_domain_imp =
 	    (osm_db_domain_imp_t *) p_domain->p_domain_imp;
@@ -555,7 +555,7 @@ char *osm_db_lookup(IN osm_db_domain_t * p_domain, IN char * const p_key)
 
 /***************************************************************************
  ***************************************************************************/
-int osm_db_update(IN osm_db_domain_t * p_domain, IN char * const p_key, IN char * const p_val)
+int osm_db_update(IN osm_db_domain_t * p_domain, IN char *p_key, IN char *p_val)
 {
 	osm_log_t *p_log = p_domain->p_db->p_log;
 	osm_db_domain_imp_t *p_domain_imp =
@@ -595,7 +595,7 @@ int osm_db_update(IN osm_db_domain_t * p_domain, IN char * const p_key, IN char
 
 /***************************************************************************
  ***************************************************************************/
-int osm_db_delete(IN osm_db_domain_t * p_domain, IN char * const p_key)
+int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key)
 {
 	osm_log_t *p_log = p_domain->p_db->p_log;
 	osm_db_domain_imp_t *p_domain_imp =
diff --git a/opensm/opensm/osm_db_pack.c b/opensm/opensm/osm_db_pack.c
index 3b4b4d7..6af2694 100644
--- a/opensm/opensm/osm_db_pack.c
+++ b/opensm/opensm/osm_db_pack.c
@@ -83,7 +83,7 @@ static inline int unpack_lids(IN char *p_lid_str, OUT uint16_t * p_min_lid,
 	return 0;
 }
 
-int osm_db_guid2lid_guids(IN osm_db_domain_t * const p_g2l,
+int osm_db_guid2lid_guids(IN osm_db_domain_t * p_g2l,
 			  OUT cl_qlist_t * p_guid_list)
 {
 	char *p_key;
@@ -109,7 +109,7 @@ int osm_db_guid2lid_guids(IN osm_db_domain_t * const p_g2l,
 	return 0;
 }
 
-int osm_db_guid2lid_get(IN osm_db_domain_t * const p_g2l, IN uint64_t guid,
+int osm_db_guid2lid_get(IN osm_db_domain_t * p_g2l, IN uint64_t guid,
 			OUT uint16_t * p_min_lid, OUT uint16_t * p_max_lid)
 {
 	char guid_str[20];
@@ -131,7 +131,7 @@ int osm_db_guid2lid_get(IN osm_db_domain_t * const p_g2l, IN uint64_t guid,
 	return 0;
 }
 
-int osm_db_guid2lid_set(IN osm_db_domain_t * const p_g2l, IN uint64_t guid,
+int osm_db_guid2lid_set(IN osm_db_domain_t * p_g2l, IN uint64_t guid,
 			IN uint16_t min_lid, IN uint16_t max_lid)
 {
 	char guid_str[20];
@@ -143,7 +143,7 @@ int osm_db_guid2lid_set(IN osm_db_domain_t * const p_g2l, IN uint64_t guid,
 	return (osm_db_update(p_g2l, guid_str, lid_str));
 }
 
-int osm_db_guid2lid_delete(IN osm_db_domain_t * const p_g2l, IN uint64_t guid)
+int osm_db_guid2lid_delete(IN osm_db_domain_t * p_g2l, IN uint64_t guid)
 {
 	char guid_str[20];
 	pack_guid(guid, guid_str);
diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
index 7d55a06..9bfaed5 100644
--- a/opensm/opensm/osm_inform.c
+++ b/opensm/opensm/osm_inform.c
@@ -61,7 +61,7 @@ typedef struct osm_infr_match_ctxt {
 
 /**********************************************************************
  **********************************************************************/
-void osm_infr_delete(IN osm_infr_t * const p_infr)
+void osm_infr_delete(IN osm_infr_t * p_infr)
 {
 	free(p_infr);
 }
@@ -83,7 +83,7 @@ osm_infr_t *osm_infr_new(IN const osm_infr_t * p_infr_rec)
 
 /**********************************************************************
  **********************************************************************/
-static void dump_all_informs(IN osm_subn_t const *p_subn, IN osm_log_t * p_log)
+static void dump_all_informs(IN const osm_subn_t * p_subn, IN osm_log_t * p_log)
 {
 	cl_list_item_t *p_list_item;
 
@@ -214,7 +214,7 @@ Exit:
  **********************************************************************/
 osm_infr_t *osm_infr_get_by_rec(IN osm_subn_t const *p_subn,
 				IN osm_log_t * p_log,
-				IN osm_infr_t * const p_infr_rec)
+				IN osm_infr_t * p_infr_rec)
 {
 	cl_list_item_t *p_list_item;
 
@@ -572,7 +572,7 @@ static void log_notice(osm_log_t * log, osm_log_level_t level,
 				  sizeof gid_str));
 }
 
-ib_api_status_t osm_report_notice(IN osm_log_t * const p_log, IN osm_subn_t * p_subn,
+ib_api_status_t osm_report_notice(IN osm_log_t * p_log, IN osm_subn_t * p_subn,
 				  IN ib_mad_notice_attr_t * p_ntc)
 {
 	osm_infr_match_ctxt_t context;
diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 8b620c3..947fe7a 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -106,14 +106,14 @@ typedef struct osm_lid_mgr_range {
 
 /**********************************************************************
  **********************************************************************/
-void osm_lid_mgr_construct(IN osm_lid_mgr_t * const p_mgr)
+void osm_lid_mgr_construct(IN osm_lid_mgr_t * p_mgr)
 {
 	memset(p_mgr, 0, sizeof(*p_mgr));
 }
 
 /**********************************************************************
  **********************************************************************/
-void osm_lid_mgr_destroy(IN osm_lid_mgr_t * const p_mgr)
+void osm_lid_mgr_destroy(IN osm_lid_mgr_t * p_mgr)
 {
 	cl_list_item_t *p_item;
 
@@ -224,7 +224,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_lid_mgr_init(IN osm_lid_mgr_t * const p_mgr, IN osm_sm_t * sm)
+ib_api_status_t osm_lid_mgr_init(IN osm_lid_mgr_t * p_mgr, IN osm_sm_t * sm)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
@@ -585,11 +585,11 @@ AfterScanningLids:
  check if the given range of lids is free
 **********************************************************************/
 static boolean_t lid_mgr_is_range_not_persistent(IN osm_lid_mgr_t * p_mgr,
-						 IN const uint16_t lid,
-						 IN const uint16_t num_lids)
+						 IN uint16_t lid,
+						 IN uint16_t num_lids)
 {
 	uint16_t i;
-	const uint8_t start_lid = (uint8_t) (1 << p_mgr->p_subn->opt.lmc);
+	uint8_t start_lid = (uint8_t) (1 << p_mgr->p_subn->opt.lmc);
 
 	if (lid < start_lid)
 		return FALSE;
@@ -605,7 +605,7 @@ static boolean_t lid_mgr_is_range_not_persistent(IN osm_lid_mgr_t * p_mgr,
 find a free lid range
 **********************************************************************/
 static void lid_mgr_find_free_lid_range(IN osm_lid_mgr_t * p_mgr,
-					IN const uint8_t num_lids,
+					IN uint8_t num_lids,
 					OUT uint16_t * p_min_lid,
 					OUT uint16_t * p_max_lid)
 {
@@ -823,8 +823,7 @@ static void lid_mgr_set_remote_pi_state_to_init(IN osm_lid_mgr_t * p_mgr,
  **********************************************************************/
 static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 				IN osm_port_t * p_port,
-				IN osm_physp_t * p_physp,
-				IN ib_net16_t const lid)
+				IN osm_physp_t * p_physp, IN ib_net16_t lid)
 {
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	ib_port_info_t *p_pi = (ib_port_info_t *) payload;
@@ -1145,7 +1144,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * const p_mgr)
+int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * p_mgr)
 {
 	int ret;
 
@@ -1173,7 +1172,7 @@ int osm_lid_mgr_process_sm(IN osm_lid_mgr_t * const p_mgr)
  1.2 if a change is required send the port info
  2 if any change send the signal PENDING...
 **********************************************************************/
-int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * const p_mgr)
+int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * p_mgr)
 {
 	cl_qmap_t *p_port_guid_tbl;
 	osm_port_t *p_port;
diff --git a/opensm/opensm/osm_log.c b/opensm/opensm/osm_log.c
index d5e1af6..8f30784 100644
--- a/opensm/opensm/osm_log.c
+++ b/opensm/opensm/osm_log.c
@@ -80,7 +80,7 @@ void OsmReportState(IN const char *p_str);
 
 #ifndef WIN32
 
-static void truncate_log_file(osm_log_t * const p_log)
+static void truncate_log_file(osm_log_t * p_log)
 {
 	int fd = fileno(p_log->out_port);
 	if (ftruncate(fd, 0) < 0)
@@ -94,15 +94,15 @@ static void truncate_log_file(osm_log_t * const p_log)
 
 #else				/* Windows */
 
-static void truncate_log_file(osm_log_t * const p_log)
+static void truncate_log_file(osm_log_t * p_log)
 {
 	fprintf(stderr,
 		"truncate_log_file: cannot truncate on windows system (yet)\n");
 }
 #endif				/* ndef WIN32 */
 
-void osm_log(IN osm_log_t * const p_log,
-	     IN const osm_log_level_t verbosity, IN const char *p_str, ...)
+void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
+	     IN const char *p_str, ...)
 {
 	char buffer[LOG_ENTRY_SIZE_MAX];
 	va_list args;
@@ -198,8 +198,8 @@ _retry:
 	cl_spinlock_release(&p_log->lock);
 }
 
-void osm_log_raw(IN osm_log_t * const p_log,
-		 IN const osm_log_level_t verbosity, IN const char *p_buf)
+void osm_log_raw(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
+		 IN const char *p_buf)
 {
 	if (p_log->level & verbosity) {
 		cl_spinlock_acquire(&p_log->lock);
@@ -296,12 +296,10 @@ int osm_log_reopen_file(osm_log_t * p_log)
 	return ret;
 }
 
-ib_api_status_t osm_log_init_v2(IN osm_log_t * const p_log,
-				IN const boolean_t flush,
-				IN const uint8_t log_flags,
-				IN const char *log_file,
-				IN const unsigned long max_size,
-				IN const boolean_t accum_log_file)
+ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
+				IN uint8_t log_flags, IN const char *log_file,
+				IN unsigned long max_size,
+				IN boolean_t accum_log_file)
 {
 	p_log->level = log_flags;
 	p_log->flush = flush;
@@ -326,11 +324,9 @@ ib_api_status_t osm_log_init_v2(IN osm_log_t * const p_log,
 		return IB_ERROR;
 }
 
-ib_api_status_t osm_log_init(IN osm_log_t * const p_log,
-			     IN const boolean_t flush,
-			     IN const uint8_t log_flags,
-			     IN const char *log_file,
-			     IN const boolean_t accum_log_file)
+ib_api_status_t osm_log_init(IN osm_log_t * p_log, IN boolean_t flush,
+			     IN uint8_t log_flags, IN const char *log_file,
+			     IN boolean_t accum_log_file)
 {
 	return osm_log_init_v2(p_log, flush, log_flags, log_file, 0,
 			       accum_log_file);
diff --git a/opensm/opensm/osm_mad_pool.c b/opensm/opensm/osm_mad_pool.c
index 56a2a6d..96f62ff 100644
--- a/opensm/opensm/osm_mad_pool.c
+++ b/opensm/opensm/osm_mad_pool.c
@@ -52,7 +52,7 @@
 
 /**********************************************************************
  **********************************************************************/
-void osm_mad_pool_construct(IN osm_mad_pool_t * const p_pool)
+void osm_mad_pool_construct(IN osm_mad_pool_t * p_pool)
 {
 	CL_ASSERT(p_pool);
 
@@ -61,14 +61,14 @@ void osm_mad_pool_construct(IN osm_mad_pool_t * const p_pool)
 
 /**********************************************************************
  **********************************************************************/
-void osm_mad_pool_destroy(IN osm_mad_pool_t * const p_pool)
+void osm_mad_pool_destroy(IN osm_mad_pool_t * p_pool)
 {
 	CL_ASSERT(p_pool);
 }
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * const p_pool)
+ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * p_pool)
 {
 	p_pool->mads_out = 0;
 
@@ -77,10 +77,10 @@ ib_api_status_t osm_mad_pool_init(IN osm_mad_pool_t * const p_pool)
 
 /**********************************************************************
  **********************************************************************/
-osm_madw_t *osm_mad_pool_get(IN osm_mad_pool_t * const p_pool,
+osm_madw_t *osm_mad_pool_get(IN osm_mad_pool_t * p_pool,
 			     IN osm_bind_handle_t h_bind,
-			     IN const uint32_t total_size,
-			     IN const osm_mad_addr_t * const p_mad_addr)
+			     IN uint32_t total_size,
+			     IN const osm_mad_addr_t * p_mad_addr)
 {
 	osm_madw_t *p_madw;
 	ib_mad_t *p_mad;
@@ -120,11 +120,11 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-osm_madw_t *osm_mad_pool_get_wrapper(IN osm_mad_pool_t * const p_pool,
+osm_madw_t *osm_mad_pool_get_wrapper(IN osm_mad_pool_t * p_pool,
 				     IN osm_bind_handle_t h_bind,
-				     IN const uint32_t total_size,
-				     IN const ib_mad_t * const p_mad,
-				     IN const osm_mad_addr_t * const p_mad_addr)
+				     IN uint32_t total_size,
+				     IN const ib_mad_t * p_mad,
+				     IN const osm_mad_addr_t * p_mad_addr)
 {
 	osm_madw_t *p_madw;
 
@@ -152,7 +152,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * const p_pool)
+osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * p_pool)
 {
 	osm_madw_t *p_madw;
 
@@ -169,8 +169,7 @@ osm_madw_t *osm_mad_pool_get_wrapper_raw(IN osm_mad_pool_t * const p_pool)
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_mad_pool_put(IN osm_mad_pool_t * const p_pool, IN osm_madw_t * const p_madw)
+void osm_mad_pool_put(IN osm_mad_pool_t * p_pool, IN osm_madw_t * p_madw)
 {
 	CL_ASSERT(p_madw);
 
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 029a735..dc5e5f3 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -53,9 +53,8 @@
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_mcast_tbl_init(IN osm_mcast_tbl_t * const p_tbl,
-		   IN uint8_t const num_ports, IN uint16_t const capacity)
+ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
+				   IN uint8_t num_ports, IN uint16_t capacity)
 {
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(num_ports);
@@ -106,16 +105,15 @@ osm_mcast_tbl_init(IN osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * const p_tbl)
+void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl)
 {
 	free(p_tbl->p_mask_tbl);
 }
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_mcast_tbl_set(IN osm_mcast_tbl_t * const p_tbl,
-		  IN const uint16_t mlid_ho, IN const uint8_t port)
+void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
+		       IN uint8_t port)
 {
 	uintn_t mlid_offset;
 	uintn_t mask_offset;
@@ -140,9 +138,8 @@ osm_mcast_tbl_set(IN osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * const p_tbl,
-		      IN const uint16_t mlid_ho, IN const uint8_t port_num)
+boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
+				IN uint16_t mlid_ho, IN uint8_t port_num)
 {
 	uintn_t mlid_offset;
 	uintn_t mask_offset;
@@ -170,9 +167,8 @@ osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * const p_tbl,
-			  IN const uint16_t mlid_ho)
+boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
+				    IN uint16_t mlid_ho)
 {
 	uintn_t mlid_offset;
 	uint8_t position;
@@ -195,10 +191,10 @@ osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * const p_tbl,
-			IN const ib_net16_t * const p_block,
-			IN const int16_t block_num, IN const uint8_t position)
+ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN const ib_net16_t * p_block,
+					IN int16_t block_num,
+					IN uint8_t position)
 {
 	uint32_t i;
 	uint16_t mlid_start_ho;
@@ -228,9 +224,7 @@ osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * const p_tbl,
-			 IN const uint16_t mlid_ho)
+void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 {
 	uint8_t i;
 	uintn_t mlid_offset;
@@ -247,11 +241,9 @@ osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * const p_tbl,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * const p_tbl,
-			IN int16_t const block_num,
-			IN uint8_t const position,
-			OUT ib_net16_t * const p_block)
+boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
+				  IN int16_t block_num, IN uint8_t position,
+				  OUT ib_net16_t * p_block)
 {
 	uint32_t i;
 	uint16_t mlid_start_ho;
diff --git a/opensm/opensm/osm_mcm_port.c b/opensm/opensm/osm_mcm_port.c
index 56065e6..171f395 100644
--- a/opensm/opensm/osm_mcm_port.c
+++ b/opensm/opensm/osm_mcm_port.c
@@ -71,7 +71,7 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp,
 
 /**********************************************************************
  **********************************************************************/
-void osm_mcm_port_delete(IN osm_mcm_port_t * const p_mcm)
+void osm_mcm_port_delete(IN osm_mcm_port_t * p_mcm)
 {
 	CL_ASSERT(p_mcm);
 	free(p_mcm);
diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index a674514..064d792 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -75,7 +75,7 @@ void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp)
 	free(p_mgrp);
 }
 
-osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid, IN ib_member_rec_t * mcmr)
+osm_mgrp_t *osm_mgrp_new(IN ib_net16_t mlid, IN ib_member_rec_t * mcmr)
 {
 	osm_mgrp_t *p_mgrp;
 
@@ -277,7 +277,7 @@ void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 /**********************************************************************
  **********************************************************************/
 osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
-				      IN const ib_net64_t port_guid)
+				      IN ib_net64_t port_guid)
 {
 	cl_map_item_t *item = cl_qmap_get(&p_mgrp->mcm_port_tbl, port_guid);
 	if (item != cl_qmap_end(&p_mgrp->mcm_port_tbl))
diff --git a/opensm/opensm/osm_node.c b/opensm/opensm/osm_node.c
index ee2fbed..d7a6e9d 100644
--- a/opensm/opensm/osm_node.c
+++ b/opensm/opensm/osm_node.c
@@ -51,8 +51,8 @@
 
 /**********************************************************************
  **********************************************************************/
-void osm_node_init_physp(IN osm_node_t * const p_node, uint8_t port_num,
-			 IN const osm_madw_t * const p_madw)
+void osm_node_init_physp(IN osm_node_t * p_node, uint8_t port_num,
+			 IN const osm_madw_t * p_madw)
 {
 	ib_net64_t port_guid;
 	ib_smp_t *p_smp;
@@ -73,7 +73,7 @@ void osm_node_init_physp(IN osm_node_t * const p_node, uint8_t port_num,
 
 /**********************************************************************
  **********************************************************************/
-osm_node_t *osm_node_new(IN const osm_madw_t * const p_madw)
+osm_node_t *osm_node_new(IN const osm_madw_t * p_madw)
 {
 	osm_node_t *p_node;
 	ib_smp_t *p_smp;
@@ -145,7 +145,7 @@ static void osm_node_destroy(IN osm_node_t * p_node)
 
 /**********************************************************************
  **********************************************************************/
-void osm_node_delete(IN OUT osm_node_t ** const p_node)
+void osm_node_delete(IN OUT osm_node_t ** p_node)
 {
 	CL_ASSERT(p_node && *p_node);
 	osm_node_destroy(*p_node);
@@ -155,11 +155,8 @@ void osm_node_delete(IN OUT osm_node_t ** const p_node)
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_node_link(IN osm_node_t * const p_node,
-	      IN const uint8_t port_num,
-	      IN osm_node_t * const p_remote_node,
-	      IN const uint8_t remote_port_num)
+void osm_node_link(IN osm_node_t * p_node, IN uint8_t port_num,
+		   IN osm_node_t * p_remote_node, IN uint8_t remote_port_num)
 {
 	osm_physp_t *p_physp;
 	osm_physp_t *p_remote_physp;
@@ -180,11 +177,8 @@ osm_node_link(IN osm_node_t * const p_node,
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_node_unlink(IN osm_node_t * const p_node,
-		IN const uint8_t port_num,
-		IN osm_node_t * const p_remote_node,
-		IN const uint8_t remote_port_num)
+void osm_node_unlink(IN osm_node_t * p_node, IN uint8_t port_num,
+		     IN osm_node_t * p_remote_node, IN uint8_t remote_port_num)
 {
 	osm_physp_t *p_physp;
 	osm_physp_t *p_remote_physp;
@@ -205,11 +199,9 @@ osm_node_unlink(IN osm_node_t * const p_node,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_node_link_exists(IN osm_node_t * const p_node,
-		     IN const uint8_t port_num,
-		     IN osm_node_t * const p_remote_node,
-		     IN const uint8_t remote_port_num)
+boolean_t osm_node_link_exists(IN osm_node_t * p_node, IN uint8_t port_num,
+			       IN osm_node_t * p_remote_node,
+			       IN uint8_t remote_port_num)
 {
 	osm_physp_t *p_physp;
 	osm_physp_t *p_remote_physp;
@@ -225,11 +217,10 @@ osm_node_link_exists(IN osm_node_t * const p_node,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_node_link_has_valid_ports(IN osm_node_t * const p_node,
-			      IN const uint8_t port_num,
-			      IN osm_node_t * const p_remote_node,
-			      IN const uint8_t remote_port_num)
+boolean_t osm_node_link_has_valid_ports(IN osm_node_t * p_node,
+					IN uint8_t port_num,
+					IN osm_node_t * p_remote_node,
+					IN uint8_t remote_port_num)
 {
 	osm_physp_t *p_physp;
 	osm_physp_t *p_remote_physp;
@@ -245,8 +236,7 @@ osm_node_link_has_valid_ports(IN osm_node_t * const p_node,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_node_has_any_link(IN osm_node_t * const p_node, IN const uint8_t port_num)
+boolean_t osm_node_has_any_link(IN osm_node_t * p_node, IN uint8_t port_num)
 {
 	osm_physp_t *p_physp;
 	CL_ASSERT(port_num < p_node->physp_tbl_size);
@@ -256,8 +246,8 @@ osm_node_has_any_link(IN osm_node_t * const p_node, IN const uint8_t port_num)
 
 /**********************************************************************
  **********************************************************************/
-osm_node_t *osm_node_get_remote_node(IN osm_node_t * const p_node,
-				     IN const uint8_t port_num,
+osm_node_t *osm_node_get_remote_node(IN osm_node_t * p_node,
+				     IN uint8_t port_num,
 				     OUT uint8_t * p_remote_port_num)
 {
 	osm_physp_t *p_physp;
@@ -278,9 +268,8 @@ osm_node_t *osm_node_get_remote_node(IN osm_node_t * const p_node,
 /**********************************************************************
  The lock must be held before calling this function.
 **********************************************************************/
-ib_net16_t
-osm_node_get_remote_base_lid(IN osm_node_t * const p_node,
-			     IN const uint32_t port_num)
+ib_net16_t osm_node_get_remote_base_lid(IN osm_node_t * p_node,
+					IN uint32_t port_num)
 {
 	osm_physp_t *p_physp;
 	osm_physp_t *p_remote_physp;
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index 50d1349..1f2b067 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -209,7 +209,7 @@ static void setup_routing_engines(osm_opensm_t *osm, const char *engine_names)
 
 /**********************************************************************
  **********************************************************************/
-void osm_opensm_construct(IN osm_opensm_t * const p_osm)
+void osm_opensm_construct(IN osm_opensm_t * p_osm)
 {
 	memset(p_osm, 0, sizeof(*p_osm));
 	p_osm->osm_version = OSM_VERSION;
@@ -251,7 +251,7 @@ static void destroy_plugins(osm_opensm_t *osm)
 	}
 }
 
-void osm_opensm_destroy(IN osm_opensm_t * const p_osm)
+void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 {
 	/* in case of shutdown through exit proc - no ^C */
 	osm_exit_flag = TRUE;
@@ -335,9 +335,8 @@ static void load_plugins(osm_opensm_t *osm, const char *plugin_names)
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_opensm_init(IN osm_opensm_t * const p_osm,
-		IN const osm_subn_opt_t * const p_opt)
+ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
+				IN const osm_subn_opt_t * p_opt)
 {
 	ib_api_status_t status;
 
@@ -454,8 +453,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_opensm_bind(IN osm_opensm_t * const p_osm, IN const ib_net64_t guid)
+ib_api_status_t osm_opensm_bind(IN osm_opensm_t * p_osm, IN ib_net64_t guid)
 {
 	ib_api_status_t status;
 
diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr.c
index ecfdbda..f95610e 100644
--- a/opensm/opensm/osm_perfmgr.c
+++ b/opensm/opensm/osm_perfmgr.c
@@ -242,7 +242,7 @@ Exit:
 /**********************************************************************
  * Bind the PerfMgr to the vendor layer for MAD sends/receives
  **********************************************************************/
-ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, const ib_net64_t port_guid)
+ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
 {
 	osm_bind_info_t bind_info;
 	ib_api_status_t status = IB_SUCCESS;
diff --git a/opensm/opensm/osm_pkey.c b/opensm/opensm/osm_pkey.c
index ea918d6..6075b6a 100644
--- a/opensm/opensm/osm_pkey.c
+++ b/opensm/opensm/osm_pkey.c
@@ -303,7 +303,7 @@ static boolean_t match_pkey(IN const ib_net16_t * pkey1,
  **********************************************************************/
 boolean_t osm_physp_share_this_pkey(IN const osm_physp_t * p_physp1,
 				    IN const osm_physp_t * p_physp2,
-				    IN const ib_net16_t pkey)
+				    IN ib_net16_t pkey)
 {
 	ib_net16_t *pkey1, *pkey2;
 
@@ -417,7 +417,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-boolean_t osm_physp_has_pkey(IN osm_log_t * p_log, IN const ib_net16_t pkey,
+boolean_t osm_physp_has_pkey(IN osm_log_t * p_log, IN ib_net16_t pkey,
 			     IN const osm_physp_t * p_physp)
 {
 
diff --git a/opensm/opensm/osm_port.c b/opensm/opensm/osm_port.c
index 79a8913..198dab9 100644
--- a/opensm/opensm/osm_port.c
+++ b/opensm/opensm/osm_port.c
@@ -87,9 +87,9 @@ void osm_physp_destroy(IN osm_physp_t * p_physp)
 
 /**********************************************************************
  **********************************************************************/
-void osm_physp_init(IN osm_physp_t * p_physp, IN const ib_net64_t port_guid,
-		    IN uint8_t port_num, IN const struct osm_node *const p_node,
-		    IN const osm_bind_handle_t h_bind, IN uint8_t hop_count,
+void osm_physp_init(IN osm_physp_t * p_physp, IN ib_net64_t port_guid,
+		    IN uint8_t port_num, IN const struct osm_node *p_node,
+		    IN osm_bind_handle_t h_bind, IN uint8_t hop_count,
 		    IN const uint8_t * p_initial_path)
 {
 	uint16_t num_slvl, i;
diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index 80b54cc..1821397 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -54,13 +54,12 @@
 #include <opensm/osm_sa.h>
 #include <opensm/osm_multicast.h>
 
-extern int osm_prtn_config_parse_file(osm_log_t * const p_log,
-				      osm_subn_t * const p_subn,
+extern int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 				      const char *file_name);
 
 static uint16_t global_pkey_counter;
 
-osm_prtn_t *osm_prtn_new(IN const char *name, IN const uint16_t pkey)
+osm_prtn_t *osm_prtn_new(IN const char *name, IN uint16_t pkey)
 {
 	osm_prtn_t *p = malloc(sizeof(*p));
 	if (!p)
@@ -82,7 +81,7 @@ osm_prtn_t *osm_prtn_new(IN const char *name, IN const uint16_t pkey)
 	return p;
 }
 
-void osm_prtn_delete(IN OUT osm_prtn_t ** const pp_prtn)
+void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn)
 {
 	osm_prtn_t *p = *pp_prtn;
 
@@ -313,8 +312,8 @@ osm_prtn_t *osm_prtn_make_new(osm_log_t * p_log, osm_subn_t * p_subn,
 	return p;
 }
 
-static ib_api_status_t osm_prtn_make_default(osm_log_t * const p_log,
-					     osm_subn_t * const p_subn,
+static ib_api_status_t osm_prtn_make_default(osm_log_t * p_log,
+					     osm_subn_t * p_subn,
 					     boolean_t no_config)
 {
 	ib_api_status_t status = IB_UNKNOWN_ERROR;
@@ -338,8 +337,7 @@ _err:
 	return status;
 }
 
-ib_api_status_t osm_prtn_make_partitions(osm_log_t * const p_log,
-					 osm_subn_t * const p_subn)
+ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 {
 	struct stat statbuf;
 	const char *file_name;
diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 95e420e..a85ccd4 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -2268,7 +2268,7 @@ number_from_range_2:  TK_NUMBER {
 /***************************************************
  ***************************************************/
 
-int osm_qos_parse_policy_file(IN osm_subn_t * const p_subn)
+int osm_qos_parse_policy_file(IN osm_subn_t * p_subn)
 {
     int res = 0;
     static boolean_t first_time = TRUE;
diff --git a/opensm/opensm/osm_remote_sm.c b/opensm/opensm/osm_remote_sm.c
index 96bfd78..9550492 100644
--- a/opensm/opensm/osm_remote_sm.c
+++ b/opensm/opensm/osm_remote_sm.c
@@ -49,24 +49,22 @@
 
 /**********************************************************************
  **********************************************************************/
-void osm_remote_sm_construct(IN osm_remote_sm_t * const p_sm)
+void osm_remote_sm_construct(IN osm_remote_sm_t * p_sm)
 {
 	memset(p_sm, 0, sizeof(*p_sm));
 }
 
 /**********************************************************************
  **********************************************************************/
-void osm_remote_sm_destroy(IN osm_remote_sm_t * const p_sm)
+void osm_remote_sm_destroy(IN osm_remote_sm_t * p_sm)
 {
 	memset(p_sm, 0, sizeof(*p_sm));
 }
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_remote_sm_init(IN osm_remote_sm_t * const p_sm,
-		   IN const osm_port_t * const p_port,
-		   IN const ib_sm_info_t * const p_smi)
+void osm_remote_sm_init(IN osm_remote_sm_t * p_sm, IN const osm_port_t * p_port,
+			IN const ib_sm_info_t * p_smi)
 {
 	CL_ASSERT(p_sm);
 	CL_ASSERT(p_port);
diff --git a/opensm/opensm/osm_req.c b/opensm/opensm/osm_req.c
index f79e3ab..0c97ad7 100644
--- a/opensm/opensm/osm_req.c
+++ b/opensm/opensm/osm_req.c
@@ -60,12 +60,10 @@
 /**********************************************************************
   The plock MAY or MAY NOT be held before calling this function.
 **********************************************************************/
-ib_api_status_t osm_req_get(IN osm_sm_t * sm,
-			    IN const osm_dr_path_t * const p_path,
-			    IN const ib_net16_t attr_id,
-			    IN const ib_net32_t attr_mod,
-			    IN const cl_disp_msgid_t err_msg,
-			    IN const osm_madw_context_t * const p_context)
+ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN cl_disp_msgid_t err_msg,
+			    IN const osm_madw_context_t * p_context)
 {
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
@@ -124,20 +122,18 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm,
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
-	return (status);
+	return status;
 }
 
 /**********************************************************************
   The plock MAY or MAY NOT be held before calling this function.
 **********************************************************************/
-ib_api_status_t osm_req_set(IN osm_sm_t * sm,
-			    IN const osm_dr_path_t * const p_path,
-			    IN const uint8_t * const p_payload,
-			    IN const size_t payload_size,
-			    IN const ib_net16_t attr_id,
-			    IN const ib_net32_t attr_mod,
-			    IN const cl_disp_msgid_t err_msg,
-			    IN const osm_madw_context_t * const p_context)
+ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+			    IN const uint8_t * p_payload,
+			    IN size_t payload_size,
+			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN cl_disp_msgid_t err_msg,
+			    IN const osm_madw_context_t * p_context)
 {
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
@@ -199,7 +195,7 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm,
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
-	return (status);
+	return status;
 }
 
 int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
diff --git a/opensm/opensm/osm_resp.c b/opensm/opensm/osm_resp.c
index 9cd44f5..1e3a474 100644
--- a/opensm/opensm/osm_resp.c
+++ b/opensm/opensm/osm_resp.c
@@ -58,12 +58,11 @@
 
 /**********************************************************************
  **********************************************************************/
-static void
-osm_resp_make_resp_smp(IN osm_sm_t * sm,
-		       IN const ib_smp_t * const p_src_smp,
-		       IN const ib_net16_t status,
-		       IN const uint8_t * const p_payload,
-		       OUT ib_smp_t * const p_dest_smp)
+static void osm_resp_make_resp_smp(IN osm_sm_t * sm,
+				   IN const ib_smp_t * p_src_smp,
+				   IN ib_net16_t status,
+				   IN const uint8_t * p_payload,
+				   OUT ib_smp_t * p_dest_smp)
 {
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -98,11 +97,10 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_resp_send(IN osm_sm_t * sm,
-	      IN const osm_madw_t * const p_req_madw,
-	      IN const ib_net16_t mad_status,
-	      IN const uint8_t * const p_payload)
+ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
+			      IN const osm_madw_t * p_req_madw,
+			      IN ib_net16_t mad_status,
+			      IN const uint8_t * p_payload)
 {
 	const ib_smp_t *p_req_smp;
 	ib_smp_t *p_smp;
@@ -153,5 +151,5 @@ osm_resp_send(IN osm_sm_t * sm,
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
-	return (status);
+	return status;
 }
diff --git a/opensm/opensm/osm_router.c b/opensm/opensm/osm_router.c
index cb5a236..51467a3 100644
--- a/opensm/opensm/osm_router.c
+++ b/opensm/opensm/osm_router.c
@@ -51,7 +51,7 @@
 
 /**********************************************************************
  **********************************************************************/
-void osm_router_delete(IN OUT osm_router_t ** const pp_rtr)
+void osm_router_delete(IN OUT osm_router_t ** pp_rtr)
 {
 	free(*pp_rtr);
 	*pp_rtr = NULL;
@@ -59,17 +59,17 @@ void osm_router_delete(IN OUT osm_router_t ** const pp_rtr)
 
 /**********************************************************************
  **********************************************************************/
-osm_router_t *osm_router_new(IN osm_port_t * const p_port)
+osm_router_t *osm_router_new(IN osm_port_t * p_port)
 {
 	osm_router_t *p_rtr;
 
 	CL_ASSERT(p_port);
 
-	p_rtr = (osm_router_t *) malloc(sizeof(*p_rtr));
+	p_rtr = malloc(sizeof(*p_rtr));
 	if (p_rtr) {
 		memset(p_rtr, 0, sizeof(*p_rtr));
 		p_rtr->p_port = p_port;
 	}
 
-	return (p_rtr);
+	return p_rtr;
 }
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index b1a3d5e..a124a45 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -92,7 +92,7 @@ extern void osm_sr_rcv_lease_cb(IN void *context);
 
 /**********************************************************************
  **********************************************************************/
-void osm_sa_construct(IN osm_sa_t * const p_sa)
+void osm_sa_construct(IN osm_sa_t * p_sa)
 {
 	memset(p_sa, 0, sizeof(*p_sa));
 	p_sa->state = OSM_SA_STATE_INIT;
@@ -103,7 +103,7 @@ void osm_sa_construct(IN osm_sa_t * const p_sa)
 
 /**********************************************************************
  **********************************************************************/
-void osm_sa_shutdown(IN osm_sa_t * const p_sa)
+void osm_sa_shutdown(IN osm_sa_t * p_sa)
 {
 	ib_api_status_t status;
 	OSM_LOG_ENTER(p_sa->p_log);
@@ -140,7 +140,7 @@ void osm_sa_shutdown(IN osm_sa_t * const p_sa)
 
 /**********************************************************************
  **********************************************************************/
-void osm_sa_destroy(IN osm_sa_t * const p_sa)
+void osm_sa_destroy(IN osm_sa_t * p_sa)
 {
 	OSM_LOG_ENTER(p_sa->p_log);
 
@@ -153,15 +153,11 @@ void osm_sa_destroy(IN osm_sa_t * const p_sa)
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_sa_init(IN osm_sm_t * const p_sm,
-	    IN osm_sa_t * const p_sa,
-	    IN osm_subn_t * const p_subn,
-	    IN osm_vendor_t * const p_vendor,
-	    IN osm_mad_pool_t * const p_mad_pool,
-	    IN osm_log_t * const p_log,
-	    IN osm_stats_t * const p_stats,
-	    IN cl_dispatcher_t * const p_disp, IN cl_plock_t * const p_lock)
+ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
+			    IN osm_subn_t * p_subn, IN osm_vendor_t * p_vendor,
+			    IN osm_mad_pool_t * p_mad_pool,
+			    IN osm_log_t * p_log, IN osm_stats_t * p_stats,
+			    IN cl_dispatcher_t * p_disp, IN cl_plock_t * p_lock)
 {
 	ib_api_status_t status;
 
@@ -177,11 +173,9 @@ osm_sa_init(IN osm_sm_t * const p_sm,
 
 	p_sa->state = OSM_SA_STATE_READY;
 
-	status = osm_sa_mad_ctrl_init(&p_sa->mad_ctrl,
-				      p_sa,
-				      p_sa->p_mad_pool,
-				      p_sa->p_vendor,
-				      p_subn, p_log, p_stats, p_disp);
+	status = osm_sa_mad_ctrl_init(&p_sa->mad_ctrl, p_sa, p_sa->p_mad_pool,
+				      p_sa->p_vendor, p_subn, p_log, p_stats,
+				      p_disp);
 	if (status != IB_SUCCESS)
 		goto Exit;
 
@@ -296,8 +290,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t
-osm_sa_bind(IN osm_sa_t * const p_sa, IN const ib_net64_t port_guid)
+ib_api_status_t osm_sa_bind(IN osm_sa_t * p_sa, IN ib_net64_t port_guid)
 {
 	ib_api_status_t status;
 
@@ -314,12 +307,11 @@ osm_sa_bind(IN osm_sa_t * const p_sa, IN const ib_net64_t port_guid)
 
 Exit:
 	OSM_LOG_EXIT(p_sa->p_log);
-	return (status);
+	return status;
 }
 
-ib_api_status_t osm_sa_send(osm_sa_t *sa,
-			    IN osm_madw_t * const p_madw,
-			    IN boolean_t const resp_expected)
+ib_api_status_t osm_sa_send(osm_sa_t *sa, IN osm_madw_t * p_madw,
+			    IN boolean_t resp_expected)
 {
 	ib_api_status_t status;
 
@@ -334,10 +326,8 @@ ib_api_status_t osm_sa_send(osm_sa_t *sa,
 	return status;
 }
 
-void
-osm_sa_send_error(IN osm_sa_t * sa,
-		  IN const osm_madw_t * const p_madw,
-		  IN const ib_net16_t sa_status)
+void osm_sa_send_error(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
+		       IN ib_net16_t sa_status)
 {
 	osm_madw_t *p_resp_madw;
 	ib_sa_mad_t *p_resp_sa_mad;
diff --git a/opensm/opensm/osm_sa_mad_ctrl.c b/opensm/opensm/osm_sa_mad_ctrl.c
index 135c666..f22411b 100644
--- a/opensm/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/opensm/osm_sa_mad_ctrl.c
@@ -506,7 +506,7 @@ Exit:
 /**********************************************************************
  **********************************************************************/
 ib_api_status_t osm_sa_mad_ctrl_bind(IN osm_sa_mad_ctrl_t * p_ctrl,
-				     IN const ib_net64_t port_guid)
+				     IN ib_net64_t port_guid)
 {
 	osm_bind_info_t bind_info;
 	ib_api_status_t status = IB_SUCCESS;
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index bd4245b..c80dae7 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -888,7 +888,7 @@ osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_sa_t * sa, IN ib_gid_t * p_mgid)
 ib_api_status_t osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
 						     IN ib_net64_t comp_mask,
 						     IN ib_member_rec_t *
-						     const p_recvd_mcmember_rec,
+						     p_recvd_mcmember_rec,
 						     OUT osm_mgrp_t ** pp_mgrp)
 {
 	osm_mgrp_t *mgrp;
diff --git a/opensm/opensm/osm_service.c b/opensm/opensm/osm_service.c
index cc834b2..bf7df52 100644
--- a/opensm/opensm/osm_service.c
+++ b/opensm/opensm/osm_service.c
@@ -49,16 +49,15 @@
 
 /**********************************************************************
  **********************************************************************/
-void osm_svcr_delete(IN osm_svcr_t * const p_svcr)
+void osm_svcr_delete(IN osm_svcr_t * p_svcr)
 {
 	free(p_svcr);
 }
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_svcr_init(IN osm_svcr_t * const p_svcr,
-	      IN const ib_service_record_t * p_svc_rec)
+void osm_svcr_init(IN osm_svcr_t * p_svcr,
+		   IN const ib_service_record_t * p_svc_rec)
 {
 	CL_ASSERT(p_svcr);
 
@@ -85,47 +84,38 @@ osm_svcr_t *osm_svcr_new(IN const ib_service_record_t * p_svc_rec)
 		osm_svcr_init(p_svcr, p_svc_rec);
 	}
 
-	return (p_svcr);
+	return p_svcr;
 }
 
 /**********************************************************************
  **********************************************************************/
-static
-    cl_status_t
-match_rid_of_svc_rec(IN const cl_list_item_t * const p_list_item,
-		     IN void *context)
+static cl_status_t match_rid_of_svc_rec(IN const cl_list_item_t * p_list_item,
+					IN void *context)
 {
 	ib_service_record_t *p_svc_rec = (ib_service_record_t *) context;
 	osm_svcr_t *p_svcr = (osm_svcr_t *) p_list_item;
-	int32_t count;
 
-	count = memcmp(&p_svcr->service_record,
-		       p_svc_rec,
-		       sizeof(p_svc_rec->service_id) +
-		       sizeof(p_svc_rec->service_gid) +
-		       sizeof(p_svc_rec->service_pkey));
-
-	if (count == 0)
-		return CL_SUCCESS;
-	else
+	if (memcmp(&p_svcr->service_record, p_svc_rec,
+		   sizeof(p_svc_rec->service_id) +
+		   sizeof(p_svc_rec->service_gid) +
+		   sizeof(p_svc_rec->service_pkey)))
 		return CL_NOT_FOUND;
-
+	else
+		return CL_SUCCESS;
 }
 
 /**********************************************************************
  **********************************************************************/
 osm_svcr_t *osm_svcr_get_by_rid(IN osm_subn_t const *p_subn,
 				IN osm_log_t * p_log,
-				IN ib_service_record_t * const p_svc_rec)
+				IN ib_service_record_t * p_svc_rec)
 {
 	cl_list_item_t *p_list_item;
 
 	OSM_LOG_ENTER(p_log);
 
 	p_list_item = cl_qlist_find_from_head(&p_subn->sa_sr_list,
-					      match_rid_of_svc_rec,
-					      p_svc_rec);
-
+					      match_rid_of_svc_rec, p_svc_rec);
 	if (p_list_item == cl_qlist_end(&p_subn->sa_sr_list))
 		p_list_item = NULL;
 
@@ -135,9 +125,8 @@ osm_svcr_t *osm_svcr_get_by_rid(IN osm_subn_t const *p_subn,
 
 /**********************************************************************
  **********************************************************************/
-void
-osm_svcr_insert_to_db(IN osm_subn_t * p_subn,
-		      IN osm_log_t * p_log, IN osm_svcr_t * p_svcr)
+void osm_svcr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			   IN osm_svcr_t * p_svcr)
 {
 	OSM_LOG_ENTER(p_log);
 
@@ -149,9 +138,8 @@ osm_svcr_insert_to_db(IN osm_subn_t * p_subn,
 	OSM_LOG_EXIT(p_log);
 }
 
-void
-osm_svcr_remove_from_db(IN osm_subn_t * p_subn,
-			IN osm_log_t * p_log, IN osm_svcr_t * p_svcr)
+void osm_svcr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			     IN osm_svcr_t * p_svcr)
 {
 	OSM_LOG_ENTER(p_log);
 
diff --git a/opensm/opensm/osm_sm.c b/opensm/opensm/osm_sm.c
index 6eaee0d..f780124 100644
--- a/opensm/opensm/osm_sm.c
+++ b/opensm/opensm/osm_sm.c
@@ -92,7 +92,7 @@ static void sm_process(osm_sm_t * sm, osm_signal_t signal)
 static void sm_sweeper(IN void *p_ptr)
 {
 	ib_api_status_t status;
-	osm_sm_t *const p_sm = (osm_sm_t *) p_ptr;
+	osm_sm_t * p_sm = p_ptr;
 	unsigned signals, i;
 
 	OSM_LOG_ENTER(p_sm->p_log);
@@ -420,7 +420,7 @@ void osm_sm_sweep(IN osm_sm_t * p_sm)
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_sm_bind(IN osm_sm_t * p_sm, IN const ib_net64_t port_guid)
+ib_api_status_t osm_sm_bind(IN osm_sm_t * p_sm, IN ib_net64_t port_guid)
 {
 	ib_api_status_t status;
 
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index c211bf8..f96aff4 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -863,7 +863,7 @@ Exit:
 /**********************************************************************
  **********************************************************************/
 ib_api_status_t osm_sm_mad_ctrl_bind(IN osm_sm_mad_ctrl_t * p_ctrl,
-				     IN const ib_net64_t port_guid)
+				     IN ib_net64_t port_guid)
 {
 	osm_bind_info_t bind_info;
 	ib_api_status_t status = IB_SUCCESS;
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 97b62c2..647950e 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -402,7 +402,7 @@ static long compar_mgids(const void *m1, const void *m2)
 	return memcmp(m1, m2, sizeof(ib_gid_t));
 }
 
-void osm_subn_construct(IN osm_subn_t * const p_subn)
+void osm_subn_construct(IN osm_subn_t * p_subn)
 {
 	memset(p_subn, 0, sizeof(*p_subn));
 	cl_ptr_vector_construct(&p_subn->port_lid_tbl);
@@ -420,7 +420,7 @@ void osm_subn_construct(IN osm_subn_t * const p_subn)
 
 /**********************************************************************
  **********************************************************************/
-void osm_subn_destroy(IN osm_subn_t * const p_subn)
+void osm_subn_destroy(IN osm_subn_t * p_subn)
 {
 	int i;
 	osm_node_t *p_node, *p_next_node;
@@ -501,9 +501,8 @@ void osm_subn_destroy(IN osm_subn_t * const p_subn)
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_subn_init(IN osm_subn_t * const p_subn,
-			      IN osm_opensm_t * const p_osm,
-			      IN const osm_subn_opt_t * const p_opt)
+ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
+			      IN const osm_subn_opt_t * p_opt)
 {
 	cl_status_t status;
 
@@ -536,7 +535,7 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * const p_subn,
 	/* we assume master by default - so we only need to set it true if STANDBY */
 	p_subn->coming_out_of_standby = FALSE;
 
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -573,7 +572,7 @@ ib_api_status_t osm_get_gid_by_mad_addr(IN osm_log_t * p_log,
 					IN osm_mad_addr_t * p_mad_addr,
 					OUT ib_gid_t * p_gid)
 {
-	const osm_port_t *p_port = NULL;
+	const osm_port_t *p_port;
 
 	if (p_gid == NULL) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 7505: "
@@ -595,7 +594,7 @@ osm_physp_t *osm_get_physp_by_mad_addr(IN osm_log_t * p_log,
 				       IN const osm_subn_t * p_subn,
 				       IN osm_mad_addr_t * p_mad_addr)
 {
-	osm_port_t *p_port = NULL;
+	osm_port_t *p_port;
 
 	p_port = osm_get_port_by_mad_addr(p_log, p_subn, p_mad_addr);
 	if (!p_port)
@@ -681,7 +680,7 @@ static void subn_init_qos_options(osm_qos_options_t *opt, osm_qos_options_t *f)
 
 /**********************************************************************
  **********************************************************************/
-void osm_subn_set_default_opt(IN osm_subn_opt_t * const p_opt)
+void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 {
 	memset(p_opt, 0, sizeof(osm_subn_opt_t));
 	p_opt->guid = 0;
@@ -823,7 +822,7 @@ static int subn_dump_qos_options(FILE * file, const char *set_name,
 
 /**********************************************************************
  **********************************************************************/
-static ib_api_status_t append_prefix_route(IN osm_subn_t * const p_subn,
+static ib_api_status_t append_prefix_route(IN osm_subn_t * p_subn,
 					   uint64_t prefix, uint64_t guid)
 {
 	osm_prefix_route_t *route;
@@ -840,7 +839,7 @@ static ib_api_status_t append_prefix_route(IN osm_subn_t * const p_subn,
 	return IB_SUCCESS;
 }
 
-static ib_api_status_t osm_parse_prefix_routes_file(IN osm_subn_t * const p_subn)
+static ib_api_status_t osm_parse_prefix_routes_file(IN osm_subn_t * p_subn)
 {
 	osm_log_t *log = &p_subn->p_osm->log;
 	FILE *fp;
@@ -1066,7 +1065,7 @@ static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix,
 	subn_verify_sl2vl(&set->sl2vl, prefix, dflt->sl2vl);
 }
 
-int osm_subn_verify_config(IN osm_subn_opt_t * const p_opts)
+int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 {
 	if (p_opts->lmc > 7) {
 		log_report(" Invalid Cached Option Value:lmc = %u:"
@@ -1156,7 +1155,7 @@ int osm_subn_verify_config(IN osm_subn_opt_t * const p_opts)
 
 /**********************************************************************
  **********************************************************************/
-int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * const p_opts)
+int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 {
 	char line[1024];
 	FILE *opts_file;
@@ -1208,7 +1207,7 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * const p_opts)
 	return 0;
 }
 
-int osm_subn_rescan_conf_files(IN osm_subn_t * const p_subn)
+int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 {
 	char line[1024];
 	osm_subn_opt_t *p_opts = &p_subn->opt;
@@ -1271,7 +1270,7 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * const p_subn)
 
 /**********************************************************************
  **********************************************************************/
-int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t *const p_opts)
+int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 {
 	fprintf(out,
 		"#\n# DEVICE ATTRIBUTES OPTIONS\n#\n"
@@ -1647,7 +1646,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t *const p_opts)
 	return 0;
 }
 
-int osm_subn_write_conf_file(char *file_name, IN osm_subn_opt_t *const p_opts)
+int osm_subn_write_conf_file(char *file_name, IN osm_subn_opt_t * p_opts)
 {
 	FILE *opts_file;
 
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index 8a83523..ad1018f 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -53,10 +53,8 @@
 
 /**********************************************************************
  **********************************************************************/
-cl_status_t
-osm_switch_set_hops(IN osm_switch_t * const p_sw,
-		    IN const uint16_t lid_ho,
-		    IN const uint8_t port_num, IN const uint8_t num_hops)
+cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
+				IN uint8_t port_num, IN uint8_t num_hops)
 {
 	if (lid_ho > p_sw->max_lid_ho)
 		return -1;
@@ -76,7 +74,7 @@ osm_switch_set_hops(IN osm_switch_t * const p_sw,
 
 /**********************************************************************
  **********************************************************************/
-void osm_switch_delete(IN OUT osm_switch_t ** const pp_sw)
+void osm_switch_delete(IN OUT osm_switch_t ** pp_sw)
 {
 	osm_switch_t *p_sw = *pp_sw;
 	unsigned i;
@@ -100,8 +98,8 @@ void osm_switch_delete(IN OUT osm_switch_t ** const pp_sw)
 
 /**********************************************************************
  **********************************************************************/
-osm_switch_t *osm_switch_new(IN osm_node_t * const p_node,
-			     IN const osm_madw_t * const p_madw)
+osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
+			     IN const osm_madw_t * p_madw)
 {
 	osm_switch_t *p_sw;
 	ib_switch_info_t *p_si;
@@ -160,10 +158,8 @@ err:
 
 /**********************************************************************
  **********************************************************************/
-boolean_t
-osm_switch_get_lft_block(IN const osm_switch_t * const p_sw,
-			 IN const uint16_t block_id,
-			 OUT uint8_t * const p_block)
+boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
+				   IN uint16_t block_id, OUT uint8_t * p_block)
 {
 	uint16_t base_lid_ho = block_id * IB_SMP_DATA_SIZE;
 
@@ -181,11 +177,10 @@ osm_switch_get_lft_block(IN const osm_switch_t * const p_sw,
 /**********************************************************************
  **********************************************************************/
 static struct osm_remote_node *
-osm_switch_find_guid_common(IN const osm_switch_t * const p_sw,
+osm_switch_find_guid_common(IN const osm_switch_t * p_sw,
 			    IN struct osm_remote_guids_count *r,
 			    IN uint8_t port_num,
-			    IN int find_sys_guid,
-			    IN int find_node_guid)
+			    IN int find_sys_guid, IN int find_node_guid)
 {
 	struct osm_remote_node *p_remote_guid = NULL;
 	osm_physp_t *p_physp;
@@ -217,7 +212,7 @@ osm_switch_find_guid_common(IN const osm_switch_t * const p_sw,
 }
 
 static struct osm_remote_node *
-osm_switch_find_sys_guid_count(IN const osm_switch_t * const p_sw,
+osm_switch_find_sys_guid_count(IN const osm_switch_t * p_sw,
 			       IN struct osm_remote_guids_count *r,
 			       IN uint8_t port_num)
 {
@@ -225,7 +220,7 @@ osm_switch_find_sys_guid_count(IN const osm_switch_t * const p_sw,
 }
 
 static struct osm_remote_node *
-osm_switch_find_node_guid_count(IN const osm_switch_t * const p_sw,
+osm_switch_find_node_guid_count(IN const osm_switch_t * p_sw,
 				IN struct osm_remote_guids_count *r,
 				IN uint8_t port_num)
 {
@@ -234,13 +229,11 @@ osm_switch_find_node_guid_count(IN const osm_switch_t * const p_sw,
 
 /**********************************************************************
  **********************************************************************/
-uint8_t
-osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
-			  IN osm_port_t * p_port,
-			  IN const uint16_t lid_ho,
-			  IN unsigned start_from,
-			  IN const boolean_t ignore_existing,
-			  IN const boolean_t dor)
+uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
+				  IN osm_port_t * p_port, IN uint16_t lid_ho,
+				  IN unsigned start_from,
+				  IN boolean_t ignore_existing,
+				  IN boolean_t dor)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -306,7 +299,7 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 
 	least_hops = osm_switch_get_least_hops(p_sw, base_lid);
 	if (least_hops == OSM_NO_PATH)
-		return (OSM_NO_PATH);
+		return OSM_NO_PATH;
 
 	/*
 	   First, inquire with the forwarding table for an existing
@@ -346,7 +339,7 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 				   hop function.
 				 */
 				if (hops == least_hops)
-					return (port_num);
+					return port_num;
 			}
 		}
 	}
@@ -475,7 +468,7 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 	}
 
 	if (port_found == FALSE)
-		return (OSM_NO_PATH);
+		return OSM_NO_PATH;
 
 	/*
 	   if we are in enhanced routing mode and the best port is not
@@ -489,7 +482,7 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 			best_port = best_port_other_node;
 	}
 
-	return (best_port);
+	return best_port;
 }
 
 /**********************************************************************
@@ -505,8 +498,7 @@ void osm_switch_clear_hops(IN osm_switch_t * p_sw)
 
 /**********************************************************************
  **********************************************************************/
-int
-osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids)
+int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids)
 {
 	uint8_t **hops;
 	unsigned i;
@@ -545,9 +537,8 @@ osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids)
 
 /**********************************************************************
  **********************************************************************/
-uint8_t
-osm_switch_get_port_least_hops(IN const osm_switch_t * const p_sw,
-			       IN const osm_port_t * p_port)
+uint8_t osm_switch_get_port_least_hops(IN const osm_switch_t * p_sw,
+				       IN const osm_port_t * p_port)
 {
 	uint16_t lid;
 
@@ -572,11 +563,10 @@ osm_switch_get_port_least_hops(IN const osm_switch_t * const p_sw,
 
 /**********************************************************************
  **********************************************************************/
-uint8_t
-osm_switch_recommend_mcast_path(IN osm_switch_t * const p_sw,
-				IN osm_port_t * p_port,
-				IN uint16_t const mlid_ho,
-				IN boolean_t const ignore_existing)
+uint8_t osm_switch_recommend_mcast_path(IN osm_switch_t * p_sw,
+					IN osm_port_t * p_port,
+					IN uint16_t mlid_ho,
+					IN boolean_t ignore_existing)
 {
 	uint16_t base_lid;
 	uint8_t hops;
@@ -623,7 +613,7 @@ osm_switch_recommend_mcast_path(IN osm_switch_t * const p_sw,
 			hops =
 			    osm_switch_get_hop_count(p_sw, base_lid, port_num);
 			if (hops != OSM_NO_PATH)
-				return (port_num);
+				return port_num;
 		}
 	}
 
@@ -648,5 +638,5 @@ osm_switch_recommend_mcast_path(IN osm_switch_t * const p_sw,
 			break;
 
 	CL_ASSERT(port_num < num_ports);
-	return (port_num);
+	return port_num;
 }
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 39d825c..be37df9 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -108,7 +108,7 @@ ib_api_status_t osm_ucast_mgr_init(IN osm_ucast_mgr_t * p_mgr, IN osm_sm_t * sm)
 static void ucast_mgr_process_hop_0_1(IN cl_map_item_t * p_map_item,
 				      IN void *context)
 {
-	osm_switch_t *const p_sw = (osm_switch_t *) p_map_item;
+	osm_switch_t * p_sw = (osm_switch_t *) p_map_item;
 	osm_node_t *p_remote_node;
 	uint16_t lid, remote_lid;
 	uint8_t i;
@@ -135,8 +135,8 @@ static void ucast_mgr_process_hop_0_1(IN cl_map_item_t * p_map_item,
 static void ucast_mgr_process_neighbor(IN osm_ucast_mgr_t * p_mgr,
 				       IN osm_switch_t * p_this_sw,
 				       IN osm_switch_t * p_remote_sw,
-				       IN const uint8_t port_num,
-				       IN const uint8_t remote_port_num)
+				       IN uint8_t port_num,
+				       IN uint8_t remote_port_num)
 {
 	osm_switch_t *p_sw;
 	cl_map_item_t *item;
@@ -184,8 +184,7 @@ static void ucast_mgr_process_neighbor(IN osm_ucast_mgr_t * p_mgr,
  **********************************************************************/
 static struct osm_remote_node *find_and_add_remote_sys(osm_switch_t * sw,
 						       uint8_t port,
-						       const boolean_t dor,
-						       struct
+						       boolean_t dor, struct
 						       osm_remote_guids_count
 						       *r)
 {
@@ -361,7 +360,7 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
 				  IN void *context)
 {
 	osm_ucast_mgr_t *p_mgr = context;
-	osm_switch_t *const p_sw = (osm_switch_t *) p_map_item;
+	osm_switch_t * p_sw = (osm_switch_t *) p_map_item;
 	unsigned i, lids_per_port;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
@@ -404,8 +403,8 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
 static void ucast_mgr_process_neighbors(IN cl_map_item_t * p_map_item,
 					IN void *context)
 {
-	osm_switch_t *const p_sw = (osm_switch_t *) p_map_item;
-	osm_ucast_mgr_t *const p_mgr = (osm_ucast_mgr_t *) context;
+	osm_switch_t * p_sw = (osm_switch_t *) p_map_item;
+	osm_ucast_mgr_t * p_mgr = context;
 	osm_node_t *p_node;
 	osm_node_t *p_remote_node;
 	uint32_t port_num;
@@ -797,7 +796,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 				  IN void *cxt)
 {
 	osm_ucast_mgr_t *p_mgr = cxt;
-	osm_switch_t *const p_sw = (osm_switch_t *) p_map_item;
+	osm_switch_t * p_sw = (osm_switch_t *) p_map_item;
 	osm_node_t *p_node;
 	osm_dr_path_t *p_path;
 	osm_madw_context_t context;
diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index 43095c9..9e43a9c 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -113,7 +113,7 @@ static void vl15_poller(IN void *p_ptr)
 {
 	ib_api_status_t status;
 	osm_madw_t *p_madw;
-	osm_vl15_t *const p_vl = (osm_vl15_t *) p_ptr;
+	osm_vl15_t *p_vl = p_ptr;
 	cl_qlist_t *p_fifo;
 
 	OSM_LOG_ENTER(p_vl->p_log);
@@ -244,7 +244,7 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
  **********************************************************************/
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
-			      IN const int32_t max_wire_smps)
+			      IN int32_t max_wire_smps)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
-- 
1.6.5.rc1

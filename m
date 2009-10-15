From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: add force_link_speed_file config option.
Date: Thu, 15 Oct 2009 13:26:50 -0700
Message-ID: <20091015132650.6e8b8dde.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 14 Oct 2009 16:09:25 -0700
Subject: [PATCH] opensm: add force_link_speed_file config option.

	From the config file help:

	# Optional file used to override individual port GUIDs and speeds to be forced.
	# Port GUIDs which are _not_ listed in this file will be set to "force_link_speed"
	# Speeds specified in this file may be higher or lower than the global
	# setting (force_link_speed) above
	# File Format:
	# # comment
	# <port_guid> [<setting>] [# comment]
	# ...
	# if the optional <setting> is not specified the default (15) will be used

This option along with the force_link_speed option can be used to override the
PortInfo:LinkSpeedSupported option for hardware which is not operating
properly.  Previously one could only force a singe speed across a fabric.  With
this option one can set speeds on an individual node basis.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/include/opensm/osm_base.h   |   10 ++++
 opensm/include/opensm/osm_sm.h     |    1 +
 opensm/include/opensm/osm_subnet.h |    6 ++
 opensm/opensm/osm_link_mgr.c       |   22 +++++++-
 opensm/opensm/osm_sm.c             |    2 +
 opensm/opensm/osm_subnet.c         |   99 +++++++++++++++++++++++++++++++++++-
 6 files changed, 135 insertions(+), 5 deletions(-)

diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 06223ce..5457bc6 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -146,6 +146,16 @@ BEGIN_C_DECLS
 * SYNOPSIS
 */
 #define OSM_DEFAULT_MAX_OP_VLS 5
+/****s* OpenSM: Base/OSM_DEFAULT_FORCE_LINK_SPEED
+* NAME
+*	OSM_DEFAULT_FORCE_LINK_SPEED
+*
+* DESCRIPTION
+*	Default force link speed value
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_FORCE_LINK_SPEED 15
 /********/
 /****s* OpenSM: Base/OSM_DEFAULT_SL
 * NAME
diff --git a/opensm/include/opensm/osm_sm.h b/opensm/include/opensm/osm_sm.h
index e653d49..7086ca6 100644
--- a/opensm/include/opensm/osm_sm.h
+++ b/opensm/include/opensm/osm_sm.h
@@ -143,6 +143,7 @@ typedef struct osm_sm {
 	cl_disp_reg_handle_t slvl_disp_h;
 	cl_disp_reg_handle_t vla_disp_h;
 	cl_disp_reg_handle_t pkey_disp_h;
+	cl_map_t force_link_speed_except_guids;
 } osm_sm_t;
 /*
 * FIELDS
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 9488225..5353298 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -154,6 +154,7 @@ typedef struct osm_subn_opt {
 	boolean_t lmc_esp0;
 	uint8_t max_op_vls;
 	uint8_t force_link_speed;
+	char *force_link_speed_file;
 	boolean_t reassign_lids;
 	boolean_t ignore_other_sm;
 	boolean_t single_thread;
@@ -469,6 +470,11 @@ typedef struct osm_subn_opt {
 *	Subnet object
 *********/
 
+typedef struct force_speed_exception {
+	uint64_t port_guid;
+	uint8_t val;
+} force_speed_exception_t;
+
 /****s* OpenSM: Subnet/osm_subn_t
 * NAME
 *	osm_subn_t
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index c9bdfee..21dcc50 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -106,6 +106,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	boolean_t esp0 = FALSE, send_set = FALSE;
 	osm_physp_t *p_remote_physp;
 	int ret = 0;
+	uint8_t force_link_speed;
+	force_speed_exception_t *except;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -326,12 +328,26 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			   sizeof(p_pi->link_width_enabled)))
 			send_set = TRUE;
 
-		if (sm->p_subn->opt.force_link_speed &&
-		    (sm->p_subn->opt.force_link_speed != 15 ||
+		/* use the force link speed set in the config */
+		force_link_speed = sm->p_subn->opt.force_link_speed;
+		/* unless this port guid is in our "except"ion file */
+		if ((except = cl_map_get(
+				&sm->force_link_speed_except_guids,
+				cl_ntoh64(p_physp->port_guid)))
+					!= NULL) {
+			force_link_speed = except->val;
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+				"Skipping force_link_speed on GUID 0x%016"
+				PRIx64 " (%d)\n",
+			       cl_ntoh64(p_physp->port_guid),
+			       force_link_speed);
+		}
+
+		if (force_link_speed &&
+		     (force_link_speed != OSM_DEFAULT_FORCE_LINK_SPEED ||
 		     ib_port_info_get_link_speed_enabled(p_pi) !=
 		     ib_port_info_get_link_speed_sup(p_pi))) {
 			ib_port_info_set_link_speed_enabled(p_pi,
-							    sm->p_subn->opt.
 							    force_link_speed);
 			if (memcmp(&p_pi->link_speed, &p_old_pi->link_speed,
 				   sizeof(p_pi->link_speed)))
diff --git a/opensm/opensm/osm_sm.c b/opensm/opensm/osm_sm.c
index f780124..e5cf2b4 100644
--- a/opensm/opensm/osm_sm.c
+++ b/opensm/opensm/osm_sm.c
@@ -168,6 +168,8 @@ void osm_sm_construct(IN osm_sm_t * p_sm)
 	osm_sm_mad_ctrl_construct(&p_sm->mad_ctrl);
 	osm_lid_mgr_construct(&p_sm->lid_mgr);
 	osm_ucast_mgr_construct(&p_sm->ucast_mgr);
+	cl_map_construct(&p_sm->force_link_speed_except_guids);
+	cl_map_init(&p_sm->force_link_speed_except_guids, 10);
 }
 
 /**********************************************************************
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 647950e..6aa338f 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -46,6 +46,7 @@
 #  include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
+#include <sys/stat.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdarg.h>
@@ -305,6 +306,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_parse_boolean, NULL, 1 },
 	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_parse_uint8, NULL, 1 },
+	{ "force_link_speed_file", OPT_OFFSET(force_link_speed_file), opts_parse_charp, NULL, 1 },
 	{ "reassign_lids", OPT_OFFSET(reassign_lids), opts_parse_boolean, NULL, 1 },
 	{ "ignore_other_sm", OPT_OFFSET(ignore_other_sm), opts_parse_boolean, NULL, 1 },
 	{ "single_thread", OPT_OFFSET(single_thread), opts_parse_boolean, NULL, 0 },
@@ -700,7 +702,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lmc = OSM_DEFAULT_LMC;
 	p_opt->lmc_esp0 = FALSE;
 	p_opt->max_op_vls = OSM_DEFAULT_MAX_OP_VLS;
-	p_opt->force_link_speed = 15;
+	p_opt->force_link_speed = OSM_DEFAULT_FORCE_LINK_SPEED;
+	p_opt->force_link_speed_file = NULL;
 	p_opt->reassign_lids = FALSE;
 	p_opt->ignore_other_sm = FALSE;
 	p_opt->single_thread = FALSE;
@@ -927,6 +930,73 @@ static ib_api_status_t osm_parse_prefix_routes_file(IN osm_subn_t * p_subn)
 
 /**********************************************************************
  **********************************************************************/
+void osm_parse_force_link_speed_except_file(IN osm_opensm_t * const p_osm,
+					    IN char *file)
+{
+	FILE *fp;
+	char line[1024];
+	uint64_t guid = 0;
+	force_speed_exception_t *except = NULL;
+	cl_map_t *map = &p_osm->sm.force_link_speed_except_guids;
+	cl_map_iterator_t head;
+
+	CL_ASSERT(cl_is_map_inited(map));
+
+	/* clear previous entries */
+	head = cl_map_head(map);
+	while (head != cl_map_end(map)) {
+		except = (force_speed_exception_t *)cl_map_obj(head);
+		cl_map_remove_item(map, head);
+		free(except);
+		head = cl_map_head(map);
+	}
+
+	if (file) {
+		fp = fopen(file, "r");
+		if (!fp) {
+			osm_log(&p_osm->log, OSM_LOG_ERROR,
+				"failed to open force_link_speed_file "
+				"\'%s\'\n",
+				file);
+			return;
+		}
+
+		while (fgets(line, sizeof(line) - 1, fp) != NULL) {
+			char *p;
+			char *guid_str, *force_str;
+			unsigned long force_val;
+
+			p = strchr(line, '#');
+			if (p)
+				*p = '\0';
+
+			guid_str = strtok_r(line, " \t\n", &p);
+			if (guid_str &&
+			   ((guid = strtoull(guid_str, NULL, 0)) != 0)) {
+				except = calloc(1, sizeof *except);
+
+				force_str = strtok_r(NULL, " \t\n", &p);
+				if (force_str) {
+					force_val = strtoul(force_str, NULL, 0);
+				} else
+					force_val = OSM_DEFAULT_FORCE_LINK_SPEED;
+
+				except->port_guid = guid;
+				except->val = (uint8_t)force_val;
+				OSM_LOG(&p_osm->log, OSM_LOG_DEBUG,
+					"Setting exception to "
+					"force_link_speed on GUID 0x%016"
+					PRIx64 " (%d)\n", except->port_guid, except->val);
+				cl_map_insert(map, guid, (void *)except);
+			}
+		}
+
+		fclose(fp);
+	}
+}
+
+/**********************************************************************
+ **********************************************************************/
 static void subn_verify_max_vls(unsigned *max_vls, const char *prefix, unsigned dflt)
 {
 	if (!*max_vls || *max_vls > 15) {
@@ -1097,6 +1167,15 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
 	}
 
+	if (p_opts->force_link_speed_file) {
+		struct stat statbuf;
+		if (stat(p_opts->force_link_speed_file, &statbuf))
+			log_report(" Invalid Cached Option "
+				   "Value:force_link_speed_file = %s"
+				   "; file not found\n",
+				   p_opts->force_link_speed_file);
+	}
+
 	if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE)
 	    && strcmp(p_opts->console, OSM_LOCAL_CONSOLE)
 #ifdef ENABLE_OSM_CONSOLE_SOCKET
@@ -1265,6 +1344,9 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 
 	osm_parse_prefix_routes_file(p_subn);
 
+	osm_parse_force_link_speed_except_file(p_subn->p_osm,
+					       p_opts->force_link_speed_file);
+
 	return 0;
 }
 
@@ -1331,8 +1413,18 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#    5: 2.5 or 10.0 Gbps\n"
 		"#    7: 2.5 or 5.0 or 10.0 Gbps\n"
 		"#    2,4,6,8-14 Reserved\n"
-		"#    Default 15: set to PortInfo:LinkSpeedSupported\n"
+		"#    Default %d: set to PortInfo:LinkSpeedSupported\n"
 		"force_link_speed %u\n\n"
+		"# Optional file used to override individual port GUIDs and speeds to be forced.\n"
+		"# Port GUIDs which are _not_ listed in this file will be set to \"force_link_speed\"\n"
+		"# Speeds specified in this file may be higher or lower than the global setting\n"
+		"# (force_link_speed) above\n"
+		"# File Format:\n"
+		"# # comment\n"
+		"# <port_guid> [<setting>] [# comment]\n"
+		"# ...\n"
+		"# if the optional <setting> is not specified the default (%d) will be used\n"
+		"force_link_speed_file %s\n\n"
 		"# The subnet_timeout code that will be set for all the ports\n"
 		"# The actual timeout is 4.096usec * 2^<subnet_timeout>\n"
 		"subnet_timeout %u\n\n"
@@ -1355,7 +1447,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->head_of_queue_lifetime,
 		p_opts->leaf_head_of_queue_lifetime,
 		p_opts->max_op_vls,
+		OSM_DEFAULT_FORCE_LINK_SPEED,
 		p_opts->force_link_speed,
+		OSM_DEFAULT_FORCE_LINK_SPEED,
+		p_opts->force_link_speed_file,
 		p_opts->subnet_timeout,
 		p_opts->local_phy_errors_threshold,
 		p_opts->overrun_errors_threshold);
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

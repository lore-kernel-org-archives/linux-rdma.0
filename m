From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_helper: remove meanless 'const' keywords
Date: Thu, 1 Oct 2009 22:22:15 +0200
Message-ID: <20091001202215.GZ17846@me>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com>
 <20091001183127.GX17846@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C86E88D1@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E88D1-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In APIs remove meanless 'const' keywords related to function parameter
values. Such as:

type func(..., type * const ptr, ..., type const var, ... )

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

On 12:30 Thu 01 Oct     , Smith, Stan wrote:
> >
> > Also wouldn't it be simpler to remove 'const' in "type * const var"
> > function parameter definitions? This restricts only value of a pointer
> > (not structure content), and since function parameters are passed by
> > values such restriction is only related to a function implementation
> > and actually meanless in sense of API. Thoughts?
> 
> I'm just the messenger here, making the function match the prototype.
> Fine by me if you choose to change both.

This is a "pilot" for such cleanup. Hope it works for you.

 opensm/include/opensm/osm_helper.h |  211 +++++++++++++++---------------------
 opensm/opensm/osm_helper.c         |   66 ++++++------
 2 files changed, 121 insertions(+), 156 deletions(-)

diff --git a/opensm/include/opensm/osm_helper.h b/opensm/include/opensm/osm_helper.h
index d76af8d..ddca69b 100644
--- a/opensm/include/opensm/osm_helper.h
+++ b/opensm/include/opensm/osm_helper.h
@@ -209,12 +209,10 @@ static inline boolean_t ib_gid_is_notzero(IN const ib_gid_t * p_gid)
 *
 * SYNOPSIS
 */
-void osm_dump_port_info(IN osm_log_t * const p_log,
-			IN const ib_net64_t node_guid,
-			IN const ib_net64_t port_guid,
-			IN const uint8_t port_num,
-			IN const ib_port_info_t * const p_pi,
-			IN const osm_log_level_t log_level);
+void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+			IN ib_net64_t port_guid, IN uint8_t port_num,
+			IN const ib_port_info_t * p_pi,
+			IN osm_log_level_t log_level);
 /*
 * PARAMETERS
 *	p_log
@@ -243,89 +241,66 @@ void osm_dump_port_info(IN osm_log_t * const p_log,
 * SEE ALSO
 *********/
 
-void
-osm_dump_path_record(IN osm_log_t * const p_log,
-		     IN const ib_path_rec_t * const p_pr,
-		     IN const osm_log_level_t log_level);
-
-void
-osm_dump_multipath_record(IN osm_log_t * const p_log,
-			  IN const ib_multipath_rec_t * const p_mpr,
-			  IN const osm_log_level_t log_level);
-
-void
-osm_dump_node_record(IN osm_log_t * const p_log,
-		     IN const ib_node_record_t * const p_nr,
-		     IN const osm_log_level_t log_level);
-
-void
-osm_dump_mc_record(IN osm_log_t * const p_log,
-		   IN const ib_member_rec_t * const p_mcmr,
-		   IN const osm_log_level_t log_level);
-
-void
-osm_dump_link_record(IN osm_log_t * const p_log,
-		     IN const ib_link_record_t * const p_lr,
-		     IN const osm_log_level_t log_level);
-
-void
-osm_dump_service_record(IN osm_log_t * const p_log,
-			IN const ib_service_record_t * const p_sr,
-			IN const osm_log_level_t log_level);
-
-void
-osm_dump_portinfo_record(IN osm_log_t * const p_log,
-			 IN const ib_portinfo_record_t * const p_pir,
-			 IN const osm_log_level_t log_level);
-
-void
-osm_dump_guidinfo_record(IN osm_log_t * const p_log,
-			 IN const ib_guidinfo_record_t * const p_gir,
-			 IN const osm_log_level_t log_level);
-
-void
-osm_dump_inform_info(IN osm_log_t * const p_log,
-		     IN const ib_inform_info_t * const p_ii,
-		     IN const osm_log_level_t log_level);
-
-void
-osm_dump_inform_info_record(IN osm_log_t * const p_log,
-			    IN const ib_inform_info_record_t * const p_iir,
-			    IN const osm_log_level_t log_level);
-
-void
-osm_dump_switch_info_record(IN osm_log_t * const p_log,
-			    IN const ib_switch_info_record_t * const p_sir,
-			    IN const osm_log_level_t log_level);
-
-void
-osm_dump_sm_info_record(IN osm_log_t * const p_log,
-			IN const ib_sminfo_record_t * const p_smir,
-			IN const osm_log_level_t log_level);
-
-void
-osm_dump_pkey_block(IN osm_log_t * const p_log,
-		    IN uint64_t port_guid,
-		    IN uint16_t block_num,
-		    IN uint8_t port_num,
-		    IN const ib_pkey_table_t * const p_pkey_tbl,
-		    IN const osm_log_level_t log_level);
-
-void
-osm_dump_slvl_map_table(IN osm_log_t * const p_log,
-			IN uint64_t port_guid,
-			IN uint8_t in_port_num,
-			IN uint8_t out_port_num,
-			IN const ib_slvl_table_t * const p_slvl_tbl,
-			IN const osm_log_level_t log_level);
-
-void
-osm_dump_vl_arb_table(IN osm_log_t * const p_log,
-		      IN uint64_t port_guid,
-		      IN uint8_t block_num,
-		      IN uint8_t port_num,
-		      IN const ib_vl_arb_table_t * const p_vla_tbl,
-		      IN const osm_log_level_t log_level);
+void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
+			  IN osm_log_level_t log_level);
+
+void osm_dump_multipath_record(IN osm_log_t * p_log,
+			       IN const ib_multipath_rec_t * p_mpr,
+			       IN osm_log_level_t log_level);
+
+void osm_dump_node_record(IN osm_log_t * p_log,
+			  IN const ib_node_record_t * p_nr,
+			  IN osm_log_level_t log_level);
+
+void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
+			IN osm_log_level_t log_level);
+
+void osm_dump_link_record(IN osm_log_t * p_log,
+			  IN const ib_link_record_t * p_lr,
+			  IN osm_log_level_t log_level);
+
+void osm_dump_service_record(IN osm_log_t * p_log,
+			     IN const ib_service_record_t * p_sr,
+			     IN osm_log_level_t log_level);
+
+void osm_dump_portinfo_record(IN osm_log_t * p_log,
+			      IN const ib_portinfo_record_t * p_pir,
+			      IN osm_log_level_t log_level);
+
+void osm_dump_guidinfo_record(IN osm_log_t * p_log,
+			      IN const ib_guidinfo_record_t * p_gir,
+			      IN osm_log_level_t log_level);
+
+void osm_dump_inform_info(IN osm_log_t * p_log,
+			  IN const ib_inform_info_t * p_ii,
+			  IN osm_log_level_t log_level);
+
+void osm_dump_inform_info_record(IN osm_log_t * p_log,
+				 IN const ib_inform_info_record_t * p_iir,
+				 IN osm_log_level_t log_level);
+
+void osm_dump_switch_info_record(IN osm_log_t * p_log,
+				 IN const ib_switch_info_record_t * p_sir,
+				 IN osm_log_level_t log_level);
+
+void osm_dump_sm_info_record(IN osm_log_t * p_log,
+			     IN const ib_sminfo_record_t * p_smir,
+			     IN osm_log_level_t log_level);
+
+void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
+			 IN uint16_t block_num, IN uint8_t port_num,
+			 IN const ib_pkey_table_t * p_pkey_tbl,
+			 IN osm_log_level_t log_level);
+
+void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
+			     IN uint8_t in_port_num, IN uint8_t out_port_num,
+			     IN const ib_slvl_table_t * p_slvl_tbl,
+			     IN osm_log_level_t log_level);
+
+void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
+			   IN uint8_t block_num, IN uint8_t port_num,
+			   IN const ib_vl_arb_table_t * p_vla_tbl,
+			   IN osm_log_level_t log_level);
 
 /****f* OpenSM: Helper/osm_dump_port_info
 * NAME
@@ -336,9 +311,9 @@ osm_dump_vl_arb_table(IN osm_log_t * const p_log,
 *
 * SYNOPSIS
 */
-void osm_dump_node_info(IN osm_log_t * const p_log,
-			IN const ib_node_info_t * const p_ni,
-			IN const osm_log_level_t log_level);
+void osm_dump_node_info(IN osm_log_t * p_log,
+			IN const ib_node_info_t * p_ni,
+			IN osm_log_level_t log_level);
 /*
 * PARAMETERS
 *	p_log
@@ -367,10 +342,8 @@ void osm_dump_node_info(IN osm_log_t * const p_log,
 *
 * SYNOPSIS
 */
-void
-osm_dump_sm_info(IN osm_log_t * const p_log,
-		 IN const ib_sm_info_t * const p_smi,
-		 IN const osm_log_level_t log_level);
+void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
+		      IN osm_log_level_t log_level);
 /*
 * PARAMETERS
 *	p_log
@@ -399,10 +372,9 @@ osm_dump_sm_info(IN osm_log_t * const p_log,
 *
 * SYNOPSIS
 */
-void
-osm_dump_switch_info(IN osm_log_t * const p_log,
-		     IN const ib_switch_info_t * const p_si,
-		     IN const osm_log_level_t log_level);
+void osm_dump_switch_info(IN osm_log_t * p_log,
+			  IN const ib_switch_info_t * p_si,
+			  IN osm_log_level_t log_level);
 /*
 * PARAMETERS
 *	p_log
@@ -431,10 +403,9 @@ osm_dump_switch_info(IN osm_log_t * const p_log,
 *
 * SYNOPSIS
 */
-void
-osm_dump_notice(IN osm_log_t * const p_log,
-		IN const ib_mad_notice_attr_t * p_ntci,
-		IN const osm_log_level_t log_level);
+void osm_dump_notice(IN osm_log_t * p_log,
+		     IN const ib_mad_notice_attr_t * p_ntci,
+		     IN osm_log_level_t log_level);
 /*
 * PARAMETERS
 *	p_log
@@ -477,21 +448,17 @@ const char *osm_get_disp_msg_str(IN cl_disp_msgid_t msg);
 * SEE ALSO
 *********/
 
-void osm_dump_dr_path(IN osm_log_t * const p_log,
-		      IN const osm_dr_path_t * const p_path,
-		      IN const osm_log_level_t level);
+void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
+		      IN osm_log_level_t level);
 
-void osm_dump_smp_dr_path(IN osm_log_t * const p_log,
-			  IN const ib_smp_t * const p_smp,
-			  IN const osm_log_level_t level);
+void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
+			  IN osm_log_level_t level);
 
-void osm_dump_dr_smp(IN osm_log_t * const p_log,
-		     IN const ib_smp_t * const p_smp,
-		     IN const osm_log_level_t level);
+void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
+		     IN osm_log_level_t level);
 
-void osm_dump_sa_mad(IN osm_log_t * const p_log,
-		     IN const ib_sa_mad_t * const p_smp,
-		     IN const osm_log_level_t level);
+void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_smp,
+		     IN osm_log_level_t level);
 
 /****f* IBA Base: Types/osm_get_sm_signal_str
 * NAME
@@ -520,17 +487,17 @@ const char *osm_get_port_state_str_fixed_width(IN uint8_t port_state);
 
 const char *osm_get_node_type_str_fixed_width(IN uint8_t node_type);
 
-const char *osm_get_manufacturer_str(IN uint64_t const guid_ho);
+const char *osm_get_manufacturer_str(IN uint64_t guid_ho);
 
-const char *osm_get_mtu_str(IN uint8_t const mtu);
+const char *osm_get_mtu_str(IN uint8_t mtu);
 
-const char *osm_get_lwa_str(IN uint8_t const lwa);
+const char *osm_get_lwa_str(IN uint8_t lwa);
 
-const char *osm_get_mtu_str(IN uint8_t const mtu);
+const char *osm_get_mtu_str(IN uint8_t mtu);
 
-const char *osm_get_lwa_str(IN uint8_t const lwa);
+const char *osm_get_lwa_str(IN uint8_t lwa);
 
-const char *osm_get_lsa_str(IN uint8_t const lsa);
+const char *osm_get_lsa_str(IN uint8_t lsa);
 
 /****f* IBA Base: Types/osm_get_sm_mgr_signal_str
 * NAME
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index ea9e21f..2f45279 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -552,8 +552,7 @@ const ib_gid_t ib_zero_gid = { { 0 } };
 
 /**********************************************************************
  **********************************************************************/
-static ib_api_status_t dbg_do_line(IN char **pp_local,
-				   IN const uint32_t buf_size,
+static ib_api_status_t dbg_do_line(IN char **pp_local, IN uint32_t buf_size,
 				   IN const char *p_prefix_str,
 				   IN const char *p_new_str,
 				   IN uint32_t * p_total_len)
@@ -574,7 +573,7 @@ static ib_api_status_t dbg_do_line(IN char **pp_local,
 
 /**********************************************************************
  **********************************************************************/
-static void dbg_get_capabilities_str(IN char *p_buf, IN const uint32_t buf_size,
+static void dbg_get_capabilities_str(IN char *p_buf, IN uint32_t buf_size,
 				     IN const char *p_prefix_str,
 				     IN const ib_port_info_t * p_pi)
 {
@@ -780,11 +779,10 @@ static void dbg_get_capabilities_str(IN char *p_buf, IN const uint32_t buf_size,
 
 /**********************************************************************
  **********************************************************************/
-void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,
-			IN const ib_net64_t port_guid,
-			IN const uint8_t port_num,
+void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+			IN ib_net64_t port_guid, IN uint8_t port_num,
 			IN const ib_port_info_t * p_pi,
-			IN const osm_log_level_t log_level)
+			IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -872,7 +870,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,
  **********************************************************************/
 void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			      IN const ib_portinfo_record_t * p_pir,
-			      IN const osm_log_level_t log_level)
+			      IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -958,7 +956,7 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_guidinfo_record(IN osm_log_t * p_log,
 			      IN const ib_guidinfo_record_t * p_gir,
-			      IN const osm_log_level_t log_level)
+			      IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		const ib_guid_info_t *p_gi = &p_gir->guid_info;
@@ -996,7 +994,7 @@ void osm_dump_guidinfo_record(IN osm_log_t * p_log,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,
-			IN const osm_log_level_t log_level)
+			IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, log_level,
@@ -1032,7 +1030,7 @@ void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,
  **********************************************************************/
 void osm_dump_node_record(IN osm_log_t * p_log,
 			  IN const ib_node_record_t * p_nr,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char desc[sizeof(p_nr->node_desc.description) + 1];
@@ -1081,7 +1079,7 @@ void osm_dump_node_record(IN osm_log_t * p_log,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1131,7 +1129,7 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
  **********************************************************************/
 void osm_dump_multipath_record(IN osm_log_t * p_log,
 			       IN const ib_multipath_rec_t * p_mpr,
-			       IN const osm_log_level_t log_level)
+			       IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1194,7 +1192,7 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
-			IN const osm_log_level_t log_level)
+			IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1233,7 +1231,7 @@ void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
  **********************************************************************/
 void osm_dump_service_record(IN osm_log_t * p_log,
 			     IN const ib_service_record_t * p_sr,
-			     IN const osm_log_level_t log_level)
+			     IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1334,7 +1332,7 @@ void osm_dump_service_record(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_inform_info(IN osm_log_t * p_log,
 			  IN const ib_inform_info_t * p_ii,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		uint32_t qpn;
@@ -1395,7 +1393,7 @@ void osm_dump_inform_info(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_inform_info_record(IN osm_log_t * p_log,
 				 IN const ib_inform_info_record_t * p_iir,
-				 IN const osm_log_level_t log_level)
+				 IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1478,7 +1476,7 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_link_record(IN osm_log_t * p_log,
 			  IN const ib_link_record_t * p_lr,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, log_level,
@@ -1497,7 +1495,7 @@ void osm_dump_link_record(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_switch_info(IN osm_log_t * p_log,
 			  IN const ib_switch_info_t * p_si,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, OSM_LOG_VERBOSE,
@@ -1532,7 +1530,7 @@ void osm_dump_switch_info(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_switch_info_record(IN osm_log_t * p_log,
 				 IN const ib_switch_info_record_t * p_sir,
-				 IN const osm_log_level_t log_level)
+				 IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, log_level,
@@ -1571,7 +1569,7 @@ void osm_dump_switch_info_record(IN osm_log_t * p_log,
 void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
 			 IN uint16_t block_num, IN uint8_t port_num,
 			 IN const ib_pkey_table_t * p_pkey_tbl,
-			 IN const osm_log_level_t log_level)
+			 IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf_line[1024];
@@ -1595,7 +1593,7 @@ void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
 void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
 			     IN uint8_t in_port_num, IN uint8_t out_port_num,
 			     IN const ib_slvl_table_t * p_slvl_tbl,
-			     IN const osm_log_level_t log_level)
+			     IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf_line1[1024], buf_line2[1024];
@@ -1622,7 +1620,7 @@ void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
 void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
 			   IN uint8_t block_num, IN uint8_t port_num,
 			   IN const ib_vl_arb_table_t * p_vla_tbl,
-			   IN const osm_log_level_t log_level)
+			   IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf_line1[1024], buf_line2[1024];
@@ -1646,7 +1644,7 @@ void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
-		      IN const osm_log_level_t log_level)
+		      IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, OSM_LOG_DEBUG,
@@ -1668,7 +1666,7 @@ void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
  **********************************************************************/
 void osm_dump_sm_info_record(IN osm_log_t * p_log,
 			     IN const ib_sminfo_record_t * p_smir,
-			     IN const osm_log_level_t log_level)
+			     IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, OSM_LOG_DEBUG,
@@ -1696,7 +1694,7 @@ void osm_dump_sm_info_record(IN osm_log_t * p_log,
  **********************************************************************/
 void osm_dump_notice(IN osm_log_t * p_log,
 		     IN const ib_mad_notice_attr_t * p_ntci,
-		     IN const osm_log_level_t log_level)
+		     IN osm_log_level_t log_level)
 {
 	if (!osm_log_is_active(p_log, log_level))
 		return;
@@ -1890,7 +1888,7 @@ void osm_dump_notice(IN osm_log_t * p_log,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
-		     IN const osm_log_level_t log_level)
+		     IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -1997,7 +1995,7 @@ void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
-		     IN const osm_log_level_t log_level)
+		     IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -2060,7 +2058,7 @@ void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
-		      IN const osm_log_level_t log_level)
+		      IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -2078,7 +2076,7 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 /**********************************************************************
  **********************************************************************/
 void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
-			  IN const osm_log_level_t log_level)
+			  IN osm_log_level_t log_level)
 {
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
@@ -2200,7 +2198,7 @@ const char *osm_get_node_type_str_fixed_width(IN uint8_t node_type)
 
 /**********************************************************************
  **********************************************************************/
-const char *osm_get_manufacturer_str(IN uint64_t const guid_ho)
+const char *osm_get_manufacturer_str(IN uint64_t guid_ho)
 {
 	/* note that the max vendor string length is 11 */
 	static const char *intel_str = "Intel";
@@ -2300,7 +2298,7 @@ static const char *mtu_str_fixed_width[] = {
 
 /**********************************************************************
  **********************************************************************/
-const char *osm_get_mtu_str(IN uint8_t const mtu)
+const char *osm_get_mtu_str(IN uint8_t mtu)
 {
 	if (mtu > IB_MTU_LEN_4096)
 		return (mtu_str_fixed_width[0]);
@@ -2322,7 +2320,7 @@ static const char *lwa_str_fixed_width[] = {
 
 /**********************************************************************
  **********************************************************************/
-const char *osm_get_lwa_str(IN uint8_t const lwa)
+const char *osm_get_lwa_str(IN uint8_t lwa)
 {
 	if (lwa > 8)
 		return (lwa_str_fixed_width[0]);
@@ -2340,7 +2338,7 @@ static const char *lsa_str_fixed_width[] = {
 	"10 "
 };
 
-const char *osm_get_lsa_str(IN uint8_t const lsa)
+const char *osm_get_lsa_str(IN uint8_t lsa)
 {
 	if (lsa > 4)
 		return (lsa_str_fixed_width[0]);
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

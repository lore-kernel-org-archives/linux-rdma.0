From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] osm_helper.c match func to proto
Date: Thu, 1 Oct 2009 13:16:19 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E895E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Removed inet_ntop() (void*) cast per discussions; only prototype updates.

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index ea9e21f..f4e365b 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -780,10 +780,11 @@ static void dbg_get_capabilities_str(IN char *p_buf, IN const uint32_t buf_size,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,
+void osm_dump_port_info(IN osm_log_t * const p_log,
+                       IN const ib_net64_t node_guid,
                        IN const ib_net64_t port_guid,
                        IN const uint8_t port_num,
-                       IN const ib_port_info_t * p_pi,
+                       IN const ib_port_info_t * const p_pi,
                        IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -870,8 +871,8 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_portinfo_record(IN osm_log_t * p_log,
-                             IN const ib_portinfo_record_t * p_pir,
+void osm_dump_portinfo_record(IN osm_log_t * const p_log,
+                             IN const ib_portinfo_record_t * const p_pir,
                              IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -956,8 +957,8 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_guidinfo_record(IN osm_log_t * p_log,
-                             IN const ib_guidinfo_record_t * p_gir,
+void osm_dump_guidinfo_record(IN osm_log_t * const p_log,
+                             IN const ib_guidinfo_record_t * const p_gir,
                              IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -995,7 +996,8 @@ void osm_dump_guidinfo_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,
+void osm_dump_node_info(IN osm_log_t * const p_log,
+                       IN const ib_node_info_t * const p_ni,
                        IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1030,8 +1032,8 @@ void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_node_record(IN osm_log_t * p_log,
-                         IN const ib_node_record_t * p_nr,
+void osm_dump_node_record(IN osm_log_t * const p_log,
+                         IN const ib_node_record_t * const p_nr,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1080,7 +1082,8 @@ void osm_dump_node_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
+void osm_dump_path_record(IN osm_log_t * const p_log,
+                         IN const ib_path_rec_t * const p_pr,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1129,8 +1132,8 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_multipath_record(IN osm_log_t * p_log,
-                              IN const ib_multipath_rec_t * p_mpr,
+void osm_dump_multipath_record(IN osm_log_t * const p_log,
+                              IN const ib_multipath_rec_t * const p_mpr,
                               IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1193,7 +1196,8 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
+void osm_dump_mc_record(IN osm_log_t * const p_log,
+                       IN const ib_member_rec_t * const p_mcmr,
                        IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1231,8 +1235,8 @@ void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_service_record(IN osm_log_t * p_log,
-                            IN const ib_service_record_t * p_sr,
+void osm_dump_service_record(IN osm_log_t * const p_log,
+                            IN const ib_service_record_t * const p_sr,
                             IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1332,8 +1336,8 @@ void osm_dump_service_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_inform_info(IN osm_log_t * p_log,
-                         IN const ib_inform_info_t * p_ii,
+void osm_dump_inform_info(IN osm_log_t * const p_log,
+                         IN const ib_inform_info_t * const p_ii,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1393,8 +1397,8 @@ void osm_dump_inform_info(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_inform_info_record(IN osm_log_t * p_log,
-                                IN const ib_inform_info_record_t * p_iir,
+void osm_dump_inform_info_record(IN osm_log_t * const p_log,
+                                IN const ib_inform_info_record_t * const p_iir,
                                 IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1476,8 +1480,8 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_link_record(IN osm_log_t * p_log,
-                         IN const ib_link_record_t * p_lr,
+void osm_dump_link_record(IN osm_log_t * const p_log,
+                         IN const ib_link_record_t * const p_lr,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1495,8 +1499,8 @@ void osm_dump_link_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_switch_info(IN osm_log_t * p_log,
-                         IN const ib_switch_info_t * p_si,
+void osm_dump_switch_info(IN osm_log_t * const p_log,
+                         IN const ib_switch_info_t * const p_si,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1530,8 +1534,8 @@ void osm_dump_switch_info(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_switch_info_record(IN osm_log_t * p_log,
-                                IN const ib_switch_info_record_t * p_sir,
+void osm_dump_switch_info_record(IN osm_log_t * const p_log,
+                                IN const ib_switch_info_record_t * const p_sir,
                                 IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1568,9 +1572,9 @@ void osm_dump_switch_info_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
+void osm_dump_pkey_block(IN osm_log_t * const p_log, IN uint64_t port_guid,
                         IN uint16_t block_num, IN uint8_t port_num,
-                        IN const ib_pkey_table_t * p_pkey_tbl,
+                        IN const ib_pkey_table_t * const p_pkey_tbl,
                         IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1592,9 +1596,9 @@ void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
+void osm_dump_slvl_map_table(IN osm_log_t * const p_log, IN uint64_t port_guid,
                             IN uint8_t in_port_num, IN uint8_t out_port_num,
-                            IN const ib_slvl_table_t * p_slvl_tbl,
+                            IN const ib_slvl_table_t * const p_slvl_tbl,
                             IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1619,9 +1623,9 @@ void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
+void osm_dump_vl_arb_table(IN osm_log_t * const p_log, IN uint64_t port_guid,
                           IN uint8_t block_num, IN uint8_t port_num,
-                          IN const ib_vl_arb_table_t * p_vla_tbl,
+                          IN const ib_vl_arb_table_t * const p_vla_tbl,
                           IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1645,7 +1649,8 @@ void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
+void osm_dump_sm_info(IN osm_log_t * const p_log,
+                     IN const ib_sm_info_t * const p_smi,
                      IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1666,8 +1671,8 @@ void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_sm_info_record(IN osm_log_t * p_log,
-                            IN const ib_sminfo_record_t * p_smir,
+void osm_dump_sm_info_record(IN osm_log_t * const p_log,
+                            IN const ib_sminfo_record_t * const p_smir,
                             IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1694,7 +1699,7 @@ void osm_dump_sm_info_record(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_notice(IN osm_log_t * p_log,
+void osm_dump_notice(IN osm_log_t * const p_log,
                     IN const ib_mad_notice_attr_t * p_ntci,
                     IN const osm_log_level_t log_level)
 {
@@ -1889,7 +1894,8 @@ void osm_dump_notice(IN osm_log_t * p_log,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
+void osm_dump_dr_smp(IN osm_log_t * const p_log,
+                    IN const ib_smp_t * const p_smp,
                     IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -1996,7 +2002,8 @@ void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
+void osm_dump_sa_mad(IN osm_log_t * const p_log,
+                    IN const ib_sa_mad_t * const p_mad,
                     IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -2059,7 +2066,8 @@ void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
+void osm_dump_dr_path(IN osm_log_t * const p_log,
+                     IN const osm_dr_path_t * const p_path,
                      IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
@@ -2077,7 +2085,8 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,

 /**********************************************************************
  **********************************************************************/
-void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
+void osm_dump_smp_dr_path(IN osm_log_t * const p_log,
+                         IN const ib_smp_t * const p_smp,
                          IN const osm_log_level_t log_level)
 {
        if (osm_log_is_active(p_log, log_level)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

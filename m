From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v2 04/15] opensm: Track the minimum value in the fabric
 of data VLs supported.
Date: Wed, 10 Mar 2010 11:06:46 -0700
Message-ID: <1268244416-20351-5-git-send-email-jaschut@sandia.gov>
References: <1268244416-20351-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268244416-20351-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A routing engine that wants to make contributions to SL2VL maps in support
of routing free from credit loops may need to know the minimum number
of supported data VLs in the fabric.

This code tracks that value.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    1 +
 opensm/opensm/osm_port_info_rcv.c  |   13 ++++++++++++-
 opensm/opensm/osm_state_mgr.c      |    6 ++++++
 opensm/opensm/osm_subnet.c         |    1 +
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 3970e98..d74a57c 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -520,6 +520,7 @@ typedef struct osm_subn {
 	uint16_t max_mcast_lid_ho;
 	uint8_t min_ca_mtu;
 	uint8_t min_ca_rate;
+	uint8_t min_data_vls;
 	boolean_t ignore_existing_lfts;
 	boolean_t subnet_initialization_error;
 	boolean_t force_heavy_sweep;
diff --git a/opensm/opensm/osm_port_info_rcv.c b/opensm/opensm/osm_port_info_rcv.c
index 9260047..c05301e 100644
--- a/opensm/opensm/osm_port_info_rcv.c
+++ b/opensm/opensm/osm_port_info_rcv.c
@@ -83,6 +83,7 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 	ib_api_status_t status;
 	ib_net64_t port_guid;
 	uint8_t rate, mtu;
+	unsigned data_vls;
 	cl_qmap_t *p_sm_tbl;
 	osm_remote_sm_t *p_sm;
 
@@ -92,7 +93,7 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 
 	/* HACK extended port 0 should be handled too! */
 	if (osm_physp_get_port_num(p_physp) != 0) {
-		/* track the minimal endport MTU and rate */
+		/* track the minimal endport MTU, rate, and operational VLs */
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 		if (mtu < sm->p_subn->min_ca_mtu) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
@@ -108,6 +109,16 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 				PRIx64 "\n", rate, cl_ntoh64(port_guid));
 			sm->p_subn->min_ca_rate = rate;
 		}
+
+		data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+		if (data_vls >= IB_MAX_NUM_VLS)
+			data_vls = IB_MAX_NUM_VLS - 1;
+		if ((uint8_t)data_vls < sm->p_subn->min_data_vls) {
+			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+				"Setting endport minimal data VLs to:%u defined by port:0x%"
+				PRIx64 "\n", data_vls, cl_ntoh64(port_guid));
+			sm->p_subn->min_data_vls = data_vls;
+		}
 	}
 
 	if (port_guid != sm->p_subn->sm_port_guid) {
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 6fcccba..96ad348 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1164,6 +1164,12 @@ repeat_discovery:
 	sm->p_subn->force_reroute = FALSE;
 	sm->p_subn->subnet_initialization_error = FALSE;
 
+	/* Reset tracking values in case limiting component got removed
+	 * from fabric. */
+	sm->p_subn->min_ca_mtu = IB_MAX_MTU;
+	sm->p_subn->min_ca_rate = IB_MAX_RATE;
+	sm->p_subn->min_data_vls = IB_MAX_NUM_VLS - 1;
+
 	/* rescan configuration updates */
 	if (!config_parsed && osm_subn_rescan_conf_files(sm->p_subn) < 0)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 331A: "
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index e4126bc..55b9384 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -525,6 +525,7 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 	p_subn->max_mcast_lid_ho = IB_LID_MCAST_END_HO;
 	p_subn->min_ca_mtu = IB_MAX_MTU;
 	p_subn->min_ca_rate = IB_MAX_RATE;
+	p_subn->min_data_vls = IB_MAX_NUM_VLS - 1;
 	p_subn->ignore_existing_lfts = TRUE;
 
 	/* we assume master by default - so we only need to set it true if STANDBY */
-- 
1.6.6.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

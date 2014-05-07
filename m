From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_port_info_rcv.c: Fixed calculation of min_data_vls
Date: Wed, 07 May 2014 09:25:04 -0400
Message-ID: <536A3430.5060605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 13 Apr 2014 15:26:47 +0300

Bug description:
	opensm is not using future value of op_vls when calculating subnet's minimal op_vl. opensm calculates
	minimal op_vls (sm->p_subn->min_data_vl) when receiving pi mads, and the linkmgr might update that
	port's op_vls according to it's vl_cap. as a result, routing engines that depends on the minimal
	op_vls (such as torus) might fail on the first heavy sweep. for example, if in the fabric there is a port
	with op_vls = 1. vl_cap = 5, peer port vl_cap = 5. tours routing engine would fail on first sweep.

Fix: now the calculation is done respective to vl_cap and max_op_vls

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index eb68dbf..9707496 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -115,7 +115,9 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 			sm->p_subn->min_ca_rate = rate;
 		}
 
-		data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+		data_vls = 1U << (ib_port_info_get_vl_cap(p_pi) - 1);
+		if (data_vls > sm->p_subn->opt.max_op_vls)
+			data_vls = sm->p_subn->opt.max_op_vls;
 		if (data_vls >= IB_MAX_NUM_VLS)
 			data_vls = IB_MAX_NUM_VLS - 1;
 		if ((uint8_t)data_vls < sm->p_subn->min_data_vls) {
@@ -416,7 +418,9 @@ static void pi_rcv_process_switch_ext_port(IN osm_sm_t * sm,
 	if (p_remote_physp) {
 		p_remote_node = osm_physp_get_node_ptr(p_remote_physp);
 		if (p_remote_node->sw) {
-			data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+			data_vls = 1U << (ib_port_info_get_vl_cap(p_pi) - 1);
+			if (data_vls > sm->p_subn->opt.max_op_vls)
+				data_vls = sm->p_subn->opt.max_op_vls;
 			if (data_vls >= IB_MAX_NUM_VLS)
 				data_vls = IB_MAX_NUM_VLS - 1;
 			if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

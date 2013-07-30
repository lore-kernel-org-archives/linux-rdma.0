From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_path_record.c: Fix rate setting issue in SA
 PR handling
Date: Tue, 30 Jul 2013 11:13:06 -0400
Message-ID: <51F7D802.9070208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


For switch egress ports, fix rate setting for an extended speed port

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_path_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 02aeb9f..e7ac607 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -385,7 +385,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 					  ib_port_info_compute_rate(p_pi,
 								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
 			rate = ib_port_info_compute_rate(p_pi,
-							 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 		if (sa->p_subn->opt.qos) {
 			/*
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

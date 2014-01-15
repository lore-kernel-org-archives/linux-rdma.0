From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 4/4] osm_trap_rcv.c: Removed unneeded lock when disabling
 port
Date: Wed, 15 Jan 2014 15:29:07 -0500
Message-ID: <52D6EF93.7030105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 0ff054ae2f6e53e9e908f72f23b35cb40b3aeab4 Mon Sep 17 00:00:00 2001
From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 5 May 2013 12:20:40 +0300
Subject: [PATCH 4/4] osm_trap_rcv.c: Removed unneeded lock when disabling
 port

When disabling a noisy port, read-lock was taken twice.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 2623536..472083d 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -258,13 +258,11 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 		pi->master_sm_base_lid = sm->p_subn->sm_base_lid;
 	}
 
-	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
 			   payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
 			   cl_hton32(osm_physp_get_port_num(p)),
 			   FALSE, m_key,
 			   CL_DISP_MSGID_NONE, &context);
-	CL_PLOCK_RELEASE(sm->p_lock);
 	return status;
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 3/4] osm_trap_rcv.c: Minimize time holding RW lock
 for, SystemImageGUID changed trap 145
Date: Wed, 15 Jan 2014 15:28:55 -0500
Message-ID: <52D6EF87.6000705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From e7c4ec39fff6c6c243ac57434eb8f8bbe6f783f8 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 15 Nov 2012 18:09:57 +0200
Subject: [PATCH 3/4] osm_trap_rcv.c: Minimize time holding RW lock for
 SystemImageGUID changed trap 145

Release RW lock after updating SystemImageGUID and reacquire RO lock

Found-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 27f3e4a..2623536 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -566,6 +566,8 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 				p_physp->p_node->node_info.sys_guid =
 					p_ntci->data_details.ntc_145.new_sys_guid;
 			}
+			CL_PLOCK_RELEASE(sm->p_lock);
+			CL_PLOCK_ACQUIRE(sm->p_lock);
 		} else
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 				"ERR 3813: No physical port found for "
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

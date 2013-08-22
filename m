From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_trap_rcv.c: Fix locking in aging callback
Date: Thu, 22 Aug 2013 10:31:06 -0400
Message-ID: <521620AA.5030906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Callback execution should be under read lock as it accesses global data.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 4e59a17..6a7936d 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -115,6 +115,8 @@ static uint64_t aging_tracker_callback(IN uint64_t key, IN uint32_t num_regs,
 	lid = (ib_net16_t) ((key & 0x0000FFFF00000000ULL) >> 32);
 	port_num = (uint8_t) ((key & 0x00FF000000000000ULL) >> 48);
 
+	CL_PLOCK_ACQUIRE(sm->p_lock);
+
 	p_physp = get_physp_by_lid_and_num(sm, lid, port_num);
 	if (!p_physp) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
@@ -140,5 +142,6 @@ static uint64_t aging_tracker_callback(IN uint64_t key, IN uint32_t num_regs,
 	}
 
+	CL_PLOCK_RELEASE(sm->p_lock);
 	OSM_LOG_EXIT(sm->p_log);
 
 	/* We want to remove the event from the tracker - so
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

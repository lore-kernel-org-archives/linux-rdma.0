From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0 - ucm: cleanup CM debug warning messages
Date: Mon, 2 Aug 2010 11:30:50 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010FE6D303@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index b874c8b..05b5af5 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -165,9 +165,9 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		if ((time - cm->timer)/1000 > 
 		    (cm->hca->ib_trans.rep_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
-				 " CM_REQ retry %d %p [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x Time(ms) %llu > %llu\n", 
-				 cm, cm->retries, ntohs(cm->msg.saddr.ib.lid), 
+				 " CM_REQ retry %p %d [lid, port, qpn]:"
+				 " %x %x %x -> %x %x %x Time(ms) %llu > %d\n", 
+				 cm, cm->retries+1, ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn), 
 				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
 				 ntohl(cm->msg.dqpn), (time - cm->timer)/1000, 
@@ -184,8 +184,8 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		    (cm->hca->ib_trans.rtu_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_REPLY retry %d [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %llu\n", 
-				 cm->retries,
+				 " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %d\n", 
+				 cm->retries+1,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
 				 ntohl(cm->msg.saddr.ib.qpn), 
@@ -194,7 +194,8 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 ntohl(cm->msg.daddr.ib.qpn),  
 				 ntohl(*(DAT_UINT32*)cm->msg.resv),
 				 ntohl(*(DAT_UINT32*)cm->msg.resv), 
-				 (time - cm->timer)/1000, cm->hca->ib_trans.rtu_time << cm->retries);
+				 (time - cm->timer)/1000, 
+				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
 			dapl_os_unlock(&cm->lock);
 			ucm_reply(cm);
@@ -208,8 +209,8 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		    (cm->hca->ib_trans.rtu_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_DREQ retry %d [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %llu\n", 
-				 cm->retries,
+				 " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %d\n", 
+				 cm->retries+1,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
 				 ntohl(cm->msg.saddr.ib.qpn), 
@@ -218,7 +219,8 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 ntohl(cm->msg.dqpn), 
 				 ntohl(*(DAT_UINT32*)cm->msg.resv),
 				 ntohl(*(DAT_UINT32*)cm->msg.resv), 
-				 (time - cm->timer)/1000, cm->hca->ib_trans.rtu_time << cm->retries);
+				 (time - cm->timer)/1000, 
+				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_state_mgr.c: Start sweep immedeately when
 recieving HANDOVER in DISCOVERING state
Date: Tue, 5 Feb 2013 16:30:17 +0200
Message-ID: <20130205143017.GE13151@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Dorfman <eli.dorfman-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of waiting fo sweep_interval to expire, start the sweep
imeediately. That can speed-up SM bring up.

Found-by: Eli Dorfman <eli.dorfman-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sm_state_mgr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 7da8258..c996ea2 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -294,11 +294,13 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			break;
 		case OSM_SM_SIGNAL_HANDOVER:
 			/*
-			 * Do nothing. We will discover it later on. If we already discovered
-			 * this SM, and got the HANDOVER - this means the remote SM is of
-			 * lower priority. In this case we will stop polling it (since it is
-			 * a lower priority SM in STANDBY state).
+			 * Signal for a new sweep. We need to discover the other SM.
+			 * If we already discovered this SM, and got the
+			 * HANDOVER - this means the remote SM is of lower priority.
+			 * In this case we will stop polling it (since it is a lower
+			 * priority SM in STANDBY state).
 			 */
+			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
 		default:
 			sm_state_mgr_signal_error(sm, signal);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

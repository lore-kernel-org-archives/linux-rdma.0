From: "Dorfman, Eli" <Eli.Dorfman-mb1K0bWo544@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_sm_state_mgr.c: Start sweep immedeately when
 recieving HANDOVER in DISCOVERING state
Date: Tue, 5 Feb 2013 10:10:50 -0500
Message-ID: <58D7FA4D54027743B71E05095945B961016359C3FE@MX42A.corp.emc.com>
References: <20130205143017.GE13151@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130205143017.GE13151-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for the fast response and update.
Which opensm & OFED versions will include this fix?

Note that my email has changed to emc.com - please update.
Thanks again,
Eli
________________________________________
From: Alex Netes [alexne-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] On Behalf Of Alex Netes [alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
Sent: Tuesday, February 05, 2013 4:30 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Dorfman
Subject: [PATCH] opensm/osm_sm_state_mgr.c: Start sweep immedeately when recieving HANDOVER in DISCOVERING state

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
-                        * Do nothing. We will discover it later on. If we already discovered
-                        * this SM, and got the HANDOVER - this means the remote SM is of
-                        * lower priority. In this case we will stop polling it (since it is
-                        * a lower priority SM in STANDBY state).
+                        * Signal for a new sweep. We need to discover the other SM.
+                        * If we already discovered this SM, and got the
+                        * HANDOVER - this means the remote SM is of lower priority.
+                        * In this case we will stop polling it (since it is a lower
+                        * priority SM in STANDBY state).
                         */
+                       osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
                        break;
                default:
                        sm_state_mgr_signal_error(sm, signal);
--
1.7.11.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

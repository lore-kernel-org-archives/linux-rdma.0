From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 02/12] opensm: torus-2QoS should fail to route if
 message deadlock is possible.
Date: Fri, 18 Dec 2009 13:50:52 -0700
Message-ID: <1261169461-2516-3-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The whole point of torus-2QoS is to provide deadlock-free routing
for a torus while enabling two quality of service levels.  The
ability to route around a failed switch provides a window to
repair the fabric with minimal impact to running applications.

So if the possibility of mesage deadlock is detected due to
the topology of missing switches, torus-2QoS should fail
to route.

Users of torus-2QoS can either configure multiple routing
algorithms, so another algorithm with different properties can
attempt to route the fabric, or configure no fallback algorithm
so that the last good torus-2QoS tables are left in the switches.

None of the alternatives are great:
- Having torus-2QoS route the fabric even though the missing
    switch topology allows message deadlock means applications
    may encounter poor performance due to message deadlock.
- Having another engine route the fabric means that any
    application that doesn't repath may trigger message deadlock
    due to inconsistencies between path SL values in use and
    path SL values required by the new engine for deadlock-free
    routing.
- Leaving the last good torus-2QoS tables in the switches means
    that traffic through the newly failed switch cannot be
    delivered.

It isn't clear which of these options has the least impact on
running applications, but the operational imperative is clear:
failures in a torus fabric routed with torus-2QoS need to be
repaired ASAP.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 7108394..bc87757 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -7659,10 +7659,12 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 		}
 
-	if (t->flags & MSG_DEADLOCK)
+	if (t->flags & MSG_DEADLOCK) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Warning: missing switch topology "
-			"==> message deadlock possible!\n");
+			"Error: missing switch topology "
+			"==> message deadlock!\n");
+		success = false;
+	}
 	return success;
 }
 
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

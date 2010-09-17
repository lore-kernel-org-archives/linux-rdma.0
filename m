From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_torus.c: Add check for invalid topology
 discovery due to user misconfiguration.
Date: Fri, 17 Sep 2010 11:03:13 -0600
Message-ID: <1284742994-24503-2-git-send-email-jaschut@sandia.gov>
References: <1284742994-24503-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284742994-24503-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock found a way to make torus-2QoS seg fault: when
the fabric contains a torus dimension with radix 4, but the
configuration info in torus-2QoS.conf didn't say so.  This
patch detects the result of such misconfiguration, and warns.

Tested-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 0b7741d..12b480d 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -1623,6 +1623,22 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 		return true;
 
 	fsw = tsw->tmp;
+	/*
+	 * link_srcsink is supposed to get called once for every switch in
+	 * the fabric.  At this point every fsw we encounter must have a
+	 * non-null osm_switch.  Otherwise something has gone horribly
+	 * wrong with topology discovery; the most likely reason is that
+	 * the fabric contains a radix-4 torus dimension, but the user gave
+	 * a config that didn't say so, breaking all the checking in
+	 * safe_x_perpendicular and friends.
+	 */
+	if (!(fsw && fsw->osm_switch)) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: Invalid topology discovery. "
+			"Verify torus-2QoS.conf contents.\n");
+		return false;
+	}
+
 	pg = &tsw->ptgrp[2 * TORUS_MAX_DIM];
 	pg->type = SRCSINK;
 	tsw->osm_switch = fsw->osm_switch;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

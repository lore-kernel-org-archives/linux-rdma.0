From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 01/12] opensm: Make error message for torus-2QoS
 dateline specification match code check.
Date: Fri, 18 Dec 2009 13:50:51 -0700
Message-ID: <1261169461-2516-2-git-send-email-jaschut@sandia.gov>
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


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 8eb2880..7108394 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -954,7 +954,7 @@ bool parse_dir_dateline(int c_dir, struct torus *t, const char *parse_sep)
 	if ((*dl < 0 && *dl <= -max_dl) || *dl >= max_dl)
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"Error: dateline value for coordinate direction %d "
-			"must be %d <= dl <= %d\n",
+			"must be %d < dl < %d\n",
 			c_dir, -max_dl, max_dl);
 	else
 		success = true;
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

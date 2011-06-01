From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 2/2] opensm: use OSM_LOG_INFO on duplicate torus port
 order parsing
Date: Wed,  1 Jun 2011 16:33:01 -0600
Message-ID: <1306967581-1015-2-git-send-email-jaschut@sandia.gov>
References: <4DE6BD7A.9030102@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE6BD7A.9030102-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since it doesn't cause OpenSM to exit, it isn't an error.
We just want to give the admin information that will allow them
to clean up their configuration.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/osm_torus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 47654ce..d06cea9 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -870,8 +870,8 @@ bool parse_port_order(struct torus *t, const char *parse_sep)
 
 		for (j = 0; j < i; j++) {
 			if (t->port_order[j] == t->port_order[i]) {
-				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: ignoring duplicate port %u in "
+				OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+					"Ignored duplicate port %u in"
 					" port_order parsing\n",
 					t->port_order[j]);
 				i--;	/* Ignore duplicate port number */
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

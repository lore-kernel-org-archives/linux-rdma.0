From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_torus.c: Handle calloc() failure on
 routing engine context creation.
Date: Fri, 17 Sep 2010 11:03:14 -0600
Message-ID: <1284742994-24503-3-git-send-email-jaschut@sandia.gov>
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

Hal Rosenstock pointed out this calloc() could fail.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 12b480d..3b67f16 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -410,7 +410,11 @@ struct torus_context *torus_context_create(osm_opensm_t *osm)
 	struct torus_context *ctx;
 
 	ctx = calloc(1, sizeof(*ctx));
-	ctx->osm = osm;
+	if (ctx)
+		ctx->osm = osm;
+	else
+		OSM_LOG(&osm->log, OSM_LOG_ERROR,
+			"Error: calloc: %s\n", strerror(errno));
 
 	return ctx;
 }
@@ -9113,6 +9117,8 @@ int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
 	struct torus_context *ctx;
 
 	ctx = torus_context_create(osm);
+	if (!ctx)
+		return -1;
 
 	r->context = ctx;
 	r->ucast_build_fwd_tables = torus_build_lfts;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

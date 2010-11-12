From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 02/13] opensm: torus-2QoS requires that QoS be enabled.
Date: Fri, 12 Nov 2010 15:11:11 -0700
Message-ID: <1289599882-15165-3-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SL2VL maps are only programmed if QoS is enabled.  Require this to be
the case if torus-2QoS is configured, and print a message otherwise.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 3b67f16..aeb4fe6 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -9045,6 +9045,14 @@ int torus_build_lfts(void *context)
 	struct fabric *fabric;
 	struct torus *torus;
 
+	if (!ctx->osm->subn.opt.qos) {
+		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+			"Error: Routing engine list contains torus-2QoS. "
+			"Enable QoS for correct operation "
+			"(-Q or 'qos TRUE' in opensm.conf).\n");
+		return status;
+	}
+
 	fabric = &ctx->fabric;
 	teardown_fabric(fabric);
 
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

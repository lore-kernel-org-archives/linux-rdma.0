From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 06/11] opensm: Enable torus-2QoS routing engine.
Date: Fri, 20 Nov 2009 12:15:04 -0700
Message-ID: <1258744509-11148-6-git-send-email-jaschut@sandia.gov>
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
 opensm/include/opensm/osm_opensm.h |    1 +
 opensm/opensm/osm_opensm.c         |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index ef9d4e1..90c6c0f 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -105,6 +105,7 @@ typedef enum _osm_routing_engine_type {
 	OSM_ROUTING_ENGINE_TYPE_FTREE,
 	OSM_ROUTING_ENGINE_TYPE_LASH,
 	OSM_ROUTING_ENGINE_TYPE_DOR,
+	OSM_ROUTING_ENGINE_TYPE_TORUS_2QOS,
 	OSM_ROUTING_ENGINE_TYPE_UNKNOWN
 } osm_routing_engine_type_t;
 /***********/
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index 9cd254e..7052d49 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -70,6 +70,7 @@ extern int osm_ucast_file_setup(struct osm_routing_engine *, osm_opensm_t *);
 extern int osm_ucast_ftree_setup(struct osm_routing_engine *, osm_opensm_t *);
 extern int osm_ucast_lash_setup(struct osm_routing_engine *, osm_opensm_t *);
 extern int osm_ucast_dor_setup(struct osm_routing_engine *, osm_opensm_t *);
+extern int osm_ucast_torus2QoS_setup(struct osm_routing_engine *, osm_opensm_t *);
 
 const static struct routing_engine_module routing_modules[] = {
 	{"minhop", osm_ucast_minhop_setup},
@@ -78,6 +79,7 @@ const static struct routing_engine_module routing_modules[] = {
 	{"ftree", osm_ucast_ftree_setup},
 	{"lash", osm_ucast_lash_setup},
 	{"dor", osm_ucast_dor_setup},
+	{"torus-2QoS", osm_ucast_torus2QoS_setup},
 	{NULL, NULL}
 };
 
@@ -98,6 +100,8 @@ const char *osm_routing_engine_type_str(IN osm_routing_engine_type_t type)
 		return "lash";
 	case OSM_ROUTING_ENGINE_TYPE_DOR:
 		return "dor";
+	case OSM_ROUTING_ENGINE_TYPE_TORUS_2QOS:
+		return "torus-2QoS";
 	default:
 		break;
 	}
@@ -124,6 +128,8 @@ osm_routing_engine_type_t osm_routing_engine_type(IN const char *str)
 		return OSM_ROUTING_ENGINE_TYPE_LASH;
 	else if (!strcasecmp(str, "dor"))
 		return OSM_ROUTING_ENGINE_TYPE_DOR;
+	else if (!strcasecmp(str, "torus-2QoS"))
+		return OSM_ROUTING_ENGINE_TYPE_TORUS_2QOS;
 	else
 		return OSM_ROUTING_ENGINE_TYPE_UNKNOWN;
 }
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v3 11/17] opensm: Enable torus-2QoS routing engine.
Date: Tue, 15 Jun 2010 13:53:18 -0600
Message-ID: <1276631604-29230-12-git-send-email-jaschut@sandia.gov>
References: <1276631604-29230-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276631604-29230-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h |    1 +
 opensm/opensm/main.c               |    2 +-
 opensm/opensm/osm_opensm.c         |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index fddcf53..8d63111 100644
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
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 0093aa7..abc3282 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -174,7 +174,7 @@ static void show_usage(void)
 	       "          Min Hop algorithm.  Multiple routing engines can be specified\n"
 	       "          separated by commas so that specific ordering of routing\n"
 	       "          algorithms will be tried if earlier routing engines fail.\n"
-	       "          Supported engines: updn, file, ftree, lash, dor\n\n");
+	       "          Supported engines: updn, file, ftree, lash, dor, torus-2QoS\n\n");
 	printf("--do_mesh_analysis\n"
 	       "          This option enables additional analysis for the lash\n"
 	       "          routing engine to precondition switch port assignments\n"
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index 5614240..8b03947 100644
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
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

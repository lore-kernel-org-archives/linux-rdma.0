From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_file.c: closing file descriptor in error
	path
Date: Tue, 7 Sep 2010 18:16:44 +0300
Message-ID: <4C86575C.8010607@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_ucast_file.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/opensm/opensm/osm_ucast_file.c b/opensm/opensm/osm_ucast_file.c
index 8cb3cb6..fef77a2 100644
--- a/opensm/opensm/osm_ucast_file.c
+++ b/opensm/opensm/osm_ucast_file.c
@@ -130,6 +130,7 @@ static int do_ucast_file_load(void *context)
 	uint16_t lid;
 	uint8_t port_num;
 	unsigned lineno;
+	int status = -1;

 	file_name = p_osm->subn.opt.lfts_file;
 	if (!file_name) {
@@ -143,7 +144,7 @@ static int do_ucast_file_load(void *context)
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 6302: "
 			"Can't open ucast dump file \'%s\': %m\n", file_name);
-		return -1;
+		goto Exit;
 	}

 	lineno = 0;
@@ -173,7 +174,7 @@ static int do_ucast_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse switch definition\n",
 					file_name, lineno);
-				return -1;
+				goto Exit;
 			}
 			p = q + 8;
 			sw_guid = strtoull(p, &q, 16);
@@ -182,7 +183,7 @@ static int do_ucast_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse switch guid: \'%s\'\n",
 					file_name, lineno, p);
-				return -1;
+				goto Exit;
 			}
 			sw_guid = cl_hton64(sw_guid);

@@ -202,7 +203,7 @@ static int do_ucast_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse lid: \'%s\'\n",
 					file_name, lineno, p);
-				return -1;
+				goto Exit;
 			}
 			p = q;
 			while (isspace(*p))
@@ -213,7 +214,7 @@ static int do_ucast_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse port: \'%s\'\n",
 					file_name, lineno, p);
-				return -1;
+				goto Exit;
 			}
 			p = q;
 			/* additionally try to extract guid */
@@ -241,9 +242,11 @@ static int do_ucast_file_load(void *context)
 			add_path(p_osm, p_sw, lid, port_num, port_guid);
 		}
 	}
-
-	fclose(file);
-	return 0;
+	status = 0;
+Exit:
+	if (file)
+		fclose(file);
+	return status;
 }

 static int do_lid_matrix_file_load(void *context)
@@ -257,6 +260,7 @@ static int do_lid_matrix_file_load(void *context)
 	osm_switch_t *p_sw;
 	unsigned lineno;
 	uint16_t lid;
+	int status = -1;

 	file_name = p_osm->subn.opt.lid_matrix_dump_file;
 	if (!file_name) {
@@ -270,7 +274,7 @@ static int do_lid_matrix_file_load(void *context)
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 6305: "
 			"Can't open lid matrix file \'%s\': %m\n", file_name);
-		return -1;
+		goto Exit;
 	}

 	lineno = 0;
@@ -294,7 +298,7 @@ static int do_lid_matrix_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse switch definition\n",
 					file_name, lineno);
-				return -1;
+				goto Exit;
 			}
 			p = q + 8;
 			guid = strtoull(p, &q, 16);
@@ -303,7 +307,7 @@ static int do_lid_matrix_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse switch guid: \'%s\'\n",
 					file_name, lineno, p);
-				return -1;
+				goto Exit;
 			}
 			guid = cl_hton64(guid);

@@ -328,7 +332,7 @@ static int do_lid_matrix_file_load(void *context)
 					"PARSE ERROR: %s:%u: "
 					"cannot parse lid: \'%s\'\n",
 					file_name, lineno, p);
-				return -1;
+				goto Exit;
 			}
 			/* Just checked the range, so casting is safe */
 			lid = (uint16_t) num;
@@ -342,7 +346,7 @@ static int do_lid_matrix_file_load(void *context)
 						"PARSE ERROR: %s:%u: "
 						"cannot parse hops number: \'%s\'\n",
 						file_name, lineno, p);
-					return -1;
+					goto Exit;
 				}
 				/* Just checked the range, so casting is safe */
 				hops[len++] = (uint8_t) num;
@@ -375,9 +379,11 @@ static int do_lid_matrix_file_load(void *context)
 			add_lid_hops(p_osm, p_sw, lid, guid, hops, len);
 		}
 	}
-
-	fclose(file);
-	return 0;
+	status = 0;
+Exit:
+	if (file)
+		fclose(file);
+	return status;
 }

 int osm_ucast_file_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

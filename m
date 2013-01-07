From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_torus.c: Consolidate some parsing with parse_unsigned
Date: Mon, 07 Jan 2013 14:50:23 -0500
Message-ID: <50EB26FF.5080507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 1d847b3..ff83edb 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -853,14 +853,14 @@ out:
 }
 
 static
-bool parse_port(unsigned *pnum, const char *parse_sep)
+bool parse_unsigned(unsigned *result, const char *parse_sep)
 {
 	char *val, *nextchar;
 
 	val = strtok(NULL, parse_sep);
 	if (!val)
 		return false;
-	*pnum = strtoul(val, &nextchar, 0);
+	*result = strtoul(val, &nextchar, 0);
 	return true;
 }
 
@@ -870,7 +870,7 @@ bool parse_port_order(struct torus *t, unsigned port_order[], const char *parse_
 	unsigned i, j, k, n;
 
 	for (i = 0; i < ARRAY_SIZE(port_order); i++) {
-		if (!parse_port(&(port_order[i]), parse_sep))
+		if (!parse_unsigned(&(port_order[i]), parse_sep))
 			break;
 
 		for (j = 0; j < i; j++) {
@@ -898,18 +898,6 @@ bool parse_port_order(struct torus *t, unsigned port_order[], const char *parse_
 }
 
 static
-bool parse_pg_max_ports(struct torus *t, const char *parse_sep)
-{
-	char *val, *nextchar;
-
-	val = strtok(NULL, parse_sep);
-	if (!val)
-		return false;
-	t->portgrp_sz = strtoul(val, &nextchar, 0);
-	return true;
-}
-
-static
 bool parse_guid(struct torus *t, guid_t *guid, const char *parse_sep)
 {
 	char *val;
@@ -1094,7 +1082,7 @@ next_line:
 		kw_success = grow_seed_array(t, 1);
 		t->seed_cnt++;
 	} else if (strcmp("portgroup_max_ports", keyword) == 0) {
-		kw_success = parse_pg_max_ports(t, parse_sep);
+		kw_success = parse_unsigned(&t->portgrp_sz, parse_sep);
 	} else if (strcmp("xp_link", keyword) == 0) {
 		if (!t->seed_cnt)
 			t->seed_cnt++;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

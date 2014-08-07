From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_console.c: Included unknown speed/width ports
 in "possible issues"
Date: Thu, 07 Aug 2014 14:33:23 -0400
Message-ID: <53E3C673.6050107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 1a05902..c68d6b7 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -975,7 +975,8 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		fprintf(out, "   %" PRIu64 " at 25.78125 Gbps\n", fs.ports_edr);
 
 	if (fs.ports_disabled + fs.ports_reduced_speed + fs.ports_reduced_width
-	    + fs.ports_unenabled_width + fs.ports_unenabled_speed > 0) {
+	    + fs.ports_unenabled_width + fs.ports_unenabled_speed
+	    + fs.ports_unknown_width + fs.ports_unknown_speed > 0) {
 		fprintf(out, "\nPossible issues:\n");
 	}
 	if (fs.ports_disabled) {
@@ -992,6 +993,10 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 			fs.ports_reduced_speed);
 		__print_port_report(out, fs.reduced_speed_ports);
 	}
+	if (fs.ports_unknown_speed) {
+		fprintf(out, "   %" PRIu64 " with unknown speed\n",
+			fs.ports_unknown_speed);
+	}
 	if (fs.ports_unenabled_width) {
 		fprintf(out, "   %" PRIu64 " with unenabled width\n",
 			fs.ports_unenabled_width);
@@ -1002,6 +1007,10 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 			fs.ports_reduced_width);
 		__print_port_report(out, fs.reduced_width_ports);
 	}
+	if (fs.ports_unknown_width) {
+		fprintf(out, "   %" PRIu64 " with unknown width\n",
+			fs.ports_unknown_width);
+	}
 	fprintf(out, "\n");
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

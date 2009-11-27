From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c Log format changes
Date: Fri, 27 Nov 2009 14:27:13 +0100
Message-ID: <4B0FD3B1.1090807@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Using single line when displaying DR path info in
osm_dump_dr_path() and osm_dump_smp_dr_path()

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 77ae89e..60724f2 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -1946,8 +1946,8 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 		char buf[BUF_SIZE];
 		unsigned n = 0;
 
-		n = sprintf(buf, "Directed Path Dump of %u hop path:"
-			    "\n\t\t\t\tPath = ", p_path->hop_count);
+		n = sprintf(buf, "Directed Path Dump of %u hop path: "
+			    "Path = ", p_path->hop_count);
 
 		sprint_uint8_arr(buf + n, sizeof(buf) - n, p_path->path,
 				 p_path->hop_count + 1);
@@ -1962,13 +1962,13 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 		char buf[BUF_SIZE];
 		unsigned n;
 
-		n = sprintf(buf, "Received SMP on a %u hop path:"
-			    "\n\t\t\t\tInitial path = ", p_smp->hop_count);
+		n = sprintf(buf, "Received SMP on a %u hop path: "
+			    "Initial path = ", p_smp->hop_count);
 		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
 				      p_smp->initial_path,
 				      p_smp->hop_count + 1);
 
-		n += sprintf(buf + n, "\n\t\t\t\tReturn path  = ");
+		n += sprintf(buf + n, ", Return path  = ");
 		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
 				      p_smp->return_path, p_smp->hop_count + 1);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

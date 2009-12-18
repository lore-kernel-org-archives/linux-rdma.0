From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 03/12] opensm: Remove unused port specification from
 torus-2QoS config file parsing.
Date: Fri, 18 Dec 2009 13:50:53 -0700
Message-ID: <1261169461-2516-4-git-send-email-jaschut@sandia.gov>
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

The torus-2QoS.conf file is used to provide persistent information
describing the torus topology that torus-2QoS should generate.
Only switch GUIDs are needed to specify torus coordinate direction
and dateline information - switch ports are not needed, and in
fact were discarded immediately after parsing, before this patch.

Just get rid of it.  While we're in the area, get rid of another
unused argument to the same parsing function.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index bc87757..42582ce 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -833,8 +833,7 @@ bool parse_pg_max_ports(struct torus *t, const char *parse_sep)
 }
 
 static
-bool parse_guid_port(struct torus *t, guid_t *guid, int *port,
-		     const char *typestr, const char *parse_sep)
+bool parse_guid(struct torus *t, guid_t *guid, const char *parse_sep)
 {
 	char *val;
 	bool success = false;
@@ -845,11 +844,6 @@ bool parse_guid_port(struct torus *t, guid_t *guid, int *port,
 	*guid = strtoull(val, NULL, 0);
 	*guid = cl_hton64(*guid);
 
-	val = strtok(NULL, parse_sep);
-	if (!val)
-		goto out;
-	*port = strtol(val, NULL, 0);
-
 	success = true;
 out:
 	return success;
@@ -858,15 +852,14 @@ out:
 static
 bool parse_dir_link(int c_dir, struct torus *t, const char *parse_sep)
 {
-	int sw_port0, sw_port1;
 	guid_t sw_guid0, sw_guid1;
 	struct link *l;
 	bool success = false;
 
-	if (!parse_guid_port(t, &sw_guid0, &sw_port0, "switch", parse_sep))
+	if (!parse_guid(t, &sw_guid0, parse_sep))
 		goto out;
 
-	if (!parse_guid_port(t, &sw_guid1, &sw_port1, "switch", parse_sep))
+	if (!parse_guid(t, &sw_guid1, parse_sep))
 		goto out;
 
 	if (!t) {
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

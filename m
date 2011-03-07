From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed memory leak in osm_console()
Date: Mon, 7 Mar 2011 12:03:02 +0200
Message-ID: <20110307100302.GJ5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a scenario that fopen will overwrite output variable.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_console.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index fad80ad..7003508 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -1279,6 +1279,8 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		if (strcmp(p_cmd, "file") == 0) {
 			p_cmd = next_token(p_last);
 			if (p_cmd) {
+				if (output != out)
+					fclose(output);
 				output = fopen(p_cmd, "w+");
 				if (output == NULL) {
 					fprintf(out,
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

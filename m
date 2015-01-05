From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Correct output error with congestion
	control table entries
Date: Mon, 05 Jan 2015 11:28:10 -0800
Message-ID: <1420486090.21271.76.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index d577a69..ba760ff 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2926,10 +2926,10 @@ void osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		fprintf(out, "%u:%u",
 			p_opts->cc_cct.entries[0].shift,
 			p_opts->cc_cct.entries[0].multiplier);
-		for (i = 0; i < p_opts->cc_cct.entries_len; i++) {
+		for (i = 1; i < p_opts->cc_cct.entries_len; i++) {
 			fprintf(out, ",%u:%u",
-				p_opts->cc_cct.entries[0].shift,
-				p_opts->cc_cct.entries[0].multiplier);
+				p_opts->cc_cct.entries[i].shift,
+				p_opts->cc_cct.entries[i].multiplier);
 		}
 		fprintf(out, "\n");
 	}
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

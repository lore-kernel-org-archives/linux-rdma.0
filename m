From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] [PATCH 1/2] Fix memleak and segfault
Date: Fri, 11 Nov 2011 10:04:52 -0800
Message-ID: <1321034692.22519.382.camel@auk59.llnl.gov>
References: <1320948093.22519.337.camel@auk59.llnl.gov>
	 <20111111121957.GA2968@calypso.mtl.com>
	 <1321034297.22519.376.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321034297.22519.376.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If invalid input specified by user, memory would not be freed.

On rescan with new value, data segment memory could be attempted
to be freed.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 554a950..9845edd 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1159,7 +1159,8 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		log_report(" Invalid Cached Option Value:console = %s"
 			   ", Using Default:%s\n",
 			   p_opts->console, OSM_DEFAULT_CONSOLE);
-		p_opts->console = OSM_DEFAULT_CONSOLE;
+		free(p_opts->console);
+		p_opts->console = strdup(OSM_DEFAULT_CONSOLE);
 	}
 
 	if (p_opts->qos) {
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

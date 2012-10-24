From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Only parameters that marked with
 can_update flag should be updated during conf file rescan
Date: Wed, 24 Oct 2012 18:26:27 +0200
Message-ID: <20121024162627.GD18591@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index b9a491b..541105a 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2168,7 +2168,7 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 
 			token_matched = 1;
 
-			if (strcmp(r->name, p_key))
+			if (!r->can_update || strcmp(r->name, p_key))
 				continue;
 
 			p_field1 = (void *)p_opts->file_opts + r->opt_offset;
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

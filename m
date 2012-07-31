From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/27] Fixed Multicast precreation parsing
Date: Tue, 31 Jul 2012 19:04:32 +0300
Message-ID: <1343750695-28063-4-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now allow to define partition without members with only multicast group
definitions.

Default=0x7fff : ALL;
Default=0x7fff,ipoib:
        mgid=ff12:401b::0719;

Signed-off-by: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 6798979..750cbe0 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -670,6 +670,7 @@ skip_header:
 		if (q)
 			*q++ = '\0';
 		ret = parse_name_token(p, &name, &flag);
+		len += ret;
 
 		if (strcmp(name, "mgid") == 0) {
 			/* parse an mgid line if specified. */
@@ -685,7 +686,6 @@ skip_header:
 			return -1;
 		}
 		p += ret;
-		len += ret;
 	} while (q);
 
 done:
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

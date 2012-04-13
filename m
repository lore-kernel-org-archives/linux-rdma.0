From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/5] infiniband-diags/ibroute.c: Dead code removal
Date: Thu, 12 Apr 2012 18:09:41 -0700
Message-ID: <1334279385-10792-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Program has already exited in the case where argc == 0

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 src/ibroute.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/ibroute.c b/src/ibroute.c
index 7339218..1bf1fb0 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -432,10 +432,7 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-	if (!argc) {
-		if (ib_resolve_self_via(&portid, 0, 0, srcport) < 0)
-			IBERROR("can't resolve self addr");
-	} else if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
+	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
 					     ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[1]);
 
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

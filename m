From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/5] ibacm: Avoid clang 3.8 warning -Wmissing-field-initializers
Date: Fri,  7 Oct 2016 16:36:09 -0600
Message-ID: <1475879772-29458-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The canonical way to zero fill a struct in this tree is {}.

Fixes: 0db49b8b3e8f ("Avoid clang 3.6 warning -Wmissing-field-initializers")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 3f590d0b51f3..d70501aff8e8 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2118,7 +2118,7 @@ static void acmp_parse_osm_fullv1_lid2guid(FILE *f, uint64_t *lid2guid)
 static int acmp_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acmp_ep *ep)
 {
 	union ibv_gid sgid, dgid;
-	struct ibv_port_attr attr = { 0 };
+	struct ibv_port_attr attr = {};
 	struct acmp_dest *dest;
 	char s[128];
 	char *p, *ptr, *p_guid, *p_lid;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

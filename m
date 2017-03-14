From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 7/7] acm: Fix missing swap in pkey compare
Date: Tue, 14 Mar 2017 10:21:14 -0600
Message-ID: <1489508474-16664-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It looks like endpoint->pkey is always used as host except for here. The
routine always returns 0 on failure, so it is likely nobody noticed it
was wrong.

Found by sparse.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index fb8d30f3e6ac42..024d401fbf9fbd 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2459,7 +2459,7 @@ static uint16_t acmp_get_pkey_index(struct acm_endpoint *endpoint)
 
 	for (i = 0, ret = 0; !ret; i++) {
 		ret = ibv_query_pkey(port->dev->verbs, port->port_num, i, &pkey);
-		if (!ret && endpoint->pkey == pkey)
+		if (!ret && endpoint->pkey == be16toh(pkey))
 			return i;
 	}
 	return 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

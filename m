From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/7] cmpost: Add missing swap for sin_port
Date: Tue, 14 Mar 2017 10:21:13 -0600
Message-ID: <1489508474-16664-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It looks like this didn't matter because this sin_port is only used
for resolve_route which doesn't use sin_port data.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibcm/examples/cmpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibcm/examples/cmpost.c b/libibcm/examples/cmpost.c
index b8e7d8e0710e6d..b7c95513959390 100644
--- a/libibcm/examples/cmpost.c
+++ b/libibcm/examples/cmpost.c
@@ -632,7 +632,7 @@ static int get_dst_addr(char *dst, struct sockaddr_in *addr_in)
 	}
 
 	*addr_in = *(struct sockaddr_in *) res->ai_addr;
-	addr_in->sin_port = 7471;
+	addr_in->sin_port = htobe16(7471);
 out:
 	freeaddrinfo(res);
 	return ret;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

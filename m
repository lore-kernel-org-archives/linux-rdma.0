From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/8] acm: Fix wrong format attributes for error
Date: Fri, 14 Oct 2016 16:14:14 -0600
Message-ID: <1476483257-16308-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The arguments were swapped, and totally crash-when-run wrong.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/src/acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index e512939dd765..523b78082ff8 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2483,7 +2483,7 @@ static void acm_open_dev(struct ibv_device *ibdev)
 
 	ret = ibv_query_device(verbs, &attr);
 	if (ret) {
-		acm_log(0, "ERROR - ibv_query_device (%s) %d\n", ret, ibdev->name);
+		acm_log(0, "ERROR - ibv_query_device (%d) %s\n", ret, ibdev->name);
 		goto err1;
 	}
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

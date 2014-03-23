From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/9] ibacm: Release the refcnt on the correct client
Date: Sun, 23 Mar 2014 13:18:13 -0700
Message-ID: <1395605901-9080-2-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Release the reference on the client that we're referencing,
and not the one at the front of the array.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 82f9431..c403aa8 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -452,7 +452,7 @@ static void
 acm_free_req(struct acm_request *req)
 {
 	acm_log(2, "%p\n", req);
-	(void) atomic_dec(&client->refcnt);
+	(void) atomic_dec(&req->client->refcnt);
 	free(req);
 }
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

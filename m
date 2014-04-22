From: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] librdmacm: Fix verbs leak due to reentrancy issue
Date: Tue, 22 Apr 2014 14:22:06 +0300
Message-ID: <20140422112202.GA7440@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean,

I was out of work so I tested the patch "librdmacm: lazy initialization
for ib devices" today. The patch works fine for my test case. The only
concern I have is that I think the patch might leak verbs context. I
think that any call to ucma_init_device must be done with mutex locked.
Please correct me if I am wrong.

Thanks, Shamir


Signed-off-by: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/cma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 0dc229e..42769cf 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -416,10 +416,13 @@ static int ucma_get_device(struct cma_id_private *id_priv, uint64_t guid)
 
 	return ERR(ENODEV);
 match:
-	if ((ret = ucma_init_device(cma_dev)))
+	pthread_mutex_lock(&mut);
+
+	if ((ret = ucma_init_device(cma_dev))) {
+		pthread_mutex_unlock(&mut);
 		return ret;
+	}
 
-	pthread_mutex_lock(&mut);
 	if (!cma_dev->refcnt++) {
 		cma_dev->pd = ibv_alloc_pd(cma_dev->verbs);
 		if (!cma_dev->pd) {
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

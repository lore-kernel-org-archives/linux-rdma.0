From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] IB/ipoib: Initialize ipoib_neigh list properly
Date: Tue, 24 Aug 2010 20:51:23 -0700
Message-ID: <20100824205123.2742e194.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Tom Elken <tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "John A. Gregor" <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I applied Ralph's "fix dangling pointer references to ipoib_neigh and
ipoib_path" patch to our local RHEL based kernel and experienced crashes in
ipoib_neigh_cleanup.  It turns out ipoib_neigh->list was not initialized
properly.  So the following code from Ralph's patch caused issues.

	if (ipoib_cm_get(neigh))
		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));

Looking at Rolands upstream kernel it appears the same is true upstream.

The patch below initializes ipoib_neigh->list correctly.


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..fa38ede 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -882,6 +882,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 	if (!neigh)
 		return NULL;
 
+	INIT_LIST_HEAD(&neigh->list);
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
 	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

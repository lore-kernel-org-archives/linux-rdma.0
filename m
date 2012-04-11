From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
Date: Wed, 11 Apr 2012 23:43:29 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If, in ib_link_query_port(), the call to mlx4_MAD_IFC() fails we will
currently do 'return err;' which will leak 'in_mad' and 'out_mad' that
we previously allocated. I believe we should instead do 'goto out;'
where we'll properly free the memory we previously allocated.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75d3056..cc88c9c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -247,7 +247,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
 				   NULL, NULL, in_mad, out_mad);
 		if (err)
-			return err;
+			goto out;
 
 		/* Checking LinkSpeedActive for FDR-10 */
 		if (out_mad->data[15] & 0x1)
-- 
1.7.10


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

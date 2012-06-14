From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] RDMA/ocrdma: off by one in ocrdma_query_gid()
Date: Thu, 14 Jun 2012 21:36:09 +0300
Message-ID: <20120614183609.GE6383@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The dev->sgid_tbl[] array is allocated in ocrdma_alloc_resources().  It
has OCRDMA_MAX_SGID elements so the test here is off by one.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d55d459..2e2e7ae 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -53,7 +53,7 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 
 	dev = get_ocrdma_dev(ibdev);
 	memset(sgid, 0, sizeof(*sgid));
-	if (index > OCRDMA_MAX_SGID)
+	if (index >= OCRDMA_MAX_SGID)
 		return -EINVAL;
 
 	memcpy(sgid, &dev->sgid_tbl[index], sizeof(*sgid));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

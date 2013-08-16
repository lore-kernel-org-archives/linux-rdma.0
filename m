From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] IB/mthca: make type explicit in mthca_INIT_HCA()
Date: Fri, 16 Aug 2013 10:19:15 +0300
Message-ID: <20130816071915.GB6053@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The type of the second argument to the MTHCA_PUT() macro determines how
many bytes will be written to inbox.  Judging from the context, the
current code is doing the right thing by writing an int of data.  But I
would feel more comfortable making it explicit that we are writing 32
bits.

This is just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 9d3e5c1..2d2a401 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1359,7 +1359,7 @@ int mthca_INIT_HCA(struct mthca_dev *dev,
 	memset(inbox, 0, INIT_HCA_IN_SIZE);
 
 	if (dev->mthca_flags & MTHCA_FLAG_SINAI_OPT)
-		MTHCA_PUT(inbox, 0x1, INIT_HCA_FLAGS1_OFFSET);
+		MTHCA_PUT(inbox, (u32)0x1, INIT_HCA_FLAGS1_OFFSET);
 
 #if defined(__LITTLE_ENDIAN)
 	*(inbox + INIT_HCA_FLAGS2_OFFSET / 4) &= ~cpu_to_be32(1 << 1);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

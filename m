From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] infiniband: hw: ipath: ipath_diag.c:  Cleaning up code that is not handled properly.
Date: Sat,  7 Jun 2014 01:08:56 +0200
Message-ID: <1402096136-9919-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

None of the code is adapted to handle a struct ipath_diag_pkt.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_diag.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index e2f9a51..39ba797 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -327,7 +327,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 {
 	u32 __iomem *piobuf;
 	u32 plen, pbufn, maxlen_reserve;
-	struct ipath_diag_pkt odp;
 	struct ipath_diag_xpkt dp;
 	u32 *tmpbuf = NULL;
 	struct ipath_devdata *dd;
@@ -341,11 +340,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 			ret = -EFAULT;
 			goto bail;
 		}
-	} else if (count == sizeof(odp)) {
-		if (copy_from_user(&odp, data, sizeof(odp))) {
-			ret = -EFAULT;
-			goto bail;
-		}
 	} else {
 		ret = -EINVAL;
 		goto bail;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

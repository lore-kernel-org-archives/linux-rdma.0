From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/ipath: Translate legacy diagpkt into newer extended
 diagpkt
Date: Fri, 02 May 2014 11:40:17 -0400
Message-ID: <20140502154017.16783.60188.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch addresses an issue where the legacy diagpacket is sent in from the
user, but the driver operates on only the extended diagpkt. This patch
specifically initializes the extended diagpkt based on the legacy packet.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_diag.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index e2f9a51..45802e9 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -346,6 +346,10 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 			ret = -EFAULT;
 			goto bail;
 		}
+		dp.len = odp.len;
+		dp.unit = odp.unit;
+		dp.data = odp.data;
+		dp.pbc_wd = 0;
 	} else {
 		ret = -EINVAL;
 		goto bail;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

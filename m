From: Joseph Marrero <jmarrero-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] this patch fixes two warnings found by checkpatch on
 ipath_common.h the warnings were of the type: WARNING: __aligned(size) is
 preferred over __attribute__((aligned(size)))
Date: Wed, 25 Nov 2015 03:43:34 +0000
Message-ID: <20151125034334.GA21739@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Joseph Marrero <jmarrero-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/ipath/ipath_common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_common.h b/drivers/staging/rdma/ipath/ipath_common.h
index 28cfe97..242890f 100644
--- a/drivers/staging/rdma/ipath/ipath_common.h
+++ b/drivers/staging/rdma/ipath/ipath_common.h
@@ -342,7 +342,7 @@ struct ipath_base_info {
 	__u64 spi_port_rcvhdr_base;
 	__u64 spi_port_rcvhdr_tailaddr;
 
-} __attribute__ ((aligned(8)));
+} __aligned(8);
 
 
 /*
@@ -427,7 +427,7 @@ struct ipath_user_info {
 	 */
 	__u64 spu_base_info;
 
-} __attribute__ ((aligned(8)));
+} __aligned(8);
 
 /* User commands. */
 
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] librdmacm/rspreload: Call real.close in fd_close
Date: Thu, 16 Aug 2012 19:24:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8995C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The index into the preload lookup table is obtained by opening
/dev/null and use the returned value.  When closing the file,
use the real close call and not the preload close call.  This
is a minor optimization, but clarifies the expected operation.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index 52eaf1a..a680143 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -131,7 +131,7 @@ static int fd_open(void)
 	return index;
 
 err2:
-	close(index);
+	real.close(index);
 err1:
 	free(fdi);
 	return ret;
@@ -187,7 +187,7 @@ static enum fd_type fd_close(int index, int *fd)
 		idm_clear(&idm, index);
 		*fd = fdi->fd;
 		type = fdi->type;
-		close(index);
+		real.close(index);
 		free(fdi);
 	} else {
 		*fd = index;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

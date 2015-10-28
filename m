From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging: rdma: ipath: Remove unneeded vairable.
Date: Wed, 28 Oct 2015 18:34:55 +0530
Message-ID: <1446037495-18970-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove unneeded variable ret, directly return 0.

Signed-off-by: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/ipath/ipath_file_ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/staging/rdma/ipath/ipath_file_ops.c
index c796a51..5d9b9db 100644
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c
+++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -2046,7 +2046,6 @@ static void unlock_expected_tids(struct ipath_portdata *pd)
 
 static int ipath_close(struct inode *in, struct file *fp)
 {
-	int ret = 0;
 	struct ipath_filedata *fd;
 	struct ipath_portdata *pd;
 	struct ipath_devdata *dd;
@@ -2158,7 +2157,7 @@ static int ipath_close(struct inode *in, struct file *fp)
 
 bail:
 	kfree(fd);
-	return ret;
+	return 0;
 }
 
 static int ipath_port_info(struct ipath_portdata *pd, u16 subport,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

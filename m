From: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/11] ipath: replace open-coded ARRAY_SIZE with macro
Date: Tue, 10 Apr 2012 18:55:25 -0600
Message-ID: <1334105725-9081-1-git-send-email-jim.cromie@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: trivial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_intr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index c0a03ac..26dfbc8 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -209,8 +209,7 @@ void ipath_format_hwerrors(u64 hwerrs,
 {
 	int i;
 	const int glen =
-	    sizeof(ipath_generic_hwerror_msgs) /
-	    sizeof(ipath_generic_hwerror_msgs[0]);
+	    ARRAY_SIZE(ipath_generic_hwerror_msgs);
 
 	for (i=0; i<glen; i++) {
 		if (hwerrs & ipath_generic_hwerror_msgs[i].mask) {
-- 
1.7.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

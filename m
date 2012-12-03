From: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Mon,  3 Dec 2012 15:28:18 -0500
Message-ID: <1354566498-8364-1-git-send-email-jonstanley@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Future release of Fedora are going to remove /etc/sysconfig/network
which we source to get $HOSTNAME. Bash (and sh) set $HOSTNAME in
the shell by default, so we should be safe to use that here. This
adds the benefit of working across multiple distributions if that
is required in the future.

Related: rhbz881917

Signed-off-by: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 scripts/set_nodedesc.sh |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/scripts/set_nodedesc.sh b/scripts/set_nodedesc.sh
index 1e42ac8..3d2e406 100755
--- a/scripts/set_nodedesc.sh
+++ b/scripts/set_nodedesc.sh
@@ -1,8 +1,5 @@
 #!/bin/sh
 
-if [ -f /etc/sysconfig/network ]; then
-. /etc/sysconfig/network
-fi
 
 ib_sysfs="/sys/class/infiniband"
 newname="$HOSTNAME"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

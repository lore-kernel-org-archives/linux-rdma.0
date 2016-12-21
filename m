From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] MAINTAINERS: fix cut-n-paste typo
Date: Wed, 21 Dec 2016 17:05:53 -0500
Message-ID: <20161221220553.36122-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bc6eb50..04b6834 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8,7 +8,7 @@ Descriptions of section entries:
         F: Files and directories with wildcard patterns.
            A trailing slash includes all files and subdirectory files.
            F:   providers/mlx4/ all files in and below providers/mlx4/
-           F:   providers/*     all files in drivers/net, but not below
+           F:   providers/*     all files in providers, but not below
            F:   */net/*         all files in "any top level directory"/net
            One pattern per line.  Multiple F: lines acceptable.
         H: Historical authors
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/6] redhat/spec: call it srp_daemon in desc, not srptools
Date: Wed, 21 Dec 2016 17:08:35 -0500
Message-ID: <20161221220840.36268-2-jarod@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 801bb94..82cd149 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -187,7 +187,7 @@ Requires(postun): systemd-units
 Requires: rdma-core
 
 %description -n srp_daemon
-In conjunction with the kernel ib_srp driver, srptools allows you to
+In conjunction with the kernel ib_srp driver, srp_daemon allows you to
 discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
 
 %prep
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/hfi1: Add PSM2 user space header to header_install
Date: Wed,  2 Sep 2015 18:46:21 -0400
Message-ID: <1441233981-32071-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the hfi1 driver was added a user space header file (hfi1_user.h) was added
to be shared between PSM2 and the driver.  However, the file was not added to
the header install.  Add it now.

Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/rdma/Kbuild     | 1 +
 include/uapi/rdma/hfi/Kbuild | 2 ++
 2 files changed, 3 insertions(+)
 create mode 100644 include/uapi/rdma/hfi/Kbuild

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 687ae332200f..231901b08f6c 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -5,3 +5,4 @@ header-y += ib_user_sa.h
 header-y += ib_user_verbs.h
 header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
+header-y += hfi/
diff --git a/include/uapi/rdma/hfi/Kbuild b/include/uapi/rdma/hfi/Kbuild
new file mode 100644
index 000000000000..ef23c294fc71
--- /dev/null
+++ b/include/uapi/rdma/hfi/Kbuild
@@ -0,0 +1,2 @@
+# UAPI Header export list
+header-y += hfi1_user.h
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

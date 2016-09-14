From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC rdma-next 2/3] IB/core: Export mlx5 vendor specific strucutres
Date: Wed, 14 Sep 2016 11:27:28 +0300
Message-ID: <1473841649-8923-3-git-send-email-leon@kernel.org>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473841649-8923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/Kbuild           | 1 +
 include/uapi/rdma/providers/Kbuild | 2 ++
 2 files changed, 3 insertions(+)
 create mode 100644 include/uapi/rdma/providers/Kbuild

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 4edb0f2..e804cc3 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -7,3 +7,4 @@ header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
 header-y += rdma_user_rxe.h
+header-y += providers/
diff --git a/include/uapi/rdma/providers/Kbuild b/include/uapi/rdma/providers/Kbuild
new file mode 100644
index 0000000..d863744
--- /dev/null
+++ b/include/uapi/rdma/providers/Kbuild
@@ -0,0 +1,2 @@
+# UAPI Header export list
+header-y += mlx5-abi.h
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

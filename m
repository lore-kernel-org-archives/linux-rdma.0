From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 6/6] debian: Run wrap-and-sort
Date: Tue, 14 Nov 2017 21:02:47 +0100
Message-ID: <20171114200247.25890-7-benjamin.drung@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200247.25890-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/libibverbs-dev.install | 2 +-
 debian/rdma-core.install      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index 026327ee..28995381 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -5,8 +5,8 @@ usr/include/infiniband/mlx5dv.h
 usr/include/infiniband/opcode.h
 usr/include/infiniband/sa-kern-abi.h
 usr/include/infiniband/sa.h
-usr/include/infiniband/verbs.h
 usr/include/infiniband/tm_types.h
+usr/include/infiniband/verbs.h
 usr/lib/*/libibverbs*.so
 usr/lib/*/libmlx4.so
 usr/lib/*/libmlx5.so
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index da3e73cd..93b537a1 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -26,8 +26,8 @@ usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
 usr/share/doc/rdma-core/rxe.md
-usr/share/doc/rdma-core/udev.md
 usr/share/doc/rdma-core/tag_matching.md
+usr/share/doc/rdma-core/udev.md
 usr/share/man/man5/iwpmd.conf.5
 usr/share/man/man7/rxe.7
 usr/share/man/man8/iwpmd.8
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

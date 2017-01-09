From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Mon,  9 Jan 2017 16:39:44 -0500
Message-ID: <20170109213944.31970-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Building for 32-bit arm, things fall down, due to lack of arch-specific
memory barriers.

In file included from
/builddir/build/BUILD/rdma-core-12/libibumad/sysfs.c:46:0:
include/infiniband/arch.h:132:2: error: #error No architecture specific
memory barrier defines found!
 #error No architecture specific memory barrier defines found!

Reported-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 246079e..4d31d53 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -166,6 +166,7 @@ level work required to open an RDMA connection between two machines.
 
 %package -n libibumad
 Summary: OpenFabrics Alliance InfiniBand umad (userspace management datagram) library
+ExcludeArch: %{arm}
 Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n libibumad
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

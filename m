From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] debian: Do not build ibacm for non-Linux architectures
Date: Tue, 14 Nov 2017 12:33:28 +0100
Message-ID: <20171114113330.2715-2-benjamin.drung@profitbricks.com>
References: <20171114113330.2715-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114113330.2715-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core is tied to the Linux kernel. Thus we do not want to build it
on non-Linux architectures (like hurd-i386, kfreebsd-amd64, and
kfreebsd-i386). The build was tried on the non-Linux architectures,
because ibacm was marked to build on any architecture. Therefore also
mark ibacm as linux-any.
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index fef59ad5..5fee479c 100644
--- a/debian/control
+++ b/debian/control
@@ -44,7 +44,7 @@ Description: RDMA core userspace infrastructure and documentation
     standard socket interface.
 
 Package: ibacm
-Architecture: any
+Architecture: linux-any
 Depends: lsb-base (>= 3.2-14~),
          rdma-core (>= 15),
          ${misc:Depends},
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

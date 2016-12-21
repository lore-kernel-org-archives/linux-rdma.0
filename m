From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 3/6] redhat/spec: use fully versioned Requires on base package
Date: Wed, 21 Dec 2016 17:08:37 -0500
Message-ID: <20161221220840.36268-4-jarod@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fedora packaging guidelines spell this at as an explicit requirement.

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index f9ebad1..42d624b 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -66,7 +66,7 @@ RDMA core development libraries and headers.
 Summary: A library and drivers for direct userspace use of RDMA (InfiniBand/iWARP) hardware
 Requires(post): /sbin/ldconfig
 Requires(postun): /sbin/ldconfig
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 Provides: libcxgb3 = %{version}-%{release}
 Obsoletes: libcxgb3 < %{version}-%{release}
 Provides: libcxgb4 = %{version}-%{release}
@@ -124,7 +124,7 @@ Summary: InfiniBand Communication Manager Assistant
 Requires(post): systemd-units
 Requires(preun): systemd-units
 Requires(postun): systemd-units
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n ibacm
 The ibacm daemon helps reduce the load of managing path record lookups on
@@ -141,7 +141,7 @@ Summary: iWarp Port Mapper userspace daemon
 Requires(post): systemd-units
 Requires(preun): systemd-units
 Requires(postun): systemd-units
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n iwpmd
 iwpmd provides a userspace service for iWarp drivers to claim
@@ -150,7 +150,7 @@ tcp ports through the standard socket interface.
 %package -n libibcm
 Summary: Userspace InfiniBand Connection Manager
 ExcludeArch: s390 s390x
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n libibcm
 libibcm provides a userspace library that handles the majority of the low
@@ -158,7 +158,7 @@ level work required to open an RDMA connection between two machines.
 
 %package -n libibumad
 Summary: OpenFabrics Alliance InfiniBand umad (userspace management datagram) library
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n libibumad
 libibumad provides the userspace management datagram (umad) library
@@ -167,7 +167,7 @@ are used by the IB diagnostic and management tools, including OpenSM.
 
 %package -n librdmacm
 Summary: Userspace RDMA Connection Manager
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n librdmacm
 librdmacm provides a userspace RDMA Communication Managment API.
@@ -187,7 +187,7 @@ Obsoletes: openib-srptools <= 0.0.6
 Requires(post): systemd-units
 Requires(preun): systemd-units
 Requires(postun): systemd-units
-Requires: rdma-core
+Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n srp_daemon
 In conjunction with the kernel ib_srp driver, srp_daemon allows you to
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma-core: Add missing systemd-devel dependency to the SUSE rdma-core.spec
Date: Tue,  5 Dec 2017 17:40:05 -0600
Message-ID: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Without systemd-devel, all rdma-core daemons are using shim version of
systemd include file (in-turn, shim version of systemd functions)
causing them to not communicate with systemd.

Add the missing required systemd-devel package to SUSE's rdma-core.spec
so the correct header file is used and correct functions are linked
with the daemons.

Fixes: 8854eefa60b5 ("suse: Add spec file for SUSE")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 suse/rdma-core.spec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 0eba0507..912a77c5 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -57,6 +57,7 @@ BuildRequires:  pkgconfig
 BuildRequires:  pkgconfig(libsystemd)
 BuildRequires:  pkgconfig(libudev)
 BuildRequires:  pkgconfig(systemd)
+BuildRequires:  pkgconfig(systemd-devel)
 BuildRequires:  pkgconfig(udev)
 BuildRequires:  python3-base
 %ifnarch s390 s390x
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

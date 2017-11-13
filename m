From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 2/2] suse: use python3 by default
Date: Mon, 13 Nov 2017 14:00:27 +0100
Message-ID: <5d515246-0d12-d1a8-eb62-d4a027fa67df@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tumbleweed is to drop older python versions to switch to python3.
Add python3 to the build setup and BuildRequires.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/cbuild     | 2 +-
 suse/rdma-core.spec | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 32bb70df..97703e01 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -309,7 +309,7 @@ class leap(ZypperEnvironment):
         'make',
         'ninja',
         'pkg-config',
-        'python',
+        'python3',
         'rpm-build',
         'systemd-devel',
         'valgrind-devel',
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 4f3638f3..b6de096a 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -58,6 +58,7 @@ BuildRequires:  pkgconfig(libsystemd)
 BuildRequires:  pkgconfig(libudev)
 BuildRequires:  pkgconfig(systemd)
 BuildRequires:  pkgconfig(udev)
+BuildRequires:  python3-base
 %ifnarch s390 s390x
 BuildRequires:  valgrind-devel
 %endif
-- 
2.15.0.167.g7819e496d

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

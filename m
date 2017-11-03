From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core] suse: Bump OpenSUSE version to 42.3
Date: Fri, 3 Nov 2017 09:45:34 +0100
Message-ID: <5a062a7f-f6b3-9e34-b990-e36dc1b3bc2d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/cbuild | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 918bf233..fac1c3c6 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -292,13 +292,14 @@ class ZypperEnvironment(Environment):
         return res;
 
 class leap(ZypperEnvironment):
-    docker_parent = "opensuse:42.2";
+    docker_parent = "opensuse:42.3";
     specfile = "suse/rdma-core.spec";
     pkgs = {
         'cmake',
         'gcc',
         'libnl3-devel',
         'libudev-devel',
+        'udev',
         'make',
         'ninja',
         'pkg-config',
@@ -307,7 +308,7 @@ class leap(ZypperEnvironment):
         'systemd-devel',
         'valgrind-devel',
     };
-    name = "opensuse-42.2";
+    name = "opensuse-42.3";
     aliases = {"leap"};
 
 class tumbleweed(ZypperEnvironment):
-- 
2.14.1.461.g503560879

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

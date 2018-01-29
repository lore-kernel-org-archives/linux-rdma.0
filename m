From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] cbuild: Replace Fedora 26 with Fedora 27
Date: Mon, 29 Jan 2018 12:07:45 +0200
Message-ID: <20180129100745.31727-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/cbuild | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 3f659bf8..16743a51 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -127,10 +127,10 @@ class centos7_epel(centos7):
         res.lines.append("RUN ln -s /usr/bin/cmake3 /usr/local/bin/cmake");
         return res;

-class fc26(Environment):
-    docker_parent = "fedora:26";
+class fc27(Environment):
+    docker_parent = "fedora:27";
     pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
-    name = "fc26";
+    name = "fc27";
     specfile = "redhat/rdma-core.spec";
     ninja_cmd = "ninja-build";
     is_rpm = True;
@@ -336,7 +336,7 @@ environments = [centos6(),
                 artful(),
                 jessie(),
                 stretch(),
-                fc26(),
+                fc27(),
                 leap(),
                 tumbleweed(),
                 debian_experimental(),
--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

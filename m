From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Fri, 12 Jan 2018 13:52:09 +0200
Message-ID: <20180112115209.17437-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add Fedora 27 to the list of cbuild targets.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/cbuild | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 3f659bf8..0ef80b60 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -141,6 +141,20 @@ class fc26(Environment):
             " ".join(sorted(self.pkgs))));
         return res;

+class fc27(Environment):
+    docker_parent = "fedora:27";
+    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
+    name = "fc27";
+    specfile = "redhat/rdma-core.spec";
+    ninja_cmd = "ninja-build";
+    is_rpm = True;
+
+    def get_docker_file(self):
+        res = DockerFile(self.docker_parent);
+        res.lines.append("RUN dnf install -y %s && dnf clean all"%(
+            " ".join(sorted(self.pkgs))));
+        return res;
+
 # -------------------------------------------------------------------------

 class APTEnvironment(Environment):
@@ -337,6 +351,7 @@ environments = [centos6(),
                 jessie(),
                 stretch(),
                 fc26(),
+                fc27(),
                 leap(),
                 tumbleweed(),
                 debian_experimental(),
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

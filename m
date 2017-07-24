From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 02/21] cbuild: Switch to Fedora Core 26
Date: Mon, 24 Jul 2017 14:00:10 -0600
Message-ID: <1500926429-31822-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Latest release.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/cbuild | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 24136b4d8cc49c..78c9d7a8176ae4 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -126,10 +126,10 @@ class centos7_epel(centos7):
         res.lines.append("RUN ln -s /usr/bin/cmake3 /usr/local/bin/cmake");
         return res;
 
-class fc25(Environment):
-    docker_parent = "fedora:25";
+class fc26(Environment):
+    docker_parent = "fedora:26";
     pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
-    name = "fc25";
+    name = "fc26";
     specfile = "redhat/rdma-core.spec";
     ninja_cmd = "ninja-build";
     is_rpm = True;
@@ -318,7 +318,7 @@ environments = [centos6(),
                 trusty(),
                 xenial(),
                 jessie(),
-                fc25(),
+                fc26(),
                 harlequin(),
                 malachite(),
                 tumbleweed(),
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

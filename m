From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 04/21] cbuild: Use opensuse leap 42.2
Date: Mon, 24 Jul 2017 14:00:12 -0600
Message-ID: <1500926429-31822-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Newest release available on dockerhub

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/cbuild | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 48a8c1ea48ea5e..50e478154b0295 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -304,11 +304,11 @@ class harlequin(ZypperEnvironment):
     name = "opensuse-13.2";
     aliases = {"harelequin"};
 
-class malachite(ZypperEnvironment):
-    docker_parent = "opensuse:42.1";
+class leap(ZypperEnvironment):
+    docker_parent = "opensuse:42.2";
     pkgs = harlequin.pkgs;
-    name = "opensuse-42.1";
-    aliases = {"malachite"};
+    name = "opensuse-42.2";
+    aliases = {"leap"};
 
 class tumbleweed(ZypperEnvironment):
     docker_parent = "opensuse:tumbleweed";
@@ -327,7 +327,7 @@ environments = [centos6(),
                 stretch(),
                 fc26(),
                 harlequin(),
-                malachite(),
+                leap(),
                 tumbleweed(),
                 debian_experimental(),
 ];
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

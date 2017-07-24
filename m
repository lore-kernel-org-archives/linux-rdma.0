From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 03/21] cbuild: Add debian stretch
Date: Mon, 24 Jul 2017 14:00:11 -0600
Message-ID: <1500926429-31822-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Latest stable debian release

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/cbuild | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 78c9d7a8176ae4..48a8c1ea48ea5e 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -182,6 +182,12 @@ class jessie(APTEnvironment):
     name = "debian-8";
     aliases = {"jessie"};
 
+class stretch(APTEnvironment):
+    docker_parent = "debian:9"
+    pkgs = trusty.pkgs;
+    name = "debian-9";
+    aliases = {"stretch"};
+
 class debian_experimental(APTEnvironment):
     docker_parent = "debian:experimental"
     pkgs = (trusty.pkgs ^ {"gcc"}) | {"gcc-7"};
@@ -318,6 +324,7 @@ environments = [centos6(),
                 trusty(),
                 xenial(),
                 jessie(),
+                stretch(),
                 fc26(),
                 harlequin(),
                 malachite(),
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

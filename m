From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 4/5] buildlib/cbuild: Add Ubuntu artful
Date: Thu,  2 Nov 2017 18:55:55 +0200
Message-ID: <20171102165556.22105-5-leon@kernel.org>
References: <20171102165556.22105-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102165556.22105-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds Ubuntu17.10 artful, that comes with GCC 7

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 buildlib/cbuild | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 098bec9a..1ddc72c4 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -181,6 +181,12 @@ class xenial(APTEnvironment):
     name = "ubuntu-16.04";
     aliases = {"xenial"};

+class artful(APTEnvironment):
+    docker_parent = "ubuntu:17.10"
+    pkgs = xenial.pkgs
+    name = "ubuntu-17.10";
+    aliases = {"artful"};
+
 class jessie(APTEnvironment):
     docker_parent = "debian:8"
     pkgs = xenial.pkgs;
@@ -325,6 +331,7 @@ environments = [centos6(),
                 travis(),
                 trusty(),
                 xenial(),
+                artful(),
                 jessie(),
                 stretch(),
                 fc26(),
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

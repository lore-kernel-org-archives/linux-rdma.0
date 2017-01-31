From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/6] Add Debian experimental gcc-7 to cbuild
Date: Tue, 31 Jan 2017 14:08:01 -0700
Message-ID: <1485896886-23517-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485896886-23517-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/cbuild | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 98f69dbfba3d9d..31535cb4a8473a 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -181,6 +181,17 @@ class jessie(APTEnvironment):
     name = "debian-8";
     aliases = {"jessie"};
 
+class debian_experimental(APTEnvironment):
+    docker_parent = "debian:experimental"
+    pkgs = (trusty.pkgs ^ {"gcc"}) | {"gcc-7"};
+    name = "debian-experimental";
+
+    def get_docker_file(self):
+        res = DockerFile(self.docker_parent);
+        res.lines.append("RUN apt-get update && apt-get -t experimental install -y --no-install-recommends %s && apt-get clean"%(
+            " ".join(sorted(self.pkgs))));
+        return res;
+
 class travis(APTEnvironment):
     """This parses the .travis.yml "apt" add on and converts it to a dockerfile,
     basically creating a container that is similar to what travis would
@@ -301,6 +312,7 @@ environments = [centos6(),
                 harlequin(),
                 malachite(),
                 tumbleweed(),
+                debian_experimental(),
 ];
 
 class ToEnvAction(argparse.Action):
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 05/21] Make 'cbuild travis pkg' run sparse like real travis
Date: Mon, 24 Jul 2017 14:00:13 -0600
Message-ID: <1500926429-31822-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide a git dir in the container and compute the package set
relative to the current top of tree on github.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 .travis.yml     |  1 +
 buildlib/cbuild | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index 4eba65be3353ca..c190a2418b651a 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -26,6 +26,7 @@ addons:
       - fakeroot
       - gcc
       - gcc-7
+      - git
       - libnl-3-dev
       - libnl-route-3-dev
       - libudev-dev
diff --git a/buildlib/cbuild b/buildlib/cbuild
index 50e478154b0295..888fae6ccca692 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -550,6 +550,16 @@ def run_travis_build(args,env):
             subprocess.check_call(["git",
                                    "--git-dir",os.path.join(opwd,".git"),
                                    "reset","--hard","HEAD"]);
+            subprocess.check_call(["git",
+                                   "--git-dir",os.path.join(opwd,".git"),
+                                   "fetch",
+                                   "--no-tags",
+                                   "https://github.com/linux-rdma/rdma-core.git","HEAD",
+                                   "master"]);
+            base = subprocess.check_output(["git",
+                                            "--git-dir",os.path.join(opwd,".git"),
+                                            "merge-base",
+                                            "HEAD","FETCH_HEAD"]).strip();
 
         home = os.path.join(os.path.sep,"home","travis");
         home_build = os.path.join(os.path.sep,home,"build");
@@ -559,8 +569,10 @@ def run_travis_build(args,env):
             "--read-only",
             "--rm=true",
             "-v","%s:%s"%(tmpdir, home_build),
+            "-v","%s:%s:ro"%(os.path.join(opwd,".git"),os.path.join(home_build,"src",".git")),
             "-w",os.path.join(home_build,"src"),
             "-u",str(os.getuid()),
+            "-e","TRAVIS_COMMIT_RANGE=%s..HEAD"%(base),
             "-e","HOME=%s"%(home),
             "-e","TMPDIR=%s"%(os.path.join(home_build,"tmp")),
         ];
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

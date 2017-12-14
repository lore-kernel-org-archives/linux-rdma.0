From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core] Have cbuild map the git alternates
Date: Thu, 14 Dec 2017 15:41:06 -0700
Message-ID: <20171214224106.31017-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When running commands in the travis configuration it needs access to
the git history to run checkpatch, but if the local repo is using
alternates that fails.

The simple solution is to just map the alternate directories into the
container as well.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/cbuild | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

This is
https://github.com/linux-rdma/rdma-core/pull/277

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 29c5b4b87d9548..3f659bf84ff68d 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -402,6 +402,22 @@ def inDirectory(dir):
     finally:
         os.chdir(cdir);
 
+def map_git_args(src_root,to):
+    """Return a list of docker arguments that will map the .git directory into the
+    container"""
+    srcd = os.path.join(src_root,".git");
+    res = ["-v","%s:%s:ro"%(srcd,
+                            os.path.join(to,".git"))];
+
+    alternates = os.path.join(srcd,"objects/info/alternates");
+    if os.path.exists(alternates):
+        with open(alternates) as F:
+            for I in F.readlines():
+                I = I.strip();
+                res.extend(["-v","%s:%s:ro"%(I,I)]);
+
+    return res;
+
 def get_image_id(args,image_name):
     img = json.loads(docker_cmd_str(args,"inspect",image_name));
     image_id = img[0]["Id"];
@@ -606,7 +622,6 @@ def run_travis_build(args,env):
             "--read-only",
             "--rm=true",
             "-v","%s:%s"%(tmpdir, home_build),
-            "-v","%s:%s:ro"%(os.path.join(opwd,".git"),os.path.join(home_build,"src",".git")),
             "-w",os.path.join(home_build,"src"),
             "-u",str(os.getuid()),
             "-e","TRAVIS_COMMIT_RANGE=%s..HEAD"%(base),
@@ -614,7 +629,7 @@ def run_travis_build(args,env):
             "-e","TRAVIS_EVENT_TYPE=pull_request",
             "-e","HOME=%s"%(home),
             "-e","TMPDIR=%s"%(os.path.join(home_build,"tmp")),
-        ];
+        ] + map_git_args(opwd,os.path.join(home_build,"src"));
 
         # Load the commands from the travis file
         with open(os.path.join(opwd,".travis.yml")) as F:
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

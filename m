From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 1/3] cbuild: Support distros that only ship python3
Date: Mon, 15 Jan 2018 14:13:45 -0700
Message-ID: <20180115211347.5651-2-jgg@ziepe.ca>
References: <20180115211347.5651-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115211347.5651-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

SuSE tumbleweed is no longer shipping python2 by default, at least
in the minimal docker image. This breaks cbuild and travis.

Revise this little scriptlet we run in the container to support
both versions of python and use python3 in tumbleweed.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/cbuild | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 3f659bf84ff68d..6e52328d489dea 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -73,6 +73,7 @@ class DockerFile(object):
         self.lines = ["FROM %s"%(src)];
 
 class Environment(object):
+    python_cmd = "python";
     aliases = set();
     use_make = False;
     proxy = True;
@@ -324,6 +325,9 @@ class tumbleweed(ZypperEnvironment):
     name = "tumbleweed";
     specfile = "suse/rdma-core.spec";
     rpmbuild_options = [ "--without=curlmini" ];
+    # tumbleweed no longer includes python2 in the base docker images, only python3,
+    # use that instead.
+    python_cmd = "python3";
 
 # -------------------------------------------------------------------------
 
@@ -474,17 +478,17 @@ def run_rpm_build(args,spec_file,env):
             print >> F,"""
 import os,subprocess;
 with open("/etc/passwd","a") as F:
-   print >> F, {passwd!r};
+   F.write({passwd!r} + "\\n");
 with open("/etc/group","a") as F:
-   print >> F, {group!r};
+   F.write({group!r} + "\\n");
 os.setgid({gid:d});
 os.setuid({uid:d});
 
 # Get RPM to tell us the expected tar filename.
 for ln in subprocess.check_output(["rpmspec","-P",{tspec_file!r}]).splitlines():
-   if ln.startswith("Source:"):
-      tarfn = ln.strip().partition(' ')[2].strip();
-os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
+   if ln.startswith(b"Source:"):
+      tarfn = ln.strip().partition(b' ')[2].strip();
+os.symlink({tarfn!r},os.path.join(b"SOURCES",tarfn));
 """.format(passwd=":".join(str(I) for I in pwd.getpwuid(os.getuid())),
            group=":".join(str(I) for I in grp.getgrgid(os.getgid())),
            uid=os.getuid(),
@@ -505,7 +509,7 @@ os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
         if args.run_shell:
             opts.append("/bin/bash");
         else:
-            opts.extend(["python","go.py"]);
+            opts.extend([env.python_cmd,"go.py"]);
 
         docker_cmd(args,*opts)
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

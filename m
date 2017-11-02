From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 2/5] cbuild: Properly create tarball for SuSE
Date: Thu,  2 Nov 2017 18:55:53 +0200
Message-ID: <20171102165556.22105-3-leon@kernel.org>
References: <20171102165556.22105-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102165556.22105-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The tarball was not created at the expected path by SUSE scripts,
causing rpmbuild to fail with the following error:
error: File /usr/src/packages/SOURCES/rdma-core-16.tar.gz: No such file or directory

This patch fixes the issue by adding ".rpmmacros" file to root's home
folder and sets "%_topdir" to the path where we place the source tarball.

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 buildlib/cbuild | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index d1455b6f..098bec9a 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -415,13 +415,15 @@ def run_rpm_build(args,spec_file,env):

     image_id = get_image_id(args,env.image_name());
     with private_tmp(args) as tmpdir:
-        os.mkdir(os.path.join(tmpdir,"SOURCES"));
+        builddir = os.path.join(tmpdir,"builddir")
+        os.mkdir(builddir);
+        os.mkdir(os.path.join(builddir,"SOURCES"));
         os.mkdir(os.path.join(tmpdir,"tmp"));

         subprocess.check_call(["git","archive",
                                # This must match the prefix generated buildlib/github-release
                                "--prefix","%s-%s/"%(project,get_version()),
-                               "--output",os.path.join(tmpdir,"SOURCES",tarfn),
+                               "--output",os.path.join(builddir,"SOURCES",tarfn),
                                "HEAD"]);

         with open(spec_file,"r") as inF:
@@ -431,18 +433,21 @@ def run_rpm_build(args,spec_file,env):
             outF.write("".join(spec));

         home = os.path.join(os.path.sep,"home",os.getenv("LOGNAME"));
-        vdir = os.path.join(home,"rpmbuild");

         opts = [
             "run",
             "--rm=true",
-            "-v","%s:%s"%(tmpdir,vdir),
-            "-w",vdir,
+            "-v","%s:%s"%(tmpdir,home),
+            "-w",home,
             "-h","builder-%s"%(image_id[:12]),
             "-e","HOME=%s"%(home),
-            "-e","TMPDIR=%s"%(os.path.join(vdir,"tmp")),
+            "-e","TMPDIR=%s"%(os.path.join(home,"tmp")),
         ];

+        # set _topdir for rpmbuild under SUSE since it's different than RedHat
+        with open(os.path.join(tmpdir,".rpmmacros"),"w") as F:
+            print >> F,"%%_topdir %s"%os.path.join(home,"builddir")
+
         # rpmbuild complains if we do not have an entry in passwd and group
         # for the user we are going to use to do the build.
         with open(os.path.join(tmpdir,"go.py"),"w") as F:
@@ -459,7 +464,7 @@ os.setuid({uid:d});
 for ln in subprocess.check_output(["rpmspec","-P",{tspec_file!r}]).splitlines():
    if ln.startswith("Source:"):
       tarfn = ln.strip().partition(' ')[2].strip();
-os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
+os.symlink({tarfn!r},os.path.join("builddir","SOURCES",tarfn));
 """.format(passwd=":".join(str(I) for I in pwd.getpwuid(os.getuid())),
            group=":".join(str(I) for I in grp.getgrgid(os.getgid())),
            uid=os.getuid(),
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

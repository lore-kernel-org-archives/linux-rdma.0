From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Fri, 4 Aug 2017 18:59:10 +0200
Message-ID: <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27366048-d80f-3711-c6cd-93c87809650e-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Generate a temporary file with the spec file parsed and all its macro replaced.
Avoid manually replacing Version and handle extra macros

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 .gitignore      | 3 +++
 buildlib/cbuild | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index f31a0617..52c7af2f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -69,3 +69,6 @@ tramp
 Session.vim
 .netrwhist
 *~
+
+# rpm
+*/*.spec.processed
\ No newline at end of file
diff --git a/buildlib/cbuild b/buildlib/cbuild
index 5228ec1b..cf7828eb 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -404,7 +404,12 @@ def get_image_id(args,image_name):
 
 def run_rpm_build(args,spec_file,env):
     version = get_version();
-    with open(spec_file,"r") as F:
+
+    # Pre-process file with rpm spec to avoid manually replacing macros
+    f = open(spec_file + ".processed", "w");
+    subprocess.check_call(["rpmspec", "-P", spec_file], stdout=f);
+
+    with open(spec_file + ".processed" ,"r") as F:
         for ln in F:
             if ln.startswith("Version:"):
                 ver = ln.strip().partition(' ')[2].strip();
@@ -412,7 +417,6 @@ def run_rpm_build(args,spec_file,env):
 
             if ln.startswith("Source:"):
                 tarfn = ln.strip().partition(' ')[2].strip();
-    tarfn = tarfn.replace("%{version}",version);
 
     image_id = get_image_id(args,env.image_name());
     with private_tmp(args) as tmpdir:
-- 
2.14.0.rc1.4.gab083fa77.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

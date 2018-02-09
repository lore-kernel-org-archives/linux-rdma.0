From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 7/7] Check that published headers do not rely on internal headers
Date: Thu,  8 Feb 2018 20:09:04 -0700
Message-ID: <20180209030904.22370-8-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We already check that the published headers can be compiled, but that
test is done with our build directory in the search path, and can
see a full set of kernel headers.

This new CI test ensures that only glibc headers or two allowed kernel
headers are being #include'd by the public headers. This prevents
a very easy mistake to use a kernel ABI or private header in
the wrong place.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/check-build | 86 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 69 insertions(+), 17 deletions(-)

diff --git a/buildlib/check-build b/buildlib/check-build
index bfd53b21b789a4..766db7ae46259f 100755
--- a/buildlib/check-build
+++ b/buildlib/check-build
@@ -10,6 +10,7 @@ import shutil
 import subprocess
 import tempfile
 import sys
+import copy
 from contextlib import contextmanager;
 
 def get_src_dir():
@@ -204,31 +205,82 @@ def is_fixup(fn):
         return "buildlib/fixup-include/" in os.readlink(fn);
     return False;
 
-def test_public_headers(args):
-    """Test that every header file can be included on its own, and has no obvious
-    implicit dependencies. This is mainly intended to check the public
-    headers, but this sweeps in published internal headers too."""
-    incdir = os.path.abspath(os.path.join(args.BUILD,"include"));
+def get_headers(incdir):
     includes = set();
     for root,dirs,files in os.walk(incdir):
         for I in files:
             if I.endswith(".h"):
                 includes.add(os.path.join(root,I));
+    return includes;
+
+def compile_test_headers(tmpd,incdir,includes):
+    with open(os.path.join(tmpd,"build.ninja"),"wt") as F:
+        print >> F,"rule comp";
+        print >> F," command = %s -Werror -c -I %s $in -o $out"%(args.CC,incdir);
+        print >> F," description=Header check for $in";
+        count = 0;
+        for I in sorted(includes):
+            if is_obsolete(I) or is_fixup(I):
+                continue;
+            print >> F,"build %s : comp %s"%("out%d.o"%(count),I);
+            print >> F,"default %s"%("out%d.o"%(count));
+            count = count + 1;
+    subprocess.check_call(["ninja"],cwd=tmpd);
+
+def test_published_headers(args):
+    """Test that every header file can be included on its own, and has no obvious
+    implicit dependencies. This is intended as a first pass check of the public
+    installed API headers"""
+    incdir = os.path.abspath(os.path.join(args.BUILD,"include"));
+    includes = get_headers(incdir);
 
     # Make a little ninja file to compile each header
     with private_tmp() as tmpd:
-        with open(os.path.join(tmpd,"build.ninja"),"wt") as F:
-            print >> F,"rule comp";
-            print >> F," command = %s -Werror -c -I %s $in -o $out"%(args.CC,incdir);
-            print >> F," description=Header check for $in";
-            count = 0;
-            for I in sorted(includes):
-                if is_obsolete(I) or is_fixup(I):
-                    continue;
-                print >> F,"build %s : comp %s"%("out%d.o"%(count),I);
-                print >> F,"default %s"%("out%d.o"%(count));
-                count = count + 1;
-        subprocess.check_call(["ninja"],cwd=tmpd);
+        compile_test_headers(tmpd,incdir,includes);
+
+# -------------------------------------------------------------------------
+
+allowed_uapi_headers = {
+    # This header is installed in all supported distributions
+    "rdma/ib_user_sa.h",
+    "rdma/ib_user_verbs.h",
+}
+
+def test_installed_headers(args):
+    """This test also checks that the public headers can be compiled on their own,
+    but goes further and confirms that the public headers do not depend on any
+    internal headers, or kernel kAPI headers."""
+    with private_tmp() as tmpd:
+        env = copy.deepcopy(os.environ);
+        env["DESTDIR"] = tmpd;
+        subprocess.check_output(["ninja","install"],env=env);
+
+        includes = get_headers(tmpd);
+        incdir = os.path.commonprefix(includes);
+        rincludes = {I[len(incdir):] for I in includes};
+
+        bincdir = os.path.abspath(os.path.join(args.BUILD,"include"));
+        all_includes = set();
+        for I in get_headers(bincdir):
+            if not is_fixup(I) and not is_obsolete(I):
+                all_includes.add(I[len(bincdir)+1:]);
+
+        # Drop error includes for any include file that is internal, this way
+        # when we compile the public headers any include of an internal header
+        # will fail.
+        for I in sorted(all_includes - rincludes):
+            if I in allowed_uapi_headers:
+                continue;
+
+            I = os.path.join(incdir,I)
+            dfn = os.path.dirname(I);
+            if not os.path.isdir(dfn):
+                os.makedirs(dfn);
+            assert not os.path.exists(I);
+            with open(I,"w") as F:
+                print >> F,'#error "Private internal header"';
+
+        compile_test_headers(tmpd,incdir,includes);
 
 # -------------------------------------------------------------------------
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

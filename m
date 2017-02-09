From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 01/10] Have check-build confirm that every public header is standalone
Date: Thu,  9 Feb 2017 14:53:23 -0700
Message-ID: <1486677212-3188-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Public library headers should be includable without requiring other
headers to be included first. We confirm this by compiling each header
in a stand alone compilation unit.

Add a few minor missing headers to make the check pass.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/check-build     | 55 +++++++++++++++++++++++++++++++++++++++++++++++-
 librdmacm/ib.h           |  1 +
 librdmacm/rdma_cma_abi.h |  1 +
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/buildlib/check-build b/buildlib/check-build
index 45e7cb41c83f39..ddb3383e6a5514 100755
--- a/buildlib/check-build
+++ b/buildlib/check-build
@@ -5,7 +5,9 @@ import argparse
 import inspect
 import os
 import re
+import shutil
 import subprocess
+import tempfile
 from contextlib import contextmanager;
 
 def get_src_dir():
@@ -34,6 +36,15 @@ def inDirectory(dir):
     finally:
         os.chdir(cdir);
 
+@contextmanager
+def private_tmp():
+    """Simple version of Python 3's tempfile.TemporaryDirectory"""
+    dfn = tempfile.mkdtemp();
+    try:
+        yield dfn;
+    finally:
+        shutil.rmtree(dfn);
+
 # -------------------------------------------------------------------------
 
 def get_symbol_vers(fn):
@@ -80,7 +91,6 @@ def check_lib_symver(args,fn):
         raise ValueError("Too many private symbol versions in ELF %r (%r)"%(fn,private));
     if private:
         private_rel = list(private)[0].split('_')[-1];
-        print repr(private_rel)
         if private_rel > args.PACKAGE_VERSION:
             raise ValueError("Private Symbol Version %r is newer than the package version %r"%(
                 private,args.PACKAGE_VERSION));
@@ -106,6 +116,49 @@ def test_lib_names(args):
 
 # -------------------------------------------------------------------------
 
+def is_obsolete(fn):
+    """True if the header is obsolete and should not be compiled anyhow."""
+    with open(fn) as F:
+        for ln in F.readlines():
+            if re.search(r"#warning.*This header is obsolete",ln):
+                return True;
+    return False;
+
+def is_fixup(fn):
+    """True if this is a fixup header, fixup headers are exempted because they
+    required includes are not the same for kernel headers (eg netinet/in.h)"""
+    if os.path.islink(fn):
+        return "buildlib/fixup-include/" in os.readlink(fn);
+    return False;
+
+def test_public_headers(args):
+    """Test that every header file can be included on its own, and has no obvious
+    implicit dependencies. This is mainly intended to check the public
+    headers, but this sweeps in published internal headers too."""
+    incdir = os.path.abspath(os.path.join(args.BUILD,"include"));
+    includes = set();
+    for root,dirs,files in os.walk(incdir):
+        for I in files:
+            if I.endswith(".h"):
+                includes.add(os.path.join(root,I));
+
+    # Make a little ninja file to compile each header
+    with private_tmp() as tmpd:
+        with open(os.path.join(tmpd,"build.ninja"),"wt") as F:
+            print >> F,"rule comp";
+            print >> F," command = cc -c -I %s $in -o $out"%(incdir);
+            print >> F," description=Header check for $in";
+            count = 0;
+            for I in sorted(includes):
+                if is_obsolete(I) or is_fixup(I):
+                    continue;
+                print >> F,"build %s : comp %s"%("out%d.o"%(count),I);
+                print >> F,"default %s"%("out%d.o"%(count));
+                count = count + 1;
+        subprocess.check_call(["ninja"],cwd=tmpd);
+
+# -------------------------------------------------------------------------
+
 parser = argparse.ArgumentParser(description='Run build time tests')
 parser.add_argument("--build",default=os.getcwd(),dest="BUILD",
                     help="Build directory to inpsect");
diff --git a/librdmacm/ib.h b/librdmacm/ib.h
index 2e5029ac29b2dc..eb6cd871dbc7a7 100644
--- a/librdmacm/ib.h
+++ b/librdmacm/ib.h
@@ -34,6 +34,7 @@
 #define _RDMA_IB_H
 
 #include <linux/types.h>
+#include <arpa/inet.h>
 #include <string.h>
 
 #ifndef AF_IB
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index 71b93f888cc861..92fb63d9b6f0eb 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -36,6 +36,7 @@
 #include <infiniband/kern-abi.h>
 #include <rdma/ib_user_sa.h>
 #include <infiniband/sa.h>
+#include <netinet/in.h>
 
 /*
  * This file must be kept in sync with the kernel's version of rdma_user_cm.h
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

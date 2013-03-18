From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] infiniband-diags: fix rst2man when using upstream
 docutils
Date: Mon, 18 Mar 2013 17:42:14 -0400
Message-ID: <51478a36.ZrUNUxwMPWSTIAS+%ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The upstream docutils package does not install "rst2man".  Instead the executable
is "rst2man.py".  Check for both options before giving up.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in |    3 +++
 doc/generate |   16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/configure.in b/configure.in
index edac1e3..a85d2ed 100644
--- a/configure.in
+++ b/configure.in
@@ -181,6 +181,9 @@ dnl Generate doc/man/*.in files if possible
 DOC_DATE="`date +%Y-%m-%d`"
 AC_SUBST(BUILD_DATE)
 AC_CHECK_PROG(have_rst2man, rst2man, "yes")
+if test x$have_rst2man != xyes; then
+AC_CHECK_PROG(have_rst2man, rst2man.py, "yes")
+fi
 if test x$have_rst2man == xyes; then
 	doc/generate
 else
diff --git a/doc/generate b/doc/generate
index 68a4cbd..816b66f 100755
--- a/doc/generate
+++ b/doc/generate
@@ -5,12 +5,22 @@ mode=$1
 
 cd $docdir
 
+rst2man=""
+
+rc=`which rst2man &> /dev/null`
+if [ "$?" == "0" ]; then
+	rst2man="rst2man"
+fi
+rc=`which rst2man.py &> /dev/null`
+if [ "$?" == "0" ]; then
+	rst2man="rst2man.py"
+fi
+
 if [ "$mode" == "" ]; then
 	if [ ! -d man ]; then
 		mkdir man
 	fi
-	rc=`which rst2man &> /dev/null`
-	if [ "$?" != "0" ]; then
+	if [ "$rst2man" == "" ]; then
 		echo "could not generate man pages; 'rst2man not found'"
 		exit 1
 	fi
@@ -18,7 +28,7 @@ if [ "$mode" == "" ]; then
 		file=`basename $file`
 		target=`echo $file | sed -e 's/\(.*\).rst/\1/'`
 		echo "   creating man/$target ..."
-		rst2man rst/$file > man/$target
+		$rst2man rst/$file > man/$target
 	done
 elif [ "$mode" == "clean" ]; then
 	rm -f man/*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

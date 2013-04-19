From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: add .gitignore
Date: Fri, 19 Apr 2013 10:07:33 -0700
Message-ID: <20130419100733.11d74423936db4a8ff372749@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 .gitignore |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..390c6d7
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,43 @@
+*.o
+*.lo
+*~
+configure
+Makefile.in
+autom4te.cache
+aclocal.m4
+stamp-h.in
+config.h.in
+config.log
+config.h
+.libs
+.deps
+libibverbs.spec
+Makefile
+config.status
+stamp-h1
+libtool
+INSTALL
+infiniband-diags.spec
+include/ibdiag_version.h
+doc/man/*.8
+scripts/dump_lfts.sh
+scripts/dump_mfts.sh
+scripts/ibcheckerrors
+scripts/ibcheckerrs
+scripts/ibchecknet
+scripts/ibchecknode
+scripts/ibcheckport
+scripts/ibcheckportstate
+scripts/ibcheckportwidth
+scripts/ibcheckstate
+scripts/ibcheckwidth
+scripts/ibclearcounters
+scripts/ibclearerrors
+scripts/ibdatacounters
+scripts/ibdatacounts
+scripts/ibhosts
+scripts/iblinkinfo.pl
+scripts/ibnodes
+scripts/ibqueryerrors.pl
+scripts/ibrouters
+scripts/ibswitches
-- 
1.7.0.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ibaddr: Add missing -t option to manpage
Date: Thu, 10 Oct 2013 15:29:12 +0200
Message-ID: <20131010132912.GA21069@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing 'timeout' option

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/man/ibaddr.8.in     |    4 ++++
 doc/rst/ibaddr.8.in.rst |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/doc/man/ibaddr.8.in b/doc/man/ibaddr.8.in
index 8a804d7..9e25223 100644
--- a/doc/man/ibaddr.8.in
+++ b/doc/man/ibaddr.8.in
@@ -155,6 +155,10 @@ ibaddr \-C mthca0 \-P 2  # use the specified port only.
 .UNINDENT
 .UNINDENT
 .SS Configuration flags
+.\" Define the common option -t
+.
+.sp
+\fB\-t, \-\-timeout <timeout_ms>\fP override the default timeout for the solicited mads.
 .\" Define the common option -y
 .
 .INDENT 0.0
diff --git a/doc/rst/ibaddr.8.in.rst b/doc/rst/ibaddr.8.in.rst
index 6713fcf..ac18bbf 100644
--- a/doc/rst/ibaddr.8.in.rst
+++ b/doc/rst/ibaddr.8.in.rst
@@ -69,6 +69,7 @@ Configuration flags
 -------------------
 
 .. include:: common/opt_y.rst
+.. include:: common/opt_t.rst
 .. include:: common/opt_z-config.rst
 
 FILES
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ibtracert.c: Add 'force' flag to man page
Date: Sun, 13 Oct 2013 09:48:36 +0200
Message-ID: <20131013074836.GA11041@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add 'force' route option to man page.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/man/ibtracert.8.in     |    7 +++++++
 doc/rst/ibtracert.8.in.rst |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/doc/man/ibtracert.8.in b/doc/man/ibtracert.8.in
index 9bc0317..4ca938e 100644
--- a/doc/man/ibtracert.8.in
+++ b/doc/man/ibtracert.8.in
@@ -108,6 +108,13 @@ ibaddr \-C mthca0 \-P 2  # use the specified port only.
 .UNINDENT
 .UNINDENT
 .SS Debugging flags
+.\" Define the common option -f
+.
+.INDENT 0.0
+.TP
+.B \-f
+force route to destination port.
+.UNINDENT
 .\" Define the common option -d
 .
 .INDENT 0.0
diff --git a/doc/rst/ibtracert.8.in.rst b/doc/rst/ibtracert.8.in.rst
index e6b9823..76fe568 100644
--- a/doc/rst/ibtracert.8.in.rst
+++ b/doc/rst/ibtracert.8.in.rst
@@ -34,6 +34,8 @@ OPTIONS
 **-m**
         show the multicast trace of the specified mlid
 
+**-f, --force**
+        force route to destination port
 
 
 Addressing Flags
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

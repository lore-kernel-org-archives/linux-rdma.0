From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] Update MAINTAINERS
Date: Mon, 27 Nov 2017 16:50:32 -0700
Message-ID: <20171127235032.GA7380@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Revise Jason's email and add Jason as an overall maintainer.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .mailmap    | 8 ++++++++
 MAINTAINERS | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 .mailmap

PR:

https://github.com/linux-rdma/rdma-core/pull/260

diff --git a/.mailmap b/.mailmap
new file mode 100644
index 00000000000000..227f3aa8f7ebe7
--- /dev/null
+++ b/.mailmap
@@ -0,0 +1,8 @@
+#
+# This list is used by git-shortlog to fix a few botched name translations
+# in the git archive, either because the author's full name was messed up
+# and/or not always written the same way, making contributions from the
+# same person appearing not to be so or badly displayed.
+#
+Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 194a2da02f322f..e6f139501b7393 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -31,10 +31,11 @@ Descriptions of section entries:
 * OVERALL PACKAGE
 M:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
+M:	Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
 
 BUILD SYSTEM
-M:	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
+M:	Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
 F:	*/CMakeLists.txt
 F:	*/lib*.map
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

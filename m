From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 13/23] rdmacm: Fix leading \'s in rcopy man page
Date: Wed, 21 Sep 2016 16:08:39 -0600
Message-ID: <1474495729-17604-14-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Debian's Lintian remarks:

W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man1/rcopy.1.gz 15: warning: numeric expression expected (got `u')

And indeed the man page displays corrupted. The leading \ is only needed
if the text starts with - so drop it on all other cases.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/man/rcopy.1 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/librdmacm/man/rcopy.1 b/librdmacm/man/rcopy.1
index a5ad76aa8742..e875458bf162 100644
--- a/librdmacm/man/rcopy.1
+++ b/librdmacm/man/rcopy.1
@@ -12,13 +12,13 @@ Uses sockets over RDMA interface to copy a source file to the
 specified destination. 
 .SH "OPTIONS"
 .TP
-\source
+source
 The name and path of the source file to copy.
 .TP
-\server
+server
 The name or address of the destination server.
 .TP
-\:destination
+:destination
 An optional destination filename and path.  If not given, the destination
 filename will match that of the source.
 .TP
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

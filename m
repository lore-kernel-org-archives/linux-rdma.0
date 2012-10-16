From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] rdma_xserver/client: Fix man page formatting
Date: Tue, 16 Oct 2012 12:44:39 -0700
Message-ID: <1350416679-6001-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Putting 'r' at the beginning of a line in the nroff source for man pages
is confusing to nroff because lines that start with a single quote
character ' or a dot character . are treated as control lines, which is
not what's intended here.  Some of the man page text ends up left out of
the formatted output.

Fix this by just wrapping the text slightly differently in the source
(which doesn't matter since nroff reflows the text anyway).  Also add a
missing ".TP" so that the -p and -c options are not run together in the
formatted output.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 man/rdma_xclient.1 |    5 +++--
 man/rdma_xserver.1 |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/man/rdma_xclient.1 b/man/rdma_xclient.1
index 087e7fe..b4bb045 100644
--- a/man/rdma_xclient.1
+++ b/man/rdma_xclient.1
@@ -20,9 +20,10 @@ By default, the client will attempt to connect to the server using
 \-p server_port
 Specifies the port number that the server listens on.  By default the server
 listens on port 7471.
+.TP
 \-c communication type
-Specifies the type of communication established with the server program.
-'r' results in using a reliable-connected QP (the default).  'x' uses
+Specifies the type of communication established with the server program.  'r'
+results in using a reliable-connected QP (the default).  'x' uses
 extended reliable-connected XRC QPs.
 .SH "NOTES"
 Basic usage is to start rdma_xserver, then connect to the server using the
diff --git a/man/rdma_xserver.1 b/man/rdma_xserver.1
index 75529e4..a26c962 100644
--- a/man/rdma_xserver.1
+++ b/man/rdma_xserver.1
@@ -14,9 +14,10 @@ data.
 \-p port
 Changes the port number that the server listens on.  By default the server
 listens on port 7471.
+.TP
 \-c communication type
-Specifies the type of communication established with the client program.
-'r' results in using a reliable-connected QP (the default).  'x' uses
+Specifies the type of communication established with the client program.  'r'
+results in using a reliable-connected QP (the default).  'x' uses
 extended reliable-connected XRC QPs.
 .SH "NOTES"
 Basic usage is to start rdma_xserver, then connect to the server using the
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

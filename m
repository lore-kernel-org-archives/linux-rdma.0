From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 01/20] xprtrdma: Add rdma6 option to support NFS/RDMA IPv6
Date: Mon, 02 May 2016 14:40:23 -0400
Message-ID: <20160502184022.10798.85913.stgit@manet.1015granger.net>
References: <20160502183144.10798.99847.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502183144.10798.99847.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

RFC 5666: The "rdma" netid is to be used when IPv4 addressing
is employed by the underlying transport, and "rdma6" for IPv6
addressing.

Add mount -o proto=rdma6 option to support NFS/RDMA IPv6 addressing.

Changes from v2:
 - Integrated comments from Chuck Level, Anna Schumaker, Trodt Myklebust
 - Add a little more to the patch description to describe NFS/RDMA
   IPv6 suggested by Chuck Level and Anna Schumaker
 - Removed duplicated rdma6 define
 - Remove Opt_xprt_rdma mountfamily since it doesn't support

Signed-off-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f126828..c884155 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -191,6 +191,7 @@ static const match_table_t nfs_mount_option_tokens = {
 
 enum {
 	Opt_xprt_udp, Opt_xprt_udp6, Opt_xprt_tcp, Opt_xprt_tcp6, Opt_xprt_rdma,
+	Opt_xprt_rdma6,
 
 	Opt_xprt_err
 };
@@ -201,6 +202,7 @@ static const match_table_t nfs_xprt_protocol_tokens = {
 	{ Opt_xprt_tcp, "tcp" },
 	{ Opt_xprt_tcp6, "tcp6" },
 	{ Opt_xprt_rdma, "rdma" },
+	{ Opt_xprt_rdma6, "rdma6" },
 
 	{ Opt_xprt_err, NULL }
 };
@@ -1456,6 +1458,8 @@ static int nfs_parse_mount_options(char *raw,
 				mnt->flags |= NFS_MOUNT_TCP;
 				mnt->nfs_server.protocol = XPRT_TRANSPORT_TCP;
 				break;
+			case Opt_xprt_rdma6:
+				protofamily = AF_INET6;
 			case Opt_xprt_rdma:
 				/* vector side protocols to TCP */
 				mnt->flags |= NFS_MOUNT_TCP;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

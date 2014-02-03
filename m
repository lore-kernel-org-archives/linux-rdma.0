From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/8] NFS: Use port 20049 by default for NFS/RDMA mounts
Date: Mon, 03 Feb 2014 16:02:50 -0500
Message-ID: <20140203210250.3533.66371.stgit@manet.1015granger.net>
References: <20140203205903.3533.39213.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140203205903.3533.39213.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When providing NFSv2 and v3 service via RDMA, NFS servers MAY use an
alternative well-known port number, 20049.  They are not required to
register the service with their local rpcbind.  At least one server
implementation I am aware of does not register.

When providing NFSv4 service via RDMA, the server MUST use the
alternative port number, 20049.  As with NFSv4 on IP-based
transports, clients SHOULD connect to this port without consulting
the server's rpcbind, so we can't expect rpcbind to help here
either.

See section 6 of RFC 5667 for details.

Today, admins are required to specify "port=" when mounting an
NFS/RDMA server.  To comply with RFC 5667 and for cross-
compatibility with heterogenous automounter maps, provide the proper
default port when mounting with "proto=rdma".

If the server does not use port 20049, the "port=" mount option is
still required to mount successfully.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=68401
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 fs/nfs/super.c           |    2 ++
 include/uapi/linux/nfs.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 910ed90..6432600 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2157,6 +2157,8 @@ static int nfs_validate_text_mount_data(void *options,
 	} else
 		nfs_set_mount_transport_protocol(args);
 
+	if (args->nfs_server.protocol == XPRT_TRANSPORT_RDMA)
+		port = NFS_RDMA_PORT;
 	nfs_set_port(sap, &args->nfs_server.port, port);
 
 	return nfs_parse_devname(dev_name,
diff --git a/include/uapi/linux/nfs.h b/include/uapi/linux/nfs.h
index 5199a36..ccc6f8d 100644
--- a/include/uapi/linux/nfs.h
+++ b/include/uapi/linux/nfs.h
@@ -9,6 +9,7 @@
 
 #define NFS_PROGRAM	100003
 #define NFS_PORT	2049
+#define NFS_RDMA_PORT	20049
 #define NFS_MAXDATA	8192
 #define NFS_MAXPATHLEN	1024
 #define NFS_MAXNAMLEN	255

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

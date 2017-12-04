From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/4] nfs: Define NFS_RDMA_PORT
Date: Mon, 04 Dec 2017 14:13:30 -0500
Message-ID: <20171204191330.18629.77069.stgit@manet.1015granger.net>
References: <20171204190904.18629.70341.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171204190904.18629.70341.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The NFS/RDMA port assignment is specified in Section 9 of RFC 8267.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/nfs.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/nfs.h b/include/uapi/linux/nfs.h
index 057d22a..946cb62 100644
--- a/include/uapi/linux/nfs.h
+++ b/include/uapi/linux/nfs.h
@@ -12,6 +12,7 @@
 
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

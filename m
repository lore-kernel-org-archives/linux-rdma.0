From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 17/17] NFS: Fix size of NFSACL SETACL operations
Date: Tue, 26 May 2015 11:53:52 -0400
Message-ID: <20150526155352.4542.1803.stgit@manet.1015granger.net>
References: <20150526153926.4542.96409.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526153926.4542.96409.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When encoding the NFSACL SETACL operation, reserve just the estimated
size of the ACL rather than a fixed maximum. This eliminates needless
zero padding on the wire that the server ignores.

Fixes: ee5dc7732bd5 ('NFS: Fix "kernel BUG at fs/nfs/nfs3xdr.c:1338!"')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/nfs3xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 53852a4..9b04c2e 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -1342,7 +1342,7 @@ static void nfs3_xdr_enc_setacl3args(struct rpc_rqst *req,
 	if (args->npages != 0)
 		xdr_write_pages(xdr, args->pages, 0, args->len);
 	else
-		xdr_reserve_space(xdr, NFS_ACL_INLINE_BUFSIZE);
+		xdr_reserve_space(xdr, args->len);
 
 	error = nfsacl_encode(xdr->buf, base, args->inode,
 			    (args->mask & NFS_ACL) ?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

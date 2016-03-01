From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 01/14] nfsd: Update NFS server comments related to RDMA
 support
Date: Tue, 01 Mar 2016 13:05:27 -0500
Message-ID: <20160301180527.2492.28091.stgit@klimt.1015granger.net>
References: <20160301180337.2492.4255.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301180337.2492.4255.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The server does indeed now support NFSv4.1 on RDMA transports. It
does not support shifting an RDMA-capable TCP transport (such as
iWARP) to RDMA mode.

Reported-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfsd/nfs4state.c |    5 ++---
 fs/nfsd/nfs4xdr.c   |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c484a2b..12940cb 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2710,10 +2710,9 @@ nfsd4_create_session(struct svc_rqst *rqstp,
 		goto out_free_conn;
 	}
 	status = nfs_ok;
-	/*
-	 * We do not support RDMA or persistent sessions
-	 */
+	/* Persistent sessions are not supported */
 	cr_ses->flags &= ~SESSION4_PERSIST;
+	/* Upshifting from TCP to RDMA is not supported */
 	cr_ses->flags &= ~SESSION4_RDMA;
 
 	init_session(rqstp, new, conf, cr_ses);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d6ef095..a12a2ea 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3060,7 +3060,7 @@ static __be32 nfsd4_encode_bind_conn_to_session(struct nfsd4_compoundres *resp,
 		p = xdr_encode_opaque_fixed(p, bcts->sessionid.data,
 						NFS4_MAX_SESSIONID_LEN);
 		*p++ = cpu_to_be32(bcts->dir);
-		/* Sorry, we do not yet support RDMA over 4.1: */
+		/* Upshifting from TCP to RDMA is not supported */
 		*p++ = cpu_to_be32(0);
 	}
 	return nfserr;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

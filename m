From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/4] SUNRPC: Remove rpc_protocol()
Date: Mon, 04 Dec 2017 14:13:55 -0500
Message-ID: <20171204191354.18629.23260.stgit@manet.1015granger.net>
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

Since nfs4_create_referral_server was the only call site of
rpc_protocol, rpc_protocol can now be removed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/clnt.h |    1 -
 net/sunrpc/clnt.c           |   16 ----------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 71c237e..ed761f7 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -179,7 +179,6 @@ struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
 int		rpc_restart_call_prepare(struct rpc_task *);
 int		rpc_restart_call(struct rpc_task *);
 void		rpc_setbufsize(struct rpc_clnt *, unsigned int, unsigned int);
-int		rpc_protocol(struct rpc_clnt *);
 struct net *	rpc_net_ns(struct rpc_clnt *);
 size_t		rpc_max_payload(struct rpc_clnt *);
 size_t		rpc_max_bc_payload(struct rpc_clnt *);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e2a4184..6e432ec 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1376,22 +1376,6 @@ int rpc_localaddr(struct rpc_clnt *clnt, struct sockaddr *buf, size_t buflen)
 EXPORT_SYMBOL_GPL(rpc_setbufsize);
 
 /**
- * rpc_protocol - Get transport protocol number for an RPC client
- * @clnt: RPC client to query
- *
- */
-int rpc_protocol(struct rpc_clnt *clnt)
-{
-	int protocol;
-
-	rcu_read_lock();
-	protocol = rcu_dereference(clnt->cl_xprt)->prot;
-	rcu_read_unlock();
-	return protocol;
-}
-EXPORT_SYMBOL_GPL(rpc_protocol);
-
-/**
  * rpc_net_ns - Get the network namespace for this RPC client
  * @clnt: RPC client to query
  *

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

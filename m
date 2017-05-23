From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 08/12] NFSv4.1: Handle EXCHGID4_FLAG_CONFIRMED_R during
 NFSv4.1 migration
Date: Tue, 23 May 2017 10:54:43 -0400
Message-ID: <20170523145442.961.53875.stgit@manet.1015granger.net>
References: <20170523142629.961.81233.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523142629.961.81233.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Transparent State Migration copies a client's lease state from the
server where a filesystem used to reside to the server where it now
resides. When an NFSv4.1 client first contacts that destination
server, it uses EXCHANGE_ID to detect trunking relationships.

The lease that was copied there is returned to that client, but the
destination server sets EXCHGID4_FLAG_CONFIRMED_R when replying to
the client. This is because the lease was confirmed on the source
server (before it was copied).

Normally, when CONFIRMED_R is set, a client purges the lease and
creates a new one. However, that throws away the entire benefit of
Transparent State Migration.

Therefore, the client must not purge that lease, and it must use the
contrived slot sequence value returned by the destination for its
first CREATE_SESSION operation.

Reported-by: Xuan Qi <xuan.qi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/nfs4proc.c  |    2 +-
 fs/nfs/nfs4state.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c08c46a..54e561a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7375,11 +7375,11 @@ static void nfs4_exchange_id_done(struct rpc_task *task, void *data)
 	if (status == 0) {
 		clp->cl_clientid = cdata->res.clientid;
 		clp->cl_exchange_flags = cdata->res.flags;
+		clp->cl_seqid = cdata->res.seqid;
 		/* Client ID is not confirmed */
 		if (!(cdata->res.flags & EXCHGID4_FLAG_CONFIRMED_R)) {
 			clear_bit(NFS4_SESSION_ESTABLISHED,
 			&clp->cl_session->session_state);
-			clp->cl_seqid = cdata->res.seqid;
 		}
 
 		kfree(clp->cl_serverowner);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b34de03..1b8a848 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -341,6 +341,7 @@ int nfs41_discover_server_trunking(struct nfs_client *clp,
 				   struct rpc_cred *cred)
 {
 	int status;
+	bool tsm;
 
 	status = nfs4_proc_exchange_id(clp, cred);
 	if (status != NFS4_OK)
@@ -352,8 +353,14 @@ int nfs41_discover_server_trunking(struct nfs_client *clp,
 	if (clp != *result)
 		return 0;
 
-	/* Purge state if the client id was established in a prior instance */
-	if (clp->cl_exchange_flags & EXCHGID4_FLAG_CONFIRMED_R)
+	/*
+	 * Purge state if the client id was established in a prior
+	 * instance and the client id could not have arrived on the
+	 * server via Transparent State Migration.
+	 */
+	tsm = test_bit(NFS4CLNT_MOVED, &clp->cl_state) ||
+	      test_bit(NFS4CLNT_LEASE_MOVED, &clp->cl_state);
+	if (clp->cl_exchange_flags & EXCHGID4_FLAG_CONFIRMED_R && !tsm)
 		set_bit(NFS4CLNT_PURGE_STATE, &clp->cl_state);
 	else
 		set_bit(NFS4CLNT_LEASE_CONFIRM, &clp->cl_state);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

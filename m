From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/13] NFSv4.1: Use seqid returned by EXCHANGE_ID after
 state migration
Date: Thu, 08 Jun 2017 11:52:52 -0400
Message-ID: <20170608155252.18945.61089.stgit@manet.1015granger.net>
References: <20170608154339.18945.5500.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608154339.18945.5500.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

When CONFIRMED_R is set, the client throws away the sequence ID
returned by the server. During a Transparent State Migration, however
there's no other way for the client to know what sequence ID to use
with a lease that's been migrated.

Therefore, the client must save and use the contrived slot sequence
value returned by the destination server even when CONFIRMED_R is
set.

Note that some servers always return a seqid of 1 after a migration.

Reported-by: Xuan Qi <xuan.qi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Xuan Qi <xuan.qi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/nfs4proc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c08c46a..04dd718 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7375,12 +7375,11 @@ static void nfs4_exchange_id_done(struct rpc_task *task, void *data)
 	if (status == 0) {
 		clp->cl_clientid = cdata->res.clientid;
 		clp->cl_exchange_flags = cdata->res.flags;
+		clp->cl_seqid = cdata->res.seqid;
 		/* Client ID is not confirmed */
-		if (!(cdata->res.flags & EXCHGID4_FLAG_CONFIRMED_R)) {
+		if (!(cdata->res.flags & EXCHGID4_FLAG_CONFIRMED_R))
 			clear_bit(NFS4_SESSION_ESTABLISHED,
-			&clp->cl_session->session_state);
-			clp->cl_seqid = cdata->res.seqid;
-		}
+				  &clp->cl_session->session_state);
 
 		kfree(clp->cl_serverowner);
 		clp->cl_serverowner = cdata->res.server_owner;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

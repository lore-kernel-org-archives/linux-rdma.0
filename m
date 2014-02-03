From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/8] NFS: advertise only supported callback netids
Date: Mon, 03 Feb 2014 16:02:40 -0500
Message-ID: <20140203210240.3533.87689.stgit@manet.1015granger.net>
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

NFSv4.0 clients use the SETCLIENTID operation to inform NFS servers
how to contact a client's callback service.  If a server cannot
contact a client's callback service, that server will not delegate
to that client, which results in a performance loss.

Our client advertises "rdma" as the callback netid when the forward
channel is "rdma".  But our client always starts only "tcp" and
"tcp6" callback services.

Instead of advertising the forward channel netid, advertise "tcp"
or "tcp6" as the callback netid, based on the value of the
clientaddr mount option, since those are what our client currently
supports.

(Note: this approach is appropriate for older kernels too, but this
patch doesn't apply cleanly on kernels earlier than 3.11).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69171
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.11+
---

 fs/nfs/nfs4proc.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 15052b8..09dd967 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4883,6 +4883,20 @@ nfs4_init_uniform_client_string(const struct nfs_client *clp,
 				nodename);
 }
 
+/*
+ * nfs4_callback_up_net() starts only "tcp" and "tcp6" callback
+ * services.  Advertise one based on the address family of the
+ * clientaddr.
+ */
+static unsigned int
+nfs4_init_callback_netid(const struct nfs_client *clp, char *buf, size_t len)
+{
+	if (strchr(clp->cl_ipaddr, ':') != NULL)
+		return scnprintf(buf, len, "tcp6");
+	else
+		return scnprintf(buf, len, "tcp");
+}
+
 /**
  * nfs4_proc_setclientid - Negotiate client ID
  * @clp: state data structure
@@ -4924,12 +4938,10 @@ int nfs4_proc_setclientid(struct nfs_client *clp, u32 program,
 						setclientid.sc_name,
 						sizeof(setclientid.sc_name));
 	/* cb_client4 */
-	rcu_read_lock();
-	setclientid.sc_netid_len = scnprintf(setclientid.sc_netid,
-				sizeof(setclientid.sc_netid), "%s",
-				rpc_peeraddr2str(clp->cl_rpcclient,
-							RPC_DISPLAY_NETID));
-	rcu_read_unlock();
+	setclientid.sc_netid_len =
+				nfs4_init_callback_netid(clp,
+						setclientid.sc_netid,
+						sizeof(setclientid.sc_netid));
 	setclientid.sc_uaddr_len = scnprintf(setclientid.sc_uaddr,
 				sizeof(setclientid.sc_uaddr), "%s.%u.%u",
 				clp->cl_ipaddr, port >> 8, port & 255);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

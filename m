From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/4] nfs: Update server port after referral or migration
Date: Mon, 04 Dec 2017 14:13:46 -0500
Message-ID: <20171204191346.18629.677.stgit@manet.1015granger.net>
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

After traversing a referral or recovering from a migration event,
ensure that the server port reported in /proc/mounts is updated
to the correct port setting for the new submount.

Reported-by: Helen Chao <helen.chao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/nfs4client.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index a3d5592..5bc722e 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -852,6 +852,7 @@ static int nfs4_set_client(struct nfs_server *server,
 		set_bit(NFS_CS_MIGRATION, &cl_init.init_flags);
 	if (test_bit(NFS_MIG_TSM_POSSIBLE, &server->mig_status))
 		set_bit(NFS_CS_TSM_POSSIBLE, &cl_init.init_flags);
+	server->port = rpc_get_port(addr);
 
 	/* Allocate or find a client reference we can use */
 	clp = nfs_get_client(&cl_init);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

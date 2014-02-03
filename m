From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/8] NFS: incorrect "port=" value in /proc/mounts
Date: Mon, 03 Feb 2014 16:02:58 -0500
Message-ID: <20140203210258.3533.80680.stgit@manet.1015granger.net>
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

Mounting with "-o vers=4" shows the following in /proc/mounts:

  ... namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2, ...
                                ^^^^^^

The default port, 2049, was actually used, but was never recorded
in this mount point's nfs_server.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69241
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---

 fs/nfs/client.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 1d09289..2bb6dee 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -924,6 +924,7 @@ void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_server *sour
 	target->flags = source->flags;
 	target->rsize = source->rsize;
 	target->wsize = source->wsize;
+	target->port = source->port;
 	target->acregmin = source->acregmin;
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

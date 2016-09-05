From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 19/28] verbs: Avoid gcc 6.1 warning -Wunused-variable
Date: Mon,  5 Sep 2016 15:08:09 -0600
Message-ID: <1473109698-31408-20-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

gcc remarks:

../libibverbs/src/neigh.c:339:6: warning: 'sock_fd' may be used uninitialized in this function [-Wmaybe-uninitialized]
  err = try_send_to(sock_fd, buff, sizeof(buff), &addr_dst);

But this is bogus because create_socket will always return
an error if it does not set psock_fd. It looks like the
insane if logic is just a tish too much for gcc to handle.

Since the result of create_socket is discarded anyhow, simplify the
tortured logic.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/src/neigh.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/libibverbs/src/neigh.c b/libibverbs/src/neigh.c
index 799b810a9ec4..dc8c2bc99ae3 100644
--- a/libibverbs/src/neigh.c
+++ b/libibverbs/src/neigh.c
@@ -207,7 +207,7 @@ static int create_socket(struct get_neigh_handler *neigh_handler,
 				    &addr_src.len);
 	if (err) {
 		errno = EADDRNOTAVAIL;
-		return err;
+		return -1;
 	}
 
 	addr_dst->len = sizeof(addr_dst->sktaddr);
@@ -216,24 +216,22 @@ static int create_socket(struct get_neigh_handler *neigh_handler,
 				    &addr_dst->len);
 	if (err) {
 		errno = EADDRNOTAVAIL;
-		return err;
+		return -1;
 	}
 
 	err = set_link_port(&addr_dst->sktaddr, PORT_DISCARD,
 			    neigh_handler->oif);
 	if (err)
-		return err;
+		return -1;
 
 	sock_fd = socket(addr_dst->sktaddr.s.sa_family,
 			 SOCK_DGRAM | SOCK_CLOEXEC, 0);
 	if (sock_fd == -1)
-		return errno ? -errno : -1;
+		return -1;
 	err = bind(sock_fd, &addr_src.sktaddr.s, addr_src.len);
 	if (err) {
-		int bind_err = -errno;
-
 		close(sock_fd);
-		return bind_err ?: EADDRNOTAVAIL;
+		return -1;
 	}
 
 	*psock_fd = sock_fd;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

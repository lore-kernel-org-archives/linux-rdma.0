From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
Date: Sun, 9 Oct 2016 17:19:36 -0600
Message-ID: <20161009231936.GA24139@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-27-git-send-email-jgunthorpe@obsidianresearch.com>
 <9ae84345-4427-4689-e6d1-0bfa3eb19630@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ae84345-4427-4689-e6d1-0bfa3eb19630-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 09, 2016 at 04:31:17PM +0300, Yishai Hadas wrote:

> >-	if (write(connfd, msg, sizeof msg) != sizeof msg) {
> >-		fprintf(stderr, "Couldn't send local address\n");
> >+	if (write(connfd, msg, sizeof msg) != sizeof msg ||
> >+	    read(connfd, msg, sizeof msg) != sizeof msg) {
> >+		fprintf(stderr, "Couldn't send/recv local address\n");
> 
> At that step the server expects to read a "done" response from its client,
> checking whether the read was done for sizeof msg which is much larger will
> fail.

This OK?

>From db525af53140c3b7604ab45406ed8845cb6171e1 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Sun, 9 Oct 2016 17:17:54 -0600
Subject: [PATCH] verbs: Fix read error check in pingpong

Turns out these reads rely on the short readed caused by EOS.

Fixes: f3912df771db (Avoid gcc 5.4 warning -Wunused-result)
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/rc_pingpong.c  | 2 +-
 libibverbs/examples/srq_pingpong.c | 2 +-
 libibverbs/examples/uc_pingpong.c  | 2 +-
 libibverbs/examples/ud_pingpong.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index c92e551c00e6..aca7bac4491b 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -309,7 +309,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg ||
-	    read(connfd, msg, sizeof msg) != sizeof msg) {
+	    read(connfd, msg, sizeof msg) != sizeof "done") {
 		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index 863ff10dd0f4..8f55d78e87d4 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -333,7 +333,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		}
 	}
 
-	if (read(connfd, msg, sizeof msg) != sizeof msg) {
+	if (read(connfd, msg, sizeof msg) != sizeof "done") {
 		perror("client write");
 		free(rem_dest);
 		rem_dest = NULL;
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index 2b105b947cf3..b565bacaff2a 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -283,7 +283,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg ||
-	    read(connfd, msg, sizeof msg) != sizeof msg) {
+	    read(connfd, msg, sizeof msg) != sizeof "done") {
 		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index d0cd73cc0fae..ddb68cf8624b 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -280,7 +280,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg ||
-	    read(connfd, msg, sizeof msg) != sizeof msg) {
+	    read(connfd, msg, sizeof msg) != sizeof "done") {
 		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

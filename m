From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 09/23] verbs: Fix incorrect type of len
Date: Wed, 21 Sep 2016 16:08:35 -0600
Message-ID: <1474495729-17604-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

gcc remarks:

../librdmacm/examples/udpong.c:301:11: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
   if (len < 0)

len is set by:
		len = svr_recv(&msg, sizeof msg, &addr, &addrlen);

And svr_recv returns:

static ssize_t svr_recv(struct message *msg, size_t size,

So clearly len is the wrong type, and the error test does
not work.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/examples/udpong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/librdmacm/examples/udpong.c b/librdmacm/examples/udpong.c
index 6affc62d5a84..0f44f50e6e88 100644
--- a/librdmacm/examples/udpong.c
+++ b/librdmacm/examples/udpong.c
@@ -291,7 +291,7 @@ out:
 
 static int svr_run(void)
 {
-	size_t len;
+	ssize_t len;
 	int ret;
 
 	ret = svr_bind();
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 12/23] rdmacm: Use correct format specifier for size_t
Date: Wed, 21 Sep 2016 16:08:38 -0600
Message-ID: <1474495729-17604-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

clang 3.6 remarks:

../librdmacm/examples/rping.c:1203:30: warning: invalid conversion specifier 'Z' [-Wformat-invalid-specifier]
                                       "(valid range is %Zd to %d)\n",

And indeed, the correct specifier for size_t is '%zd'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/examples/rping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index 171857dcb5ca..c248e66aaa83 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -1201,7 +1201,7 @@ int main(int argc, char *argv[])
 			if ((cb->size < RPING_MIN_BUFSIZE) ||
 			    (cb->size > (RPING_BUFSIZE - 1))) {
 				fprintf(stderr, "Invalid size %d "
-				       "(valid range is %Zd to %d)\n",
+				       "(valid range is %zd to %d)\n",
 				       cb->size, RPING_MIN_BUFSIZE, RPING_BUFSIZE);
 				ret = EINVAL;
 			} else
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

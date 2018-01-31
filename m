From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] rc_pingpong: Fix getopt processing of -t
Date: Tue, 30 Jan 2018 17:04:15 -0700
Message-ID: <20180131000415.GA29879@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The -t option never had an argument, a : was erroneously added when
the -c option was added

Fixes: 099c5aa50bc8 ("libibverb/examples: Add command line option to enable buffer validation")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/examples/rc_pingpong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index b5153bceb8254b..cf5c045741b7be 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -730,7 +730,7 @@ int main(int argc, char *argv[])
 			{}
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:ot:c",
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:otc",
 				long_options, NULL);
 
 		if (c == -1)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

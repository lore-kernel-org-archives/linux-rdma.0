From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
Date: Fri, 11 Feb 2011 22:43:57 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ok, someone needs to double check me on this before merging anything, but 
don't we want to allocate sizeof(struct ib_mad_snoop_private) here, rather 
than just the size of a pointer to the struct?

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 compile tested only. no hardware available for proper test.

diff --git 
a/drivers/infiniband/core/mad.c 
b/drivers/infiniband/core/mad.c
index 822cfdc..2c74b85 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -413,7 +413,7 @@ static int register_snoop_agent(struct ib_mad_qp_info *qp_info,
 	if (i == qp_info->snoop_table_size) {
 		/* Grow table. */
 		new_snoop_table = krealloc(qp_info->snoop_table,
-					   sizeof mad_snoop_priv *
+					   sizeof(struct ib_mad_snoop_private) *
 					   (qp_info->snoop_table_size + 1),
 					   GFP_ATOMIC);
 		if (!new_snoop_table) {


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/libmlx4] Fix generation of IBV_WC_GRH
Date: Fri, 4 Mar 2011 19:45:46 -0700
Message-ID: <20110305024546.GA29147@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Byte swap was erroneously using short not long, so the test always
returns false as 0x80000000 is greater than 16 bits.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Found and tested on a MT25418

Looks like this is a cut and paste error from libmthca which has a
similar line.

Also confirmed that the kernel has a correct version.

diff --git a/src/cq.c b/src/cq.c
index 2d04883..bc53f9b 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -317,7 +317,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		wc->src_qp	   = ntohl(cqe->g_mlpath_rqpn) & 0xffffff;
 		wc->dlid_path_bits = (ntohl(cqe->g_mlpath_rqpn) >> 24) & 0x7f;
 		wc->pkey_index     = ntohl(cqe->immed_rss_invalid) >> 16;
-		wc->wc_flags      |= ntohs(cqe->g_mlpath_rqpn) & 0x80000000 ?
+		wc->wc_flags      |= ntohl(cqe->g_mlpath_rqpn) & 0x80000000 ?
 			IBV_WC_GRH : 0;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

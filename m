From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Wed, 26 Aug 2015 11:00:37 +0200
Message-ID: <1440579639-10684-2-git-send-email-hch@lst.de>
References: <1440579639-10684-1-git-send-email-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1440579639-10684-1-git-send-email-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Eli Cohen <eli@mellanox.com>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We have many WR opcodes that are only supported in kernel space
and/or require optional information to be copied into the WR
structure.  Reject all those not explicitly handled so that we
can't pass invalid information to drivers.

Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a15318a..be4cb9f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2372,6 +2372,12 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		next->send_flags = user_wr->send_flags;
 
 		if (is_ud) {
+			if (next->opcode != IB_WR_SEND &&
+			    next->opcode != IB_WR_SEND_WITH_IMM) {
+				ret = -EINVAL;
+				goto out_put;
+			}
+
 			next->wr.ud.ah = idr_read_ah(user_wr->wr.ud.ah,
 						     file->ucontext);
 			if (!next->wr.ud.ah) {
@@ -2411,9 +2417,11 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 					user_wr->wr.atomic.compare_add;
 				next->wr.atomic.swap = user_wr->wr.atomic.swap;
 				next->wr.atomic.rkey = user_wr->wr.atomic.rkey;
+			case IB_WR_SEND:
 				break;
 			default:
-				break;
+				ret = -EINVAL;
+				goto out_put;
 			}
 		}
 
-- 
1.9.1

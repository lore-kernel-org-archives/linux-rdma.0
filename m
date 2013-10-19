From: Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>
Subject: [PATCH] IB/core: Pass imm_data from ib_uverbs_send_wr to ib_send_wr
 correctly when sending UD messages
Date: Sat, 19 Oct 2013 15:55:41 -0600
Message-ID: <20131019215540.GA8544@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently, the infiniband subsystem doesn't copy the immediate data
from the userspace struct to the kernel one when UD messages are being
sent.

This patch makes sure that the immediate data is set correctly.

Signed-off-by: Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f2b81b9..ba207e1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2126,6 +2126,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			}
 			next->wr.ud.remote_qpn  = user_wr->wr.ud.remote_qpn;
 			next->wr.ud.remote_qkey = user_wr->wr.ud.remote_qkey;
+			if (next->opcode == IB_WR_SEND_WITH_IMM)
+				next->ex.imm_data =
+					(__be32 __force) user_wr->ex.imm_data;
 		} else {
 			switch (next->opcode) {
 			case IB_WR_RDMA_WRITE_WITH_IMM:
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

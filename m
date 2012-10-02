From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] RDMA/nes: Fix for cpp code analyzer warning
Date: Tue, 2 Oct 2012 11:38:12 -0500
Message-ID: <20121002163812.GA9268@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for cpp code analyzer warning about missing break in a switch statement

Reported-by: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8b8812d..c4cfd85 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3006,6 +3006,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					switch (nesqp->hw_iwarp_state) {
 						case NES_AEQE_IWARP_STATE_CLOSING:
 							next_iwarp_state = NES_CQP_QP_IWARP_STATE_CLOSING;
+							break;
 						case NES_AEQE_IWARP_STATE_TERMINATE:
 							next_iwarp_state = NES_CQP_QP_IWARP_STATE_TERMINATE;
 							break;
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

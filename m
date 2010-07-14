From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH/RFC] RDMA/nes: Rewrite expression to avoid undefined semantics
Date: Wed, 14 Jul 2010 13:30:34 -0700
Message-ID: <ada630hx0ut.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Change code like

	x = expr(++x)

that assigns to x twice without a sequence point in between to the
intended (and well-defined)

	x = expr(x + 1)

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
I'll queue this for 2.6.36 unless someone objects.

 drivers/infiniband/hw/nes/nes_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 57874a1..f41d890 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1970,7 +1970,7 @@ void nes_destroy_nic_qp(struct nes_vnic *nesvnic)
 			dev_kfree_skb(
 				nesvnic->nic.tx_skb[nesvnic->nic.sq_tail]);
 
-		nesvnic->nic.sq_tail = (++nesvnic->nic.sq_tail)
+		nesvnic->nic.sq_tail = (nesvnic->nic.sq_tail + 1)
 					& (nesvnic->nic.sq_size - 1);
 	}
 
-- 
1.7.1.1


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

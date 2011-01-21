From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] RDMA/cxgb4: Set the correct device physical function for
	iwarp connections.
Date: Fri, 21 Jan 2011 11:00:34 -0600
Message-ID: <20110121170034.23741.14120.stgit@build.ogc.int>
References: <20110121170028.23741.61673.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110121170028.23741.61673.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The PF passed to FW was 0 causing PCI failures in an SR-IOV environment.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0dc62b1..52e777a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -380,7 +380,8 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 					  16)) | FW_WR_FLOWID(ep->hwtid));
 
 	flowc->mnemval[0].mnemonic = FW_FLOWC_MNEM_PFNVFN;
-	flowc->mnemval[0].val = cpu_to_be32(0);
+	flowc->mnemval[0].val = cpu_to_be32(
+		PCI_FUNC(ep->com.dev->rdev.lldi.pdev->devfn) << 8);
 	flowc->mnemval[1].mnemonic = FW_FLOWC_MNEM_CH;
 	flowc->mnemval[1].val = cpu_to_be32(ep->tx_chan);
 	flowc->mnemval[2].mnemonic = FW_FLOWC_MNEM_PORT;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

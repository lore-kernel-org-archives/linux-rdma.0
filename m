From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND 2.6.37 2/2] RDMA/cxgb4: Use cxgb4 service for packet gl
	to skb.
Date: Mon, 18 Oct 2010 10:16:45 -0500
Message-ID: <20101018151645.32196.13438.stgit@build.ogc.int>
References: <20101018151640.32196.78946.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101018151640.32196.78946.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the local service t4_pktgl_to_skb() and use cxgb4_pktgl_to_skb()
exported by cxgb4.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   42 +---------------------------------
 1 files changed, 1 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 22a290d..54fbc11 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -454,46 +454,6 @@ out:
 	return dev;
 }
 
-static struct sk_buff *t4_pktgl_to_skb(const struct pkt_gl *gl,
-				       unsigned int skb_len,
-				       unsigned int pull_len)
-{
-	struct sk_buff *skb;
-	struct skb_shared_info *ssi;
-
-	if (gl->tot_len <= 512) {
-		skb = alloc_skb(gl->tot_len, GFP_ATOMIC);
-		if (unlikely(!skb))
-			goto out;
-		__skb_put(skb, gl->tot_len);
-		skb_copy_to_linear_data(skb, gl->va, gl->tot_len);
-	} else {
-		skb = alloc_skb(skb_len, GFP_ATOMIC);
-		if (unlikely(!skb))
-			goto out;
-		__skb_put(skb, pull_len);
-		skb_copy_to_linear_data(skb, gl->va, pull_len);
-
-		ssi = skb_shinfo(skb);
-		ssi->frags[0].page = gl->frags[0].page;
-		ssi->frags[0].page_offset = gl->frags[0].page_offset + pull_len;
-		ssi->frags[0].size = gl->frags[0].size - pull_len;
-		if (gl->nfrags > 1)
-			memcpy(&ssi->frags[1], &gl->frags[1],
-			       (gl->nfrags - 1) * sizeof(skb_frag_t));
-		ssi->nr_frags = gl->nfrags;
-
-		skb->len = gl->tot_len;
-		skb->data_len = skb->len - pull_len;
-		skb->truesize += skb->data_len;
-
-		/* Get a reference for the last page, we don't own it */
-		get_page(gl->frags[gl->nfrags - 1].page);
-	}
-out:
-	return skb;
-}
-
 static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 			const struct pkt_gl *gl)
 {
@@ -518,7 +478,7 @@ static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 		c4iw_ev_handler(dev, qid);
 		return 0;
 	} else {
-		skb = t4_pktgl_to_skb(gl, 128, 128);
+		skb = cxgb4_pktgl_to_skb(gl, 128, 128);
 		if (unlikely(!skb))
 			goto nomem;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

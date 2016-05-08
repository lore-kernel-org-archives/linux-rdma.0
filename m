From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 02/11] IB/core: allow passing mapping an offset into
	the SG in ib_map_mr_sg
Date: Sun, 8 May 2016 10:08:57 +0200
Message-ID: <20160508080857.GA11016@lst.de>
References: <1462291273-22403-1-git-send-email-hch@lst.de> <1462291273-22403-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462291273-22403-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

i40iw grew MR support since the last version, so we'll need the fixup
below as well.  Doug, what's your plan for the series?  Should I repost
with this folded?  It would be really great to get this in before the
merge window ends in a week..

---
>From c1bbcbeabf333cbf8ac5739af69b05998576b721 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Date: Sun, 8 May 2016 10:05:12 +0200
Subject: IB/i40iw: pass through MR offset

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index eaa79c9..141eaba 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1573,12 +1573,13 @@ static int i40iw_set_page(struct ib_mr *ibmr, u64 addr)
  * @sg: scatter gather list for fmr
  * @sg_nents: number of sg pages
  */
-static int i40iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents)
+static int i40iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		int sg_nents, unsigned int sg_offset)
 {
 	struct i40iw_mr *iwmr = to_iwmr(ibmr);
 
 	iwmr->npages = 0;
-	return ib_sg_to_pages(ibmr, sg, sg_nents, i40iw_set_page);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, i40iw_set_page);
 }
 
 /**
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

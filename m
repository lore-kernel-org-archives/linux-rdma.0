From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] ib/ehca: bitmask handling for lock_hcalls
Date: Thu, 10 Jun 2010 11:06:53 +0200
Message-ID: <20100610110653.17885a81@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix reading capability bit from device capabilities for hcall locking.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---

Hi Roland, this applies against 2.6.35-rc2 and we would like to get
it into your -next tree, thanks!

 drivers/infiniband/hw/ehca/ehca_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.35-rc2.orig/drivers/infiniband/hw/ehca/ehca_main.c
+++ linux-2.6.35-rc2/drivers/infiniband/hw/ehca/ehca_main.c
@@ -360,7 +360,8 @@ static int ehca_sense_attributes(struct 
 	 * a firmware property, so it's valid across all adapters
 	 */
 	if (ehca_lock_hcalls == -1)
-		ehca_lock_hcalls = !(shca->hca_cap & HCA_CAP_H_ALLOC_RES_SYNC);
+		ehca_lock_hcalls = !EHCA_BMASK_GET(HCA_CAP_H_ALLOC_RES_SYNC,
+					shca->hca_cap);
 
 	/* translate supported MR page sizes; always support 4K */
 	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

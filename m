From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 06/9] ib/iser: use atomic allocations
Date: Mon, 8 Feb 2010 15:20:43 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081520140.16288@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002081509400.16288-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Two minor flows in iser's data path still use allocations,
move them to be atomic as a preperation step towards moving
to use libiscsi passthrough mode.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 drivers/infiniband/ulp/iser/iser_memory.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -373,7 +373,7 @@ int iser_send_data_out(struct iscsi_conn
 	iser_dbg("%s itt %d dseg_len %d offset %d\n",
 		 __func__,(int)itt,(int)data_seg_len,(int)buf_offset);

-	tx_desc = kmem_cache_zalloc(ig.desc_cache, GFP_NOIO);
+	tx_desc = kmem_cache_zalloc(ig.desc_cache, GFP_ATOMIC);
 	if (tx_desc == NULL) {
 		iser_err("Failed to alloc desc for post dataout\n");
 		return -ENOMEM;
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_memory.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_memory.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_memory.c
@@ -53,10 +53,10 @@ static int iser_start_rdma_unaligned_sg(
 	unsigned long  cmd_data_len = data->data_len;

 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
-		mem = (void *)__get_free_pages(GFP_NOIO,
+		mem = (void *)__get_free_pages(GFP_ATOMIC,
 		      ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
 	else
-		mem = kmalloc(cmd_data_len, GFP_NOIO);
+		mem = kmalloc(cmd_data_len, GFP_ATOMIC);

 	if (mem == NULL) {
 		iser_err("Failed to allocate mem size %d %d for copying sglist\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

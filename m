From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/usnic: Fix resource leak in error case
Date: Wed,  9 Dec 2015 10:42:18 -0800
Message-ID: <1449686539-29959-5-git-send-email-neescoba@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index b306870..5f44b66 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -575,7 +575,7 @@ alloc_res_chunk_list(struct usnic_vnic *vnic,
 	return res_chunk_list;
 
 out_free_res:
-	for (i--; i > 0; i--)
+	for (i--; i >= 0; i--)
 		usnic_vnic_put_resources(res_chunk_list[i]);
 	kfree(res_chunk_list);
 	return ERR_PTR(err);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

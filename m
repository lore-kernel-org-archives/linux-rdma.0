From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 4/8] Add completion timestamp support for ibv_poll_cq_ex
Date: Wed, 24 Feb 2016 11:42:00 +0200
Message-ID: <1456306924-31298-5-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for raw completion timestamp through
ibv_poll_cq_ex.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index a64e320..232b0df 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -401,6 +401,7 @@ enum ibv_wc_flags_ex {
 	IBV_WC_EX_WITH_SLID		= 1 << 9,
 	IBV_WC_EX_WITH_SL		= 1 << 10,
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 11,
+	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP = 1 << 12,
 };
 
 enum {
@@ -417,6 +418,10 @@ enum {
 /* fields order in wc_ex
  * Note: To guarantee compatibility a new field will be added after fields
  * of the same size.
+ *	// Raw timestamp of completion. A raw timestamp is implementation
+ *	// defined and can not be relied upon to have any ordering value
+ *	// between more than one HCA or driver.
+ *	uint64_t		completion_timestamp;
  *	uint32_t		byte_len,
  *	uint32_t		imm_data;
  *	uint32_t		qp_num;
@@ -428,7 +433,7 @@ enum {
  */
 
 enum {
-	IBV_WC_EX_WITH_64BIT_FIELDS = 0
+	IBV_WC_EX_WITH_64BIT_FIELDS = IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

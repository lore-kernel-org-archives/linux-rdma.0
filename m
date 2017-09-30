From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libhns: Update the size and member order of hns_roce_create_qp structure
Date: Sat, 30 Sep 2017 16:51:17 +0800
Message-ID: <1506761477-47350-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to keep the size and member order with the
hns_roce_ib_create_qp sturcture of the kernel driver,
it need to update hns_roce_create_qp's structure
members. Otherwise, it will run fail.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_abi.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index e78f967..276d29d 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -61,9 +61,10 @@ struct hns_roce_create_cq_resp {
 struct hns_roce_create_qp {
 	struct ibv_create_qp		ibv_cmd;
 	__u64				buf_addr;
+	__u64				rsv;
 	__u8				log_sq_bb_count;
 	__u8				log_sq_stride;
-	__u8				reserved[5];
+	__u8				reserved[6];
 };
 
 #endif /* _HNS_ROCE_U_ABI_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

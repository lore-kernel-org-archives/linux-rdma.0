From: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>
Subject: [PATCH V2 rdma-core] libhns: Update the size and member order of hns_roce_create_qp structure
Date: Mon,  2 Oct 2017 04:17:09 +0800
Message-ID: <1506889029-25168-1-git-send-email-xavier.huwei@tom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

In order to keep the size and member order with the
hns_roce_ib_create_qp sturcture of the kernel driver,
it needs to update hns_roce_create_qp's structure
members. Otherwise, it will run fail.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Patch V2: Address comments by Jason:
	https://patchwork.kernel.org/patch/9979299/

Patch V1: Initial Submit
---
 providers/hns/hns_roce_u_abi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index e78f967..2a57f46 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -61,8 +61,10 @@ struct hns_roce_create_cq_resp {
 struct hns_roce_create_qp {
 	struct ibv_create_qp		ibv_cmd;
 	__u64				buf_addr;
+	__u64				db_addr;
 	__u8				log_sq_bb_count;
 	__u8				log_sq_stride;
+	__u8				sq_no_prefetch;
 	__u8				reserved[5];
 };
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

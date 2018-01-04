From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 5/6] RDMA/hns: Update the verbs of polling for completion
Date: Thu, 4 Jan 2018 12:19:22 +0800
Message-ID: <1515039563-73084-6-git-send-email-oulijun@huawei.com>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515039563-73084-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the port is a RoCEv2 port, the remote port address and QP
information which returned for UD will be modified.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 12 ++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4a902c4..6b4474d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1914,6 +1914,18 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		wc->port_num = roce_get_field(cqe->byte_32,
 				V2_CQE_BYTE_32_PORTN_M, V2_CQE_BYTE_32_PORTN_S);
 		wc->pkey_index = 0;
+		memcpy(wc->smac, cqe->smac, 4);
+		wc->smac[4] = roce_get_field(cqe->byte_28,
+					     V2_CQE_BYTE_28_SMAC_4_M,
+					     V2_CQE_BYTE_28_SMAC_4_S);
+		wc->smac[5] = roce_get_field(cqe->byte_28,
+					     V2_CQE_BYTE_28_SMAC_5_M,
+					     V2_CQE_BYTE_28_SMAC_5_S);
+		wc->vlan_id = 0xffff;
+		wc->wc_flags |= (IB_WC_WITH_VLAN | IB_WC_WITH_SMAC);
+		wc->network_hdr_type = roce_get_field(cqe->byte_28,
+						    V2_CQE_BYTE_28_PORT_TYPE_M,
+						    V2_CQE_BYTE_28_PORT_TYPE_S);
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index c11b253..ce52c73 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -766,7 +766,7 @@ struct hns_roce_v2_cqe {
 	u32	byte_12;
 	u32	byte_16;
 	u32	byte_cnt;
-	u32	smac;
+	u8	smac[4];
 	u32	byte_28;
 	u32	byte_32;
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

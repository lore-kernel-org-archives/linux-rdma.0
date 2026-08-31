Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658E18AE3
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 02:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141820; cv=none; b=c9jFj3LJPx1/jEFCnvf59eIRc9SJRkwWecY0GQxObANf5vaCMxujV+u3o98VvBIBuJK5SfM4YnJ1Kx1PwVGGiYO+F4/1RyEnsQ2WWbavxYLQcAsy5/yFchyMMarODJrmgFr8YeIPrOafQbah+F2d2l78CChEarkl9tvb5U8Bx9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141820; c=relaxed/simple;
	bh=xmP583Sl1jvyHj6hQuCBgC7nXi8nzwjf50+2mjxR4Jo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLTFUbi486AdXmXIu0j8nPJ7m9rUvE1fXXPYO6tLUF+/9Jd3ao11+ArOqfQqAktu1BTiuMmlDDCGfq1dEKyqiNMrrdj5TIkvMNH4AbDzT62qfcyvBLKR62ALopc9MKsSbc/COXxR6sTgGZxK01rFRYKDhmeoBH1fc08s3MeEiUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hYBnX4pmvzpSvb;
	Mon, 31 Aug 2026 09:52:16 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 593484058C;
	Mon, 31 Aug 2026 10:03:33 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 10:03:32 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next 1/2] RDMA/hns: Fix missing CQE when UD QP use different SL
Date: Mon, 31 Aug 2026 10:03:23 +0800
Message-ID: <20260831020324.3540901-2-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260831020324.3540901-1-huangjunxian6@hisilicon.com>
References: <20260831020324.3540901-1-huangjunxian6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100018.china.huawei.com (7.202.181.17)

From: Chengchang Tang <tangchengchang@huawei.com>

Due to the hardware contraint, CQEs may be dropped when a UD QP
sends with multiple SLs. Pin the SL to the value from the first
post_send on the QP to avoid this issue.

Fixes: 66d86e529dd5 ("RDMA/hns: Add UD support for HIP09")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index eb7b1865e4c7..95529251e2e2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -654,6 +654,7 @@ struct hns_roce_qp {
 	u8			priority;
 	spinlock_t flush_lock;
 	struct hns_roce_dip *dip;
+	bool ud_sl_set;
 };
 
 struct hns_roce_ib_iboe {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 27cc7df55ee7..fd198faf4ee4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -431,7 +431,8 @@ static int set_ud_opcode(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 	return 0;
 }
 
-static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
+static int fill_ud_av(struct hns_roce_qp *qp,
+		      struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 		      struct hns_roce_ah *ah)
 {
 	struct ib_device *ib_dev = ah->ibah.device;
@@ -441,7 +442,12 @@ static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_HOPLIMIT, ah->av.hop_limit);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_TCLASS, ah->av.tclass);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_FLOW_LABEL, ah->av.flowlabel);
-	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_SL, ah->av.sl);
+	if (!qp->ud_sl_set) {
+		qp->sl = ah->av.sl;
+		qp->ud_sl_set = true;
+	}
+
+	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_SL, qp->sl);
 
 	ud_sq_wqe->sgid_index = ah->av.gid_index;
 
@@ -491,12 +497,10 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 			  qp->qkey : ud_wr(wr)->remote_qkey);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_DQPN, ud_wr(wr)->remote_qpn);
 
-	ret = fill_ud_av(ud_sq_wqe, ah);
+	ret = fill_ud_av(qp, ud_sq_wqe, ah);
 	if (ret)
 		return ret;
 
-	qp->sl = to_hr_ah(ud_wr(wr)->ah)->av.sl;
-
 	set_extend_sge(qp, wr->sg_list, &curr_idx, valid_num_sge);
 
 	/*
@@ -5603,6 +5607,7 @@ static void v2_set_flushed_fields(struct ib_qp *ibqp,
 	hr_reg_write(context, QPC_SQ_PRODUCER_IDX, hr_qp->sq.head);
 	hr_reg_clear(qpc_mask, QPC_SQ_PRODUCER_IDX);
 	hr_qp->state = IB_QPS_ERR;
+	hr_qp->ud_sl_set = false;
 	spin_unlock_irqrestore(&hr_qp->sq.lock, sq_flag);
 
 	if (ibqp->srq || ibqp->qp_type == IB_QPT_XRC_INI) /* no RQ */
-- 
2.33.0


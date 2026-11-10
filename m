Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311779;
	b=QVEfn4FikoXoOsR4KAGh6dZDQeIQWNDdf3ftz1OPyikBclLEjQLDOKBNr52ZnvB3NW6q
	 UDaQrCY8dREdq72rqw5K45bEREmP9VWeTcKdk64VyAbCmCAFtZIKJsJV5bsZsJ88X+oEp
	 tjgWWDcS+YBaC6pbGjOlk0t3z8cqE9ECIhzcE07KGq0KMcO/M/brwruQBDv9uxELapclQ
	 O512hb9q21Csd+GBYGWD2RsrCr96kSKRC6Max4bUwpKQPDPzekDwXEPbN78wmqUX3RNRW
	 qmMqLuAASauGqN6SVhrERDS9beYT1j9C09U8vEyaULMQwHtkixvtgV6Bgs1otX8MQzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311779;
	h=DMARC-Filter:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=YSFTPX5UnzweSc+okWihTXm/l1myrm+ylFy8TCX46lQ=;
	b=S7eENqR2DIpD51LMg2+s94yzucRh6vK45gcsDucZ3rr6wGHc5raRa0Egfic2pLJQZ3Kr
	 GkAbcVG7k6qvU5WtbsM98nBOTGd05MzSGnzHfzIeDNZ85pDycm4hFfUeUwQfUlvfdREkz
	 FAhUu0avaZe6lZdrpRz68zDrjrWUUbppUQxcPvJzJ9IkwySr+enJ2lVmd0eud8TPgIpAY
	 xx4hhcLDh845Ro2jnNzwiHzjvZIbYn2sGZTc8CblHJO26FRhFHaafjgO29X1O45YtKI3k
	 C5cGqRn41kxzXtGhHG05zXmcEi3C9Z7MYgW3BA6l9Sj/QLYM68wH1CasUmSiMA4iqbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hisilicon.com;
	spf=pass smtp.mailfrom=hisilicon.com;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D06606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32D06606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jP4qJ065gzLlTt;
	Tue, 10 Nov 2026 19:55:56 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id A541B4057A;
	Tue, 10 Nov 2026 19:56:10 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 10 Nov 2026 19:56:10 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next] RDMA/hns: Add reset fence before freeing DMA memory when destroy mbox fails
Date: Tue, 10 Nov 2026 19:56:09 +0800
Message-ID: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100018.china.huawei.com (7.202.181.17)

When a destroy mailbox (QPC/CQC/MPT/SRQC/EQC) fails or is skipped
in a reset, HW may still access the context while the driver frees
its DMA memory, causing a HW UAF.

According to the suggestion in [1], add a reset fence before freeing
DMA memory when the destroy mailbox fails. Once ops->ae_dev_reset_cnt()
increases, the HW reset is guaranteed to have completed, so HW will
no longer access the DMA memory and it is safe for the driver
to free it.

[1] https://lore.kernel.org/linux-rdma/20250401133956.GC186258@ziepe.ca/

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  7 +++-
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 40 +++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 1943031b0dbe..885900e68779 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -287,5 +287,10 @@ int hns_roce_create_hw_ctx(struct hns_roce_dev *dev,
 
 int hns_roce_destroy_hw_ctx(struct hns_roce_dev *dev, u8 cmd, unsigned long idx)
 {
-	return hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
+	int ret;
+
+	ret = hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
+	dev->hw->mbox_rst_fence(dev, ret);
+
+	return ret;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 5890ee69247c..021a52bc49ab 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -976,6 +976,7 @@ struct hns_roce_hw {
 				enum hns_roce_scc_algo algo);
 	int (*query_scc_param)(struct hns_roce_dev *hr_dev,
 			       enum hns_roce_scc_algo alog);
+	void (*mbox_rst_fence)(struct hns_roce_dev *hr_dev, int mbox_ret);
 };
 
 #define HNS_ROCE_SCC_PARAM_SIZE 4
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a8f319a57f25..e17569a532e4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1317,6 +1317,43 @@ static bool check_device_is_in_reset(struct hns_roce_dev *hr_dev)
 	return false;
 }
 
+static void hns_roce_v2_mbox_rst_fence(struct hns_roce_dev *hr_dev,
+				       int mbox_ret)
+{
+#define FENCE_POLL_INTERVAL_US 1000
+#define FENCE_TIMEOUT_US (60 * 1000 * 1000)
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long cnt;
+	unsigned long val;
+	int ret;
+
+	might_sleep();
+
+	if (!mbox_ret && !check_device_is_in_reset(hr_dev))
+		return;
+
+	cnt = ops->ae_dev_reset_cnt(handle);
+	if (cnt != hr_dev->reset_cnt)
+		return;
+
+	if (!check_device_is_in_reset(hr_dev)) {
+		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hr_dev->pci_dev);
+		enum hnae3_reset_type rst_type = hr_dev->is_vf ?
+			HNAE3_VF_FUNC_RESET : HNAE3_FUNC_RESET;
+
+		ops->set_default_reset_request(ae_dev, rst_type);
+		ops->reset_event(hr_dev->pci_dev, handle);
+	}
+
+	ret = read_poll_timeout(ops->ae_dev_reset_cnt, val, val > cnt,
+				FENCE_POLL_INTERVAL_US, FENCE_TIMEOUT_US,
+				false, handle);
+	if (ret)
+		dev_err(hr_dev->dev, "reset fence timeout.\n");
+}
+
 static bool v2_chk_mbox_is_avail(struct hns_roce_dev *hr_dev, bool *busy)
 {
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
@@ -5943,6 +5980,8 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 			ibdev_err_ratelimited(ibdev,
 					      "failed to modify QP to RST, ret = %d.\n",
 					      ret);
+
+		hr_dev->hw->mbox_rst_fence(hr_dev, ret);
 	}
 
 	send_cq = hr_qp->ibqp.send_cq ? to_hr_cq(hr_qp->ibqp.send_cq) : NULL;
@@ -7327,6 +7366,7 @@ static const struct hns_roce_hw hns_roce_hw_v2 = {
 	.hns_roce_dev_srq_ops = &hns_roce_v2_dev_srq_ops,
 	.config_scc_param = hns_roce_v2_config_scc_param,
 	.query_scc_param = hns_roce_v2_query_scc_param,
+	.mbox_rst_fence = hns_roce_v2_mbox_rst_fence,
 };
 
 static const struct pci_device_id hns_roce_hw_v2_pci_tbl[] = {
-- 
2.33.0


Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F242989B5
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 02:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141824; cv=none; b=qn/LxqiCSOf+WfdHaF0WuHGsb6wmPeMwgrfalPiAsHgz+dWAN0CumjSLBezU2CGJRiyJrCoaCpzvMrJfz2KDTjBXE3FbnwagX1e/1VPvyqlat6VT/GC2KxDAE4xfesI6Vfy/DgV0+qjUvLhF32USLdleif63IZShlbBTn+xWk3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141824; c=relaxed/simple;
	bh=NnwJFfFriJr+EWa+nXRo+UjKDyqJZi66hmiLqQy4Sbk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1S8t/mWypq+0In2BgHlYeeWoEbPjlfElGKrW9C2WM02hIayTa/uTiU/VrXvmBRX7/8oAAdC1XGbrebFCA7047zved+gFn24r8Cdq3kqNRplpBMFxBAMXmNCDKiq5AdBhdsB9an4r6FQUAtnkMJ4KT/0kkiETMJEtmUFtnsi3wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hYBp71VSkzRhVP;
	Mon, 31 Aug 2026 09:52:47 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id B13A04058C;
	Mon, 31 Aug 2026 10:03:33 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 10:03:33 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next 2/2] RDMA/hns: Support setting GSI QP SL via debugfs
Date: Mon, 31 Aug 2026 10:03:24 +0800
Message-ID: <20260831020324.3540901-3-huangjunxian6@hisilicon.com>
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
sends with multiple SLs. For GSI QP, provide debugfs to allow users
to set a fixed SL. This is only allowed when the device is link down.

Example:

  # cat /sys/kernel/debug/hns_roce/<PCI>/gsi_sl
  0
  # echo 3 > /sys/kernel/debug/hns_roce/<PCI>/gsi_sl
  # cat /sys/kernel/debug/hns_roce/<PCI>/gsi_sl
  3

Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 55 ++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_debugfs.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_device.h  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c   |  5 +-
 4 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_debugfs.c b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
index 05630f7c9155..2487a80b689a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_debugfs.c
+++ b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
@@ -339,6 +339,60 @@ static void create_cc_param_debugfs(struct hns_roce_dev *hr_dev,
 	}
 }
 
+static int gsi_sl_debugfs_show(struct seq_file *file, void *offset)
+{
+	struct hns_roce_dev *hr_dev = file->private;
+
+	seq_printf(file, "%u\n", hr_dev->gsi_sl);
+
+	return 0;
+}
+
+static ssize_t gsi_sl_debugfs_store(char *buf, size_t count, void *data)
+{
+	struct hns_roce_dev *hr_dev = data;
+	struct net_device *netdev;
+	int ret;
+	u8 val;
+
+	netdev = ib_device_get_netdev(&hr_dev->ib_dev, 1);
+	if (!netdev)
+		return -ENODEV;
+
+	if (ib_get_curr_port_state(netdev) == IB_PORT_ACTIVE) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		goto out;
+
+	if (!check_sl_valid(hr_dev, val)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	hr_dev->gsi_sl = val;
+
+out:
+	dev_put(netdev);
+	return ret ? : count;
+}
+
+static void create_gsi_sl_debugfs(struct hns_roce_dev *hr_dev,
+				  struct dentry *parent)
+{
+	struct hns_debugfs_seqfile *seqfile = &hr_dev->dbgfs.gsi_sl;
+
+	seqfile->read = gsi_sl_debugfs_show;
+	seqfile->write = gsi_sl_debugfs_store;
+	seqfile->data = hr_dev;
+
+	debugfs_create_file("gsi_sl", 0600, parent, seqfile,
+			    &hns_debugfs_seqfile_fops);
+}
+
 /* debugfs for device */
 void hns_roce_register_debugfs(struct hns_roce_dev *hr_dev)
 {
@@ -349,6 +403,7 @@ void hns_roce_register_debugfs(struct hns_roce_dev *hr_dev)
 
 	create_sw_stat_debugfs(hr_dev, dbgfs->root);
 	create_cc_param_debugfs(hr_dev, dbgfs->root);
+	create_gsi_sl_debugfs(hr_dev, dbgfs->root);
 }
 
 void hns_roce_unregister_debugfs(struct hns_roce_dev *hr_dev)
diff --git a/drivers/infiniband/hw/hns/hns_roce_debugfs.h b/drivers/infiniband/hw/hns/hns_roce_debugfs.h
index 116b1e8b6677..286704711785 100644
--- a/drivers/infiniband/hw/hns/hns_roce_debugfs.h
+++ b/drivers/infiniband/hw/hns/hns_roce_debugfs.h
@@ -47,6 +47,7 @@ struct hns_roce_dev_debugfs {
 	struct dentry *root;
 	struct hns_sw_stat_debugfs sw_stat_root;
 	struct hns_cc_param_debugfs cc_param_root[CONG_TYPE_MAX_NUM];
+	struct hns_debugfs_seqfile gsi_sl;
 };
 
 struct hns_roce_dev;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 95529251e2e2..f4f899e87ea6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1048,6 +1048,7 @@ struct hns_roce_dev {
 	struct hns_roce_dev_debugfs dbgfs;
 	atomic64_t *dfx_cnt;
 	struct hns_roce_scc_param *scc_param;
+	u8 gsi_sl;
 };
 
 enum hns_roce_trace_type {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index fd198faf4ee4..368e1d74c283 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -442,8 +442,9 @@ static int fill_ud_av(struct hns_roce_qp *qp,
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_HOPLIMIT, ah->av.hop_limit);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_TCLASS, ah->av.tclass);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_FLOW_LABEL, ah->av.flowlabel);
-	if (!qp->ud_sl_set) {
-		qp->sl = ah->av.sl;
+	if (!qp->ud_sl_set || qp->ibqp.qp_type == IB_QPT_GSI) {
+		qp->sl = qp->ibqp.qp_type == IB_QPT_GSI ?
+				hr_dev->gsi_sl : ah->av.sl;
 		qp->ud_sl_set = true;
 	}
 
-- 
2.33.0


Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B3442118
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770949; cv=none; b=iLXZfEcfGPkLCoj73ceQqGoQ0NvdSlE453tay2E2VLF31APn2DnVbIfJfyYKuumDTOpZbRnhagbMHx6gAGkPjCFgm6wtRbTRU7JRZrowLmXzCnn8Tq/0R+6ka8jGNELN0iL/UV6SK5t9u+piQoTvsFWpnOqYUnRIV7hYf87F+AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770949; c=relaxed/simple;
	bh=WJ/Aph1cRqngfYGlPHq3FtQ6P001hAS+P855TZWqfRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4AUnE0AOboOUpilAyE/khaPQnP705cUUw9N47Qkq/0jH00VR+Pt5Jt1KCwFqEU3D2V3eSoZub0M22XZM3WZRbjQVRe9vspd+u3akmMYQAVMDFdYz2NXJd+zIMqeJ+aN2VXq4Yr4wZJ6eMGi9hdn5UNamwpDfUw0AIp+9du7kr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hdgRy01WwzpT0h;
	Mon,  7 Sep 2026 16:37:34 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E3BF40579;
	Mon,  7 Sep 2026 16:49:03 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 16:49:03 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH v2 for-next 1/3] RDMA/hns: Use u32 for gid_table_len
Date: Mon, 7 Sep 2026 16:48:59 +0800
Message-ID: <20260907084901.2420703-2-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260907084901.2420703-1-huangjunxian6@hisilicon.com>
References: <20260907084901.2420703-1-huangjunxian6@hisilicon.com>
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

The gid_table_len is always read from HW registers or derived from
u32 arithmetic, and it is never negative. Change its type from int
to u32 to avoid signed/unsigned mixed-type operations with other
u32 fields such as gmv_entry_num.

Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index eb7b1865e4c7..c9536bdfe172 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -737,7 +737,7 @@ enum hns_roce_scc_algo {
 struct hns_roce_caps {
 	u64		fw_ver;
 	u8		num_ports;
-	int		gid_table_len[HNS_ROCE_MAX_PORTS];
+	u32		gid_table_len[HNS_ROCE_MAX_PORTS];
 	int		pkey_table_len[HNS_ROCE_MAX_PORTS];
 	int		local_ca_ack_delay;
 	int		num_uars;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 27cc7df55ee7..41aa6bf4c63e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5327,7 +5327,7 @@ static int hns_roce_v2_set_path(struct ib_qp *ibqp,
 	hr_reg_clear(qpc_mask, QPC_VLAN_ID);
 
 	if (grh->sgid_index >= hr_dev->caps.gid_table_len[hr_port]) {
-		ibdev_err(ibdev, "sgid_index(%u) too large. max is %d\n",
+		ibdev_err(ibdev, "sgid_index(%u) too large. max is %u\n",
 			  grh->sgid_index, hr_dev->caps.gid_table_len[hr_port]);
 		return -EINVAL;
 	}
-- 
2.33.0


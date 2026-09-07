Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7104533262A
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770949; cv=none; b=Vv8SBVGpZbxo1eOimXQ7PAKcUvycWnplKM5uLOY3vVz7/mru03xYlVBaS0teODk6pG+WuYNtFi30elKvGhTlUIaN/NQtrOC+M4tmVy8xsYaLfoUHFlSXD3ZA9ZWp4G2hmzRIDRl0o0v6+Av+35tj8VXLGHsc1Q4yIXIJtkX5IgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770949; c=relaxed/simple;
	bh=6MdrFD/Qx04890IIBQGzRplKhdnPJhWT0BjDho/gJ+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yp3fVL4kjc93en2+dGVv19QGuPXwd3PXhgzeTB5C4kQB+YAFRA6S/uXZl1LzHizeNh4yuOVgUvW2ZNNSfeVrAXHyjLEpBnTicRKZWYDFRlKybGGYYZTd3inEd5+KEFJr2o6KpAF4k8yMrfpbwjL4uPPhUnqHblbRBbYlsgh2bvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hdgRy1vcwzpSvB;
	Mon,  7 Sep 2026 16:37:34 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id CF7AF40579;
	Mon,  7 Sep 2026 16:49:03 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 16:49:03 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH v2 for-next 2/3] RDMA/hns: Limit gmv_entry_num to avoid memory waste
Date: Mon, 7 Sep 2026 16:49:00 +0800
Message-ID: <20260907084901.2420703-3-huangjunxian6@hisilicon.com>
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

The GMV entry is a HW object corresponding to a GID. Since gid_table_len
is already limited to a maximum of 256, there is no need to allocate
memory for those extra GMV entries as they will never be touched.

Fixes: 7243396aaf12 ("RDMA/hns: Add a max length of gid table")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 41aa6bf4c63e..38bdd2d6d274 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2416,8 +2416,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
-							  caps->gmv_entry_sz);
+		caps->gmv_entry_num = caps->gid_table_len[0];
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
 
-- 
2.33.0


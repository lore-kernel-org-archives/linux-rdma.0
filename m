Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A8A440652
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 09:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514725; cv=none; b=Zujo9cNIlBbsLtpKJmFcb7eElCNqOPwTFdAYfMOpV1onRJVT6BPqGRqMomk91CHSgfjtdQU6HB1qiO4YI7ChQ4M/V90KOIpBg3gN8a8IK3SFgkxxDQdXVYIggnTcVUgoN/YEBEQf6/WY8u3oFMVwVZGqizdzq+dPXg76NI8mzps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514725; c=relaxed/simple;
	bh=Tw2x3yLuaIgSz1HWx+ErEvRwwtibPO7S9aYqsHp+b4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUaMtXOd4XyHSXmGeftTNhS/S3v0RBaykkMjTFRvtHC9cD9riEuXnND7fj/hGBX1utaschhKnig9Ss6w0VGcpoY8A01mpINrb06g5AxFJSNfTHg2+IZtr8TxbOaA4DS2U9QWpxjttsyhYwjHSOd+ECbdI7isR2YBjTT1RY0Lm04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbrjD1hSvzKm6S;
	Fri,  4 Sep 2026 17:27:44 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 294264048B;
	Fri,  4 Sep 2026 17:38:39 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 17:38:38 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next 1/2] RDMA/hns: Limit gmv_entry_num to avoid memory waste
Date: Fri, 4 Sep 2026 17:38:36 +0800
Message-ID: <20260904093837.1633748-2-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260904093837.1633748-1-huangjunxian6@hisilicon.com>
References: <20260904093837.1633748-1-huangjunxian6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
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
index 27cc7df55ee7..3edceadbca76 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2416,8 +2416,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
-							  caps->gmv_entry_sz);
+		caps->gmv_entry_num = (u32)caps->gid_table_len[0];
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
 
-- 
2.33.0


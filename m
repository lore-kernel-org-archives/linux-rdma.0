Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C623ACA50
	for <linux-rdma@vger.kernel.org>; Sat, 13 Jun 2026 10:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781346058; cv=none; b=WONMOBgjvPicIHs1XMczNlK2PYoQqe+E3A3mQSRr9+5OXD2FWzfpb6NLcKSZUWC2ZomHFwfpWtCSB1aBxraZixHdGcBC4cyKxq5LS7ftPm4nGFlH/5FLVa+pFuC5bIeILHmpcXLaTJJJ7mU1r6U5Y4zRTiqbWyqo4n5b3jDY6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781346058; c=relaxed/simple;
	bh=s4smzi2SkuzP8xGp1VmLCI/Xon/zRozVIE8n7jxImvk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FtADa7Y2C12WWZVtCrIHfvSqSPdW0ShRJg7R8S3ESdbtMxzrw3bJf4HhiR8h1657iHiSlLAqWlxY2NS/7TLpY1BH/AeKhrhOF1/AhcatL2OUEvJ2INlYo39hsbsh1nw39COGc37ej/FCGrdTAQOlbPpPmDsedfjeZlM78ne+fig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gcsdX24xwzKm4Y;
	Sat, 13 Jun 2026 18:12:48 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id D456B40563;
	Sat, 13 Jun 2026 18:20:46 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 13 Jun 2026 18:20:46 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
	<huangjunxian6@hisilicon.com>, <tangchengchang@huawei.com>
Subject: [PATCH v2 for-next] RDMA/hns: Fix memory leak of bonding resources
Date: Sat, 13 Jun 2026 18:20:45 +0800
Message-ID: <20260613102045.811623-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100018.china.huawei.com (7.202.181.17)

In a corner case of concurrent driver removal and driver reset,
bonding resource is first released in hns_roce_hw_v2_exit() during
driver removal, and then is allocated again in hns_roce_register_device()
during driver reset. This leads to memory leak because the release
timing has already passed. This may also lead to a kernel panic
as below because of the leaked notifier callback:

Call trace:
  0xffffa20fccc04978 (P)
  raw_notifier_call_chain+0x20/0x38
  call_netdevice_notifiers_info+0x60/0xb8
  netdev_lower_state_changed+0x4c/0xb8

As Sashiko suggested, the teardown order of bonding resources should
be inverted to make sure the resources are released when the driver
is removed.

Fixes: b37ad2e290fc ("RDMA/hns: Initialize bonding resources")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
v2:
* Invert the teardown order of bonding resources as suggested by
  Jason and Sashiko.
v1: https://lore.kernel.org/linux-rdma/20260520055759.2354037-2-huangjunxian6@hisilicon.com/
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4afd7d6ae3ca..f839578d7fdb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -7654,8 +7654,8 @@ static int __init hns_roce_hw_v2_init(void)

 static void __exit hns_roce_hw_v2_exit(void)
 {
-	hns_roce_dealloc_bond_grp();
 	hnae3_unregister_client(&hns_roce_hw_v2_client);
+	hns_roce_dealloc_bond_grp();
 	hns_roce_cleanup_debugfs();
 }

--
2.33.0


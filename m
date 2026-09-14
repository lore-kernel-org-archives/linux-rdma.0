Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8519029DB64
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 02:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789354093; cv=none; b=VHfjNUwJL2nPLyPx470iqLsJ1IRY1izmbMXvvmEzheogfo4IP87cEIkerQixnGZloW6zX3fpU5/JCchSXaoOo706Js/MPpi8T5ZhBEtMeVlJLEl3MnulvOAojX0Q/ZxE8zsHgU/2/ncxp/DW2tWrvIEjLBxGhsNplUo7NsYTSwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789354093; c=relaxed/simple;
	bh=po/a2gr+chLXxIzwqWqWf8wLuesMnctxJ8+w7r7t2BM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aDoM/8FNv4aJjPDQtzPZzwcDREGQfvyIcrDC6YRQLHkbeiq/cOP+tieXb0yNezo0tPSX3UKSVUxQljlKGKNMCpc/1VZfZrpoZysoIKNg+WXl85ZB2DR/s+raIYdi4lC/SZpyjArJWkc8vuvhthkCbHTCdmCj5DqGo5PI4+jw9xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hjq6m3jQrz1cyQh;
	Mon, 14 Sep 2026 10:37:04 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D2474056C;
	Mon, 14 Sep 2026 10:48:01 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 14 Sep 2026 10:48:00 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-rc] RDMA/hns: Fix the use of uninitialized variable
Date: Mon, 14 Sep 2026 10:48:00 +0800
Message-ID: <20260914024800.132429-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100018.china.huawei.com (7.202.181.17)

The variable 'i' is used without being initialized in active-backup
mode.

Fixes: d9023e461b73 ("RDMA/hns: Implement bonding init/uninit process")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_bond.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_bond.c b/drivers/infiniband/hw/hns/hns_roce_bond.c
index f2b12ae13a58..21de82b864d3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_bond.c
+++ b/drivers/infiniband/hw/hns/hns_roce_bond.c
@@ -81,7 +81,7 @@ static int hns_roce_set_bond_netdev(struct hns_roce_bond_group *bond_grp,
 {
 	struct net_device *active_dev;
 	struct net_device *old_dev;
-	int i, ret = 0;
+	int i = 0, ret = 0;
 
 	if (bond_grp->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
 		rcu_read_lock();
-- 
2.33.0


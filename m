Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D1E40E8C1
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770950; cv=none; b=ZdFgRPV4zJQO38J7Nh/DprYMOCgeKjowzKXjG60n4TFWrPsvOaLy3y+xKu17kKM3zjHWGEUb0UvDwiSxPbQHQQRYajXdESrqs2pIrMLREEJxiVGnS56FBPYqQnjwzXYMt3nIckRT8kzZTQEeq4PhFdRFDQS5yo2NhBHrbBw/eCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770950; c=relaxed/simple;
	bh=q13qSHbPRnQY9Fvm6CxxYUzOnDQ8rpc92sjo/o0laPM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cDJ8zeLX64i+duOLgRLSr/ubbdEc7F8swidHem4k2a+I5MUpZNYWeWrEWmaUxzLVDOnojd8Qu1Zf0QggHui3kvgeuxeLGQEwF0koxmVk/sf7jExkNMWh73RbvqkVsWVmY4qbAaaBr5HtJgG2sCUfMayoO6n2rspe9gbN/BMStus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdgSc45f7z1prLc;
	Mon,  7 Sep 2026 16:38:08 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 3DF3140561;
	Mon,  7 Sep 2026 16:49:03 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 16:49:02 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH v2 for-next 0/3] RDMA/hns: Fix GMV entry management
Date: Mon, 7 Sep 2026 16:48:58 +0800
Message-ID: <20260907084901.2420703-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
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

This patchset fixes two issues in the GMV entry management. It starts
with a preparation patch that changes the type of gid_table_len to u32.

v2:
* Change gid_table_len type from int to u32 in a separate patch, as suggested by Leon
* Drop the redundant (u32) cast on gid_table_len[0] since the type is now u32
v1: https://lore.kernel.org/linux-rdma/20260904093837.1633748-1-huangjunxian6@hisilicon.com/

Junxian Huang (3):
  RDMA/hns: Use u32 for gid_table_len
  RDMA/hns: Limit gmv_entry_num to avoid memory waste
  RDMA/hns: Fix GID capacity loss in 64K system

 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 42 +++++++++++++++------
 2 files changed, 32 insertions(+), 12 deletions(-)

-- 
2.33.0


Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A71E1C11
	for <linux-rdma@vger.kernel.org>; Thu,  7 May 2026 01:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778116914; cv=none; b=aDDj5MTwiqeDZHrBvViEccWMif/SjVD+5A0oiXRFeprthIk/Zqr5ZQWPQlSxHxI5vEq/7L4Pozn6qjt7zeOlP9HiaT5A/VwQYaD4Ai3dquOq1gJbnRxkrtdKtd8QEpa85rXBz5ICmfMwU/Jw6Cqo4Mymf5S/rCubPe4JT18NAvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778116914; c=relaxed/simple;
	bh=OQRo/k6/4K8m4S9WCJaZFgg+7mCo/cMzfNC4EQazlkA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kbbQCqVNjVIBpMb6Ufy3FCnZKy2QPBw7Jl2dJ++9psLyZgYUtEdIuGpEKmHme2SdYgYlIBSU2l4fXyc69HZRlM1nmMWIHPuSqXgYFNsftnrQz1qartjtI+Ig9vl1vCwT2eiT4TvlyFhfh3d8PcrpHxPd1WM4/4LHD3i2XoZZQp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4g9vSM1gZxz1prLr;
	Thu,  7 May 2026 09:15:15 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E2A240569;
	Thu,  7 May 2026 09:21:49 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 7 May 2026 09:21:49 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
	<huangjunxian6@hisilicon.com>, <tangchengchang@huawei.com>
Subject: [PATCH v2 for-next 0/3] RDMA/hns: Support congestion control algorithm parameter configuration by debugfs
Date: Thu, 7 May 2026 09:21:45 +0800
Message-ID: <20260507012148.1079712-1-huangjunxian6@hisilicon.com>
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

This series adds support for congestion control algorithm parameter
configuration by debugfs.

v2:
* Inline init_debugfs_seqfile()
* Remove delayed_work and related logic
* Add usage example to the commit log of patch 3
v1: https://lore.kernel.org/linux-rdma/20260206103110.3414311-1-huangjunxian6@hisilicon.com/

Chengchang Tang (1):
  RDMA/hns: Support congestion control algorithm parameter configuration

Junxian Huang (2):
  RDMA/hns: Initialize seqfile before creating file
  RDMA/hns: Add write support to debugfs

 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 288 ++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_debugfs.h |  26 ++
 drivers/infiniband/hw/hns/hns_roce_device.h  |  21 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c   |  54 ++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h   | 125 ++++++++
 5 files changed, 501 insertions(+), 13 deletions(-)

--
2.33.0


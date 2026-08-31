Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4AE18AE3
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 02:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141823; cv=none; b=P30U+zFiysIjbDIWcMTIZbXE3zwyCvcXSTCWRyEdG54So0uqCah+UlKW6+CKn0wa3z/z//daF6XDVIEe8Hc09NAg19BviNTgvF2I2ZLPT7otWCFpNq9tGLPjUcvu3FzYqQ50t7stgU2119ZIJVCTJmwu8H3S6OKZ0ty68JSOHxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141823; c=relaxed/simple;
	bh=V0fpAekX15jfvmW+dj5M+tIQAC+HGazEF5roE6KoP/c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cJyfXy6CfjBL3cMKuicuYXWU/rxRkcYW5WeMrGkgSYmGK3rVOoRbrdyQ/ctwD/ioU3v+z5TI25h5KGh96SpuhrD5ixd3w1ic4sS1EHjl6BM09ecd0j6vhyHCvWdizxAz/4gpP2FY021dGnu/MQUPV3tK4OiWI7mbSq7FG5Ntd5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hYBnV5WWdz1T4gv;
	Mon, 31 Aug 2026 09:52:14 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C2ED40575;
	Mon, 31 Aug 2026 10:03:33 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 10:03:25 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next 0/2] RDMA/hns: Workaround for CQE drop with multiple SLs on HIP09
Date: Mon, 31 Aug 2026 10:03:22 +0800
Message-ID: <20260831020324.3540901-1-huangjunxian6@hisilicon.com>
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

Due to the hardware constraint, CQEs may be dropped when a UD QP sends
with multiple SLs. This patchset addresses this issue in two ways:

Patch 1 pins the SL to the value from the first post_send on a UD QP to
prevent CQE drop for regular UD QPs.

Patch 2 provides a debugfs interface for GSI QP to set a fixed SL. It is
allowed to set only when the device is link down.

Chengchang Tang (2):
  RDMA/hns: Fix missing CQE when UD QP use different SL
  RDMA/hns: Support setting GSI QP SL via debugfs

 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 55 ++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_debugfs.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_device.h  |  2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c   | 16 ++++--
 4 files changed, 69 insertions(+), 5 deletions(-)

-- 
2.33.0


Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653184457D9
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514727; cv=none; b=u7twYWv9kg0rDzrUDIH1Vi4UTK+3/XmqCYMcNwVcL8Ie095Lq2fXqXYOXlBdIJYYfVTQVnZi0R1a5Z1vnYiY+Mtrh/61o/RtjAuE8sGkdj2EfwpzEkEsOGozcNbgxEvmOj0m375jKZd4tUoG8rdrNRtqA5vEGTy7Y6H+yHJ+qTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514727; c=relaxed/simple;
	bh=YOAcuziFstSDL63QlM9r/Ni5qlBVI4qO/hfZZMIJPA8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rl1fD0yNF4/2EBAHmlgYR8Qho+jN4RjLktNJGmH9NgbhxnaVBsDgbbvO/xBNbT4tu7JGdZk9NEPqQJRB0SZ4/FKKIQ3ARos1/OzRgpqrqLysD3jkIlGq36fLcJVDsAqja/I5VZiiH5vwcRHWz5fHd5Z8yleAcLI9d1Z2zrVIl58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hbrjK5XKHzRhRG;
	Fri,  4 Sep 2026 17:27:49 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id C49774058F;
	Fri,  4 Sep 2026 17:38:38 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 17:38:38 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH for-next 0/2] RDMA/hns: Fix GMV entry management
Date: Fri, 4 Sep 2026 17:38:35 +0800
Message-ID: <20260904093837.1633748-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
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

This patchset fixes two issues in the GMV entry management.

Junxian Huang (2):
  RDMA/hns: Limit gmv_entry_num to avoid memory waste
  RDMA/hns: Fix GID capacity loss in 64K system

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 40 ++++++++++++++++------
 1 file changed, 30 insertions(+), 10 deletions(-)

-- 
2.33.0


Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77E1296BD1
	for <linux-rdma@vger.kernel.org>; Fri,  6 Feb 2026 10:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770373875; cv=none; b=ZipcS5758hHc/+HMBGard3YvvSWwe32TPKGDikTWAOKm9bHf3GLH0DT7YPhe2DYL4VCXJ5CX8IeXMTGjN+/YjWgEncWpWqbehhvEEQk+uplXbpvPKqlEsz7o9DtrkOcGJ9E1FOugnwJyzveAxkAn5plLPaj3KHFgccOXG4x+190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770373875; c=relaxed/simple;
	bh=mYOD8IUDFEXKFzIoN7ILvsoBckTyd/CsAT8NSPtwoLM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NlzSJXi7XOxi+zwwklPwbppZUPpgiqJABDIyVL1l4DX6IlKFhjVAYv4cYRmLCbL/TQ394DwKbtgWSkk+W6IVGr0bd7QxbDBC4ncoP79nfh58l7tbbnjboIx8u/hBbXLLBIy+7vJ4fvJBJm/gfN0GOrkbs5RRxdCT15vhKMzni/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4f6qy51QB0z1cyQM;
	Fri,  6 Feb 2026 18:26:37 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B3D040561;
	Fri,  6 Feb 2026 18:31:12 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 6 Feb 2026 18:31:11 +0800
From: Junxian Huang <huangjunxian6@hisilicon.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
	<huangjunxian6@hisilicon.com>, <tangchengchang@huawei.com>
Subject: [PATCH for-next 1/3] RDMA/hns: Initialize seqfile before creating file
Date: Fri, 6 Feb 2026 18:31:08 +0800
Message-ID: <20260206103110.3414311-2-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260206103110.3414311-1-huangjunxian6@hisilicon.com>
References: <20260206103110.3414311-1-huangjunxian6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100018.china.huawei.com (7.202.181.17)

The debugfs file was created before seq->read and seq->data were set,
leaving a small window where userspace could access an uninitialized
seqfile. Move debugfs_create_file() after the assignments to avoid
this issue.

Fixes: ca7ad04cd5d2 ("RDMA/hns: Add debugfs to hns RoCE")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_debugfs.c b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
index b869cdc54118..3f0a692e6ac7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_debugfs.c
+++ b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
@@ -31,10 +31,10 @@ static void init_debugfs_seqfile(struct hns_debugfs_seqfile *seq,
 				 int (*read_fn)(struct seq_file *, void *),
 				 void *data)
 {
-	debugfs_create_file(name, 0400, parent, seq, &hns_debugfs_seqfile_fops);
-
 	seq->read = read_fn;
 	seq->data = data;
+
+	debugfs_create_file(name, 0400, parent, seq, &hns_debugfs_seqfile_fops);
 }
 
 static const char * const sw_stat_info[] = {
-- 
2.33.0


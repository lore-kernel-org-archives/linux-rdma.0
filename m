Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E2443E4A
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661926; cv=none; b=L/4E2tYB7BMU6CikKKcyrlMvwz7zEDUNnZkV0Esaf0iHJxK3rGagWB3aVkaTqE09aRg2VNykuxC4dhUBrIsDBt3lo7x+3WNZhQttG4um91I4x/aDSQG+MLIST5SWmJ3lHdOwJRE0HXwf9zZoOEEeauh7VOmK5K0stHPGA3CBNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661926; c=relaxed/simple;
	bh=9XPt/5iVbc+NiTB1mC1J4CUZMkWZpH6XxZwso8dsxEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFIRDKqgDDxRaxj3MP/LIA3s3jH3RKus/vVm+6nJiXFUIGS3JAu2wN7d9oHL8dhOmIesMAqys7p5YT84CNtGlYK6lnRwd7GY1HxbVRDEiz4GFSKJdudZ82zzxPYGK9dEArHQiYbC5V18MldfMAMvj+114u/F8MHGSlyeDImz3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BsBPBful; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BsBPBful"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787661916; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jvk03kh5puiCWZn8LHcj658G3qDnEUnCcC9bX8yWAs4=;
	b=BsBPBfulCGePuQsTHFH/v1e5VLpa5/8BTW0hQh7jvfUzOQBZkYWKTUf3bI1V3KxdmiV1tLnd2yGsoVbSzhsM3AgVicjqmB2T9WMtO6vWxkLwt0KoErMBl5r6vwyeyPlSYF5gO13cfUiWVfgM/KG55TtsrGdbgn07Be2hXzyQWt0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9dy.X1_1787661915;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9dy.X1_1787661915 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 20:45:16 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next 0/4] RDMA/erdma: Support non-contiguous kernel queue buffers
Date: Tue, 25 Aug 2026 20:45:06 +0800
Message-ID: <20260825124515.99370-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small patchset introduces support for non-contiguous kernel queue
buffers. Kernel QP and CQ buffers currently use a single coherent DMA
allocation, which can fail for large queues when memory is fragmented.
To address this, we allocate page-sized coherent buffers and describe
them with the existing MTT.

- #1 adds support for non-contiguous kernel QP buffers.
- #2 adds support for non-contiguous kernel CQ buffers.
- #3 unifies userspace and kernel space queue buffer management.
- #4 moves kernel QP helpers after the shared memory helpers.

Thanks,
Cheng Xu

Cheng Xu (4):
  RDMA/erdma: Support non-contiguous kernel QP buffers
  RDMA/erdma: Support non-contiguous kernel CQ buffers
  RDMA/erdma: Unify userspace and kernel queue buffer management
  RDMA/erdma: Move kernel QP helpers after memory helpers

 drivers/infiniband/hw/erdma/erdma_cq.c    |  19 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c | 579 +++++++++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  64 ++-
 4 files changed, 420 insertions(+), 280 deletions(-)

-- 
2.31.1

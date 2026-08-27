Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6CB391E4E
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787819138; cv=none; b=iWhlG+K43Xq2hYaNdtCrWuYNJEbcOgu/9yc5W69NA0vqHfdIr1diD6flVJGDy+1emSMyqQqxDNccZKEAtAp4MaEMXC9WPCU6starLftmlLSwqx7NNryX6ArVbk8zdbAX9TYzMmpVNVZ0rOFVSZekf4biI37+uXPDeBYmV0Xe7+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787819138; c=relaxed/simple;
	bh=eBQ75YAveHS4tB1C8CViHWdapYZ5l3TmXWXfD1h4wN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nj74gWTo+TMXE2YXcivtcAALEyHgI7QZEjEGud1UvwzSYCaPbCcAksErztsnEFxNIZ8yoKk5/68sFMcxGSwDEhvUTFAKSceyZ9qN+1PpeBskoiHrC+v5pXeyD5TROxpGMj2T3F+P6gQX4oBwuCButWQMVWfDrh3d1BD7e1qdjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nh8uih9h; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nh8uih9h"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787819125; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WeAvxmAgP0tI7/yjS5KgmgqjERJ81V6ImvbExvQIcjs=;
	b=Nh8uih9hAGk9AQ+jNRCN7XtgvlfShW0po+dfWea8XS0LFWIPHIh4wdIpQvXIFvDnFBiaH7O6Mb92PJKVjmype7bfcLElTdwTbiDgcHQoXjE4MdtmhNcO1NoCRxR+13UDaNpVjLGWmCPVTLeZsNuHLoHLhVr8FSdTZ30aFQ20Ufo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9j.Gd1_1787819124;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9j.Gd1_1787819124 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 16:25:25 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v2 0/4] RDMA/erdma: Support non-contiguous kernel queue buffers
Date: Thu, 27 Aug 2026 16:25:19 +0800
Message-ID: <20260827082523.36294-1-chengyou@linux.alibaba.com>
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

Changes from v1:
- Fix formatting issues.

Thanks,
Cheng Xu

Cheng Xu (4):
  RDMA/erdma: Support non-contiguous kernel QP buffers
  RDMA/erdma: Support non-contiguous kernel CQ buffers
  RDMA/erdma: Unify userspace and kernel queue buffer management
  RDMA/erdma: Move kernel QP helpers after memory helpers

 drivers/infiniband/hw/erdma/erdma_cq.c    |  18 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c | 576 +++++++++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  64 ++-
 4 files changed, 416 insertions(+), 280 deletions(-)

-- 
2.31.1

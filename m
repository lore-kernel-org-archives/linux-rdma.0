Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6326C4DE726
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646723; cv=none; b=G30ZZg4/tTEvvoMuSG78ddJuMwlgCHFinKnoT9Ju70kbM1C5BrOvWSmw4X/dkJHxD0kWpSmkRNH7b0BnHtydxnagcLZShca1qLtgQHuckNEB5AVHivKLwUpoOyO2ukJtUEKpZWim1ltInzZ2K0i/rmX1YCAAGwJaAdaac9rWxkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646723; c=relaxed/simple;
	bh=tq/qdI+SJvxB8di/UCUqGjxnHjCe6s2ier7hoI/IOBk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OBi3YabK+/QpAtA86mq1pS7eXvLxvHaPgi3YAbEx7JGjDipj429p5M14dvRaPUZfEsEagMvl+kSrEJxDGIyCl5HWnqbbuASI9eELSGQ2UW5qhmKe1FAngu8IVXKAUjkEMSjCNO/b/T2R4lcPAIrz/ynvTC715xqVXW3gJyq0rbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IJ/nnuZd; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IJ/nnuZd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789646700; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ZJ/6F74WelHepRiQ9jvkXSc4xP8phBeFkg40Ke//GDE=;
	b=IJ/nnuZdn+2+UkdhRPzONJmbKovQ/435t/nZFmAS3BpLOkZpKQjZIcDS9OSHLVW2AUradLr2nM84NgqYyKM1io710hzUFcLeV4J7lwXrYYF4vyx0NWv0JPKJAXW6BuQvD7qXlHmhAWu1E0jocK8VL+CFe/pa3MKZ6R72w+WM+H4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XB85Zlv_1789646699;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XB85Zlv_1789646699 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Sep 2026 20:05:00 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v4 0/5] RDMA/erdma: Support non-contiguous kernel queue buffers
Date: Thu, 17 Sep 2026 20:04:54 +0800
Message-ID: <20260917120459.13286-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.54.0
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

- #1 unwinds kernel QP initialization failures explicitly.
- #2 adds support for non-contiguous kernel QP buffers.
- #3 adds support for non-contiguous kernel CQ buffers.
- #4 unifies userspace and kernel space queue buffer management.
- #5 moves kernel QP helpers after the shared memory helpers.

Changes from v3:
- Address Sashiko automated review findings:
  - Keep the CPU and DMA addresses returned by dma_alloc_coherent() instead
    of deriving a virtual address through scatterlist helpers.
  - Sync continuous MTTs after populating their entries.
  - Keep DMA MRs and MTT-only FRMRs outside queue buffer backing cleanup.

Changes from v2:
- Add explicit resource unwinding for kernel QP initialization.
- Use struct scatterlist for kernel queue buffer pages.
- Make memory cleanup operate only on initialized backing memory.
- Return -ENOMEM when a kernel QP doorbell record allocation fails.

Changes from v1:
- Fix formatting issues.

Thanks,
Cheng Xu

Cheng Xu (5):
  RDMA/erdma: Unwind kernel QP initialization failures
  RDMA/erdma: Support non-contiguous kernel QP buffers
  RDMA/erdma: Support non-contiguous kernel CQ buffers
  RDMA/erdma: Unify userspace and kernel queue buffer management
  RDMA/erdma: Move kernel QP helpers after memory helpers

 drivers/infiniband/hw/erdma/erdma_cq.c    |  18 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c | 569 ++++++++++++----------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  65 ++-
 4 files changed, 404 insertions(+), 286 deletions(-)

-- 
2.31.1

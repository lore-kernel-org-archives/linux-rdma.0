Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8AB356766
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838676; cv=none; b=EppYfMr0JHpYKWih5OBMhqmRHrCRwQ6WBRH02EDEPpHfKM+jXiERXofJqDJ/59bHIp1GVljkMqlctKhiKa+IkVevrAeSMuUySagR4pgmi/96zj8BMnvx9JZpH9QPxzys4r2ZMk4EkP+/rxzJ184ONcZldpg5j5T0cyl3/jyiecw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838676; c=relaxed/simple;
	bh=/R1MCsY5QfVq7AxeptHMtSx+YMv2TcVfOfUGbs8F1EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vCp0RPVDhU2aFVI1uR+hb2GhlPt0B74QUJhj6HDQjknQEU6u+ShyFyxxytoFXeFZhj/LWl3othxaqY1uP8rJ6KpQfWBoNYgxpHlSn6bbglB0Fh5+ueaGJP5tqxlX1ohdCmAskS3puGaT8f32mO1rHas7nQrTuUIANUS+yUWe0mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sEgCQDX6; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sEgCQDX6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788838631; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=txtmxeDdJKg4HscEnuQR8AQOdo5xPj1IIZpri2zQT/k=;
	b=sEgCQDX6iMg6SObVqDMARgVS+KNgqqqIC2zsQeJQ0UEWdM1hl5LrLIOgi8dIDSFC4n9WdVhDbNQB13vTI+ymTUJMjh6avLke641xt/GEu2XmrMBr6C4L7iB3PvCb+/JNLCQkYJdq3gvgEXcW9HA/+mULNvRYYu+IRbkhucodXo8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAaH5-4_1788838629;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAaH5-4_1788838629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 11:37:10 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v3 0/5] RDMA/erdma: Support non-contiguous kernel queue buffers
Date: Tue,  8 Sep 2026 11:37:04 +0800
Message-ID: <20260908033709.89898-1-chengyou@linux.alibaba.com>
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

- #1 unwinds kernel QP initialization failures explicitly.
- #2 adds support for non-contiguous kernel QP buffers.
- #3 adds support for non-contiguous kernel CQ buffers.
- #4 unifies userspace and kernel space queue buffer management.
- #5 moves kernel QP helpers after the shared memory helpers.

Changes from v2:
- Add explicit resource unwinding for kernel QP initialization.
- Use struct scatterlist for kernel queue buffer pages.
- Make memory cleanup operate only on initialized backing memory.

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
 drivers/infiniband/hw/erdma/erdma_verbs.c | 571 ++++++++++++----------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  60 ++-
 4 files changed, 400 insertions(+), 287 deletions(-)

-- 
2.31.1

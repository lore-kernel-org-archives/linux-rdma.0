Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE743939C9;
	Thu,  1 Oct 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878875; cv=none; b=SglLUndczSo+IxomsykEatkg0E49g4Igp/MiSwkb9512I6l9Hf9+YBpjUGY1UmSwPHjG5sRj1YwvDguFAE06vapzl9ZLStFtFCSHBDPlAK9uek1/Tmli/QQgdnzYjprxitDWgJlZ/YHsjWtU6Lvd0ULHKh0fNLkRrwnnwPLGlDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878875; c=relaxed/simple;
	bh=4rshS9XctKGf28WnOLSgd80GpFX+3fgpVCCeI6MXqGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BxXtRHD7SlzEwjrVxc5GX8oFASRCjyL5DnfVEr6V8kTVDqXHKbvOCDIo+26wJIjHyQrsluOQgaeNtEIxqjGYB/S9KI0vzDaLoBxXuAD4mGa8S3C75W9lblMaG92fQ1DuALreXxDWUDlNMCztCg/nB0TCZ+sfSSqlJ99PD08sXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mT4VWyOu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mT4VWyOu"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 05B0B20B7166; Thu,  1 Oct 2026 11:20:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 05B0B20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790878816;
	bh=WSAwCUnhQq36c+GY/8nvU7Wan3XpF2l+QigzEUWsKhw=;
	h=From:To:Cc:Subject:Date:From;
	b=mT4VWyOurIMVkWdmTMq6MyIrbAK07Q0pXPKc/mrKKcdVm5g2OjCPeEGmpHUzOZPeD
	 QnUfKaNG/XX9VkAjXPH8n01y1UPAjktDeCdKcDuG7Hb0fvP1oO0ARQcJGBpv5N4OY2
	 tOuqiHPFCJc+Dr96rUBEO7TW8u+fe0HF0yYSyJ/E=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Thu,  1 Oct 2026 11:20:05 -0700
Message-ID: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Add kernel RC QPs and fast-registration MRs to the MANA RDMA driver
for kernel consumers such as NVMe/RDMA and NFS/RDMA.

Implement QP creation and state management, work request posting,
completion processing, error handling, and queue draining. Kernel RC
QPs require extended-WQE and power-of-two-SQ hardware support.

Tested with krping, NVMe/RDMA, and NFS/RDMA, including RC send and
receive error recovery with krping and NVMe/RDMA.

Konstantin Taranov (10):
  RDMA/mana_ib: Allocate and map fast-registration MRs
  RDMA/mana: Create and destroy kernel RC QPs
  net/mana: Extend GDMA encoding for new RDMA WQEs
  RDMA/mana_ib: Maintain kernel RC QP state
  RDMA/mana_ib: Post receive WRs on kernel RC QPs
  RDMA/mana_ib: Post send and memory-management WRs on RC QPs
  RDMA/mana_ib: Poll RC completions using PSN and FSN progress
  RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
  RDMA/mana_ib: Handle error CQEs for RC QPs
  RDMA/mana_ib: Drain kernel receive and send queues

 drivers/infiniband/hw/mana/cq.c               | 240 ++++++++++-
 drivers/infiniband/hw/mana/device.c           |   4 +
 drivers/infiniband/hw/mana/main.c             |   8 +-
 drivers/infiniband/hw/mana/mana_ib.h          | 135 +++++-
 drivers/infiniband/hw/mana/mr.c               |  84 +++-
 drivers/infiniband/hw/mana/qp.c               | 323 ++++++++++++++-
 drivers/infiniband/hw/mana/shadow_queue.h     |  22 +
 drivers/infiniband/hw/mana/wr.c               | 385 ++++++++++++++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  49 ++-
 include/net/mana/gdma.h                       |  38 +-
 10 files changed, 1253 insertions(+), 35 deletions(-)

-- 
2.43.0

Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBB9306776;
	Sat,  3 Oct 2026 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791009693; cv=none; b=PuC4z8RZzwaDuxHWGZnX+S/SAp8ol+XBSI2KR0cPKk8kDUubZqKUayucHebBPImqHijmv3xqbXntEGnYAS+8LuQoEI0Z0ywLyYi80s4HGrwVF6HqFziSHwucZqY64SRWbiQWfg9Ym1vPB5uSLLuOOz5KfpfyGcSdosq+pFNPBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791009693; c=relaxed/simple;
	bh=W0Lrp5O7JT9f1/3a3ZLy9aC2ox5FCvI2nsy8n9OtBS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RG8r1DEfKppOaY7xA2jFQgyLjw7kByggVtbjOzrFwjwjjXaKFBS+rTMBcp57hB757TRACfQ4HDN5BJ0ATkPpjLmbPJsy1CzmGdugh1QuywqAFB4uxzmXvbCwRSKrv4oVrNQrNaSpaUVHcNvRJC+KejBOXFpnhKwfDGqpRzHGDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ffW1kdUP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ffW1kdUP"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E0CB220B7166; Fri,  2 Oct 2026 23:40:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E0CB220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791009637;
	bh=hM4XArEYUhe041GLEWfP21/6I8XFIH1+frLMZWEa54k=;
	h=From:To:Cc:Subject:Date:From;
	b=ffW1kdUP6kuRfJL37tdEsJR95ijX87EOArMbUO6PfbZgNL4pLaOx2Xje+DNW+4C4M
	 N7ysfQQu8TsTB4h9tawF4n1DF9Qf8arQ40EF+xKnoDfYKk1K/EUihDom3jl/QSRwXY
	 53FZ0XCPiOGCCqhiEhpwWalcB3lq3btowao2FTxc=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Fri,  2 Oct 2026 23:40:27 -0700
Message-ID: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
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

v2:
- Patch 03: Validate fixed-WQE capacity for the header, OOB and SGEs.
- Patch 04: Preserve UC QP modification support.
- Patch 08: Skip software CQ notifications for direct-polling CQs.
- Patch 09: Flush that ERR work during QP teardown.
- Patch 10: Limit drain callbacks to RC QPs and avoid completion
  callbacks for direct-polling CQs.

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

 drivers/infiniband/hw/mana/cq.c               | 242 ++++++++++-
 drivers/infiniband/hw/mana/device.c           |   4 +
 drivers/infiniband/hw/mana/main.c             |   8 +-
 drivers/infiniband/hw/mana/mana_ib.h          | 135 +++++-
 drivers/infiniband/hw/mana/mr.c               |  84 +++-
 drivers/infiniband/hw/mana/qp.c               | 336 ++++++++++++++-
 drivers/infiniband/hw/mana/shadow_queue.h     |  22 +
 drivers/infiniband/hw/mana/wr.c               | 385 ++++++++++++++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  55 ++-
 include/net/mana/gdma.h                       |  38 +-
 10 files changed, 1274 insertions(+), 35 deletions(-)

-- 
2.43.0

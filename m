Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E1128B7EA;
	Sat, 10 Oct 2026 06:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615286; cv=none; b=KqsBfIihReDWzQ2kP6a6rL7PghiB7PKTRyLgO+bh+J43Pl0/LNJ6sWtP/NL24swhja86sEUsMB1zmz22zhRb8mpAhziajJxVMZxppSI82xVtPUrhV3EhfoMDW8kk1t9FDpsGb53cw8LHar8tIxND3TzV8VYKIn1Vb85rOn60b00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615286; c=relaxed/simple;
	bh=AzSpBkcUmtXIAglapaFQzGJ2xrA1A50rumV25WCyoQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=moLnqxAgydSq3STD2DpVKVF8tU3U2GGQX3qFQ3QP3NOViaxZD1qVfBUteZMFtPPolcieg5Aaizzw/6k+64X3kTbnA6hvuJRdwOVMI6IsegU1TuWfx/4RJ5Xugxu1bhCBC/Hr3zXg53LDLH3bvmL6TpuJ7xBODbOPSDKJYhm5SWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=BcSN5QsZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BcSN5QsZ"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id A05EA20B7166; Fri,  9 Oct 2026 23:54:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A05EA20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791615283;
	bh=1KD7/ufdcs4vrJXuUUzRxBgQsE+UFt7wCNVL75TTFrI=;
	h=From:To:Cc:Subject:Date:From;
	b=BcSN5QsZ0tlJQIItQO/Z0NPbGCdY7DlEPR08HV3fSK3gm5kC9+sklsybSuoT4fVIe
	 b3ijs0WT5kilxhcHtPXKB112TtXX2X6a8XbiR8k2lzEnSnXA2wqpZWuNyfLnUkoHVd
	 xErIkbEYtAHKuoxmCqT0g7YJHShyaG4SgMF1VMzE=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Fri,  9 Oct 2026 23:54:33 -0700
Message-ID: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
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

v4:
- Patch 01: Use an explicit 64-byte FMR MST alignment
- Patch 02: Validate that the RNIC firmware reports at least two send
  SGEs and subtract the reserved SGE only for RNIC-based mana_ib.
- Patch 07: Add missing wqe_size to shadow wqe for SEND/Write, and
  return a missed-event hint for cached CQEs when CQ is armed

v3:
- Patch 07: Mask arm_psn to 24 bits before ringing the doorbell.
- Patch 08: Exclude userspace QPs from kernel software-state handling
  and CQ error-list insertion, and unlink UC QPs during destruction.

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

 drivers/infiniband/hw/mana/cq.c                 | 248 ++++++++++++++-
 drivers/infiniband/hw/mana/device.c             |   4 +
 drivers/infiniband/hw/mana/main.c               |  15 +-
 drivers/infiniband/hw/mana/mana_ib.h            | 137 ++++++++-
 drivers/infiniband/hw/mana/mr.c                 |  84 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 342 ++++++++++++++++++++-
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 388 ++++++++++++++++++++++++
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 +++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1296 insertions(+), 37 deletions(-)

-- 
2.43.0

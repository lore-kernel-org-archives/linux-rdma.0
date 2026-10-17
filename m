Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0A8413796;
	Sat, 17 Oct 2026 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219460; cv=none; b=EaO6cNyyhSpZFmA0ChIXp5fYn28h5wJc2oLqIjsz04Gi2p62sb/HL2q5BwyYUHBTTQM4apP0H8PqfLJdTojuI6kMlj4hea65FJH6uBxMM7XwEe0DYb7ss/h9KdXsOapTqd6AJ06J2ffuxmiJVwO+FXeh5xOyNBOXdQZSqi99Lbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219460; c=relaxed/simple;
	bh=6r4TWvQuVgcAPhQY7p1s3DhorpYPFUY0QgakfHlO6u4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ucIY34mP0OR/1V06Ok/9aWbI4bWVzEYPY9rKrpOlcwVbCBrtMYIjs+oFDmUtM9pGzKkxmG7L+67RwCtA+mr8d+faVaGVqwRZDCVz6bn3O7tOpvEC7/Kf2goBoYoY2Oi7TV09ZxkhhmY4Odp9xkB89NFotnyIvK4UvNy5kGHbqLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rPxeEyho; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rPxeEyho"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 2EE5820B7168; Fri, 16 Oct 2026 23:44:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2EE5820B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792219453;
	bh=KJ8TckStkBjNfFZJYdAXnpxCRGhLIn6RFqXw99tkzpQ=;
	h=From:To:Cc:Subject:Date:From;
	b=rPxeEyhoHAfD+C07KHzXDS7VcgR6Ea2hVCYRJ4oXS35fV8eZRWuNsIFuZgGy86J3t
	 wSMq3+LbnBzIQw6d0XdtQALdLyfoZn2ZMky7zZAR6m8KzKUxeiP/GYVoFVS8TEIaLC
	 Rd6YbQwQUITuNizysRAc5ydFFs6Pi1y2TsxAexUQ=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Fri, 16 Oct 2026 23:44:03 -0700
Message-ID: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
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

v5:
- Patch 01: Reject max_num_sg above MANA_MAX_FMR_PAGES.
- Patch 02: Validate kernel QP queue sizes and SGE limits to prevent
  overflows. Ensure that queue size cannnot be 0.
- Patch 06: Preserve fence flags on unsignaled WQEs. Check message
  length and read sges before posting a wqe.
- Patch 08: Remove the unused QP state field.

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
 drivers/infiniband/hw/mana/mana_ib.h            | 134 +++++++-
 drivers/infiniband/hw/mana/mr.c                 |  87 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 402 +++++++++++++++++++++++-
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 395 +++++++++++++++++++++++
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 +++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1355 insertions(+), 45 deletions(-)

-- 
2.43.0

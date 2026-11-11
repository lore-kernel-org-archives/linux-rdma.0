Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399262;
	b=sh5SrFgGUiZnSZj8ZbkuCtoluRzZz+CyN3Eu2Y9VKAdlY+gKSyeZ3kvpvBgb7h0pfbIR
	 eVJ4sTVFuQOjy4aa0ZNeMzzMF7kO+wZ9tZf/3YMzvv6+wd/NFDX32n9mxmoE+UgyTRDQh
	 Hl6Q7KgvKufUH338QkafzENlRXZvfzJP6XEjPjZ3Kt6JlMF1UHF2BS+QzyEL3QXN9eYQQ
	 4PPZLU5nzQCoZ81UDvsVfHbXFYRTKH6c3SXN4UCnONqbjyFvhjbq6oBrptKulzCiKPBsS
	 N6l/8VIrPFOKpu+EMgnwz/dFLbrJvJyxjuVDK+Mm/J+UPTQbxXYAj7DPeb/IkUPsP9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399262;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AQc0DZ0qV0ZE3G8l5gvbnQOxTIHAkdHj4Id5erQfDG8=;
	b=xT8seNh29GfB+stBh4GoQyDM2REMJHlXkwb3x69cFqm8qWq42DO7sJLPElEBHK68TcUt
	 VhyxgHAtYDzMH8Y9vhlq0zfSHXzEfO+jbf+kMvvpVpbTjjP8HgR0EMw/nVnUu5FvOBgnn
	 wRrz6t5DnAWFjxniBoytLNZYT249teJySNxRXt9Yb5C9P2c9Z1gGPxtfN4j2IOQ2AfPJD
	 z2kFHFBGOLOxML91pr2AzslZ568iNLYV+dBovZgJ9sYm5IPG35EElf1F1oSo9aqdLrawU
	 ePNM+QKg0Pf7NUwFdg2Y5MPdssfBUgN/3s7+XhioDrgm7WWaJeho0i0XPnot1rmgaQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="V/YqdciU";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDE8606A326;
	Wed, 11 Nov 2026 12:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CDE8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=V/YqdciU
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id DD28020B7169; Wed, 11 Nov 2026 04:14:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DD28020B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794399257;
	bh=AQc0DZ0qV0ZE3G8l5gvbnQOxTIHAkdHj4Id5erQfDG8=;
	h=From:To:Cc:Subject:Date:From;
	b=V/YqdciUnKDLrqmEuxydIA3IIVr83L+5nTDPRr1H0XIh+AYnJxjSJ8PTm0/YqT/Id
	 vVMhW1Vmm80PapTfWQjwhnanfk/OQUrvgbz5a2vbuqvj3YDmZgLbn+FZ2gYmy0HUG5
	 y3LcZYkNMsWQsc2aUIByAl195FAp/apPZm1JTYUU=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v10 0/9] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Wed, 11 Nov 2026 04:14:08 -0800
Message-ID: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Add kernel RC QPs and fast-registration MRs to the MANA RDMA driver
for kernel consumers such as NVMe/RDMA and NFS/RDMA.

Implement QP creation and state management, work request posting,
completion processing, and error handling. Use the RDMA core's generic
queue drains for kernel RC QPs, with software-flush notification in the
posting paths. Kernel RC QPs require extended-WQE and power-of-two-SQ
hardware support.

v10:
- Patch 01: Remove the FMR page-count limit check
- Patch 02: Remove the minimum firmware send-SGE check, kernel QP
  queue prevalidation
- Patch 06: Remove send-SGE and READ-SGE limit checks and message-
  length overflow validation

v9:
- Patch 07 and 09: Retire acknowledged successful unsignaled WQEs with
 a full WC array to avoid deferring rearming.

v8:
- Patch 06: Annotate rc_send.immediate and immediate_ext as __le32

v7:
- Patch 09: Include GSI QPs in deferred ERR handling.
- Patch 09: Complete software-flush setup even if the deferred firmware
  ERR request fails. An error CQE guarantees whole-QP DMA shutdown for
  all QP types.
- Drop patch 10 to use the generic SQ/RQ drains for RC.

v6:
- Patch 08: Notify software flushes after posting to error-listed QPs.
  Add reporting pending software flush for IB_CQ_REPORT_MISSED_EVENTS.
- Patch 09: Check fenced WQEs on error cqes to prevent flushing completed WQEs.
  Add mana_ib_cq_clean on QP reset to discard stale CQEs. QID 0 is an invalid
  value for RNIC and safe dor discarding. Add error_pending flag to prevent
  a deffered ERR request to error reset QPs.

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

Konstantin Taranov (9):
  RDMA/mana_ib: Allocate and map fast-registration MRs
  RDMA/mana: Create and destroy kernel RC QPs
  net/mana: Extend GDMA encoding for new RDMA WQEs
  RDMA/mana_ib: Maintain kernel RC QP state
  RDMA/mana_ib: Post receive WRs on kernel RC QPs
  RDMA/mana_ib: Post send and memory-management WRs on RC QPs
  RDMA/mana_ib: Poll RC completions using PSN and FSN progress
  RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
  RDMA/mana_ib: Handle error CQEs for kernel QPs

 drivers/infiniband/hw/mana/cq.c                 | 357 ++++++++++++++++++--
 drivers/infiniband/hw/mana/device.c             |   2 +
 drivers/infiniband/hw/mana/main.c               |   8 +-
 drivers/infiniband/hw/mana/mana_ib.h            | 139 +++++++-
 drivers/infiniband/hw/mana/mr.c                 |  84 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 289 ++++++++++++++--
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 423 +++++++++++++++++++++++-
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 ++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1349 insertions(+), 68 deletions(-)

-- 
2.43.0


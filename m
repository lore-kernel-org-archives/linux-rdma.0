Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704665;
	b=dpZLqupzoK0z5EoqL1vg0M3BWxoXCtET0DE48DoIDxmkanChFLKwYJ3kcc87ulNSE6xv
	 ne2YtPMhb4P+6p7O152v67oMBOZZC1NCdwJCawuE1+tR+eeCCG65kB0GdrO1orUlMFRCX
	 yQHF9EksWlEV+FCHCnZNEiJmAFheCSDn1dfSpu0UpRXYWrjI8ne6XKz0fR8ByehgmB1lQ
	 zmonpBydOLmLBL1XvQ9A/IoEqdyHwvfDDOZWMY0DIkqFmIC792qAevECncxn6ikNsdoi8
	 PMahUI4+p/83D5CNPKJ5BgjEdNPcremOU1bOYmfeYd7DOug5ewn58zjduawwearmabw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704665;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=EBO/bCkZUVwX4wNiyWd+6LkL6t+oxWYMxsCLdhnYOXY=;
	b=cmhlhEGaL5nnebuWc2Yg73CAzCf/5M8044LXEOpFmkvKG8LRzGgE458NUSqShmWZ6rPn
	 eXqR3uyiZidfm6dR+ObzOKOre/mv4Kd+0rPqTTRITvF9+Fk6Jahf2Wvj6e84Bomi0DDw7
	 LZieELn/k6wZbA1z2DSoFnS9hZ0kY+AzKSZ/p0U1JYju34bf+zGJs3h6wHJ3aVnkNtmdf
	 BYxA9NnlwxnXvEDAeky//Q5K6iQpf+6jZUZGnxRYC4YwxO4isKwV/BEuM32a815v69Kot
	 WuDChwi8QLsn6sEUh774btKsJQD3AlPXJKSdsaEaiaccqtRWTvPz98CHi2K49qgSkYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=WO2sJTNA;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA65606D80F;
	Tue,  3 Nov 2026 11:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DA65606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=WO2sJTNA
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 375F220B7167; Tue,  3 Nov 2026 03:17:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 375F220B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793704649;
	bh=EBO/bCkZUVwX4wNiyWd+6LkL6t+oxWYMxsCLdhnYOXY=;
	h=From:To:Cc:Subject:Date:From;
	b=WO2sJTNA8Nt2pZG3zVVSFmKZciOOP8fFLjiX8YfWtLVoeyNuMMpiRQ2R4aseSWaTo
	 JmzUU5x1bZ33iRmt2LOPSU26pKWTa3xu5YATCl3TPQQL89WVN9HCtzBNcptisjHv9d
	 VrQeRZVYL8HaBCPM6Hb8tjyXdPY36jXforYpZXUk=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v8 0/9] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Tue,  3 Nov 2026 03:17:20 -0800
Message-ID: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
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

Previous revisions were tested with krping, NVMe/RDMA, and NFS/RDMA,
including RC send and receive error recovery with krping and NVMe/RDMA.

The v7 series also passed 22 NVMe/fio profiles and 20 krping cases on
two MANA VMs. Active-I/O resets and disconnects exercised generic SQ/RQ
drains with softirq, workqueue, and direct-poll CQs. Tracing confirmed
post-marker notifications and completion of all 200 captured drains.

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

 drivers/infiniband/hw/mana/cq.c                 | 353 +++++++++++++++++--
 drivers/infiniband/hw/mana/device.c             |   2 +
 drivers/infiniband/hw/mana/main.c               |  15 +-
 drivers/infiniband/hw/mana/mana_ib.h            | 139 +++++++-
 drivers/infiniband/hw/mana/mr.c                 |  87 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 327 ++++++++++++++++--
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 433 +++++++++++++++++++++++-
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 ++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1402 insertions(+), 69 deletions(-)

-- 
2.43.0

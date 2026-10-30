Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365252;
	b=AVxStFMoqT6EUN9vrT4YZVZzIEMmTxC/czugu3O55JZCS9kzbXJnrF3Uj+qS620NXsXq
	 lFbvdQtjtUS/g6tXKtsTDtnpu/d7Vn4pnPbqxd6PnsVx39R95iQoWUqhBcA/2nCyPoYO7
	 YbLZsFY6LAV5SLDFISf/g6EdNFkfldp9RbTyo9Vn9RL7hNa9rRMT2eM7595PsjWUNkV27
	 JA93m+XZfS8xQ5D7HqBdr0LgR5oG+diS9ywea6/ju+wpeFrw4gzcBMDbvt0q6ckA9hRSR
	 LltGoEIHhfW37x+tIl3rObDt1Q2pyrurwAOQfqz16NBaEU233V74352FoQoSaqdBoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365252;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=FdQI/LAyKYbv+9FCjDCDMznPudCLTAfsdLXbDWfNWWI=;
	b=mGNm/X5LWgfB2mw2MQsdwkjmjT4h4kmDiql088CYrGJWl+v9vuv75Yyjid4du3tslC9F
	 3geDN0QCXNA3wY7Yg9MUFG572U4N2nU4sqCtiC3yh3QU3+S2FotqebdHU4mwRu2138TLW
	 u0MB7YEJZ6x/S6bpN/RiVE0qsKbf1fSnFtNIyBOtHi7wRvjs//+MOhiT1WcUOZpWAUQck
	 OYPch6ao0Oh8DAqhnPwMHBxl2wQ1BhtXZmeHxNTo8uv9q/OPeMDSMjp26rEFfHRoZlv9M
	 HJTPRUOtbblqI4eUvZ2Vu84Y+iebluM3ByIAtn7EcIDc9A+YTyej6Hn2gLDEsUuuE+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BtXh44zZ;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA506606A321;
	Fri, 30 Oct 2026 13:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA506606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BtXh44zZ
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 657D120B7166; Fri, 30 Oct 2026 06:00:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 657D120B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793365238;
	bh=FdQI/LAyKYbv+9FCjDCDMznPudCLTAfsdLXbDWfNWWI=;
	h=From:To:Cc:Subject:Date:From;
	b=BtXh44zZdO0mkuPy/0323D/VJ8j03p2F55DmNE5JlD7ct3+5NDuExWxMO9X+IcpfP
	 JzV+J0T4l2Qj/vLmBPqoRg3XHAlE+iuk/J1ok1T5kBYjD1x7Vk1JiNDLBz5CFc/xzz
	 sKYNpsF6pn3DyWxboMKFX8y5YbrQRcyCdw/VIpPY=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v6 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Fri, 30 Oct 2026 06:00:28 -0700
Message-ID: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
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
completion processing, error handling, and queue draining. Kernel RC
QPs require extended-WQE and power-of-two-SQ hardware support.

Tested with krping, NVMe/RDMA, and NFS/RDMA, including RC send and
receive error recovery with krping and NVMe/RDMA.

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

 drivers/infiniband/hw/mana/cq.c                 | 354 +++++++++++++++++--
 drivers/infiniband/hw/mana/device.c             |   4 +
 drivers/infiniband/hw/mana/main.c               |  15 +-
 drivers/infiniband/hw/mana/mana_ib.h            | 137 +++++++-
 drivers/infiniband/hw/mana/mr.c                 |  87 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 427 +++++++++++++++++++++--
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 433 +++++++++++++++++++++++-
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 ++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1506 insertions(+), 66 deletions(-)

-- 
2.43.0

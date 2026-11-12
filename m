Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473241;
	b=1H55iJzDgxGsLfdTwbQ3rjVGgEgBh4WOiKiuF9gktw4r8vMu1FziBHMk7a3C+Vf+gAb1
	 6ytk8Yzvt1ZFcaF7uGURurPlISXthoY6mnvYsT+tIEcJMCRBGpCuCfLqxaQTF/fYJr6lz
	 pgGoT5FMaVs2OvvcDfG2oiOcpypgXjtVuCZ7CP8X2Y5UzPVWfS60Xuzy1uqJ51M3TY6Jw
	 u+NLQO6CrSXDYKd1zh0+sUin+TUHYJ/YWumn3VOcVSC9kqlvqEaFuRS7EsWYPPAI+zBzL
	 2YQrWVmv4Endp9kxjl6snjbnyW2m8cfkodUHlsvssCUz6pfpGjORJCROFLthdGxYWsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473241;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IuEo+Yi04Yv9K5s/ToDHf1mLoQ9aV0vni1jo7HIQfu8=;
	b=GHsMZL1KvcIj0ff1j+TS5JxijuKC2HncCkm7XCc3X3dBXYoyUERf6UBZEFieG8mmHnOc
	 4h5MHmw5ymGpVVEs8u5eMKiVEjvAbrY910C2bam1kaam9gH//amc9fgmg0H51bkr3CaAG
	 HV2MDyabbQYRrKx1YLEHLdBB3TyKthVP2dzRbcG9xAQ/ScTHWOv6AGIGMCR/ONGMvwWsm
	 oFg7lDbqUgSG3VM3zslp+oYIzWTsraiNj7ATbKz0BmYgTVSw4TMQNgUsaHXnkzrJtub+t
	 OvX+ihqamnuSmv6h18ZuvWafzRjCZruhJ+SKArbXAFKYqObosG7wJnwu1aK3jtMFijQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qs6Gn4hi;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F325606B587;
	Thu, 12 Nov 2026 08:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F325606B587
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qs6Gn4hi
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 7F38220B7168; Thu, 12 Nov 2026 00:47:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F38220B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794473236;
	bh=IuEo+Yi04Yv9K5s/ToDHf1mLoQ9aV0vni1jo7HIQfu8=;
	h=From:To:Cc:Subject:Date:From;
	b=qs6Gn4hiQT80citANbsHhVcxThoYltayH/1SbV+3DF7c+uXgf8MbQSkgAx39r8tCB
	 m4gHOhS2m5vPUCGu/a7MtbUjnq/nzdAwfo5sMYjCQtn6d9wx3urT4om2OL//+CsCe7
	 8F4xnIqQYD+t8FIGV9ygevsKmU95ddPPCTCZ1Y2o=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v11 0/9] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Thu, 12 Nov 2026 00:47:07 -0800
Message-ID: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
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

v11:
- Patch 09: Reset kernel QPs before destruction unless already in RESET
  or INIT, and always clean CQEs. Keep shared-CQ cleanup under one
  uninterrupted CQ lock.
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

 drivers/infiniband/hw/mana/cq.c                 | 356 ++++++++++++++++++--
 drivers/infiniband/hw/mana/device.c             |   2 +
 drivers/infiniband/hw/mana/main.c               |   8 +-
 drivers/infiniband/hw/mana/mana_ib.h            | 142 +++++++-
 drivers/infiniband/hw/mana/mr.c                 |  84 ++++-
 drivers/infiniband/hw/mana/qp.c                 | 332 +++++++++++++++++--
 drivers/infiniband/hw/mana/shadow_queue.h       |  22 ++
 drivers/infiniband/hw/mana/wr.c                 | 423 +++++++++++++++++++++++-
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  55 ++-
 include/net/mana/gdma.h                         |  38 ++-
 10 files changed, 1386 insertions(+), 76 deletions(-)

-- 
2.43.0


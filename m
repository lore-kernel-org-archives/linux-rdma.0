Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700F74BA1E1;
	Wed,  7 Oct 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387273; cv=none; b=phN1j/sMhuCBK5iYscpuxF27YE2keq9hYUUhV510WqZh+w7qZ5eosD8VWczramYiUo1uJSwwqhfs7fB+zpHVDygi7zEYzC79y/QgAVLuAREEeSBEU/KVBICrpO17eM1qb+jKShqb5ieoxDRsg02x81SSa2O5fbnjBDjze5Q1OfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387273; c=relaxed/simple;
	bh=sJPC+6KqEiiYcLwYM5XpJuVIQep/HsjJoVlUvGEgAd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kjJEtFqj3zZrakWtsn4HKyAC59vVb95FTDEAnL80OYSX8d/MXGyApOGqvm29Owg98bNjrG3dw1rYfKv7kwJ3Xl9hhvm/1rbZg87Dy+qAGD6XXyb9/0ZYn7Lw6Ye3VRThQ5aMQHD9/OgS23t0VFdE1xZKBAwXJNEDb0iSjajk3G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=UF7LrUob; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="UF7LrUob"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id C492A20B7166; Wed,  7 Oct 2026 08:33:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C492A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791387210;
	bh=xgaAkx66IrA/fboS29JwalNhauKWU0sJvD8sU16dDf0=;
	h=From:To:Cc:Subject:Date:From;
	b=UF7LrUobsYLr6BowMqLwaLAtNIUIBBMxdZVjx4zJrcEtLIj5w0lSxZ2edl5PmpNOj
	 nPibXEZBRVm5qpnSz4V0OuTEREKQmwDGibRTxOFAFeyP5/Jw8oLyecrYjT0B0C9/KW
	 YZzlrgMW4DiJbyJYwSiSdeH9tLECP1eKH8KkegZ0=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v3 00/10] RDMA/mana_ib: Add kernel RC and fast registration support
Date: Wed,  7 Oct 2026 08:33:20 -0700
Message-ID: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
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

 drivers/infiniband/hw/mana/cq.c               | 243 ++++++++++-
 drivers/infiniband/hw/mana/device.c           |   4 +
 drivers/infiniband/hw/mana/main.c             |   8 +-
 drivers/infiniband/hw/mana/mana_ib.h          | 135 +++++-
 drivers/infiniband/hw/mana/mr.c               |  84 +++-
 drivers/infiniband/hw/mana/qp.c               | 342 ++++++++++++++-
 drivers/infiniband/hw/mana/shadow_queue.h     |  22 +
 drivers/infiniband/hw/mana/wr.c               | 385 ++++++++++++++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  55 ++-
 include/net/mana/gdma.h                       |  38 +-
 10 files changed, 1280 insertions(+), 36 deletions(-)

-- 
2.43.0

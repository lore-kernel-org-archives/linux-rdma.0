Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0564245D92C;
	Mon, 21 Sep 2026 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984481; cv=none; b=Gvj23fuOSmMGeg4Y8I/zQf/DwUpscMz0QQz1W7PUtJO1Umgq9zdoMX49V/MnoIrzGefTrtQ15BL971uxOnuE8hvGkWKWVCgFVJ/ClC8AuVcQcxJCu3m3Yjs7P/6Z00dViRHxLr7qNqtCmXtpqk/Y60riNTDYjSACp8Ygy/hGjK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984481; c=relaxed/simple;
	bh=jYcxfkf4tR4CCN/lTq9CiR/Ig9QNlNc7qvq4KdFeAMU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kczsnm/jpjtkOyi3G7kC1OtXodv/zhyw/9W5mHVpQUmgMPA+ssYqHdJ7KscAOWK+XM0KZEjyoarTmOwQcjabkOXOte9dWm3rQ8aS9YneEWmseBwwxixjBGsJ1q5aVGn4rKCA1YF4YiKETaViRc2j8/YCInh+EWHk1KoTQ/ifWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mxnJFNJ1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mxnJFNJ1"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id B062920B7167; Mon, 21 Sep 2026 02:53:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B062920B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789984432;
	bh=LGY2veuH4DF4OfX4IZ5zQkf2eApYb+BnVa7cOizC518=;
	h=From:To:Cc:Subject:Date:From;
	b=mxnJFNJ1IK2bzIH8ypYFwZWoaBULmlPV2as3E1tckxly+AHDfsHrwDoh5jKc4NZYc
	 /AW8sD2Qb4u/1gpq15tnHcm4L8Nw1PV5A8UzuR3kN5Uyq2Dg9PaTFJ8wov8Pl+I6ur
	 vUff3ZA9RihuaM5omSZiXCVR9W+IDsIFpTQOwm68=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v3 0/5] RDMA/mana_ib: Streamline kernel UD/GSI posting and completion handling
Date: Mon, 21 Sep 2026 02:53:47 -0700
Message-ID: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

This series updates the kernel UD/GSI work-request and completion paths in
the MANA RDMA driver. The existing completion path copies CQE information
into shadow entries and then walks the QPs attached to a CQ to produce
work completions. This adds bookkeeping and a second pass over information
that is already available when processing the CQE.

Generate work completions directly from CQEs and the corresponding posted
shadow entries instead. Keep only QPs requiring software flushing on the
CQ's error lists, and use the caller's remaining completion budget to
retire their outstanding requests. The explicit GSI send-drain path adds
the QP to the error list and invokes the CQ handler.

The shared GDMA SGE writer and explicit-index doorbell helper are included
with their first users so this series does not depend on a later GDMA
change. The WQE definitions and polling context also provide groundwork
for a separate kernel RC series. RC posting, PSN/FSN processing, hardware
error-CQE handling and automatic ERR-state flushing are not included here.

Changes in v3:
- Patch 5: Track unsignaled send WRs in the shadow queue.
- Patch 5: Validate the CQE target before retiring a shadow wqe.
- Patch 5: Notify the send CQ after posting to an already-flushing QP,
  outside the CQ lock, so GSI draining does not need another hardware CQE.
- Patches 1-4 are unchanged.

Changes in v2:
- Patch 5: Hold the corresponding CQ lock while resetting each shadow
  queue and removing the QP from the error list, serializing RESET with
  hardware polling and software flushing.
- Patch 5: Return the unmasked WQE start offset from GDMA posting to
  discard mismatching CQEs without producing a WC.
- Patches 1-4 are unchanged.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Konstantin Taranov (5):
  RDMA/mana_ib: Optimize shadow queue bookkeeping
  RDMA/mana_ib: Revise UD send posting and WQE definitions
  RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
  RDMA/mana_ib: Make kernel CQ arming robust
  RDMA/mana_ib: Poll UD completions and flush software error QPs

 drivers/infiniband/hw/mana/cq.c               | 344 +++++++++++++-----
 drivers/infiniband/hw/mana/mana_ib.h          | 105 +++++-
 drivers/infiniband/hw/mana/qp.c               |  84 +++--
 drivers/infiniband/hw/mana/shadow_queue.h     |  61 ++--
 drivers/infiniband/hw/mana/wr.c               | 158 ++++----
 .../net/ethernet/microsoft/mana/gdma_main.c   |  49 ++-
 include/net/mana/gdma.h                       |  11 +-
 7 files changed, 586 insertions(+), 226 deletions(-)


base-commit: 63367df6e7255067ad6a83abe0d2799dfa491876
-- 
2.43.0

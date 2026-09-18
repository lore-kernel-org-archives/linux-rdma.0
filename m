Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A194F7CB3;
	Fri, 18 Sep 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740295; cv=none; b=K+lXCUp0C79Nln7ravOPExDNKOgww0fOsknfEbLvRMUHBIKK3gsA+WJLCzhQ/6NXOp4tyU4RdyoI4bU55X7QktHxJ9+MkM69fw8jsEqDiwQeoUt52Y2jFPMsk68Jm5Zg4/WatXmJYTJkgujAn3u2PTfmx+T99Gu9GniSD/5X0pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740295; c=relaxed/simple;
	bh=AAaAzLQljlFy+qGjIL2lKBiRnFTL+d69E4HPnjcTW4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iDcujiGXUwZL59Ri0dT9tSZjbaO/8HxA64O+3GMIwKpn9qM5ozLV0jDhi+dpeDlrYFsY17nSzDkceedrubOPu2MfWmLA9CFHBi3drwft0+2HmIZu014Ouly8VuI3Qjdzyb+/wqvGhERnf6eXuXOb4qqMwEt9A+F5NfbBtNvqA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=P5snDs+X; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="P5snDs+X"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id B157B20B7166; Fri, 18 Sep 2026 07:04:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B157B20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789740247;
	bh=HJhEPsJKl4oFg/fGDixlKVJMTjWTWz1p8EV/ZJ15kd0=;
	h=From:To:Cc:Subject:Date:From;
	b=P5snDs+XnSg0oFMmxJEVbVQXqwNJkkkdPct9wt9aaLFvqiFFwNttRaM8tW8riKpwo
	 Nq3mbtljxApA2YCs+W7ZR8Tn1Snq/M1p043FNCCrg2FPJ3Yh0Eh6s7RIHNgjvGdDhk
	 9PgFtKvs03w1OMcgL/V5/ei7aqFxGsCf2L86mpl4=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 0/5] RDMA/mana_ib: Streamline kernel UD/GSI posting and completion handling
Date: Fri, 18 Sep 2026 07:04:02 -0700
Message-ID: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
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

 drivers/infiniband/hw/mana/cq.c               | 328 +++++++++++++-----
 drivers/infiniband/hw/mana/mana_ib.h          | 101 +++++-
 drivers/infiniband/hw/mana/qp.c               |  83 +++--
 drivers/infiniband/hw/mana/shadow_queue.h     |  61 ++--
 drivers/infiniband/hw/mana/wr.c               | 143 ++++----
 .../net/ethernet/microsoft/mana/gdma_main.c   |  49 ++-
 include/net/mana/gdma.h                       |  11 +-
 7 files changed, 553 insertions(+), 223 deletions(-)


base-commit: 63367df6e7255067ad6a83abe0d2799dfa491876
-- 
2.43.0

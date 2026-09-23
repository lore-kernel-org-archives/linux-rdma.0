Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766F052CCDF;
	Wed, 23 Sep 2026 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169171; cv=none; b=GAupk7jTEH+8D8PogF8v3mYHKyFRyxHCo4HDypiIZdupJu/BGCP844Gr/2H5X8G6sQjVsL90XZ8Zt7ItcXgJGMmCCcPL9yMd597Jw678VbL2qQ77LaTiSrsa781fQ7Kev8KpHOHQP5wspj1u33aRd8sfzsAOsK/q1voyFFWJmQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169171; c=relaxed/simple;
	bh=68FP7Ds3sWCOSZ/OBvW6Kad2SEYY/uzF39eWOmqWYfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YBuwhPYqBL8ftfMTrss/yV/hvzjSjWJ8sLYDsK4hF+/VSi93SP6lkYVqY64q79tw5epbJqf2VyQbEerVXaBvnI3aJXLLQJgEdq7vXueF/EuAg+K5VPMFbXf0pDHRY2H3fVzBWsNsxBnsrJpuZ1bxSNCxDjNVH/k8D5XedyQBdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lUwyQYHx; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lUwyQYHx"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 314E620B7167; Wed, 23 Sep 2026 06:11:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 314E620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790169115;
	bh=zXxJq0ZSZ3A+Rdc/pkqtrbx7rBtEb5rdNB2Y5EbvlU0=;
	h=From:To:Cc:Subject:Date:From;
	b=lUwyQYHxzOD9oCNtWA0fAmhBdQO1EbVHh0JtjtQMV3zcgfdsneABqH0xeLWYXrnVA
	 AcziSj6pM7fP6swFlZxwERBUE6LVUYKhGIgfScT8BnRPiR6RfH/5BqbFtNvUFrDlDb
	 kOLOZzR7ciEsUzvK5J7DKeNW390neBGnLVdAQxt4=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 0/5] RDMA/mana_ib: Streamline kernel UD/GSI posting and completion handling
Date: Wed, 23 Sep 2026 06:11:50 -0700
Message-ID: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
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
the MANA RDMA driver. This series is required for upcoming kernel RC QP support.

The main idea is to fill in WCs directly from CQEs and do not use shadow Qs
as proxy. The older code, a CQ had lists of QPs using it, which adds overhead
on polling when CQs are shared. Instead, CQs now maintain only the list
of QPs in error state.

The series also revises posting WQEs to reuse it for RC QPs in the next series.
We also add GDMA_WR_IB_SGL flag for posting to remove sge copying for RQs.
The RC QPs will use it for SQs and RQs.

Imporve CQ arming to avoid doorbell drops in hw. MANA hw requires occasional
arming to update tail offest in hw.

Changes in v4:
- re-write all commit messages

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

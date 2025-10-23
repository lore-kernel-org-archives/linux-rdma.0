Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678412C15A9;
	Thu, 23 Oct 2025 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761213782; cv=none; b=PlL5X0v3+ph0Pbp+Um+DhGc/JOGECDOoGKfJepy+QebKDgMud3b15slJYrQp8faie2W3XOJ1uqyPMRqVuU8Y+qGEvaIG+qzgmmTi8KaX/fvWSAFgZUPa2HkC6YfWIkBCgZciK73NWFcJBq8VDv8U7w35dVowCPr0D3H8Czg3pQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761213782; c=relaxed/simple;
	bh=+r1IRvM6NTQC1LpyB9wqFRpxfkUgVBrP5PBWWe3/ias=;
	h=From:To:Cc:Subject:Date:Message-Id; b=bbV6sri8ju4JjESzX4p2MTn8xO702fIBZ2D3tnQiWo1WAVVYdWubn35FnGzzAiEGTY45FA3S2wGu/DmOs6xdZ1tAqB4jeu49gcHObAK9SP1wfZUNk42nSJ1vCJ7XUPQYkSnXmHCc+cRvAcpiF8gLp6X2NP3EPn11jA3cOY89qKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=GFI7g7H5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="GFI7g7H5"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 18A6720145D2; Thu, 23 Oct 2025 03:03:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 18A6720145D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1761213780;
	bh=nu9m/O3l7H1AEcBrP3tRMCovSCkpELdYPyBeiyFYX0c=;
	h=From:To:Cc:Subject:Date:From;
	b=GFI7g7H5mdaYPOCxoaYj09hP6ac6BYJF/aUVcP7F47eyWpcfQxVzTW9j9cG0NSU+M
	 wM4Bn0Me+QxgOJmphRe7Y6pKcckoyPwqUHxV+rvmaK9tqjEjJbvRP2BDPbkC2RoACL
	 KfALRqpmcIkJZGoUs8hT6ux8zuHvcQUamwatf4q0=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	shirazsaleem@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: check cqe length for kernel CQs
Date: Thu, 23 Oct 2025 03:03:00 -0700
Message-Id: <1761213780-5457-1-git-send-email-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

From: Konstantin Taranov <kotaranov@microsoft.com>

Check queue size during kernel CQ creation to prevent overflow of u32.

Fixes: bec127e45d9f ("RDMA/mana_ib: create kernel-level CQs")
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 1becc8779..7600412b0 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -56,6 +56,10 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		doorbell = mana_ucontext->doorbell;
 	} else {
 		is_rnic_cq = true;
+		if (attr->cqe > U32_MAX / COMP_ENTRY_SIZE / 2 + 1) {
+			ibdev_dbg(ibdev, "CQE %d exceeding limit\n", attr->cqe);
+			return -EINVAL;
+		}
 		buf_size = MANA_PAGE_ALIGN(roundup_pow_of_two(attr->cqe * COMP_ENTRY_SIZE));
 		cq->cqe = buf_size / COMP_ENTRY_SIZE;
 		err = mana_ib_create_kernel_queue(mdev, buf_size, GDMA_CQ, &cq->queue);
-- 
2.43.0


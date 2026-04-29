Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D258437757A;
	Wed, 29 Apr 2026 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777500989; cv=none; b=aUq0IdAK8XAM5W2l8oJHtqgOWgmnZNb1LQGWQej678FH4Ir4x8RiijktRKpa+dD0tLtg2D/Ew47A2IIieXHz7iRZ2hnNw7LcQUQwnYewMtmtXQVXtPoH66ocW0HMKGXSCu/expe3WHlJQ8y8DWpconRJfiXqfkYvnTm+q9tGjo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777500989; c=relaxed/simple;
	bh=g2elQ2LNyV4dm3QMU4usylgpVfyTYrLxwAIIqZy16tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tQ1jJa967dwJS7NxfEoJwHGV5w4s9hqvqNWQpabXAmCnCq1JpfTZ1yBEbZ4A8GlDmVIrJ7DapdEmqfGEDIIJKqPoOZi5TESHqIknTN89nYZ/x/G/JaXcmD3m4SUR8tG2TuBDduLcfureP6CZj0htZs9fxUKdg0ouzsn2uDn3zrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 2FF1420B716C; Wed, 29 Apr 2026 15:16:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2FF1420B716C
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>
Cc: Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 0/6] net: mana: Per-vPort EQ and MSI-X interrupt management
Date: Wed, 29 Apr 2026 15:16:19 -0700
Message-ID: <20260429221625.1841150-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds per-vPort Event Queue (EQ) allocation and MSI-X interrupt
management for the MANA driver. Previously, all vPorts shared a single set
of EQs. This change enables dedicated EQs per vPort with support for both
dedicated and shared MSI-X vector allocation modes.

Patch 1 moves EQ ownership from mana_context to per-vPort mana_port_context
and exports create/destroy functions for the RDMA driver. Also adds EQ
create/destroy calls to mana_ib_cfg_vport/uncfg_vport so RDMA vPorts get
their own EQs.

Patch 2 adds device capability queries to determine whether MSI-X vectors
should be dedicated per-vPort or shared. When the number of available MSI-X
vectors is insufficient for dedicated allocation, the driver enables sharing
mode with bitmap-based vector assignment.

Patch 3 introduces the GIC (GDMA IRQ Context) abstraction with reference
counting, allowing multiple EQs to safely share a single MSI-X vector.

Patch 4 converts the global EQ allocation in probe/resume to use the new
GIC functions.

Patch 5 adds per-vPort GIC lifecycle management, calling get/put on each
EQ creation and destruction during vPort open/close.

Patch 6 extends the same GIC lifecycle management to the RDMA driver's EQ
allocation path.

Changes in v6:
- Rebased on net-next/main (v7.1-rc1)

Changes in v5:
- Rebased on net-next/main

Changes in v4:
- Rebased on net-next/main 7.0-rc4
- Patch 2: Use MANA_DEF_NUM_QUEUES instead of hardcoded 16 for
  max_num_queues clamping
- Patch 3: Track dyn_msix in GIC context instead of re-checking
  pci_msix_can_alloc_dyn() on each call; improved remove_irqs iteration
  to skip unallocated entries

Changes in v3:
- Rebased on net-next/main
- Patch 1: Added NULL check for mpc->eqs in mana_ib_create_qp_rss() to
  prevent NULL pointer dereference when RSS QP is created before a raw QP
  has configured the vport and allocated EQs

Changes in v2:
- Rebased on net-next/main (adapted to kzalloc_objs/kzalloc_obj macros,
  new GDMA_DRV_CAP_FLAG definitions)
- Patch 2: Fixed misleading comment for max_num_queues vs
  max_num_queues_vport in gdma.h
- Patch 3: Fixed spelling typo in gdma_main.c ("difference" -> "different")

Long Li (6):
  net: mana: Create separate EQs for each vPort
  net: mana: Query device capabilities and configure MSI-X sharing for
    EQs
  net: mana: Introduce GIC context with refcounting for interrupt
    management
  net: mana: Use GIC functions to allocate global EQs
  net: mana: Allocate interrupt context for each EQ when creating vPort
  RDMA/mana_ib: Allocate interrupt contexts on EQs

 drivers/infiniband/hw/mana/main.c             |  47 ++-
 drivers/infiniband/hw/mana/qp.c               |  16 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 307 +++++++++++++-----
 drivers/net/ethernet/microsoft/mana/mana_en.c | 163 ++++++----
 include/net/mana/gdma.h                       |  32 +-
 include/net/mana/mana.h                       |   7 +-
 6 files changed, 416 insertions(+), 156 deletions(-)

-- 
2.43.0

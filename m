Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 586842AD03;
	Wed,  4 Mar 2026 00:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582425; cv=none; b=OFsRKPQvsQCLwJswNtXJiSPLPjuZrWfs/gtq48IMakmt3ex5mi8gwP1KCXIv/ZfuoHM9C8gIY4aO33F3+CCd12PtOYrOvee/LrJav2x53qp/kdlQQRRkiDVSHcFUwsOVQ20IUNXyDEC8gLSEjfoqVamfpW9HrGZ4ocunpkwHyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582425; c=relaxed/simple;
	bh=wlHXxl94c3FVzCJgGlKQh8b5W5pdN7iksMq3/nW5ymI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cxq+kwBRfDYRGO/Gj3U89imG4J3GOfc1zN/gMdcFrIcnk/3+yUUOzsLMazR5XtQwQXU1vGW74i93+74MYLwemOwXHucDS5tyl7mp79hCma2MEiY+ls7vKnZ273zutP8hfuJ4JjmKwoMG435p03U3AIrMQwGwuvKdo7JJ9qhQiKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 0B3E020B6F02; Tue,  3 Mar 2026 16:00:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B3E020B6F02
From: Long Li <longli@microsoft.com>
To: "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Erick Archer <erick.archer@outlook.com>,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
Subject: [PATCH v2 net-next 0/6] net: mana: Per-vPort EQ and MSI-X interrupt management
Date: Tue,  3 Mar 2026 16:00:11 -0800
Message-ID: <20260304000017.333312-1-longli@microsoft.com>
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
and exports create/destroy functions for the RDMA driver.

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
allocation path and advertises the EQ_MSI_UNSHARE_MULTI_VPORT capability.

Tested on Azure VMs with 2, 3, and 4 NIC configurations:
- Both MSI sharing modes verified: mode 0 (dedicated) and mode 1 (shared)
- NIC up/down with clean VF data path switch on all interfaces
- Bulk NIC down/up (all interfaces simultaneously)
- iperf3 throughput: up to 181 Gbps (16 streams, Boost192)

Changes in v2:
- Rebased onto net-next/main
- Fixed spelling typo in patch 3 ("difference" -> "different")
- Moved HW_VPORT_LINK_AWARE define to numerical order in patch 6

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
 drivers/infiniband/hw/mana/qp.c               |   4 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 309 +++++++++++++-----
 drivers/net/ethernet/microsoft/mana/mana_en.c | 162 +++++----
 include/net/mana/gdma.h                       |  31 +-
 include/net/mana/mana.h                       |   7 +-
 6 files changed, 402 insertions(+), 158 deletions(-)

-- 
2.43.0


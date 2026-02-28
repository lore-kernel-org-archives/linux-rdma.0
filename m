Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362C5306496;
	Sat, 28 Feb 2026 02:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772244711; cv=none; b=He9xah17HqqmgnD2n3oloCaFlT7v9N/YEUf5AmJFzEIixWKBcKpOj7U9HNzILB65qrCBZY2/q1Z11powTgIiYHYTMgc85reCfMLeSGND+RG/GYhZlf4LGvGW4qAkgW7+g1PEsizvPVGtwcSo6EPpe6JsFZqm0KmVKB7K/fN1teU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772244711; c=relaxed/simple;
	bh=uUvD8+nYvhQhsga+shOqjDkaGO4xW0NmG36Y8ASpn5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NJ0261zGYv3SIxD9CUyP9AkZH0cEviALhgaoJ5zVk4J3jcbzGzL83DmYNfixsYBnf2R87YKw31L+2dwPqFZf/1TS262FkTop9k262ZvKoVfiaYUkOrJn3AhN8/gEykJtYvlIxkvpuG+RaMszDIgt6CH26ltOwDDuLeTk1i9JcWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id D181620B6F02; Fri, 27 Feb 2026 18:11:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D181620B6F02
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
Subject: [PATCH net-next 0/6] net: mana: Per-vPort EQ and MSI-X interrupt management
Date: Fri, 27 Feb 2026 18:11:38 -0800
Message-ID: <20260228021144.85054-1-longli@microsoft.com>
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
allocation path.

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
 drivers/net/ethernet/microsoft/mana/mana_en.c | 164 ++++++----
 include/net/mana/gdma.h                       |  29 +-
 include/net/mana/mana.h                       |   7 +-
 6 files changed, 402 insertions(+), 158 deletions(-)

-- 
2.43.0


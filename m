Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="jka9TeBm"
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FFD1A0;
	Mon,  4 Dec 2023 15:03:09 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1004)
	id 5EBC020B74C0; Mon,  4 Dec 2023 15:03:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5EBC020B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
	s=default; t=1701730988;
	bh=I8O/ezinzdbGIZL/wPkHY+k7KiRI6p+bTfXcw0Ub+Hk=;
	h=From:To:Cc:Subject:Date:From;
	b=jka9TeBmrelNx7fWJ4mHP576v6ROU1wmRerQ2dzjXOQdHMLHLmUTCVfzu4Nke0Rz2
	 f5Z8rlN9fxnICtfwXxN+ZKjjZiFbbyGXSVj7Cav0Pd7Si6fEWZIoVbDO2xVGI3gRz7
	 k5xkM5pzwJKDhybeAIs8deOc4QiSc7Fl6Wt0npz8=
From: longli@linuxonhyperv.com
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Long Li <longli@microsoft.com>
Subject: [Patch v2 0/3] Register with RDMA SOC interface and support for CQ
Date: Mon,  4 Dec 2023 15:02:56 -0800
Message-Id: <1701730979-1148-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

From: Long Li <longli@microsoft.com>

This patchset add support for registering a RDMA device with SoC for
support of querying device capabilities, upcoming RC queue pairs and
CQ interrupts.

This patchset is partially based on Ajay Sharma's work:
https://lore.kernel.org/netdev/1697494322-26814-1-git-send-email-sharmaajay@linuxonhyperv.com

Changes in v2:
Dropped the patches to create EQs for RC QP. They will be implemented with
RC patches.

Long Li (3):
  RDMA/mana_ib: register RDMA device with GDMA
  RDMA/mana_ib: query device capabilities
  RDMA/mana_ib: Add CQ interrupt support for RAW QP

 drivers/infiniband/hw/mana/cq.c               | 34 ++++++-
 drivers/infiniband/hw/mana/device.c           | 31 +++++--
 drivers/infiniband/hw/mana/main.c             | 69 ++++++++++----
 drivers/infiniband/hw/mana/mana_ib.h          | 53 +++++++++++
 drivers/infiniband/hw/mana/qp.c               | 89 ++++++++++++++++---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  5 ++
 include/net/mana/gdma.h                       |  5 ++
 7 files changed, 252 insertions(+), 34 deletions(-)

-- 
2.25.1


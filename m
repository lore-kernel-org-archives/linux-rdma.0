Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387274AA1CD;
	Thu, 24 Sep 2026 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271087; cv=none; b=iYRN/d5O51PuQ4QHAlvAa4249busy5JXjux2ypdtxPJpVY2+B7iyrq0WrDrvzzBNUnsbgXq9N0nQrIrT2A7XmlujMZ4L5/UQBEa/B5NQ7M6zyCvEz0O3gGi1XdPhkKiLijtIoOgF+8kGQgUDXCm5+6URefbOSsGRWK0Yf6kGvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271087; c=relaxed/simple;
	bh=9n3d9RPjx63gyvP/MxGCnZNS6Xgi+vkKKx2xFkXhSBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DcjGzLDC1oqzWsg7Up3pRh61LKgELKWlJ/S6T8BtGZa/zb60OqzpU5GepVETHCOcukhc0Uv01qKr3s4jnkWjFSk4lWyNduR+nLjk9Kqren+xJnpAfVBnbNYSII7V6BoK5Kz1xjrifYLRHUax9id0aM1/aWr7EZK28Mq2HBsSG/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cLFT/ZR4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cLFT/ZR4"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.38])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5B4B320B7167;
	Thu, 24 Sep 2026 10:30:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B4B320B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790271036;
	bh=DSqMVA3ep4LNU62i5WksiRt76ZGPG4kkSp1Jt+5qCWY=;
	h=From:To:Cc:Subject:Date:From;
	b=cLFT/ZR4NYqGWmTZKw3ueF/zCdb/SmaF01+RmEB1KNu/3Nbi0QcQ1LJIf7cFw9Tec
	 GMbYVZIoV0h2XCW7o6m8lJRigiCpTB5eCtEF+tnQPE+ClE+ChEFZbFjbqwefyYThwe
	 cVziDnUO3c+vJ2Z1UOYypL02YzYkJRYQ++Tx1gJ8=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com
Cc: horms@kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	nipun.gupta@amd.com,
	nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com
Subject: [PATCH net-next 0/4] net: mana: Add support for the CDX bus
Date: Thu, 24 Sep 2026 17:30:50 +0000
Message-ID: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds CDX bus support to the MANA driver.

The shared GDMA and Ethernet code currently builds together with the PCI
transport. To add another bus without duplicating the driver or adding
configuration checks throughout the shared code, this series separates the
bus-specific operations and builds each transport independently.

Patch 1 introduces gdma_bus_ops and routes bus-specific interrupt, reset,
service, and setup operations through it.

Patch 2 moves the PCI-specific code from gdma_main.c into gdma_pci.c
without changing PCI behavior.

Patch 3 builds the shared code as gdma_core.ko and the PCI transport as
mana.ko. The PCI module keeps its existing name, device table, and
mana.eth/mana.rdma auxiliary-device identities.

Patch 4 adds the CDX transport as mana_cdx.ko for device ID 0x00C2.

Manish Awasthi (4):
  net: mana: Introduce gdma_bus_ops for bus-specific operations
  net: mana: Move PCI transport code into gdma_pci.c
  net: mana: Build the PCI transport as a separate module
  net: mana: Add support for CDX device ID 0x00C2

 drivers/net/ethernet/microsoft/Kconfig        |   26 +-
 drivers/net/ethernet/microsoft/Makefile       |    2 +-
 drivers/net/ethernet/microsoft/mana/Makefile  |    9 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |  340 ++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   | 1063 +++--------------
 .../net/ethernet/microsoft/mana/gdma_pci.c    |  917 ++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c |   18 +-
 include/net/mana/gdma.h                       |  106 +-
 8 files changed, 1552 insertions(+), 929 deletions(-)
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_cdx.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_pci.c


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.54.0

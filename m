Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3397A3B4432;
	Fri,  7 Aug 2026 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786136436; cv=none; b=DwVnnnbPXPhCuQ5Yj5U7f74DmE0K7x5Tjb99V/0IQZ0UHIMOQ9tXzj64zPRIcxJvhIl2344+vzTzQMm43clrWSscVgWIghjV/OHMpbPOnZKIVpkLi+QY3ALZENSaZfKp5H+sICm31ZBFPiega1GPEDiYQFrrZ2T+Fh/Qk6+10pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786136436; c=relaxed/simple;
	bh=IU/wOHAdOnn5q0LYcAHP4MyCAoqdgeUod1C2cMCd/Y4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nCYxp1KiG9ZghrbLnSkzbuH3rnYfpIzIeeRI/Kli6sHVcACUg1L4+0HWCr9FKSKx7tHX+5NJ76iJKxSB+snL0yZ1ZwLQtr5m9DufXDCkAiXeKZWx+/uIde0I6i3bJptR8vdUJDvElgHPQWCHA5JPKhKe/FgQzUMs4zt58F9ED5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=R5uBYPU9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="R5uBYPU9"
Received: by linux.microsoft.com (Postfix, from userid 1231)
	id 2594A20B710C; Fri,  7 Aug 2026 14:00:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2594A20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786136407;
	bh=JuDkUjWqdq5JFucVLsaZYr2yfv0pLbVlmq39QqXO7xY=;
	h=From:To:Subject:Date:From;
	b=R5uBYPU94YZTZ3sjspm4sx81BNOP3HxGjJtt32rhTl4H33baCQmJrzkI492CKKjDW
	 JW1TC9/IcjIsRDAESxCLi/gOGJdkp5pylD+i4FjyPQnufGTyNCaNz8oexHhWRZBl/9
	 NJ0evOMkLzOxSdliLmxAaOSiKrYb0MtWGIvBU+EY=
From: Aditya Garg <gargaditya@linux.microsoft.com>
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
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	shradhagupta@linux.microsoft.com,
	kees@kernel.org,
	sgeorgejohn@microsoft.com,
	ssengar@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	gargaditya@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/2] net: mana: Avoid DMA queue allocation failure under memory fragmentation
Date: Fri,  7 Aug 2026 13:56:34 -0700
Message-ID: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MANA driver can fail to bring up its queues on systems with high
memory utilization because every GDMA queue ring is allocated as a
single dma_alloc_coherent() of the whole power-of-2 ring size. Under
memory fragmentation these high-order allocations may fail, preventing
the driver from creating queues when opening the interface, after a VF
reset, or when reconfiguring channels, ring parameters or MTU.

Per-queue sizes that are problematic, with depth and size given as
(default, max) over the ethtool ring settings:

  ring                  entry  depth          size
  ------------------------------------------------------------
  TX completion queue   64 B   (256, 16384)   (16 KB, 1024 KB)
  TX send queue         32 B   (256, 16384)   ( 8 KB,  512 KB)
  RX completion queue   64 B   (1024, 8192)   (64 KB,  512 KB)
  RX receive queue      32 B   (1024, 8192)   (32 KB,  256 KB)
  event queue           16 B   2048 (fixed)   32 KB

This series addresses the issue by:
  1. Routing all CPU-side ring access through mana_gd_ring_ptr() and
     mana_gd_ring_contig_avail(). On a contiguous ring these reduce to
     simple arithmetic, so this patch is a pure refactor.
  2. Falling back in mana_gd_alloc_memory() to a vector of scattered
     order-0 coherent pages when the contiguous allocation fails. The
     device sees the same page-list format either way, as
     mana_gd_create_dma_region() already describes a ring as a list of
     MANA_PAGE_SIZE addresses. The HW channel stays contiguous, as
     advertising a scattered page list needs the HW channel itself.

Throughput testing confirms no regression. Since the fallback only
triggers under memory fragmentation, the scattered-page path was enabled
unconditionally for all eligible GDMA queue rings during testing (iperf3,
Gbit/s):

                 Baseline    Patched     Patched
  Connections   Contiguous  Contiguous  Scattered
  -----------------------------------------------
  1                  46.1        46.2       46.1
  16                 182         182        182
  32                 182         182        182
  64                 182         182        182

Aditya Garg (2):
  net: mana: Route ring-buffer access through offset-based helpers
  net: mana: Fall back to scattered pages for GDMA queues

 .../net/ethernet/microsoft/mana/gdma_main.c   | 219 +++++++++++++++---
 .../net/ethernet/microsoft/mana/hw_channel.c  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   3 +
 include/net/mana/gdma.h                       |  19 +-
 4 files changed, 205 insertions(+), 38 deletions(-)

-- 
2.43.0


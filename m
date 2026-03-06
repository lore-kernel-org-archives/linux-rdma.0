Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2D82836AF
	for <linux-rdma@vger.kernel.org>; Fri,  6 Mar 2026 08:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772785548; cv=none; b=JYVGVwHNBfcBexATp/ipPVPFWJL6FWGJvzUj9A2mahPvaVscaIHU+mIP0dnKcRe+cbK8FYmIfsSsdp2bBIJDew1kxsRgtPkNs1xsFlZ5bb3Xc08NY4mHij55t2wnjKFxklc30FCRbS1ix3GUxlkPNn3ltaRJhYgqhkc8CXoi3EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772785548; c=relaxed/simple;
	bh=EJ5zFKKbmNrV6OFgayMyLEx3+LUaBAsVIk6ZHwA4nTg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dUXiST9/FigZiTvgEeUSGognU9QUzyEuxRCUPGIWBVFaC8OXm9Sv3IsKO0qCNHzyXnbG1mRHqZA+v4D/OwaPiPnppTwF+2L0+Pkmku6hHVip7MrxF5e9IzlLHZaUJFOOEH74n3qHGesM2x2AL1pmEjg9VVqZfq8FZTXPjFG/j1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X0vivRAu; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X0vivRAu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772785544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wenHDtnE2fTbbdQXawz5GsD7QCtK7EsMUhkDCPsNMAc=;
	b=X0vivRAur9bgO61V33my/HwQtrysi3vHzGvergnHYIpg62BpRIlNHhr9o/6Rnh+OcXJjr7
	0izESutrSs10c7+Ct3knzrLQHFNFGvLnPcgWSegAki3w33wXwapgfERkNCempv9oXWpE4w
	5F8E4+bZRTcUMH1iifREC3VCpu6WbD4=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/4] RDMA/rxe: Add the support that rxe can work in net namespace
Date: Fri,  6 Mar 2026 00:24:48 -0800
Message-ID: <20260306082452.1822-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently rxe does not work correctly in network namespaces.

When the rdma_rxe module is loaded, a UDP socket listening on port
4791 is created in init_net. When users run:

    ip link add ... type rxe

inside another network namespace, the RXE RDMA link is created but it
cannot function properly because the underlying UDP socket belongs to
init_net. Other network namespaces cannot use that socket.

To address this issue, this series introduces net namespace support
for rxe and moves socket management to be per network namespace.

The series first introduces per-net namespace management for the IPv4
and IPv6 sockets used by rxe. The sockets are created when the network
namespace becomes active and are released when the namespace is
destroyed.

Based on this infrastructure, rxe RDMA links are then created and
destroyed within each network namespace. This ensures that both the
UDP sockets and RDMA links are correctly scoped to the namespace in
which they are used.

With these changes, rxe RDMA links can be created and used both in
init_net and in other network namespaces, and resources are properly
cleaned up during namespace teardown.

The series also includes a selftest to verify RXE functionality in
network namespaces.

Zhu Yanjun (4):
  RDMA/rxe: Add testcase for net namespace rxe
  RDMA/nldev: Add dellink function pointer
  RDMA/rxe: Add net namespace support for IPv4/IPv6 sockets
  RDMA/rxe: Support RDMA link creation and destruction per net namespace

 MAINTAINERS                                   |   1 +
 drivers/infiniband/core/nldev.c               |   6 +
 drivers/infiniband/sw/rxe/Makefile            |   3 +-
 drivers/infiniband/sw/rxe/rxe.c               |  41 ++++-
 drivers/infiniband/sw/rxe/rxe_net.c           | 122 ++++++++++----
 drivers/infiniband/sw/rxe/rxe_net.h           |   9 +-
 drivers/infiniband/sw/rxe/rxe_ns.c            | 156 ++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_ns.h            |  17 ++
 include/rdma/rdma_netlink.h                   |   2 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/rdma/Makefile         |   5 +
 tools/testing/selftests/rdma/config           |   3 +
 .../selftests/rdma/rping_between_netns.sh     |  57 +++++++
 tools/testing/selftests/rdma/rxe_ipv6.sh      |  47 ++++++
 .../testing/selftests/rdma/socket_with_rxe.sh |  64 +++++++
 15 files changed, 493 insertions(+), 41 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h
 create mode 100644 tools/testing/selftests/rdma/Makefile
 create mode 100644 tools/testing/selftests/rdma/config
 create mode 100755 tools/testing/selftests/rdma/rping_between_netns.sh
 create mode 100755 tools/testing/selftests/rdma/rxe_ipv6.sh
 create mode 100755 tools/testing/selftests/rdma/socket_with_rxe.sh

-- 
2.52.0


Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814D1D6195
	for <linux-rdma@vger.kernel.org>; Fri, 13 Mar 2026 02:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773369080; cv=none; b=IEfl6ax9zx+1BNJGOSlpR0bp+VKzzn9C+O1b0wrOoMnf/Gyj0zL9grFK0GVteRrcA2cFwM1T44TFBcPXHBqMTGrwE6liuT1FFNS3h6cqkq2UIgylpcT1284B+dWE7fms1QcjILzsxtSGcR8Vh+uUOD6GQY++Otc7nIv2srI1e54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773369080; c=relaxed/simple;
	bh=T/arHJtCiXgkZIiXroQwIDaD7oUAecKRKTDTYxRCbDU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=B1/pal7Zf9Imu/OuJm5LMB+UMZJZ4lEUCDcUMcd7YiP1hqOrcgi8ucVIYug3ulKIBmE4ja9hV2LkPCUdqCr8k03wUZYQzAplAw42Ni9vybswqJvLr3ZI5+qAVP4tgW7vnLe2G9e5QubcMAMT/Ajo6Jwlia0zNUIhSM2WwklrKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SWxc8LOU; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SWxc8LOU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773369076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HP0IQ82rRcJ748p0Ao6fhqXnx5Qzg9WsCdy3eGHs70Y=;
	b=SWxc8LOUmdZA32XLMgGwUmNjpz5pXkwhuQHPd+35F0zr4UvDfQMTn9BeECnh+OBgzmYAe4
	NpmXwlGeHIAeh/6NE9xh1Mb5ykee73+uTgcPCW6degQgW9OY7AqmXO7PScyKwKJqSdgYHK
	WUqndSipnCAmH8x36emxG2qYCmOIbWE=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v7 0/4] RDMA/rxe: Add the support that rxe can work in net namespace
Date: Thu, 12 Mar 2026 19:30:54 -0700
Message-ID: <20260313023058.13020-1-yanjun.zhu@linux.dev>
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

"
# make -C tools/testing/selftests/ TARGETS=rdma run_tests
make: Entering directory 'tools/testing/selftests'
make[1]: Nothing to be done for 'all'.
TAP version 13
1..4
# timeout set to 45
# selftests: rdma: rxe_rping_between_netns.sh
# client DISCONNECT EVENT...
ok 1 selftests: rdma: rxe_rping_between_netns.sh
# timeout set to 45
# selftests: rdma: rxe_ipv6.sh
ok 2 selftests: rdma: rxe_ipv6.sh
# timeout set to 45
# selftests: rdma: rxe_socket_with_netns.sh
ok 3 selftests: rdma: rxe_socket_with_netns.sh
# timeout set to 45
# selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
ok 4 selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
make: Leaving directory 'tools/testing/selftests'
"

V6 -> V7: Add selftests to INFINIBAND DRIVER;
		Move the Macro to the beginning of the file;
		Add comments about dellink;
V5 -> V6: Fix some problems based on Leon's advice
V4 -> V5: Fix rcu warnings
V3 -> V4: Squash all the changes about rxe_ns.c/h into one commit.
V2 -> V3: Fix build warnings
V1 -> V2: Fix the problems based on David Ahern.


Zhu Yanjun (4):
  RDMA/nldev: Add dellink function pointer
  RDMA/rxe: Add net namespace support for IPv4/IPv6 sockets
  RDMA/rxe: Support RDMA link creation and destruction per net namespace
  RDMA/rxe: Add testcase for net namespace rxe

 MAINTAINERS                                   |   2 +
 drivers/infiniband/core/nldev.c               |  12 ++
 drivers/infiniband/sw/rxe/Makefile            |   3 +-
 drivers/infiniband/sw/rxe/rxe.c               |  38 ++++-
 drivers/infiniband/sw/rxe/rxe_net.c           | 144 +++++++++++++-----
 drivers/infiniband/sw/rxe/rxe_net.h           |   9 +-
 drivers/infiniband/sw/rxe/rxe_ns.c            | 124 +++++++++++++++
 drivers/infiniband/sw/rxe/rxe_ns.h            |  26 ++++
 include/rdma/rdma_netlink.h                   |   2 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/rdma/Makefile         |   7 +
 tools/testing/selftests/rdma/config           |   3 +
 tools/testing/selftests/rdma/rxe_ipv6.sh      |  63 ++++++++
 .../selftests/rdma/rxe_rping_between_netns.sh |  85 +++++++++++
 .../selftests/rdma/rxe_socket_with_netns.sh   |  76 +++++++++
 .../rdma/rxe_test_NETDEV_UNREGISTER.sh        |  63 ++++++++
 16 files changed, 612 insertions(+), 46 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h
 create mode 100644 tools/testing/selftests/rdma/Makefile
 create mode 100644 tools/testing/selftests/rdma/config
 create mode 100755 tools/testing/selftests/rdma/rxe_ipv6.sh
 create mode 100755 tools/testing/selftests/rdma/rxe_rping_between_netns.sh
 create mode 100755 tools/testing/selftests/rdma/rxe_socket_with_netns.sh
 create mode 100755 tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh

-- 
2.52.0


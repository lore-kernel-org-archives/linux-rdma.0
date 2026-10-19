Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445925;
	b=BYRmHORzE9rwa5tFP2SoUzxgYKD2MlshyqZCHERB4xqkUDMVqZNsK0n5yJJrQBeWvPbQ
	 VcSdvIRBWvwmrcwFfo0miekqM8eDpNlRIEtpvA9pS4oWFPKk/E3212zqK+/KcmjcahH4M
	 6o3Q2IYLrIwJUTZtPk0I54dokeFD9w7eEH8nozwIwUY3ZnaDmwIVJqCU0S4qurvZqeioy
	 DR6OQr3a9P7fZKKFcnKOylWdorumB/+hvAK71YjR7rXm0tQj5U7l8pOmPfph2u8vQcZnk
	 iEccVNUKmHcMlw0+juTI4lyHGIZRrz95tj5tNM7/pN0Tw8b60XvhFA25aAZQFn5YfBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445925;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LfWSuYKCth8K/6tVVIdahT1UVozh1NXcJ2UWGJ4bf7Q=;
	b=PBBtOfekql3CBdZMWDXSsjjjiCGhUows9sIYjkGai1tReuV5SbdSJ94LZDkMPNOuCxhU
	 0bCrDqrRz20rUzRLE4pxQJQZJ5fE7GbDW9bWpmrUvzT3xGTTG+msPRHDDAXgM9Ok2ju2T
	 TBbj8BBmqYp8+Px9aMXcp5IoOqkpelobQO+v2+AasLHpOMwSTjV2TQvorMKCzxRu4QVgQ
	 Oy73vqAfJZFgzHlGBhekpJU84n7HgPYY8gk+y/wDEIn9tJyKI2tEgCZyeocrRHB7yPpb5
	 6tP+87OElE2UcnSUGBH1zpUeG9nIYG2cVsTKYmsoJca060BqlPlB/7etjDnevGLlQ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aEMI6tHZ;
	arc=none smtp.remote-ip=95.215.58.209
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B22606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 21:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37B22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aEMI6tHZ
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pdm4vPb67Yst7tFmF7qxL6HpuVTm0tl2rIhOUO0+ORI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792445916; v=1; x=1793050716;
 b=aEMI6tHZdJRSaYOn45foOGwsc8iNulKBAa264AKAlkoSYyqnchAOjel0xDTwVTm8Tq88lDux
 doBuh/7amkX+LYo+D5P0wuOsILTnqs/xJEjCaF/vdZh5y6g2/BmkDdQ1m9+ko7v2fm3Zbkriroe
 n62UG3qZHwf+bvXq6EZRboLc=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5dcd77049f212692;
	Mon, 19 Oct 2026 21:38:36 +0000
X-Mizu-Trace-ID: 5dcd77049f212692
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v2 0/2] selftests/rdma: Add an eBPF-based testcase using netkit for RXE
Date: Mon, 19 Oct 2026 14:38:19 -0700
Message-ID: <20261019213821.44842-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new self-test case to verify RXE (Soft-RoCE) traffic using
netkit virtual interfaces and an eBPF tcx ingress program to dump
and parse RDMA transport headers (BTH, etc.).

The test results:

# make -C tools/testing/selftests/ TARGETS=rdma run_tests
make: Entering directory '/root/linux/tools/testing/selftests'
clang -g -O2 -target bpf -D__TARGET_ARCH_x86 -I../../../../usr/include -I../../../../include/uapi -I../bpf -I/root/linux/tools/testing/selftests/rdma -c rxe_pkg_kernel_dump.c -o /root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.o
bpftool gen skeleton /root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.o > /root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel.skel.h
gcc -D_GNU_SOURCE= -I/root/linux/tools/testing/selftests/../../../tools/testing/selftests  -g -Wall -I../../../../usr/include -I../../../../include/uapi -I../bpf -I/root/linux/tools/testing/selftests/rdma rxe_pkg_user_dump.c  -lbpf -lelf -lz -o /root/linux/tools/testing/selftests/rdma/rxe_netkit_dump
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
# timeout set to 45
# selftests: rdma: rxe_sent_rcvd_bytes.sh
# server DISCONNECT EVENT...
# wait for RDMA_READ_ADV state 10
# client DISCONNECT EVENT...
ok 5 selftests: rdma: rxe_sent_rcvd_bytes.sh
# timeout set to 45
# selftests: rdma: rxe_netns_names.sh
# 1..0 # SKIP rdma netns exclusive mode is not supported
ok 6 selftests: rdma: rxe_netns_names.sh # SKIP
# timeout set to 45
# selftests: rdma: rxe_pkg_netkit.sh
# server DISCONNECT EVENT...
# wait for RDMA_READ_ADV state 10
# ./rxe_pkg_netkit.sh: line 28:  9866 Killed                  "$CUR_WD/rxe_netkit_dump"
ok 7 selftests: rdma: rxe_pkg_netkit.sh
make: Leaving directory '/root/linux/tools/testing/selftests'

---
V1 - > V2: Fix problems from sashiko
---

Zhu Yanjun (2):
  selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE
  selftests/rdma: Add netkit-based automated test script for RXE

 tools/testing/selftests/rdma/Makefile         |   23 +-
 tools/testing/selftests/rdma/config           |    3 +
 .../selftests/rdma/rxe_pkg_kernel_dump.c      |   62 +
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  |   63 +
 .../selftests/rdma/rxe_pkg_user_dump.c        | 1275 +++++++++++++++++
 5 files changed, 1425 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_user_dump.c

-- 
2.54.0


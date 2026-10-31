Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793467840;
	b=1iVBxAMO2d/hSCgWN4f+W5tlGiGDCDS4xXg3TxIACAQMZ6Nz7xYmF/oCt3UTbEMucreq
	 hhrQlfxWrCMyfFrXKTCnXNpovspyP8zKsUJikuahlIfNOzhd/zaBQLJXMKy7RTar1Y0o7
	 RcJPPfTr2ls9nM+QENC+UOforBq/2FBfywo8G4aGCxZo6CsBPIPjLnKOeZ0pEk4LoehGK
	 4Fj0wAMvLR8DOIXwjEZzCojiRGLGsOq2ypIgtVnnyy/PGFsmqiLrXjf62RxhRz8zsannU
	 1xq2xv38hmw5jpgG3O4jWIEDfF0W+hElVEiF1Si2l3EQ9sku6aqP//2sumQdSfZ0W2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793467840;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ZyAMpffqQzs5u1P9uNHMv8kr9vuC9ICPu09YY6ag56A=;
	b=rI79RJXmSBL6G8eI9a4TnBVH/67296mnj0IbgKKjneGshUlaUYTmZnedUMPOXUHXffRU
	 uugLF8rs4XLRFHJG3WMxeKYkGGvlDo79yiV88IW3xbakZXgUJktai2im85QMCRWr8uzNy
	 LPtUhGkG5KyflLMKteeuB+cHWHwIHhVRhSurFHu6rit60ueknSRkVWOM2IpPnoBaAPM3C
	 plpm2NZG7HDpYZPkq5TvM6TSKN9zwws7I2/Y5RHM+W3yIrB8NC4pOQF1W9f0KaSFBpoui
	 RfqzKzfcqG+ZVSvSDZlGKZxskhLt58z/V1DMWgpGXOmAaQ/Bfsow9TUdWmk6yK17d6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IYkmebZF;
	arc=none smtp.remote-ip=95.215.58.62
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C7606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 17:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F16C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IYkmebZF
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+9xexL48jW9DDESnQk4SKubjwBBwQJtDClEQv8Gt++A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793467836; v=1; x=1794072636;
 b=IYkmebZF8kP7pDTwO1ZQhDx83qjl0hr/WxWozwSzKoW9ICA8qBg+8VvKVqKzrMgeOD6U5pGs
 RDOas/RXFf5rFlRFxU1bpe125IAGnBaAbl5th0ywzbb5fiNDROnS1+yKhXUReuOyhPmjlEi19PT
 TidvypWRkkiDytF+o5zs71JE=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0e049a2a3887f082;
	Sat, 31 Oct 2026 17:30:28 +0000
X-Mizu-Trace-ID: 0e049a2a3887f082
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v5 0/2] selftests/rdma: Add an eBPF-based testcase using netkit for RXE
Date: Sat, 31 Oct 2026 10:30:15 -0700
Message-ID: <20261031173017.20691-1-yanjun.zhu@linux.dev>
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
V4 - > V5: Fix err and length problems
V3 - > V4: Fix problems in user space app
V2 - > V3: Fix problems in user space application
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


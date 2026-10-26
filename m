Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051574;
	b=SkP8XpZa2+7R+ySGVjpoU7x9QxVX/MOYCU7WNOfE5/Fiwy3tXBk9Ao6menVnupscH85T
	 SofnqKPMa2DM8Ns9bxvPlyrrV7+KUaAhfHxHlTd9jt1VKJ36mHNfZcPsJcwoykW7hAiNc
	 QcotGpxftXPPDFw9GB+59pLKY0vYvkaYtlAO1aiioFFiTMfk+1Z2e+IT53LBJj0aUTbQ9
	 /P/MsLasX6Tp9KuqojdFbIP3LgcsZ8AJ+aa31nu+i03vYokBVBTrtw/o8PfhEISVKxRuj
	 7Adr+BarN7DW7LXOlJKc/3t5yktdcAPPDmkHu3o1gUXaYhDiXSpkUzVMmpAztuqX+lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051574;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S25b244wTaMqVJjFfln8keXH6fPLP/cirrhFiRLHhew=;
	b=22aaJJCx8MYMmxrUY7rq3skiNurZ8t+1Mke6uxrffzD/QMMV5BqZ7lJfIBgfX/qMGiDu
	 ZXyWWjUDY820bnibSeEVzJ6r4ksMuGQAbdn2rxxXMbtVP4KDuGzMdD03OzPRHf//HDt1V
	 NZZF6iYaHgqqh0XaCr8RwzhcSlMQkA4UFmND4jcFoqZfBMRcVnMaSol9xGF1mMMnTtNtA
	 F/x994Gef/Lnh6KKaodaGWhLyfd+P2P0bNjv9zZ8ExQ3Leoq+pN2guBDlKucsqUnfQWTJ
	 hnOqYUspnc0BxRQrjvpsUVp+rpnN+4shm23NVGvRPup0XqkT3qTvlXGUVDlQ/GxmF0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="eZIU/Wcp";
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8329360A383B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 21:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8329360A383B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eZIU/Wcp
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LVUzn4xBpWP3HV1084cxZXPEcEqRbTp4ZtSvD+kaGOk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793051571; v=1; x=1793656371;
 b=eZIU/Wcp8IfRCktVUwJSLfW7SUUgdsNW4D978XQVeMPCD2QLQW+TAi2vP/4W1mnKYU8QhXJQ
 xdIm8MTwWPw7gvUIo65OgSHx3wH+wW3sgXPl0E/x+8U7Qstk2YXXYpqaKLqTegCmHFm8VP8Ww3m
 EUMwyaXiRLyBsI4vBt3efhJg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cadc261c74d7667d;
	Mon, 26 Oct 2026 21:52:51 +0000
X-Mizu-Trace-ID: cadc261c74d7667d
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v4 0/2] selftests/rdma: Add an eBPF-based testcase using netkit for RXE
Date: Mon, 26 Oct 2026 14:52:34 -0700
Message-ID: <20261026215236.60054-1-yanjun.zhu@linux.dev>
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


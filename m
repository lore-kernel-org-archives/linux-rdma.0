Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445931;
	b=JUFzQtdWrvp9s/5sFY2bpQZPRx/W77RczXRCwfv1EZGMDyH3FXxiynFOVqkpX+dGHED7
	 csPRT6aA6gjCTCLe9f0KqrMizLd7jV92mhqwLZ+7SoQgss1w4l8uF4x29p7NdzXTxKlst
	 lB+KshdOoa1ak6ui6Onojo7obs9n65GfX/DoDc8hgb+tNrrKK9Lf3fPwD83fSyf/mvME9
	 ffUS30dRv9UghYDmOmxDxBB/HmQT5oSaTsxs7gzRS3MFjudiW8GUOzFDIZnEiNW4rb1Qf
	 Q6yp2GZm0UQ/TTR8pL27iJq+GLlDSlcqHMwSkF2RgmajVZNDQNwXmJF2qg+HJzFoTGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445931;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lMNj17CX/Hn7DyYFqL5TY7waJXxPfh0sqycM3l/wxlA=;
	b=a44zOQ38rSzZDdFhLXIbbxuc8hBGhC5r7Gil9gr/rRENSzr3oWueDPHBtratjREekM5+
	 jvLcq4RRrYc4pdCOaH6FPEIu9XBPTuTtRFyrvTqrr+RUWTmRNrl3fYtXp+jA9u38hYeTx
	 h0biKs5yp4b5Yjp9hEWUHdBlvv3gFEwqOmbMG2dTLOTuuhwRvbQrGNsh1nHbfr8aZuYXw
	 skKz1VlhneqqPcRwijEcPFeM9viEXPFXvR/5PQq1X9I121wq/ZydM2KNEhCHHdu/JqlFW
	 rKzUAKJ/Uwnx3UkNMpmJquql8zML6oTzN6mZT2hUZfXGk4MB8SrsDDoHTQr3bwPYErg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FPEF5iZN;
	arc=none smtp.remote-ip=95.215.58.216
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03760A2615
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 21:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D03760A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FPEF5iZN
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3WsDz3kl6c8EJ1fanXi87kkMifM8tX+/OTLI1R7HEDQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792445929; v=1; x=1793050729;
 b=FPEF5iZNH9gdeC42FAvktU2HZf9z/D+Smznl4QSAVjjQO50CgIOimCL+vcUP6pFO0QaJkFQN
 /rYDUjI2MX8IvgPWdL+gB5hmPlXbEfWwIsdLuZ6Ua/U2lRQnVPDFaFEtkI8lgdsXdX4as916xD0
 6YD39IhG780IjbjdtwjDrzh8=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3ecf33f37604901c;
	Mon, 19 Oct 2026 21:38:49 +0000
X-Mizu-Trace-ID: 3ecf33f37604901c
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v2 2/2] selftests/rdma: Add netkit-based automated test script for RXE
Date: Mon, 19 Oct 2026 14:38:21 -0700
Message-ID: <20261019213821.44842-3-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019213821.44842-1-yanjun.zhu@linux.dev>
References: <20261019213821.44842-1-yanjun.zhu@linux.dev>
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

Add a shell script to automate functional and tracing tests for the
Soft-RoCE (RXE) driver over netkit network interfaces. The script creates
an isolated network namespace, sets up a netkit link pair (nk0/nk1),
attaches RXE links, and runs an rping client/server verification test
along with kernel tracing output collection.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh

diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
new file mode 100755
index 000000000000..a876bd9d57ef
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
@@ -0,0 +1,83 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
+if [ "$(id -u)" -ne 0 ]; then
+    echo "SKIP: This test must be run as root"
+    exit 4
+fi
+
+for cmd in ip rdma rping; do
+    if ! command -v "$cmd" >/dev/null 2>&1; then
+        echo "SKIP: Required tool '$cmd' not found"
+        exit 4
+    fi
+done
+
+if ! modprobe -n netkit >/dev/null 2>&1 || ! modprobe -n rdma_rxe >/dev/null 2>&1; then
+    echo "SKIP: Required kernel modules (netkit or rdma_rxe) are not available"
+    exit 4
+fi
+
+# exec > /dev/null
+
+set -e
+
+CUR_WD="$(dirname "$0")"
+[ "$CUR_WD" = "." ] && CUR_WD="$(pwd)"
+
+cleanup() {
+    set +e
+    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
+    unset DUMP_PID
+
+    rdma link del rxe1 2>/dev/null
+    ip link del nk0 2>/dev/null
+    ip netns delete ns0 2>/dev/null
+
+    rm -f "$CUR_WD/rxe_netkit_dump" "$CUR_WD/rxe_pkg_kernel_dump.o" "$CUR_WD/rxe_pkg_kernel.skel.h"
+}
+
+trap cleanup EXIT INT TERM
+
+# Clear tracing buffer
+echo > /sys/kernel/debug/tracing/trace
+
+# Create network namespace and netkit peer links
+ip netns add ns0
+ip link add nk0 type netkit mode l2 peer name nk1
+ip link set nk0 up
+ip link set nk1 up
+
+# Configure namespace interface
+ip link set nk1 netns ns0
+ip netns exec ns0 ip addr add 10.0.0.1/24 dev nk1
+ip netns exec ns0 ip link set nk1 up
+
+# Configure host interface
+ip addr add 10.0.0.2/24 dev nk0
+
+# Start dump utility in background
+"$CUR_WD/rxe_netkit_dump" &
+DUMP_PID=$!
+
+# Add RXE links over netkit devices
+ip netns exec ns0 rdma link add rxe0 type rxe netdev nk1
+rdma link add rxe1 type rxe netdev nk0
+
+# Start rping server in namespace
+ip netns exec ns0 rping -s -a 10.0.0.1 -C 3 &
+
+# Add wait time
+sleep 1
+
+# Run rping client on host
+rping -c -a 10.0.0.1 -C 3
+
+# Tear down RDMA links and netkit devices
+ip netns exec ns0 rdma link del rxe0
+rdma link del rxe1
+ip link del nk0
+ip netns delete ns0
+
+# Display kernel trace output
+cat /sys/kernel/debug/tracing/trace
-- 
2.54.0


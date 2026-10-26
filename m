Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051597;
	b=KXmDQO5MM7AGcDhEgG9CawDbgABk5mNgUFg+Ge90+ew0BVvBZCSMQWZHrfAdK1eDPVtg
	 ghoPWKLeERAvTiuS7xBlbqZMSX7YNJX74yn4IbpFNLnDCA6g8X3gcIxxEIZWPb0PmaFhk
	 RYRXycgIqWIrlyIgzyM2jCAg0IAsrkbq3UUPiEYdhDJquR9iiRs2AdFErA74SrCH4i2YK
	 Va3www+hHMxjVuBBzDFzXNwikd0VcdRzFKyDPAzk1H0sMSVAUTjqVYClLZouBYoJ+slmR
	 FWgwyBcfBdOY1yL2Gq+rw2MrtZvNV2mJ0au8iA4hdPpSPsVpG087AJPfAIN0facoIVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051597;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iXNjFw3AXuPpgBzB2dIpW73+ZJUcvLCFYjzMcFVldhQ=;
	b=twGR0CgE+T+M5MrWJXr0/Bcm4dhqiCa/wkE70zd0oRnhuIIM4e9Uito5ZLMQvGl1kE68
	 +JrMNBXWfAWd3YZUJUD+Puj57LVYRppO8qnyMKhmQ3AdcmmaSUjcMDYmJFYYDFJ/K4gCJ
	 kQDtivBqQXZ476B+6+Pv/eXuc43FyGuzrlQ9NUbzd61YFgLkmR+JTu2jJP0ELf6BhI3Nz
	 B8dJqFOO5dfcxJ9HDAF5neiTYtbjfqOXwcwFmcWk0hqbN1pbhTxQtJ2OeXPrSjm53zUcO
	 ybG6IiJ6RBGIeONWplzBUttJwZwAs6YrssteNdckLWmiAy+AZ/xYNoDuSOrsG1HagKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q9oRpon5;
	arc=none smtp.remote-ip=91.218.175.162
Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0A60A2633
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 21:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70B0A60A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q9oRpon5
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=W3vVu5Uphs0NM4YFbvd5w2RlKRAMIIH16asxmDrJhQo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793051581; v=1; x=1793656381;
 b=Q9oRpon5zA+UHTc/zNA1CfOEj7tzi+hM9f3kaNawsSSJ8mdg3JWGxgYvIyn/111onNDap1X2
 sNtJNpKVNh9BpqgXFsSQZjRAlkXHmTWxvdgnZ+YwApZ8XuoidzSOdq5NHVywEJo6VzWASgpxTk3
 papqwVddycMV1y3KZDcUxrjI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 45d9b29136f833cb;
	Mon, 26 Oct 2026 21:53:01 +0000
X-Mizu-Trace-ID: 45d9b29136f833cb
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v4 2/2] selftests/rdma: Add netkit-based automated test script for RXE
Date: Mon, 26 Oct 2026 14:52:36 -0700
Message-ID: <20261026215236.60054-3-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026215236.60054-1-yanjun.zhu@linux.dev>
References: <20261026215236.60054-1-yanjun.zhu@linux.dev>
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
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh

diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
new file mode 100755
index 000000000000..181e2d85eed7
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
@@ -0,0 +1,81 @@
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
+exec > /dev/null
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


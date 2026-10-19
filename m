Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770A33CB8E5
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383582; cv=none; b=Cw7thrBs/1/wGTLl3ITYUmlug88MzIajxukbuV8XU/7OoQKoWAA77V/NieaSUodQO/V5dAScT1yLoy592gLZCs0vWOoJaK+FOykHkILG1nkK6YgBLPo7fVcb+w7FslAFA7XJ9mxn5RZcGIBT93BNE9IWnXHmf8AioSxOylF3gL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383582; c=relaxed/simple;
	bh=eDL1d3IBSbdn9Scy8w025AbOjF9AVFf5oKfU9FQy7iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QG2ILuFL2ZztvLTz5XySydGuo8rrCI/p81USo0S7FQ26Q3gOawfF7QxfQbVCmRM1uJfO+wlz+XRW/ZWOyvJFfQIrX1GwM3JRI2G/T0t6pbz6jo/EGez+MZjy8rmlFOFhEo8RFdkQD4KS7qRdYRmDvCDNvlnUBNizBMC+1nnMfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b5GdHTbr; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b5GdHTbr"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eDL1d3IBSbdn9Scy8w025AbOjF9AVFf5oKfU9FQy7iM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383577; v=1; x=1792988377;
 b=b5GdHTbrsEKJQ89YFzH2E0CyerCQBAg+4RnTQ8n1YPeaAWotZDDlCDc9Ah69aZWmKCwh4vMA
 F2FPy2hq8dv88XWj6Z8VLs2k9mKXO9O6ZwMizr2yBRgUuDyoXr8CnkvxFc9HDzg11khmzzga8Pu
 O1qX8LjNPBrWrrqGWZI4+N5c=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 730a19cba618098c;
	Mon, 19 Oct 2026 04:19:36 +0000
X-Mizu-Trace-ID: 730a19cba618098c
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 2/2] selftests/rdma: Add netkit-based automated test script for RXE
Date: Sun, 18 Oct 2026 21:19:12 -0700
Message-ID: <20261019041912.29488-3-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019041912.29488-1-yanjun.zhu@linux.dev>
References: <20261019041912.29488-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a shell script to automate functional and tracing tests for the
Soft-RoCE (RXE) driver over netkit network interfaces. The script creates
an isolated network namespace, sets up a netkit link pair (nk0/nk1),
attaches RXE links, and runs an rping client/server verification test
along with kernel tracing output collection.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh

diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
new file mode 100755
index 000000000000..6b544d9f49ae
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
@@ -0,0 +1,63 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
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
+    ip netns delete ns0 2>/dev/null
+    rm -f "$CUR_WD/rxe_netkit_dump" "$CUR_WD/rxe_pkg_kernel_dump.o" "$CUR_WD/rxe_pkg_kernel.skel.h"
+}
+
+trap cleanup EXIT
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
+ip link set nk0 netns ns0
+ip netns exec ns0 ip addr add 10.0.0.1/24 dev nk0
+ip netns exec ns0 ip link set nk0 up
+
+# Configure host interface
+ip addr add 10.0.0.2/24 dev nk1
+
+# Start dump utility in background
+"$CUR_WD/rxe_netkit_dump" &
+DUMP_PID=$!
+
+# Add RXE links over netkit devices
+ip netns exec ns0 rdma link add rxe0 type rxe netdev nk0
+rdma link add rxe1 type rxe netdev nk1
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
+ip link del nk1
+ip netns delete ns0
+
+# Display kernel trace output
+cat /sys/kernel/debug/tracing/trace
-- 
2.54.0


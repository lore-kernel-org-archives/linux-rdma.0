Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793467846;
	b=ditP3VS8iB/yEd5TthS98A0cgSv4+ih9skVnZNb+VubFe2ZnQ6ttjmxcziVW+S5UQaLI
	 veSs22CGcJSNbHhCvE6WCrSUSTy6Py4gcWBDybpWl05ySIDnWuds84kyVvqKQvH9jHVjS
	 pqHGZvZKJPDwSRIHnJDm968lgZS8/Ad0xhOyuNO+Dw1RUqvH2F/mWuFOTzSSs6ADqJAjt
	 DdOqVp8jT4omJMswgdCtmjDSGNgYbW9NDRjf6eutVPgpudyl6EScwj41uaLf3SMz12dCl
	 AV3j0ae/qGosauaNDTmndAcnJQw3q4KlQjwTWsUcJuw9glfO83VCVSqKyQXOm287lEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793467846;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=An4RKoQv8canUYctWX7MkEYwfU6QCqzXBm57U/vzawI=;
	b=2VsPsCaYA5x4AZYu4ggkYfCkUJBoJ6vMoENwNN6T70jxscoMQLf6SGWS5z9OAJAaSCCs
	 XvS7TOs+buBzVRutfXNSz1RP9bpOFm70BSa/dcokVr3Hlr+KjarQTnMsTD5uWTne7Lspi
	 HrWnhqk9JfCBQ+likV9sOqhCMmYsCSYe7fpcISaVHP4cLwj1iKe84cDAW+Y+G3Qxh7s9w
	 c8G7Qe9bPgquB/dNSCVdB3+LQUF3JypeYR54CAPwVvY1dZQHtD5IVYO2KEsvzDMM6XM9I
	 /C3D6F2JT6cGqIhDYBCjBKZPLIaZDcomYgW1sKXt9YQDb1ey3BU+W4bxICazburuXKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UxZeGI78;
	arc=none smtp.remote-ip=95.215.58.69
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C71606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 17:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3C71606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UxZeGI78
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=djYAoafCwPg/3+YI/VxhP2cFiJ4Xe2xAVkaaP+yCTBA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793467843; v=1; x=1794072643;
 b=UxZeGI787pN4Br/+HAw4zyVFj5j00vH0bk2Rfdyx/vH6zNGQt1cRfvmDsM0C0EGfhpcQINVf
 4HppONm0qwF4dtajefIF0gfTxi8lACGprjrmj7LZaTnwqGtYOOvIDkMAbDCbHKMzizN7phMUkAt
 g69zof6ixSiwyOfxY2nGGPlI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1b8d4fcc83e46f9b;
	Sat, 31 Oct 2026 17:30:43 +0000
X-Mizu-Trace-ID: 1b8d4fcc83e46f9b
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v5 2/2] selftests/rdma: Add netkit-based automated test script for RXE
Date: Sat, 31 Oct 2026 10:30:17 -0700
Message-ID: <20261031173017.20691-3-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031173017.20691-1-yanjun.zhu@linux.dev>
References: <20261031173017.20691-1-yanjun.zhu@linux.dev>
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
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh

diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
new file mode 100755
index 000000000000..937144cb91a6
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
@@ -0,0 +1,91 @@
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
+    local exit_code=$?
+
+    set +e
+    [ -n "$RPING_PID" ] && kill -9 "$RPING_PID" 2>/dev/null
+    unset RPING_PID
+
+    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
+    unset DUMP_PID
+
+    ip netns exec ns0 rdma link del rxe0 2>/dev/null
+
+    rdma link del rxe1 2>/dev/null
+    ip link del nk0 2>/dev/null
+    ip netns delete ns0 2>/dev/null
+
+    exit "$exit_code"
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
+RPING_PID=$!
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


Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED3336AB50
	for <linux-rdma@vger.kernel.org>; Tue, 14 Apr 2026 06:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776148231; cv=none; b=O71Syu+vu95X/pRYZjKS89eaoblKxpic5PFx6EhFmc+HAnJ1IpvH4XO2G5mVr9lT0JEyYZys5Xenp0TrZC74OGGJCRyuMZH+Wty0XKYRPc6kbvHdBWkPoUa7uoqdqB82cOxqoCn3bEtvkxcTKChar07/g+XFgfTuvUOorxm01xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776148231; c=relaxed/simple;
	bh=ItMLToIyV4S77ljFxNduKnisdDSNpcqHtUfi2/mzDE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvUTGbwfOZSWvHsHcidVxI5gIS6DIGXHBRdUbbI+GROn5cruPXkJqAp7GTH8aqKieLSM/Aiix0LR62df2xRGRFuD9E9AiHcX0A8qhRQTXuoLPYLuDaQEHxeb3UWqx0LmWi2uvYh9TL97me1qCdwLP12bQs7rhTELLXJIbkDzhD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZ2/vfpk; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZ2/vfpk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776148227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x34vfN+KG8g2HdRXGL+ty/bB/rBlCCclhJVaFNhRcvQ=;
	b=RZ2/vfpk5566FMbqAa4M55cx8/LT4KDmGRK/J4cCCLaTKk9Nm+YwCjjYHq5kwfIQ04KNPT
	6z+KDtJd9tdmoC/Z+0E5A2mNvoVRQIOs08qIdLzbrXixjrObMzi5I5UJ8PgqrNzDcRAkax
	Xf9Q1jBClAsYEJdvfZe7V3rkAxsdEs8=
From: zhenwei pi <zhenwei.pi@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v7 4/4] selftest/rxe: Add selftests for perf
Date: Tue, 14 Apr 2026 14:29:48 +0800
Message-ID: <20260414062948.671658-5-zhenwei.pi@linux.dev>
In-Reply-To: <20260414062948.671658-1-zhenwei.pi@linux.dev>
References: <20260414062948.671658-1-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Create a virtual TUN net device with RXE support, then run rping
server and client to invoke networking packets, finally compare both
*port_xmit_data* and *port_rcv_data* of such device.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 tools/testing/selftests/rdma/Makefile         |  3 +-
 .../selftests/rdma/rxe_sent_rcvd_bytes.sh     | 75 +++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh

diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
index 7dd7cba7a73c..07af7f15c1bf 100644
--- a/tools/testing/selftests/rdma/Makefile
+++ b/tools/testing/selftests/rdma/Makefile
@@ -2,6 +2,7 @@
 TEST_PROGS := rxe_rping_between_netns.sh \
 		rxe_ipv6.sh \
 		rxe_socket_with_netns.sh \
-		rxe_test_NETDEV_UNREGISTER.sh
+		rxe_test_NETDEV_UNREGISTER.sh \
+		rxe_sent_rcvd_bytes.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
new file mode 100755
index 000000000000..0e4fbfeebd22
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+
+# Configuration
+PORT=4791
+MODS=("tun" "rdma_rxe")
+
+exec > /dev/null
+
+# --- Helper: Cleanup Routine ---
+cleanup() {
+    echo "Cleaning up resources..."
+    rdma link del rxe0 2>/dev/null
+    ip link del tun0 2>/dev/null
+    for m in "${MODS[@]}"; do modprobe -r "$m" 2>/dev/null; done
+}
+
+# Ensure cleanup runs on script exit or interrupt
+trap cleanup EXIT
+
+# --- Phase 1: Environment Check ---
+if [[ $EUID -ne 0 ]]; then
+   echo "Error: This script must be run as root."
+   exit 1
+fi
+
+for m in "${MODS[@]}"; do
+    modprobe "$m" || { echo "Error: Failed to load $m"; exit 1; }
+done
+
+# --- Phase 2: Create Interfaces & RXE Links ---
+echo "Creating tun0 (1.1.1.1) and rxe0..."
+ip tuntap add mode tun tun0
+ip addr add 1.1.1.1/24 dev tun0
+ip link set tun0 up
+rdma link add rxe0 type rxe netdev tun0
+
+# Verify port 4791 is listening
+if ! ss -Huln sport = :$PORT | grep -q ":$PORT"; then
+    echo "Error: UDP port $PORT not found after rxe0 creation"
+    exit 1
+fi
+
+orig_s=`cat /sys/class/infiniband/rxe0/ports/1/counters/port_xmit_data`
+orig_r=`cat /sys/class/infiniband/rxe0/ports/1/counters/port_rcv_data`
+
+rping -s -a 1.1.1.1 -C 3 -v &
+sleep 1
+rping -c -a 1.1.1.1 -C 3 -d -v
+
+new_s=`cat /sys/class/infiniband/rxe0/ports/1/counters/port_xmit_data`
+new_r=`cat /sys/class/infiniband/rxe0/ports/1/counters/port_rcv_data`
+
+echo sent $new_s $orig_s
+echo rcvd $new_r $orig_r
+
+result0=$((new_s - orig_s))
+result1=$((new_r - orig_r))
+
+if [ $result0 != $result1 ]; then
+       echo "Error: sent and rcvd bytes different"
+       echo $result0
+       echo $result1
+       exit 1
+fi
+
+echo "Deleting rxe0..."
+rdma link del rxe0
+
+# Port should now be gone
+if ss -Huln sport = :$PORT | grep -q ":$PORT"; then
+    echo "Error: UDP port $PORT still exists after all links deleted"
+    exit 1
+fi
+
+echo "Test passed successfully."
-- 
2.43.0


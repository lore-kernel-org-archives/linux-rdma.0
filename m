Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6719378D96
	for <linux-rdma@vger.kernel.org>; Fri,  6 Mar 2026 08:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772785552; cv=none; b=hMI/bD4O/VMBarjRJ8wYZscMfNCZdH5bvnhdDtdod94bhSd5hMZuNCJPbqJXr8GAo8uSMOi9PWoGRJQ/mAIJBr5/gmyWCyv3qvevG+kxjBvZj8y0TBbjdeCWq520wt4wFTmq0oDZ77yj4zjBY3BkE5OpY2yEVzv6q3Gw4scnH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772785552; c=relaxed/simple;
	bh=LXVzWNtAt9+tfbQ9OLhlLLWElv3Ngu1cWkabeS2R5Rw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmvPZBXS6A/aY/wrj7YdBuVEIBD5QdZdVkZM0TSy+H/iK0VGhyr8r0dMylIiLE1NKgGAC050h324POnhmF5yE326qJdqgLszHIYZ4xGHSTrNLwLI0cLP+kM+/dLlKsiWzV/EsZc73+bkBvKJlWYp7sLigzQkLDgiCroWswOVIaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EU9oFssg; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EU9oFssg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772785546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXBLwIqi/fUCuiRCJKpUhEdjnuAAbkrNIJXFl5SNKAA=;
	b=EU9oFssgAkP3gSMlOrKCQ1UmRlznL7YaFp7XL58LwtuX/Nyov8UpNjlh/+1Tpjsg8DIdpZ
	R4fXqy8qQj8ye5ebhhUMGDPF0XWVYOvrDg5nx9a4B+CcsESJyezEw+NUACxhw6PY1qu9UG
	pCedZ4W2d7FbM2WlSSJL/Na7PZut990=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/4] RDMA/rxe: Add testcase for net namespace rxe
Date: Fri,  6 Mar 2026 00:24:49 -0800
Message-ID: <20260306082452.1822-2-yanjun.zhu@linux.dev>
In-Reply-To: <20260306082452.1822-1-yanjun.zhu@linux.dev>
References: <20260306082452.1822-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 MAINTAINERS                                   |  1 +
 tools/testing/selftests/Makefile              |  1 +
 tools/testing/selftests/rdma/Makefile         |  5 ++
 tools/testing/selftests/rdma/config           |  3 +
 .../selftests/rdma/rping_between_netns.sh     | 57 +++++++++++++++++
 tools/testing/selftests/rdma/rxe_ipv6.sh      | 47 ++++++++++++++
 .../testing/selftests/rdma/socket_with_rxe.sh | 64 +++++++++++++++++++
 7 files changed, 178 insertions(+)
 create mode 100644 tools/testing/selftests/rdma/Makefile
 create mode 100644 tools/testing/selftests/rdma/config
 create mode 100755 tools/testing/selftests/rdma/rping_between_netns.sh
 create mode 100755 tools/testing/selftests/rdma/rxe_ipv6.sh
 create mode 100755 tools/testing/selftests/rdma/socket_with_rxe.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37c..3f3aca470d77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24509,6 +24509,7 @@ L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/sw/rxe/
 F:	include/uapi/rdma/rdma_user_rxe.h
+F:	tools/testing/selftests/rdma/
 
 SOFTLOGIC 6x10 MPEG CODEC
 M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 450f13ba4cca..110e07c0d99d 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -94,6 +94,7 @@ TARGETS += proc
 TARGETS += pstore
 TARGETS += ptrace
 TARGETS += openat2
+TARGETS += rdma
 TARGETS += resctrl
 TARGETS += riscv
 TARGETS += rlimits
diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
new file mode 100644
index 000000000000..362e97f0fb3e
--- /dev/null
+++ b/tools/testing/selftests/rdma/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_PROGS := rping_between_netns.sh \
+		rxe_ipv6.sh \
+		socket_with_rxe.sh
+include ../lib.mk
diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
new file mode 100644
index 000000000000..4ffb814e253b
--- /dev/null
+++ b/tools/testing/selftests/rdma/config
@@ -0,0 +1,3 @@
+CONFIG_TUN
+CONFIG_VETH
+CONFIG_RDMA_RXE
diff --git a/tools/testing/selftests/rdma/rping_between_netns.sh b/tools/testing/selftests/rdma/rping_between_netns.sh
new file mode 100755
index 000000000000..80b4249dba55
--- /dev/null
+++ b/tools/testing/selftests/rdma/rping_between_netns.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+
+# Notes:
+#
+# 1. Before running this script, please disable the firewall, as it may
+# block UDP port 4791.
+
+# 2. This test script depends on the veth and tun drivers. Before running
+#  the script, please verify that both drivers are available by executing:
+#
+# modinfo veth
+#
+# Make sure these commands return valid module information.
+
+#1. Check if rping can work or not
+exec > /dev/null
+ip netns add test1
+ip netns ls
+ip link add veth-a type veth peer name veth-b
+ip l
+ip link set veth-a netns test1
+ip l
+ip netns exec test1 ip l set veth-a up
+ip netns exec test1 ip addr add 1.1.1.1/24 dev veth-a
+ip netns exec test1 ip l
+ip netns exec test1 ip -4 a
+ip netns exec test1 rdma link add rxe0 type rxe netdev veth-a
+
+#check if socket exist or not
+ip netns exec test1 ss -lun | grep :4791
+
+ip netns exec test1 rdma link
+ip link set veth-b up
+ip addr add 1.1.1.2/24 dev veth-b
+ping -c 3 1.1.1.1 || exit 1
+ip netns exec test1 rping -s -a 1.1.1.1&
+rdma link add rxe1 type rxe netdev veth-b
+rdma link
+
+#check if socket exist or not
+ss -lun | grep :4791
+
+rping -c -a 1.1.1.1 -d -v -C 3 || exit 1
+ip netns ls
+rdma link del rxe1
+
+#check if socket exist or not
+ss -lun | grep :4791
+
+ip netns exec test1 ss -lun | grep :4791
+ip netns exec test1 rdma link del rxe0
+ip netns exec test1 ss -lun | grep :4791
+ip netns del test1
+ip netns ls
+
+modprobe -v -r veth
+modprobe -v -r rdma_rxe
diff --git a/tools/testing/selftests/rdma/rxe_ipv6.sh b/tools/testing/selftests/rdma/rxe_ipv6.sh
new file mode 100755
index 000000000000..9337ac4fd13f
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_ipv6.sh
@@ -0,0 +1,47 @@
+#!/bin/sh
+
+# Notes:
+#
+# 1. Before running this script, please disable the firewall, as it may
+# block UDP port 4791.
+
+# 2. This test script depends on the veth and tun drivers. Before running
+#  the script, please verify that both drivers are available by executing:
+#
+# modinfo tun
+# modinfo veth
+#
+# Make sure these commands return valid module information.
+
+# 3. ipv6 test.
+# While RXE is conventionally deployed over IPv4, it maintains
+# native support for IPv6. However, IPv6 implementations typically
+# receive less validation and performance tuning in standard use cases.
+exec > /dev/null
+# 1) create ipv6 net namespace
+ip netns add net6
+ip link add veth0 type veth peer name veth1
+ip link set veth1 netns net6
+ip netns exec net6 ip addr add 2001:db8::1/64 dev veth1
+ip netns exec net6 ip link set veth1 up
+
+# 2) Add rdma link
+ip netns exec net6 rdma link add rxe6 type rxe netdev veth1
+
+# 3) check IPv6 UDP 4791 listening port
+if ! ip netns exec net6 ss -ul6n | grep :4791; then
+	echo "Error: udp port 4791 exists"
+	exit 1
+fi
+
+# 4) Delete rxe link
+ip netns exec net6 rdma link del rxe6
+if ip netns exec net6 ss -ul6n | grep :4791; then  # result should be null
+	echo "Error: udp port 4791 exists"
+	exit 1
+fi
+
+# 5) delete net6
+ip netns del net6
+
+modprobe -v -r rdma_rxe
diff --git a/tools/testing/selftests/rdma/socket_with_rxe.sh b/tools/testing/selftests/rdma/socket_with_rxe.sh
new file mode 100755
index 000000000000..676aec63babd
--- /dev/null
+++ b/tools/testing/selftests/rdma/socket_with_rxe.sh
@@ -0,0 +1,64 @@
+#!/bin/sh
+
+# Notes:
+#
+# 1. Before running this script, please disable the firewall, as it may
+# block UDP port 4791.
+
+# 2. This test script depends on the veth and tun drivers. Before running
+#  the script, please verify that both drivers are available by executing:
+#
+# modinfo tun
+#
+# Make sure these commands return valid module information.
+
+# Check if socket exist or not
+exec > /dev/null
+ip tuntap add mode tun tun0
+ip -4 a
+ip addr add 1.1.1.1/24 dev tun0
+ip link set tun0 up
+ip -4 a
+rdma link add rxe0 type rxe netdev tun0
+rdma link
+ret=`ss -lun | grep :4791`
+if [ X"$ret" == X"" ]; then
+	echo "Error: udp port 4791 does not exist"
+	exit 1
+fi
+
+ip tuntap add mode tun tun1
+ip -4 a
+ip addr add 2.2.2.2/24 dev tun1
+ip link set tun1 up
+rdma link add rxe1 type rxe netdev tun1
+rdma link
+ret=`ss -lun | grep :4791`
+if [ X"$ret" == X"" ]; then
+	echo "Error: udp port 4791 does not exist"
+	exit 1
+fi
+
+rdma link del rxe1
+rdma link
+ret=`ss -lun | grep :4791`
+if [ X"$ret" == X"" ]; then
+	echo "Error: udp port 4791 doese not exist"
+	exit 1
+fi
+
+rdma link del rxe0
+rdma link
+if ss -lun | grep :4791; then
+	echo "Error: udp port 4791 exists"
+	exit 1
+fi
+
+ip addr del 2.2.2.2/24 dev tun1
+ip tuntap del mode tun tun1
+
+ip addr del 1.1.1.1/24 dev tun0
+ip tuntap del mode tun tun0
+
+modprobe -v -r tun
+modprobe -v -r rdma_rxe
-- 
2.52.0


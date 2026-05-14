Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9395C3B9DA8;
	Thu, 14 May 2026 04:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778733216; cv=none; b=KYX14TILud9KweXDXVVl0SR6ULq8dvp7KrNhtXF0uB5VAllnELFnIZgDBkOc4CLpa++9O3//wHyblCO+o5bGkq441xCjTQvZXGBwVra8d3NZslYDrgpxHvNbHdV3+AhTm9awLPP4vilUrPyHmIdcX1BIcGpukg2yeGHcxfANkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778733216; c=relaxed/simple;
	bh=qu9Ckvx3+OnLFi9o/k6rT6dElt8Zc9m4Dcn8OR4P9Tg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YGacG4lbiZD9U8sRzcEUnkwkXXz990WCF3dPxe1wlexo0sZoASiJjVa3o9FUdGnzvT7SN60g87vPtG+TdJZNKtJAG1EL8fAtXxV+U/rZ2kMBgbusjdv/qhFPuBWZmvicf9qGOi5kp0VS/ySQGnzcdHpixkzxpEk3IX/lOtGq58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMe5GRn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMe5GRn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF4BC2BCB7;
	Thu, 14 May 2026 04:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778733216;
	bh=qu9Ckvx3+OnLFi9o/k6rT6dElt8Zc9m4Dcn8OR4P9Tg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SMe5GRn6X2ymgo7lSpokpVn9HTSI52+W5SRd+Axcozl8sTqpW/CP/A3MTz/oCKO1y
	 mOvVpC9PcuggdNfMsFKcJB3PbYrpM59oAAs1CZvHPzEmTijI6mQb1m1DkfhmDN326S
	 HQy5Ttzpq/PreYw9tZOp5Ozwy8cH5APAspuEChTQX3MsfPQZgoL4oojZsySeFkFZN2
	 RFXOnTsBcf8eh5jWRqaOfwhXSSdwsLk7d7VJFD9W3ZmCU07JKQDdeWyIyvnL2PlCPV
	 wpUFFN7VeawQRFxNZU4j07Zan4lLbLCNKCJhdB2dHh3E5CjO4tsmuMOCBJiJfiszQC
	 Khl2+LsL+EQlw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH net-next v2 6/9] selftests: rds: Add helper function snd_rcv_packets() in test.py
Date: Wed, 13 May 2026 21:33:27 -0700
Message-Id: <20260514043330.1718969-7-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260514043330.1718969-1-achender@kernel.org>
References: <20260514043330.1718969-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hoist the send/recv logic in test.py into a helper function,
snd_rcv_packets().  This is a preparatory refactoring for the
rds over ROCE series which can use the same function to run
the test over tcp, rdma, or both.  No functional changes are
introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 99 ++++++++++++++-----------
 1 file changed, 54 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index a3def413d84a..f7d0dba85131 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -167,6 +167,59 @@ def verify_hashes(snd_hashes, rcv_hashes):
         ksft_pr(f"{key[0]}/{key[1]}: ok")
     return 0
 
+def snd_rcv_packets(addrs, netns_list):
+    """
+    Send packets on the given network interfaces
+
+    :param addrs: list of (ip, port) tuples matching the sockets
+    :param netns_list: list of network namespaces
+    """
+
+    sockets = [
+        netns_socket(netns_list[0], socket.AF_RDS, socket.SOCK_SEQPACKET),
+        netns_socket(netns_list[1], socket.AF_RDS, socket.SOCK_SEQPACKET),
+    ]
+
+    for s, addr in zip(sockets, addrs):
+        s.bind(addr)
+        s.setblocking(0)
+
+    send_hashes = {}
+    recv_hashes = {}
+
+    ep = select.epoll()
+
+    for s in sockets:
+        ep.register(s, select.EPOLLRDNORM)
+
+    num_packets = 50000
+    nr_send = 0
+    nr_recv = 0
+
+    while nr_send < num_packets:
+
+        # Send as much as we can without blocking
+        ksft_pr("sending...", nr_send, nr_recv)
+        nr_send = send_burst(sockets, addrs, send_hashes, nr_send, num_packets)
+
+        # Receive as much as we can without blocking
+        ksft_pr("receiving...", nr_send, nr_recv)
+        while nr_recv < nr_send:
+            nr_recv = recv_burst(ep, sockets, addrs, recv_hashes, nr_recv)
+
+        # exercise net/rds/tcp.c:rds_tcp_sysctl_reset()
+        for net in netns_list:
+            ip(f"netns exec {net} /usr/sbin/sysctl net.rds.tcp.rds_tcp_rcvbuf=10000")
+            ip(f"netns exec {net} /usr/sbin/sysctl net.rds.tcp.rds_tcp_sndbuf=10000")
+
+    ksft_pr("done", nr_send, nr_recv)
+
+    check_info(sockets)
+
+    # We're done sending and receiving stuff, now let's check if what
+    # we received is what we sent.
+    return verify_hashes(send_hashes, recv_hashes)
+
 def stop_pcaps():
     """Stop tcpdump processes.
 
@@ -267,7 +320,6 @@ PACKET_CORRUPTION=str(args.corruption)+'%'
 PACKET_DUPLICATE=str(args.duplicate)+'%'
 
 setup_tcp()
-addrs = tcp_addrs
 
 print("TAP version 13")
 print("1..1")
@@ -277,56 +329,13 @@ if args.timeout > 0:
     signal.alarm(args.timeout)
     signal.signal(signal.SIGALRM, signal_handler)
 
-sockets = [
-    netns_socket(NET0, socket.AF_RDS, socket.SOCK_SEQPACKET),
-    netns_socket(NET1, socket.AF_RDS, socket.SOCK_SEQPACKET),
-]
-
-for s, addr in zip(sockets, addrs):
-    s.bind(addr)
-    s.setblocking(0)
-
-send_hashes = {}
-recv_hashes = {}
-
-ep = select.epoll()
-
-for s in sockets:
-    ep.register(s, select.EPOLLRDNORM)
-
-NUM_PACKETS = 50000
-nr_send = 0
-nr_recv = 0
-
-while nr_send < NUM_PACKETS:
-
-    # Send as much as we can without blocking
-    ksft_pr("sending...", nr_send, nr_recv)
-    nr_send = send_burst(sockets, addrs, send_hashes, nr_send, NUM_PACKETS)
-
-    # Receive as much as we can without blocking
-    ksft_pr("receiving...", nr_send, nr_recv)
-    while nr_recv < nr_send:
-        nr_recv = recv_burst(ep, sockets, addrs, recv_hashes, nr_recv)
-
-    # exercise net/rds/tcp.c:rds_tcp_sysctl_reset()
-    for net in [NET0, NET1]:
-        ip(f"netns exec {net} /usr/sbin/sysctl net.rds.tcp.rds_tcp_rcvbuf=10000")
-        ip(f"netns exec {net} /usr/sbin/sysctl net.rds.tcp.rds_tcp_sndbuf=10000")
-
-ksft_pr("done", nr_send, nr_recv)
-
-check_info(sockets)
+ret = snd_rcv_packets(tcp_addrs, [NET0, NET1])
 
 # cancel timeout
 signal.alarm(0)
 
 stop_pcaps()
 
-# We're done sending and receiving stuff, now let's check if what
-# we received is what we sent.
-ret = verify_hashes(send_hashes, recv_hashes)
-
 if ret == 0:
     ksft_pr("Success")
     print("ok 1 rds selftest")
-- 
2.25.1


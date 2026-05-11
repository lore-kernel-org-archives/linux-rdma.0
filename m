Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D437A4B8;
	Mon, 11 May 2026 07:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484203; cv=none; b=aHgFVWbOcz+EDmWFOdC+Pglvsh+tYNnhBo2ZgGMEXybyDmVtqg6W4bgMQozuIk+ox245PqqxVl1WD/cJW3vkE+aJeh1J7flsD4ihnkqXkdtuXdBCBNhNExO5/RJIGSwPvA3dhFy3+p02zd7fOACnN9J/SY60h23chMDi/PnfukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484203; c=relaxed/simple;
	bh=TQxrHZChUalLNXFf5ym56IzqKtwdJZuCxLWbqgtd6fA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzWoNdZq6UomRN68jYGWImy1T2ESUZZmt5gKloLRkEskbtCD0WRbuDBBlKK+kUH8ZDNpSrce5Bf7Qq5kRLSAxtXHTFKZELkj1cW07TmdfbW29hQbtbBFB0VycjLm9R2qtOYxsskHKvikS5seyG2FllnLaQpQ7sT2h2+TASCK8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lswJEIhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lswJEIhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A052C2BCFC;
	Mon, 11 May 2026 07:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778484202;
	bh=TQxrHZChUalLNXFf5ym56IzqKtwdJZuCxLWbqgtd6fA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lswJEIhqdJA0uGgwLGVRBZ8G/EPjvmf0i6HyCl1VvMhqn6P1rUHMACCqUNQS62XPe
	 lzQv9dBgYzkpGHelfsAIEFHc3wg02xhe2JWYpNcI1fbM/4kQrMTFKfv+Ge8oxMTcIc
	 7yEKsOeNLYs7iS0IUbcsCfm/DrrdxojRVvI+nH9YqiinT1WJDU12htkW7Kj4fAvDrR
	 5WtrnXikVa6ibWF9CdyILdvNe+iolPEkp+uBUdcvHB05dOd0B2VpFjKeoi3NVUQCyF
	 5An47BB0SVYLWqv3BcwaDbhRBuCrU15ACBJ0TGXdTXlRovukpTQrU5EH3y94ag1PGI
	 M8QMXPm/PFtDw==
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
Subject: [PATCH net-next v1 7/9] selftests: rds: Add helper function snd_rcv_packets() in test.py
Date: Mon, 11 May 2026 00:23:14 -0700
Message-Id: <20260511072316.1174045-8-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260511072316.1174045-1-achender@kernel.org>
References: <20260511072316.1174045-1-achender@kernel.org>
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
index 6a7a5fe20034..38f6100a6e33 100755
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
+    NUM_PACKETS = 50000
+    nr_send = 0
+    nr_recv = 0
+
+    while nr_send < NUM_PACKETS:
+
+        # Send as much as we can without blocking
+        ksft_pr("sending...", nr_send, nr_recv)
+        nr_send = send_burst(sockets, addrs, send_hashes, nr_send, NUM_PACKETS)
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
+RC = snd_rcv_packets(tcp_addrs, [NET0, NET1])
 
 # cancel timeout
 signal.alarm(0)
 
 stop_pcaps()
 
-# We're done sending and receiving stuff, now let's check if what
-# we received is what we sent.
-RC = verify_hashes(send_hashes, recv_hashes)
-
 if RC == 0:
     ksft_pr("Success")
     print("ok 1 rds selftest")
-- 
2.25.1


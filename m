Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50A3B19C2;
	Thu, 14 May 2026 04:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778733214; cv=none; b=XM+rUodpL7HLCZNr4c/2+RyPjPGnz4rZyp2+WTZLBdq2NEh2i22OQYMRFVZzsiuLRTZoqw8B+yJXRMU2R5K/fizce+29gOZjWQOS0twzl1U7NTKupDRmxhj+LwTtvxXuPDxITTDL0qbzxjBDU3ohXA6W/gx8ZePdTYxsWXlb/E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778733214; c=relaxed/simple;
	bh=9vH3fK9yH458MCyHp9AoakIkJj1Q7h/ZnCVCpegupFk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ElVHGlQbnQZUkD5Wv27UDGi9jdhNmXi1RrEtPZJoJBbnFWfPLaeXftYF8+lrFoNXOt37fzNy9DDDGJ0G9HeDFviNJNQwvDaJuyskMyTn6yM4+beWkYSdUtuaGEwoCVsInHFqd7kGJOzr0HwyFkleiyC6t+dD4KgFxB/4CC/lhE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKZWxUfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKZWxUfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA72C2BCF7;
	Thu, 14 May 2026 04:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778733214;
	bh=9vH3fK9yH458MCyHp9AoakIkJj1Q7h/ZnCVCpegupFk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hKZWxUfb+ljRsV0vs+FZtQjrC19PrPgzelXUMacPJmIBcBb1J+lF2tLBANCMwPTv8
	 efC/kNXzLvjsA1iaYLh79SYdhoMVzkhFJNOZXahZfy/wpyAz3+94YY2ruh54/IR1XR
	 hY927POnMaeFr97qgcsgIl6k9U8tlFPPkaCtlFPdJ7zCR0nAB+9wJXH5520c8Sd7pA
	 1vpzeWfX3+pUI6gRAMuuIoO8LBunm3ItsGkmWtx27m9qjAhu1rLVogbNVhRryJ96ns
	 CNUP44zryNJ7N3EG7usjD2RZBM4UHrytyWR49q7mbeO18qlEMFk1LJl03UNksb76JF
	 A1k7k2oS0CUVA==
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
Subject: [PATCH net-next v2 3/9] selftests: rds: Add helper function send_burst() in test.py
Date: Wed, 13 May 2026 21:33:24 -0700
Message-Id: <20260514043330.1718969-4-achender@kernel.org>
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

Hoist the send packet logic in test.py into a helper function,
send_burst().  This is a preparatory refactoring for the rds over ROCE
series that helps modularize the send/recv logic. Breaking up the logic
now will help avoid large function pylint errors later.  No functional
changes are introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 50 +++++++++++++------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index d64af9e662e8..d6e872af1360 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -79,6 +79,31 @@ def netns_socket(netns, *sock_args):
     u1.close()
     return socket.fromfd(fds[0], *sock_args)
 
+def send_burst(socks, ip_addrs, snd_hashes, nr_sent, nr_total):
+    """Send until blocked or nr_total reached. Return updated nr_sent."""
+
+    while nr_sent < nr_total:
+        data = hashlib.sha256(
+            f'packet {nr_sent}'.encode('utf-8')).hexdigest().encode('utf-8')
+        # pseudo-random send/receive pattern
+        snd_idx = nr_sent % 2
+        rcv_idx = 1 - (nr_sent % 3) % 2
+
+        snd = socks[snd_idx]
+        rcv = socks[rcv_idx]
+        try:
+            snd.sendto(data, ip_addrs[rcv_idx])
+        except BlockingIOError:
+            return nr_sent
+        except OSError as e:
+            if e.errno in (errno.ENOBUFS, errno.ECONNRESET, errno.EPIPE):
+                return nr_sent
+            raise
+        snd_hashes.setdefault((snd.fileno(), rcv.fileno()),
+                hashlib.sha256()).update(f'<{data}>'.encode('utf-8'))
+        nr_sent += 1
+    return nr_sent
+
 def check_info(socks):
     """
     Check all rds info pages for errors
@@ -234,10 +259,6 @@ fileno_to_socket = {
 
 addr_to_socket = dict(zip(addrs, sockets))
 
-socket_to_addr = {
-    s: addr for addr, s in zip(addrs, sockets)
-}
-
 send_hashes = {}
 recv_hashes = {}
 
@@ -251,27 +272,10 @@ nr_send = 0
 nr_recv = 0
 
 while nr_send < NUM_PACKETS:
+
     # Send as much as we can without blocking
     ksft_pr("sending...", nr_send, nr_recv)
-    while nr_send < NUM_PACKETS:
-        send_data = hashlib.sha256(
-            f'packet {nr_send}'.encode('utf-8')).hexdigest().encode('utf-8')
-
-        # pseudo-random send/receive pattern
-        sender = sockets[nr_send % 2]
-        receiver = sockets[1 - (nr_send % 3) % 2]
-
-        try:
-            sender.sendto(send_data, socket_to_addr[receiver])
-            send_hashes.setdefault((sender.fileno(), receiver.fileno()),
-                    hashlib.sha256()).update(f'<{send_data}>'.encode('utf-8'))
-            nr_send = nr_send + 1
-        except BlockingIOError:
-            break
-        except OSError as e:
-            if e.errno in [errno.ENOBUFS, errno.ECONNRESET, errno.EPIPE]:
-                break
-            raise
+    nr_send = send_burst(sockets, addrs, send_hashes, nr_send, NUM_PACKETS)
 
     # Receive as much as we can without blocking
     ksft_pr("receiving...", nr_send, nr_recv)
-- 
2.25.1


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA225EF87;
	Mon, 18 May 2026 01:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067488; cv=none; b=HqyA5EdcqX3B/8tmu1ubhh/YMa7wecIEgqjfzJ54MdDhKKN7xmvirzfJfEwaPqoPxmbMY+SeoA3Athxwaf2WWLGlyH6y3hRJLb+rmyOn+OUc+OkWchjp5exUDJ2f60LB34zypyJorP+vCL3jYj39+P4Xj8p+qtzX1wMWrwzc78o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067488; c=relaxed/simple;
	bh=wE0sjSu8j4RsK7EzF/RCvVyzLW7rHyFMwkJtmKMAlvY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nqqYe2H/ze79tvlp0R2ePB/DZ0P5XdS03StNMo+SwCC/KIChCHAuqm4ZzbHfqUlT4ZrSYE1LDjF4yn36OnoWUAHUhMfE7EOokotS54/eM4C9kjfoeLqztx2m2onF9KbjzFGeizt2/uVeisUTdm6AzMvYyHDatJ7Rz5IMsrW1o/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKge7zbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKge7zbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39A5C2BCF5;
	Mon, 18 May 2026 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779067488;
	bh=wE0sjSu8j4RsK7EzF/RCvVyzLW7rHyFMwkJtmKMAlvY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LKge7zbv7ThumudlWcl7VQis4q7z/AoPKzgmBpqjxhmixUTt8KWb0D1XhjggXZLyv
	 1P1PykIIOjhIp2XDwLHJ5mwqjACDGMENnss84DXn9HCW3TvoIwCi6LwMHi2dn+BzKh
	 hHYK3rAP2TX/av+/txNrZ3cRHCEZOcmHjdEX7xrRPuMiJL5+j6+l3BTwWI6PUmyud6
	 nsHZTStE7wRnJrTTZTdquWSzRAxaSx/KVQfocnMogIod0583x3tdO0foHlULoP9pG2
	 szf/Nb16iUtM6tP2gO1UZ6hJ/OBHBXrqdgom1wbQ1ZgAUMOfhJT80HEdA1LlQdwasA
	 9I9i9UQ3VGa9w==
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
Subject: [PATCH net-next v3 05/11] selftests: rds: Add helper function recv_burst() in test.py
Date: Sun, 17 May 2026 18:24:37 -0700
Message-Id: <20260518012443.2629206-6-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260518012443.2629206-1-achender@kernel.org>
References: <20260518012443.2629206-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hoist receive packet logic in test.py into a helper function,
recv_burst().  This is a preparatory refactoring for the rds over ROCE
series that helps modularize the send/recv logic. Breaking up the logic
now will help avoid large function pylint errors later.  No functional
changes are introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 39 ++++++++++++-------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index d6e872af13600..ae74117b41747 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -104,6 +104,24 @@ def send_burst(socks, ip_addrs, snd_hashes, nr_sent, nr_total):
         nr_sent += 1
     return nr_sent
 
+def recv_burst(epoll, socks, ip_addrs, rcv_hashes, nr_rcv):
+    """Drain whatever's readable from epoll. Return updated nr_recv."""
+    for filen, evntmask in epoll.poll():
+        if not evntmask & select.EPOLLRDNORM:
+            continue
+        rcv = next(s for s in socks if s.fileno() == filen)
+        while True:
+            try:
+                data, adr = rcv.recvfrom(1024)
+            except BlockingIOError:
+                break
+            snd_idx = ip_addrs.index(adr)
+            snd = socks[snd_idx]
+            rcv_hashes.setdefault((snd.fileno(), rcv.fileno()),
+                    hashlib.sha256()).update(f'<{data}>'.encode('utf-8'))
+            nr_rcv += 1
+    return nr_rcv
+
 def check_info(socks):
     """
     Check all rds info pages for errors
@@ -253,12 +271,6 @@ for s, addr in zip(sockets, addrs):
     s.bind(addr)
     s.setblocking(0)
 
-fileno_to_socket = {
-    s.fileno(): s for s in sockets
-}
-
-addr_to_socket = dict(zip(addrs, sockets))
-
 send_hashes = {}
 recv_hashes = {}
 
@@ -280,20 +292,7 @@ while nr_send < NUM_PACKETS:
     # Receive as much as we can without blocking
     ksft_pr("receiving...", nr_send, nr_recv)
     while nr_recv < nr_send:
-        for fileno, eventmask in ep.poll():
-            receiver = fileno_to_socket[fileno]
-
-            if eventmask & select.EPOLLRDNORM:
-                while True:
-                    try:
-                        recv_data, address = receiver.recvfrom(1024)
-                        sender = addr_to_socket[address]
-                        recv_hashes.setdefault((sender.fileno(),
-                            receiver.fileno()), hashlib.sha256()).update(
-                                    f'<{recv_data}>'.encode('utf-8'))
-                        nr_recv = nr_recv + 1
-                    except BlockingIOError:
-                        break
+        nr_recv = recv_burst(ep, sockets, addrs, recv_hashes, nr_recv)
 
     # exercise net/rds/tcp.c:rds_tcp_sysctl_reset()
     for net in [NET0, NET1]:
-- 
2.25.1


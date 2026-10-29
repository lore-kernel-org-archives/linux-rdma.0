Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793261016;
	b=Q3ngCqo/o8QRB2mNbnTK/ICSoYDFHkf4L5w8DUAp52JtR9cm/nDsosncn9xobJHGPIud
	 AFYeANys9Zk0yGnyJf+HllhxdsJCffo3ZfuliU2GAtO17PU/J1zn9y666+mJQpBPuR8IJ
	 tTL7VENzr9GLJJwB7b1tfIbKUR0tFOSiqZ4AbiDpPHnunXgNsxc+17A0K3nnhzyD1vC+x
	 tjbGh5MG+VdtcAM44J16a6igwVnVsJGBrxgksdN7eJMYgHEmzNyv03e5GwK9phes0Bu5H
	 V1kOWFUty1//zOSoxzz8t4TlpnKhQvhcTLhB1qiOkBx8Pe4RiqUyGndjBK/+xW9LObA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261016;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=t7ppcrNUXvQfqXQ4zpLVnFBJmPKeLiyNef0bkUiDzh0=;
	b=SX5AckxKB+IREiYLPwbceEokM4mTL0R9GDBYFW1Q9iV2BwVEAoWM3/RhZ7VhSi4guciZ
	 t+kEYE/nJPWfUa0mqedJdfKl6KmOFPluH30Lv7RfXhglj8mO47WgKtK+Ode4wHkHnkEG6
	 nZTs07tWPGqxt8gmygW898QiUrL19bSFCExIDz3CWBiTiQd/5nsifGmHykCTJrTE73ZFk
	 XHG5+Sz90zmAJvilH9jQ94UvoLSrlW7W+4TVyV+5NALsmsnyIpWZJrumNQswG0C0Ea5+V
	 i3fnn9HW3zVrKxXlb7TuyuW+S+PLvrJ67EEFV4K5sXLaogO/FpzTmUj5SB/fkJQV0QQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d/8MRN+w";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FE1606A31A;
	Thu, 29 Oct 2026 08:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/8MRN+w
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793261015;
	b=V+CmWTsKqkcxcKtKxKoZNEGC7haBKGFCdINLjkvUcyaDUqmBOO5+80w5n08H8MW2of5t
	 iCiL2zHoRPBpMU6P9QX51EWEGa3zn7aeM/ymHDrudNy/5YzJJJTeHSBTllSkMMt7hLYEG
	 f1/7h5vYP3/+Cmis02fqcXauudaXzMx8OoEg9FYPbVRpDaoUICyZIob5ESq+SVJX5jIzy
	 QK46GE35A9K0dGRWxwb/0QQLt+93RhhI3VR7TOQLxXymdn/70Ch9W1leSDk+dzOgVypb+
	 1Jx/FopOxVJTZE4wcFu17s3hkO7k6z4WvBJNLZ2d0TKZmvtMg1plHyNpvZolZo9colg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793261015;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=t7ppcrNUXvQfqXQ4zpLVnFBJmPKeLiyNef0bkUiDzh0=;
	b=DFJnYsiy3/N8jun2mgZE96SpR2bbWYMSFLo2r2sVxAw8wAOh6lgiDPb25aqIlUQLA++3
	 MjKPnGQQkUFplEaoVQA+9ysy8Aq0YLutf2z9UvKzt/GD3ixRVfbEx3cmN+fwB5EVylqX1
	 rdGHOVMMfzD0BkI7AOnCcN9WayvqovfG8SUZKM1TrnGUQGFGA2yJ16sp8czGIY6hYuWq9
	 2mAp4CVIbhPFczsF04luUPhu0uzmSwIjt5zuS8gngs/I/XrAzQcj3H2MzgsMUNuaONbDD
	 jNfP2LnIk35Oh7dM1g3uOM0fvknS/j7yB6II+D53o/rdnpU49sLZb376QcCKgUFJZ3w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EFF731F01828;
	Thu, 29 Oct 2026 08:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261015;
	bh=t7ppcrNUXvQfqXQ4zpLVnFBJmPKeLiyNef0bkUiDzh0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=d/8MRN+wfTyzXnQMXWgycdk0DNOIuUuy0h7IdDFpO6QFSdqVmt4dCLOyddCSxzWHk
	 K81wqMXlKqXj1+M5SZo4ImnaxC0AVK4Y221P8mJOBsPSBDPuTsbzDYftdCPnYcHbBW
	 wD/zowsLVVsbACjkosafwEUAhDKemeQjxfLV3EaWH6/m/JccOTzGrJgIaf2GR1p/nz
	 G/VBGc0xb7iNGwmsiJBz0qMrUYmo/cmQnJHW34CITtVJk6hM0NJ0dJsy/cquyrbH7U
	 rW/+LvWsV5vrp/JASFOXSsWfzoFevH+IhZlk51FXDsrLSJHsZMWkQKeBNYO10gKT/0
	 GKAwewqzFwIQQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 51FE845769;
	Thu, 29 Oct 2026 08:03:33 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 29 Oct 2026 03:03:33 -0500
Subject: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQ6CMBAFf4W8s5u0DQXxV4yH0i66HirpIiEh/
 LtVjzPJzA7lIqy4NDsKr6LyyhXcqUF8hHxnklQZzrjOGjfQ2FISnSmFfjpzF8j2yXoTfBsHj5r
 NhSfZfssrMi+4/aW+xyfH5TvDcXwAoqd3H3kAAAA=
X-Change-ID: 20261029-b4-disp-da7f8e6a-17d150a54c95
To: Dust Li <dust.li@linux.alibaba.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>
Cc: linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 linux-rdma@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org, 
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793261012; l=7130;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=ar8KXhaTisT8HDuo20NamNjP4DQNRxjn6kgJ2jxpkAA=;
 b=ZyaCjkklAlXTK7izphnTd7TNW3OnqMNkgxPM34XZFQZn+EyHpIpkF4XFwpdKuKD+5IwvKiYX4
 6exl2iDWr+gBqKUonTYPBLqaCorOq7Fq8yXfolySTxZ5MhQ2s74DEQb
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

While bytes spliced off the RMB are still in a pipe, recvmsg() waits
for the pipe to release them before it copies the data behind them.
The path to that wait skips the timeout and signal checks, and
smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
after SHUT_RD, or once the peer closes or shuts down writing,
recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
instead of returning -EAGAIN.

Check the timeout and signals before that wait, and end it when the
pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
A zero-length read returns 0 without waiting for the pipe; a
non-blocking one returns -EAGAIN while poll() still reports the socket
readable (splice() can still take those bytes). The wait sets
SOCKWQ_ASYNC_WAITDATA like smc_rx_wait(), so a byte arriving behind
the pipe raises no SIGIO on a reader already asleep for it, and a full
barrier orders its wait queue entry before its read of splice_pending,
so no wake is lost.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Changes in v2:
- Set and clear SOCKWQ_ASYNC_WAITDATA around the sleep, as
  smc_rx_wait() does: a byte arriving behind the pipe raised SIGIO on
  an O_ASYNC reader already asleep for it (the AI review of v1 [3],
  Low). Measured on the v1 setup with that reader (F_SETOWN_EX to the
  reading thread, a SIGIO handler without SA_RESTART, the peer sends
  one more byte): v1 returns -EINTR within 1 ms of the byte; v2, like
  the unpatched kernel, sleeps on (0 ms of CPU in 3 s) and reads the
  next 4096 bytes after the drain. v2 without its sk_set_bit() line
  brings the -EINTR back.
- smp_mb() between add_wait_queue() and the read of splice_pending
  (the review's Medium): the release decrements, then wakes only if
  wq_has_sleeper() sees the entry, and the sleeper had only an unlock
  and a lock acquire between its entry's store and its read, IOW
  store-buffering, a lost wake. herd7 against LKMM: allowed without
  the smp_mb(), forbidden with it. x86 and s390 can't show it (the
  lock acquire is a full barrier there), so it's modeled, not
  measured. smc_rx_wait() has the same gap, pre-existing; every CDC
  message that brings data wakes it, so it's left alone.
- The commit message now says a non-blocking read behind the pipe
  returns -EAGAIN while poll() reports the socket readable (a
  pre-existing point the review raised); poll() is left alone, since
  hiding those bytes from smc_poll() would hide data splice() can
  still take. A level-triggered loop that keeps the spliced bytes in a
  pipe gets EPOLLIN and -EAGAIN until it drains that pipe; before the
  patch the same read didn't return until the drain, asleep, one pass
  per tick.
- Not addressed: the other pre-existing point, a second splice()
  reading a stale splice_pending between the first pipe's cursor
  update and its decrement; the change Hidayath Khan announced in [1]
  (the decrement moved under lock_sock()) would close it.
- Rebased on net after the net-next merge (fcc00b15cb21); smc_rx.c is
  the same there, on v7.3 and on v7.3-rc6. The three comments the
  patch adds are shorter.
- Link to v1: https://lore.kernel.org/netdev/20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me/

Every case of v1 (the repro is in its notes) run again on v2, on v7.3
with KASAN, gives the same result: MSG_DONTWAIT -EAGAIN at once,
SO_RCVTIMEO after 1050 ms, -EINTR or the SA_RESTART handler on a
signal, SIGKILL done within 11 ms, recv(0) 0 at once; after a shutdown
or an abort the reader sleeps with no CPU and gets the next 4096 bytes
after the drain; the MSG_WAITALL read returns its 4096 at the signal;
a second splice(SPLICE_F_NONBLOCK) with the first undrained returns
the next 4096 at once; no KASAN splat. Not repeated: the SMC-R case
(rdma link del on the reader's only device) and the run on top of the
cursor-bounds series [2]; the wait's exit once the connection is
killed is unchanged. Logs on request.

For stable: 5.10.y and 5.15.y lack c924884743e9 ("net/smc: fix
use-after-free in smc_rx_pipe_buf_release()"); its backports there are
posted, not released. Without it a reader in SMC_CLOSED,
SMC_PEERFINCLOSEWAIT or SMC_APPFINCLOSEWAIT would sleep until a
signal, its timeout or the connection's kill instead of spinning,
since the pipe release doesn't decrement splice_pending in those
states. 6.1.y and up have it.

[1] https://lore.kernel.org/all/7a174d1f-80d8-4294-ae66-829c9dacd662@linux.ibm.com/
[2] https://lore.kernel.org/all/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me/
[3] https://lore.kernel.org/all/179209723095.434549.11206499945190748009@kernel.org/
---
 net/smc/smc_rx.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 197fddc6271f..63c178c10bf1 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -286,6 +286,27 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
 	return rc;
 }
 
+/* Wait for the pipe to release the spliced data. Unlike smc_rx_wait()
+ * it does not end on shutdown or sk_err, the data is already in the
+ * RMB; smc_conn_kill() wakes it and the caller checks conn->killed.
+ */
+static void smc_rx_wait_splice(struct smc_sock *smc, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct smc_connection *conn = &smc->conn;
+	struct sock *sk = &smc->sk;
+
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	add_wait_queue(sk_sleep(sk), &wait);
+	/* pairs with the smp_mb() in wq_has_sleeper(): the release drops
+	 * splice_pending, then looks for a sleeper
+	 */
+	smp_mb();
+	sk_wait_event(sk, timeo, !atomic_read(&conn->splice_pending), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+}
+
 static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 			   int flags)
 {
@@ -443,7 +464,23 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		/* could be just 1 byte, even after waiting on data above */
 		readable = smc_rx_data_available(conn, peeked_bytes);
 		splbytes = atomic_read(&conn->splice_pending);
-		if (!readable || (msg && splbytes)) {
+		if (msg && splbytes) {
+			/* a pipe holds bytes ahead of these; the copy path
+			 * skips the timeout and signal checks
+			 */
+			if (!read_remaining)
+				break;
+			if (!timeo || signal_pending(current)) {
+				if (!read_done)
+					read_done = timeo ?
+						    sock_intr_errno(timeo) :
+						    -EAGAIN;
+				break;
+			}
+			smc_rx_wait_splice(smc, &timeo);
+			continue;
+		}
+		if (!readable) {
 			if (splbytes)
 				func = smc_rx_data_available_and_no_splice_pend;
 			else

---
base-commit: fcc00b15cb21a6de76826e5012b2c758505f5e65
change-id: 20261029-b4-disp-da7f8e6a-17d150a54c95

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>



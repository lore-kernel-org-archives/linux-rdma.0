Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DAF550DBB;
	Tue, 13 Oct 2026 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924318; cv=none; b=g2n4n3FNEAyZzOsUntnYUB8Xoncr5OUSG/RfZLDVOi8q7qVoOZ6PdySYBp0TrIEBMZ+nGjcTamvixrM3e85ksSuybt8laDYwSBByNBF5Zo/W1QHg5b9MJQXoiJ6N3Dx08IGl53sX1Bn6bLehSJPqREHJiUkZ5iJcts7kfZsxvsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924318; c=relaxed/simple;
	bh=huCSS4Tn3b+URrBgBdZls2F1eQucxNwpSTS0uTbvdmk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=P6BcYEdQIR2Q1nnVgxKC1dV/uahl9FUreOs/qCAlLMIB6OOCdzHs6Ao1r8rHxZGjHvEJ1ZlLTbcHaB5uQDY2WdIrqWTX3Xe3x3DqG2oCn6BzJw7+b16+sTHBYp+4fIbzdB8q3yW2qlOqe0b1MrocqQHTxLxEDrm30oARCVcQxRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5cvPvER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5cvPvER"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAFD1C2BCFD;
	Tue, 13 Oct 2026 20:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791924318;
	bh=huCSS4Tn3b+URrBgBdZls2F1eQucxNwpSTS0uTbvdmk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=O5cvPvERQOxhrvWYJfMrBlspmZIHM1YG7N7JSq+0IwXHdHoNFS0DZqY6Bd6BgRFlk
	 M1xWS1wCt2E2iDfkXSP5MEhxJJUrNcfQuuNN4NbZacDahxly6ep9Rv7G1epJre3c16
	 aZz9h1X+BpmAjls6scKEEHaaYiqbodweEbr8cEhWaXz+0GtniHvz5cAPTgoYEqXtcD
	 PlTJASYijTuk2F+bXCTOihFdFtAj6ojwiKJFtFq1RuIxYr2/KXdvF6KjECMdGSEW4M
	 e8TdTknVLSG34GVwSh+yD2B2QxypDd4P1GJy6CvkKaFrpMchFuvC10A8BQUV19EG22
	 Fe8k3DjSkN6rw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65DCCC6B19;
	Tue, 13 Oct 2026 20:45:17 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Tue, 13 Oct 2026 15:45:17 -0500
Subject: [PATCH net] net/smc: don't spin in smc_rx_recvmsg() while a pipe
 holds spliced data
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQ6CMBAFf4Xs2U1oUWj9FeKhhSeuh0q6aEwI/
 26R40wys5IiC5Su1UoZH1F5pQLmVNHwCGkCy1iYbG1bU5uG45lH0ZmNb4INF88dXHSA64LzVLI
 54y7f/7KnhIVuh9R3fGJY9hlt2w+yHVz2eQAAAA==
X-Change-ID: 20261013-b4-disp-193a2a59-7e8b8ee87a89
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Wen Gu <guwen@linux.alibaba.com>, linux-rdma@vger.kernel.org, 
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791924317; l=6151;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=Iy2d1C/Hg2OiJemaCd9uiVk9it4ddmATnR6ptuuaBjQ=;
 b=HaMrotusNTBYx+btMXWAl7LIp8AlN5IFI6Z811T7SebxTu950vZjxLrLRc5iin4o4FW1OyijD
 MglvEOOIWOsAMpW+SbSzqBoUdUvJdd9y/KFWqv+jS5ALTeVF7/zWj8P
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

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
A zero-length read returns 0 without waiting for the pipe.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Repro on v7.3-rc6 with KASAN (its smc_rx.c is the same as net's),
SMC-D loopback, conforming peer: the reader splices 4096 bytes into a
pipe the test drains only after 3 s, the peer has sent more behind
them, and the reader calls recv(4096).

Unpatched, with SIGUSR1 pending, after SHUT_RD, after the peer's
SHUT_WR, or after the peer closed with data of ours unread (an abort,
sk_err ECONNRESET), recv() spins on a full CPU until the drain, and
SIGKILL doesn't stop it. MSG_DONTWAIT, a 1 s SO_RCVTIMEO and a
zero-length recv() don't return until the drain either.

Patched:
  - MSG_DONTWAIT gets -EAGAIN at once, SO_RCVTIMEO after 1042 ms; a
    signal gives -EINTR, or with SA_RESTART the handler runs and the
    call goes back to sleep; SIGKILL ends the task within 10 ms;
    recv(0) returns 0 at once;
  - after a shutdown or an abort the reader sleeps with no CPU, then
    gets the next 4096 bytes once the pipe is drained;
  - a MSG_WAITALL read that had copied 4096 bytes when another thread
    spliced in front of the rest returns those 4096 at the signal.

In every case the next recv() gets the rest of the stream intact. A
second splice(SPLICE_F_NONBLOCK), with the first undrained, still
returns the next 4096 bytes at once. Over SMC-R on rxe, starting rdma
link del on the reader's only RDMA device kills the connection
(SO_ERROR ECONNABORTED) and the reader returns 14 ms later, patched or
not. The patch gives the same results on top of [2]. No KASAN splat.
Dropping any one check from the patch makes one of the cases above
fail, except the !splice_pending condition, whose race no test can hit
on demand. Logs on request.

I checked that condition in a small state model of the reader, the
pipe release and smc_conn_kill() (atomic steps, sequentially
consistent, a blocking read): over every interleaving, with the
release in today's order or with splice_pending dropped under
lock_sock (2/4 of [2]; Hidayath said in [1] he would do the same),
the reader returns. In today's order the condition is needed: without
it the release's decrement and wake can land between the reader's
check and its add_wait_queue(), and the reader sleeps until something
else wakes the socket. Under LKMM, today's order allows a lost wake
even with the condition (no full barrier between add_wait_queue() and
the condition's read; smc_rx_wait() has the same gap), and the
reorder in [1] or [2] closes it for both. This patch doesn't depend
on that reorder.

For stable: in SMC_CLOSED, SMC_PEERFINCLOSEWAIT and SMC_APPFINCLOSEWAIT
the pipe release drops splice_pending only since c924884743e9
("net/smc: fix use-after-free in smc_rx_pipe_buf_release()"). Every
maintained stable from 6.1.y up has it. 5.10.y and 5.15.y don't (the
backports are posted, not released), and there a reader in those
states would sleep until a signal, its timeout or a kill instead of
spinning. The shutdown and abort cases above reach none of those
states.

[1] https://lore.kernel.org/all/7a174d1f-80d8-4294-ae66-829c9dacd662@linux.ibm.com/
[2] https://lore.kernel.org/all/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me/
---
 net/smc/smc_rx.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 197fddc6271f..6f409bda4c37 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -286,6 +286,22 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
 	return rc;
 }
 
+/* Wait until the pipe releases the spliced data. Unlike smc_rx_wait(),
+ * this does not end on shutdown or a socket error: the data to read is
+ * already in the RMB. smc_conn_kill() wakes the socket, and the caller
+ * checks conn->killed.
+ */
+static void smc_rx_wait_splice(struct smc_sock *smc, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct smc_connection *conn = &smc->conn;
+	struct sock *sk = &smc->sk;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_wait_event(sk, timeo, !atomic_read(&conn->splice_pending), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
+}
+
 static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 			   int flags)
 {
@@ -443,7 +459,24 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		/* could be just 1 byte, even after waiting on data above */
 		readable = smc_rx_data_available(conn, peeked_bytes);
 		splbytes = atomic_read(&conn->splice_pending);
-		if (!readable || (msg && splbytes)) {
+		if (msg && splbytes) {
+			/* a pipe still holds bytes ahead of these, and the
+			 * jumps to copy skip the timeout and signal checks;
+			 * a zero-length read returns 0 at once
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
base-commit: 513444cc62e231a11c9b15ea88de0890da9b2b4f
change-id: 20261013-b4-disp-193a2a59-7e8b8ee87a89

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>



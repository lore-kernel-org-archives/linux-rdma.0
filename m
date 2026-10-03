Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E32DB79F
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791052427; cv=none; b=nLeM95P/pOs7O9uH1tDAina7vfnGC7S8c6m6JbHt6Z+mbf+iDwvbQpMDK6W23vO2JerJVglwrn98OcUhX3beuvocdrlt2a98eTrDuyCcmZYg9aXDschH4yRUFRLRMf0lQpcJef5VpcA8OlhZ8PEBB35ljm7Ntc6Kzgyja+/hLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791052427; c=relaxed/simple;
	bh=UgOZ0GFL8cUJgtYosLRGRQWy7oMnRdA2GN6IgRIw/aI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lonbfDNRrNYZ7I/2/nPqbcKmMrMWI+wpWmZ7q8SgR0exILBdedviUKkTPoMpDnTV+y1iOhVtYxocgZYwWP3M7DL7KvtRcM+Q4MFwH2YLJ8K43OWAXJJ4Lt2hqLNeYWB6WfSGTEs6qbd1ILaK0hscY5ujtoGr5BC4Bdxsdyj51/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEGzxAZS; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEGzxAZS"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e79c06622so48946eec.3
        for <linux-rdma@vger.kernel.org>; Sat, 03 Oct 2026 11:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791052425; x=1791657225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+WzRfvLcRZ3DtTlJg9GdruORS24wuPjSqAyK7FdnxtI=;
        b=AEGzxAZSdx6poWSKgX8VOzHDAWFdojSXBh15aN/Lkb20fvg11Fm34ec+GdZoaQCi1G
         YFNCkZ6AlUXsNnpWAI9nLFAv/9DXWAooCUO95ppSn3X+L8xXKx/K2F1BydxGQyDCeDKm
         5VP3jwDIUXklZffb45uMT5H19O1orBMnpuWIRj4HQtCegGYWLzN8ux25Jk+3ZYFjg7v6
         rPDab1Ztt3pIuJpn+wnwKUDzXA8FTLxm+p385xatKNvOcYvRiZ67u4BNIwDYX2Oq20GX
         qmdq8jrgagIz1liMB6l/lI5j3bMAkyQmeCy5BIM7uHqnZqohyOE5ZvBe8irIYAxh2SDu
         pG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791052425; x=1791657225;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WzRfvLcRZ3DtTlJg9GdruORS24wuPjSqAyK7FdnxtI=;
        b=YpEnq2YAOCWhH8agUKudFTZEYSNFiVOPDteW0pRtDnmClMlX+F0XlLQZmk/Gs5GTsr
         +aO5b7TLavkG6Qfopqr1olWNm2xm7NzY1Lnyk7Ms5AzQo5SW27185kUM38lDTWZ6cXaw
         FJEJRPGdrtb0lAa/rsj22rBWVGi0NLS8maGokucE/NLuWGhAE5VnAjzBcHe8k/Ri1GtY
         ziQ5jQAUPbW/NfamapMxstbtCM0CarUyjcwTEh6gr3vCh+eWwUOx8m4UjQu2Wg/AkmDA
         MwUhlZ8b7/x6kVU6eSPOgelE0mHFYYUcaOJJp9t/NolPd+xXvbcT8J6gMGjY6vIYjofr
         x8MA==
X-Forwarded-Encrypted: i=1; AKwUvByf6I0F3OROUF++lKcrVXAXWezEUkqtTO8Ks1JRXrTIbKnalVLdwQqPGRW3dCuMzBz4pjtQUZfPZW3q@vger.kernel.org
X-Gm-Message-State: AFq9FYK3JKV18BOxu8hnMuYl5bz4FXjrhgKIL2Icgv4mysh4EP0AJgba
	dlUWHQGk2BbpNNwVNazwE6txjH636FY5RAa5szy/sOGIXB2d+YexXYO9
X-Gm-Gg: AYBFou1UtJdaOPsUHRgw3htUGLOtW0GTaD1QFuEn97K5k5i0gjLAQQdpuesHli9xdU7
	1XCTg6vqv2TXvOq5PKyZdoCVAkAk5KaCi17fdmjVesCt6nFgTzeoQ9cGUTGXRFaL7n24A/4fMtC
	sKPzcP7b5w0tiCFxfCORkURk41Sr9q7gx6sEXFmiW01e9sYVLvRmOPd7JT5kTYS09COTy7WmNnU
	UM+zPfl5WwsxR7Ku5g0ZhqBJfkMkkoXMllEC3/wjqrF+3qXU9ErVFaGVBPedGUQ+20223TRcVLa
	Hnu39YJhybBPvUG3PCfMBU4ys1nmYfIMNvsKqTr2r+yKM1SVUuR7MS8g6NQDY6aNPwfRLKwkpSp
	J9zJwQNonQeRU46e3pDrECnfrFQwQdoErv4/rAwJqroSMT+4v6EYt1uZ/R8PPeiYa44vd6bsPTO
	8HvpdfQIHgzOs+C2Y8uNmlvV9QDKuJKXispr3jhaG5wGRD0Uh97lz4zwDjvMQmfTiEls3t1UpWg
	8FxQ+igfVRPdnzXwMTyzeyngMirljmYTa2zULSxz73xoZV0mn5eRonB/75SY027jSF3Fw==
X-Received: by 2002:a05:693c:864b:10b0:33e:4e49:d08d with SMTP id 5a478bee46e88-3510d2815f3mr8300609eec.1.1791052424456;
        Sat, 03 Oct 2026 11:33:44 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3510d1575e1sm11191328eec.25.2026.10.03.11.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 11:33:44 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH net v2] net/smc: serialize clcsock access with its release
Date: Sun,  4 Oct 2026 02:33:25 +0800
Message-ID: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Link-group termination can release the CLC socket through
smc_close_active_abort() while the SMC socket is still open, for example
after shutdown(SHUT_WR). A file reference keeps the SMC socket alive but
does not prevent this asynchronous release of its CLC socket.

smc_getname() can race the pointer removal and sock_release(). The same
missing lifetime synchronization affects smc_set_keepalive(), diagnostic
address copying and an in-flight SMC-R CDC receiver. smc_shutdown() can
also reach its final CLC shutdown after its close helper drops the socket
lock and a concurrent abort closes the socket. Holding the SMC socket
lock alone is insufficient because CLC release runs outside that lock.

KASAN reported the getname failure:

  BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
  Read of size 8 at addr ffff888109abb4e0 by task poc/103
  Call Trace:
   smc_getname+0x19e/0x1b0
   do_getsockname+0xe5/0x170
   __sys_getsockname+0x8c/0x100

  Allocated by task 95:
   sock_alloc_inode+0x1e/0x280
   sock_alloc+0x3d/0x240
   __sock_create+0x7e/0x430
   smc_create+0x121/0x240

  Freed by task 0:
   kmem_cache_free+0xcc/0x340
   rcu_core+0x50a/0x1850

  Last potentially related work creation:
   evict+0x446/0x6c0
   smc_clcsock_release+0xa8/0xd0
   smc_close_active_abort+0x26a/0x3a0
   __smc_lgr_terminate.part.0+0x137/0x2e0

Hold clcsock_release_lock across getname, the final shutdown callback
and the TCP abort accesses, including dangling non-blocking connect
cleanup. Keep the peer state check and callback errors unchanged, and
return -EBADF from getname when the CLC socket is already gone.

CDC receive runs in BH context, and diagnostics hold the hash-table
read lock, so neither can use the mutex. Add a spinlock for these short
accesses and for keepalive, whose TCP callback does not sleep. Use it
for CLC pointer publication and detachment as well. Both release paths
detach under the spinlock and call sock_release() after dropping it,
while retaining the mutex to exclude sleeping readers. This protects
both the socket wrapper and its sk until each reader finishes.

Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6.1-Sol
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v2:
- Cover the other readers sharing the getname bug's asynchronous CLC
  release race, as identified by the public Sashiko review and source
  audit. These races predate v1; its getname fix did not introduce them.
- Cover keepalive, diagnostic and CDC readers with a BH-safe spinlock.
- Serialize pointer publication and both published CLC release paths;
  release the detached socket outside the spinlock.
- Protect the final shutdown callback and TCP abort readers with the
  release mutex, including dangling non-blocking connect cleanup.

v1: https://lore.kernel.org/r/20260926180404.2721010-1-nicoyip.dev@gmail.com/
Review: https://lore.kernel.org/r/179072681701.434549.13763000893839581310@kernel.org/

 net/smc/af_smc.c    | 46 +++++++++++++++++++++++++++++++++++----------
 net/smc/smc.h       |  7 ++++---
 net/smc/smc_cdc.c   |  2 ++
 net/smc/smc_close.c | 11 +++++++----
 net/smc/smc_diag.c  |  5 ++++-
 5 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..eab9c42dd3cb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -116,7 +116,10 @@ static void smc_set_keepalive(struct sock *sk, int val)
 {
 	struct smc_sock *smc = smc_sk(sk);
 
-	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
+	spin_lock_bh(&smc->clcsock_lock);
+	if (smc->clcsock)
+		smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
+	spin_unlock_bh(&smc->clcsock_lock);
 }
 
 static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
@@ -340,8 +343,12 @@ int smc_release(struct socket *sock)
 	old_state = sk->sk_state;
 
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && old_state == SMC_INIT)
-		tcp_abort(smc->clcsock->sk, ECONNABORTED);
+	if (smc->connect_nonblock && old_state == SMC_INIT) {
+		mutex_lock(&smc->clcsock_release_lock);
+		if (smc->clcsock)
+			tcp_abort(smc->clcsock->sk, ECONNABORTED);
+		mutex_unlock(&smc->clcsock_release_lock);
+	}
 
 	if (cancel_work_sync(&smc->connect_work))
 		sock_put(&smc->sk); /* sock_hold in smc_connect for passive closing */
@@ -409,6 +416,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 				      "sk_lock-AF_SMC", &smc_key);
 	spin_lock_init(&smc->accept_q_lock);
 	spin_lock_init(&smc->conn.send_lock);
+	spin_lock_init(&smc->clcsock_lock);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
 	smc->limit_smc_hs = net->smc.limit_smc_hs;
@@ -1787,7 +1795,9 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 			new_clcsock->sk->sk_error_report = lsmc->clcsk_error_report;
 	}
 
+	spin_lock_bh(&(*new_smc)->clcsock_lock);
 	(*new_smc)->clcsock = new_clcsock;
+	spin_unlock_bh(&(*new_smc)->clcsock_lock);
 out:
 	return rc;
 }
@@ -1825,6 +1835,7 @@ struct sock *smc_accept_dequeue(struct sock *parent,
 				struct socket *new_sock)
 {
 	struct smc_sock *isk, *n;
+	struct socket *clcsock;
 	struct sock *new_sk;
 
 	list_for_each_entry_safe(isk, n, &smc_sk(parent)->accept_q, accept_q) {
@@ -1833,10 +1844,14 @@ struct sock *smc_accept_dequeue(struct sock *parent,
 		smc_accept_unlink(new_sk);
 		if (new_sk->sk_state == SMC_CLOSED) {
 			new_sk->sk_prot->unhash(new_sk);
-			if (isk->clcsock) {
-				sock_release(isk->clcsock);
-				isk->clcsock = NULL;
-			}
+			mutex_lock(&isk->clcsock_release_lock);
+			spin_lock_bh(&isk->clcsock_lock);
+			clcsock = isk->clcsock;
+			isk->clcsock = NULL;
+			spin_unlock_bh(&isk->clcsock_lock);
+			if (clcsock)
+				sock_release(clcsock);
+			mutex_unlock(&isk->clcsock_release_lock);
 			sock_put(new_sk); /* final */
 			continue;
 		}
@@ -2784,6 +2799,7 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
 		int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2791,7 +2807,11 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
@@ -3003,8 +3023,10 @@ int smc_shutdown(struct socket *sock, int how)
 		/* nothing more to do because peer is not involved */
 		break;
 	}
+	mutex_lock(&smc->clcsock_release_lock);
 	if (do_shutdown && smc->clcsock)
 		rc1 = kernel_sock_shutdown(smc->clcsock, how);
+	mutex_unlock(&smc->clcsock_release_lock);
 	/* map sock_shutdown_cmd constants to sk_shutdown value range */
 	sk->sk_shutdown |= how + 1;
 
@@ -3353,10 +3375,11 @@ static const struct proto_ops smc_sock_ops = {
 int smc_create_clcsk(struct net *net, struct sock *sk, int family)
 {
 	struct smc_sock *smc = smc_sk(sk);
+	struct socket *clcsock;
 	int rc;
 
 	rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
-			      &smc->clcsock);
+			      &clcsock);
 	if (rc)
 		return rc;
 
@@ -3365,8 +3388,11 @@ int smc_create_clcsk(struct net *net, struct sock *sk, int family)
 	 * smc->sk is close()d, and TCP timers can be fired later,
 	 * which need net ref.
 	 */
-	sk = smc->clcsock->sk;
+	sk = clcsock->sk;
 	sk_net_refcnt_upgrade(sk);
+	spin_lock_bh(&smc->clcsock_lock);
+	smc->clcsock = clcsock;
+	spin_unlock_bh(&smc->clcsock_lock);
 	return 0;
 }
 
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 427b6d63b993..7c6d80e8c9c0 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -288,6 +288,7 @@ struct smc_sock {				/* smc sock container */
 		struct inet_sock	icsk_inet;
 	};
 	struct socket		*clcsock;	/* internal tcp socket */
+	spinlock_t		clcsock_lock;	/* protects non-sleeping users */
 	void			(*clcsk_state_change)(struct sock *sk);
 						/* original stat_change fct. */
 	void			(*clcsk_data_ready)(struct sock *sk);
@@ -325,9 +326,9 @@ struct smc_sock {				/* smc sock container */
 						 * flight
 						 */
 	struct mutex            clcsock_release_lock;
-						/* protects clcsock of a listen
-						 * socket
-						 * */
+						/* protects sleeping clcsock
+						 * users and serializes release
+						 */
 };
 
 #define smc_sk(ptr) container_of_const(ptr, struct smc_sock, sk)
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df321..7ccca35b7b71 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -414,8 +414,10 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 	}
 	if (smc_cdc_rxed_any_close_or_senddone(conn)) {
 		smc->sk.sk_shutdown |= RCV_SHUTDOWN;
+		spin_lock_bh(&smc->clcsock_lock);
 		if (smc->clcsock && smc->clcsock->sk)
 			smc->clcsock->sk->sk_shutdown |= RCV_SHUTDOWN;
+		spin_unlock_bh(&smc->clcsock_lock);
 		smc_sock_set_flag(&smc->sk, SOCK_DONE);
 		sock_hold(&smc->sk); /* sock_put in close_work */
 		if (!queue_work(smc_close_wq, &conn->close_work))
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bb0313ef5f7c..486e8b4c132f 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -28,11 +28,12 @@ void smc_clcsock_release(struct smc_sock *smc)
 	if (smc->listen_smc && current_work() != &smc->smc_listen_work)
 		cancel_work_sync(&smc->smc_listen_work);
 	mutex_lock(&smc->clcsock_release_lock);
-	if (smc->clcsock) {
-		tcp = smc->clcsock;
-		smc->clcsock = NULL;
+	spin_lock_bh(&smc->clcsock_lock);
+	tcp = smc->clcsock;
+	smc->clcsock = NULL;
+	spin_unlock_bh(&smc->clcsock_lock);
+	if (tcp)
 		sock_release(tcp);
-	}
 	mutex_unlock(&smc->clcsock_release_lock);
 }
 
@@ -130,11 +131,13 @@ void smc_close_active_abort(struct smc_sock *smc)
 	struct sock *sk = &smc->sk;
 	bool release_clcsock = false;
 
+	mutex_lock(&smc->clcsock_release_lock);
 	if (sk->sk_state != SMC_INIT && smc->clcsock && smc->clcsock->sk) {
 		sk->sk_err = ECONNABORTED;
 		if (smc->clcsock && smc->clcsock->sk)
 			tcp_abort(smc->clcsock->sk, ECONNABORTED);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
 	switch (sk->sk_state) {
 	case SMC_ACTIVE:
 	case SMC_APPCLOSEWAIT1:
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index bf0beaa23bdb..fe705f5143a0 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,8 +39,9 @@ static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 	memset(r, 0, sizeof(*r));
 	r->diag_family = sk->sk_family;
 	sock_diag_save_cookie(sk, r->id.idiag_cookie);
+	spin_lock_bh(&smc->clcsock_lock);
 	if (!smc->clcsock)
-		return;
+		goto out;
 	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
 	r->id.idiag_dport = smc->clcsock->sk->sk_dport;
 	r->id.idiag_if = smc->clcsock->sk->sk_bound_dev_if;
@@ -55,6 +56,8 @@ static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 		       sizeof(smc->clcsock->sk->sk_v6_daddr));
 #endif
 	}
+out:
+	spin_unlock_bh(&smc->clcsock_lock);
 }
 
 static int smc_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
-- 
2.43.0

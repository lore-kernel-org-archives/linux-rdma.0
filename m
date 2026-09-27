Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5733BFE2F
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 07:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495494; cv=none; b=b/FluHgAI+PcIkw9YgsfdSYghQaG3ht7FJOri7PBucbUnJhFOohAAab3GjhCxKEc/XTnA5dz5iLfFDOSUHKP3aSF304XKWoQgb/xM4rNOTpN1oB8ScwrO2wx2z7goNlldWWjpzd1y8+k3vBnPj0o9COxYViyVqI9EAxtZwccyHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495494; c=relaxed/simple;
	bh=dlod1CpWCqRLRGZdexHX97cGGQWxbZmQMIDU5wgRoU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G+sJN81zPsbqAdk/LL2Z5OiSM3aFjw97hsNcapNhrhdWM1VGRLQdVN+6kcRjeZfpdOU7J4S5JM7BmI9Um8DeOQAUNbcbgPMds3qKwcgkbAqHs3FNo3L5KCxDK2JtPVreI2M7hbQwP5Vjez6HDpVpqsepLFzBgPRHeI6W5HOtrXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6dtL95l; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6dtL95l"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3427977d677so146509eec.0
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 00:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790495489; x=1791100289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ww6aqGhJtBvyRvMZDM65zhE1MjD4RPJH9QsBDwHkn30=;
        b=s6dtL95lnEQD1T93TXEtIX3bzEzxyPks9PH5j1pAZYi07gxwdZXkJobWnV+nLcxxfE
         UwFT8ax4js4sYgTC+G5gOVOc0yN6bzquIMUqzOkmIRRHHMuNQeb+pWjXh7NzTZjo+wLW
         UeZhmMMkapjnBsaRGUYAdYwrYqo8DLJYYgnWtpQi2ceJgbcwytOEoXtRQ8DB7E0WprTN
         BsWij6zbRv4kqhd4cVJuRSWshZqeul0Ijzk6Wo6gVUzV7/aypMQ55whLA4oahik8bJ3n
         N9wAsxVcEv5HJZ6Re+jkZTF9LTm3GP5a7ny78nnQv6iNYdKXoCnrd76gKwu9X+FYrwtX
         lXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790495489; x=1791100289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ww6aqGhJtBvyRvMZDM65zhE1MjD4RPJH9QsBDwHkn30=;
        b=JQF9SS6K3tIeiZFVhS5CZy1dtdMCNVsrt0gs61IpT/JTJzGdzotsUx96qLWm+gBZpk
         d2WkfL19EHQtH6u9KRVqiYh3ValWCvpIbFvXBrEZ6yNF/2iwRV7vICC17m9k/sNJeWfC
         uvihwfiQbAaC8ll9J/0luVUzB1hqchEyCxEL1D1U8n/i7R6UOYX208s9lUe5fAhP6xPl
         JrnByXCFJpFwxxyhPnGLEW7Futt9sd9SModUk0vluX4xJUwmZhxjUHcUeUlDXnAAdzhQ
         gCZihPN0e/9eNhPMzL7VLNZQUnOA+23qmZvQPdqzU1n7Er54R6XHLfAvH/4R4swkhPxg
         7kpg==
X-Gm-Message-State: AFq9FYJRVf4QuAhe9ItwCiJNwYXi06pRTKpzqPNdK5LDrU59F4M1h/ZW
	4+y4/AojPCqmsP6iKze9HphAmwEWREW5F+kqdCnuvqKlEdS/BOLLmthH
X-Gm-Gg: AYBFou1jvjR5iQ1WiAn4xyonTvso9r34O3uXZW8qEeBl/sQRYupJmKmkIigC9kLAJIp
	MRq2Nnhjjz+qcSMkti/elXT+HoLEfjSegwlDw1VwB4T0dCzgcWpoR4/Wg1Era28fxRQEHhLh+EA
	3bA33q4GlbwwuJ0Z5SC9aeFXqww3QiVW+fAJV2nCUsMhgTiOIqGJ9UplP8Op8yCS1jlclvVhWt0
	HaY+X/CMZuxjaLYOHW1sIvPrk4xYpczp2q5jWt0TpLQ3xIWCOIbzHlQ4RPYI5gXImoeRYREDrVo
	4wRL4a/3me1wciEyFBXbf84Rk3LxGc8Jh6ya3e6uOHEUYYRSms04Zalk7R6mfJmyyORyMC7cfGN
	L948huApNcYUvRQ+L7sQFIFbQMVHOI2swDkEDUf9W5pZhySx4DO3Op16eb8zNWVLg8lRYRZ2d8d
	hrMTygVYv3MRQUKfY+Bw+LXPJTOjQRZytXYOBJRRa2OGR2zFLLu+l5vzOpSkL997bk4lfImXL/z
	OUUn11XiUXX4+bhzd03RVlOAX/l724icYkBeg+EHJZTV8fqM0nUlk8OUdoC5KJIimfVjFp5xoSn
	1BbA
X-Received: by 2002:a05:7301:540e:b0:33c:1bd2:1db6 with SMTP id 5a478bee46e88-3426d0df371mr8407759eec.0.1790495488467;
        Sun, 27 Sep 2026 00:51:28 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3414504fae2sm20464916eec.20.2026.09.27.00.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 00:51:27 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net/smc: Hold a socket reference for transmit work
Date: Sun, 27 Sep 2026 15:51:20 +0800
Message-ID: <20260927075120.3695060-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMC transmit work is queued without holding a socket reference. After
an active close has cancelled tx_work, a received CDC message can queue
it again while the socket is in SMC_PEERCLOSEWAIT1. Passive close can
then reach SMC_CLOSED, call smc_conn_free() and drop the last socket
reference before smc_tx_work() acquires the socket lock. The worker
then accesses the freed socket.

KASAN reported:

  BUG: KASAN: slab-use-after-free in lock_sock_nested+0x97/0x180
  Write of size 8 by task kworker/0:1/11
  Workqueue: smc_tx_wq-00000000 smc_tx_work
  Call Trace:
   lock_sock_nested+0x97/0x180
   smc_tx_work+0x5d/0x170
   process_one_work+0x5ce/0xeb0
   worker_thread+0x45b/0xd10

  Allocated by task 24:
   sk_prot_alloc+0x56/0x210
   sk_alloc+0x2b/0x6f0
   smc_tcp_listen_work+0x16d/0xfc0

  Freed by task 182:
   slab_free_after_rcu_debug+0xa6/0x1e0
   rcu_core+0x509/0x1850

Hold a socket reference for each successful enqueue and release it when
the worker finishes or a pending invocation is cancelled. Cover all three
queue sites and all cancellation sites, including the socket options.
Check conn->freed in smc_tx_pending() under the socket lock: retaining the
socket does not retain connection resources released by smc_conn_free().
This also covers pending transmit processing from smc_release_cb().

Use queue_delayed_work() for the busy-slot retry as well. All tx_work
delays are zero, so an already queued invocation needs no timer update.
Unlike mod_delayed_work(), its return value distinguishes a successful
enqueue from work disabled temporarily by cancel_delayed_work_sync(),
allowing the extra reference to be returned when no work was queued.

Fixes: e6727f39004b ("smc: send data (through RDMA)")
Cc: stable@vger.kernel.org
Link: https://lists.openwall.net/netdev/2026/09/09/105
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/smc/af_smc.c    |  6 ++++--
 net/smc/smc_close.c | 18 ++++++++++++------
 net/smc/smc_core.c  |  4 +++-
 net/smc/smc_tx.c    | 18 +++++++++++++-----
 4 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..7ebd51f922aa 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3141,7 +3141,8 @@ int smc_setsockopt(struct socket *sock, int level, int optname,
 			if (val) {
 				SMC_STAT_INC(smc, ndly_cnt);
 				smc_tx_pending(&smc->conn);
-				cancel_delayed_work(&smc->conn.tx_work);
+				if (cancel_delayed_work(&smc->conn.tx_work))
+					sock_put(sk);
 			}
 		}
 		break;
@@ -3152,7 +3153,8 @@ int smc_setsockopt(struct socket *sock, int level, int optname,
 			if (!val) {
 				SMC_STAT_INC(smc, cork_cnt);
 				smc_tx_pending(&smc->conn);
-				cancel_delayed_work(&smc->conn.tx_work);
+				if (cancel_delayed_work(&smc->conn.tx_work))
+					sock_put(sk);
 			}
 		}
 		break;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bb0313ef5f7c..a8d4b4b65f24 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -118,7 +118,8 @@ static void smc_close_cancel_work(struct smc_sock *smc)
 	release_sock(sk);
 	if (cancel_work_sync(&smc->conn.close_work))
 		sock_put(sk);
-	cancel_delayed_work_sync(&smc->conn.tx_work);
+	if (cancel_delayed_work_sync(&smc->conn.tx_work))
+		sock_put(sk);
 	lock_sock(sk);
 }
 
@@ -230,7 +231,8 @@ int smc_close_active(struct smc_sock *smc)
 	case SMC_ACTIVE:
 		smc_close_stream_wait(smc, timeout);
 		release_sock(sk);
-		cancel_delayed_work_sync(&conn->tx_work);
+		if (cancel_delayed_work_sync(&conn->tx_work))
+			sock_put(sk);
 		lock_sock(sk);
 		if (sk->sk_state == SMC_ACTIVE) {
 			/* send close request */
@@ -264,7 +266,8 @@ int smc_close_active(struct smc_sock *smc)
 		if (!smc_cdc_rxed_any_close(conn))
 			smc_close_stream_wait(smc, timeout);
 		release_sock(sk);
-		cancel_delayed_work_sync(&conn->tx_work);
+		if (cancel_delayed_work_sync(&conn->tx_work))
+			sock_put(sk);
 		lock_sock(sk);
 		if (sk->sk_state != SMC_APPCLOSEWAIT1 &&
 		    sk->sk_state != SMC_APPCLOSEWAIT2)
@@ -372,7 +375,8 @@ static void smc_close_passive_work(struct work_struct *work)
 		/* peer has not received all data */
 		smc_close_passive_abort_received(smc);
 		release_sock(sk);
-		cancel_delayed_work_sync(&conn->tx_work);
+		if (cancel_delayed_work_sync(&conn->tx_work))
+			sock_put(sk);
 		lock_sock(sk);
 		goto wakeup;
 	}
@@ -462,7 +466,8 @@ int smc_close_shutdown_write(struct smc_sock *smc)
 	case SMC_ACTIVE:
 		smc_close_stream_wait(smc, timeout);
 		release_sock(sk);
-		cancel_delayed_work_sync(&conn->tx_work);
+		if (cancel_delayed_work_sync(&conn->tx_work))
+			sock_put(sk);
 		lock_sock(sk);
 		if (sk->sk_state != SMC_ACTIVE)
 			goto again;
@@ -475,7 +480,8 @@ int smc_close_shutdown_write(struct smc_sock *smc)
 		if (!smc_cdc_rxed_any_close(conn))
 			smc_close_stream_wait(smc, timeout);
 		release_sock(sk);
-		cancel_delayed_work_sync(&conn->tx_work);
+		if (cancel_delayed_work_sync(&conn->tx_work))
+			sock_put(sk);
 		lock_sock(sk);
 		if (sk->sk_state != SMC_APPCLOSEWAIT1)
 			goto again;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9974149659c2..6021322253e9 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1070,7 +1070,9 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	    smc->sk.sk_state != SMC_CLOSED) {
 		rc = smcr_cdc_msg_send_validation(conn, pend, wr_buf);
 		if (!rc) {
-			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work, 0);
+			sock_hold(&smc->sk);
+			if (!queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work, 0))
+				sock_put(&smc->sk);
 			smc->sk.sk_data_ready(&smc->sk);
 		}
 	} else {
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3144b4b1fe29..c5c00c63ce4c 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -570,8 +570,10 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 			if (conn->killed)
 				return -EPIPE;
 			rc = 0;
-			mod_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
-					 SMC_TX_WORK_DELAY);
+			sock_hold(&smc->sk);
+			if (!queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
+						SMC_TX_WORK_DELAY))
+				sock_put(&smc->sk);
 		}
 		return rc;
 	}
@@ -667,7 +669,7 @@ void smc_tx_pending(struct smc_connection *conn)
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	int rc;
 
-	if (smc->sk.sk_err)
+	if (smc->sk.sk_err || conn->freed)
 		return;
 
 	rc = smc_tx_sndbuf_nonempty(conn);
@@ -690,6 +692,7 @@ void smc_tx_work(struct work_struct *work)
 	lock_sock(&smc->sk);
 	smc_tx_pending(conn);
 	release_sock(&smc->sk);
+	sock_put(&smc->sk);
 }
 
 void smc_tx_consumer_update(struct smc_connection *conn, bool force)
@@ -718,8 +721,13 @@ void smc_tx_consumer_update(struct smc_connection *conn, bool force)
 			return;
 		if ((smc_cdc_get_slot_and_msg_send(conn) < 0) &&
 		    !conn->killed) {
-			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
-					   SMC_TX_WORK_DELAY);
+			struct smc_sock *smc =
+				container_of(conn, struct smc_sock, conn);
+
+			sock_hold(&smc->sk);
+			if (!queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
+						SMC_TX_WORK_DELAY))
+				sock_put(&smc->sk);
 			return;
 		}
 	}
-- 
2.43.0


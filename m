Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E032F84F;
	Tue,  6 Oct 2026 07:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272167; cv=none; b=Qmyp0kJFqJHLNV1lOhJMObE3LqR2B4TXhKx6MuE3LNBZKM+RBrNyRRCGld/ULnfmyPz7ygQhKxKF1hBoz7bWcde538SRYlnUe+WCKOctbKwGIM2jpBmE+K+LO6D/lV7IKCodXJTb/Yse1MrZ7jjX9AIPB9yBnXmrR8HmHZtjK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272167; c=relaxed/simple;
	bh=BcRXb4BgGzM4LjZD4I2U751UyfN2cGTEUSDlKE8Y+Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dTmeSYhj6Gnw9OhrEXmbRnnb1dJk5eWJq5W7Wl8wldxM7ia3SPEoyG8aoZBX0iMqZ4Lji/rnACmghE8xirA07CxwrtqRXUG8Sa2+FriKSbls4Nm5RO3ulp9xtQ0FRnEL+nXXN4cm9gf0vpa96K3L7MRrWsarcQhNX1gcWOucNss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CiFOMSN9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CiFOMSN9"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6966bV3s2992246;
	Tue, 6 Oct 2026 07:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=X5kfbq34nGEmHpGxQcP0OoNsKglv0wOj9pI2h7BFs
	wA=; b=CiFOMSN9EJoOGw0+nC+GbX/QjdIKIoeaGwSGUVRUR4FiFY9rKxtszB8X8
	4UU1cSIadsq0J77+LmS8sL2S0X3QIHs7/8VVvsmYkaBQD+rMy8fM46XuMusHBm0g
	QaAF4m+asUGiTJlYYB1bwDuOaq6T0x/iffmVHc4jXj8kFquWSfuqBYmRI6xFDT2i
	hWp7MDCjG6oT3w+YbT9w7lv4R65eFu39LUXLwJYv+wIzzNXI85FQOLEJ5DJ1+XD5
	daQtdkD/4cI9s7I83r5Q2fB0jJj0R/VL5xfM8eoiNvbPiDsG0b8vFfaw/X0LzqY7
	1Ynu0fR0bT+y2nDMCbuL3xLlx/pAw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2s74pqxd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 07:35:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6966lYHA4106906;
	Tue, 6 Oct 2026 07:35:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h3c1ps4jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 07:35:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6967Zpi456295696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Oct 2026 07:35:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E5BD2004E;
	Tue,  6 Oct 2026 07:35:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D8DC2004D;
	Tue,  6 Oct 2026 07:35:50 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Oct 2026 07:35:50 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, hidayath@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net v3] net/smc: fix abort_work termination in smc_conn_free()
Date: Tue,  6 Oct 2026 09:35:50 +0200
Message-ID: <20261006073550.1595003-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: TvHRDvYWTpCwSVMUAqBoWP2M2EtAXSoe
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAzMCBTYWx0ZWRfXz7RHXW78LBa/
 7WI/71uJ5miw5KGgR0nkhstFgV6GWBWJynefH+o0SX1Fc69kVv2SP/ylTq/FJBkiqlWSsO3lkN+
 2+UaeJ3RJEtHxNUFUy4ZmSVLlRgcu8k=
X-Proofpoint-GUID: o_4vsL7lLno1qJJ3VL370zAE9b3B6mIJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAzMCBTYWx0ZWRfX5sim1I4Lg4hm
 UcFJVrB6F6TYZ6cg/pPj4owsa65AexnLc/uOyTFKEgAGEiRvI+SP53aGS7gQp6B6oU/jjCSciMC
 o0ZKMUHaQ9OPvHhnjG+8f7PdhU6ewMns7VLteNS/ZxYmisBXVSSab25Ppm2zOoil4ZNc7mBsgfX
 cXtB0wyXu7zNvxGeIT+V6ghSoguLPhvOXOnAOn509pwxUv0Sao9cRzOlvvu6HPskbcAI/9WcmwX
 h0ipRUGELfToetYKjCnD6TOszIVb44B+2PPjv3+sw5cWNzibGLvBa21E3E4n4z3gZTfS1hdnUFy
 96851qXJkKwQBHeWINoT7s/74nRtLi7Zq0nlpM98vMBZpSivjJXz0He4F3l4Wx+WTWQR0iLWsOn
 ZTkQZsAz1KycGAkxJCnlk2+bCMNPx0HhezqAlNnVWDevTZVbz3mHY/5NnRtf14M00lperosZp7q
 jn0/eUFPuuwz6ps6xlQ==
X-Authority-Analysis: v=2.4 cv=fM2sTpae c=1 sm=1 tr=0 ts=6ac4a4dc cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ii6Q-fC3ctQ2JV946WIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_02,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060030

smc_conn_free() cancels a pending conn->abort_work, and that cancel is
wrong in three ways.

It deadlocks. smc_conn_free() runs with the socket lock held, and
smc_conn_abort_work() takes the same lock, so cancel_work_sync() against an
instance that has already started waits for a worker that is waiting for
the caller.  The current_work() test only stops the work cancelling itself.
The lock cannot simply be dropped around the cancel either: several
smc_conn_abort() paths hold smc_client_lgr_pending or
smc_server_lgr_pending, which is taken after the socket lock, and
release_sock() on an SMC socket runs smc_release_cb(), which can post from
conn->sndbuf_desc again.

It leaks a socket reference. Schedulers of abort_work take one and
smc_conn_abort_work() returns it when it runs, so an item that
cancel_work_sync() removes before it runs never gives its reference back.

It does not stop the work being queued again. smc_cdc_rx_handler() takes
its socket reference and leaves lgr->conns_lock before
smc_cdc_msg_validate() decides to queue, so a receiver already past that
unlock can queue after the cancel has returned. cancel_work_sync() only
promises that the work is neither pending nor running when it returns.

Make the work harmless first: smc_conn_free() sets conn->freed with the
socket lock held and before it releases anything, and the work takes the
same lock, so testing the flag there is exact. An instance that is running
is parked on that lock and will find the flag set; an instance queued
afterwards finds the same.

The cancel can then be asynchronous. cancel_work() never waits, so the
deadlock is gone and the socket lock is never dropped, and returning the
reference when it reports that it removed a pending item fixes the leak.

Testing the flag also covers the early exit that no cancel ever reached.
conn->freed is set before the smc_conn_lgr_valid() test, so the goto
lgr_put path is covered too. That path is taken when smc_conn_kill() has
already unregistered the connection and then reaches smc_conn_free()
through smc_close_active_abort(); __smc_lgr_terminate() goes on to
smc_lgr_free(), whose smc_lgr_put() can drop the last reference and
kfree() the link group, while a queued abort_work would still have
dereferenced conn->lgr in smc_conn_kill().

Finally, move INIT_WORK() out of smc_conn_create(). abort_work is the only
per connection work item initialised per connection rather than once per
socket, and that asymmetry is what makes the cancel above have to reason
about re-initialisation at all: smc_listen_find_device() creates a
connection once per device it tries, so a socket can run INIT_WORK() on
this work item several times. Initialise it where tx_work and close_work
are already initialised, and the work item's lifetime matches the socket's.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
v3:
- Keep the socket lock held continuously during smc_conn_free() instead of
  dropping it. Dropping the lock in v2 had two issues:
  1. Inverted lock ordering: smc_conn_abort() runs inside
     smc_{client,server}_lgr_pending on listen/connect paths, so releasing
     the socket lock violates the socket lock -> mutex hierarchy.
  2. Spurious TX posting: release_sock() invokes smc_release_cb(), which
     can trigger smc_tx_pending() and post from conn->sndbuf_desc after
     the drain and buffer release.
- Switch from cancel_work_sync() to non-blocking cancel_work():
  - If the work was pending, drop its socket reference immediately.
  - If the work is already running, it waits on our socket lock and will
    safely no-op upon seeing conn->freed once the lock is released.
- Move INIT_WORK() from smc_conn_create() to smc_sk_init() so the work item
  is initialized once per socket lifetime, avoiding re-initialization races
  across multiple device searches in smc_listen_work().
- Document the socket lock requirement in smc_conn_free().
- Dropped Reviewed-by tag due to substantial implementation changes.

v2:
- Extended the fix to cover the deadlock and racing enqueue issues flagged
  during v1 review.
- Moved the cancel into a helper smc_conn_cancel_abort_work() that drops
  the socket lock around cancel_work_sync().
- Added a check for conn->freed under lock_sock in smc_conn_abort_work() to
  safely handle late-queued work items without fragile reordering.
- Updated patch subject to reflect the broader termination fix.
  Link: https://lore.kernel.org/netdev/20260806081549.595001-1-hidayath@linux.ibm.com/

 net/smc/af_smc.c   |  1 +
 net/smc/smc_core.c | 25 +++++++++++++++++++------
 net/smc/smc_core.h |  1 +
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..5b1bee22fc59 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -404,6 +404,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 	INIT_WORK(&smc->tcp_listen_work, smc_tcp_listen_work);
 	INIT_WORK(&smc->connect_work, smc_connect_work);
 	INIT_DELAYED_WORK(&smc->conn.tx_work, smc_tx_work);
+	INIT_WORK(&smc->conn.abort_work, smc_conn_abort_work);
 	INIT_LIST_HEAD(&smc->accept_q);
 	sock_lock_init_class_and_name(sk, "slock-AF_SMC", &smc_slock_key,
 				      "sk_lock-AF_SMC", &smc_key);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9974149659c2..907530e1d646 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1251,9 +1251,13 @@ static void smc_buf_unuse(struct smc_connection *conn,
 	}
 }
 
-/* remove a finished connection from its link group */
+/* remove a finished connection from its link group.
+ * Must be called with the socket lock held: conn->freed is what disarms
+ * a pending or running abort_work, and both are set and tested under it.
+ */
 void smc_conn_free(struct smc_connection *conn)
 {
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	struct smc_link_group *lgr = conn->lgr;
 
 	if (!lgr || conn->freed)
@@ -1276,8 +1280,13 @@ void smc_conn_free(struct smc_connection *conn)
 			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
-		if (current_work() != &conn->abort_work)
-			cancel_work_sync(&conn->abort_work);
+		/* Do not wait here: the work takes the socket lock this
+		 * caller holds. An instance that is already running is
+		 * parked on that lock and will find conn->freed set; only a
+		 * still-pending one has to give its reference back.
+		 */
+		if (cancel_work(&conn->abort_work))
+			sock_put(&smc->sk);
 	}
 	if (!list_empty(&lgr->list)) {
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
@@ -1742,7 +1751,7 @@ void smcr_lgr_set_type_asym(struct smc_link_group *lgr,
 }
 
 /* abort connection, abort_work scheduled from tasklet context */
-static void smc_conn_abort_work(struct work_struct *work)
+void smc_conn_abort_work(struct work_struct *work)
 {
 	struct smc_connection *conn = container_of(work,
 						   struct smc_connection,
@@ -1750,7 +1759,12 @@ static void smc_conn_abort_work(struct work_struct *work)
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
 	lock_sock(&smc->sk);
-	smc_conn_kill(conn, true);
+	/* smc_conn_free() sets freed with this lock held and before it
+	 * releases anything, so an instance that was queued or parked by
+	 * then has nothing left to do.
+	 */
+	if (!conn->freed)
+		smc_conn_kill(conn, true);
 	release_sock(&smc->sk);
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }
@@ -2059,7 +2073,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
 	conn->urg_state = SMC_URG_READ;
 	init_waitqueue_head(&conn->cdc_pend_tx_wq);
-	INIT_WORK(&smc->conn.abort_work, smc_conn_abort_work);
 	if (ini->is_smcd) {
 		conn->rx_off = sizeof(struct smcd_cdc_msg);
 		smcd_cdc_rx_init(conn); /* init tasklet for this conn */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 5c18f08a4c8a..52e3ba9f6d69 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -596,6 +596,7 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini);
 
 void smc_conn_free(struct smc_connection *conn);
+void smc_conn_abort_work(struct work_struct *work);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_core_init(void);
 void smc_core_exit(void);

base-commit: a3726256fa7e8ad8a3ee4855cedc7a762e5d8252
-- 
2.52.0


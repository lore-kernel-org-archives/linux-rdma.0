Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B724B0498;
	Tue,  8 Sep 2026 09:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859392; cv=none; b=QX5gY19EKG2BRm+sGfzUwSN7n88AbUVKxBwsTrNnQdeihd+msEom82Om4Y5UV3JSQgaO9mcZqurmnnsw9vEU3mlgBYbjQAiH1W3rLtxD0MyrgYHLiJv3WC5SmA7oWmYlL4a/X82zRNeYRKIDfhE5h4GV+vYIJkkcbyff4Ki4C8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859392; c=relaxed/simple;
	bh=i/GI2R0kd1CVpJlWX/yiZQi5V2+wB6ixZSZQiNPQdT8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MvKG0NlEMf7lpDQ0cWSFE7t5EtrbjBRaLWCnabLZJP9juByCLVKsfPMtU5Nr3K7pptNHY0d/4+uHnGwxU3eYB97x7Ay8OZMX6XOZ4AkKDUi0YsirWgpDxqYVAczovG1EcX1K2yzG7S53AQ3sud1clsheHhONtWUIyj+4GG9cO8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ofIa+itA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ofIa+itA"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6886VXg34125339;
	Tue, 8 Sep 2026 09:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=mS9e0xT5mcwrOA87PaxxeFNdOnTjDOlBb+fWt4HYX
	Y8=; b=ofIa+itA/yEpx8c75SUi0/YmXa7+1k51ZCsMypXIrrdEAK/0qyM3qaHQU
	GiarBHDwI1zjWma2aMIT9mFACtQ6zIflbEJ439tRKl8/GkoDM9YtdVrmRb3E8593
	rw1rf7wEUuU4YRE2uXLms4K9PRychYmUZuKcgufvXDd6nP/D8BRDqZbt5rYDNWCV
	mae/Q1dZrA9VUjWGXv6coRQrx3rLWQ8MqpdLnk/gaqlxg1ghhvSTMYt6l0qspOkK
	Ytg8voT2ZLRByzGELwS7BsTtBKTFFV57B8JxVjsO85CM1y0ZvONOBxYygaPoRoYq
	lxsKykhm7i6mf5YxInRo1+PS6aY6A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbj85njr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 09:23:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6889BHiL030682;
	Tue, 8 Sep 2026 09:23:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwh2tqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 09:23:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6889MvpB44630458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 09:22:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C5672004B;
	Tue,  8 Sep 2026 09:22:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D189520043;
	Tue,  8 Sep 2026 09:22:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  8 Sep 2026 09:22:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id B896E160E25; Tue, 08 Sep 2026 11:22:56 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hidayath@linux.ibm.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v3] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Tue,  8 Sep 2026 11:22:52 +0200
Message-ID: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 6vKcp2BlReI_DphWAd8dXL1kccoRN6_r
X-Proofpoint-ORIG-GUID: VR7QYvXtEk3u-siCrTjB_0u8qsBmfMF8
X-Authority-Analysis: v=2.4 cv=RNCD2Yi+ c=1 sm=1 tr=0 ts=6a9fd3f6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=1D_QaxW2Y1NEVYoI354A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDA5NCBTYWx0ZWRfX9AWlNC1izf4G
 EAWdcjCdqkd0hvlJeuaHqjFr7gIZ0U4VUUX6XhCpGdUGz8D7IkO1HB3Pdcp7DiRFPkvtFyswAL+
 UIefKTRmmqlw+6t/moTE/2jF4O1Kbm8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDA5NCBTYWx0ZWRfX6r+klDav+Ww/
 EfsaDVMbI2FVjeVGjNi1F2G6zFT2PZXNzAalVve8QrgH3V3xj/uq69fewJWuXnoHFDTmEYpWRPb
 78dArT2JM42xLFs46NsQBlzNKDbbTZmbaLidISIvOpah77IyPL+RprLPdqGQEjIdGwP9FzuR9rG
 R7+x/EOcN+lSnq9Hf52j5UQBKAL0uJNMG2+nInB7ycN09MDVxOOf5QJa3mWXS9T+LyfAjmznvdA
 Eh4muUHhqMkSFHotE/+QBK0Ij0YAQyHjf43iwAHPGUmlVtjgMHk4haXc/2Z2MgHvRIGPZrb/rs+
 m/dhtHroW72bZFRzKQJOjVwaTAbS7nqvtmPsm1+UDWnpyk8/63kQ17bzUEwUZSI5Hs6vqtbU+2M
 rje50YSMIM5IdYr73RWKah33UoX5XslkvqY+UJ8OC44/+SPZAW913uUvIs9NQMQekNQouh8x5gf
 SFiQBYiTY1/9Gm7Kjtg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_01,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080094

The SMC diag dump path reads conn->lgr and conn->lnk while iterating the =
socket
hash table under a read_lock.  Concurrently, RDMA link failure teardown
(__smc_lgr_terminate -> smc_conn_kill -> smc_close_active_abort ->
smc_conn_free) and the passive close workqueue path (smc_close_passive_wo=
rk ->
smc_conn_free) can drop the connection-owned references to lgr and lnk wh=
ile the
socket is still visible in the hash, allowing the diag reader to derefere=
nce a
freed lgr or lnk.

Fix this by ensuring that for all non-fallback paths the socket is remove=
d from
the hash table before the lgr/lnk references are dropped in smc_conn_free=
().

Introduce smc_conn_unhash() with a per-connection 'unhashed' flag so that=
 the
unhash executes exactly once regardless of which path reaches smc_conn_fr=
ee()
first.  smc_conn_free() calls smc_conn_unhash() before the lgr_put/link_p=
ut
sequence, establishing the invariant: any socket still visible to the dia=
g
reader under the hash read_lock has valid conn->lgr and conn->lnk pointer=
s.

__smc_release() is updated to use smc_conn_unhash() for non-fallback sock=
ets (so
the flag is honoured when smc_conn_free() already ran, e.g.  via smc_conn=
_kill()
ahead of the user-space close()), and keeps the direct sk->sk_prot->unhas=
h()
call only for fallback sockets, which never call smc_conn_free().

The diag path therefore reduces to:
  hold hash read_lock -> read conn->lgr -> if non-NULL, dereference -> do=
ne
with no new lock, no extra reference count, and no trylock.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v3:
- redesigned as a single patch; dropped the lgr_lnk_lock spinlock
  approach and the 2-patch split
- fix is now at the socket hash layer: introduce smc_conn_unhash() with
  a per-connection unhashed flag; smc_conn_free() unhashes before droppin=
g
  lgr/lnk refs, so any socket visible to the diag reader under the hash
  read_lock has valid conn->lgr and conn->lnk pointers
- __smc_release() updated to call smc_conn_unhash() for non-fallback
  sockets so the flag is honoured when smc_conn_free() already ran first
- smc_diag.c needs no changes; the hash read_lock invariant is
  sufficient without any per-connection lock in the dump path
- dropped the clcsock/mutex_trylock fix as that will be addressed separat=
ely

Changes in v2:
- this is v2 of the 2-patch series; the earlier submission was mislabelle=
d
  [PATCH v3] but was in fact the first version sent to the list
- split into a 2-patch series; patch 1/2 adds per-connection lgr_lnk_lock
  infrastructure to smc_core, patch 2/2 fixes the diag dump path using it
- dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held the
  socket lock across all lgr/lnk dereferences, requiring the hash read_lo=
ck
  to be dropped and re-acquired around each socket
- dropped the restart-from-head loop in smc_diag_dump_proto(); the new
  design does not drop the hash read_lock mid-walk so the hlist truncatio=
n
  concern no longer applies
- dropped refcount_inc_not_zero() socket pinning from the dump loop for t=
he
  same reason: the hash read_lock is now held for the full walk
- added per-connection lgr_lnk_lock spinlock to struct smc_connection;
  conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
  before borrowed references are released, establishing the invariant: a
  non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
- added lgr_lnk_lock to smc_switch_link_and_count() to protect the conn->=
lnk
  pointer swap from concurrent diag readers
- replaced mutex_lock() on clcsock_release_lock in smc_diag_msg_common_fi=
ll()
  with mutex_trylock(); mutex_lock() was valid in v1 because the hash
  spinlock had been dropped, but the new design holds the hash read_lock
  throughout so only a non-sleeping trylock is safe; a failed trylock lea=
ves
  address fields zeroed, which is acceptable for a monitoring tool
- all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
  snapshot-then-use pattern: fields are copied into local stack variables
  under lgr_lnk_lock and nla_put() is called after releasing the lock,
  avoiding any sleeping operation under the spinlock

 net/smc/af_smc.c   | 10 +++++++++-
 net/smc/smc.h      |  1 +
 net/smc/smc_core.c | 20 ++++++++++++++++++++
 net/smc/smc_core.h |  1 +
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..8c781a4a4485 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -310,7 +310,15 @@ static int __smc_release(struct smc_sock *smc)
 		smc_restore_fallback_changes(smc);
 	}

-	sk->sk_prot->unhash(sk);
+	/* Fallback sockets never call smc_conn_free(), so unhash directly.
+	 * Non-fallback sockets use smc_conn_unhash() so that the conn->unhashe=
d
+	 * flag keeps the unhash exactly once even when smc_conn_free() already=
 ran
+	 * first (e.g. via smc_conn_kill()).
+	 */
+	if (smc->use_fallback)
+		sk->sk_prot->unhash(sk);
+	else
+		smc_conn_unhash(&smc->conn);

 	if (sk->sk_state =3D=3D SMC_CLOSED) {
 		if (smc->clcsock) {
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 427b6d63b993..075312278835 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -279,6 +279,7 @@ struct smc_connection {
 	u64			peer_token;	/* SMC-D token of peer */
 	u8			killed;		/* abnormal termination */
 	u8			freed;		/* normal termination */
+	u8			unhashed;	/* removed from sock hash */
 	u8			out_of_sync;	/* out of sync with peer */
 };

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 04aedd957543..e302221c35e3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1251,6 +1251,20 @@ static void smc_buf_unuse(struct smc_connection *c=
onn,
 	}
 }

+/* unhash the socket once; owns the single unhash for all non-fallback p=
aths.
+ * Every caller holds lock_sock for this socket, so conn->unhashed is pr=
otected
+ * by that lock and no separate synchronisation is needed.
+ */
+void smc_conn_unhash(struct smc_connection *conn)
+{
+	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);
+
+	if (!conn->unhashed) {
+		conn->unhashed =3D 1;
+		smc->sk.sk_prot->unhash(&smc->sk);
+	}
+}
+
 /* remove a finished connection from its link group */
 void smc_conn_free(struct smc_connection *conn)
 {
@@ -1263,6 +1277,11 @@ void smc_conn_free(struct smc_connection *conn)
 		return;

 	conn->freed =3D 1;
+	/* Unhash before dropping lgr/lnk refs so the diag reader, which
+	 * iterates under the socket hash read_lock, cannot see a connection wh=
ose
+	 * lgr or lnk is being freed concurrently.
+	 */
+	smc_conn_unhash(conn);
 	if (!smc_conn_lgr_valid(conn))
 		/* Connection has already unregistered from
 		 * link group.
@@ -2053,6 +2072,7 @@ int smc_conn_create(struct smc_sock *smc, struct sm=
c_init_info *ini)
 	if (!conn->lgr->is_smcd)
 		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
 	conn->freed =3D 0;
+	conn->unhashed =3D 0;
 	conn->local_tx_ctrl.common.type =3D SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len =3D SMC_WR_TX_SIZE;
 	conn->urg_state =3D SMC_URG_READ;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 5c18f08a4c8a..f23d60aef0b7 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -595,6 +595,7 @@ void smc_sndbuf_sync_sg_for_device(struct smc_connect=
ion *conn);
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)=
;

+void smc_conn_unhash(struct smc_connection *conn);
 void smc_conn_free(struct smc_connection *conn);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_core_init(void);
--=20
2.50.1 (Apple Git-155)

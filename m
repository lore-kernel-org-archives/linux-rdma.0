Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63189396D28;
	Sat, 26 Sep 2026 06:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405440; cv=none; b=nVCyIyMyL3VfPnwBhJ6nQspqRKcDNe3LzYpL/Y5lebeGVbMGfWELHYySzejI2yHvd2KNoJ18e0PMc7+riIBqxIjt4bAc7o3JaVZenE1hQ4rvmrqPJTP4SHToj0+QQJqdyJj3rERVfPT4o0u+8Os15zgPLtIOO6HaWhoPmlADuiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405440; c=relaxed/simple;
	bh=rF+qC370QxX5TTP5YOjQIe/R5uB2cpJo/TLiysj7pdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VmZFGOLmQEF+z6VsbH1GKV7ktVcLhg4X28pTjnmfvAn4fiUdxzfsjhLvnZDfO97EGhecZ5b6RSbsUY0DHKPrXl1vrWQwYb2tHzlF6gTdyFoGObF/dZXAQEOzQM5h7aL8PxHwSacPBcu0k09nVyFw0W26u6JLPsh432XnFZB5seg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QmcU7Nbe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QmcU7Nbe"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68Q6ZKwx3209561;
	Sat, 26 Sep 2026 06:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=1HzMlbgHU9cjMwN9861RfGhHO8IkDNphdLw2+F/54
	18=; b=QmcU7NbeD0DsU6YKfR/BiF06c9qBBKcBDb0uYxW+qvvy8IOhBPI3TI3to
	1ADPoYuo2ET32UNeOl3DcU7YhXx3jOA72PK0gtPQhGhu8I74a65miZD/tl+UX3j+
	OCjFySLDvHjeIHcGiUrOw87RQ9Gf5tOC458QuT92bbDcf2FMO1rh7terKocfOdFV
	s3QlCG53xYAGiirofA/T12nCyxqCdR1Eeb0pyo6bqCnnmgfD+rRaP6PRIPErUwPv
	vym296Gqyzogm5zSTd1E+f38jw9thBbC9EWuWK8L0SA6m9eQ8LUem8PUWMSBDA+s
	o8WsYKO7x2EsXRdtnFLLKgViC2mlQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5s4rj80-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 26 Sep 2026 06:50:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68Q6WgOA3797191;
	Sat, 26 Sep 2026 06:50:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvu7ehqb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Sep 2026 06:50:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68Q6oPPu47382990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Sep 2026 06:50:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B79B20043;
	Sat, 26 Sep 2026 06:50:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DF1420040;
	Sat, 26 Sep 2026 06:50:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Sat, 26 Sep 2026 06:50:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 491E7161A91; Sat, 26 Sep 2026 08:50:25 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v6] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Sat, 26 Sep 2026 08:50:23 +0200
Message-ID: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI2MDAyNiBTYWx0ZWRfXxa3SuVzSImMt
 p7Mdwmg1E0Mabnvdf2BGgehZ1XGn1qizDxFe+D06RX6l/tn/wryQPARIQORw5NXjYwFWAc2QPCk
 Z7Yak68RwDJN0NwzUEmFbeRy9bZaMjA=
X-Authority-Analysis: v=2.4 cv=HJ5WhYtv c=1 sm=1 tr=0 ts=6ab76b36 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=lbOKbjRzEsN-7L7eHfQA:9
X-Proofpoint-GUID: kIDWJNSf904GUQUHc3mrNUhDwDU4elhy
X-Proofpoint-ORIG-GUID: KvUBfKdPQcrORBATS-DSNJ69I3vW8fEi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI2MDAyNiBTYWx0ZWRfX6qrY2qTQ0kWt
 LgXeU67wyOOEy69Zze+/FjH0/f3DQM336EEDGj0R4WP3/iz7oQKT0MJMM8rbWN6vVQqaXsGrYo+
 e0o0WF23fQON1J/quJBjcQVda5xBKjPc68H2tPtc4uNIsSsTgf9JGxuc6t8y+GGLhl0BYsDK4Y7
 hEBqQLqH/RGiuavzxOVGue5Wrmimmm2Mf39u4K12+e80wm0NVuLHlEV33X2l/URaAW5oud/XOWx
 KWSzPizuq6wS7mfujlcYe9ZjvEgcC23SAzEK2n/nfl/WFWYQu4kBL/rhu2uxwI1D7ciRrQeevc4
 P0dAvB4iibh3Z2E8lJspiSvRI7njSy0xfubmHQKbCxuge1uNpR5uh/wW2C120yq510q/EClqXg/
 cucQF9SyOT+9wcrMB/ijfXNoT2DLgmc86YJHUw9FByhWgThg1mn5gupMYkbqxZFI37BMYWzok2s
 tLqKIMpVSFse8u6jWNw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609260026

The diag dump walks the socket hash table under a read_lock and dereferen=
ces
conn->lgr and conn->lnk. Three paths expose a window where a hashed socke=
t has
freed or partially freed conn/lgr/lnk state.

First, smc_conn_abort() calls smc_conn_free() during early handshake abor=
ts
while the socket is still hashed in SMC_INIT. On the smc_lgr_cleanup_earl=
y()
path this frees the lgr synchronously without holding the hash write_lock=
. A
concurrent diag reader can therefore load a non-NULL conn->lgr and then
dereference lgr->is_smcd after the kfree. Guard the conn->lgr->is_smcd lo=
ad in
__smc_diag_dump() by skipping it when the socket is in SMC_INIT state.

Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach() NU=
LLs and
frees conn->sndbuf_desc before the socket is unhashed. A concurrent diag =
reader
entering the CONNINFO block can dereference the freed descriptor. Unhash =
the
socket at the top of smc_conn_kill(), before smcd_buf_detach().

Third, in the terminal teardown branches of smc_close_active_abort()
(PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
smc_conn_free() drops lgr and lnk references while the socket is still ha=
shed.
Unhash immediately before each smc_conn_free() call at those two sites.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v6:
- smc_diag.c: inline sk->sk_state !=3D SMC_INIT into the else-if conditio=
n
  so conn->lgr->is_smcd is never loaded for SMC_INIT sockets; retain the
  SMC_INIT || SMC_CLOSED early-exit guard and out: label from v5 to
  defensively skip the CONNINFO/LGRINFO/DMBINFO blocks for sockets with
  no live connection
- smc_close.c: remove the unconditional unhash from the top of
  smc_close_active_abort(); place it scoped immediately before each of
  the two smc_conn_free() calls in the PEERCLOSEWAIT and PROCESSABORT
  branches, and before smc_conn_free() in smc_close_passive_work();
  this avoids prematurely hiding live SMC_ACTIVE/APPCLOSEWAIT sockets
  from smcss
- smc_core.c: unhash at the top of smc_conn_kill(), before
  smcd_buf_detach(), so the socket is off the hash table before
  conn->sndbuf_desc is freed on the dmb_nocopy path

Changes in v5:
- guard conn/lgr/lnk blocks in __smc_diag_dump() with an
  (SMC_INIT || SMC_CLOSED) state check placed after the
  SMC_DIAG_FALLBACK nla_put; SMC_INIT can coexist with fallback
  (smc_sendmsg() MSG_FASTOPEN path), so the guard must not suppress
  the fallback reason

Changes in v4:
- dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
  changes to af_smc.c, smc.h, smc_core.c and smc_core.h;
  smc_unhash_sk() is already idempotent via sk_hashed(), so direct
  calls at the two teardown sites in smc_close.c are sufficient
- dropped the __smc_release() hunk: it needs no change since the
  subsequent unhash there is already a safe no-op
- fixed premature-unhash issue present in v3: smc_conn_free() must not
  unhash because smc_conn_abort() calls it before
  smc_switch_to_fallback() in both smc_listen_decline() and
  smc_connect_rdma() error paths; unhashing there would make live
  fallback sockets invisible to smcss
- likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(),
  smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed
  attempt and then smc_conn_create() on the next device; unhashing in
  smc_conn_free() would permanently hide the established connection from
  smc_diag since smc_conn_create() does not re-hash the socket

Changes in v3:
- redesigned as a single patch; dropped the lgr_lnk_lock spinlock
  approach and the 2-patch split
- fix is now at the socket hash layer: introduce smc_conn_unhash() with
  a per-connection unhashed flag; smc_conn_free() unhashes before
  dropping lgr/lnk refs, so any socket visible to the diag reader under
  the hash read_lock has valid conn->lgr and conn->lnk pointers
- __smc_release() updated to call smc_conn_unhash() for non-fallback
  sockets so the flag is honoured when smc_conn_free() already ran first
- smc_diag.c needs no changes; the hash read_lock invariant is
  sufficient without any per-connection lock in the dump path
- dropped the clcsock/mutex_trylock fix as that will be addressed
  separately

Changes in v2:
- this is v2 of the 2-patch series; the earlier submission was
  mislabelled [PATCH v3] but was in fact the first version sent to the
  list
- split into a 2-patch series; patch 1/2 adds per-connection
  lgr_lnk_lock infrastructure to smc_core, patch 2/2 fixes the diag
  dump path using it
- dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held
  the socket lock across all lgr/lnk dereferences, requiring the hash
  read_lock to be dropped and re-acquired around each socket
- dropped the restart-from-head loop in smc_diag_dump_proto(); the new
  design does not drop the hash read_lock mid-walk so the hlist
  truncation concern no longer applies
- dropped refcount_inc_not_zero() socket pinning from the dump loop for
  the same reason: the hash read_lock is now held for the full walk
- added per-connection lgr_lnk_lock spinlock to struct smc_connection;
  conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
  before borrowed references are released, establishing the invariant: a
  non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
- added lgr_lnk_lock to smc_switch_link_and_count() to protect the
  conn->lnk pointer swap from concurrent diag readers
- replaced mutex_lock() on clcsock_release_lock in
  smc_diag_msg_common_fill() with mutex_trylock(); mutex_lock() was
  valid in v1 because the hash spinlock had been dropped, but the new
  design holds the hash read_lock throughout so only a non-sleeping
  trylock is safe; a failed trylock leaves address fields zeroed, which
  is acceptable for a monitoring tool
- all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
  snapshot-then-use pattern: fields are copied into local stack
  variables under lgr_lnk_lock and nla_put() is called after releasing
  the lock, avoiding any sleeping operation under the spinlock

 net/smc/smc_close.c | 3 +++
 net/smc/smc_core.c  | 1 +
 net/smc/smc_diag.c  | 7 ++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bb0313ef5f7c..aa6363abdd74 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -154,6 +154,7 @@ void smc_close_active_abort(struct smc_sock *smc)
 		if (sk->sk_state !=3D SMC_PEERABORTWAIT)
 			break;
 		sk->sk_state =3D SMC_CLOSED;
+		sk->sk_prot->unhash(sk);
 		smc_conn_free(&smc->conn);
 		release_clcsock =3D true;
 		sock_put(sk); /* passive closing */
@@ -165,6 +166,7 @@ void smc_close_active_abort(struct smc_sock *smc)
 		if (sk->sk_state !=3D SMC_PEERABORTWAIT)
 			break;
 		sk->sk_state =3D SMC_CLOSED;
+		sk->sk_prot->unhash(sk);
 		smc_conn_free(&smc->conn);
 		release_clcsock =3D true;
 		break;
@@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct=
 *work)
 		sk->sk_state_change(sk);
 		if ((sk->sk_state =3D=3D SMC_CLOSED) &&
 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
+			sk->sk_prot->unhash(sk);
 			smc_conn_free(conn);
 			if (smc->clcsock)
 				release_clcsock =3D true;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 04aedd957543..d7bd6d7f428b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *co=
nn, bool soft)
 {
 	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);

+	smc->sk.sk_prot->unhash(&smc->sk);
 	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort =3D 1;
 	else
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index bf0beaa23bdb..b29bd34acf7b 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -90,7 +90,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_b=
uff *skb,
 	r->diag_state =3D sk->sk_state;
 	if (smc->use_fallback)
 		r->diag_mode =3D SMC_DIAG_MODE_FALLBACK_TCP;
-	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
+	else if (sk->sk_state !=3D SMC_INIT &&
+		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
 		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
 	else
 		r->diag_mode =3D SMC_DIAG_MODE_SMCR;
@@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
 		goto errout;

+	if (sk->sk_state =3D=3D SMC_INIT || sk->sk_state =3D=3D SMC_CLOSED)
+		goto out;
+
 	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
 	    smc->conn.alert_token_local) {
 		struct smc_connection *conn =3D &smc->conn;
@@ -185,5 +189,6 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			goto errout;
 	}

+out:
 	nlmsg_end(skb, nlh);
 	return 0;
--=20
2.43.7

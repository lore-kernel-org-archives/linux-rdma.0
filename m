Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3321D00A;
	Mon, 12 Oct 2026 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792053; cv=none; b=iRB70wmysCL1VOgCN3r6mWEtXwnfSszDh5jTCwWxPsYUbSEY91B4C5Zm7dbFFA9nwT+uHOoTgd6rxRC3FEUA85Ot5vlTYXQdxrTuB6XMaC4ZofzM5lMUj9+8VgyM1tyJbFrCxc5ALkgiJ1PnUR3ZrJsqEfo+Cs5G8wjSEWPrtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792053; c=relaxed/simple;
	bh=I3dBhQ5RL5RBbtMKdUXDiTR7FJm672G+vxWdUTFVEic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b8VzF7CjB0c+n8CZNjb8IuWMt/5nkpFfoNPJtuPnN8WSgafnosBbxyX06PHYbGa+lPlU9RPwqYS+ZmejcXMut8EMSgVePq38CI00+7r6HgEsLrGCZcQoaWJJ90oplctHQtN5/tXC0gRoFnU62XYz85hxjoHyj20RU6y0XNI8aik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DdEcsRms; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DdEcsRms"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C5FHgT3323639;
	Mon, 12 Oct 2026 08:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=8+2iJo0s53yqQr9SYp/UPPNFqHxxBO9shpCKizyD0
	2o=; b=DdEcsRmsH3Fm0JPmh9JqCszhlIqtsmntBkOV6HF5yu3dk1x5ViWSW4JXu
	dJHVrQ4rCV8wjabSVg2V5ohcK5YKUPgPS8xVizNjiKxs3aoT1JWTr9Iwtl46BTcY
	G1mrEMUHELNcQLllEkZPq7Z63v8b8WCkKPtDiiMQ/fj4OkqZXEZ9C0HffymRO3/A
	9LYqhquRDBngR5pZlt1P69Wk+kDnNCJI/9q6n+IrZ3CYTotTjUmQ1s/ZfUKzRDSr
	Hp2uQ1mI5UW9KBEoS1WmyzpEh6PIe1m28ABJxQuMTvXiNoVvq5yqAydWjbgPbZ7t
	geqsA1VTEaLmoBGd0HFYV2UeX2MOQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhqhxd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 08:00:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69C5Jqu0769651;
	Mon, 12 Oct 2026 08:00:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h802vmcy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 08:00:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69C80cmD31326630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 08:00:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E5D72004D;
	Mon, 12 Oct 2026 08:00:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FFDB20043;
	Mon, 12 Oct 2026 08:00:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 12 Oct 2026 08:00:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 0ADE4160DD9; Mon, 12 Oct 2026 10:00:38 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 12 Oct 2026 10:00:34 +0200
Message-ID: <20261012080034.38770-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAzMCBTYWx0ZWRfXyrnywz9bynZd
 ljnDkDXeDJx2gbQGTVTqgOPZwSodN1z2DeqJr+R+XZswBsom910DtrmD64n3MOTiCEDx/QX2ygl
 8AU6wTm/FFiARuLUk2if6RGo2wwTx8x/mukZKyMcRo16msVjX6lFPiq+IqpF2oEEIuaOACU0zbO
 IwEeK2xzmpVkhjvRDHfSFUEFOIHnWxFs6PXM28X4hZAMrMdgtOduaYadA7iXvmuBseSVzbzkN6o
 Y1vAFdg0zQtYC/l43wB+kT/cylwqaDNqYhH69uoVVBsafCHmNsYWH7L1g+EMlzLiFXoHdaZuR6z
 JRfCPGVIuVtvci56gha3i2/c9cTxdXPCAHtuGdNlvy3Rb2EAlmqzfvZijxz1MSAx9iUpn19iZlp
 eqpuklkzu3oIaoh4J4iPpCZv2B+C0LHfaHJjzDE5BbnQ+hDVgd6JWVAuohHzQPEZnE45+lyz6r0
 SwMWkh1Mqa137Y2VVWQ==
X-Proofpoint-GUID: XWMJE9Fn8DpouqamW3cpSH5v876HMOlX
X-Proofpoint-ORIG-GUID: mjDx_v61dIbQjl9zHBdJ9aLpnyyLCXRA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAzMCBTYWx0ZWRfX0S/OCLHRFxbz
 VdvsXkA2EofJF6yD507LO2cCxg701CnxzmxMe8w5fmE1MomkQ3TbqY08jmCuSK52F/pIx2pByoV
 AHWurDjImUUfLypbSCsOt/N3x0MNeEY=
X-Authority-Analysis: v=2.4 cv=btHZl0ai c=1 sm=1 tr=0 ts=6acc93ab cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=j_y0sSGUbsAF7EDPGGkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120030

The diag dump walks the socket hash table under a read_lock and dereferen=
ces
conn->lgr and conn->lnk. Four paths expose a window where a hashed socket=
 has
freed or partially freed conn/lgr/lnk state.

First, smc_conn_abort() calls smc_conn_free() during early handshake abor=
ts
while the socket is still hashed in SMC_INIT, synchronously freeing the l=
gr on
the smc_lgr_cleanup_early() path without holding the hash write_lock. A
concurrent diag reader can load a non-NULL conn->lgr and dereference
lgr->is_smcd after the kfree. Guard the conn/lgr/lnk blocks in __smc_diag=
_dump()
for SMC_INIT and SMC_CLOSED sockets. As a side effect the diag_mode field=
 is
reported as SMC_DIAG_MODE_SMCR for SMC-D sockets still in SMC_INIT; smcss
suppresses those rows before printing the mode string so there is no rend=
ered
regression. Use smp_load_acquire() / smp_store_release() on sk_state to o=
rder
these checks on weakly ordered CPUs.

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

Fourth, smc_listen_out_err() sets sk_state =3D SMC_CLOSED with a plain st=
ore after
smc_conn_abort() -> smc_conn_free() has already cleared alert_token_local=
 under
write_lock_bh(). On weakly ordered CPUs a concurrent diag reader using
smp_load_acquire() on sk_state can observe SMC_CLOSED while the preceding=
 store
to alert_token_local has not yet become visible, causing it to dereferenc=
e an
lgr whose reference was already dropped. Use smp_store_release() to order=
 the
alert_token_local clear before the sk_state =3D SMC_CLOSED store.

Additionally, in __smc_diag_dump(), use cached link->ibname instead of ch=
asing
link->smcibdev->ibdev->name to avoid racing with link clearing during SMC=
-R link
failover.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
Cc: stable@vger.kernel.org
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v9:
- af_smc.c: change plain store in smc_listen_out_err() to
  smp_store_release(&newsmcsk->sk_state, SMC_CLOSED) to order the
  preceding alert_token_local clear (done under write_lock_bh() inside
  smc_conn_free()) before the sk_state write; pairs with the
  smp_load_acquire() in __smc_diag_dump() to close a use-after-free on
  weakly ordered CPUs where a diag reader could observe SMC_CLOSED while
  conn->lgr still appeared live

Changes in v8:
- smc_diag.c: use smp_load_acquire(&sk->sk_state) to prevent
  speculative load reordering on weakly ordered CPUs (such as arm64)
  during handshake abort fallback
- af_smc.c: pair with smp_store_release(&sk->sk_state, SMC_ACTIVE)
  when transitioning out of SMC_INIT
- smc_diag.c: copy cached link->ibname instead of chasing
  link->smcibdev->ibdev->name to prevent NULL pointer dereference / UAF
  if __smcr_link_clear() zeroes the link during link failover

Changes in v7:
- no code changes; commit message only
- document the SMC_CLOSED leg of the early-exit guard and the rationale
  that smcss already skips CLOSED sockets on the userspace side; add
  Fixes: ae2be35cbed2 for the smc_conn_kill() hunk since
  smcd_buf_detach() was introduced by that commit

Changes in v6:
- smc_diag.c: inline sk->sk_state !=3D SMC_INIT into the else-if
  condition so conn->lgr->is_smcd is never loaded for SMC_INIT sockets;
  retain the SMC_INIT || SMC_CLOSED early-exit guard and out: label
  from v5 to defensively skip the CONNINFO/LGRINFO/DMBINFO blocks for
  sockets with no live connection
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
- likewise, the ISM/RDMA retry loops call smc_conn_abort() on a failed
  attempt and then smc_conn_create() on the next device; unhashing in
  smc_conn_free() would permanently hide the established connection from
  smc_diag since smc_conn_create() does not re-hash the socket

Changes in v3:
- redesigned as a single patch; dropped the lgr_lnk_lock spinlock
  approach and the 2-patch split

Changes in v2:
- split into a 2-patch series; patch 1/2 adds per-connection
  lgr_lnk_lock infrastructure to smc_core, patch 2/2 fixes the diag
  dump path using it

 net/smc/af_smc.c    | 10 +++++++---
 net/smc/smc_close.c |  3 +++
 net/smc/smc_core.c  |  1 +
 net/smc/smc_diag.c  | 12 ++++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..2f8308aa7daf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -976,7 +976,7 @@ static int smc_connect_fallback(struct smc_sock *smc,=
 int reason_code)
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock =3D 0;
 	if (smc->sk.sk_state =3D=3D SMC_INIT)
-		smc->sk.sk_state =3D SMC_ACTIVE;
+		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);
 	return 0;
 }

@@ -1381,7 +1381,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock =3D 0;
 	if (smc->sk.sk_state =3D=3D SMC_INIT)
-		smc->sk.sk_state =3D SMC_ACTIVE;
+		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);

 	return 0;
 connect_abort:
@@ -1484,7 +1484,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock =3D 0;
 	if (smc->sk.sk_state =3D=3D SMC_INIT)
-		smc->sk.sk_state =3D SMC_ACTIVE;
+		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);

 	return 0;
 connect_abort:
@@ -1951,7 +1951,7 @@ static void smc_listen_out_connected(struct smc_soc=
k *new_smc)
 	struct sock *newsmcsk =3D &new_smc->sk;

 	if (newsmcsk->sk_state =3D=3D SMC_INIT)
-		newsmcsk->sk_state =3D SMC_ACTIVE;
+		smp_store_release(&newsmcsk->sk_state, SMC_ACTIVE);

 	smc_listen_out(new_smc);
 }
@@ -1965,7 +1965,7 @@ static void smc_listen_out_err(struct smc_sock *new=
_smc)
 	this_cpu_inc(net->smc.smc_stats->srv_hshake_err_cnt);
 	if (newsmcsk->sk_state =3D=3D SMC_INIT)
 		sock_put(&new_smc->sk); /* passive closing */
-	newsmcsk->sk_state =3D SMC_CLOSED;
+	smp_store_release(&newsmcsk->sk_state, SMC_CLOSED);

 	smc_listen_out(new_smc);
 }
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
index 9974149659c2..663926465ba7 100644
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
index bf0beaa23bdb..36a3b8f31f28 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,

 	r =3D nlmsg_data(nlh);
 	smc_diag_msg_common_fill(r, sk);
-	r->diag_state =3D sk->sk_state;
+	r->diag_state =3D smp_load_acquire(&sk->sk_state);
 	if (smc->use_fallback)
 		r->diag_mode =3D SMC_DIAG_MODE_FALLBACK_TCP;
-	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
+	else if (r->diag_state !=3D SMC_INIT &&
+		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
 		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
 	else
 		r->diag_mode =3D SMC_DIAG_MODE_SMCR;
@@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
 		goto errout;

+	if (r->diag_state =3D=3D SMC_INIT || r->diag_state =3D=3D SMC_CLOSED)
+		goto out;
+
 	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
 	    smc->conn.alert_token_local) {
 		struct smc_connection *conn =3D &smc->conn;
@@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			.lnk[0].link_id =3D link->link_id,
 		};

-		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
-		       sizeof(link->smcibdev->ibdev->name));
+		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));
 		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
 		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);

@@ -185,6 +188,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			goto errout;
 	}

+out:
 	nlmsg_end(skb, nlh);
 	return 0;

--=20
2.50.1 (Apple Git-155)

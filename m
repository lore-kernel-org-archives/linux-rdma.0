Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE16481A97;
	Mon,  5 Oct 2026 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205977; cv=none; b=rFEbDemW8dKoRcv7JyGVuToRlY/yRsl4NPqD46t88EDVFBoZrZf0ahGQ8ZcL0R4cWuK6YLc87jDGWlrNuP8MmYzj/HhdojcfdVdYb0xbHsc3twBldtp05q+Nc0f43Kmqqlm5w/Kew5sCKgFX0XOVJG3ILVALW1NL8onouvaDiVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205977; c=relaxed/simple;
	bh=0OQ1xzhDS95czbutR18GtxiMav3uyLz+5oCIJzvmaZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gYlTDo4Fhr+mXQ7DgdOpAbiPk17euGmpswERD7rNNDqq+7osLyWwl2a/uWI/sjnHheUNXHaTSgiqsL++okXQlE/83IrJzUD5ln6zZb4ZDU7eZg82CLECRu7UCH/BLFt8aFDe+raRBDpCY8I8/5TOyksiG0AaWcrad/EWY3ZYEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pLoOoK7m; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pLoOoK7m"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695CZikh504152;
	Mon, 5 Oct 2026 13:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=obiFoDbcelCUjEHJPePscGKeoNedIO7JFFVKJBO8h
	3o=; b=pLoOoK7mcUjtwg45Rb+yvf9OVmWHiXalkvleHcPS6rNTSyzxPphzHtzWW
	8xPMliXCsX898LfxUQxsrN7KBd3kSA+y0AlrV9jWHQhW/loPUHGim1GZ+G0rXF1o
	owx59+P3nZEr+jLDkhYYPpLy/wng05xyXF9B7q6eF/0bhVitDLx8na3pZ9X4mo21
	LeprSdrtU1eG/WvfRNTVsc70i311v7awkfcRvY8Zt/GYvYcyb8D3wLwSAGAeaVN2
	NEn2KCdbfiKJtFqg9S+471yZhOQnkclRCwje/EZ4PYDzXTuc10F1BafgK2mL39sd
	dwY9PX3CIRkacepes3Vm9pvhNQHmA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2q4jj0nt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 13:12:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 695CHnZT2913114;
	Mon, 5 Oct 2026 13:12:46 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h3eqy5b16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 13:12:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 695DCh5c52887846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Oct 2026 13:12:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E93262004B;
	Mon,  5 Oct 2026 13:12:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC63620040;
	Mon,  5 Oct 2026 13:12:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  5 Oct 2026 13:12:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 9469C1612C8; Mon, 05 Oct 2026 15:12:42 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon,  5 Oct 2026 15:12:41 +0200
Message-ID: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 1v9joWk1UBtkQXO1bawf4baJj1wuDR7Y
X-Proofpoint-GUID: Um2IjovbMZLOJW6b51o1-jJJfI6h42uK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1MSBTYWx0ZWRfX68Vd1HfkOPzo
 KqApgHAAd+RpG2uwRe2UgiUCWVSPykQ8kbKUX1fdDxWmiaRwg773vusHxh4DvOWyXpM25KUqmVs
 Prrql/5qKsJE+BFskP1mAqqnD4cKBC8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1MSBTYWx0ZWRfXy3Ckk27Vlbv+
 dDJ90VQVBvHEr2f2PY/ZRAkGBkRlP603XLQ3xGgSu0GIEkUUG7Crxdb0MHkqAXmzJdbNa6ooAw+
 03gxbWd42nP51z+nYep9RCBB4ccZBYZ+UrPaUKlLkb/lSgx6MppqsWmlMu0B3mnCaazxO4r8twk
 Ub9MzGp8RRPGlEXPUaX/OcyqnTXt6X3VPYb/Nr8dUUbt9FkqUuqi7dCACweUVB37MkgxDZ5znvF
 r6DYTz/eR8dAxPZGS3x1jc3TXwlUmWf/8tfsNWPJSZDFdcA2uhFmeEOeUQC09zZzraYd1qWFaDP
 dldu4OL4pkrbfUh+OMQ8PKyoZpMzCETQh0AYgj/xdXhnUfpU6CqAOr7HVoWUvzwGfBEA5U5s8kD
 BdLfCZSyDfzK+sn1FLd0UJzHJNWXOa1kCyHOXjhvuhkbLxLv8K5frmSMm0fLZ6K8NNf2F0GTZ77
 GT9dd2AsZ0jAh/nlJRg==
X-Authority-Analysis: v=2.4 cv=eYeo7LEH c=1 sm=1 tr=0 ts=6ac3a24f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=BXWiJY1A4b8lTG70euYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_03,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050051

The diag dump walks the socket hash table under a read_lock and dereferen=
ces
conn->lgr and conn->lnk. Three paths expose a window where a hashed socke=
t has
freed or partially freed conn/lgr/lnk state.

First, smc_conn_abort() calls smc_conn_free() during early handshake abor=
ts
while the socket is still hashed in SMC_INIT, synchronously freeing the l=
gr on
the smc_lgr_cleanup_early() path without holding the hash write_lock. A
concurrent diag reader can load a non-NULL conn->lgr and dereference
lgr->is_smcd after the kfree. Guard the conn/lgr/lnk blocks in __smc_diag=
_dump()
for SMC_INIT and SMC_CLOSED sockets; smcss already suppresses these attri=
butes
for closed/unconnected sockets so there is no observability regression. U=
se
smp_load_acquire() / smp_store_release() on sk_state to prevent speculati=
ve load
reordering on weakly ordered CPUs (e.g. ARM64) during fallback.

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
Changes in v8:
- smc_diag.c: use smp_load_acquire(&sk->sk_state) to prevent speculative
  load reordering on weakly ordered CPUs (such as arm64) during handshake
  abort fallback
- af_smc.c: pair with smp_store_release(&sk->sk_state, SMC_ACTIVE) when
  transitioning out of SMC_INIT
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

 net/smc/af_smc.c    | 8 ++++----
 net/smc/smc_close.c | 3 +++
 net/smc/smc_core.c  | 1 +
 net/smc/smc_diag.c  | 9 +++++++--
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 23d46797b536..3c9b74301d01 100644
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

@@ -1381,7 +1381,7 @@ int smc_conn_create(struct smc_sock *smc, struct sm=
c_init_info *ini)
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock =3D 0;
 	if (smc->sk.sk_state =3D=3D SMC_INIT)
-		smc->sk.sk_state =3D SMC_ACTIVE;
+		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);

 	return 0;
 connect_abort:
@@ -1484,7 +1484,7 @@ static int smc_connect_ism(struct smc_sock *smc, st=
ruct smc_init_info *ini)
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
index bf0beaa23bdb..6ee51088d227 100644
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
@@ -154,7 +158,6 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			.lnk[0].link_id =3D link->link_id,
 		};

-		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
-		       sizeof(link->smcibdev->ibdev->name));
+		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));
 		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
 		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);
@@ -185,6 +189,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			goto errout;
 	}

+out:
 	nlmsg_end(skb, nlh);
 	return 0;

--=20
2.50.1 (Apple Git-155)

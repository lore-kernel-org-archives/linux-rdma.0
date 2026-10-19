Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56164CDA12;
	Mon, 19 Oct 2026 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408236; cv=none; b=dImnHTsBk5Y361d5K0DO+izPvxZy1LFnH3251jdipUo1jiEfV+aF/tYjiBmBaX6euhD5Df4M7e/SsYg86nM2XnYMNxV/Sd5XcZUal/UHAgtHkYEVc0dp/vB9Xrheh6Fom1BuKVHU/4Fi7E/hkZl5ZYWBA2XfFBOWhRYIZTs8ZQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408236; c=relaxed/simple;
	bh=RcURL80LQes+fOBnI7ubBJdHCDgx+U400KL5VOyNY4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kceOCBif4h9VJJuOCjezwmb3OnT0/3d8MOHqIBdMdjDuv2gx4LnRvuetwqOi5yAK3B7M9pIqDKYyBOBV94oacs+JND2y2gW/EB8hZKKAEB0FMXCFwZ+Hljx1VWyCgjdDejTKVGplpDmlZUKcSAZK/d7aaYbjoqDpiVOlpxYNP4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FdfrDlWq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FdfrDlWq"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8iNQK3347948;
	Mon, 19 Oct 2026 11:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=kQ8//EMrU08pl4brA7+dGiY0AKgy1HsEp3ER0/cNO
	As=; b=FdfrDlWqYhqpOr+USLQsTFYZPYUzXimVXLsX6fdfov3Lr1ewxVG3ogATx
	BXSxIJxGam3vVz6eJGQYYCiw6VZOfRTbJC1vDHdUGZm7TNyaZ8rz02RSjWShM0Q7
	dPENbp3wTeQFF1dR2qEzE/aEpYzusUvida67dmGe1OI77zhA8lnVERp2ZRJBFhT2
	Xl9Hzh05ez9MtbDnD9MH5CnSVuui89kkKVqYVAVnAJ+R6GVhEEw8xg2dyi4MGg/8
	6XEShgJCXL1nchgwcWk4WWXwR1N1pdUEB0g4uZsROrc8tZxRiJLzgCJBMn41rusS
	DJs9JpeBhu+GP7I2+fCmcerM3O/FQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hc0nvsx6f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 11:10:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8Z5ex3889643;
	Mon, 19 Oct 2026 11:10:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hcmugwbaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 11:10:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69JBAJYg48628202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 11:10:20 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A7552004F;
	Mon, 19 Oct 2026 11:10:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FDB02004D;
	Mon, 19 Oct 2026 11:10:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 19 Oct 2026 11:10:19 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id E9E45160E0B; Mon, 19 Oct 2026 13:10:18 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 19 Oct 2026 13:10:08 +0200
Message-ID: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA0MiBTYWx0ZWRfX4ujsUqhKI5AR
 z9k18SsYvPM9ZVQ37+505FZmEjSJ+tjw0ul7zlI2zNZZ+IzNtGhEDWrSS4YsKZNEXgonuGW/EHK
 V8QeEP8RdsWD39aZtV/k6aFxoORYKA4=
X-Proofpoint-ORIG-GUID: J4K83NyRiUnv2bYZl1cJ78HDvqRazHKG
X-Proofpoint-GUID: q0Dn5_kO4V-uLsQFm0AaXzp_ThqKE2HH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA0MiBTYWx0ZWRfX6jRyzuez3m9L
 PIsylkgTcCyEA027rE5rYKZ4yuieRbKON72Shb+6hnlMxplhovpcwRj5lmN45RyZ3s/NhyMQQIF
 yawLnqjKX1VdMmAtzSb9l0nav1HZxM60Pbrl9I34vqdLmpkAwWm8i9DjIbEFLCgvm0ll+iKP2WE
 ANaYWldXczmGdjs7Qg/01+Ljslyn0Dz/zNMH53ew9hqLxcxDZ8voRLcti1WwyaxKshKHPUa5/WV
 15/DhUtn7NrqJ9SodLJaLIpR5VD+Wq08gkOldjci+Masi8nmfYpFLGvttvMxtfdKdn2TWPqu7Qz
 xTuXEtzdC/+wllgYjfIkfDo2AxoNam/Xtm8ebxYCL1dnNpJGxy6TCrok9ZMzYaEJ3ScLGbUJ99L
 XHHpqjI8NLBfKoumVQTwaa/9c2BlmuKjOyinfjw9K7MeVlreEDrp6pQWjeMcXxiOggFdtjwoJH/
 x3Ihh3KBocvF8ZuDcbQ==
X-Authority-Analysis: v=2.4 cv=MY35KJ/f c=1 sm=1 tr=0 ts=6ad5faa2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=kuSpdRzMKIjKfhU5lbMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190042

The diag dump walks the socket hash table under a read_lock and
dereferences conn->lgr and conn->lnk. Several paths expose a window
where a hashed socket has freed or partially freed conn/lgr/lnk state.

First, smc_conn_abort() calls smc_conn_free() during early handshake
aborts while the socket is still hashed in SMC_INIT, synchronously
freeing the lgr on the smc_lgr_cleanup_early() path without holding the
hash write_lock. A concurrent diag reader can load a non-NULL conn->lgr
and dereference lgr->is_smcd after the kfree. Skip the connection, link
group and DMB attributes in __smc_diag_dump() for sockets in SMC_INIT or
SMC_CLOSED, and do not look at conn->lgr to determine diag_mode in
SMC_INIT.

This changes the sock_diag output for such sockets. SMC_DIAG_CONNINFO,
SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are no longer reported while a
socket is in SMC_INIT or SMC_CLOSED; diag_mode is SMC_DIAG_MODE_SMCR for
a non-fallback SMC-D socket in SMC_INIT, as it already was before
smc_conn_create() had run. smcss does not use these attributes for such
sockets. Use smp_load_acquire() / smp_store_release() on sk_state to
order these checks on weakly ordered CPUs.

Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach()
NULLs and frees conn->sndbuf_desc while the socket is still hashed. A
concurrent diag reader entering the CONNINFO block can dereference the
freed descriptor. Unhash the socket right before smcd_buf_detach().
Other kill paths leave the socket hashed, since it can stay open until
close().

Third, in the terminal teardown branches of smc_close_active_abort()
(PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
smc_conn_free() drops lgr and lnk references while the socket is still
hashed. Unhash immediately before each smc_conn_free() call at those two
sites.

Fourth, smc_listen_out_err() sets sk_state =3D SMC_CLOSED with a plain
store after smc_conn_abort() -> smc_conn_free() has already cleared
alert_token_local under write_lock_bh(). On weakly ordered CPUs a
concurrent diag reader using smp_load_acquire() on sk_state can observe
SMC_CLOSED while the preceding store to alert_token_local has not yet
become visible, causing it to dereference an lgr whose reference was
already dropped. Use smp_store_release() to order the alert_token_local
clear before the sk_state =3D SMC_CLOSED store.

Fifth, on the smc_lgr_cleanup_early() path (e.g. server CLC decline with
SYNCERR) __smc_lgr_terminate() sets terminating=3D1 and unlinks the LGR
without setting freeing=3D1. smc_conn_free() gated
smc_lgr_unregister_conn() on !list_empty(&lgr->list), skipping
unregister on the unlinked LGR and leaving alert_token_local non-zero; a
fallback socket could then reach SMC_ACTIVE and a diag reader could
dereference sndbuf_desc/rmb_desc freed by smc_lgr_free_bufs(). Also,
smc_lgr_schedule_free_work() only checked !lgr->freeing, so a concurrent
smc_conn_free() decrementing conns_num to 0 could re-arm free_work; the
subsequent kfree(lgr) leaves the armed work pointing at freed memory.
Unregister unconditionally in smc_conn_free(), and guard
smc_lgr_schedule_free_work() with !lgr->terminating in addition to
!lgr->freeing.

Finally, in __smc_diag_dump(), copy the cached link->ibname instead of
dereferencing link->smcibdev->ibdev->name to avoid the NULL pointer
dereference / UAF if __smcr_link_clear() zeroes the link during
concurrent SMC-R link failover. Like the SMC netlink link dump and the
tracepoints, this reports the name at link creation time and does not
follow a later ib_device_rename().

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 2a0674fffb6b ("net/smc: improve abnormal termination of link group=
s")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
Cc: stable@vger.kernel.org
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v12:
- smc_core.c: guard smc_lgr_schedule_free_work() with !lgr->terminating
  in addition to !lgr->freeing, preventing free_work from being re-armed
  on a terminating LGR after smc_lgr_cleanup_early() has called
  __smc_lgr_terminate() (which sets terminating=3D1 and cancels free_work
  without setting freeing=3D1); without this a concurrent smc_conn_free()
  decrementing conns_num to 0 would re-arm free_work, and the subsequent
  kfree(lgr) in smc_lgr_free() would leave the armed work pointing at
  freed memory

 Changes in v11:
- smc_core.c: unregister connection unconditionally in smc_conn_free()
  rather than gating it on !list_empty(&lgr->list), ensuring
  alert_token_local is always reset to 0
- commit message: add Fixes tag for 2a0674fffb6b and clarify that
  copying cached link->ibname eliminates the NULL dereference / UAF
  during concurrent link clearing

Changes in v10:
- smc_core.c: move the unhash out of the top of smc_conn_kill() into
  the smc_ism_support_dmb_nocopy() branch, right before
  smcd_buf_detach(); the other kill paths leave ACTIVE/APPCLOSEWAIT
  sockets open, so they must stay visible to smcss and keep their
  inuse accounting
- commit message: document the sock_diag output changes for sockets in
  SMC_INIT and SMC_CLOSED (extension attributes omitted, diag_mode of
  SMC-D in SMC_INIT) and that ibname is the name cached at link
  creation

Changes in v9:
- af_smc.c: change plain store in smc_listen_out_err() to
  smp_store_release(&newsmcsk->sk_state, SMC_CLOSED) to order the
  preceding alert_token_local clear (done under write_lock_bh() inside
  smc_conn_free()) before the sk_state write; pairs with the
  smp_load_acquire() in __smc_diag_dump() to close a use-after-free on
  weakly ordered CPUs where a diag reader could observe SMC_CLOSED
  while conn->lgr still appeared live

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

 net/smc/af_smc.c    | 10 +++++-----
 net/smc/smc_close.c |  3 +++
 net/smc/smc_core.c  | 11 ++++++-----
 net/smc/smc_diag.c  | 12 ++++++++----
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..41b8af13efc4 100644
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
index 9974149659c2..9d8165d1b40c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -84,7 +84,7 @@ static void smc_lgr_schedule_free_work(struct smc_link_=
group *lgr)
 	 * creation. For client use a somewhat higher removal delay time,
 	 * otherwise there is a risk of out-of-sync link groups.
 	 */
-	if (!lgr->freeing) {
+	if (!lgr->freeing && !lgr->terminating) {
 		mod_delayed_work(system_percpu_wq, &lgr->free_work,
 				 (!lgr->is_smcd && lgr->role =3D=3D SMC_CLNT) ?
 						SMC_LGR_FREE_DELAY_CLNT :
@@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
 		if (current_work() !=3D &conn->abort_work)
 			cancel_work_sync(&conn->abort_work);
 	}
-	if (!list_empty(&lgr->list)) {
+	if (!list_empty(&lgr->list))
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
-		smc_lgr_unregister_conn(conn);
-	}
+	smc_lgr_unregister_conn(conn);

 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
@@ -1530,8 +1529,10 @@ static void smc_conn_kill(struct smc_connection *c=
onn, bool soft)
 			tasklet_kill(&conn->rx_tsklet);
 		else
 			tasklet_unlock_wait(&conn->rx_tsklet);
-		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
+		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
+			smc->sk.sk_prot->unhash(&smc->sk);
 			smcd_buf_detach(conn);
+		}
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 	}
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


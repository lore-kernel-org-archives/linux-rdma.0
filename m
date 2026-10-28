Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793170956;
	b=BGgVafLfAkKajnPqF0SaYBbNGwr83HHvYS84fPtPl9/ZI+D+rSvAMngZpAT5TeSHSHnx
	 kD8n/hEYQttYW+2TAdeYO8Kp35+5Cdn2YW6EsOCMf+LiD+Ig3iyw2LwWBFZXDqJ0sOC1D
	 WaqMWW9Ydm+R1XQOgTBzBUOmcG4gGoxkwv/ltDhkXUdgVVOVsFTstipi83qH4hn+7B3j6
	 guX4Ku8rWKxcjTnh3sO3pfliN3JUk3A/r+ipdcG53jvVy5yJCYrTFSyhvCWj1JmLvF0jB
	 CXU8Vcq69TIzsllyPfuUp7gVoZRsmdf8WX5/2df1lXBe5gllnaOaCZUErnxkq1tHK7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793170956;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=zh/q/xvt7ZnvcrUlhy8wP327VxKlyfYobfQ9COGm7gA=;
	b=Pdsw6TwgdsL+UNhWOCThdXjw37kK2KAtuQce/w/Ex3ZolayOlLx485GC5NkWsyduPymQ
	 1QrKf2/NT3yIGJJnneD4gc8ByYixvrE0BmkMKiWOpvZdJpeLYHJQ0yZffU0ysu52ukY6D
	 1pReHMAsTD2NthXkpDasTtq3MyrRyYeDaHUSaYW8X8FuOEhVhscbkir29vAdYKv8LN2YN
	 VMp88SHxSpfFLTiyHEeuaKaj48U6fYxjZ4LbAwSeIHeG8XJoSpWT/U9DVOq30NpGt10Dd
	 6gSpSwWRJGpZFcVEaQLf7wtqlMlHUC9YdiUS4wDbEiR8QuY54WyJFzGMnW2gLkdoebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=o+ENkvTX;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7AA606A31D;
	Wed, 28 Oct 2026 07:02:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E7AA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=o+ENkvTX
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4iF2e287748;
	Wed, 28 Oct 2026 07:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=zh/q/xvt7ZnvcrUlhy8wP327VxKlyfYobfQ9COGm7
	gA=; b=o+ENkvTXMKm8syfqlvRYiwzvuZIBoM2Rc89bDrRF10OWBU+g9pUEeCJXu
	gus1J7J17mTSSvGAtYGnye7HcGwRQVl7Sa6642qvoibs3+3FiicLGZJkIhgA0w60
	eSnswaFbvplF0jic6Wv3d6tI5YzFI1x1OQkNOwKRW0vZ8ELylltvVAGtgc1SNAHT
	deEp5RjvIuH+ioOuvlwumMrSUPtow8QvC22FlxrDPmQW7W2/mIEEYCGgKxbhjppD
	p6cwBxjC4m06MfVqu6S9++59oUA/QCgM5BkiGdYvjUN8JkHSBtPkeR7EZ8kXzpTl
	iFVXh3H8Q/Ksp3SSNpolFEwXnpDCQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgmd73e29-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 07:02:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4YxjF1081712;
	Wed, 28 Oct 2026 07:02:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8gh6981-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 07:02:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69S72Nuh39846266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Oct 2026 07:02:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED49420040;
	Wed, 28 Oct 2026 07:02:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3F202004E;
	Wed, 28 Oct 2026 07:02:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 28 Oct 2026 07:02:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 8E36116165B; Wed, 28 Oct 2026 08:02:22 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v14] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Wed, 28 Oct 2026 08:02:10 +0100
Message-ID: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ZYOIpcVA c=1 sm=1 tr=0 ts=6ae19e04 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gHv3EBI5lFabm7VhXzcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDAyNiBTYWx0ZWRfX/5Z27Fz8/pPh
 meZ9uzSXh3g1wuSlduQDNcpS9aJ86UWUj/3cJTB4+GNuI7Gy/Zfu40N68C8dCqJyiTkzM0z6Oqf
 O79uRf1jUZjT/P0EZtrr4gZEuNQHWT1NIAi7aMRQZFG2NZwBtVDapTVLTvosCNIuAl5fzFOoCZZ
 c5C/eM5jfAYjFy70nW5bRS3QRsDfcK0eyS0quy6T5hIsXOH36AxZzuk1gd+bVCfMsfklbjwEDX0
 8kYtGJhxCul2DjgsLZt1RpPogL30JvaWqeK7/hKzwbwVvhPWXQJy2TPpxZ1HChiGQtleP7vSU1g
 Lh0xwfBw23USjTAlrRknY3a/71niSIRkla5fh9tDftw20m5eyNEIhA/jtYK8XqcZLRogr4qynuN
 Xnxi3Z59cMTN8G9lNwmqjNsxXt19PcfKu4GTctKZZ2vWoDo/ygNYETJZefUFTFjFW4s4yp3izra
 n/JYFe6BHktY4n0/dcA==
X-Proofpoint-GUID: tJkeMw2E9FC0kReabhTN7K66z9zAqTwi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDAyNiBTYWx0ZWRfX09K2ZFVJngs1
 4kA+UuUSXGo0MvWiwccncJjXQM1IOv4FWxb8iL+hDJ/wPgY2L7vWnfC0Pblq01oKNPypMKl07Sd
 pjCqx9VrbtZ4lHJ0BWlbBWnUT15OeAQ=
X-Proofpoint-ORIG-GUID: EsEL8QSJdz1n2rnmVTVGZf50MG95GfLW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280026

The diag dump walks the socket hash table under a read_lock and
dereferences conn->lgr and conn->lnk. Four paths expose a window where a
hashed socket has freed or partially freed conn/lgr/lnk state.

First, smc_conn_abort() calls smc_conn_free() during early handshake
aborts while the socket is still hashed in SMC_INIT, synchronously
freeing the lgr on the smc_lgr_cleanup_early() path without holding the
hash write_lock. A concurrent diag reader can load a non-NULL conn->lgr
and dereference lgr->is_smcd after the kfree. Skip the connection, link
group and DMB attributes in __smc_diag_dump() for sockets in SMC_INIT or
SMC_CLOSED, and for sockets that have fallen back to TCP, and do not
look at conn->lgr to determine diag_mode in SMC_INIT or SMC_CLOSED.

This changes the sock_diag output for such sockets. SMC_DIAG_CONNINFO,
SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are not read while a socket is in
SMC_INIT or SMC_CLOSED or has fallen back to TCP, and diag_mode is
SMC_DIAG_MODE_SMCR for a non-fallback SMC-D socket in SMC_INIT or
SMC_CLOSED. smcss does not use these attributes for such sockets. A
fallback socket is a plain TCP socket with no SMC connection state to
report; the stale conn fields left behind by smc_conn_abort() must not
be read. SMC_DIAG_FALLBACK is still reported. Use smp_load_acquire() /
smp_store_release() on sk_state to order these checks on weakly ordered
CPUs.

Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach()
NULLs and frees conn->sndbuf_desc while the socket is still hashed. A
concurrent diag reader entering the CONNINFO block can dereference the
freed descriptor. Unhash the socket right before smcd_buf_detach(). As a
result, killed ACTIVE and APPCLOSEWAIT sockets that are still open are
no longer visible to smcss on loopback-ism devices.

Third, in the terminal teardown branches of smc_close_active_abort()
(PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
smc_conn_free() drops lgr and lnk references while the socket is still
hashed. Unhash immediately before each smc_conn_free() call at those two
sites. Sockets killed in the PEERCLOSEWAIT1/2, PEERFINCLOSEWAIT,
PROCESSABORT and APPFINCLOSEWAIT states are therefore unhashed, and
their inuse accounting dropped, before close(), even if the fd is still
open. Whether a killed socket remains visible to smcss thus depends on
its close state and, for SMC-D, on the device type.

Fourth, smc_listen_out_err() sets sk_state =3D SMC_CLOSED with a plain
store after smc_conn_abort() -> smc_conn_free() has already cleared
alert_token_local under write_lock_bh(). On weakly ordered CPUs a
concurrent diag reader using smp_load_acquire() on sk_state can observe
SMC_CLOSED while the preceding store to alert_token_local has not yet
become visible, causing it to dereference an lgr whose reference was
already dropped. Use smp_store_release() to order the alert_token_local
clear before the sk_state =3D SMC_CLOSED store. If smc_conn_free() skippe=
d
the unregister because the link group was already unlinked by
smc_lgr_terminate_sched(), alert_token_local is still set; the
SMC_CLOSED check in __smc_diag_dump() keeps the reader from
dereferencing conn->lgr in that case.

Additionally, in __smc_diag_dump(), use the cached link->ibname instead
of link->smcibdev->ibdev->name to avoid a NULL pointer dereference or a
use-after-free of the IB device if __smcr_link_clear() zeroes the link
and the device is removed during concurrent SMC-R link failover. The
link data is still read without conns_lock or send_lock, so a dump
racing with a link failover may transiently report zeroed or mixed link
fields (ibname, ibport, link_id, GIDs). This does not affect memory
safety and the next dump reports the new link. Like the SMC netlink link
dump and the tracepoints, this reports the name at link creation time
and does not follow a later ib_device_rename().

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
Cc: stable@vger.kernel.org
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v14:
- smc_diag.c: also exclude SMC_CLOSED before dereferencing conn->lgr to
  determine diag_mode; a server socket that fails in
  smc_listen_decline() with rc < 0 reaches SMC_CLOSED hashed, with a
  stale alert_token_local left by smc_conn_free() when
  smc_lgr_terminate_sched() had already emptied lgr->list, and the lgr
  can be freed by terminate_work while a diag reader still holds the
  hash read_lock
- commit message: document the diag_mode change for SMC_CLOSED and the
  limits of the smp_store_release() in smc_listen_out_err()

Changes in v13:
- smc_diag.c: also skip the CONNINFO/LGRINFO/DMBINFO blocks for sockets
  with use_fallback set; the SMC_DIAG_FALLBACK attribute is still
  reported. After smc_lgr_terminate_sched() emptied lgr->list,
  smc_conn_free() skips smc_lgr_unregister_conn(), so a socket that then
  falls back and reaches SMC_ACTIVE can keep a stale alert_token_local
  and a diag reader could dereference the freed sndbuf/rmb/lgr; a
  fallback socket is a plain TCP socket with no SMC connection state to
  report
- smc_core.c: drop the v11 and v12 changes (unconditional
  smc_lgr_unregister_conn() in smc_conn_free() and the
  !lgr->terminating check in smc_lgr_schedule_free_work()); the v12
  check was racy against __smc_lgr_terminate() and the changes moved the
  patch away from the diag reader race, so smc_core.c is back to the v10
  change only; the Fixes tag for 2a0674fffb6b added in v11 is dropped
  with them
- commit message: state that using the cached link->ibname avoids the
  NULL pointer dereference and the IB device use-after-free, and that
  link fields may be transiently zeroed or mixed in a dump racing with a
  link failover, without affecting memory safety
- commit message: drop the claim that other kill paths leave the socket
  hashed; every smc_conn_kill() ends in smc_close_active_abort(), so
  sockets killed in the PEERCLOSEWAIT1/2, PEERFINCLOSEWAIT, PROCESSABORT
  and APPFINCLOSEWAIT states are unhashed before close() even if the fd
  is still open, and the dmb_nocopy unhash hides ACTIVE/APPCLOSEWAIT
  sockets on loopback-ism; smcss visibility thus depends on close state
  and device type; this supersedes the v10 entry below

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
- smc_core.c: move the unhash out of the top of smc_conn_kill() into the
  smc_ism_support_dmb_nocopy() branch, right before smcd_buf_detach(); th=
e
  other kill paths leave ACTIVE/APPCLOSEWAIT sockets open, so they must
  stay visible to smcss and keep their inuse accounting
- commit message: document the sock_diag output changes for sockets in
  SMC_INIT and SMC_CLOSED (extension attributes omitted, diag_mode of
  SMC-D in SMC_INIT) and that ibname is the name cached at link creation

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
  a Fixes tag for ae2be35cbed2 for the smc_conn_kill() hunk since
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
 net/smc/smc_core.c  |  4 +++-
 net/smc/smc_diag.c  | 13 +++++++++----
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index XXXXXXX..XXXXXXX 100644
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
index XXXXXXX..XXXXXXX 100644
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
@@ -433,6 +435,7 @@ wakeup:
 		sk->sk_state_change(sk);
 		if ((sk->sk_state =3D=3D SMC_CLOSED) &&
 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
+			sk->sk_prot->unhash(sk);
 			smc_conn_free(conn);
 			if (smc->clcsock)
 				release_clcsock =3D true;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index XXXXXXX..XXXXXXX 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1530,8 +1530,10 @@ static void smc_conn_kill(struct smc_connection *c=
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
index XXXXXXX..XXXXXXX 100644
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
+	else if (r->diag_state !=3D SMC_INIT && r->diag_state !=3D SMC_CLOSED &=
&
+		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
 		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
 	else
 		r->diag_mode =3D SMC_DIAG_MODE_SMCR;
@@ -103,6 +104,10 @@ static int __smc_diag_dump(struct sock *sk, struct s=
k_buff *skb,
 	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
 		goto errout;

+	if (r->diag_state =3D=3D SMC_INIT || r->diag_state =3D=3D SMC_CLOSED ||
+	    smc->use_fallback)
+		goto out;
+
 	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
 	    smc->conn.alert_token_local) {
 		struct smc_connection *conn =3D &smc->conn;
@@ -154,8 +159,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
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


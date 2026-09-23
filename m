Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643231C5D72;
	Wed, 23 Sep 2026 06:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144299; cv=none; b=gs2bIj6C1j5ai4BTcwd86V7i/ahWrunFP2Zlw5Nm/g57okp2PYDeJPee4gKZSEAQuKaGcZYrGzJje285YK2KwbjOBr6krj/V8DSI1eIrDuBoJwigkcUEdERZ6dyRwRlq2he+vAa/NhJUjTybc2ebPfbIq7JwYpO+nerQqztvWuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144299; c=relaxed/simple;
	bh=Uu748ubSW/QQrB+QXJmWruZIuhi/YzA1i5UWxRViIfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxOitRwSiwZrRsnNTfAZx7843xdOjMz8Go3tVykxg0gfvLVgS0UJAaWJFufrbziEDWwNV21J8KDvHenC+avXXIjj0s+WJ8BxZ2OutSL33ltJDUc0GRbi85hFLilQLZ4pRsSm1RIJ5sOEYJJ6A3WPulY6zILBCPwXr1ggn9bV6zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bEVfyl+f; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bEVfyl+f"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N45aYI2189290;
	Wed, 23 Sep 2026 06:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=G6CDeaTQ+93ah+yEXVxJiAaK+t3iA5aoxjUfAluYM
	5M=; b=bEVfyl+ftVnoDVLXOuVPWaTK5zOpg2LvlzkqU8n6Uafaa8xE2d3If8nrx
	jSru73RNsCZmE7m8+VdrnQsV4K90Lainm2zOggfnuWwMs/KwJ5LgMr5jIGQ3Xe16
	B+WUSwbzzfeFfxHYJzXGj3ddhU6F+/+MQV1NvLfBwM0Hcrys0P/agff3H+ZV0P/1
	fFtmH0d2BZUINDE4Zc9gjC6FWfTVGidNjWqNfcN+3uM8GEuTeN1qC0kX4XRT0C93
	uaZHlyF1mwTvnuQoZlOjb/kcSqoDShq35PjbC0Ji1E+hS86N23oivmz6mbT/s2MK
	oloCYfoqLKJvYSx/YvFSv44ebh0fA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1h7d0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 06:18:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68N3lXsp3855379;
	Wed, 23 Sep 2026 06:18:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt67gvybu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 06:18:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68N6I41125952632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Sep 2026 06:18:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 207C120043;
	Wed, 23 Sep 2026 06:18:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5E7420040;
	Wed, 23 Sep 2026 06:18:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 23 Sep 2026 06:18:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id BB6B11616BB; Wed, 23 Sep 2026 08:18:03 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Wed, 23 Sep 2026 08:17:16 +0200
Message-ID: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RdAdVqKNJ-tSIJhEmn9rQoIJ3aCTtQAC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAyNCBTYWx0ZWRfXxYJS0UlF3FoQ
 QrCcFz+kNnZEMxdoLm52BW/deXppkyzlVZd/nkOx6T/bfnnV40cXUy8V6MT+vN9wC7j1PlDWRWc
 oz5/lTfTMXQEnmW/GTDVYCCoGYBTuEOK1bZXZsr19oMt7Dz8UlaZQeThBss0GVo07deS8Z+I3NO
 /99IgI1zkFdU7AjJk9cdub3eJv61ALtafz85g//Ug7z6krkL0gBuHAvbs+IUtYt5rQRgUtnOMhg
 OFCrrhPkukY9/p9YTnu6WRPE+RU3ScyUb79uMAdspOYP7hSNa31fx7+gIB6t9b3e0Lv9LkIdV/n
 4ZF0JRRHgDdn+Nrh5fJ0vaY6ck9GWTOVdEY4m2XLQ4+7F3oYPWIvOz5uNZam7ldv/vUuW1Mu+N7
 JLMqFL1N/2Z/j3PJ361w9G4iI9yZ1rbsZta5deIlz6YM4JoYk3BvSCYXhmh/zqA9aMKnqtgUBFp
 p9VnixRqyktwGAK38Zw==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab36f21 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=G6lVKk-lwKvxZUKr5V8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAyNCBTYWx0ZWRfX6huBAfbGwSsf
 q46aQbNsy4x1PuuKPZAX7CK7dd5STxXxgQW7PM7SlmQrNop6dZcY9i78iTG9o8s7LhWw7Jh4HjG
 VOHznGPdy8Pd72Aff7YBJRFRClz6i5o=
X-Proofpoint-GUID: ZIWTCR-ljzvfso0WB8jBl2TIOCSXSJX0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230024

The diag dump walks the socket hash table under a read_lock and dereferen=
ces
conn->lgr and conn->lnk. Two terminal teardown paths drop those reference=
s via
smc_conn_free() while the socket is still hashed:

  - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
  - smc_close_passive_work() -> smc_conn_free()

This allows the diag reader to dereference a freed lgr or lnk.

Fix it by unhashing the socket before smc_conn_free() is called at the tw=
o
terminal teardown sites in smc_close.c.

Additionally, smc_conn_abort() calls smc_conn_free() during early handsha=
ke
aborts while the socket remains hashed in SMC_INIT state. The
smc_listen_out_err() path leaves the socket hashed in SMC_CLOSED state af=
ter
smc_conn_abort() returns. Guard the conn/lgr/lnk inspection blocks in
__smc_diag_dump() by skipping them when the socket is in SMC_INIT or SMC_=
CLOSED
state.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
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

 net/smc/smc_close.c | 10 ++++++++++
 net/smc/smc_diag.c  |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bb0313ef5f7c..3940098c651d 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -130,6 +130,11 @@ void smc_close_active_abort(struct smc_sock *smc)
 	struct sock *sk =3D &smc->sk;
 	bool release_clcsock =3D false;

+	/*
+	 * Unhash before any branch calls smc_conn_free() and drops lgr/lnk ref=
s;
+	 * the diag reader must not see a hashed socket with freed lgr/lnk.
+	 */
+	sk->sk_prot->unhash(sk);
 	if (sk->sk_state !=3D SMC_INIT && smc->clcsock && smc->clcsock->sk) {
 		sk->sk_err =3D ECONNABORTED;
 		if (smc->clcsock && smc->clcsock->sk)
@@ -433,6 +438,11 @@ static void smc_close_passive_work(struct work_struc=
t *work)
 		sk->sk_state_change(sk);
 		if ((sk->sk_state =3D=3D SMC_CLOSED) &&
 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
+			/*
+			 * Unhash before smc_conn_free() drops lgr/lnk refs so the diag
+			 * reader cannot see a hashed socket with freed lgr/lnk.
+			 */
+			sk->sk_prot->unhash(sk);
 			smc_conn_free(conn);
 			if (smc->clcsock)
 				release_clcsock =3D true;
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index bf0beaa23bdb..fb615d3af058 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -103,5 +103,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
 		goto errout;

+	if (sk->sk_state =3D=3D SMC_INIT || sk->sk_state =3D=3D SMC_CLOSED)
+		goto out;
+
 	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
 	    smc->conn.alert_token_local) {
@@ -185,5 +188,6 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
 			goto errout;
 	}

+out:
 	nlmsg_end(skb, nlh);
 	return 0;
--=20
2.43.7

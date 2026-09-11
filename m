Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAA346EC99;
	Fri, 11 Sep 2026 09:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117765; cv=none; b=Y419yUyQi+UR53fkjjFcXx6pMemnZqLqSRKo0QNb5t4DQHCPEw5YiFBox0i5m0DGy+C8jzg+DyZjR71XDHvc+wwT/JO6qieHkVGDY21UcC5LiBr/8tE1fV4c2DfDpIlotpEquEqz4x+q37dI2ofvrPWM0q7YKhLflPyOVqXUC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117765; c=relaxed/simple;
	bh=jDQzWSty4Iaz0vBPA+gOeokR+Yvwp8eRSnA19nxlPCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxxIe+xR59lTSWiX5jH6LCe6vd+lhNO45+5RdkLM+/1qTvkHLBUoHSeYIQcTXYc7prXRKZw++zqakbutG++e3GyH9gorgH9pai0tYA6djlOqvVu0JIO5/jaZHRQX+iUhe9+oxkDyE5UHuvjeyqJxJsEDWR+ReFJ4POo1XlACnxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rh0lEU3l; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rh0lEU3l"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B81hKK3537107;
	Fri, 11 Sep 2026 09:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=FxFfF6cUNiHIe8ehi3XMTBOmWFpiAPGP8ZPMGKt5Y
	Do=; b=rh0lEU3lAyQgEFnsPlQ2MWAxTgJ6ZKp8LqvoBmTx7ezEm4hZXnPxHEqeJ
	lXOPA5FHTOwqvREXvjIF43mZERq1na0zqJXDYCegq1o4Za7U/kMtaqrRTAdq+/6h
	JoyYhepJG7mPJK7vEYw8iWNLhgWqcZxHwzRwxnuK6Ki2cVYNP/+qquUm6vaMMHQ2
	64lAa5DTkpaU0f3Ombc+7o0ukHZL8ozFjsZKNLJl81CdgSTU4drpS2M9KbmG3Gdr
	JZ97zLerdvfVNeG2GBmzPuBq7IuZGqxkQw1S12pPPAjs93jLU1HrsJrcYtFb3OFF
	1g4t9fFmAQIPoSaTTlbbwmpgyEcQA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8naf4y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 09:09:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B7o4oD1280913;
	Fri, 11 Sep 2026 09:09:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrdc97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 09:09:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B999h450397564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 09:09:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EA9C20040;
	Fri, 11 Sep 2026 09:09:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56D2B2004E;
	Fri, 11 Sep 2026 09:09:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 11 Sep 2026 09:09:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 3915A16115A; Fri, 11 Sep 2026 11:09:09 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hidayath@linux.ibm.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Fri, 11 Sep 2026 11:09:06 +0200
Message-ID: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa3c53b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=zrz6I-INSVoQeSQ5hhQA:9
X-Proofpoint-GUID: xeRjunLFklJspHZSjX0XLGBvyztBDnHY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDEyNiBTYWx0ZWRfX/lO+LcRbcqKd
 QijLZEnae5QZLoyYKoxWViN5K8UHtm+N6OpI3yYNhAfA2biXufDJbj85F8SEdkNv0wI2iY5yCfw
 BNxjIWjPn3us2+rAbjHSakquFfDvRehfVXWe+0ljohP9/tBhgEFwas8NabMA0CG9Scg5N9IrkCd
 FgtKItGUDJaWvbhW87I2j0W6R3upHdUuWcjWoqVkPTeN4buEdTrrcsSgKI5WW1KOJz4QbauuWS6
 v4Ljukxwh3IAQkRRPt6sXJR2Sk4ccCfRvDtSAQpXNJaxmDm8nNr5AT/r7Yhr5GvVf+/1GQqu8gE
 ByhPwsUH56w6cw8l84i4ITVliDT475Gv6YRSXx6KKyUg/tm+mzLWo5o++4ZMPe5+uY67nUahAr3
 hr2r0LD2IC8KTPT+um0mW100TyIy5HiKgNMUF8ye3EResNPkiRAQlivXZbHHI/fjNwQy5C7ynPD
 YoSyPZ8QMI36Kv/uZ/Q==
X-Proofpoint-ORIG-GUID: FIS-Aq8n1wAYO1hi1m-5ii3-_vRXLqP_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDEyNiBTYWx0ZWRfXzDk7QL6j7bEW
 fnlzTSmxsp7at6cfBi3tMiTPjJ+VtCWGXaNMoL7ha+QBC4I1ZsqXvMupnVJrzrflETZizSuzKPJ
 lYfUflhOqYKL8uvPI044KqnB113dolc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110126

The diag dump walks the socket hash table under a read_lock and dereferen=
ces
conn->lgr and conn->lnk.  Two terminal teardown paths drop those referenc=
es via
smc_conn_free() while the socket is still hashed:

  - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
  - smc_close_passive_work() -> smc_conn_free()

This allows the diag reader to dereference a freed lgr or lnk.

Fix it by unhashing the socket before smc_conn_free() is called at each o=
f these
two sites.  Any socket visible to the diag reader under the hash read_loc=
k then
has valid conn->lgr and conn->lnk pointers.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v4:
- dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
  changes to af_smc.c, smc.h, smc_core.c and smc_core.h; smc_unhash_sk()
  is already idempotent via sk_hashed(), so direct calls at the two
  teardown sites in smc_close.c are sufficient
- dropped the __smc_release() hunk: it needs no change since the
  subsequent unhash there is already a safe no-op
- fixed premature-unhash issue present in v3: smc_conn_free() must not
  unhash because smc_conn_abort() calls it before smc_switch_to_fallback(=
)
  in both smc_listen_decline() and smc_connect_rdma() error paths;
  unhashing there would make live fallback sockets invisible to smcss
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
 1 file changed, 10 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bb0313ef5f7c..9e4b4e9b9d08 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -128,6 +128,11 @@ void smc_close_active_abort(struct smc_sock *smc)
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
@@ -432,7 +436,12 @@ static void smc_close_passive_work(struct work_struc=
t *work)
 	if (old_state !=3D sk->sk_state) {
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
--=20
2.43.7

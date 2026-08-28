Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8503CB554;
	Fri, 28 Aug 2026 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900109; cv=none; b=HoPrUwiexknaDpRtsiPbk0J33HXOZz2Uq4Mj4iQtN9CuKIckTFbu7w9vImuL9/s9xiZ7cyv2adIM4QG346i5B1FoFOSFMcEvhXZpW2Ai2lSdawijyWJA9uS/0ahrA2rOfDWM94ww8Rrs0NKP9zEfqbp6pKmvIurQ6vptX6QLTbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900109; c=relaxed/simple;
	bh=LK9coVivaEg6X7pyagvSH/oxJLLh/lXIGvmAeUZugI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccjBkpmxcFL5cX//KZBdIabAKS7tyJILHd90FA/iMERTKNTm0S8T80s5bXVfv6gYJsNXDy3OG3DexHnDpfH4d9H1mZ/cYdElQnwEhCYgxnYOvp356paDE9Q0BMPspVEsgdGuFUot438hkxNuThWmAgT6ViLT1tYQkB1nQaapLJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TAlpaHkS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TAlpaHkS"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S6VcJK1265199;
	Fri, 28 Aug 2026 06:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=A40Vc1mh0XS9Z4S9a
	2t2St9YNWjs5QnCiHvbMash+Cw=; b=TAlpaHkSoTnC22KSEFg9H9GDu+SorR80H
	dfnKtFDL0fXvhRLUt7iAB3ww6F871plR3IN02CVHzhlzskc9qJ3nhjheNP1Q+Xcc
	2M/p/jIu4Q5/CoX1fDqbhyc0OCtFWa4NKL2p+LE8lMBs9nIYhKV2zv6CiuGKB+Fm
	NH7m02LSzBqk22tT7MnDB6Mb/+RQ695VNfp0KtFAAfLFhrLIcwQU/AXF0whK1y1/
	El4TBDLPfQ2XZ/vvOOHkBAosNaBWaHeGFkO8oGdF9Vep/rqT1rNVyCD1kssoQm93
	e2+E4Sp3v6RTbXF1QT6nbpA6/mu4OohU2k43Y9Jto/iNzvbSgOD+Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73dxt6ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:55:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67S6QP2h009516;
	Fri, 28 Aug 2026 06:54:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkhmqyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:54:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67S6stIV39846202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 06:54:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AD4D2004B;
	Fri, 28 Aug 2026 06:54:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EA6420049;
	Fri, 28 Aug 2026 06:54:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 28 Aug 2026 06:54:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 1A45C16161F; Fri, 28 Aug 2026 08:54:55 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v2 2/2] net/smc: fix races in smc_diag dump path
Date: Fri, 28 Aug 2026 08:54:39 +0200
Message-ID: <20260828065439.3582783-3-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfXyWXRDcIKoHTr
 ryjxHSLnL2vBSqy3alPggwd0mR+/CFpdytuuwDXz1CVAhIqvGtpKfv7NDeab7QzLoDGkv/CkdXI
 5BEghAT/Qf1g5OJZeGHQbfZKnChPc5s=
X-Authority-Analysis: v=2.4 cv=AYuB2XXG c=1 sm=1 tr=0 ts=6a9130c4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=1D_QaxW2Y1NEVYoI354A:9
X-Proofpoint-ORIG-GUID: Bm7krsO1TqWXhTYBYmuApEmp7GmLRUmG
X-Proofpoint-GUID: a0cIJQrVdK67meDY1Rra8XgvsZS9uj7a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfX1OXpnI5Rjdhn
 Xo+q+voTNg/MTbQKy3CQnWHz/rR/sg7/yDYXCL6+rCCVd8CLHRTP6c6R/EpzdJHzWEKTJ/W/FxV
 NkFM0dd0O25OnFNwDF/qBTNFuh3VkiI6rFa6ScWvs+p3c1KXgxrdXgROOw7ipbDSjvRzctjLQul
 deZbDWu1Q3nnwK/Gm0oNOqA7sTSmlkHJD+9dSoAfCLsxh+yuacp1lg0XaP0C/rLKd0wFwYexjWG
 uG4CDRCXf+kaXmUr+AAybUDKE8rKBN4I5G0TWnLGy+bMq0U3SidQcLBz6Vs9ZFjRS+1Vsl826ff
 xAjaC3XcSVnCAlH6t0RM1K2Pp7iVpgAPUHe/ym4X2p/SKPw4deZ05J3DOThA4yQ9E57x62Xp9Sz
 mkGvp41Fj/gpC+QbwivZTM2xw6aijRmI067ZCABm1QHBMj0CCynaydbDDlXRRYy+Jvhpwl1MlvN
 ajirqaamT8HuL0lsk0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608280054

Two races exist in the SMC diag dump path.

Race 1: smc->clcsock can be set to NULL by smc_clcsock_release() after a =
bare
NULL check in smc_diag_msg_common_fill() and before the subsequent field =
reads.
Use mutex_trylock() on clcsock_release_lock to serialize the check and th=
e reads
with that writer. If the lock cannot be taken, teardown or fallback is in
progress; leaving address fields zeroed is a safe transient gap for a mon=
itoring
tool.

Race 2: conn->lgr and conn->lnk can be torn down concurrently by
smc_conn_free(). Take conn->lgr_lnk_lock when accessing these fields in t=
he dump
path. This covers three sites: the diag_mode classification
(conn->lgr->is_smcd), the SMC_DIAG_LGRINFO block, and the SMC_DIAG_DMBINF=
O
block. In each case, fields are snapshotted into local variables under th=
e lock
and used after releasing it.  With patch 1/2, a non-NULL conn->lgr seen u=
nder
that lock guarantees the lgr is alive. conn->lnk is likewise valid when n=
on-NULL
under the lock. nla_put() is called after releasing the lock.

This design avoids borrowing an extra lgr reference, which would require
smc_lgr_put() to be called inside __smc_diag_dump() -- a problem because
smc_diag_dump_proto() holds an atomic read_lock for the duration of that =
call.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index bf0beaa23bdb..06db3d769929 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,8 +39,20 @@ static void smc_diag_msg_common_fill(struct smc_diag_m=
sg *r, struct sock *sk)
 	memset(r, 0, sizeof(*r));
 	r->diag_family =3D sk->sk_family;
 	sock_diag_save_cookie(sk, r->id.idiag_cookie);
-	if (!smc->clcsock)
+	/* smc_clcsock_release() sets smc->clcsock =3D NULL under
+	 * clcsock_release_lock. Use mutex_trylock() to make the NULL check and=
 all
+	 * field reads atomic with that writer. mutex_trylock() is safe under t=
he
+	 * hash read_lock held by smc_diag_dump_proto() because it never sleeps=
. If
+	 * it fails, the socket's clcsock is being modified or released (teardo=
wn
+	 * or fallback transition); leaving address fields zeroed is a safe
+	 * transient gap for a monitoring tool.
+	 */
+	if (!mutex_trylock(&smc->clcsock_release_lock))
 		return;
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return;
+	}
 	r->id.idiag_sport =3D htons(smc->clcsock->sk->sk_num);
 	r->id.idiag_dport =3D smc->clcsock->sk->sk_dport;
 	r->id.idiag_if =3D smc->clcsock->sk->sk_bound_dev_if;
@@ -55,6 +67,7 @@ static void smc_diag_msg_common_fill(struct smc_diag_ms=
g *r, struct sock *sk)
 		       sizeof(smc->clcsock->sk->sk_v6_daddr));
 #endif
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
 }
=20
 static int smc_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
@@ -88,12 +101,18 @@ static int __smc_diag_dump(struct sock *sk, struct s=
k_buff *skb,
 	r =3D nlmsg_data(nlh);
 	smc_diag_msg_common_fill(r, sk);
 	r->diag_state =3D sk->sk_state;
-	if (smc->use_fallback)
+	if (smc->use_fallback) {
 		r->diag_mode =3D SMC_DIAG_MODE_FALLBACK_TCP;
-	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
-		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
-	else
-		r->diag_mode =3D SMC_DIAG_MODE_SMCR;
+	} else {
+		bool is_smcd =3D false;
+
+		spin_lock_bh(&smc->conn.lgr_lnk_lock);
+		if (smc_conn_lgr_valid(&smc->conn))
+			is_smcd =3D smc->conn.lgr->is_smcd;
+		spin_unlock_bh(&smc->conn.lgr_lnk_lock);
+		r->diag_mode =3D is_smcd ? SMC_DIAG_MODE_SMCD
+				       : SMC_DIAG_MODE_SMCR;
+	}
 	user_ns =3D sk_user_ns(NETLINK_CB(cb->skb).sk);
 	if (smc_diag_msg_attrs_fill(sk, skb, r, user_ns))
 		goto errout;
@@ -143,45 +162,57 @@ static int __smc_diag_dump(struct sock *sk, struct =
sk_buff *skb,
 			goto errout;
 	}
=20
-	if (smc_conn_lgr_valid(&smc->conn) && !smc->conn.lgr->is_smcd &&
-	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
-	    !list_empty(&smc->conn.lgr->list)) {
-		struct smc_link *link =3D smc->conn.lnk;
-
-		struct smc_diag_lgrinfo linfo =3D {
-			.role =3D smc->conn.lgr->role,
-			.lnk[0].ibport =3D link->ibport,
-			.lnk[0].link_id =3D link->link_id,
-		};
-
-		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
-		       sizeof(link->smcibdev->ibdev->name));
-		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
-		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);
-
-		if (nla_put(skb, SMC_DIAG_LGRINFO, sizeof(linfo), &linfo) < 0)
+	if (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) {
+		struct smc_connection *conn =3D &smc->conn;
+		struct smc_diag_lgrinfo linfo;
+		bool lgr_valid =3D false;
+
+		memset(&linfo, 0, sizeof(linfo));
+		spin_lock_bh(&conn->lgr_lnk_lock);
+		if (smc_conn_lgr_valid(conn) && !conn->lgr->is_smcd &&
+		    conn->lnk && !list_empty(&conn->lgr->list)) {
+			linfo.role =3D conn->lgr->role;
+			linfo.lnk[0].ibport =3D conn->lnk->ibport;
+			linfo.lnk[0].link_id =3D conn->lnk->link_id;
+			memcpy(linfo.lnk[0].ibname,
+			       conn->lnk->smcibdev->ibdev->name,
+			       sizeof(conn->lnk->smcibdev->ibdev->name));
+			smc_gid_be16_convert(linfo.lnk[0].gid,
+					     conn->lnk->gid);
+			smc_gid_be16_convert(linfo.lnk[0].peer_gid,
+					     conn->lnk->peer_gid);
+			lgr_valid =3D true;
+		}
+		spin_unlock_bh(&conn->lgr_lnk_lock);
+		if (lgr_valid &&
+		    nla_put(skb, SMC_DIAG_LGRINFO, sizeof(linfo), &linfo) < 0)
 			goto errout;
 	}
-	if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd &&
-	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
-	    !list_empty(&smc->conn.lgr->list) && smc->conn.rmb_desc) {
+	if (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) {
 		struct smc_connection *conn =3D &smc->conn;
 		struct smcd_diag_dmbinfo dinfo;
-		struct smcd_dev *smcd =3D conn->lgr->smcd;
-		struct smcd_gid smcd_gid;
+		bool lgr_valid =3D false;
=20
 		memset(&dinfo, 0, sizeof(dinfo));
-
-		dinfo.linkid =3D *((u32 *)conn->lgr->id);
-		dinfo.peer_gid =3D conn->lgr->peer_gid.gid;
-		dinfo.peer_gid_ext =3D conn->lgr->peer_gid.gid_ext;
-		copy_to_smcdgid(&smcd_gid, &smcd->dibs->gid);
-		dinfo.my_gid =3D smcd_gid.gid;
-		dinfo.my_gid_ext =3D smcd_gid.gid_ext;
-		dinfo.token =3D conn->rmb_desc->token;
-		dinfo.peer_token =3D conn->peer_token;
-
-		if (nla_put(skb, SMC_DIAG_DMBINFO, sizeof(dinfo), &dinfo) < 0)
+		spin_lock_bh(&conn->lgr_lnk_lock);
+		if (smc_conn_lgr_valid(conn) && conn->lgr->is_smcd &&
+		    conn->rmb_desc && !list_empty(&conn->lgr->list)) {
+			struct smcd_dev *smcd =3D conn->lgr->smcd;
+			struct smcd_gid smcd_gid;
+
+			dinfo.linkid =3D *((u32 *)conn->lgr->id);
+			dinfo.peer_gid =3D conn->lgr->peer_gid.gid;
+			dinfo.peer_gid_ext =3D conn->lgr->peer_gid.gid_ext;
+			copy_to_smcdgid(&smcd_gid, &smcd->dibs->gid);
+			dinfo.my_gid =3D smcd_gid.gid;
+			dinfo.my_gid_ext =3D smcd_gid.gid_ext;
+			dinfo.token =3D conn->rmb_desc->token;
+			dinfo.peer_token =3D conn->peer_token;
+			lgr_valid =3D true;
+		}
+		spin_unlock_bh(&conn->lgr_lnk_lock);
+		if (lgr_valid &&
+		    nla_put(skb, SMC_DIAG_DMBINFO, sizeof(dinfo), &dinfo) < 0)
 			goto errout;
 	}
=20
--=20
2.50.1 (Apple Git-155)


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506620;
	b=cUN5BeXOfwT2KlRMSFWerWJQLZC6dx0MAV8tiCrPd6k8K2ddN82/rejSoO+LPx5QVuah
	 pnaQAlzzonoUzXddwzMRmjAY7iM03QEEeNFU9iti516048GnrCnF9JIT1rCbjI2O4xZKS
	 UcxCNnq+VA/PkaiPmSwc9EGuHTHxGgaojHmMa2ywtmqXSqx1hVHP3t/JdyVzBbZSrihM5
	 BZYiRX7jTM5DzO0byQVsFwhFQjIdhfkrfw5DEduIdyHwFBxbfkFMyktXJSB6uiJORE7XH
	 YfSu31O20UA3RdwgTbN9FAsW/CSj0LtTv7AvxmIkrR7MTdSwyPQu3sXQN+c2kRstKEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506620;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=d/ScMjDTdZjQ0BTpNHSS+kgxqfX+lqvUwknkpxTB7IE=;
	b=svDbB4841kYLi0UL1bO2bu1vSAKkacB+502GB/ULc6oskhUzoEpNR8B03s3LA8egamDl
	 P8a6K2HSvlsUozElS5i5quzFV16nXIMshBTeL74LMiTMLaSd1z0+UXIeH8jBe5p/ln5v8
	 Izytya36RiLB6M1EG86exChmVVqvxQQzDFDMOMrkD2kdVmoxtRVzy3wEjbW/drBKUl2q2
	 NK23NrPzkFPOtlgLpyA4tuG+qe++dLxwxuCexsJGCifYqH4b11abIjO0CleJXHee1Md81
	 9FQLdSNBk6OCt/pOjA1yjizHJCmMd3c/nXlLw/Alxc0u+/o5dTt5W6G9RXvgVaCU0wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CjqiRmjC;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E7E606A31E;
	Tue, 24 Nov 2026 07:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90E7E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CjqiRmjC
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO35SRe003612;
	Tue, 24 Nov 2026 07:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=d/ScMjDTdZjQ0BTpN
	HSS+kgxqfX+lqvUwknkpxTB7IE=; b=CjqiRmjCXQQlTkf0MC6mrpaVJXiwZMnW+
	yoMFVdBVV68OKqblxA/q6GgyYVsztEIqQn9fnZPWzq7TOBuF6zcRYLwhDoBTEZ2g
	nYhUl/p8yshLUW7bsjvMp+kK9I4b+IpLktZVPY3A5uqd6IER3f3A1f4HDUcctnzL
	Vs9CklpMkc6F796NA0PWB1zS58xmfCMP+zPttXl5bViheQZbI18Uh4B8rVKwWNU1
	+oIBZpAjV8Xk6FPkHihuOEROP5u7Gzz2pIwQZVldcezIw09FUqYId4LTVNrIsZLH
	IXIArkZOiy9v5sFMzCR5OsggHpYBf3kLe5S9OamzhmicoOXtM9sWQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4e4kj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:50:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nK2B021916;
	Tue, 24 Nov 2026 07:50:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3pmk1rvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:50:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7o2wn42140046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:50:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23D172004D;
	Tue, 24 Nov 2026 07:50:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E16B920040;
	Tue, 24 Nov 2026 07:50:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 07:50:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id CC71F1616BE; Tue, 24 Nov 2026 08:50:01 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next v2 3/3] net/smc: document the clcsock lifetime
Date: Tue, 24 Nov 2026 08:49:27 +0100
Message-ID: <20261124074927.3622245-4-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
References: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX3Pf2pL3nl1y6
 IdQ4G3hTSEC9qc2MpyzccjYMcViewYyoKfv65rS/2i3/Mp+7iWxGOI9r7ty51+TiUFphRfGAurz
 Yys45YM903H9d4f/vEvSuTLbCjL3XsE=
X-Proofpoint-GUID: cfK_VD-D_h2G4fxX02AuT67FB5O5624Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX6rFRKVG9Zig5
 qZsLTwS74SzwKnFUOFK1uoo/BCT0eY6Hj49xLJfrX6sfoQuT6S1LE8OJxW1NMho3gJwURv1ujFU
 yednlWW4j6k4/AauGcofCXvmxVXv/sZ6RyNSV4Bk3vdwAlXJI6u1twJNyg+F2JyKyqOkZjbhJTC
 2BHY6P7aev/kZhJY5iiP2sSVeJRNoWSUMYUemJhugq52ONFtsOWV57dT00pNiozsATR3P06YVv9
 iNYYQQ5A1FkJGVN68vRS7/14XI+yOLDkKa1dJVamL+Vmye2Zi94tf3YBkgHUxaTkkaanKmiRBqe
 3qoPZ25/iEYFlatqffSZkr00cXhaVhaTSKOtkWf3B95vfp3YOUi0DQ6aooBDeHuec1D0HuIb3ng
 CpomcAVMbx+sLRdSjkqCRHd4ykUrkJRnhD9Bb3YutSiDPtlfbtG0USrv1AbiKyqBvhLKNlOSwtl
 YD7JGcXEeTZlcIX1TVg==
X-Proofpoint-ORIG-GUID: 41Mut2htOV48vOIJRN8Ijeoaft_Jzybd
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b0541b0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=yV60tvTADACx1VT-17AA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240030

The clcsock is freed only when no socket file can reference it. Record
that invariant where it is relied upon: at the clcsock field, at the
release helper, at the diag dump, which can find a socket before its
clcsock has been created, at the accept cleanup, which must not wait for
the listen work with the child and listener locks held, and in the
destructor, which warns if a clcsock is left.

Freeing the clcsock from the destructor is not possible: it can run from
an RCU callback or a softirq.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c    | 13 +++++++++++++
 net/smc/smc.h       |  4 +++-
 net/smc/smc_close.c |  7 ++++++-
 net/smc/smc_diag.c  |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 7fd79bb..912da20 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -373,6 +373,14 @@ out:

 static void smc_destruct(struct sock *sk)
 {
+	struct smc_sock *smc =3D smc_sk(sk);
+
+	/* The destructor can run from an RCU callback or a softirq, where
+	 * sock_release() must not be called. Every path that drops an SMC
+	 * socket therefore releases its clcsock before the final
+	 * sock_put().
+	 */
+	WARN_ON_ONCE(smc->clcsock);
 	if (sk->sk_state !=3D SMC_CLOSED)
 		return;
 	if (!sock_flag(sk, SOCK_DEAD))
@@ -1825,6 +1833,11 @@ struct sock *smc_accept_dequeue(struct sock *paren=
t,
 		lock_sock(new_sk);
 		if (new_sk->sk_state =3D=3D SMC_CLOSED) {
 			new_sk->sk_prot->unhash(new_sk);
+			/* The child is on the accept queue, so its
+			 * smc_listen_work() no longer uses the clcsock. Do not
+			 * wait for that work here, the child and listener locks
+			 * are held.
+			 */
 			tcp =3D xchg(&isk->clcsock, NULL);
 			release_sock(new_sk);
 			if (tcp)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 616bb32..c6bfe63 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -288,7 +288,9 @@ struct smc_sock {				/* smc sock container */
 		struct sock		sk;
 		struct inet_sock	icsk_inet;
 	};
-	struct socket		*clcsock;	/* internal tcp socket */
+	struct socket		*clcsock;	/* internal tcp socket, freed
+						 * when no file can use it
+						 */
 	void			(*clcsk_state_change)(struct sock *sk);
 						/* original stat_change fct. */
 	void			(*clcsk_data_ready)(struct sock *sk);
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index e71245d..d359436 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -20,7 +20,12 @@
 #include "smc_cdc.h"
 #include "smc_close.h"

-/* release the clcsock that is assigned to the smc_sock */
+/* Release the clcsock.  Call this only after the socket has been
+ * unhashed, and only when no socket file can reach the clcsock: from
+ * smc_release(), from the listener cleanup, and from the abnormal
+ * close paths once the socket has no file left. While a file is open,
+ * the clcsock stays in place until smc_release() runs.
+ */
 void smc_clcsock_release(struct smc_sock *smc)
 {
 	struct socket *tcp;
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 15485a0..42828ff 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,6 +39,9 @@ static void smc_diag_msg_common_fill(struct smc_diag_ms=
g *r, struct sock *sk)
 	memset(r, 0, sizeof(*r));
 	r->diag_family =3D sk->sk_family;
 	sock_diag_save_cookie(sk, r->id.idiag_cookie);
+	/* The socket is hashed in smc_sk_init(), before its clcsock is
+	 * created, so a dump can find it without one.
+	 */
 	if (!smc->clcsock)
 		return;
 	r->id.idiag_sport =3D htons(smc->clcsock->sk->sk_num);
--=20
2.50.1 (Apple Git-155)


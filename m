Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506601;
	b=K+Umfo1A9iLa0zisLd6dbuU2bOsnYym9LhvrnrB+l9lT7DWQrKp0hog4yiyDBUSxEXiX
	 qxgnn24VdboOq71Xh8OaVKzAxmHyl4aRtnqqE6uaFtfxMlWJ4IxIc1aRMfR54dmWnYt8g
	 AdpRyMcm3sCBOgLmo7uien8lBwqlzZKq6/KpAh5x4sWO+cXyEIXu1tfwW6YtLpW5ZbdDZ
	 1RmxRBt4si4A6CU71xthHso/xQ6jAR+aJQKiLAhoyru9m4FjHikmYj0ah8BJpVQtfaOS3
	 qyqBCccGGP3xAqZ+Cbi+UELS874dKDrGcOCZz8IJ4bWjDz77rEfAkUlsU+q5o7/sEeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506601;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=evSn4XDavEpcSX9J12r1Jipa10IDL0FvF98b44kN9cM=;
	b=Rh71xze/aiijLP3EcGxWwQsZIsggXGur5L6rkQpdYjltNh0pReYyOklxCF8GGsJXC22o
	 vcTL5XeFjxHmcKhlwe9fRSODU5spY+ps75xyn0DTuOm0UAZpGo+9HGEfehzLOAuWGocd3
	 bekuIYZzjuydTOFimFRqGQECeEouW4fTGx/ffAUn7Xhx8O7iTRmQGEGmGKav//EDkeFV2
	 Z4kC+gHfXiMeJilmYBJUxZu6V1/OJEGHXCz8TroJXZ3j9ud5w/fMmXDx5we9O531kXdpc
	 FbRRDZLagP106i7aM/VDnk0O4E4KK5hUO1WZolVkfLY3lv+vlncEi1zjVpZj13QT3ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XdvaX9K5;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307E3606A327;
	Tue, 24 Nov 2026 07:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 307E3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XdvaX9K5
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO3EEO31292801;
	Tue, 24 Nov 2026 07:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=evSn4XDavEpcSX9J1
	2r1Jipa10IDL0FvF98b44kN9cM=; b=XdvaX9K5X5Eya3fpzV+urofPftxWOcsug
	yN/pxrLsisfpbKj55IhvQMWziJppPvNwnaiW/8lhMXqrQ4/Ndh/f8/FMAODipC8G
	imgrolhA/cN/LPB4xCshDA11BIzA92ojkJ4ZdGWCFIqlEE12tuGxlkudri7fngdZ
	KcxqSipP8yZl1sp9xItmEGUVLonjRVCXe6SNSovbgzpBqU/hdwofcjl+NO2tVBj1
	SijbqpQpSJI1I3FEVbnZcFLKdTBHAVu3B9CpQGr7Xuldl6mVNJO+bmMWCfkSzjZr
	mxiHgOXVrFsPKto6Zsd7uzdct4jHqOvwRGny05NZP/B/Fp4pBwJyA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1696h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nLmV2741023;
	Tue, 24 Nov 2026 07:49:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j3nmqhxuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7ng4t48169318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:49:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85AD2004B;
	Tue, 24 Nov 2026 07:49:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DA7020043;
	Tue, 24 Nov 2026 07:49:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 07:49:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 561771616BE; Tue, 24 Nov 2026 08:49:42 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next v2 2/3] net/smc: remove the clcsock release lock
Date: Tue, 24 Nov 2026 08:49:26 +0100
Message-ID: <20261124074927.3622245-3-mjambigi@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: K2YJvyffzGxys_vaE9g_tjaU4-9kYKVM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfXzLeibsCbPi8B
 15Y107GBGPYmP0niG9S4XbHgtwZW8HexHalxWInJAbfeQhbjY+1gVYQuOeDJpcjlf/x9Omt7SNe
 Z9w3WMfFFzMsSnsKiavicwGPklbyWY0=
X-Proofpoint-GUID: 3y-rz83KPuNPdXXNxSuaH_seuTBwV0Ae
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b05419b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=BEQQ4jbJs6TTUjtYrjYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX2eVnmQY368Eo
 BgCKDlvNzYI30AxoSI/TT2kbh7++D48yyX9LUaQSUn8kjLZ+hdYe7U7ldhy9+CFrXxT9bP3D1UC
 0j0FpbhV4azyKNVPQFsHXudHRgofC7ORcKXt9v/q9DX4YMj/Tzu30HQCmD9QEJ7SOui2yQyD5LQ
 OBmcsBS5H2o0CmHLuNf1SsikHSdqktBZQkj68S6voatUlRnaV3A9LMcPpJge013Hx+4udTwQF1b
 4cEfaDgapg2cCavknceZH9WfUoMP7Nm/mV1l5ZRju1DBp6K8MWPt1/1e0V2oiUEWkZkAhcNMbHf
 lLgY0eaEXxkU16RhRe2PNQ8QpMB87tIQPYpd2UFdhf6Wb018UsivibWsGNMqbthwr8wV2TxotUk
 KZI/aJtEINcwbpH547Zr97PlsQN2lbd4mKWy4qmZyN1ua/xdLXQq+frsCwi+IFY60UX2cC2h7R4
 kmxDxfx0g4znoEpfCsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240030

The clcsock is now freed only when no socket file can reference it, and
that decision is made under the socket lock: smc_accept_dequeue() holds
the same lock across the accept-queue state check and sock_graft(), so a
child that is being accepted cannot lose its clcsock to an asynchronous
close. A socket operation on the file is serialized with smc_release()
by the file reference.

The listen paths that held the lock are covered without it:
smc_clcsock_release() flushes smc_tcp_listen_work() before releasing a
listener's clcsock and waits for smc_listen_work() before releasing a
child's. Remove the lock and the NULL checks and error paths it needed
in getsockopt, setsockopt, getname, ioctl and accept;
smc_switch_to_fallback() can no longer fail and returns void. Detach the
clcsock with xchg() at both release sites, so a second release attempt
is a no-op.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c    | 106 +++++++++++++-------------------------------
 net/smc/smc.h       |   4 --
 net/smc/smc_close.c |  12 ++---
 net/smc/smc_inet.c  |   9 ++--
 4 files changed, 42 insertions(+), 89 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 7415829..7fd79bb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -409,7 +409,6 @@ void smc_sk_init(struct net *net, struct sock *sk, in=
t protocol)
 				      "sk_lock-AF_SMC", &smc_key);
 	spin_lock_init(&smc->accept_q_lock);
 	spin_lock_init(&smc->conn.send_lock);
-	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
 	smc->limit_smc_hs =3D READ_ONCE(net->smc.limit_smc_hs);
 	smc->use_fallback =3D false; /* assume rdma capability first */
@@ -932,16 +931,8 @@ static void smc_fback_replace_callbacks(struct smc_s=
ock *smc)
 	write_unlock_bh(&clcsk->sk_callback_lock);
 }

-static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
+static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code=
)
 {
-	int rc =3D 0;
-
-	mutex_lock(&smc->clcsock_release_lock);
-	if (!smc->clcsock) {
-		rc =3D -EBADF;
-		goto out;
-	}
-
 	smc->use_fallback =3D true;
 	smc->fallback_rsn =3D reason_code;
 	smc_stat_fallback(smc);
@@ -959,24 +950,12 @@ static int smc_switch_to_fallback(struct smc_sock *=
smc, int reason_code)
 		 */
 		smc_fback_replace_callbacks(smc);
 	}
-out:
-	mutex_unlock(&smc->clcsock_release_lock);
-	return rc;
 }

 /* fall back during connect */
 static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 {
-	struct net *net =3D sock_net(&smc->sk);
-	int rc =3D 0;
-
-	rc =3D smc_switch_to_fallback(smc, reason_code);
-	if (rc) { /* fallback fails */
-		this_cpu_inc(net->smc.smc_stats->clnt_hshake_err_cnt);
-		if (smc->sk.sk_state =3D=3D SMC_INIT)
-			sock_put(&smc->sk); /* passive closing */
-		return rc;
-	}
+	smc_switch_to_fallback(smc, reason_code);
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock =3D 0;
 	if (smc->sk.sk_state =3D=3D SMC_INIT)
@@ -1757,10 +1736,10 @@ static int smc_clcsock_accept(struct smc_sock *ls=
mc, struct smc_sock **new_smc)
 	}
 	*new_smc =3D smc_sk(new_sk);

-	mutex_lock(&lsmc->clcsock_release_lock);
-	if (lsmc->clcsock)
-		rc =3D kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
-	mutex_unlock(&lsmc->clcsock_release_lock);
+	/* The listener lock is dropped here. smc_clcsock_release() flushes
+	 * smc_tcp_listen_work() before it releases the clcsock.
+	 */
+	rc =3D kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
 	lock_sock(lsk);
 	if  (rc < 0 && rc !=3D -EAGAIN)
 		lsk->sk_err =3D -rc;
@@ -1830,18 +1809,26 @@ struct sock *smc_accept_dequeue(struct sock *pare=
nt,
 				struct socket *new_sock)
 {
 	struct smc_sock *isk, *n;
+	struct socket *tcp;
 	struct sock *new_sk;

 	list_for_each_entry_safe(isk, n, &smc_sk(parent)->accept_q, accept_q) {
 		new_sk =3D (struct sock *)isk;

 		smc_accept_unlink(new_sk);
+		/* smc_close_active_abort() and smc_close_passive_work()
+		 * decide under the socket lock whether the clcsock may be
+		 * released. Hold it across the state check and the graft so a
+		 * child that becomes file-referenced here cannot lose its
+		 * clcsock to an asynchronous close.
+		 */
+		lock_sock(new_sk);
 		if (new_sk->sk_state =3D=3D SMC_CLOSED) {
 			new_sk->sk_prot->unhash(new_sk);
-			if (isk->clcsock) {
-				sock_release(isk->clcsock);
-				isk->clcsock =3D NULL;
-			}
+			tcp =3D xchg(&isk->clcsock, NULL);
+			release_sock(new_sk);
+			if (tcp)
+				sock_release(tcp);
 			sock_put(new_sk); /* final */
 			continue;
 		}
@@ -1853,6 +1840,7 @@ struct sock *smc_accept_dequeue(struct sock *parent=
,
 				isk->clcsock->file->private_data =3D isk->clcsock;
 			}
 		}
+		release_sock(new_sk);
 		return new_sk;
 	}
 	return NULL;
@@ -1983,12 +1971,12 @@ static void smc_listen_decline(struct smc_sock *n=
ew_smc, int reason_code,
 {
 	/* RDMA setup failed, switch back to TCP */
 	smc_conn_abort(new_smc, local_first);
-	if (reason_code < 0 ||
-	    smc_switch_to_fallback(new_smc, reason_code)) {
+	if (reason_code < 0) {
 		/* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
 	}
+	smc_switch_to_fallback(new_smc, reason_code);
 	if (reason_code && reason_code !=3D SMC_CLC_DECL_PEERDECL) {
 		if (smc_clc_send_decline(new_smc, reason_code, version) < 0) {
 			smc_listen_out_err(new_smc);
@@ -2478,11 +2466,8 @@ static void smc_listen_work(struct work_struct *wo=
rk)

 	/* check if peer is smc capable */
 	if (!tcp_sk(newclcsock->sk)->syn_smc) {
-		rc =3D smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
-		if (rc)
-			smc_listen_out_err(new_smc);
-		else
-			smc_listen_out_connected(new_smc);
+		smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
+		smc_listen_out_connected(new_smc);
 		return;
 	}

@@ -2729,7 +2714,8 @@ int smc_accept(struct socket *sock, struct socket *=
new_sock,

 	lsmc =3D smc_sk(sk);
 	sock_hold(sk); /* sock_put below */
-	lock_sock(sk);
+	/* smc_accept_dequeue() locks the child socket as well. */
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);

 	if (lsmc->sk.sk_state !=3D SMC_LISTEN) {
 		rc =3D -EINVAL;
@@ -2750,7 +2736,7 @@ int smc_accept(struct socket *sock, struct socket *=
new_sock,
 		timeo =3D schedule_timeout(timeo);
 		/* wakeup by sk_data_ready in smc_listen_work() */
 		sched_annotate_sleep();
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		if (signal_pending(current)) {
 			rc =3D sock_intr_errno(timeo);
 			break;
@@ -2791,19 +2777,13 @@ int smc_getname(struct socket *sock, struct socka=
ddr *addr,
 		int peer)
 {
 	struct smc_sock *smc;
-	int rc =3D -EBADF;

 	if (peer && (sock->sk->sk_state !=3D SMC_ACTIVE) &&
 	    (sock->sk->sk_state !=3D SMC_APPCLOSEWAIT1))
 		return -ENOTCONN;

 	smc =3D smc_sk(sock->sk);
-
-	mutex_lock(&smc->clcsock_release_lock);
-	if (smc->clcsock)
-		rc =3D smc->clcsock->ops->getname(smc->clcsock, addr, peer);
-	mutex_unlock(&smc->clcsock_release_lock);
-	return rc;
+	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
 }

 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
@@ -2819,9 +2799,7 @@ int smc_sendmsg(struct socket *sock, struct msghdr =
*msg, size_t len)
 	if (msg->msg_flags & MSG_FASTOPEN) {
 		/* not connected yet, fallback */
 		if (sk->sk_state =3D=3D SMC_INIT && !smc->connect_nonblock) {
-			rc =3D smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
-			if (rc)
-				goto out;
+			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc =3D -EINVAL;
 			goto out;
@@ -3110,11 +3088,6 @@ int smc_setsockopt(struct socket *sock, int level,=
 int optname,
 	/* generic setsockopts reaching us here always apply to the
 	 * CLC socket
 	 */
-	mutex_lock(&smc->clcsock_release_lock);
-	if (!smc->clcsock) {
-		mutex_unlock(&smc->clcsock_release_lock);
-		return -EBADF;
-	}
 	if (unlikely(!smc->clcsock->ops->setsockopt))
 		rc =3D -EOPNOTSUPP;
 	else
@@ -3124,7 +3097,6 @@ int smc_setsockopt(struct socket *sock, int level, =
int optname,
 		sk->sk_err =3D smc->clcsock->sk->sk_err;
 		sk_error_report(sk);
 	}
-	mutex_unlock(&smc->clcsock_release_lock);

 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -3141,7 +3113,7 @@ int smc_setsockopt(struct socket *sock, int level, =
int optname,
 	case TCP_FASTOPEN_NO_COOKIE:
 		/* option not supported by SMC */
 		if (sk->sk_state =3D=3D SMC_INIT && !smc->connect_nonblock) {
-			rc =3D smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc =3D -EINVAL;
 		}
@@ -3186,26 +3158,16 @@ int smc_getsockopt(struct socket *sock, int level=
, int optname,
 		   char __user *optval, int __user *optlen)
 {
 	struct smc_sock *smc;
-	int rc;

 	if (level =3D=3D SOL_SMC)
 		return __smc_getsockopt(sock, level, optname, optval, optlen);

 	smc =3D smc_sk(sock->sk);
-	mutex_lock(&smc->clcsock_release_lock);
-	if (!smc->clcsock) {
-		mutex_unlock(&smc->clcsock_release_lock);
-		return -EBADF;
-	}
 	/* socket options apply to the CLC socket */
-	if (unlikely(!smc->clcsock->ops->getsockopt)) {
-		mutex_unlock(&smc->clcsock_release_lock);
+	if (unlikely(!smc->clcsock->ops->getsockopt))
 		return -EOPNOTSUPP;
-	}
-	rc =3D smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
-					   optval, optlen);
-	mutex_unlock(&smc->clcsock_release_lock);
-	return rc;
+	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
+					     optval, optlen);
 }

 int smc_ioctl(struct socket *sock, unsigned int cmd,
@@ -3220,10 +3182,6 @@ int smc_ioctl(struct socket *sock, unsigned int cm=
d,
 	conn =3D &smc->conn;
 	lock_sock(&smc->sk);
 	if (smc->use_fallback) {
-		if (!smc->clcsock) {
-			release_sock(&smc->sk);
-			return -EBADF;
-		}
 		answ =3D smc->clcsock->ops->ioctl(smc->clcsock, cmd, arg);
 		release_sock(&smc->sk);
 		return answ;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 36b243b..616bb32 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -325,10 +325,6 @@ struct smc_sock {				/* smc sock container */
 						/* non-blocking connect in
 						 * flight
 						 */
-	struct mutex            clcsock_release_lock;
-						/* protects clcsock of a listen
-						 * socket
-						 * */
 };

 #define smc_sk(ptr) container_of_const(ptr, struct smc_sock, sk)
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index cf1add1..e71245d 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -27,13 +27,13 @@ void smc_clcsock_release(struct smc_sock *smc)

 	if (smc->listen_smc && current_work() !=3D &smc->smc_listen_work)
 		cancel_work_sync(&smc->smc_listen_work);
-	mutex_lock(&smc->clcsock_release_lock);
-	if (smc->clcsock) {
-		tcp =3D smc->clcsock;
-		smc->clcsock =3D NULL;
+	/* smc_tcp_listen_work() dereferences smc->clcsock outside the
+	 * socket lock; wait for it before the clcsock goes away.
+	 */
+	flush_work(&smc->tcp_listen_work);
+	tcp =3D xchg(&smc->clcsock, NULL);
+	if (tcp)
 		sock_release(tcp);
-	}
-	mutex_unlock(&smc->clcsock_release_lock);
 }

 /* The clcsock can be released once no socket file can reach it; while a
diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index 520b666..76cde32 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -122,11 +122,10 @@ static int smc_inet_init_sock(struct sock *sk)

 static void smc_inet_destroy_sock(struct sock *sk)
 {
-	/* The sock is hashed and smc_diag dumps dereference smc->clcsock
-	 * without clcsock_release_lock, while sk_common_release() calls
-	 * .destroy before .unhash. Unhash first, as __smc_release() does,
-	 * so no dump can observe the clcsock being released; the second
-	 * unhash is a no-op.
+	/* The sock is hashed and smc_diag dumps dereference smc->clcsock,
+	 * while sk_common_release() calls .destroy before .unhash. Unhash
+	 * first, as __smc_release() does, so no dump can observe the
+	 * clcsock being released; the second unhash is a no-op.
 	 */
 	sk->sk_prot->unhash(sk);
 	smc_clcsock_release(smc_sk(sk));
--=20
2.50.1 (Apple Git-155)


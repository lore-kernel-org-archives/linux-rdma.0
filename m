Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709612;
	b=Gcs0QEZCWFs3dzF4LfcozHZ+CgkXe44nG3phfJkq2mWP8nClVOCis9r9p05xwfqN23ZY
	 yO5cdmwtA4soVJr5p/LDxg7ufUI8aFs6tP7cHGv2dUhhcyIP9XJGU2hBuUkTK4YUWx0Rg
	 F2yzveOQEx9TX+7zeW5qoor+RcBElmmK1h15uz9fHgz5DXOdyzJTG8PAV8vxBegr7B2uv
	 Evc2UFUIjSmwRmqSdko2QPkWv+0PbOFlJWUpl+kkKneRZVZZoitnvsTpWFaCI2A6bJhxu
	 b0Yn3vA2pNnkkuuf+L8BjPc2hCyJPDlvjypwPtUVfrO7NDmRDM0SPodsvBTDWVROfSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709612;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1HoKG7AczmArxj/e203ByyadFBSaF3YoawX7aS0BYGk=;
	b=H17fNRk91IJzNtUK7UFfgTgqrqED+6PFnJ0M7XeDtFKiHbG1IcI2B5aiQcs7lTxSokvC
	 7Esf9jPmIhyhfIvGYDm6K8Em3xbGpQsVcZfb2XRsVEQIisVJ2RWS9Ko7CnNFq6Isy4fjC
	 F8P/ILGHasYOUda7UTUr5m3Cs9VbRtb1YlzUH6J6FekbgXPKV6CzW84P2OenmpN/8jD8N
	 mcIUIHLWGxugdiWZbSKH9e1xaIhYn1ZrMGoOh78vpLiGTcEsyRCVsfhiPsf2meaIXUG76
	 D1VaUZKMIduZDpYHjHIpsEA2uC4rMd48PED6O1KVWLAKJF56fftoOJRojxiuJjGdowA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=sbrUKqeV;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF066606A324;
	Tue,  3 Nov 2026 12:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF066606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=sbrUKqeV
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3AEOF01469930;
	Tue, 3 Nov 2026 12:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=1HoKG7AczmArxj/e203ByyadFBSaF3YoawX7aS0BY
	Gk=; b=sbrUKqeVB2atTPszb7MucPpuH9TTtsGpf5OBGt4wNAZEYzEqPPhmN98iO
	+dFeN2mpaTFD4MSYGmG5lSezDCIS6+rHudY8yJKjoJLrgR1kc2f59TBktvWaab5c
	wDYV19ZgUnE5wBZ02Cr2aNI99JkiAcI801zNXhzV8IdLcJaY7E6rNOS1vr2N9Bd/
	msEkMJzjXSU6WBeb6kD9wTr0suCdLlcz8VUsdvLfYHbzS1lOFPsxtyStNyd7d5fd
	jkNVzuPLHAvxaqOEwCOwnzSvMyhQJvci+TySbPUtxyQdC0YdKL2UXEBp6SJ+VMPA
	io2E6d8arOw3SQ17Khy+68O9zco3g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn7yrwcv3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 12:40:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3CZ1la1329135;
	Tue, 3 Nov 2026 12:40:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnvvft6vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 12:40:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A3CdxHf41419142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Nov 2026 12:40:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D128F2004E;
	Tue,  3 Nov 2026 12:39:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D5F92004B;
	Tue,  3 Nov 2026 12:39:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  3 Nov 2026 12:39:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 85CAD160E2C; Tue, 03 Nov 2026 13:39:59 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net] net/smc: fix handshake abort on a terminating link group
Date: Tue,  3 Nov 2026 13:39:55 +0100
Message-ID: <20261103123955.47454-1-mjambigi@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=Mcr5KJ/f c=1 sm=1 tr=0 ts=6ae9d624 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=C7S82auI6gwtKrQfpSwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA0OCBTYWx0ZWRfXwRkZGzON+f+F
 yxAvFudTiiy2LnuC5ZJ52rEq1pKjAmXTUxXTZQPVxZAhv/OLx52yirl1FMUNRrWfSoSmOZM0aEM
 ZfhcIVxHRhSF86tXcJkvodQocBJk25U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA0OCBTYWx0ZWRfXyQEnY7aQ8nae
 yBfr84w6WgGbQAG/ELXWrYJWPknhuROMJ5htYvCvTCoSck0yXc8Bgl/RhpNXD28NbDpdQqHcwfn
 FW6huISlHytHjroP1B2s5TDMQznbH146KRhgfeTzL/iGyH58luhKywU7eTQZWO2ptYCtiYUikXA
 mjDmJUXr94GA73DpGtXdLeAcbIsSBSShXJeOeG6Rd9k8wOF3VJVNT6mLHKYnerOkZPdVlJDGP3i
 X7pVxzYwy+7WL0WJihBCwJ8u//2IWy+D4w6zJdDKqEL+cCuU1+UgLqyGtS+8KAFbw924VKSjES0
 2AKwvAnjLMKGWWwcFsz8Q+e1T22bz/wJ2LZf8nxezyLQOf7Cuq+EaeeDgpmSIki4N97Aqw2VEzN
 5j8u+XSXjeLy/kqLiWFJ5RJNYgxICGKO9Ajl25CSn01lDoFCuCWdVHxzU6uZRGaK06QlJd9OSPa
 jLwPMvAdUdjdub+BlnQ==
X-Proofpoint-GUID: nLp3KrnXrNY-aSUalKLs4tVFwzLEfNP-
X-Proofpoint-ORIG-GUID: 0gIYNvJw8cmok1dRv7M_PWGuWwwjdThs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030048

The handshake abort path can leave a connection that smc_conn_free()
already freed in lgr->conns_all: when a received first-contact CLC
DECLINE has already scheduled the link group termination and emptied
lgr->list, smc_conn_free() skips the unregister. The handshake thread
then calls smc_lgr_cleanup_early() on a link group that is already being
terminated, and __smc_lgr_terminate() hangs on the socket lock that
thread already holds; if the termination work wins the race instead, it
later kills the freed connection and aborts the clcsock of a socket that
has fallen back to TCP.

Do not terminate a link group that another context has already removed
from the link group list, and drop an already freed connection in
smc_conn_kill() without running the connection and socket teardown.

Fixes: 2a0674fffb6b ("net/smc: improve abnormal termination of link group=
s")
Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early=
()")
Cc: stable@vger.kernel.org
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/smc_core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6021322253e9..df2ab2da2793 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -688,9 +688,15 @@ void smc_lgr_cleanup_early(struct smc_link_group *lg=
r)

 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (list_empty(&lgr->list)) {
+		/* another context already removed the link group from the
+		 * list and will terminate it
+		 */
+		spin_unlock_bh(lgr_lock);
+		return;
+	}
 	/* do not use this link group for new connections */
-	if (!list_empty(&lgr->list))
-		list_del_init(&lgr->list);
+	list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
 	__smc_lgr_terminate(lgr, true);
 }
@@ -1519,6 +1525,17 @@ static void smc_conn_kill(struct smc_connection *c=
onn, bool soft)
 {
 	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);

+	if (conn->freed) {
+		/* connection was already freed, e.g. by an aborted
+		 * handshake, but kept its entry because smc_conn_free() skips
+		 * the unregister for a link group that is no longer on the lgr
+		 * list. Remove the stale entry, but do not kill a socket that
+		 * may be an established fallback connection.
+		 */
+		smc_lgr_unregister_conn(conn);
+		return;
+	}
+
 	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort =3D 1;
 	else

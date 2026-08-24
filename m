Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E793EA949;
	Mon, 24 Aug 2026 06:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787554758; cv=none; b=efb7ebT8Rr0Q0dpGNR4JimrsAILcV7NURu7JicfW/rCOQRFXl8RnWetRHsl440Aqdi0Ap/9h1IlJ/SYk8vEZzFWo96PP9UfU7909TIQoDVyz4AcpZaEqbl4sEcxKPxx6+A8O7ThAbNPwfAkNGuhdJGjr6o4Es3QBOL4lMyYPuAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787554758; c=relaxed/simple;
	bh=SKC/TBZZw15QzPzlqIGkVqIlE3FmmfgbbQcvXZl/5EE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cXaX7pY2Rb2aA3DZ1NKwB6pRbwh4MmJ2zRKdROxkF3qOAsqc/Liy8kD8lXvXUnDnX9k8ff0qjoTnKkbDgVbwKhyAtAB3U0cf1Zi3AvdhW9hY8KRPEiETC8XuZlBXcGxpKsNh/eDcV5kVsT16CJa3FGq+LxoCJKtIRniMFIyrm+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hqoyhM8i; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hqoyhM8i"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O5W88G3284357;
	Mon, 24 Aug 2026 06:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=TbAZgqCl5ZDBtQyYNmVXhC4MW9gkDEJq3vbwwpGd7
	I0=; b=hqoyhM8inGcL2bbm2WWYerNUfEvcJTUBQ3A9o/KC6/WMw0HNKoJaM4yU8
	WfaYKdFlt9a4QjjLcChAU4ooGgW5bKUD+rGUWemqDvdHrYjlSoGDxR1n22CDPZlP
	0dIpJNwGYaxrT+t+Td0He7kJLLHh52XklGxE2u0PmSOqzWsrFPb9B0IT2UGniIdn
	Bt1/K8VOkQqYHjeFakoEHR6H7n7dt3Fu8vQxhnzpSy1vPGPgstvUMRQ+Z4oPuwv3
	03mMChHlIEfp8Tp9OCIGEQftIeBf96iCOtAP+p6rHDxIHgw3eAq2mSK/i4yqa5/Y
	xsRGY7oEuG6LCnx9ng5/+lekAWNZw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73eqfn1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 06:59:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67O6uQ4V007839;
	Mon, 24 Aug 2026 06:59:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfvvk7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 06:59:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67O6x4L629360480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 06:59:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5431220040;
	Mon, 24 Aug 2026 06:59:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FDF22004B;
	Mon, 24 Aug 2026 06:59:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 24 Aug 2026 06:59:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 076F6161222; Mon, 24 Aug 2026 08:59:04 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net] net/smc: serialize clcsock teardown in smc_accept_dequeue
Date: Mon, 24 Aug 2026 08:58:51 +0200
Message-ID: <20260824065851.1070988-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-GUID: Kwd15JpiW7udZ8qcJajes80ZSeylCBO-
X-Proofpoint-ORIG-GUID: rgrTLSAw4ghOd9XSRimTVnNdy5T90aZx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA1NiBTYWx0ZWRfX4x5H/z4nbZwx
 rDYHVzuEkEl9bnhY/X+HSaXPPrEk+/iLfrga+8Vm3aQta7XwiaUXrWpMHcdWcrw6KM28u3ZWAmK
 seSlCdXdPWPFBHPm4qGq6c8/+AFvRMr7s69ckGQKCdjyrjFR/riWdr8JbgzlnEo+yC5bFmZILv9
 oLpUbcC3omxcrF70e9NInBaWqAYqqSR39iwcr/3aLLIKNc0xKsQR++OYGPqwGajch4mTU0m+xqc
 njrp74GlCm119Cc8aXC8aFndIrboH2ACG+Lu+DP/bg4d2R1G5zMS+kyIIZyiI4aqDf5ii7Ogq7/
 S9aMjowTUp8K3DY18pUatFkVHhpLNNK3aLiJb4cLqVGKEovXkleZlprWvJ9XVNRw80vClXRZ9L7
 we9HkfwshgHhp84t+xFLQuZCFtvnLb+fxN2E6/xFlLZ8zpUhjVitv9SBm8gH9itjeXo77hXHN34
 jk8MGIEKtnYMxG2KP8A==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a8bebbe cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=lM2LvyVLlU_OE4QnBS4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA1NiBTYWx0ZWRfX5Xu84L5Jku7I
 isto+gQs+yKa9vej61C6HNhdXO4/Yz10OkecVEgWagIrZnME5JuYyTCoy5WWr4uRXGDmjA5Hjbg
 RsWH7e2NNaXwh8qFbZDSj5B0iLcQ5GM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240056

smc_accept_dequeue() open-codes clcsock teardown for SMC_CLOSED child soc=
kets
without taking clcsock_release_lock:

  new_sk->sk_prot->unhash(new_sk);
  if (isk->clcsock) {
      sock_release(isk->clcsock);
      isk->clcsock =3D NULL;
  }

This bypasses the clcsock_release_lock discipline used elsewhere in SMC c=
lcsock
lifetime handling. In particular, other paths serialize clcsock access an=
d
updates with clcsock_release_lock, but this local teardown path does not.

Fix it by taking clcsock_release_lock around the local teardown and by st=
oring
NULL before sock_release(), matching the established ordering used by oth=
er
clcsock teardown paths.

Fixes: 127f49705823 ("net/smc: release clcsock from tcp_listen_worker")
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00403175b740..bbf8269876ee 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1833,10 +1833,14 @@ struct sock *smc_accept_dequeue(struct sock *pare=
nt,
 		smc_accept_unlink(new_sk);
 		if (new_sk->sk_state =3D=3D SMC_CLOSED) {
 			new_sk->sk_prot->unhash(new_sk);
-			if (isk->clcsock) {
-				sock_release(isk->clcsock);
-				isk->clcsock =3D NULL;
-			}
+			mutex_lock(&isk->clcsock_release_lock);
+			if (isk->clcsock) {
+				struct socket *clcsock =3D isk->clcsock;
+
+				isk->clcsock =3D NULL;
+				sock_release(clcsock);
+			}
+			mutex_unlock(&isk->clcsock_release_lock);
 			sock_put(new_sk); /* final */
 			continue;
 		}
--=20
2.50.1 (Apple Git-155)

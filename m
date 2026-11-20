Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174650;
	b=3xxyY81UaLGlBWy1zQOXNoEc9zWMiZTBRWWS65xh6+Qbhx9Hez3mk7w4Dmou4HJ5UG+V
	 irjqsSgLdkqRUKDneOYerRBZTxxo1+CLcgZ8dLbT5P9UnsL3lLp1UNFKu8O4HLEQH7urU
	 uXL0Irf8iZatz2FP4yDWZTsgCzKE18BBeFVFN+MyGKSfIPP12GoW/sSTpuV9pMtl5lTQA
	 qE8NaiIo29kKVgw1Iieo7ahIKF3QB09h55oXUdqG+2KwtEO7icchghYWN9/+fdkAaV95K
	 /lefmT8dmArhtwBDcnMhhxQT5NaVvzOtpZoHLRzokYb4RUgtH6v0Zsq2GHz3Zc7laPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174650;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bNDGK4UI7JVDed+fyjj3bo9xPV3mWmMM9QpU4oudZxc=;
	b=tKvUg+AzPlQLH3WkPK1fLwJldVr1bS4A2uUWvcJvTHMdeXtThAm/yCYBCjE8iWoiWojq
	 Nxq/KwR+wKnIh125GkzCygRudXQwf9uS//T9VWw/3D3jh2MXVagkwvBGmB3YZk4zPje5E
	 WJIErsXyycd6WfvEWfHiB4lRTnMpYvzcFOV+tOnsN5CUIxi9dnQxTYEbL8sCNdqhEAqON
	 rbRFHQ5n0fR6KpSH2cjL8Z1Yum2T5kndjHZs0VcuGtjB5QOsJw7xauUNdSPI89u22Xu2z
	 aVs+Hf3J5NJMbT8Eny2I0ZO5fMKpoWMxVN3xHFb2Dd78zoiFsmNxdFhEsiB8Km+L7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="P/bTawFy";
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADB5606A325;
	Fri, 20 Nov 2026 11:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EADB5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=P/bTawFy
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAu3F01243432;
	Fri, 20 Nov 2026 11:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bNDGK4UI7JVDed+fyjj3bo9xPV3mWmMM9QpU4oudZ
	xc=; b=P/bTawFyKmTrxJb9km1l+ZwZzpezT132SBswVnHDsPZD9Ar5pAyjhaioL
	5tVE4omRNpgpgOzEC33IaeyxSkey/vQzvSe7SY+GRttclX4OfguUfAblDV/1+uvG
	c2SqRDuULuR7JntMPS3Rzqa6CQwUK0f8ddCvLj/KOKOnH6MYtleWB6WnhXCvGNec
	aPzTymsI1UjWe1t+1rXEl2/97WbgxwtUU4nVHz5Z3LtMyVlR4/Hb0M98owCmeGyj
	dM/viX+cowVmkoxLm0KO6dqVKwEXnIEkf8RUzGD4t92P+oO20hqhZRRzdiP5aton
	XHByEpjPaw3mhg8C9rlqE2ezbNNZw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105s023h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 11:37:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAo06g1107116;
	Fri, 20 Nov 2026 11:37:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1bb5kunb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 11:37:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKBbA2K50594184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 11:37:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15AB22004B;
	Fri, 20 Nov 2026 11:37:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA53820040;
	Fri, 20 Nov 2026 11:37:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 20 Nov 2026 11:37:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id C6087161068; Fri, 20 Nov 2026 12:37:09 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next] net/smc: validate smc_diag_req length before reading diag_ext
Date: Fri, 20 Nov 2026 12:37:08 +0100
Message-ID: <20261120113708.3950966-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-GUID: 71PAhncLYfGjMu00Rerr-YyoUyRjLMKt
X-Authority-Analysis: v=2.4 cv=e8uT2qp/ c=1 sm=1 tr=0 ts=6b0030eb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=vWuhhF-FjSUm6uSirrwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfX1wCr0Mdwn2ZV
 QAajzY4C5Ua/Vj/DO0RcinyOI3kByuAPNaREVHLCCYPFRGEl4v0ptGtHZsxONyCLIZmHfzZO0xc
 5urg6FMo9NvE45TRu8Aeium4c3zMn1I=
X-Proofpoint-ORIG-GUID: ddHUqvYonBTXZ1aHdKK7-C_ZPon1CD4y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfX7BahzPQY2UM1
 DUPL1RvsWD1i7vqybhmM4z24F4OauwHGWh8iR7VJGQUfISFmZrVTtSZLc/GlidiCfyXcY2kVvdf
 n4WY8m0GmPOay4/Rp51SPFW2IyQ/wJ3/2viud9QWeiDgLOIhZA7UlEamp9QCPrdBcYvZ+vsDnj5
 QW3Z4u0iuVMctdhKLInNkeslMFw9VUsERPmLfZugU0jpvHjY6NaXjzzmwhCaF3pdMKhHquCMeIw
 H0/z4kDLWNVvAS0SqtRHOiDPD0W2UAfS3BR1qYVHsTTAHsliK2oWoInqJLgndZsc6piT31Af2WS
 oONLi0aKipK2CYUt4i9mL/A/QLow7cqo8DIatX6ncl/iaEU/CPIvFDFRFenovYdp5koKhSjbREj
 wap//JHmcSTJfPA73d3K0cOht36mrPHSmMtlrRT2c5FehUBXCei1DcDXfHXGlC4KOk7NMfuhAz9
 pmSp+nTmqWziogY60QA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200045

__sock_diag_cmd() only validates nlmsg_len against sizeof(struct
sock_diag_req) (2 bytes). smc_diag_handler_dump() schedules a dump
without a further check, so the dump path reads diag_ext at offset 3 of
struct smc_diag_req from uninitialised skb tailroom. Add the missing
nlmsg_len guard, matching every other sock_diag handler.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/smc_diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 15485a08d9a0..ed578279dcd0 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -245,6 +245,9 @@ static int smc_diag_handler_dump(struct sk_buff *skb,=
 struct nlmsghdr *h)
 {
 	struct net *net =3D sock_net(skb->sk);

+	if (nlmsg_len(h) < sizeof(struct smc_diag_req))
+		return -EINVAL;
+
 	if (h->nlmsg_type =3D=3D SOCK_DIAG_BY_FAMILY &&
 	    h->nlmsg_flags & NLM_F_DUMP) {
 		{
--=20
2.50.1 (Apple Git-155)


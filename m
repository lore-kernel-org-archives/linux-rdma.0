Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E3C3C65F4;
	Thu, 20 Aug 2026 08:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216156; cv=none; b=Sq42zYRRo7TIfCvkI61nfPJJb36emZ8UD19vc6Tz73JjB2pu9FJwZoWaK3PgrZo5MxxdLTH9K+CG3iTM55mIyv5+//o/SbRUXkYY/xcODU8DV10MqAYk/W0nvLQRTEv1ZPILIMx/dN6LfJLzEquf10MC3zMLaNmU0w4G9bSAJGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216156; c=relaxed/simple;
	bh=uKt/bVvGmAKMs6Wbljk4+MxB01QAMk8FNkSh1Das0TY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJruK7ioKYWrgTnnO7Jchikoj+8IHxmcFpTugmX28oOjQGSph4DvKMIxC/ejraIALfkekXupzOBoZylxL9kL9f3jQiiHdECuNh31U9QDdUD0mKsJ1wQY/17VANH4funxrhXL6OaABKjAqNeQ2sCO0+/j/Rqc49Yao1nJaQ4gsmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YSC1KO9I; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YSC1KO9I"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLVaFX471315;
	Thu, 20 Aug 2026 08:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vzWQGoY7InyN21TSCZBoV83Axxos3SX6gfQ3/aJAA
	uY=; b=YSC1KO9IoqGmnffdXfUYNtAtceiGcDCuDH/jdqeCHQDcF8GqQqQBDsseK
	IV230p3HMbJhKbFxCkQy2bnhhJUKFyhfF3n4ORNSy+rHxzkHOm2foarluZ+Cm1+/
	cWxOJ4KRUdmWyNDc4r8lmiA5XmIpBMwI8NG14UH/sJZ3cTKsMAJX5U7FKy/0dAtY
	ncag4z6M5LU3sfEHE9UWrPYD8lENGVb4QMQyc0MCoCFrsZHUZZnV4av8TS3vmIsD
	eqr+9JkDittlyaw7lsIgFTSkp4SEgLUkRYEwqk8qcIKR+c5P46OvBdmBv7+6cXvu
	nKruPXI5JvNwC773kH7yu1Ezt93RQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu0h71a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 08:55:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67K8fJMH000841;
	Thu, 20 Aug 2026 08:55:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ngnbtv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 08:55:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67K8th8740305020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 08:55:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5A4F2004E;
	Thu, 20 Aug 2026 08:55:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6550020043;
	Thu, 20 Aug 2026 08:55:43 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Aug 2026 08:55:43 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, hidayath@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net] net/smc: do not credit bytes that splice() did not take
Date: Thu, 20 Aug 2026 10:55:43 +0200
Message-ID: <20260820085543.967490-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=MthiLWae c=1 sm=1 tr=0 ts=6a86c115 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=w8sWwliLtTwIomcRwIIA:9
X-Proofpoint-ORIG-GUID: i8SKujpPmIGt-VCB3A54qA5qlKr0zCrg
X-Proofpoint-GUID: dMSkA1Z1RV2yjpMxcIZKFkkl7u2i7vDn
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA2MSBTYWx0ZWRfX1kuN7jggQWG/
 8knfnb7///suIb28UQlUbp2rrGxHJ2XihtfN9tcaWF3fLawj/1Ui5IkBveRGB3QcjKCsGZiOOzj
 oEZGtihbB48CWQ1adD29tuKFZnejOZs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA2MSBTYWx0ZWRfXy020InQfLeO0
 Z5Sgq2WZyI522PpHS1n11Pq6uttG6E7OTbds546lWmFgeWeWAx1VBXjvZy57xj+b3kaBebVspoZ
 knwUCx6hQP291egx66k79GXwy2L7H2j131UHrGuzNnfMbeUCpiMzIB14ZD6qnsFg1naK9AOnxnZ
 wTrR4g8vv6rvpg1NQ4xfHB955jCRN4VZwwoUPokjDTNLke8/qnfiLgJeiMfUvf9J0vOCAbuMh3X
 ERyWtMhZaruX12Oz6ckE1Ttss4W23EHVpafxIRCZYy2YTiG4eVnD7FmxV/pzWsKLJEjX1o3m0qY
 RrFsAIH8xs7NiA6fqF1xlV1C75brNPLRxPP8PZH1Ixv0NOfwrOwyfWmOc5EBJbJL9TjhsyRRwuB
 5BiKTS/wj/msVR+qHTV0abBhrkhS5rl7elE9TU5K8m+skoM7jCxcOaj3mxkGXPhsb9mr3JJpNDa
 9v1Etv/zGYh8emUW87Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200061

smc_rx_recvmsg() offers a chunk of the RMB to splice_to_pipe() and then
credits the whole chunk regardless of what was taken.

splice_to_pipe() takes only what the pipe has room for. A short count and
a zero count are both non-negative, so both fall through as success: the
call returns more than it delivered, and the consumer cursor and
bytes_to_rcv are advanced by copylen rather than by what the reader
received. The skipped bytes are never handed to anyone.

A pipe that is not empty is enough to hit this; SPLICE_F_NONBLOCK on a
full pipe produces the zero case.

Account what splice_to_pipe() actually took, and stop there rather than
continuing to the second chunk of a wrapped read. When it took nothing,
return -EAGAIN instead of reporting a length that was not delivered.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
 net/smc/smc_rx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 5c9e4d8b57de..d951dbe8eec3 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -488,6 +488,24 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 						read_done = -EFAULT;
 					goto out;
 				}
+				/* splice_to_pipe() takes only what the pipe
+				 * has room for, which may be less than was
+				 * offered, or nothing. Account what it took
+				 * and stop: crediting the whole chunk would
+				 * advance the consumer past data the reader
+				 * never received.
+				 */
+				if (!msg && rc < chunk_len) {
+					if (!rc) {
+						if (!read_done)
+							read_done = -EAGAIN;
+						goto out;
+					}
+					copylen = chunk_len_sum - chunk_len + rc;
+					read_remaining -= rc;
+					read_done += rc;
+					break;
+				}
 			}
 			read_remaining -= chunk_len;
 			read_done += chunk_len;

base-commit: d3083202a78cd0040be6a88953f728b0d3db1990
-- 
2.52.0


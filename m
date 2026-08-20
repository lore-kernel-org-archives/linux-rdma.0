Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7892208D0;
	Thu, 20 Aug 2026 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212017; cv=none; b=hxtxSnpQ7PA+Bx3b9Qi5hBOhxMAI7grcInyZNqNA+i/4FUc8IBaWHYZHlAPvhmKz+T6eoAIxdxXczkJnw9ff4FKrPIJiLrcTa2kM9j7ZvjcoH5qEshkB6Tb78rcckQtl2Cbtle5nyYP9m3o4ry8KjlD7bA0PpCEdIPj1dv296O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212017; c=relaxed/simple;
	bh=u37AhnI8X+hGFEe9P2C62O6bDAReT4K8SuHu0Spnlyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C9r1GIRNGuCIsZfoiSL/WX0bRDG8abE5Emk98AGU/tOXQeo1aLLL4c+fvx8VyTjX6hb5/ipZgsA5UmZsFe2Adi13dNjXUh0RcLQhQUNWkRho7xPQMCJURJ0PCPs/2AyYYhrPfmPWQv6DJoOpDgs47kQcnk6r8jgLQ5EoeVgWKxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OFCoDsjb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OFCoDsjb"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLVjCt471864;
	Thu, 20 Aug 2026 07:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=PK+WFQhwMUtCMaftof1kyol7hRx70JFZDuO+LPmXV
	T8=; b=OFCoDsjbXCyuEpWhJNxjE+l/uPrmVUBGe5lUYUe6pcxBltq1qmdiTQxdJ
	NPtonjZ3K0Obxir1t6ou1xpC4bE+aWHDBlnj3IDX5zeZ4R/ydytTOBRcuqHlX2kD
	cXvRjr+rVGT2KjlDaRskGLSLPyg9xIb2Nju5KTwnX5NaOLGhurDvvDEPavKDonlv
	eWiRhEzb4KXs7KCxtZ37uz/9twyYLhEl6TWZfjtXfHca2/LcOtuLupGT8DhZ7xPc
	W+spHcYV8Ito179JoWaf1Zu648WNsmPk/9dE3/tMW9Jvvm9dmEQ3oeZJJVtdHvej
	yCKiSXHSiNaWglf2pMVbF4dxHcfbA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu0guhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67K7fKPX005167;
	Thu, 20 Aug 2026 07:46:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32twdbp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67K7khgk13828366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 07:46:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4289120040;
	Thu, 20 Aug 2026 07:46:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DEE32004D;
	Thu, 20 Aug 2026 07:46:43 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Aug 2026 07:46:43 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, hidayath@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net v2 0/2] net/smc: fix use-after-free in smc_rx_pipe_buf_release()
Date: Thu, 20 Aug 2026 09:46:40 +0200
Message-ID: <20260820074642.966856-1-hidayath@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MthiLWae c=1 sm=1 tr=0 ts=6a86b0e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=64RyPHVN2Ejl6unEET8A:9
X-Proofpoint-ORIG-GUID: g8t_QR1qI84c4kMOMydn4USVw36XOY2n
X-Proofpoint-GUID: sBc4Tu9rnp9_mrI60RJxK9yG8GD206DN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfX+HPrW+s3wbqQ
 vKpOQV1kB/kqt+WFSQuLkaO1tqMrGbAoVOqfX9faSBIlVhXHfZJkZBbPAaF0Q9BxeA77l0Fj6YC
 BH2IAJfJNICoSaEzD2rSU++ceMgIuAk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfX4TWSpOuBIOsy
 iYczbYvswUGK3MwMea+Yb0NoTSgnaAPhL/ONxebMMOE67e/bdkL9jre778lUfzReSjqGlIC20tY
 xqaU0zLXQZDnlQA4VbSxiuvVU+gg8whJarHJJDmVB9CqSi2qljKTHcAHDUEJC1WMKo5x05IsXby
 mNOJA+o82T4JME2NsK5/y6npwRaBlTmtfMec/GnF4GOqCyujS6TYqOJ1yTNzDD1vubSR3t4s0TU
 Q4uRQEhha0tjjVxJNJkRyiP3EQCBEcbKQ5yAFWvyHVqEf792/lSSeUzAYJKsfeTuuXjoLCJU+ad
 LzmXpTnfsMTt3b2+sSGkIQDXiQTpgusO+r05x0q/xO6KwJSjzKHraPaT3ukQDsztdPAucUaIY87
 3iK1smF46Mlm+YbtPQU7srFYxGG6ZFeMTuhkeR0nURpP0uiZAC6PXbLmkHcm8T74IQc2r5IA1zy
 /4CNJd/u3iMLF3iQrCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200053

smc_rx_pipe_buf_release() tests sk_state before taking the socket lock
and then dereferences conn->rmb_desc and conn->lgr. A concurrent close
runs smc_conn_free() in between, which releases those structures. On the
is_reg_err path smcr_buf_unuse() frees the descriptor outright, so this
is a use-after-free.

Patch 2/2 fixes this by taking the socket lock first and testing
conn->freed instead. smc_conn_free() sets that flag before releasing
anything, under the same lock, so the two paths exclude each other.

Patch 1/2 is a prerequisite. conn->freed shares a byte with killed and
out_of_sync as single-bit bitfields. out_of_sync is written from the
receive tasklet without the socket lock, so a concurrent store to freed
from process context can be lost in the read-modify-write. Patch 1/2
gives each flag its own byte so stores do not interfere.

Hidayath Khan (2):
  net/smc: stop killed, freed and out_of_sync sharing a byte
  net/smc: fix use-after-free in smc_rx_pipe_buf_release()

 net/smc/smc.h    |  6 +++---
 net/smc/smc_rx.c | 11 +++++------
 2 files changed, 8 insertions(+), 9 deletions(-)

---
v2:
- Patch 1/2 is new. It is a prerequisite for 2/2.
- Patch 2/2 replaces the conn->rmb_desc = NULL approach from v1 with a
  conn->freed check. The NULL store exposed smc_cdc_msg_recv_action()
  and the sock_diag dump to NULL dereferences on paths that do not take
  the socket lock.

-- 
2.52.0


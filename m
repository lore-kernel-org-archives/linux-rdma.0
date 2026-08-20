Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE98388E61;
	Thu, 20 Aug 2026 07:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212017; cv=none; b=SgRoN11JiHn+AY2Ce2GeXH3HVRzfrCcAxo0xUmHgPZgxSxPNiB2gIeEV+KuGI+WZzuV+L7AZzYJuyu5rHWbL8jNtQTBFvsWjotpvQstlfxbZrhCxJJA49MVdyYqYU8TzZLvvbB3e62oA5lTpzh6yIxs4ALgKK3z7jiVb0ZdkZXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212017; c=relaxed/simple;
	bh=ZDs8qeOzQQQP63I+x2vxVjc5XEeEGjTpOeZbCbXWzAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByFCFg10GHdtBOQiX1kNvDQhAN1I3L6vVJ3+vmXgBvSXbGuxTcqe61E8HhMWhZuXUGhcCa9zXnzB2GyU09mmWTXg8JNCgcoqpIn6Qen+sW6Q5+bmAA9QXXOk6yeHWHyHdW5eUcRwovvHO8Ct0WgIk+Ce/wD4WtrZ1h1Qf6Uj7Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JuCF3fJi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JuCF3fJi"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLW4Df424851;
	Thu, 20 Aug 2026 07:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BN1K/n6JpoBV1479W
	VRv4ajiQogMB2MfE959YKhtyqo=; b=JuCF3fJihcrvQdGlfyHdp9BKTq8T4oPWN
	+cUC2KmNJE6C/6Ga965Ssplg7oiJ6miYG8GfPAT/AG9W1/O35ieASpcGbgZUGpEz
	g8Vw94H8RNFt+NdidBOeWNe/fihaspVI8fgPIADXOPlA6K/Zu7P4DdE2KZNzrEAy
	sqOu3gX6LKOTdked3k5vTGNGhuipLN0uZ+pYfl1ygEhh/8xrR5W+4C6/jqztRK0z
	7LwtN8BNTmOIJw8LP+xVNFTHTR+Tuw9rbMC7NL3ilKrMgNQmIZMcSn4LtfTVYx6I
	vdY8EvdHgTuwDrdMWJew/WF1X1R7WLKLr2qRqjrFsgrxSY8trpCzw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1gs8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67K7fHfS026485;
	Thu, 20 Aug 2026 07:46:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32eqddvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67K7khhs28770918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 07:46:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79F8120040;
	Thu, 20 Aug 2026 07:46:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46A8C2004B;
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
Subject: [PATCH net v2 1/2] net/smc: stop killed, freed and out_of_sync sharing a byte
Date: Thu, 20 Aug 2026 09:46:41 +0200
Message-ID: <20260820074642.966856-2-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260820074642.966856-1-hidayath@linux.ibm.com>
References: <20260820074642.966856-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a86b0e8 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=GTcdQ6rE3tqjsuqwFHkA:9
X-Proofpoint-GUID: quY30RAjYBlCH_ZsBMwCZ4dAvys-Rg0k
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfX4J/F8q2kXSQJ
 OIEUa671A30GHlWG2ucXxqqXWm6Drrbg5mZSvH0XT6GNv6XdXJKfHdtGCKJ3D4u3D9EV5XjqjFs
 0bH0AGPxlGvHX1uCDX/noG59sCGdRCA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfX7pHneQ6YxfCb
 VS0YcyD7OanFh4udk26F2oL25s95kcSk5sR5DGSR3zI0e8VjFmA8oR/maHpRo9q2GAjOcERQgYX
 w+QUrUaDSQ1PtpGPvUe3v4Ei6A5YmzZ7kxPVDFsp7LCxwsMoMLgAdFu2KG9sVGOYitmMldso4Xu
 yiMh6U9yEhMxGs0J12yJhgpAfTAhqFWdJ8AZ7XwOfRk4+UUSWTpJYUP3KE8166La3mjc4DEZiKi
 1qKIaKsmXANxFLAWgaUbgm4E/onblND6CY9gVEdEH7R3wA7kk4Yo4sZnJBG71o5WktQqK33oupO
 bgxHRylntBm1CymXHu3+DdlC+0tJ8/DfWf4HWoFTQ+tKrdjQrY3LDfx2BBaCRJmsDHnH3Fxejt2
 dBPJDJXBts+usOqkuPZZQJOVm3lYJDze6DjfPc1fUKdfPIIj7/ReZRW1u60eYPi2rcW0wyStvhI
 ouQT4Bl5IBD4W19hBEQ==
X-Proofpoint-ORIG-GUID: 5Tka3A-1cbhhcx2D3DsjtfBgDFC0MwpV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200053

The three connection state flags are single-bit bitfields, so they occupy
one byte of struct smc_connection and every store to one is a
read-modify-write of the other two:

    u8  killed : 1;
    u8  freed : 1;
    u8  out_of_sync : 1;

They are not written under a common lock. smc_cdc_msg_validate() sets
out_of_sync from the receive tasklet, while smc_conn_kill() sets killed
from process context under lock_sock(), and the receive path does not defer
to the backlog when the socket is owned -- smc_cdc_msg_recv() takes only
bh_lock_sock().

Give each flag its own byte so a store no longer touches its neighbours.
All readers test them as booleans and are unchanged. struct smc_connection
grows by two bytes.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
New in v2.

 net/smc/smc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 52145df83f6e..427b6d63b993 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -277,9 +277,9 @@ struct smc_connection {
 						 * 0 for SMC-R, 32 for SMC-D
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
-	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termination */
-	u8			out_of_sync : 1; /* out of sync with peer */
+	u8			killed;		/* abnormal termination */
+	u8			freed;		/* normal termination */
+	u8			out_of_sync;	/* out of sync with peer */
 };
 
 struct smc_sock {				/* smc sock container */
-- 
2.52.0


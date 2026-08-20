Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF913B19C2;
	Thu, 20 Aug 2026 07:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212018; cv=none; b=prAzPpaZUXTxW7DWwmeCC1u4K2rBjqw2/fbstvjHGhS2fgWfLuKMHKfO2BcPt31Ok0Cb/A/1ntijIXOXxMPOm1o1htDnAvu5u8KjvEe8+WIn4G8hm1biGkPVtTwREfV+a1m9mj6PoS9hVkR0QVHY4Vdw42qLSXA3slQMacPhGHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212018; c=relaxed/simple;
	bh=tUEtLWrgm5czhfJOBvdd6mAP43FiO5n0Chg925WlD4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJR8nB+1H0Pr4cuoyq/lJZU3c6vAhxrJ/T7bwEfZRJ8qoGoDjNqOuvmZvYNvDEeU0msRVOHT9RjpIhDMfPLE9MUJZeAjn6fZ9DCdkbaJrKOkn5Ju8ctvLl1J2eYTvVln30HqLi8LfZ9t9Jgzw4hpF7SOFqxRD7gf9n4lbF21bNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jhI8A1W+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jhI8A1W+"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLVprK2795124;
	Thu, 20 Aug 2026 07:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wFBL3yHr1RJlTGz4c
	ga9dYCwiuApnerM2ADAcePpgBo=; b=jhI8A1W+KeR63d8xTnj6A2S5zgrghQofP
	gyONWsgLJ/E25+r8RZn0008zg6S6UwLjsd+5sX7KPEaS6XS+BjLDVNSnkvaJuzxn
	dmBnuxrwxYsltrhbfqUA/6EJ+C32atjpyBYBtQNA+3sPtuUOnYBBfEgfhSQ9x+9s
	vy17vjqKnMm7rsPbJcg+UEmUrpEPE9xMOhtm2IlJ6z7uwN+HlZojzRP9fxJNASFX
	tvX8NrMr1JvnU4aRPHp/jk1spwuwFdyVOlvsiU3bQ1PQcv1EUC1oX4CtlWH1Rqr0
	T19TLZV5EPvF/TjwTie70kj0Khl3Iw/uAHI9RA0IyIjbxnUP0ScfQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu08t5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67K7fJOh005153;
	Thu, 20 Aug 2026 07:46:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32twdbpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 07:46:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67K7khLH16974180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 07:46:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B029E20040;
	Thu, 20 Aug 2026 07:46:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DA5D2004D;
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
Subject: [PATCH net v2 2/2] net/smc: fix use-after-free in smc_rx_pipe_buf_release()
Date: Thu, 20 Aug 2026 09:46:42 +0200
Message-ID: <20260820074642.966856-3-hidayath@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: HBnp-sr74NynY0YxFt1E8Ku6zgnfQisP
X-Proofpoint-GUID: yeavFs_bpZNIZAkfGdFTJC_qxB6g1KOm
X-Authority-Analysis: v=2.4 cv=RoX16imK c=1 sm=1 tr=0 ts=6a86b0e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=olxAUb-_ScPgihUlld0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfX+AW6E4jpsYr9
 wHm/vckRM+WDetY0ZjEiqOirsoAVoceOBf4iJ7v5JFPChZ/ibM/u0M1i9HLcl913FXN9vFDz7vH
 4Z+XUUxsROmFa9hN4xfkX0lWbb/UDWM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA1MyBTYWx0ZWRfXw9rJ3adGTABg
 95umqd2snIIu8cio0dcm9Gshp5JHYhxTlAOIuTKsOOI2ZgZVENupzoxQs9X0aXs4T8aGnBdjS5w
 RQQfzeGXhSeoqR2l+W0OBtD9t/7FJj5ZnZEa+diW/wrvs0fTInrbqxk3ZbzKSLdZHOlWRreNYrH
 BpznzNHUHpYSSHWQWX3/SiWmZ5Hd7UFN0Bw+oes1BOQB+yxhKdntLZCrqRtjKl1xHMvQqrcKX35
 5vXBKvpybIIKq0Z1B/4QF4X5N226EOOkVPPghM4Jl+O36l8OGlqXu5dZ6iV7rbDu+ryTXyli5qK
 hT746WW1XXkUh7jHragVX/DG5HLspJGPA9oA0jg8DDm4nvoLA7ZZPYuHEwihJpSomXSsm7GIRvl
 ChJjn56xQ3+Zi/cl07QlLqKoJyPXFVgFKXmhX9md5ise4a07/oc8sgnEisIq1IkjNPRM1HLzLQF
 l7wv1ltcmxjpqB7hUbQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200053

smc_rx_splice() hands RMB pages to a pipe and takes a socket reference
per entry so the smc_sock stays alive until the reader finishes. The
connection does not: a concurrent close runs smc_conn_free(), which
releases the receive buffer back to the link group pool.

smc_rx_pipe_buf_release() tests sk_state before taking the socket lock.
The state can change between the test and the lock, and
smc_rx_update_cons() then dereferences conn->rmb_desc and walks
conn->lgr, which smc_conn_free() has already released. On the
is_reg_err path smcr_buf_unuse() frees the descriptor outright, so
this is a use-after-free.

Take the socket lock first and test conn->freed instead.
smc_conn_free() sets that flag before releasing anything, and every
caller holds the socket lock. The two paths exclude each other: either
the pipe release runs first with everything valid, or it sees the flag
and skips the update.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
v2: Replace conn->rmb_desc = NULL with a conn->freed check under the
    socket lock. The NULL store exposed two paths without a NULL check:
    smc_cdc_msg_recv_action() in softirq and the sock_diag dump without
    the socket lock.

 net/smc/smc_rx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 5c9e4d8b57de..197fddc6271f 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -115,16 +115,15 @@ static void smc_rx_pipe_buf_release(struct pipe_inode_info *pipe,
 				    struct pipe_buffer *buf)
 {
 	struct smc_spd_priv *priv = (struct smc_spd_priv *)buf->private;
+	struct smc_connection *conn = &priv->smc->conn;
 	struct smc_sock *smc = priv->smc;
-	struct smc_connection *conn;
 	struct sock *sk = &smc->sk;
 
-	if (sk->sk_state == SMC_CLOSED ||
-	    sk->sk_state == SMC_PEERFINCLOSEWAIT ||
-	    sk->sk_state == SMC_APPFINCLOSEWAIT)
-		goto out;
-	conn = &smc->conn;
 	lock_sock(sk);
+	if (conn->freed) {
+		release_sock(sk);
+		goto out;
+	}
 	smc_rx_update_cons(smc, priv->len);
 	release_sock(sk);
 	if (atomic_sub_and_test(priv->len, &conn->splice_pending))
-- 
2.52.0


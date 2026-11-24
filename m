Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506591;
	b=GkaoOx8naMHlQxX0vuR91+B+EqnMJ3DzeaVp35rwXhh/45fJl3i2+YyIkDQeWs7/Nk2X
	 mHE/7LapRfMjza6fhRphkap5UUvYhZ820fbmkschNpBmWHc2ElT0jpdD+oCwGAd8KNiyM
	 FkOwiwm6WPO3Rks2swjl4xxrVr2D9HTuGl8nYbyD/SS9qvcOgx3EB+zPteqWAT2hKv5iu
	 ADTjqGijAqOPDdo/I3b4bIeiW2RckYBHPoyMvtm97BAPWROD1PVfG8Ifm2fTe868hmtrg
	 gEk8fpvDu35waehDE14xdObrVN1ia2xBRYEDt8SBOmknXXHw3a8qXQPKKggZqn6y1/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506591;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=vFe9+xvHMJKBNQaIgGpMM8NokfA92ua0f4m4mQbWGmo=;
	b=sm+mC7ystHcD/BrVPyTHZUJoEXRZ362+IArFCDP3Nrc3rj0HoqygQWIvaxocK+jr2nGo
	 Srr5GAfps0g9Iq/Zcszfyc8vUtUwPsMyHlO3/6uDzdoauxjvp2ACNYyQNl6Xkl8hVMirP
	 yWPsJadSxK4cbIn7FjvO9M2a98lnJFDoBoKpK+y8c50We4p8DubIGkqq7WpbUB/fPjWN9
	 xPu1vwI8Hph+Ba/Jmwv5xPKVjgya+JvF2ceBR056Oi+W01vIM5aJxTuk+tA1NK8Iw0ChL
	 mcZtW19hFkqIqw4DHw3v5gozux1OAFmxV8c15dePKU0NG0A8uGGVCkuszhbcOvUonYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DV8HRORm;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E10606A31E;
	Tue, 24 Nov 2026 07:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88E10606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DV8HRORm
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO35ABN1271944;
	Tue, 24 Nov 2026 07:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vFe9+xvHMJKBNQaIgGpMM8NokfA92ua0f4m4mQbWG
	mo=; b=DV8HRORm6xSuVOJ03ebYv3z/LZrpZFX2bhOysHERSKPLvqXavJK4N9FP5
	W5xliBYmFC+WOx8AG9dX2k39vmLbxdL6o2LU002a56f8folkF1dS3qks6iBeACX9
	9XhcfLGAYqonlrXZVzDyfkqag+bDnP7iStDm3U4yFBSX74abnbifVVT6TTF/5DN+
	rG4DNQUNHTO9i669pMUrjHsan2TkoINhUeBa5Avsd2+R5UabmiQSAsn+T6EYLdSN
	hVXRYDUux8/ExZhSs0j3nC+51TcCRKNyPFcdjsJB6+q/5hNDw3kOUqygM5JlG1i8
	zhHTUT0tU2Aobg7oKoo1E8Q0BYSNA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g16966-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nPIR2741045;
	Tue, 24 Nov 2026 07:49:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j3nmqhxuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7nYF728311994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:49:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69DB620043;
	Tue, 24 Nov 2026 07:49:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A1BA20040;
	Tue, 24 Nov 2026 07:49:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 07:49:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 12D901616BE; Tue, 24 Nov 2026 08:49:34 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next v2 0/3] net/smc: fix clcsock lifetime vs asynchronous paths
Date: Tue, 24 Nov 2026 08:49:24 +0100
Message-ID: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: K59Fqsie0400o7ITTeGkzM7bzWlg5qHy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX+vbROWhBao3R
 JqPpIuTQo+plpSYnvn0H8FgGAld3H9SeM9j/beS3A7tW5t9c7+QGgLOmFOpjMBP+Ku5wcoYF2Y+
 5XBH0rlpV9KZj1+NT79Zm0883gN33Vw=
X-Proofpoint-GUID: 39XXvwgPrFUytP02PBzLyRN3nscuc4AD
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b054194 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=e0kRlRqOptjlawYriWYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX/0hzE8k4OrOD
 YOk1EKzZU6kjiUigPtdMoYVbg5nMQD4YmXDuPP2acX+0I/AB8C0kOXEpfWvgRnVuncOAPU40rmx
 lOTsNiyE8o0i6JeELSUbmnloC0LeQ+dHn18mRFzI3AjElvXH7C3TYrzrORgjPLTUBSu2oXOL4eu
 uT2HJDsudOwMi0eWuxi26MBU7xa25ycDmUjRttou9WSM26rwmdfyRKYShlAqHsWrWfTfLy6y6od
 CxTslo0Wp3iPhTEXoqHuxSJAeNc2mYrnpYNTL1NQ1hKYXYg3F7luRJrGXOum0J71n9eeVmSSFSF
 xkUtbzvDKr01JzdbH1YGgAntWuh2y/JO6/Csjt3sd2KvkT2/fdFc/nkuHCJ/4C0EK6Zy1vkQ0YC
 nD6gtA/muZWd0Qg/zsUL9g9poCmRb9qOBgmuzsRcM4ErTECt6FGj20ENZ6A2MBGxZlwukk8eYAf
 O1R7pzOg8JjcvSlGLNw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240030

The internal TCP socket (clcsock) of an SMC socket is freed by
asynchronous paths: link group termination reaches
smc_close_active_abort() and peer close reaches
smc_close_passive_work(), and both can run while the SMC socket is still
referenced by an open file descriptor. A task that uses the fd at that
moment, for example getsockopt() or a socket diag dump, then operates on
a released socket.

Free the clcsock only when no socket file can reference it: from the
socket release paths, after the socket has been unhashed, and from the
abnormal close paths once the socket has no file left. The decision is
made under the socket lock, and the accept path holds the same lock
across the accept-queue state check and sock_graft(), so a connection
that is being accepted cannot lose its clcsock to an asynchronous close.
The clcsock_release_lock is no longer needed: a socket operation on a
file is serialized with smc_release() by the file reference, and the
listen work is covered by flush_work() and cancel_work_sync() in
smc_clcsock_release().

Trade-off: with an open file, a clcsock now stays allocated after an
abnormal close until the application closes the SMC fd. The SMC
connection is already torn down and its TCP connection has been reset or
shut down; only the local TCP socket remains allocated until then.

Patch 1 makes the lifetime change and is self-contained. Patch 2 removes
the lock and the checks it made necessary, and serializes the accept
path with the asynchronous close. Patch 3 documents the invariant and
adds a destructor warning for it. The diag dump keeps its NULL check: a
socket is hashed in smc_sk_init(), before its clcsock is created.

This is hardening found by code walk, not a fix for a reported
regression, so the series targets net-next and carries no Fixes: tag.

---
Changes in v2:
- Rebased onto net-next (eb6d6c80d354) instead of the torvalds tree
  (7e1392a42ea2). The patch content is unchanged; the only differences
  are unrelated net-next context: patch 2 now shows the READ_ONCE()
  around limit_smc_hs, and hunk labels were re-derived.
- Patch 1: clarify the commit message to say the issue was found by code
  inspection rather than from a reported regression, and to describe the
  conn->freed rationale more precisely.
- No functional change to the series.

Mahanta Jambigi (3):
  net/smc: keep clcsock until socket release
  net/smc: remove the clcsock release lock
  net/smc: document the clcsock lifetime

 net/smc/af_smc.c    | 123 +++++++++++++++++---------------------------
 net/smc/smc.h       |   8 ++-
 net/smc/smc_close.c |  35 +++++++++----
 net/smc/smc_diag.c  |   3 ++
 net/smc/smc_inet.c  |   9 ++--
 5 files changed, 82 insertions(+), 96 deletions(-)


base-commit: eb6d6c80d35449c27471b1874f13066c09a8964d
--=20
2.50.1 (Apple Git-155)

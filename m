Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178761;
	b=3f+zdW2Cv037Ekk4zzb3Bwg/qxb9iJIw5cmip2EbeHBUzpTblxlaVerULXCZV+Ojy2Nd
	 PZ+xmA3U5xwHO9xCGYhi/FHSYKx5kADKMzb7/F6H7Xv0BA3OI777ZqZE1NbK608w2xO1I
	 bMlrteUBqLGAv/JsITj040nn/Cv5dXsjmXq3r4HR5C1OHvYK5qKTH6aPz+B7p1q5lnCNV
	 DPU4NyYRi5Xz4/0vIPKX0UzbLdCDoPDmfg0qUsU5pBIWLvfwwLDQ/x7vWuXxq18UET6Uc
	 81RuZDKrz3XikRhfI0HwnOJ752zfkiPlPn39ZodNH+Qb1/1M4N23x7AdS1f0/S3s4fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178761;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=A2lctlwYtriSyDX+8a84R0H8qTM0RWQIPGwcyCVle44=;
	b=DPZ/aAkUtxFBfWjqS2mGi+Zx++Lj/7+qgedbKIGuYIVPnNEvrdbhu39qmzGA6hI2gBeb
	 yguPKmvmgI1wfGLIhlxFfIZSGPDwU8noqNxrMCZCyuXGXW8j9NDuqQ1Ve69e1gE2v2Uh+
	 hA2VQYAojMQ6qvs9uhIP2/AyMmhRdQ/lcFMOf3w0z/FbHIMiiURt7ZukbpAuIfZefuI3m
	 hFu0qU7JMv8zeqDYObl9gdazsQrGIivyxY4RE0eJ+T2ut2sqExC98sHI5F/qPIDBnghLI
	 sgVrCFR64bJpbXx2HzgxdnQgjiQSEUYDxP6QhVSrH/SwIwD00xVtOxRCkeTYLihnK9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tY7PS0GB;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D74606A33A;
	Fri, 20 Nov 2026 12:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47D74606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tY7PS0GB
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAu3Mn1243432;
	Fri, 20 Nov 2026 12:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=A2lctlwYtriSyDX+8a84R0H8qTM0RWQIPGwcyCVle
	44=; b=tY7PS0GBnH3GsZI3wxTsdaWVYxVn9u+b+nj7EwcHQXvRrJGtJWAVr4EWW
	qybRDbyW+ljRDUWEco8JsIq5lQY8DrJgu3Raz0ouNCEBclij6eDa4J5FvIGFvs7f
	kaHO7Xzs687axR7B6/Cf0HUcNcTJbbNBV+ZZflq4bkMdmdgHiLCV5a8aPjzi/bsJ
	S16zAsXlM4z/ABTu9zFEz05M2cMJwn2o9pPfXSQ1W0BbgRBoDZVk54AIRsALKqhj
	nmYN9vivWspFjiuwf2OLc5xOb8VTptwlkHfyDQ1Wi7yjcZyH7d1PV/2Ovz8VQLZ5
	35PCWtCPu3HVbUl7nyJgW8/hhmK5A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105s0dky-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAo6EY4130935;
	Fri, 20 Nov 2026 12:45:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1v9xg2k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKCjd5r51904828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 12:45:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B3262004B;
	Fri, 20 Nov 2026 12:45:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E37520043;
	Fri, 20 Nov 2026 12:45:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 20 Nov 2026 12:45:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id EAC02160DEF; Fri, 20 Nov 2026 13:45:38 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next 0/3] net/smc: fix clcsock lifetime vs asynchronous paths
Date: Fri, 20 Nov 2026 13:45:31 +0100
Message-ID: <20261120124534.430200-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-GUID: mVajBoqCZhyOBC6PnndldJlMHu3zg39k
X-Authority-Analysis: v=2.4 cv=e8uT2qp/ c=1 sm=1 tr=0 ts=6b0040f8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=e0kRlRqOptjlawYriWYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX23UL19bdfffL
 DGM1z4haIrBM0XDxvcmEpI3q/pb0+4YtKRwm6YYH0PcHAy0T5sCKjDaPUfD2wkszyQGJ18akxT2
 dehgC80hO6dyrbJhEG0fbdtjdNwWFcU=
X-Proofpoint-ORIG-GUID: qZgiATnaRMkBQYwKYJw5La-BgKnNtvNj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX1YIM50WSNLkn
 XYNp8wy5fe0poHBh/DfyJ4nvXn9UZqt717gPrGoEdGenBTE+/Jfxc2yLYevsULUHlFro8dwS9MT
 GC9vdD+tuw6AgIFgUFkcJpSGQYkzs9bjic+F6Bh0s03wUpVWfc3U0tkuCRQm6F401vj1p/Fe/tJ
 OVFpD5zaooPY9uE+eumwuBZIAe4pXVF/+h/l3N/81II+zbSAA3FPP+UCyDXkUe4Iv1wVNVSPKqb
 7CO2j6wMcUPFiUQP4Jcb6LfuOMioLFVvAjowdxIYD3EaY+qP6rxM4nX9ki6RlRe2sgyyVJWgyCs
 nnXcsZAraDDzWYqcwNqWPHtMMor7xWwwIpLQptcjrRQUMkpNvARWVEvB++K4Vjnmxo/D1uzmqKk
 RWefYbsVUwCRz4oUda6VC3ONOwNLKctvlidzviT6jKr5mphHYzhTVNYbU0o9d1l7+zm0o8qOQIq
 nqRgxmruo0MTRLpZk1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200049

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

Mahanta Jambigi (3):
  net/smc: keep clcsock until socket release
  net/smc: remove the clcsock release lock
  net/smc: document the clcsock lifetime

 net/smc/af_smc.c    | 123 +++++++++++++++---------------------------
 net/smc/smc.h       |   8 ++-
 net/smc/smc_close.c |  35 +++++++++----
 net/smc/smc_diag.c  |   3 ++
 net/smc/smc_inet.c  |   9 ++--
 5 files changed, 82 insertions(+), 96 deletions(-)

--=20
2.50.1 (Apple Git-155)

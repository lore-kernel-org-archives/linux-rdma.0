Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415953;
	b=rUdukB9JkQio/YvgXbsbvWyj23cCQoSk3cPN8DjNPJpamX3P2BDtWOaXVg277vHKrBvy
	 wo7oTLlxazzmodfe43xuUzZs7q4dSRXALD0gRYVQJBk+TlB2tBZDjkevMFOj9VSi5BJ+i
	 P3MAPvrScPPDpjt52XWcQE5NL2WoN78hf+5+JOlFhhjqpp344SWDjtjTOMn1UmYADABFu
	 hXseYEtYr4C94FZBVX+fsAO/hTik4/P0kXQrsTGRfwlwBzQsOsJQkZSqw4Q7KGY6NUeSU
	 8MsiOGLOF5+QzTk4iG4EkvIPe21e1D/pN9qHvSRPtIQYtzmYCpPJ4EsSFNERl4o1mpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415953;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=3p6j4BummQ7DEDYd3L0u+o/FJMfAWrrauAFxppvlCxs=;
	b=Xi5n35hoSjTjnVhQRg2OJNmF/LR0gQbm5y+Wr11cSp6QeFfvNP6vJiaKZrXQMrgBza1f
	 FioZ+s0TmDKPAUzSLid2pxL4f2c9R4G3bRDrvMbdfLELES3bAFSfSOuoPKqCkwahZZE/M
	 BrjnAUYg/E5c14xV70r6BVatvqWeQ8kFrY+to9gqb60Yr9XbC/tVouLpuFwDiF3wUVUOb
	 DbIqyscrvdy1gyBx614Oe2Xl6mQXgCaxSDBj0c/PNcmn6Hv83e7zukcT8nDhFlwbHfm8X
	 q1zKxdBPlsGcQejielDQxIezWuwwCg6TA9OtgwLNyhQfEbx6dzLiahnmje95BcHElPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gcmlENnq;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA59606A31A;
	Mon, 23 Nov 2026 06:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EA59606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gcmlENnq
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN556vg2634170;
	Mon, 23 Nov 2026 06:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3p6j4B
	ummQ7DEDYd3L0u+o/FJMfAWrrauAFxppvlCxs=; b=gcmlENnqM6MZy2/TO8vaqY
	N5QSGCaIlBbQmO2dCASYvAex4SoCazeK6mwsEZbkd+jswWXNN2sg2zL/zk+4tH+o
	6dXu2/8wrzMNelwT8n2uAhSeLuv/t6ZnGCx7vkwoc6oFIVJMRVhQ94hJYRSjBkCi
	MMi7PJpwIA+ndg+oHgGU27DPd6GYcpkLgPKyCQCQ73WTM/6WQXb0175PLMAoiipC
	yCZvxz74vDIdwRAg+ghnQc90wYickdQPTldmejkKujzv0tNmDVrqR5i3jabgF6iq
	CdQ6+zNw3EXOn3nvtnQDqfXmOlufyrx3tgExgt7+ucBqaAr/dkscmWhpA98HYjdg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g11jv6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 06:38:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN54SlE1346513;
	Mon, 23 Nov 2026 06:38:48 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j3nmqdtn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 06:38:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AN6ciW645285684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Nov 2026 06:38:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66E1A2004B;
	Mon, 23 Nov 2026 06:38:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEC9120043;
	Mon, 23 Nov 2026 06:38:41 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Nov 2026 06:38:41 +0000 (GMT)
Message-ID: <90fb64eb-8fd6-47de-8773-263701b2179c@linux.ibm.com>
Date: Mon, 23 Nov 2026 12:08:40 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/3] net/smc: fix clcsock lifetime vs
 asynchronous paths
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261120124534.430200-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: _rBVRy8o8DAmjMQF4L8z2M8ImwNSrJd-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDAyNiBTYWx0ZWRfX8wuVjDiQOY8G
 lW16sRYHwau+s+eOe2hfyHs385klPRws95jsc0V2oxy2pnLIsPxWIibanyPgQPI0ZSI6EMYoZTP
 gNe/z5E7vwrsKNERlWUXXyFc3Cd2CMA=
X-Proofpoint-GUID: ZYuclnfSGq8afemKTGN9w3r1haX4RmPb
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b03df79 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=Upmd74fEsTyMv7FUjCUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDAyNiBTYWx0ZWRfXz4h4F3OKm9pD
 VJxL83zO54K7KDyBL3wYjMdZaf7fM8UEYwjLLG9sAHEaXYhK+GSbme7LtlkriE3iwo4VY6OcA9J
 NRWPQXJs1HJwLSvLY8ZwrLBW9LO1QsJFxqMMVp7ohM/dzH6CmJz6Y+WEAIFxAscH06Q3Q7jdym9
 oml5dyjSnvIh0os2ZyEwdVdpBk8s1BHZMESQB2K3B5D0NeRDUQUCQaTerol3jCvvE2MWW6uGeQ7
 BWIIGdwSDBTTA4e/I7fjEj79jCe/x5IIq55RdyvihMu/+oRRvQJoX7fwJbREnpQtqSxtLfuN00e
 aMdGRdoqXzQJYfVxotsCCRe48SvASIFf4Z2sOiX5q0tZXcv61T8oG9axwLcG4it/BLaQQlg5qjj
 3AruepxN/5D++dQdxYSwkTHE2fCs1dkReIsGd9aKSyePVNx6OdT+Vtvf3VN+5hkERA0feE6Xtfu
 n9p29lopn0DGdQoRKpQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_01,2026-11-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230026



On 20/11/26 6:15 pm, Mahanta Jambigi wrote:
> The internal TCP socket (clcsock) of an SMC socket is freed by
> asynchronous paths: link group termination reaches
> smc_close_active_abort() and peer close reaches
> smc_close_passive_work(), and both can run while the SMC socket is still
> referenced by an open file descriptor. A task that uses the fd at that
> moment, for example getsockopt() or a socket diag dump, then operates on
> a released socket.
> 
> Free the clcsock only when no socket file can reference it: from the
> socket release paths, after the socket has been unhashed, and from the
> abnormal close paths once the socket has no file left. The decision is
> made under the socket lock, and the accept path holds the same lock
> across the accept-queue state check and sock_graft(), so a connection
> that is being accepted cannot lose its clcsock to an asynchronous close.
> The clcsock_release_lock is no longer needed: a socket operation on a
> file is serialized with smc_release() by the file reference, and the
> listen work is covered by flush_work() and cancel_work_sync() in
> smc_clcsock_release().
> 
> Trade-off: with an open file, a clcsock now stays allocated after an
> abnormal close until the application closes the SMC fd. The SMC
> connection is already torn down and its TCP connection has been reset or
> shut down; only the local TCP socket remains allocated until then.
> 
> Patch 1 makes the lifetime change and is self-contained. Patch 2 removes
> the lock and the checks it made necessary, and serializes the accept
> path with the asynchronous close. Patch 3 documents the invariant and
> adds a destructor warning for it. The diag dump keeps its NULL check: a
> socket is hashed in smc_sk_init(), before its clcsock is created.
> 
> This is hardening found by code walk, not a fix for a reported
> regression, so the series targets net-next and carries no Fixes: tag.
> 
> Mahanta Jambigi (3):
>   net/smc: keep clcsock until socket release
>   net/smc: remove the clcsock release lock
>   net/smc: document the clcsock lifetime
> 
>  net/smc/af_smc.c    | 123 +++++++++++++++---------------------------
>  net/smc/smc.h       |   8 ++-
>  net/smc/smc_close.c |  35 +++++++++----
>  net/smc/smc_diag.c  |   3 ++
>  net/smc/smc_inet.c  |   9 ++--
>  5 files changed, 82 insertions(+), 96 deletions(-)
> 

This series does not apply on net-next here.
The cover letter carries no base-commit: b4 am reports "Base: not
specified", so it is not possible to tell which tree the series was
generated against. Please repost with the base recorded, so that b4 am
and reviewers apply against the exact commit,for example:
  git format-patch --base=origin/net-next -o outgoing/

which adds base-commit: <sha> to the cover letter. Naming the base SHA
in the cover text is enough.

Thanks,
Sidraya

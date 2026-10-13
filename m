Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279C23E33D;
	Tue, 13 Oct 2026 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915186; cv=none; b=H1Clxm+b2pLK5Bc9g9BK+bmc9aEshgm2AEmz6N12zlM8ytm50S2Vs5gDs2oX4XVqbdQX7aflayRHv05T/qUlEFBriP40x1yy1hxhPViA06rKn01hFlwRrG+Hz3uFWgjJGYLeAWHevcUcDYMMdQxGuKRMSfCS7+/ECIirD9Br4KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915186; c=relaxed/simple;
	bh=NP2uEWY33oLWyrCIUabsjyvryyGbSatYCLEI5X1zaGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OCD22qJiPgjXMkWLX2uhpssFUQhfXaIfOkLna0QxWAdN3NwABUpiXDKgNUoDuq618G2fkFcamG8yDz8e5xtmx6c8c8Enje/Rqc5b2AJBHoTIdRGa7aeODjYcUjq8mJGjtaORy5fUp4vD9KexxCbvvxpbpL98Km2oTWxFiDECu/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fPqw5Hzr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fPqw5Hzr"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69DE24gD1775095;
	Tue, 13 Oct 2026 18:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=miYnpo
	80qlkbiHUnF9/PxK0NC5uxRfKy1IE22BcWU0o=; b=fPqw5HzryssOr33ROMQErx
	HbgO64o9tniLUrc8J6FF6SpE7/B6WfVQC+PSS7SkfwPDs1O7ftJWpHdnRz1e3BDc
	bJmnXl9xlheNPpzSA4/loL2PmeC6XOzyU4AXAOV/0PtvWfJXarVcdFB392lyDAyx
	5jB1gd0F+mD1y42uiQQcXpQv/Dc2/LaprAAkOx38HcER7WUhUrIjszz7UvE5Md3G
	G7/QZd5fHfCS9OjJ7QDNWzPa5tAl9mtIWnDZV7iZqdXzOVCyB21Xx0pKlgxwbtYT
	2LUOf88SCuG5qb2dJnFv0hq993kZ7cV+oAysxueZucBxms9UBUzT+I0C1NJ2YDyg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhynkw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 18:12:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69DFYxpI2667561;
	Tue, 13 Oct 2026 18:12:18 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h802vumbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 18:12:18 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69DICGln24183394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 18:12:17 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7A175805A;
	Tue, 13 Oct 2026 18:12:16 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B7925805C;
	Tue, 13 Oct 2026 18:12:10 +0000 (GMT)
Received: from [9.39.28.43] (unknown [9.39.28.43])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 13 Oct 2026 18:12:10 +0000 (GMT)
Message-ID: <2b0bba52-3a7a-4def-89e3-223ab2dcaf9b@linux.ibm.com>
Date: Tue, 13 Oct 2026 23:42:08 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v10] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
 <179190120255.2527009.1699844827628717041@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179190120255.2527009.1699844827628717041@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA3MCBTYWx0ZWRfX9lAhL03EBGan
 nv0qi1YnJB2kv3VdoDD3Mgju6Sfv1GZKEQe4YRSEwF/rNNGupojh52FdVc/Fk8bHFsfEDQNywhF
 Q5pLpTVCug1RYX6gYffsYETGGF0jrpukC1xyAVFe4j65IwI1DBp5Mi2ssxKnWIyTmgCO9fRcQxz
 QPvT3m4YeCGo36/eT5C0wEgjApNgx4vbFaem85iexNNhYNKiibwKVa6e4lob7sd/QvsybSbMTCk
 0Y4AqDl+QiRevBgabgyGGh0cWwoixxyj90HuWp06UjlQXm9MBaJft1g8ZoN7ndSSxy3dgNvPiSh
 F2fmC5WuduxKMBOCVv9BNyW9OI3n7X2iT3tKCfWwEcFnH81+zHqBGl8r4HSRw6Am2yHziLTG4Bs
 5GXfKBvay0Q9pU1D4wO/Ir+Nza1ta4WZ/kMo1mCu4IpBpTlb3/EXCmGrjPBgzvUkoZJKeqh+7K5
 qzX+8bw2Uq0CjJyjU2Q==
X-Proofpoint-GUID: 4oHyMwCOGILTFXwkOMnFuXX8X4lVIxqb
X-Proofpoint-ORIG-GUID: 7w1L4tiieBePXkWrUdr6MH5KTiEfD5KR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA3MCBTYWx0ZWRfX1rKqZKIdxVjn
 YilsYgMPtqxPIeW56ZIQi4HTdSFBoZoiRs97eN9C6cHsz//49R2EyhjxnLRLpj7uHnT1CtA2Mv9
 DLcB1Y1KkDUI9Y8tcR6y19VbFMt27c4=
X-Authority-Analysis: v=2.4 cv=btHZl0ai c=1 sm=1 tr=0 ts=6ace7483 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130070



On 13/10/26 7:50 pm, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

The issue was found by manual code inspection while reviewing the diag
dump path in net/smc/smc_diag.c.

> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

The races are theoretical — none of the three windows were triggered in
practice. The smc_conn_kill() / smcd_buf_detach() race requires an
active smcss poll to coincide with an SMC-D lgr termination on the
dmb_nocopy path; the smc_close_active_abort() and
smc_close_passive_work() races require a concurrent diag dump during the
narrow teardown window between sk_state = SMC_CLOSED and
smc_conn_free(). No stack trace or error message is available since the
bugs were not hit in a running system.


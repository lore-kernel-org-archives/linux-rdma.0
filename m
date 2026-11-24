Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506991;
	b=uhijM7rpmrDsp/MK2ozMfBl71STYyoFC7Im7rNB19xMKEQuFL0hbCoMVhYxNKLEiIqJQ
	 2Y9kAAEJPhqyer5T+H4d8vZ7o4b1zKWT5VrGYjdc+jBgHzMIjkk/PayxaXIxsHn8Jfh8r
	 V7S4r1je3BUylAqJbNoh77hveu/sGZ0NPp9BN4colmwJSTJ9Evi4G78yJKftQLNMdsTmx
	 wXI9I/4mrBLp6cYmVGjOXGdg0fd2GmD9edElVR8j+Tfbt5MrkjMCSMbI3G1tj5SOsqb3C
	 T4+pP2G5nAvuZuXPJbpde0qECXpBFv3pyUDhzTAiuX8jEdkeMxosn5r2P4wu3hpbh9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506991;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9EmRdhCjBr/QenqY18Qmil+hpyMqdIb8seb29UTAa20=;
	b=TJhJj3gKdm9b0UawtnY6woEySidCeFL1ie+HoLpmur6rihUHUYZmkGnm7WNR3dyn1ekY
	 dyHL5cSIzLOPUEScZGCZVvWn+3iN5yubF8T0nduRUox5xqEyHviyAdfVGYHzuMMUnoTfB
	 wKepxKdQDr8rGOJ9niAzRnA1aeMupEcwRPNf7QFQcbfdmV+VZDUmpOxpDTgOtBuWd5nz5
	 HtDlZ0X4srSDA4fjTNtXkPZSiUHEFSOYnO590hd8gN9Nyn0BcFgODpFCGv+DZlPvXTpPo
	 MD31QYsJm4B3RqcRult8nUDVagGsUN3kQVnCeKL7umYyK7cJvclF/w+TmLmUuc2KOeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Z4US9SZs;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A2606A321;
	Tue, 24 Nov 2026 07:56:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 559A2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Z4US9SZs
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO35SSE003612;
	Tue, 24 Nov 2026 07:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9EmRdh
	CjBr/QenqY18Qmil+hpyMqdIb8seb29UTAa20=; b=Z4US9SZsc/KR88as+6noda
	+l/WwrWE7Pg1jtKvr3nw517TwzirKWKkF/K7Auy0LaHiTbbYvq0y5cAp8Jx4W2/6
	aUz/iHkNx4P++/GW2TJZl2jSClF/XivNawb+BGg+CkYtHCcGNQxwN1DZIrj0ZU8e
	WoDYWWBXTTXKceNk88t6IlKrviQqoZwTXKA7J8IOyOD/Ywm9yejQIjT3KcR2zzGF
	C8XZnq0q2iEBRAdcbDUqb2bvt71FJ+EU9DZeXVEkHw+Po3wq0yOWWVRB34iaBIWq
	/tZnUfYtCjln1NJ0ETVmu5KkZFMvXY2FTNC0jCr50mXkthmyiw/Tsmm8ohryDnDg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4e5cf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:56:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nLl2021923;
	Tue, 24 Nov 2026 07:56:13 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3pmk1seb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:56:13 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7uChW32834094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:56:12 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5ED2A58043;
	Tue, 24 Nov 2026 07:56:12 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 240C658059;
	Tue, 24 Nov 2026 07:56:07 +0000 (GMT)
Received: from [9.123.5.224] (unknown [9.123.5.224])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Nov 2026 07:56:06 +0000 (GMT)
Message-ID: <8e5fe7d5-ee5e-42e6-b194-6e75abf402ad@linux.ibm.com>
Date: Tue, 24 Nov 2026 13:26:05 +0530
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
To: Sidraya Jayagond <sidraya@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
 <90fb64eb-8fd6-47de-8773-263701b2179c@linux.ibm.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <90fb64eb-8fd6-47de-8773-263701b2179c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfXzTfcHnj++Gcq
 1aFQlmOIPPwqpVX4tO/Ki7N5iUIhITAZF3cQNfp1HAi07ob1NrKKHHcqInxkAqes3emAsOVC0nd
 ffOj4xYiJAoGrc+ZFI9LR0SRmUwrle0=
X-Proofpoint-GUID: IBFr-Od1tzhLYVyxPLKPD3UFyE-YByfm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX3dVkL/kPdqPw
 8WMvrvoULre6xnRPMTqPiM8OoZqUj8QAmCj3WJzzpCP2L+KyJ/6KxzgP2El39lAeRjgF30vsntA
 CR2oqk24ViZrBzakOhMRdeerT02AzZJkcIZ9MbUOlGIvscUSCWR9ckSdzNS/H8TDXF7Lk3hk7S1
 DHRMjyz81L6B2Xj85BSxrrskuyige9GfARqggrTHcIsnr4z5ZHocX2VvfeWT3YM3pcMrIa1wk4A
 hUYZ+rmjSJgfA0P3KUH80hAOdsGPNRU4T+LmZ2TlwRzxtSC3ABby+d+C4zxgWayMe5QQyBOYyeU
 3urxPZNE0UGpT8mxyHh2IPRQcLqQg37n8icA9dKm0Zh/K/WkV/qQjnHsML1uqC3ZsOEd9LfQPhG
 cw0QalcoPrI4TRmABwcu0CEVO8ddikysih+RqinM5Ifii7yzvG/LHwcngf5qkwSeRsENoBln/SN
 33Bko3j0dIY1ToCjQGw==
X-Proofpoint-ORIG-GUID: q03cOY5mIeTj6kniCyEFyGIktXhp8M_8
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b05431e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=5eUvoMCQNJi1rTH1nyMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240030



On 23/11/26 12:08 pm, Sidraya Jayagond wrote:
> 
> 
> On 20/11/26 6:15 pm, Mahanta Jambigi wrote:
>> The internal TCP socket (clcsock) of an SMC socket is freed by
>> asynchronous paths: link group termination reaches
>> smc_close_active_abort() and peer close reaches
>> smc_close_passive_work(), and both can run while the SMC socket is still
>> referenced by an open file descriptor. A task that uses the fd at that
>> moment, for example getsockopt() or a socket diag dump, then operates on
>> a released socket.
>>
>> Free the clcsock only when no socket file can reference it: from the
>> socket release paths, after the socket has been unhashed, and from the
>> abnormal close paths once the socket has no file left. The decision is
>> made under the socket lock, and the accept path holds the same lock
>> across the accept-queue state check and sock_graft(), so a connection
>> that is being accepted cannot lose its clcsock to an asynchronous close.
>> The clcsock_release_lock is no longer needed: a socket operation on a
>> file is serialized with smc_release() by the file reference, and the
>> listen work is covered by flush_work() and cancel_work_sync() in
>> smc_clcsock_release().
>>
>> Trade-off: with an open file, a clcsock now stays allocated after an
>> abnormal close until the application closes the SMC fd. The SMC
>> connection is already torn down and its TCP connection has been reset or
>> shut down; only the local TCP socket remains allocated until then.
>>
>> Patch 1 makes the lifetime change and is self-contained. Patch 2 removes
>> the lock and the checks it made necessary, and serializes the accept
>> path with the asynchronous close. Patch 3 documents the invariant and
>> adds a destructor warning for it. The diag dump keeps its NULL check: a
>> socket is hashed in smc_sk_init(), before its clcsock is created.
>>
>> This is hardening found by code walk, not a fix for a reported
>> regression, so the series targets net-next and carries no Fixes: tag.
>>
>> Mahanta Jambigi (3):
>>   net/smc: keep clcsock until socket release
>>   net/smc: remove the clcsock release lock
>>   net/smc: document the clcsock lifetime
>>
>>  net/smc/af_smc.c    | 123 +++++++++++++++---------------------------
>>  net/smc/smc.h       |   8 ++-
>>  net/smc/smc_close.c |  35 +++++++++----
>>  net/smc/smc_diag.c  |   3 ++
>>  net/smc/smc_inet.c  |   9 ++--
>>  5 files changed, 82 insertions(+), 96 deletions(-)
>>
> 
> This series does not apply on net-next here.
> The cover letter carries no base-commit: b4 am reports "Base: not
> specified", so it is not possible to tell which tree the series was
> generated against. Please repost with the base recorded, so that b4 am
> and reviewers apply against the exact commit,for example:
>   git format-patch --base=origin/net-next -o outgoing/
> 
> which adds base-commit: <sha> to the cover letter. Naming the base SHA
> in the cover text is enough.
Thanks for the report. The series is based on net-next
eb6d6c80d354 ("net/sched: em_text: pad the text pattern in the ematch
dump"). I rebased it onto that commit and reposted it as v2; the cover
letter records the base:

  base-commit: eb6d6c80d35449c27471b1874f13066c09a8964d

Link:
https://lore.kernel.org/netdev/20261124074927.3622245-1-mjambigi@linux.ibm.com/

Could you please take another look?

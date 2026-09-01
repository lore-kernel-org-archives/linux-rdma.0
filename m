Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F212A4119E7;
	Tue,  1 Sep 2026 15:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275611; cv=none; b=GRe7BPg6g1o2tnS8iAWlN+aIU06t2CgvWHNM5xVr/SMIh2mMUMGOqCwP9b3WxT6ZfyQlT/XPCS6NgfcsXZ3fJfw2Yvwh5GUGo3WxrkT+Xlkcpa+iI2HgJ1w/KRnmoBkEK5Qry4+Nd2T0CcMsFFakYGKYLTbYSMMewdIUAI/kuk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275611; c=relaxed/simple;
	bh=4fqqNsTF19SDREzyDVFkE4z5ayELphcyw2jVqQpA1v4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYOQWgFSto3IUd39aMOR7Nv3QAN+fclqO2s0Z/bPwsB6SVaIqDbaUE3M6ZC5NnxeppQjMkABdiZIZjfIWqhXcJHrCGAkMWnJSxdW7H7hUUX1Z9E2kgHoZ61FKyPFdmDcLdliIHKITfmVaJwLAhfQMzAlcGRYlATqOSWasfTTuQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qt4r7N0G; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qt4r7N0G"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681EVhQi1454986;
	Tue, 1 Sep 2026 15:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7A4PXe
	niivxIX6u8yjHyw5VQdPmNLTH4M3liTTP/Xpg=; b=qt4r7N0GJp6QXnOmZQTraQ
	L41BqG1C8c8H0wFN3ag5E2JTMz9e8dBsOvIkdxAQ/BTpx37DEjdMuPRhwqA1tEP0
	RZUqKZ8ZxnXW3xxE2xbOhg7GNpcGKws2yavV/ivSCUVc7QXeVLoFHy23Rj9D2+ju
	pIKvxlcS4Q1eqKl8cg0rzURCqKzp3ye+EKPfRcFwYLDmKaJ4bSOR80vIwfzN0uCC
	kHU+a9KNhF8RvmYEWPNf1bCJ00vSrSaqIgjJjyZC2XX0fH04yBXhyhfaDhL4m9jO
	YTgJxr2h/9c4f6tQigmcNd3TdEnjmSpcN9sjhufTsvtCvyRHu4nf3jclKD8JYjQw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq54rngf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 15:13:21 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 681FBKcZ010050;
	Tue, 1 Sep 2026 15:13:20 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcark4cbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 15:13:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 681FDJO18586174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 15:13:19 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A367658053;
	Tue,  1 Sep 2026 15:13:19 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B26558043;
	Tue,  1 Sep 2026 15:13:13 +0000 (GMT)
Received: from [9.124.220.22] (unknown [9.124.220.22])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Sep 2026 15:13:13 +0000 (GMT)
Message-ID: <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
Date: Tue, 1 Sep 2026 20:43:11 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
 <apbMyLc0IhLMKwwA@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <apbMyLc0IhLMKwwA@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDEzMyBTYWx0ZWRfX40VaqdzE30Um
 K59IzYvi076heC6x4JGBxJ27uvs+1aEJlicMGT1l6NCi2uvfqPSKJQZrvwzN7PgdpLkDvhWmfgv
 3i0UuFvL1D+kb+5xhBg4MuF5zqNSj4Qw9RHOG/VM7X5DZoUEuP9TvaVi/CbKKMxN9caG43VTL3v
 HKOEceOMY8biX62bVuuzP7ppafdMjPcMQxlJRmJG9WsWxZjHyQyzkrVdqAFgB8sc7j/Fw3KpBkn
 OuSz2hL2nPb0pdwjvbzRUQi5B9lcAOzMzR8xl91uUC/qe9mUHJ4pdKg2QdbIL5Ji9oL1j2BqyhH
 POyrbTszT8fWzIKNoGDQtxe3WIhQqmFzCCYKMELWn42AgMB9PoOJBg02jyaskoros7ZroaAMd3z
 2VycZbkQHlyBnybW4++Bsh36seRznoq3ui7T61GCAFHJZQIOT2q+B7pyK921FN4j2zwfMyaH6md
 /1jvUMFvWJeZVrGSpIg==
X-Proofpoint-ORIG-GUID: MEeEiqrO68wYjINYwtjLubSvOA9eWFw1
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a96eb92 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=oMzoRjevkXO8OqSMbZQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: odP2NZ-6mH2MAGpBVHOb35SkiQya0zjv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDEzMyBTYWx0ZWRfX2Bzmoz7Qexa3
 6KxpGEoAiD784s1Dx8OCJ8wVfrwSgvX4wVthtS+71IkE5GHbmuQzZs8ZTCjGX5mUZqcg5CUN64d
 PVunR4/E5gPwAtabxo0sLIOs/aYYlkI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010133



On 01/09/26 6:32 pm, Dust Li wrote:
> On 2026-08-31 20:27:38, Mahanta Jambigi wrote:
>>
>>
>> On 31/08/26 7:12 pm, Dust Li wrote:
>>> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>>>> This series fixes multiple lifetime races in the SMC diag dump path.
>>>>
>>>> The first patch adds the basic infrastructure needed to synchronize diag readers
>>>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>>>> per-connection spinlock and uses it in the link switch and connection free
>>>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>>>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>>>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>>>> without borrowing any extra reference.
>>>>
>>>> The second patch fixes two races in smc_diag itself:
>>>>
>>>> - serialize clcsock field access against smc_clcsock_release() with
>>>>  mutex_trylock()
>>>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>>>  still registered, then snapshot all required fields and call nla_put()
>>>>  after releasing the lock
>>>
>>> Hi Mahanta,
>>>
>>> As discussed in the other thread, I think we should defer the release of
>>> smc->clcsock and remove clcsock_release_lock.
>>>
>>> In that case, we should no longer need these two patches. Also,
>>> introducing more locks in SMC is the last thing I want to do :)
>>
>> Thanks for the new series "[RFC net-next 0/7] net/smc: tie clcsock
>> lifetime to the smc socket and remove clcsock_release_lock" — once it
>> lands, we can drop the mutex_trylock() fix for Race 1 (clcsock).
>>
>> However, Race 2 remains open. Your series does not touch smc_core.c or
>> smc_cdc.c, so smc_conn_free(), smc_switch_link_and_count(), and
>> smc_cdc_msg_validate() still write conn->lgr/conn->lnk with no
>> synchronization against the diag reader.
> 
> Hi Mahanta,
> 
> Thanks for the detailed explanation. You are right that a per-connection
> spinlock can work here, and I agree none of the lock sites are on the
> per-message hot path. But I think we can also do the same thing we did with
> clcsock_release_lock: instead of adding a lock, tie the lifetime of
> conn->lgr/conn->lnk to the point where the connection stops being observable,
> and remove the need for synchronization altogether.
> 
> For lgr/lnk, that point is the hash table. Once the connection is unhashed, the
> diag dump (which iterates under the hash read_lock) can no longer reach it. So
> if we make sure the connection-owned references are only dropped after unhash,
> the invariant becomes: holding the hash read_lock and seeing a non-NULL
> conn->lgr implies it is safe to dereference. The diag path then reduces to
> `hold hash read_lock -> read conn->lgr -> if non-NULL, use it -> done` with no
> new lock, no extra reference, and no trylock. The invariant is carried by
> object lifetime rather than by a lock, which I find easier to keep correct over
> time.

I looked carefully at the new design and found one remaining gap.

The *unhash* invariant — "any socket in the hash has its
connection-owned lgr/lnk refs held" — protects against smc_conn_free()
dropping refs while the socket is still hashed. However it does not
protect the conn->lnk->smcibdev->ibdev->name access in the
SMC_DIAG_LGRINFO block in smc_diag.c file.

The gap is in *smc_switch_link_and_count*(). It is called under
send_lock (not under any hash-related lock) and calls
smcr_link_put(conn->lnk) on the old link before reassigning conn->lnk.
If that put drops the last reference, __smcr_link_clear() runs
immediately, doing memset(lnk, 0, sizeof(struct smc_link)) which zeroes
lnk->smcibdev. The socket remains hashed throughout — so the *unhash*
invariant is not violated — but the diag reader can hold a stale pointer
to the old link and race this memset. The timeline:

diag reader [hash read_lock held]:
    conn->lnk → old_lnk (non-NULL, socket hashed ✓)
    [about to read old_lnk->smcibdev->ibdev->name]

smc_switch_link_and_count() [send_lock held]:
    smcr_link_put(old_lnk) → last ref → __smcr_link_clear()
        memset(old_lnk, 0, ...) ← smcibdev = NULL

diag reader:
    old_lnk->smcibdev->ibdev->name ← NULL deref

The *unhash* invariant says nothing about the link a connection used to
point at before *smc_switch_link_and_count*() swapped it. Hash
membership of the socket provides no protection here because the socket
is still hashed — the link pointer simply changed underneath the diag
reader.

Any ideas on this?

Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DCC375AC6;
	Thu,  3 Sep 2026 07:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422210; cv=none; b=LzpqG/h4HiW4tKN6THIkGeVhr/JW/2VZEO4f/ca2gUJ3lTdA1BhNVeMqojkpgHPjzbJZAU65AisKtMqi4WbiqsINUUXWUX+nl+fzX/HDxsY87Lssg3b3ZIYWn4JEweaTTAXjcbhZkL6wBPv6Zda0C6AN4FQKvHhcm8FmIohzStg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422210; c=relaxed/simple;
	bh=nPXSat9Y8qMV6LqZbab7eUT7de7PGqDfdArGw9j7kTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eKextiWm/bXfpguikp/LhQxpDz9Oc1A9oUSRep/6Z2T6ng6SDAgmagLJu8vQpNdQ8nWqXnUhIdaWkyhUFNCG+xydgL710FOR95tnu67irO+07YetfIf4XRQcSl4KMwwDQCjBrE+UqF0FJDaNXsJeNavq28OhAjUaIq35p+Rpifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RLizagp+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RLizagp+"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68361SoP2186417;
	Thu, 3 Sep 2026 07:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LFwris
	lcYH1GXAA0Z1wy8u9LA7IR72GFlQ3AuPoiAiE=; b=RLizagp+sDPPHS4PJ1JRbX
	7bos6O4C6VWlWUxQWwE/pserx3c1HH5SGiuoVVxZmJA3bAXbYvxKKsJvunwrzZVi
	XectMacqkUPCfrFeAfeiUbkb72Hchg1LF5EAEdcXTuLhhRqaUeoHC9WYmNUz/B5i
	EKAZgl1Vc0lGvbjJ4UunZULf/FDifihxlorYsCeaxvVkh9dRt+sFN6+ZdeWnuGu0
	G/pX53ejzsd91CisMl2dEcNtjjqNzCq+nYQD5sSka8c3duL7d/uBbbHvUvA8/bUw
	pzEHkV0ZYg2v1oCJS0nt3WXyt5qJTd1xpnL3bLsTTyHmEwsqmm4Ac+US90gmD0tg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq553rx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:56:40 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6837uQm6031271;
	Thu, 3 Sep 2026 07:56:39 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcbygpfqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:56:39 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6837ucnd16515602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 07:56:38 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3E5D58056;
	Thu,  3 Sep 2026 07:56:37 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 369F65805E;
	Thu,  3 Sep 2026 07:56:32 +0000 (GMT)
Received: from [9.123.4.74] (unknown [9.123.4.74])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 07:56:31 +0000 (GMT)
Message-ID: <899816c9-c908-4d64-8f5c-ba35619f78f2@linux.ibm.com>
Date: Thu, 3 Sep 2026 13:26:30 +0530
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
 <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
 <apgTu9dRGIQE6tm3@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <apgTu9dRGIQE6tm3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfX8vbu34ZfPje+
 niQy21HiphtNfsiAuOCA7o6mXzd4qbdTvTbzxWSFEhbJnIk5L5m0q15+7ApGxVqmfFNucKo62lX
 HtgeyVygQbO25G/YNH3fKrCrIQbHGsy0qxWp3pqOxHtZ8UYxH0THJvE2ZhGC4oyu/EHEc1Iq+yV
 6FUuD+QZMeX4OXTKKdxv0/j/1GgrsAXdHIoBQ9CqqI7JZA7Smq6r+hoROScYFvISdrk485EQSW6
 5qo2uO1jXw1eIeyYIeL2KKhS6ZbQi6cgxBX5TDexffQ7UgD8pY55+gZ/OP3JrLX9vCa998ytx0d
 dK0V77yeFZR3y2bZzzNfmCR9A7zbUpudVkqSWOolejgBpLWXQzd4DYxjFbWrahS5LKRu93m6cvC
 /4/oXvUm2xjPoyF0Hk/jwu3FWyS+uiTrrP/86tFl1/jT2wVvTDIlMX02wceQRY7gpDF0FI6aOOh
 pbcuqJYV9ke3FZagpSg==
X-Proofpoint-ORIG-GUID: YIFnRvhLaFAFZvyi-8MBYLoJWJf7J33x
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a992839 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=W0d0o3OFOr16zztopj0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: XyCmL7rdUrtvc9kAuJvoWfNwoVFi-gjO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfXxRgzhEu/6PDs
 SJ++7Q6+p50FN5b6gyvVbjUBJD0OiuVQTCOGtc+FJgfHDeht6zfVtdGu+oguDFxr/BQHWcqO2om
 +rThr0SLpmrwoBHEbmdtRiHXriQ5Yfk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_02,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030066



On 02/09/26 5:46 pm, Dust Li wrote:
> On 2026-09-01 20:43:11, Mahanta Jambigi wrote:
>>
>>
>> On 01/09/26 6:32 pm, Dust Li wrote:
>>> On 2026-08-31 20:27:38, Mahanta Jambigi wrote:
>>>>
>>>>
>>>> On 31/08/26 7:12 pm, Dust Li wrote:
>>>>> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>>>>>> This series fixes multiple lifetime races in the SMC diag dump path.
>>>>>>
>>>>>> The first patch adds the basic infrastructure needed to synchronize diag readers
>>>>>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>>>>>> per-connection spinlock and uses it in the link switch and connection free
>>>>>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>>>>>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>>>>>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>>>>>> without borrowing any extra reference.
>>>>>>
>>>>>> The second patch fixes two races in smc_diag itself:
>>>>>>
>>>>>> - serialize clcsock field access against smc_clcsock_release() with
>>>>>>  mutex_trylock()
>>>>>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>>>>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>>>>>  still registered, then snapshot all required fields and call nla_put()
>>>>>>  after releasing the lock
>>>>>
>>>>> Hi Mahanta,
>>>>>
>>>>> As discussed in the other thread, I think we should defer the release of
>>>>> smc->clcsock and remove clcsock_release_lock.
>>>>>
>>>>> In that case, we should no longer need these two patches. Also,
>>>>> introducing more locks in SMC is the last thing I want to do :)
>>>>
>>>> Thanks for the new series "[RFC net-next 0/7] net/smc: tie clcsock
>>>> lifetime to the smc socket and remove clcsock_release_lock" — once it
>>>> lands, we can drop the mutex_trylock() fix for Race 1 (clcsock).
>>>>
>>>> However, Race 2 remains open. Your series does not touch smc_core.c or
>>>> smc_cdc.c, so smc_conn_free(), smc_switch_link_and_count(), and
>>>> smc_cdc_msg_validate() still write conn->lgr/conn->lnk with no
>>>> synchronization against the diag reader.
>>>
>>> Hi Mahanta,
>>>
>>> Thanks for the detailed explanation. You are right that a per-connection
>>> spinlock can work here, and I agree none of the lock sites are on the
>>> per-message hot path. But I think we can also do the same thing we did with
>>> clcsock_release_lock: instead of adding a lock, tie the lifetime of
>>> conn->lgr/conn->lnk to the point where the connection stops being observable,
>>> and remove the need for synchronization altogether.
>>>
>>> For lgr/lnk, that point is the hash table. Once the connection is unhashed, the
>>> diag dump (which iterates under the hash read_lock) can no longer reach it. So
>>> if we make sure the connection-owned references are only dropped after unhash,
>>> the invariant becomes: holding the hash read_lock and seeing a non-NULL
>>> conn->lgr implies it is safe to dereference. The diag path then reduces to
>>> `hold hash read_lock -> read conn->lgr -> if non-NULL, use it -> done` with no
>>> new lock, no extra reference, and no trylock. The invariant is carried by
>>> object lifetime rather than by a lock, which I find easier to keep correct over
>>> time.
>>
>> I looked carefully at the new design and found one remaining gap.
>>
>> The *unhash* invariant — "any socket in the hash has its
>> connection-owned lgr/lnk refs held" — protects against smc_conn_free()
>> dropping refs while the socket is still hashed. However it does not
>> protect the conn->lnk->smcibdev->ibdev->name access in the
>> SMC_DIAG_LGRINFO block in smc_diag.c file.
>>
>> The gap is in *smc_switch_link_and_count*(). It is called under
>> send_lock (not under any hash-related lock) and calls
>> smcr_link_put(conn->lnk) on the old link before reassigning conn->lnk.
>> If that put drops the last reference, __smcr_link_clear() runs
>> immediately, doing memset(lnk, 0, sizeof(struct smc_link)) which zeroes
>> lnk->smcibdev. The socket remains hashed throughout — so the *unhash*
>> invariant is not violated — but the diag reader can hold a stale pointer
>> to the old link and race this memset. The timeline:
>>
>> diag reader [hash read_lock held]:
>>    conn->lnk → old_lnk (non-NULL, socket hashed ✓)
>>    [about to read old_lnk->smcibdev->ibdev->name]
>>
>> smc_switch_link_and_count() [send_lock held]:
>>    smcr_link_put(old_lnk) → last ref → __smcr_link_clear()
>>        memset(old_lnk, 0, ...) ← smcibdev = NULL
>>
>> diag reader:
>>    old_lnk->smcibdev->ibdev->name ← NULL deref
>>
>> The *unhash* invariant says nothing about the link a connection used to
>> point at before *smc_switch_link_and_count*() swapped it. Hash
>> membership of the socket provides no protection here because the socket
>> is still hashed — the link pointer simply changed underneath the diag
>> reader.
>>
>> Any ideas on this?
> 
> Good catch ! You are right that the "unhash invariant" as stated
> does not cover the stale-conn->lnk race through a link switch + clear.
> 
> I think we can close this window by holding the SMC hash table lock in
> smcr_link_clear()? As the diag walker captures and dereferences the stale
> pointer within a single read_lock hold on the SMC hash table. Since
> smc_link_clear() is a cold path, and the region where we hold the SMC hash
> table lock is small, the overhead should be negligible.
> 
> 
> Something like this:
> 
> ```diff
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 5af55abece57..ca3030f02e70 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1361,6 +1361,18 @@ static void __smcr_link_clear(struct smc_link *lnk)
>         struct smc_ib_device *smcibdev;
>  
>         smc_wr_free_link_mem(lnk);
>  
> +       write_lock_bh(&smc_v4_hashinfo.lock);
> +       write_lock_bh(&smc_v6_hashinfo.lock);
>         smc_ibdev_cnt_dec(lnk);
>         put_device(&lnk->smcibdev->ibdev->dev);
>         smcibdev = lnk->smcibdev;
> @@ -1368,6 +1380,9 @@ static void __smcr_link_clear(struct smc_link *lnk)
>         lnk->state = SMC_LNK_UNUSED;
>         if (!atomic_dec_return(&smcibdev->lnk_cnt))
>                 wake_up(&smcibdev->lnks_deleted);
> +       write_unlock_bh(&smc_v6_hashinfo.lock);
> +       write_unlock_bh(&smc_v4_hashinfo.lock);
> ```
> 
> What do you think ?
Hi Dust,

After debugging further, I believe that __smcr_link_clear() cannot be
called from smc_switch_link_and_count() because
refcount_dec_and_test(&lnk->refcnt) is always false on that path — the
initial ref (set in smcr_link_init(), released only in
smcr_link_clear()) is always held while the switch executes. So there is
no UAF from that path. The only consequence is that the diag reader may
observe a stale conn->lnk pointer value — pointing to the old link which
is still fully live — and read the old link's ibport/link_id/ibname from it.

The real UAF is via smc_conn_free(): it drops both the connection-owned
conn->lnk reference via smcr_link_put() and the connection-owned
conn->lgr reference via smc_lgr_put(), while the socket is still visible
in the hash table. For conn->lgr this means kfree(lgr) can race with the
diag reader dereferencing lgr->is_smcd, lgr->role, lgr->list etc. For
conn->lnk this means memset(lnk, 0, ...) in __smcr_link_clear() can race
with the diag reader dereferencing link->smcibdev->ibdev->name. The
current patch tries to fix this using lgr_lnk_lock. Since you suggested
we fix it with *unhash-before-free*, I thought about it and here is my
proposal.

Proposed fix (high level):

Introduce a smc_conn_unhash() helper with a per-connection unhashed flag
that ensures the socket is removed from the hash table exactly once.
Call it at the top of smc_conn_free(), before any lgr/lnk references are
dropped.

This establishes the invariant: any socket still visible to the diag
reader under read_lock(hash->lock) has valid conn->lgr and conn->lnk
pointers. The mutual exclusion between write_lock_bh(hash->lock) inside
smc_conn_unhash() and the diag reader's read_lock(hash->lock) ensures
that by the time smcr_link_put() runs in smc_conn_free(), the socket is
already gone from the hash — the diag reader either completes before the
unhash or never sees the socket at all.

The unhashed flag is needed because smc_conn_free() can be called from
multiple paths (e.g. smc_conn_kill() ahead of __smc_release()), so we
need to guarantee the unhash happens exactly once.

Does this design look reasonable to you?

There is a separate minor issue — smc_switch_link_and_count() updates
conn->lnk under send_lock while the diag reader loads it without any
lock, which can cause stale ibport/link_id/ibname in *smcss -R* during a
failover event. This is a data race but not a safety issue since the
link struct is always live at that point.

This race is very rare in practice — it requires a concurrent smcss -R
dump to hit the exact CPU-cycle window during a conn->lnk pointer write,
which itself only happens during an exceptional link failover event.
Even when it occurs, the effect is transient: one dump may show the old
link's ibport/link_id/ibname, and the next dump will show the correct
values.

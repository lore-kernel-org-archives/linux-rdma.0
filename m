Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E73B42E3;
	Fri, 18 Sep 2026 07:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789716470; cv=none; b=A4nxufPFyQFlXupB/UbzdSPWgkur3JFIBSdyROPK1XUS0t4zxGvvMAWu1DGKMJ0wQ65+xqU1+o3iTPQBVgN+awgQm3jLHEldvCbYiKvZ0tH9HjGy099plWctsZlKTIC8RKTpxaeiSVrooSusSz1DfHYOZjgPo5T+HUlr/JTLdtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789716470; c=relaxed/simple;
	bh=Wr4nyvzcR7JAFQv8sDWIUvP9LIRBWSLeep4vaSSRrOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGdj4Nk+4xVzU5PsPwg39sqvTj5J+K6LxA1UYvFd4v8pLgW6VEPWy0/KfDd+DS4/4NHlhn528Cwy1Y/vd3mn+3tXvrKkoyf9lYxtkuNQohmtPeC8W+Bdcki97pGAogby7F3/p8F78g443lxZqamWzvoRX9xqsEEiF/jrabsOdaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HsS7XZ5x; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HsS7XZ5x"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I61XiZ457215;
	Fri, 18 Sep 2026 07:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=x+H+eF
	PYEIB0UoYVc5ZjURmJ2HCWkqvvv2is4lFZPw8=; b=HsS7XZ5xM9lyMgn/zEzyl5
	ZGjT2BvywdVghsQoADzELXCN7+VIUumdWA5jbwrjHelVT4BTmuchW5ZP1ulGXjfy
	9KYOVEB/Q6bAKz44tBi4TFAkVhAKclMwtiujMFqHt9yguaWmna7lmBZaF1sHHKkA
	/s9GoObnjhktPv76JZhsx0JxNxQy8wMeNWH7rqx8glp8Mvn5xtQRk2HNx2R7B0O4
	XBGl11znCWkZy3fbrNvsUZN8ohOaySz74MsT9XyFRCnBa4Y/4M6gnWCvEncCAsqL
	2h9rTzvDD9IYsRmPoPC0SDOU/XBDXUCYNVMZNJeKH4XQTU5vxtHhugWJzLrsm3fA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx846t8j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 07:27:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68I652Eu1154846;
	Fri, 18 Sep 2026 07:27:22 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr7genvac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 07:27:22 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68I7RLqB42664402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 07:27:21 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 146225805B;
	Fri, 18 Sep 2026 07:27:21 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75DD258058;
	Fri, 18 Sep 2026 07:27:15 +0000 (GMT)
Received: from [9.111.160.79] (unknown [9.111.160.79])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Sep 2026 07:27:15 +0000 (GMT)
Message-ID: <d11098fd-042c-4246-ba3b-9c2662447f21@linux.ibm.com>
Date: Fri, 18 Sep 2026 12:57:13 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hidayath@linux.ibm.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
 <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
 <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>
 <aqq0rnQjiKymR3TM@linux.alibaba.com>
 <2111df0c-33b1-4330-8adf-ac5a0f1de451@linux.ibm.com>
 <aqwM5USzvdm5zF40@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <aqwM5USzvdm5zF40@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDA5NCBTYWx0ZWRfX2LEL4DqE7S0i
 LRndXWD/1pPWFlvDLj2xe8vnStKwH05PZm+7Ul67NCAIH6xuqfM7fOoF7D00u/2bJH+AUvGnLB4
 kI2W4E4PJLUbpsxQ2iBum89NyMLrrN2+QI0SDUs2bTf9b39cGqug5cTlCN3XP9wH6C/kXprB2+p
 JuWSjUSf0Kgm5Fa8lpQAZ7PUWBfBBEfiKwY23JnIspLsI3wLidczkqDGOx//Qvk+BdeSY3sTG6X
 K0qA1ZO8uaRqNv+l8+rst22QVw+c988kzQOXUEWhdt2Omcn6LZVQZ3lcs2tSSs/Sp4mnBSsaz8F
 bbtKdGiJmadGD4ugRol169PWifLKJ+kxVh+7NVuwZ2LvXhhx9fxoiPnFfsrmeszAl80AY0mxhzV
 dqYtx3uIiBLIE8WK2tQuxLLvKv0NId1+vDFCzZZ9/21FDWSZ0gCZoFobFGOQnNS4MVwRXRDcl0m
 qnk03wocZbW7UNf4epQ==
X-Proofpoint-ORIG-GUID: XifP6K_Ftt7UtKQwvbSQdtfebg422q9x
X-Proofpoint-GUID: SV85c2tR4z56xvmot4vVapNolRtXfanR
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDA5NCBTYWx0ZWRfX9ahZrEt/GsmG
 wD4IrPo08tZvoopffbnzch97uhB/Rr/gJaTQJUUpPr9xFhKiEwCP/Imj3917aB4BspYcbqNlq0z
 0ACQHf+M7/EUAzlx/tP4tIELQh1EBNM=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aace7dc cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=j7ZKgxhjHW8lMw6mU2MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180094



On 17/09/26 9:23 pm, Dust Li wrote:
> On 2026-09-17 13:15:23, Mahanta Jambigi wrote:
>>
>>
>> On 16/09/26 8:54 pm, Dust Li wrote:
>>> On 2026-09-16 14:04:42, Mahanta Jambigi wrote:
>>>>
>>>>
>>>> On 15/09/26 8:43 pm, Dust Li wrote:
>>>>> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>>>>>> The diag dump walks the socket hash table under a read_lock and
>>>>>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>>>>>> drop those references via smc_conn_free() while the socket is still
>>>>>> hashed:
>>>>>>
>>>>>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>>>>>> smc_close_passive_work() -> smc_conn_free()
>>>>>>
>>>>>> This allows the diag reader to dereference a freed lgr or lnk.
>>>>>>
>>>>>> Fix it by unhashing the socket before smc_conn_free() is called at
>>>>>> each of these two sites.  Any socket visible to the diag reader
>>>>>> under the hash read_lock then has valid conn->lgr and conn->lnk
>>>>>> pointers.
>>>>>>
>>>>>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>>>>>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>>>>>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>>>>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>>>>>>> unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>>>>>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>>>>>> so direct calls at the two teardown sites in smc_close.c are
>>>>>> sufficient - dropped the __smc_release() hunk: it needs no change
>>>>>> since the subsequent unhash there is already a safe no-op - fixed
>>>>>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>>>>>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>>>>>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>>>>>> there would make live fallback sockets invisible to smcss -
>>>>>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>>>>>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>>>>>> and then smc_conn_create() on the next device; unhashing in 
>>>>>> smc_conn_free() would permanently hide the established connection
>>>>>> from smc_diag since smc_conn_create() does not re-hash the socket
>>>>>
>>>>> Hi Mahanta,
>>>>>
>>>>> This version looks clean. And you explained why we can't call unhash
>>>>> in smc_conn_abort() well. But smc_conn_abort() still calls
>>>>> smc_conn_free(), when the smc_sk is still hashed, is there still a
>>>>> race window with dump ?
>>>>
>>>> Hi Dust,
>>>>
>>>> Thank you for catching this corner case!
>>>>
>>>> During early handshake setup (when sk_state is *SMC_INIT*),
>>>> smc_conn_abort() can be called on connection failure/fallback and
>>>> invokes smc_conn_free() while the socket remains hashed, leaving a
>>>> window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
>>>> and dereference conn->lgr / conn->lnk.
>>>>
>>>> Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
>>>> and userspace (smcss) *skips displaying link-group, DMB, and connection
>>>> details for INIT state sockets anyway*, we could have __smc_diag_dump()
>>>> skip inspecting connection/link-group extensions when r->diag_state ==
>>>> SMC_INIT:
>>>>
>>>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>>>> --- a/net/smc/smc_diag.c
>>>> +++ b/net/smc/smc_diag.c
>>>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>>>> sk_buff *skb,
>>>> 	r->diag_state = sk->sk_state;
>>>> +	if (r->diag_state == SMC_INIT)
>>>> +		return 0;
>>>> +
>>>> 	if (smc->use_fallback)
>>>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>>>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>>>
>>>> Together with unhashing before smc_conn_free() in smc_close.c for
>>>> established and closing sockets, this cleanly closes the race window
>>>> across all socket states without touching the hash table mechanics
>>>> during fallback/retry.
>>>>
>>>> Does this approach look good to you? If you agree, I will prepare and
>>>> submit v5 with this change. Please let me know if you have any other
>>>> suggestions or alternative approaches, and I'll be happy to look into them.
>>>
>>> What about this path ?
>>>
>>> smc_listen_decline() -> smc_listen_out_err(), where smc_conn_abort() has
>>> already run, and the sock state is then changed from SMC_INIT to SMC_CLOSED.
>>
>> Hi Dust,
>>
>> Good catch on the smc_listen_out_err() path as well!
>>
>> In smc_listen_decline() -> smc_listen_out_err(), the server socket fails
>> handshake and is transitioned to SMC_CLOSED while remaining in the hash
>> table until smc_accept_dequeue() runs.
>>
>> Since userspace (smcss) skips displaying all connection, link-group, and
>> DMB details for both SMC_INIT and SMC_CLOSED sockets (smcss.c:186 and
>> smcss.c:199), we can update __smc_diag_dump() to check for both states:
>>
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>> sk_buff *skb,
>> 	r->diag_state = sk->sk_state;
>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>> +		return 0;
>> +
>> 	if (smc->use_fallback)
>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>
> 
> I checked the code again, and I'm afraid adding SMC_CLOSED is still not right.
> 
> smc_listen_decline(): smc_switch_to_fallback(), smc_clc_send_decline() then
> fails, and smc_listen_out_err() sets the socket to SMC_CLOSED. The socket
> stays on the accept queue, hashed, until accept() reaches smc_accept_dequeue().
> 
> But the early return sits after nlmsg_put() but before diag_mode,
> smc_diag_msg_attrs_fill() and the SMC_DIAG_FALLBACK attribute are filled.
> The record is still emitted, but diag_mode is left at 0 -- which is
> SMC_DIAG_MODE_SMCR, not "unknown" -- and the fallback reason attribute is gone.

Regarding your concern about wrong output when the early return fires
before diag_mode and SMC_DIAG_FALLBACK are filled: you are right that
diag_mode must be filled before the guard. *smcss.c* reads diag_mode at
lines 177 and 179 for --smcr/--smcd filtering, which happens before the
SMC_INIT and SMC_CLOSED state checks. If diag_mode is left as 0 for
a failed-fallback SMC_CLOSED socket, --smcr would incorrectly include it
and --smcd would incorrectly exclude it.

*SMC_DIAG_FALLBACK* however is *not* needed before the guard — smcss
only reads it inside the diag_mode == SMC_DIAG_MODE_FALLBACK_TCP branch
which is never reached for *SMC_INIT* or *SMC_CLOSED* sockets, as those
two states hit goto newline before that point.

So the correct placement is after smc_diag_msg_attrs_fill(), which fills
diag_mode, diag_uid, and diag_inode, but before SMC_DIAG_FALLBACK:

    r->diag_state = sk->sk_state;
    if (smc->use_fallback)
        r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
    else if (...)
        ...
    if (smc_diag_msg_attrs_fill(sk, skb, r, user_ns))
        goto errout;

+   if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
+       goto out;

    fallback.reason = smc->fallback_rsn;
    ...

+out:
    nlmsg_end(skb, nlh);
    return 0;

At this position all fields smcss reads for these two states are already
filled correctly, including diag_mode for --smcr/--smcd filtering.  The
CONNINFO, LGRINFO, and DMBINFO blocks — which contain the unsafe lgr/lnk
dereferences — are never reached.

What is your opinion on this?
> 
> Why don't you use conn->free instead of sk_state ? It is set unconditionally
> at the top of smc_conn_free() before any lgr/lnk reference is dropped.
> 
> 
> So maybe something like this ? Please double check.
> 
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..a19f16881ae7e 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -103,6 +103,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>         if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>                 goto errout;
> 
> +       if (smc->conn.freed)
> +               goto out;
> +

Regarding conn->freed: it does not fully close the race. The check and
the subsequent lgr/lnk dereferences in the LGRINFO/DMBINFO blocks are
not atomic. The diag reader can pass the conn->freed == 0 check, then
smc_conn_free() runs concurrently and calls smc_lgr_put() which may drop
the lgr refcount to zero and free lgr, and then the reader resumes and
dereferences conn->lgr — a UAF.

>         if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>             smc->conn.alert_token_local) {
>                 struct smc_connection *conn = &smc->conn;
> @@ -185,6 +188,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>                         goto errout;
>         }
> 
> +out:
>         nlmsg_end(skb, nlh);
>         return 0;
> 
> BTW, as we talked in the previous threads, the teardown path is messy and lots
> of hidden holes, so I think we will finnally refine those.
> As for now, if this works, I think we can go with it.

I agree, as of now I am trying to fix the UAF bug with minimal changes.

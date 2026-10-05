Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8894825BB;
	Mon,  5 Oct 2026 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205879; cv=none; b=UN7A7h2hGzD9sYo8zJx1PrME0KV3qJkjDJngOMb5PPKs5mogikn2jC3jIQUgjIk8obNRWXp5dzSCgQPSQyQ98fE9KcsmQ/I56Bh9FlKo0EvLLHiK3uIaKT0V1CpeO1jPd66Q/DFgqdNdE/Um0FRVJzCrXdm3WC9u3qCtx0BLC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205879; c=relaxed/simple;
	bh=yggD/7T8H2cKdHwzxrMCg/sJWOUy1fSXJcntZp7PbVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdqIEFdoZ8/sX0EAKjosMAjXPjByZ0fpkDV9PqJ9+hIkekw9cKSwv1zdvnnh3TDm0g2/N6uAnj2kDcVN5LoApK/7KdleSeYCqpg2Mx+9Iq7ZLFXOOrbnmB0i06jcUeW16nQ1sSLfWksqYJwHNTjUHrnvjZnWzDD/BSfrg1X1DKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eE4OXAq4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eE4OXAq4"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695CZu7T712185;
	Mon, 5 Oct 2026 13:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IAMuV/
	Ckmeidgom5DWMsQUY5YhSz05Mw6tgXMXt9cPU=; b=eE4OXAq4YQfKrTl/RuY8fr
	N8BGfc9zdQ6mDcOeTI02ifU+3T2P8S8vmi5Gl0OJYOsESdkh2iS8Magetk6uuP7Y
	Xc3L/xRc5buJzH0WGUp8t0NFCuI7nOgnfL5xNha7JX+QalVqInkozsOFrurICIef
	mysPjzlpUGLDO8oIF40Kn+BQcYY2synS8WOhUH8/MF6mEyp7euJExjWm3qyJJcO3
	XPv39FtJCuZDIAaVHNrkCgPuAx3tE7fbuCIv6d1spBZ6sY0tGHWCcYDHP81aVXfd
	wETijCfw355vx/I5QN+fXEEm36tsg8DF/DT1kmqi9WvvSdhbWzRwlgApHOj1INXw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2s74jdmj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 13:10:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 695CWiD62894025;
	Mon, 5 Oct 2026 13:10:26 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3cdvnn9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 13:10:26 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 695DAPiJ7734074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Oct 2026 13:10:25 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5CB558064;
	Mon,  5 Oct 2026 13:10:25 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B01D5805D;
	Mon,  5 Oct 2026 13:10:18 +0000 (GMT)
Received: from [9.39.23.136] (unknown [9.39.23.136])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Oct 2026 13:10:18 +0000 (GMT)
Message-ID: <46e5b6b2-a0ee-4381-816c-6435c61e320f@linux.ibm.com>
Date: Mon, 5 Oct 2026 18:40:16 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
 <179110012456.434549.13805687630302688897@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179110012456.434549.13805687630302688897@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: TZq39kL32FTxUkRF68m-18kLrWAYpPKm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1MSBTYWx0ZWRfX1m5MtzK3ZN5v
 KGaFLQasXCsVxH3rEkYFwz45tDKP2ln7jkYG1m5UTaUOj9YNFi6BdMrWN018nPRS02DD4bP8j5l
 BxXN+WyAI3cb9co4xMQUdCIRTCObNH0=
X-Proofpoint-GUID: sXcoUv1NlrKxestaNaiyM7h_Ny3r3WUG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1MSBTYWx0ZWRfX5J8oLxaOOy6d
 nDdIEclSGUWIcsDm8bG/Zo91amypKMrOwlIInfMPo+NVVR58BGvwaGYT+QPufRNIozqvEWT0xyX
 xiZxtKL/03MBmODgRMEM3Y46vhNBRW4ebDHnD9Z5UOCuOEKz1lrU5PMaKKIFtqqeYO67ylhpHSg
 27ZACOj6PWTaQNv+3ggpbuhYc+pchq+/JhR1+ljj6jjo5qPWFUgO5MGgCSad4OBO2yhx3SFaI2y
 W7dWWZI7QxoBaUiiht8m1rI1BuxO6Dp8DcbG7XznOqgjSiyEku9eO0FMfyN4C0PZR2qy6vdRlT+
 FZHLE2DdOb3pKqHCKZVjG25DS/wkVso+PKantnlOf/HKykab4KPXaE76KqWXWzioQ1QTRFRry0g
 fkpGo336MyTCMqzwHSIrpLDxZW+AJjxi0bXdeA+IcHMDInnPB7ETOjFSaNzYVS5gB9JVSIsqmRn
 Y15lXYrw6AD8eZ3I48A==
X-Authority-Analysis: v=2.4 cv=fM2sTpae c=1 sm=1 tr=0 ts=6ac3a1c4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=qQrw9uN9OdwYv-SV2ssA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_03,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050051



On 04/10/26 1:18 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch does not fully close the diag-reader vs. link-lifetime
>   race it says it fixes.
> - [Medium] The new safety gates in __smc_diag_dump() depend on a plain,
>   lockless load of sk->sk_state.
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch tries to close races between the SMC sock_diag dump and
> teardown paths. The dump walks the socket hash under read_lock, while the
> teardown paths free lgr, lnk or sndbuf_desc state. The patch adds sk_state
> based guards for SMC_INIT and SMC_CLOSED sockets to __smc_diag_dump(), and
> unhashes the socket earlier in smc_conn_kill(), smc_close_active_abort()
> and smc_close_passive_work().
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..b29bd34acf7b5 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -90,7 +90,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	r->diag_state = sk->sk_state;
>>  	if (smc->use_fallback)
>>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>> +	else if (sk->sk_state != SMC_INIT &&
>> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>>  	else
>>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> 
> [Severity: Medium]
> Is a plain load of sk->sk_state enough to order the later loads of
> conn->alert_token_local, conn->lgr->is_smcd and conn->sndbuf_desc->len?
> 
> This check, and the SMC_INIT/SMC_CLOSED guard added below, share no lock
> with the writer. Nothing sits between the sk_state load and the conn field
> loads: no READ_ONCE(), no smp_load_acquire(), no smp_rmb(). Only a control
> dependency links them, and that doesn't order load->load on weakly ordered
> CPUs.
> 
> On the early abort path the writer runs under lock_sock():
> 
> smc_conn_abort()
>   smc_conn_free()
>     smc_lgr_unregister_conn()    /* alert_token_local = 0 */
>   smc_lgr_cleanup_early()
>     __smc_lgr_terminate()
>       smc_lgr_free()             /* lgr and buffers freed, conn->lgr and
>                                     conn->sndbuf_desc left set */
> smc_switch_to_fallback()
> ...
> sk->sk_state = SMC_ACTIVE
> 
> On arm64, could the reader see sk_state == SMC_ACTIVE together with a
> stale non-zero alert_token_local? It would then read lgr->is_smcd or
> sndbuf_desc->len from freed memory and copy the value into the netlink
> reply.
> 
> This can't happen on x86 or s390, which keep load-load order, and the
> writer's window is long. The Linux kernel memory model still allows it.
> 
> Would READ_ONCE() or smp_load_acquire() on sk_state (or an smp_rmb()
> before the conn field loads), paired with release-ordered state changes,
> be needed here?

Agreed. Under the LKMM, a control dependency does not order load-load on
weakly ordered architectures (such as ARM64).

In v8, I will address this with acquire-release ordering:
- In __smc_diag_dump(), I use smp_load_acquire(&sk->sk_state) and reuse
  the acquired state (in r->diag_state) across the subsequent mode/state
  checks.
- In af_smc.c, I paired it with smp_store_release(&sk->sk_state,
SMC_ACTIVE) when transitioning out of SMC_INIT.

> 
>> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
>> +		goto out;
>> +
> 
> [Severity: High]
> Does this leave the conn->lnk replacement during SMC-R link failover still
> racing with the diag reader?
> 
> For SMC_ACTIVE and closing-state sockets, the LGRINFO block further down
> still does this with only read_lock(&smc_hash->lock) held:
> 
> net/smc/smc_diag.c:__smc_diag_dump() {
>     ...
> 		struct smc_link *link = smc->conn.lnk;
> 		...
> 		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> 		       sizeof(link->smcibdev->ibdev->name));
>     ...
> }
> 
> The failover side doesn't take the hash lock and doesn't unhash the
> socket. For example, when the peer sends DELETE_LINK:
> 
> smc_llc_process_cli_delete_link()
>   smc_switch_conns(lgr, lnk_del, false)
>     smc_switch_link_and_count(conn, to_lnk)
>       smcr_link_put(conn->lnk);
>       conn->lnk = to_lnk;
>   smcr_link_clear(lnk_del, true)
>     ...
>     __smcr_link_clear()
>       put_device(&lnk->smcibdev->ibdev->dev);
>       smcibdev = lnk->smcibdev;
>       memset(lnk, 0, sizeof(struct smc_link));
>       ...
>       atomic_dec_return(&smcibdev->lnk_cnt)
> 
> A local RNIC or port going down reaches smc_switch_conns() the same way,
> through smcr_link_down().
> 
> smc_switch_link_and_count() runs only under lgr->conns_lock and
> conn->send_lock. The diag reader takes neither lock.
> 
> Suppose the reader loaded the old conn->lnk before the switch and was
> delayed before the later loads. Could it then dereference a NULL
> link->smcibdev after the memset()? Could it instead read a freed smcibdev
> or ibdev and copy those bytes to userspace?
> 
> An unprivileged SOCK_DIAG dump that asks for SMC_DIAG_LGRINFO (for
> example smcss -R) can reach this.
> 
> The socket stays hashed in SMC_ACTIVE or a closing state. So neither this
> guard nor the !list_empty(&smc->conn.lgr->list) check from 9dbe086c69b8
> filters it out
Good catch. When smcr_link_clear() drops the final base refcount after
smc_switch_conns(), __smcr_link_clear() can execute memset() and
put_device() while a concurrent diag reader holds a pointer to the old link.

To eliminate the pointer dereference and external device lifetime
dependency entirely, in v8 I switched from chasing
link->smcibdev->ibdev->name to copying directly from the cached
link->ibname (which is embedded in struct smc_link and initialized once
at link creation). Since struct smc_link is embedded in the link group
(pinned while the socket is hashed), this avoids the NULL dereference
and UAF on smcibdev/ibdev without introducing extra locking on the
critical TX path.

I'll post v8 shortly with these 2 changes.

pw-bot: cr


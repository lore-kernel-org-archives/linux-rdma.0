Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793169607;
	b=yxr7631q3TH1C0N1JxGjldsj70EDUhgOquok/ndkps0S0KpvQfM4+BWiAZg3Mm0yve66
	 eZWmVbBb7rUCyJmZjx2Blh6ihoyCFo/au8rk8+rNvHyQdQB7ZW9GpxgsSzLGEnSnRw00O
	 IJsipwCVbLkF7QbkpM1lfAg5a8vvd4mL1pOBimcs5O+PZR8iYkuujkq/1r+/XwH5oEkDb
	 VLxRK+ddSqrYTFC1m3JqEurJ/AJz/m+H5aHu9CUkjYLfI02pckMrbiFvKehu04L0yDkUQ
	 0reX85tKqTDmjyvdC++EhM7V2ZstN3inqCJBhosCnIfcITDD+YCh1xwlYvoHfFlXAlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793169607;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:Cc:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=VRMp0VSYcpSQF97GiENk7UaqrDcmf17j4ys0PVfumL8=;
	b=A3ckM/7v1557RI8RI/zYz6VzCYcmhhyiJt+gTCx9mElBfaHZt7Kl8UPY3sp5+18o/7GT
	 8tERv0wHPIMHEisM8xIrIqID+dHJYucqkw/4hT1cWPxcsrYqDJiTTlivdnoII3rtoFvp1
	 EVTDrn1y4Yle3/hoiFRXYBwYM00Y76rFHhUBgCJBPHcqdWCuiw3C857V/ruA5F54fbLlk
	 ccbMpFN/XWhDD853JWDAUIjSL+L1FW7fgGSWg6cl75eDSaOB6PggBw13/Ke+GKN5CnFhb
	 EcCvK97MfbFK/sOEATAvwc9hdEgcWG0Tm5au3lLhoM6PX2RLaXhfgBKwzWNg8nCcu3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=jRKoeBzF;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47273606A31A;
	Wed, 28 Oct 2026 06:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47273606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=jRKoeBzF
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4i8ZY287718;
	Wed, 28 Oct 2026 06:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VRMp0V
	SYcpSQF97GiENk7UaqrDcmf17j4ys0PVfumL8=; b=jRKoeBzFv05HveINtC1jJf
	z7Tm5NMYmY+SRfV0T/eS9eR973efIjzQnfSE5Pb74vVmqEBaO94/qAEkkTGI6Jav
	xljPAAk/79W8U9gVvuYDyezUmUGLgw09QI6dQFCadxCXAYCSZOKTLU90eo9bSu99
	euXLOkgAYnr63j9wffV4gvPRVMV4cCQ7aHkHRn5mVT/IOVF2tCGWT0HKViXWBf3/
	l3qfvd+RsdX25ZSH261PE9hSQEWkglupJSuXI0Q7Xi7qEMDrTVwSD8db1HU/sKn2
	ug1yyEO5hW0PcH5+pSwxvXMIqgmGFcuwXAdxPdQRUE+UWiDcpw6Ds0XkpB/8x/4w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgmd73bet-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 06:39:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4Z08K973667;
	Wed, 28 Oct 2026 06:39:55 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hjtnnbwqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 06:39:55 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69S6d6pZ22872576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Oct 2026 06:39:06 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3696558058;
	Wed, 28 Oct 2026 06:39:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46B5C5805C;
	Wed, 28 Oct 2026 06:39:46 +0000 (GMT)
Received: from [9.123.14.188] (unknown [9.123.14.188])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 Oct 2026 06:39:45 +0000 (GMT)
Message-ID: <3190b92c-2fdc-41da-b0e2-b8a6945bef64@linux.ibm.com>
Date: Wed, 28 Oct 2026 12:09:44 +0530
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
Subject: Re: [PATCH net v13] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
References: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
 <179311414480.3134.15723255171112798704@kernel.org>
Content-Language: en-US
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179311414480.3134.15723255171112798704@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ZYOIpcVA c=1 sm=1 tr=0 ts=6ae198bd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=Qo0v_rsg_MSqEvw2p5oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDAyNCBTYWx0ZWRfX2laPY5JtBD8q
 ODucbhtPKhrKxfAO9Y4L94n4NYx1oucQKcXcS9qkNG2ku0sahFWvrKdE6g9+/uPHs5jFGGkjIP9
 G8ooIGgjOHHfBI9SgJk2SrpPfegVSjiFUql+xZMe0xWOcADGmwaO1UbtSIcCBYvsYVEHvenR19e
 H7ygmdCIcUCzVvAp7StaEa3Grdifc9ek3khuITCWzLFUV5m07Hh9Ybeid9lXwcPydeoOsSY7XlS
 zC/DINkW6bUr8kINkjm5lHzPvp42+2ggiD3B0hSzH/aheeXynkACVIeYQ+wNROfet/YesikgEda
 KxUdycJsg4qXpIDnt8Z/e2HnUXuzG8E4Ph9jLJlY8h4a9ZRme3X3GtxuGB+KNHxRJldVKNEezNA
 EdptSFyeLRvJ/4l/h675AtOu4XCE+9cUSawMfYfJrCIyMHF3/fRQ2Pd+27XGlgmmtNSw+5ZUl1N
 kYtumCfqBfr3H7Oq61w==
X-Proofpoint-GUID: RRc89_Eu-uAZul5hWn6hMIKzKeSvLwU4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDAyNCBTYWx0ZWRfXxl65/ksGd4Wf
 1E4B9h50iMI8Mmuy2hBQ51n8vGbSYFvZSXDiScgMmXcYw/UyyUhY7HAauWsHtkGW1uUAtXXDclB
 n/zkVktyQBdTAFCqNyRvP8GynPiGUGc=
X-Proofpoint-ORIG-GUID: uXnhtyT3ZIC84JI04H8SdokQbKW5NO91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280024



On 27/10/26 8:45 pm, netdev-bot+sashiko@kernel.org wrote:
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
> - [High] Use-after-free read of the link group in __smc_diag_dump()
>   (net/smc/smc_diag.c, lines 93-94) for hashed SMC_CLOSED sockets that…
> - [Medium] The new state-based guard in __smc_diag_dump() (smc_diag.c:93
>   and 107-109) can be bypassed by a stale-registration socket that…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch tries to close several windows where the SMC sock_diag dump
> can dereference a freed or partially freed conn/lgr/lnk on a socket that
> is still hashed. It adds an SMC_INIT/SMC_CLOSED/fallback guard in
> __smc_diag_dump(), pairs it with acquire/release on sk_state, and unhashes
> sockets before smc_conn_free() and smcd_buf_detach() in the teardown
> paths. It also uses the cached link->ibname for the LGRINFO attribute.
> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..84c45aabc196c 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  
>>  	r = nlmsg_data(nlh);
>>  	smc_diag_msg_common_fill(r, sk);
>> -	r->diag_state = sk->sk_state;
>> +	r->diag_state = smp_load_acquire(&sk->sk_state);
>>  	if (smc->use_fallback)
>>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>> +	else if (r->diag_state != SMC_INIT &&
>> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> 
> [Severity: High]
> Can this still dereference a freed link group for a hashed socket in
> SMC_CLOSED?
> 
> The diag_mode check here only excludes SMC_INIT. The new SMC_INIT /
> SMC_CLOSED / use_fallback guard comes later, after
> smc->conn.lgr->is_smcd has already been loaded.
> 
> The v13 changelog describes how a stale alert_token_local can survive.
> Once smc_lgr_terminate_sched() has emptied lgr->list, smc_conn_free()
> skips the unregister but still drops the references:
> 
> net/smc/smc_core.c:smc_conn_free() {
>     ...
> 	if (!list_empty(&lgr->list)) {
> 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> 		smc_lgr_unregister_conn(conn);
> 	}
>     ...
> lgr_put:
> 	if (!lgr->is_smcd)
> 		smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */
> 	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
> }
> 
> On the server side this looks reachable as:
> 
> smc_listen_work()
>   smc_conn_create()          <- joins existing SMC-R lgr L
>                              <- smc_lgr_terminate_sched(L) empties L->list
>   smc_clc_wait_msg()         <- peer resets, rc < 0 (-ECONNRESET/-EPROTO)
>   smc_listen_decline()
>     smc_conn_abort()
>       smc_conn_free()        <- unregister skipped, token stays set
>     smc_listen_out_err()     <- SMC_CLOSED, use_fallback false, hashed
> 
> Since rc < 0 there is no fallback. The socket stays hashed in the accept
> queue or until smc_close_non_accepted() takes the sock lock. Later,
> terminate_work runs:
> 
> __smc_lgr_terminate()
>   smc_conn_kill()            <- clears token under conns_lock
>     smc_close_active_abort() <- SMC_CLOSED case just breaks, no unhash
>   smc_lgr_cleanup()
>   smc_lgr_free()
>     smc_lgr_put()
>       __smc_lgr_free()       <- kfree(lgr)
> 
> Nothing in that sequence synchronizes with the hash read_lock that the
> diag reader holds. A reader could see the non-zero token in
> smc_conn_lgr_valid() and then load smc->conn.lgr->is_smcd after the
> kfree. That would read freed memory.
> 
> The "Fourth" paragraph of the commit message says this case must not
> happen: observing SMC_CLOSED and dereferencing an lgr whose reference was
> already dropped. The smp_store_release() added in smc_listen_out_err()
> only helps when the token was actually cleared, and here it was not.
> 
> The client close() path (SMC_INIT -> SMC_CLOSED in smc_close_active())
> doesn't seem to be exploitable this way. The reader's read_lock blocks
> the unhash in __smc_release() while the sock lock is held. The server
> path above has no such protection.
> 
> Could the SMC_INIT / SMC_CLOSED / use_fallback check move ahead of the
> diag_mode computation? Adding r->diag_state != SMC_CLOSED to this
> condition would also work.

Valid finding, fixed in v14.

The v13 diag_mode check only excluded SMC_INIT, so a hashed SMC_CLOSED
socket still loaded smc->conn.lgr->is_smcd. The scenario is reachable.
If smc_lgr_terminate_sched() empties lgr->list after smc_conn_create(),
then smc_conn_free() skips the unregister and leaves alert_token_local
set. A negative rc from smc_clc_wait_msg() then reaches
smc_listen_out_err() with no fallback. The socket stays hashed in
SMC_CLOSED, and terminate_work can free the lgr.

You are also right that smp_store_release() doesn't help here, since the
token was never cleared. v14 excludes SMC_CLOSED before conn->lgr is
read in __smc_diag_dump(), and the commit message now says what the
release store does and doesn't order.

The stale token itself is not new. It comes from smc_conn_free()
skipping the unregister when lgr->list is empty (2a0674fffb6b).

> 
>>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>>  	else
>>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
>> @@ -103,6 +104,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED ||
>> +	    smc->use_fallback)
>> +		goto out;
>> +
> 
> [Severity: Medium]
> Can a stale-registration socket get past this guard if it leaves
> SMC_INIT through passive close instead of fallback?
> 
> Here is a scenario on an SMC-R client:
> 
> smc_connect_rdma()
>   smc_conn_create()             <- registers conn in existing lgr L
>                                 <- smc_lgr_terminate_sched(L) empties
>                                    L->list
>   smc_clc_send_confirm() fails  <- rc < 0
>   smc_conn_abort()
>     smc_conn_free()             <- unregister skipped, lgr/lnk refs
>                                    dropped
> smc_connect_decline_fallback()  <- rc < 0, returns without fallback
> 
> A positive decline code followed by a failing smc_clc_send_decline()
> ends up in the same place.
> 
> The socket stays hashed in SMC_INIT with use_fallback false. The conn is
> still in L->conns_all with its alert_token_local set, so
> smc_cdc_rx_handler() -> smc_lgr_find_conn() still finds it. The peer has
> the token from the confirm, or can guess it from the sequential counter.
> 
> A CDC with close or abort flags then queues close_work, which moves the
> socket out of SMC_INIT:
> 
> smc_close_passive_work():
> 	case SMC_INIT:
> 		sk->sk_state = SMC_APPCLOSEWAIT1;
> 
> smc_close_passive_abort_received():
> 	case SMC_INIT:
> 	case SMC_ACTIVE:
> 	case SMC_APPCLOSEWAIT1:
> 		sk->sk_state = SMC_PROCESSABORT;
> 
> At that point the state is neither SMC_INIT nor SMC_CLOSED, use_fallback
> is false, and smc_conn_lgr_valid() is true because of the stale token.
> The reader then dereferences:
> 
> - smc->conn.lgr->is_smcd
> - conn->sndbuf_desc->len and conn->rmb_desc->len (still on L's lists,
>   since smc_buf_unuse() was skipped)
> - lgr->list and lgr->role
> - the conn->lnk fields
> 
> Meanwhile __smc_lgr_terminate() -> smc_conn_kill() clears the token and
> calls smc_close_active_abort():
> 
> - The ACTIVE/APPCLOSEWAIT branch never unhashes.
> - The PROCESSABORT branch now unhashes, but smc_conn_free() returns early
>   because conn->freed is already set.
> 
> smc_lgr_free() -> __smc_lgr_free() then frees the buffers and kfree()s L.
> 
> What makes that free wait for a diag reader that has already passed the
> token check? The v13 changelog names this stale-registration case, but it
> seems to handle only the variant where the socket falls back.
Its a pre-existing issue & I'm not going to address this in this patch.

It is *not* a regression. The stale token comes from the same old
smc_conn_free() behaviour (2a0674fffb6b), and before this patch the
reader was exposed in SMC_INIT with no further action needed. The
SMC_INIT guard makes this path harder to hit.

It also needs a misbehaving peer. The socket only leaves SMC_INIT if the
peer sends, or guesses, a CDC with a close or abort flag for the stale
token. A well-behaved peer never does that for a connection it saw fail.
On top of that, a diag reader holding the hash read_lock would have to
stall through smc_conn_kill(), smc_lgr_cleanup() and smc_lgr_free()
after passing the token check. The odds of hitting that are very low. A
peer that can forge CDCs on an established SMC-R link can already abort
connections on that lgr, so it has far simpler options than this race.

The proper fix is to clear the token in smc_conn_free() when lgr->list
is empty. That changes lgr lifetime handling, which is where v11 and v12
got stuck, so it belongs in a separate patch. I'm keeping this one
limited to the diag reader.

pw-bot: cr

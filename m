Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792504553;
	b=vfhEt3ud8nMUCJBfREsVclKCdynK3PALpMWofafiComvFxbap//1U7jb7WLLRYdxOtG+
	 ptDimCfgeQvymd0VtbhvXjinetWz3HbiB/xt4lRQPBne43FjmDUkWVPLVqAcegwpprYhC
	 avNruD6vXqHJGN68pKJcpx4tNtThWnG8D9EIq5sFpwPla1vsFzNfeSpzCOJp05ijSlEcW
	 W6XUCCDdfPPvYFR3GURcD4e6ZHX9TpyYDCrYg11r0lPP7V6CSv4gUQDPhSbUJ3UVIaKBN
	 HueWfNJ3SOEkhROugV5YuuOTKxhExLU+wXiVdxcpniTgl8fL4JhGWi0c+RSExMIyilw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504553;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=baLN8Zw8K5CP4rJAF2j58N3uFppr4FonBYEhPUnvlbI=;
	b=ZoHk4MSRtxUz26iYsjKpE2Ew3Vqbmw6uAggzeN50dRoTi2BRr19uoufFdJLgPedqR32y
	 JAGSgOoCuG95O8JuaZAnw2Yx5k26XOfsPopUAz1Zy66kzcms+IhF/DFyCht3MJIFJ7KK1
	 V2y0ZTXkcEtnavnyv1Y1Vr5tbKb82zW79fPp9TIj297JHuhM7iohVevpTBSX8tsiYfM5r
	 JFbqkwrEpepo5itO9e9DdXFLb/H1TnqRrpyf4nwe5XRifjNCyQvoU5zC7UK29sVVIw9Ye
	 xr5FUTCl2JN3edsc8zlFMQQhG9AioqkdFG+aPxWxADb2ENfre8aqCPKY4xCm4l5CDCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="IIi/FyJN";
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28B606A31B;
	Tue, 20 Oct 2026 13:55:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD28B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=IIi/FyJN
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDEOGH2679524;
	Tue, 20 Oct 2026 13:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=baLN8Z
	w8K5CP4rJAF2j58N3uFppr4FonBYEhPUnvlbI=; b=IIi/FyJNQ6ZiHPUERG3gHf
	Y4iFXQWR7mdEQCC5cWo+2rM18fiFh8Jp4Wf/PGrwL0cIa/QDvdjeS0pvTlZMCn8Z
	cK//BNaMSfcGeMVwVQqX7JsTbE/hFLdr6l9cEGeVIraAhaL5SwvNMoi24S8RPrhs
	ASzmmW7/oJiqonE9LZIOWeqATEMDsrbBHvcyl+8KfeKzFmLRM2Oqw36g3WRj14Xy
	ydgr5Bw17QvIiWFlQh2+Ut2DmIUou4pMCjC8dnqX5PY/jFZfDSKA2lqB6YjKrcOF
	AuyfZ9JBuDavR91E0yu7rq5+t6OL4m7v1p9wGvYqBiYiRkJqrCcHNl0G3ln4PDxg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58k78y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 13:55:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDJs7T1542964;
	Tue, 20 Oct 2026 13:55:51 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he6gq8p7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 13:55:51 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69KDtnLO56623600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Oct 2026 13:55:50 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C25A958045;
	Tue, 20 Oct 2026 13:55:49 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D330458052;
	Tue, 20 Oct 2026 13:55:46 +0000 (GMT)
Received: from [9.39.31.249] (unknown [9.39.31.249])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Oct 2026 13:55:46 +0000 (GMT)
Message-ID: <b54bb916-7e0e-4014-b0bb-e61ac0926b32@linux.ibm.com>
Date: Tue, 20 Oct 2026 19:25:45 +0530
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
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
To: sashiko-reviews@lists.linux.dev
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
 <sashiko-outbox-178883@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <sashiko-outbox-178883@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EaHhtNhbKhYLwCACkzXhTXpR5SxvYtpf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA1NCBTYWx0ZWRfX9pl7NyJQIAWs
 Y8u6AIRFWucxiZWFxh/p1ld8bleJbOeIGDz8QPRl6MjyeUYMjeNwiKB4daOxcgowKxNv3lEPsqg
 ZSMEbwSuVTpINon7PyFMTqHFSR7+Fks=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA1NCBTYWx0ZWRfX9eiyYjTXypuE
 rIm5MuynyfdC29uPIFLRvoKt0SGGaluXb2YsFWgPAoF+ujsoQ7EdP7fp2v+0vfhHvzZVgjXhqFC
 RExdlNiQ3vZ0ULyCsb3wNz4UIdoL5hx/UThzGxE9glwqUnM0ekXNJIKE6AuBVZL13Xuui9b1uLF
 Y4KPrhcOpyRq0Z+n6Jp7VV2f8A4sLg5gAf0O5cWl2/uI8v3D1zQqxgc5ADBBOlmapRD7enEM6Os
 riPPDNHTtrBbmeKejJiHP5jlK7kT7mkdkkaK0POFIjCPrS92HTkNhcNm/SXm2vQi0TVR+a4OcUE
 gDspnJXdVp7BlbsuRsR+9aHjSNrekObc1slak4deyTWkOZzZPgEt849zvf+dyNj0Dlm5HfP/No1
 JDjTrKcb/dK+avJ5W9emMSvUwSGcP+hpZBbp6FLt0wqtrArWtWejjo1tjm/XBlLKjHL78r4SbEu
 W+lD28PeIPkOYVUjHbg==
X-Proofpoint-ORIG-GUID: EaHhtNhbKhYLwCACkzXhTXpR5SxvYtpf
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6ad772e7 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=6t2IyP89yvAV8c14NKoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200054



On 20/10/26 4:40 pm, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] net/smc: race in smc_lgr_schedule_free_work() can arm free_work before kfree
> - [High] net/smc: missing release barrier on client SMC_INIT to SMC_CLOSED transition
> --
> 
> commit ac5d5191510569377b3ad3881fe61cfb7d941a9d
> Author: Mahanta Jambigi <mjambigi@linux.ibm.com>
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This commit addresses several races between SMC socket/link group teardown
> and concurrent sock_diag readers by adjusting sk_state ordering, unhashing
> sockets earlier in teardown paths, skipping extended diag attributes in
> SMC_INIT/SMC_CLOSED, and unconditionally unregistering connections in
> smc_conn_free().
> 
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 9974149659c2f..9d8165d1b40c5 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -84,7 +84,7 @@ static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
>>  	 * creation. For client use a somewhat higher removal delay time,
>>  	 * otherwise there is a risk of out-of-sync link groups.
>>  	 */
>> -	if (!lgr->freeing) {
>> +	if (!lgr->freeing && !lgr->terminating) {
>>  		mod_delayed_work(system_percpu_wq, &lgr->free_work,
>>  				 (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
>>  						SMC_LGR_FREE_DELAY_CLNT :
>> @@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
>>  		if (current_work() != &conn->abort_work)
>>  			cancel_work_sync(&conn->abort_work);
>>  	}
>> -	if (!list_empty(&lgr->list)) {
>> +	if (!list_empty(&lgr->list))
>>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
>> -		smc_lgr_unregister_conn(conn);
>> -	}
>> +	smc_lgr_unregister_conn(conn);
>>  
>>  	if (!lgr->conns_num)
>>  		smc_lgr_schedule_free_work(lgr);
> 
> [Severity: Critical]
> Can smc_lgr_schedule_free_work() still race with __smc_lgr_terminate() and
> re-arm lgr->free_work right before lgr is freed?
> 
> In smc_lgr_cleanup_early(), the link group is unlinked from lgr->list while
> both lgr->freeing and lgr->terminating are still 0, and then
> __smc_lgr_terminate() cancels free_work before setting lgr->terminating:
> 
> net/smc/smc_core.c:__smc_lgr_terminate() {
> 	if (lgr->terminating)
> 		return;	/* lgr already terminating */
> 	/* cancel free_work sync, will terminate when lgr->freeing is set */
> 	cancel_delayed_work(&lgr->free_work);
> 	lgr->terminating = 1;
> 	...
> }
> 
> Because smc_conn_free() now calls smc_lgr_unregister_conn(conn)
> unconditionally and invokes smc_lgr_schedule_free_work(lgr) outside
> lgr->conns_lock, can the following interleaving occur when another
> connection on the same link group is concurrently freed?
> 
> CPU0 (smc_conn_free)                   CPU1 (smc_lgr_cleanup_early)
> --------------------                   ----------------------------
> smc_lgr_unregister_conn(conn)
>   lgr->conns_num becomes 0
> smc_lgr_schedule_free_work(lgr)
>   sees !lgr->freeing &&
>        !lgr->terminating
>                                        __smc_lgr_terminate(lgr, true)
>                                          cancel_delayed_work(&lgr->free_work)
>                                          lgr->terminating = 1
>                                          ...
>                                          smc_lgr_free(lgr)
>                                            smc_lgr_put(lgr)
>   mod_delayed_work(..., &lgr->free_work, ...)
> smc_lgr_put(lgr)
>   __smc_lgr_free(lgr)
>     kfree(lgr)
> 
> If that happens, wouldn't lgr be freed via kfree(lgr) while lgr->free_work
> remains queued in system_percpu_wq?

The interleaving is theoretically possible but *pre-existing* and not
widened by this patch. It requires a first-contact connection A to fail
and take the smc_lgr_cleanup_early() path, a second connection B to have
joined the same lgr after smc_server_lgr_pending was dropped, and B's
smc_conn_free() to bring conns_num to 0 within a few instructions of A's
__smc_lgr_terminate() cancelling free_work, with A's teardown completing
before B's final smc_lgr_put().

The unlocked "!lgr->freeing" check followed by mod_delayed_work() in
smc_lgr_schedule_free_work() has the same non-atomic window against
smc_lgr_terminate_sched() and __smc_lgr_terminate() in the baseline. The
"!lgr->terminating" check added here only avoids re-arming once
terminating is already visible, so it keeps the window no larger than
before. Closing it fully requires reworking how free_work scheduling is
serialized against lgr termination (check and arm under lgr_lock, or
cancelling free_work in __smc_lgr_free()). That is a separate lgr
lifetime fix, out of scope for this diag reader race patch.

> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..36a3b8f31f28d 100644
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
>>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>>  	else
>>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> 
> [Severity: High]
> Should this condition also exclude r->diag_state == SMC_CLOSED, or should
> smc_close_active() use smp_store_release() when transitioning from SMC_INIT
> to SMC_CLOSED?
> 
> On the client side, if smc_connect_rdma() or smc_connect_ism() fails after
> smc_conn_create() and jumps to connect_abort, smc_conn_abort() calls
> smc_conn_free() and smc_lgr_cleanup_early(), which clears
> conn->alert_token_local and frees conn->lgr while leaving conn->lgr non-NULL.
> 
> If fallback is not possible in smc_connect_decline_fallback() (or fails in
> smc_connect_fallback()), smc->use_fallback remains false and sk->sk_state
> remains SMC_INIT.
> 
> When the socket is then closed via smc_release() -> __smc_release() ->
> smc_close_active(), sk->sk_state is set to SMC_CLOSED with a plain store
> while the socket is still hashed:
> 
> net/smc/smc_close.c:smc_close_active() {
> 	...
> 	switch (sk->sk_state) {
> 	case SMC_INIT:
> 		sk->sk_state = SMC_CLOSED;
> 		break;
> 	...
> }
> 
> On weakly ordered CPUs, if a concurrent reader in __smc_diag_dump() observes
> r->diag_state == SMC_CLOSED from that plain store, there is no release
> barrier ordering the earlier conn->alert_token_local = 0 store before the
> sk_state transition, and the diag_mode check here only filters out SMC_INIT
> (unlike the SMC_INIT || SMC_CLOSED check further down). Could
> __smc_diag_dump() then see a stale non-zero alert_token_local and
> dereference the freed smc->conn.lgr->is_smcd?


On this path alert_token_local is cleared in the connect syscall, under
conns_lock with the socket lock held. The SMC_INIT -> SMC_CLOSED store
only happens later in close() -> smc_close_active() under lock_sock().
The lock_sock()/release_sock() handoff and the conns_lock write_unlock
between the two order the clear before the sk_state store, so a reader
that sees SMC_CLOSED *cannot* see a stale non-zero alert_token_local.


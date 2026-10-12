Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997738E8BF;
	Mon, 12 Oct 2026 07:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789640; cv=none; b=XZzsEjh6skTwn0wAcERO/x0Y/jlpTl7pHonKX8AgJKb5uvZzNObhfA7XGNVbT4gEMChdc2sOk06M9gcOc0nWrMgKzOqBbc/NI1ZkqEtURO6YddbveZXLwQxkx3RWRnBEhvlWh1QmIgld/KYAK/AJqEqB4G82xwzJOi+KLBSDn/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789640; c=relaxed/simple;
	bh=n844ZyaS4YpiO5izZUnF/FIWOXwBnrwDkyFiS4o7uWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I2qyEixCu/1ORrAasP6VuurBmnmHp6QbmhoDnpScRClFNqLTldHXcZiCnHewmeRIzD+kjbOS4iHpBDYb8Ns2Fd8UvL2C0zhJoacej7C5Xo9XEKH+9aUziDmAgR9aP9I5PrU8pfMfUKmh80Dpcs8B/Gbbdkh92UC9DzgdypTGy/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j6+zj/Cz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j6+zj/Cz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C5EaMs1693986;
	Mon, 12 Oct 2026 07:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MgJI74
	Pk36jF22qxBKv9HC9+3jutB5SJ1cW4ut9VIa4=; b=j6+zj/CzZmDU3VTEeGeUvr
	4szztnHQdQfhwdpR6NJHrsTO3sQIpFQYnRgn/l+zFq8pQlDMn+td2Xvigd3OZlwQ
	as+fJvU/j2KgL8bDClJhHDOlKeDjNBcNFd9e1gKb4MRAZNy0SZPB85yKOaVrHgUl
	aXAmwRAjyL+j6/u4upRPA27YCQfO4zTWbBuuJXKQNjZ51zPc/RjN8jie7Hjlp8A9
	gwrPHvvmYLSl7Zrfqz9aTkcj4hr+ZlkayVta6teCKaqkVQE4HbTQnXpg1lf6xZy/
	x3F/Y0bqi90eOyIfhdkY1yhVxOt1Y20dKsurviQp/WSyK75MnkZpqA4iLlXQl36A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwh7p3d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 07:20:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69C553h13726533;
	Mon, 12 Oct 2026 07:20:31 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h81wfuyse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 07:20:31 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69C7KTNh5506006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 07:20:29 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B9C558056;
	Mon, 12 Oct 2026 07:20:29 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44C9458052;
	Mon, 12 Oct 2026 07:20:23 +0000 (GMT)
Received: from [9.124.213.153] (unknown [9.124.213.153])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 12 Oct 2026 07:20:22 +0000 (GMT)
Message-ID: <9036c71f-d7bc-468d-9c1e-f527dd01d737@linux.ibm.com>
Date: Mon, 12 Oct 2026 12:50:21 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
 <179147599850.434549.17282557208373125996@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179147599850.434549.17282557208373125996@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyOCBTYWx0ZWRfX6P9iW+C5yVH8
 NCzC7myMngbLZxeW4U8yT3t69fM6lfGe0y7tH7XNSCDPXfUk2LPwwdN6KRDgXUfgrEYT4LTwvzO
 jO42m+YewtTXuQtOfAg4X5PfP3/RuBY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyOCBTYWx0ZWRfXyPrBDay2OO+K
 Xw9u73U6U2d/irpGh8z4HckpcGwBTx8KQNNgh7vKQJiFHC1TLAnmLpPmZwGZkdmv3mojI50IfcB
 Bo+Gy+0agK6TEKWQoVRykMY3jf/Jt2NW99yEDzyQijuuvQipxTJnNlBW3RtsmplFSi92TzDn1pV
 jUgKLO2Z+yono20rHnUDq8beWcdYCkb1w8mY6mOtB66acIeNhDdqgA3PGZVLrh9zuzqf+IW3WM3
 THcZLPv+9lhlJ38A7oag7iLl3UyWq7OhcysZm3rU0J7epf258qj2R09uvdMe25ORsbE6Jwsufdj
 qZhF6S9kGVekp1bm7DtIMa6ZA/dI8DIE3u+BNZxcxC5y3awLMY7I/aw+NZdIv4rR4ptyvibjPJR
 PYwDET8dR8+gSmsWusKgCz92sO98TF5Ny2zKtCkmpMF2PxOvn3Sw3cKbQ0rp55Sr7msaqn0SV+p
 gmcO3s6GmTVXZ/yJYew==
X-Proofpoint-GUID: wZREcjX9KqX3QFtrxJZtN1PU4YBJbUBP
X-Authority-Analysis: v=2.4 cv=RoFQvymK c=1 sm=1 tr=0 ts=6acc8a40 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=3WnsXf8fg-JtRXj8Nn8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rHEgMzF8En5yQX1NGbUPpRVI2OWLcp1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120028



On 08/10/26 9:43 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The commit message says the conn/lgr/lnk blocks of
>   __smc_diag_dump() are guarded for SMC_INIT and SMC_CLOSED sockets.
> - [Low] In __smc_diag_dump() (net/smc/smc_diag.c:93-97) the new
>   `r->diag_state != SMC_INIT &&` check in the diag_mode selection sends…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> The patch closes races between the SMC diag dump and connection teardown.
> It skips the conn/lgr/lnk attribute blocks for SMC_INIT and SMC_CLOSED
> sockets, and pairs smp_load_acquire()/smp_store_release() on sk_state. It
> also unhashes the socket before smc_conn_free() or smcd_buf_detach() in
> several teardown paths, and copies the cached link->ibname.
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
> [Severity: Low]
> Is this change to diag_mode intended? With the new r->diag_state !=
> SMC_INIT check, every non-fallback SMC_INIT socket falls into the else
> branch and is reported as SMC_DIAG_MODE_SMCR.
> 
> Before this patch, an SMC_INIT socket with a registered SMC-D link group
> was reported as SMC_DIAG_MODE_SMCD.
> 
> On the client side, this window runs from smc_conn_create() in
> smc_connect_ism() until the smp_store_release() to SMC_ACTIVE. On the
> server side it lasts until smc_listen_out_connected(), which includes
> waiting for the peer's CLC CONFIRM. During that time, sock_diag users see
> an SMC-D connection labelled as SMC-R. The "Mode of a connection" enum in
> include/uapi/linux/smc_diag.h has no "unknown" value for this case.
> 
> The commit message says:
> 
>   "Guard the conn/lgr/lnk blocks in __smc_diag_dump() for SMC_INIT and
>    SMC_CLOSED sockets; smcss already suppresses these attributes for
>    closed/unconnected sockets so there is no observability regression."
> 
> It doesn't mention the diag_mode change, which only appears in the v6
> changelog below the --- line.
> 
> Could the transport type be recorded in a field of struct smc_sock when
> the lgr is assigned? That would avoid both the lgr dereference and the
> wrong mode.

You are right that v8 deterministically misreports the diag_mode for
this narrow window. However the practical impact on smcss users is none:
smcss already jumps to newline at diag_state == SMC_INIT, before
printing the mode string, and without --all those sockets are filtered
out entirely before the mode filter is evaluated. The misreported mode
field is never rendered.

I am leaving the diag_mode logic unchanged in v9; if a future change
adds a cached transport type field to struct smc_sock the diag path can
be simplified at that point.

> 
> [ ... ]
> 
>> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>> +		goto out;
>> +
> 
> [Severity: Medium]
> The commit message says the conn/lgr/lnk blocks are guarded for both
> SMC_INIT and SMC_CLOSED. The diag_mode selection above excludes only
> SMC_INIT, and it runs before this early exit.
> 
> For an SMC_CLOSED socket, can __smc_diag_dump() still call
> smc_conn_lgr_valid() and then dereference smc->conn.lgr->is_smcd?
> 
> In the server handshake error path, a CLOSED socket stays hashed after
> its conn has been freed:
> 
> smc_listen_decline()
>   smc_conn_abort()
>     smc_conn_free()
>       smc_lgr_unregister_conn()
>         write_lock_bh(&lgr->conns_lock);
>         __smc_lgr_unregister_conn()
>           conn->alert_token_local = 0;
>         write_unlock_bh(&lgr->conns_lock);
>       smcr_link_put(conn->lnk);
>       smc_lgr_put(lgr);          <-- conn->lgr is left set
>   smc_listen_out_err()
>     newsmcsk->sk_state = SMC_CLOSED;
> 
> The SMC_CLOSED store in smc_listen_out_err() is a plain store, not the
> smp_store_release() this patch adds for SMC_ACTIVE.
> 
> Between the alert_token_local reset and the CLOSED store, the only
> operations are release-ordered ones: write_unlock_bh(),
> refcount_dec_and_test() via smcr_link_put()/smc_lgr_put(), and
> sock_put(). None of them orders the later CLOSED store.
> 
> On a weakly ordered CPU such as arm64, could the reader's
> smp_load_acquire() see SMC_CLOSED while alert_token_local still reads as
> non-zero? The reader would then dereference an lgr that the connection no
> longer holds a reference to. If link-group freeing runs concurrently,
> that read is a use-after-free.
> 
> This needs a non-local-first lgr with a negative reason code, so that
> smc_lgr_cleanup_early() is not called. The window is narrow.
> 
> Would it help to exclude SMC_CLOSED from the diag_mode condition as well,
> or to move this early exit ahead of the diag_mode selection? Publishing
> SMC_CLOSED in smc_listen_out_err() with smp_store_release() would also
> close the gap.

Correct. Fixed in v9 by changing the plain store in smc_listen_out_err()
to smp_store_release(&newsmcsk->sk_state, SMC_CLOSED). This orders the
alert_token_local clear (performed under write_lock_bh() inside
smc_conn_free()) before the sk_state write, so a reader whose
smp_load_acquire() sees SMC_CLOSED is guaranteed to also see
alert_token_local == 0 and take the early-exit goto out.

The other sk_state = SMC_CLOSED stores in the close state machine do not
need the same treatment: in smc_close_active_abort() and
smc_close_passive_work() the state is set to SMC_CLOSED before
smc_conn_free() is called, so a reader seeing SMC_CLOSED exits early
before smc_conn_free() has run and there is nothing to race against.

pw-bot: cr

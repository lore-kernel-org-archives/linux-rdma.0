Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608837;
	b=4Tm1ZJU/OAQPt1jC4LecV10Yi4x0X14w+1BXvYeeTeN0oxToUOgbSAu0LGWokvmG1X3Y
	 pTTeT05cCcCM/nHJUi+PT7nGy8vCWVNmelEqzmM1cJsVaM4clCg9eJ5o3CyemD5UFTKS5
	 NXJ/gEUaYeCw8fU2U8dE+l34w8kn4NEZy8/ESR2ZZIRkYaiEeBUnXPvuHNd7ObjkpKI4g
	 AhHeVpMwXTz6Ff75cUbB2m2cuJOwnc+BYdWkP6AXmaI4NZOl/7J+AEnB5J5mth9wqo60c
	 d9iP6ZKeXECt5ndEHL2Wv+cyWa9IFhTErI5JsiqBk3odd3GDe04S9bXVd2mKCwPjGEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608837;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=G7oo4xs/PNsCQScDs4B65fSByPv2XnfwRej1B2C25x0=;
	b=iBgYx/Pl7zHpDFR3vSC0FfllADiaZMPth5gMClx27VyKEZb+ow6TEFjWlWpjaRZDthpy
	 q9fDBJ/acuAd5bVKKuYGpAIy3ixBfIefkqODs+NXuIT5afjtX+DBwEwYruZ3rAb0JNJoo
	 q8ZArkBsRDe0hZ5nDiWvqd/N3hZRFzFB6CyC1cC+f4Nt64ZkzUmEnmEDCGtMohYGJIiPx
	 mVA5AbMrhPUM+KvfIxdhQJz+Subh0OoGzNaANS3I95D/4YRrIJA/bKSZ4MDTAxby7AKgl
	 vrtqyYr22aMuHR6HX7SazfuQpKT/pUKZzPYlPvV4lMdprOyfxGtISZ0ZCeY/wHFtGPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tm+vc7DH;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76445606A324;
	Mon,  2 Nov 2026 08:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76445606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tm+vc7DH
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A24EAmZ1880677;
	Mon, 2 Nov 2026 08:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G7oo4x
	s/PNsCQScDs4B65fSByPv2XnfwRej1B2C25x0=; b=tm+vc7DHk8mrh9Ed548PtA
	f+2greY0E9S1+/7tGoHHD3mnUguqVwAPCdPHr89NvyYkW41eBmuFktelrBL1X0KX
	SQWAMV9eoIEiu9LY/wcYo0NOTIQvSoujADGnpDiNmyNj0EKOa4gom14U74Kr9p9Z
	2usY38dwbTAtRcrU5uFqBcRG7VxXV8DnPUH/g8aZKpcnDD5edNalRXXjWqCbEkG0
	pew/PGMjFWBdPHQTDz3TgFQCCT4o+US0EBWvqfYhFCxec0D5MgTUvYVS54+ojjzU
	xr+sOEcflDx84aZwtKyvmHio9o4ekUSpOjz05N991e+DAyCm45m/xqTQ5p6DxhPQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn826fh4c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 08:40:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A24JoG7376338;
	Mon, 2 Nov 2026 08:40:16 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hnu1vd22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 08:40:16 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A28eFQW27984452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 08:40:15 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BDE158050;
	Mon,  2 Nov 2026 08:40:15 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9C5F58045;
	Mon,  2 Nov 2026 08:40:08 +0000 (GMT)
Received: from [9.39.26.45] (unknown [9.39.26.45])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 08:40:08 +0000 (GMT)
Message-ID: <d6334191-8f5d-4096-87f6-2fe3878990e2@linux.ibm.com>
Date: Mon, 2 Nov 2026 14:10:06 +0530
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
Subject: Re: [PATCH net v14] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
 <179351735189.3131.9219259330792018704@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179351735189.3131.9219259330792018704@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -aImblFV0Dy_5wtvNX0pPH3GB9ibJsCd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzMiBTYWx0ZWRfXzJN6CguetKGw
 zy2nmN/S1DtgeALz5ZOuSZ2cvxwVXXEZf2U8TqjM0Px3xwhI+Dw1ZWDDTZSMsjttKf9l9dSvkmo
 8Tr7KKeR+v56f6BeYFLVpBHtdamGoAlhTHlNVZhrW5KMidN78J0bRx0PbN/Zft8Rzu2QLP9Z7dq
 H+gfr2OZ6I57ye/mzUQLiTxEmWDzRp2RM/cSB3XCpxS2ix0867Syau6CUkQuK7GJPSDkueqbOzO
 +/X78ykrkl9bToCeaAJ1QPT84Ta3m6gZv7IcGRzaYGOr5Vz7nPHJ9BtYz9ijLJuc5eGsw2HKFCh
 Hxv6eXC06FzaamsJxqddOE8olhk2jlY8T5f0hBmA93lAIYvBC5LDBDCIPhQ7ttGrVr8F28RwKNK
 nn6pbYiD4O2AtshFG0phO40K2gbWsTSCKq2W46EeM20WIsldosQ0FCce6yVwp2rqVYzogpVmn2j
 OSwsMswHuBu2DLZ0zLA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzMiBTYWx0ZWRfXxxZV9uHts+6B
 cY1FUwvjInDjBQo1OviupDyXdj/fFXoViy80pWJVjyurNyu/B1Zd3sO7bgtAxs1LiKfYjRAXuHD
 ivheJSEkLPcLRwHroUKmZMt6nfM8lBg=
X-Proofpoint-GUID: OEgU_XljqcW9VIHtPx6qtiSlDjltleJ2
X-Authority-Analysis: v=2.4 cv=EsJHPicA c=1 sm=1 tr=0 ts=6ae84c72 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=y1wDWJwAWSAM7wl4Mt0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020032



On 01/11/26 12:45 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 1 (2) · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix is incomplete.
> - [Medium] After this patch, __smc_diag_dump() (net/smc/smc_diag.c)
>   reports SMC_DIAG_MODE_SMCR for every non-fallback socket in SMC_INIT…
> - [Low] The commit message's 'Fourth' item says the
>   smp_store_release(&newsmcsk->sk_state, SMC_CLOSED) in…
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_conn_free() (net/smc/smc_core.c:1281-1282) calls…
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_diag_handler_dump() (net/smc/smc_diag.c) never checks that the…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch tries to close races between the SMC sock_diag dump and the
> teardown of conn/lgr/lnk state. __smc_diag_dump() now skips the extension
> attributes and the lgr based diag_mode test for sockets in SMC_INIT,
> SMC_CLOSED or fallback, and several teardown paths unhash the socket
> before smc_conn_free() or smcd_buf_detach(). It also adds acquire/release
> ordering on sk_state and copies the cached link->ibname.
> 
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index d10244af5bd29..ec5980add7a9d 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
> 
> [ ... ]
> 
>> @@ -1971,7 +1971,7 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
>>  	this_cpu_inc(net->smc.smc_stats->srv_hshake_err_cnt);
>>  	if (newsmcsk->sk_state == SMC_INIT)
>>  		sock_put(&new_smc->sk); /* passive closing */
>> -	newsmcsk->sk_state = SMC_CLOSED;
>> +	smp_store_release(&newsmcsk->sk_state, SMC_CLOSED);
> 
> [Severity: Low]
> 
> The commit message says:
> 
>   Fourth, smc_listen_out_err() sets sk_state = SMC_CLOSED with a plain
>   store after smc_conn_abort() -> smc_conn_free() has already cleared
>   alert_token_local under write_lock_bh(). On weakly ordered CPUs a
>   concurrent diag reader using smp_load_acquire() on sk_state can observe
>   SMC_CLOSED while the preceding store to alert_token_local has not yet
>   become visible, causing it to dereference an lgr whose reference was
>   already dropped.
> 
> Is this still accurate with the current __smc_diag_dump()?
> 
> A reader that sees SMC_CLOSED now skips the conn->lgr dereference in the
> diag_mode test, and the new goto out skips the extension blocks.
> 
> Before this store the state is SMC_INIT. smc_listen_work() holds the
> socket lock until smc_listen_out(), so close_work can't change it in
> between, and SMC_INIT is skipped the same way.
> 
> So whichever value the reader sees, it never reads alert_token_local or
> conn->lgr, and the release ordering doesn't seem to protect anything the
> reader relies on. The commit message already says this for the
> stale-token case ("the SMC_CLOSED check in __smc_diag_dump() keeps the
> reader from dereferencing conn->lgr").
> 
> This reasoning seems to date from v9, before v14 added SMC_CLOSED to the
> diag_mode test. Could the fourth item be described as hardening, or
> dropped, so stable backporters don't treat the barrier as a required
> standalone fix?

Reworded as hardening: a reader that observes SMC_CLOSED skips the
connection fields in any case, so the smp_store_release() in
smc_listen_out_err() is uniformity with the SMC_ACTIVE transitions,
not a required ordering. Stable backporters should not treat it as a
standalone fix.

> 
>>  
>>  	smc_listen_out(new_smc);
>>  }
>> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
>> index a8d4b4b65f244..e26586114f802 100644
>> --- a/net/smc/smc_close.c
>> +++ b/net/smc/smc_close.c
> 
> [ ... ]
> 
>> @@ -437,6 +439,7 @@ static void smc_close_passive_work(struct work_struct *work)
>>  		sk->sk_state_change(sk);
>>  		if ((sk->sk_state == SMC_CLOSED) &&
>>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
>> +			sk->sk_prot->unhash(sk);
>>  			smc_conn_free(conn);
> 
> [Severity: Medium]
> 
> This is a pre-existing issue and wasn't introduced by this patch. Does
> smc_conn_free() leak the socket reference held by abort_work when it
> cancels a pending abort_work?

Yes its pre-existing & I will address this seperately.

> 
> smc_conn_free() in net/smc/smc_core.c does:
> 
> 	} else {
> 		smc_cdc_wait_pend_tx_wr(conn);
> 		if (current_work() != &conn->abort_work)
> 			cancel_work_sync(&conn->abort_work);
> 	}
> 
> and ignores the return value. The only code that schedules abort_work is
> smc_cdc_msg_validate(), and it hands a reference to the work:
> 
> 		sock_hold(&smc->sk); /* sock_put in abort_work */
> 		if (!queue_work(smc_close_wq, &conn->abort_work))
> 			sock_put(&smc->sk);
> 
> smc_conn_abort_work() drops that reference when it runs. Suppose
> abort_work is still pending when an SMC-R connection reaches
> smc_conn_free() from outside abort_work, for example via __smc_release().
> Then cancel_work_sync() returns true, nobody drops the reference, and the
> smc_sock is never freed.
> 
> smc_close_cancel_work() handles close_work the same way with:
> 
> 	if (cancel_work_sync(&smc->conn.close_work))
> 		sock_put(sk);
> 
> Should smc_conn_free() do the same for abort_work?
> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..7b4656d6560a6 100644
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
>> +	else if (r->diag_state != SMC_INIT && r->diag_state != SMC_CLOSED &&
>> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>>  	else
>>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> 
> [Severity: Medium]
> 
> With this change every non-fallback socket in SMC_INIT or SMC_CLOSED is
> reported as SMC_DIAG_MODE_SMCR. That includes SMC-D connections, which
> used to report SMC_DIAG_MODE_SMCD.
> 
> include/uapi/linux/smc_diag.h defines diag_mode as:
> 
> /* Mode of a connection */
> enum {
> 	SMC_DIAG_MODE_SMCR,
> 	SMC_DIAG_MODE_FALLBACK_TCP,
> 	SMC_DIAG_MODE_SMCD,
> };
> 
> It has no "unknown" value. Is it intended that an SMC-D connection is
> reported as SMC-R here?
> 
> Live SMC-D sockets can stay hashed in SMC_CLOSED with a valid lgr and
> alert_token_local. smc_close_passive_work() or
> smc_close_passive_abort_received() can move a socket to SMC_CLOSED while
> the fd is still open. smc_close_passive_work() only unhashes and frees
> when:
> 
> 		if ((sk->sk_state == SMC_CLOSED) &&
> 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> 
> SMC-D sockets in SMC_INIT after smc_conn_create() are affected the same
> way. A tool that filters by mode (smcss -D / -R style) would put these
> sockets in the wrong group.
> 
> Could the race be avoided without misreporting? For example, is_smcd
> could be cached in the smc_sock, or SMC-D could be inferred from
> conn.lgr != NULL && conn.lnk == NULL, which only reads pointers and
> doesn't dereference the lgr.

Fixed as you suggested: the type is cached in conn->is_smcd at
smc_conn_create() time (struct smc_connection is embedded in the
smc_sock, so the lifetime is identical) and diag_mode is taken from
the cached flag. The conn->lgr dereference and the state condition
are gone from the diag_mode test, and SMC-D sockets in SMC_INIT and
SMC_CLOSED report SMC_DIAG_MODE_SMCD again.


> 
>>  	user_ns = sk_user_ns(NETLINK_CB(cb->skb).sk);
>>  	if (smc_diag_msg_attrs_fill(sk, skb, r, user_ns))
>>  		goto errout;
>> @@ -103,6 +104,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED ||
>> +	    smc->use_fallback)
>> +		goto out;
>> +
> 
> [Severity: High]
> 
> Can a socket whose connection was already released by smc_conn_abort()
> still move into a state this guard doesn't cover?
> 
> The guard only checks the sk_state snapshot. Take a client handshake
> that fails with a negative rc after smc_conn_create():
> 
> smc_connect_rdma()
>   connect_abort:
>     smc_conn_abort()
>       smc_conn_free()   /* sets conn->freed, drops lgr/lnk refs */
> 
> smc_connect_decline_fallback() returns early without changing the state,
> and smc_connect_work() only does:
> 
> 	rc = __smc_connect(smc);
> 	if (rc < 0)
> 		smc->sk.sk_err = -rc;
> 
> So the socket stays hashed in SMC_INIT with use_fallback == false.
> 
> Suppose smc_lgr_terminate_sched() had already emptied lgr->list, which
> is the stale-token case the changelog mentions. Then smc_conn_free()
> skips the unregister:
> 
> 	if (!list_empty(&lgr->list)) {
> 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> 		smc_lgr_unregister_conn(conn);
> 	}
> 
> alert_token_local stays non-zero and the conn stays in lgr->conns_all.
> 
> smc_cdc_rx_handler() doesn't check conn->freed:
> 
> 	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
> 	if (!conn || conn->out_of_sync) {
> 
> So a close or peer-abort CDC can still queue close_work. Once the
> handshake thread drops the socket lock, smc_close_passive_work() does:
> 
> 	case SMC_INIT:
> 		sk->sk_state = SMC_APPCLOSEWAIT1;
> 		break;
> 
> Or smc_close_passive_abort_received() moves SMC_INIT to
> SMC_PROCESSABORT. Both are plain stores, and neither path reaches the
> new unhash plus smc_conn_free() branch.
> 
> A diag reader under read_lock(&h->lock) would then see APPCLOSEWAIT1 or
> PROCESSABORT and pass both new checks. It would find
> smc_conn_lgr_valid() true, because conn->lgr is never cleared. It then
> dereferences smc->conn.lgr->is_smcd, conn->sndbuf_desc, conn->rmb_desc
> and lgr->list.
> 
> Meanwhile terminate_work runs
> __smc_lgr_terminate()->smc_conn_kill()->smc_close_active_abort(). Its
> ACTIVE/APPCLOSEWAIT branch goes to SMC_CLOSED without unhashing:
> 
> 	case SMC_ACTIVE:
> 	case SMC_APPCLOSEWAIT1:
> 	case SMC_APPCLOSEWAIT2:
> 		sk->sk_state = SMC_PEERABORTWAIT;
> 		smc_close_cancel_work(smc);
> 		if (sk->sk_state != SMC_PEERABORTWAIT)
> 			break;
> 		sk->sk_state = SMC_CLOSED;
> 		sock_put(sk); /* (postponed) passive closing */
> 
> So the hash write_lock is never taken before smc_lgr_free() drops the
> last lgr reference. Wouldn't the reader then be dereferencing a freed
> smc_link_group?
> 
> There is also a weaker variant, where the token is cleared normally and
> the lgr is freed synchronously via smc_lgr_cleanup_early(). Safety then
> depends on the token clear being visible to a reader that acquire-loads
> an sk_state written with a plain store. This is probably ordered in
> practice through lock_sock()/release_sock(), but the patch doesn't
> establish it.
> 
> Separately, after a failed handshake the same SMC_INIT to
> SMC_APPCLOSEWAIT1 transition later runs the "postponed passive closing"
> sock_put() in smc_close_active() or smc_close_active_abort(). But
> smc_connect_decline_fallback() has already dropped that reference.

Fixed by returning early from smc_close_passive_work() when
conn->freed is set. I kept your conn->freed check, but at execution
time instead of in smc_cdc_rx_handler(): a queue-time check cannot
cover a close_work that was queued before the abort, and the CDC
receive path runs under bh_lock_sock(), which does not exclude the
handshake thread's lock_sock(), so check-then-queue would be racy
anyway. At execution time the check holds the socket lock that every
smc_conn_free() caller holds as well, so it is serialized against all
free sites. A hashed socket with a freed connection now stays in
SMC_INIT or SMC_CLOSED until release, which is exactly what the filter
covers; the only states reachable after a normal token clear are
therefore guarded ones, so the reader relies on no ordering of the
clear. This also fixes the double passive-closing sock_put() you
noted (Fixes: 46c28dbd4c23, 2a0674fffb6b).

> 
> Would one of these work better?
> 
> - unhash a socket whose conn was freed by smc_conn_abort(), or
>   otherwise hide it from diag
> - cancel close_work, or check conn->freed in smc_cdc_rx_handler() and
>   in the diag reader
> - pin the lgr for as long as stale conn state is visible
> 
>>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>  	    smc->conn.alert_token_local) {
> 
> [Severity: Medium]
> 
> This is a pre-existing issue and wasn't introduced by this patch. Is
> req->diag_ext guaranteed to be inside the request payload here?

Yes its pre-existing & I will address this seperately.

pw-bot: cr

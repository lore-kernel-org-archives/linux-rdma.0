Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD24CE672;
	Thu, 15 Oct 2026 08:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052430; cv=none; b=PofK3EhEeTBm0ss2ZUUuzIJFFdAWDdNsFQRp2M4nGATSa0DFiJBirX2XK4NG7eOPOXgGLU5Q+zl59THDJWcwNTW6fVbn3Kf86yfTPaqr+XnKcxicZ7zZBAHN42vEdg1X6JJfVHNltHbEEJHdICmSda+cOOSw1nPWegOkw0VfgXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052430; c=relaxed/simple;
	bh=uXlFsfNLwGdbvGXybclKNSQdbosMmmVjh9AjcIt2rzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/OQG36uK3n5rVeXSxbZ7bon1RmVdRAb7zn2L1vT+71f3OJ2dQsqxhoRaciTOgwRVvSx89L2DaFntUuX7aiKTWrYvtf2uOOcJgv4W/zcoKyggy9E+YzdyzR00/HVN0AQ4gMGc5tboOTd6/dLtWkW0PaKPZXJARKBEDowTsARDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gXYK/i6/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gXYK/i6/"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F3iSaY695159;
	Thu, 15 Oct 2026 08:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+mBS6m
	voR4Dd817pb3KFl204cwegs+NsduzLMgbPsjc=; b=gXYK/i6/Y4+vHgpPBTKHi8
	Wv7YSRs8PfPM+HnMWtZzMby8pYkPAoGucDyouZLQU0+2qxY1gmp9td/iIyZpqfgG
	ylknM+MXKuzTC/+eTJXcenFSCElyGMVW7z+T07jRw6z8ENmnk5OjD5DGtzks+WBD
	f372aa2DyNaX/0xMM0Dp6BP8vtX2M6QhhFVPmvWxv9TCu/LXphZhKWCbWcYyg4uu
	VjJ5XhfULFXr7jh6JLIFnPaG5IMaY404c50tcdcxeIcIfXpF9n1D9i7XpynUQQbu
	MQ3b5QaH5rvfDvADNbQOboO/GKZB6W6RNfMd7ANlKbnl9m50PYI4ytpfaMJ94ZTw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhrwj0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 08:20:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69F5Ftnx669905;
	Thu, 15 Oct 2026 08:20:16 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h9ypq6100-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 08:20:16 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69F8KFFb29491910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 08:20:15 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 312F858054;
	Thu, 15 Oct 2026 08:20:15 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 266985803F;
	Thu, 15 Oct 2026 08:20:09 +0000 (GMT)
Received: from [9.123.14.182] (unknown [9.123.14.182])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Oct 2026 08:20:08 +0000 (GMT)
Message-ID: <94382105-bba7-431d-bf0b-9c1673f946ff@linux.ibm.com>
Date: Thu, 15 Oct 2026 13:50:07 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v10] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
 <179198739873.434549.14480502288349527609@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179198739873.434549.14480502288349527609@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAzMiBTYWx0ZWRfX5UHqTAdR9ZGF
 pLgAhF/jSsdc1gKn5B44kMdwy35KP83l2mNXY6COq8VIHRXtEQtsZDkgK40UXa9yvBkP/0dSwNb
 +JroIyIsQvZl4iL6lLkgn+hMvhGktbw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAzMiBTYWx0ZWRfX7sL7OXN8oUM2
 e4UnfhY1Heu/NgOXIcEW3vLZV33L/rXl/oXr/9qzhEFy/3wteQs2TsXq4QcV+PqQ57/N7r4S1Tl
 G4Hic+OhGi+22tta8aT73LIHcDwYoDr5e0PIBisd3tHTklD7wad2ZhlhCJJ4CX3P70uybMbDXsM
 9PHk3wj3XTZz4cIjVy0p0co3jyYwNCCJh1odoy06yy1ZHXaT207lf6/1hmAw6l2ic181apUN5rz
 cDQSa6fFzeNuLTZZEVHEuA39qcp0tiJAHNTITVnrCHPOTPJ01Ah0O+9jOfAwnunaFaVL3IF+E8X
 zeEY+P7IfqUsFeQgPv0lFTlB7aR14QoCiZsGaJ1Sfy+gOv4mj9ujj4AJrx5rUJRJAmHHvxQlc8P
 T6TkNeQ6lnil4yQFEB/uLmFP4PWpYqzgONDX7M8J3vbVnJl4DoSFCre1ToDm5u+RM3XO1WHvmc1
 W7DaQNyZlu0M9rxpQVg==
X-Proofpoint-GUID: 3BWusatf8QXlhui44fy9HSEXCYFBPniv
X-Authority-Analysis: v=2.4 cv=RoFQvymK c=1 sm=1 tr=0 ts=6ad08cc4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=K5ce6bKmJZ4Fwuhyun0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: u04HDrRi4Tl8-4vBP4vhtE2vjA_Lw1_v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150032



On 14/10/26 7:46 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 (1) · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix still leaves a use-after-free between the diag reader
>   and the lgr.
> - [Medium] Switching to link->ibname removes the NULL dereference through
>   link->smcibdev->ibdev.
> - [Low] SMC_DIAG_LGRINFO now reports link->ibname, which
>   smcr_copy_dev_info_to_link() (smc_core.c:783-784) caches at link…
> 
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the teardown
>   sites it touches have a deadlock.
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch tries to close races between the SMC sock_diag dump and the
> teardown of conn/lgr/lnk state. It skips the extension attributes for
> sockets in SMC_INIT or SMC_CLOSED and orders sk_state with acquire/release.
> It also unhashes the socket before several smc_conn_free() and
> smcd_buf_detach() calls, and uses the cached link->ibname in the LGRINFO
> dump.
> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
>> index bb0313ef5f7c1..aa6363abdd747 100644
>> --- a/net/smc/smc_close.c
>> +++ b/net/smc/smc_close.c
> 
> [ ... ]
> 
>> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>>  		sk->sk_state_change(sk);
>>  		if ((sk->sk_state == SMC_CLOSED) &&
>>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
>> +			sk->sk_prot->unhash(sk);
>>  			smc_conn_free(conn);
> 
> [Severity: High]
> This is a pre-existing issue and was not introduced by this patch. Can this
> smc_conn_free() call deadlock against abort_work?

I agree with your analysis regarding the lock inversion between
lock_sock(&smc->sk) and cancel_work_sync(&conn->abort_work). As this is
a pre-existing issue in the SMC core connection teardown flow, I will
submit a separate, dedicated patch to fix this deadlock so as to keep
this diag race series focused.

> 
> smc_close_passive_work() holds lock_sock(sk) here. For SMC-R,
> smc_conn_free() then does:
> 
> 		if (current_work() != &conn->abort_work)
> 			cancel_work_sync(&conn->abort_work);
> 
> The connection is still registered at this point. A CDC message with
> failover_validation and a seqno ahead can make smc_cdc_msg_validate()
> queue abort_work on smc_close_wq, and it does this without the socket lock.
> smc_close_wq can run that work alongside close_work, and
> smc_conn_abort_work() starts with:
> 
> 	lock_sock(&smc->sk);
> 	smc_conn_kill(conn, true);
> 
> If abort_work is already running and blocked in lock_sock(), would this
> thread wait forever in cancel_work_sync() while it holds that same socket
> lock? The current_work() check only stops abort_work from cancelling
> itself.
> 
> smc_close_active_abort() also reaches smc_conn_free() with the socket lock
> held.
> 
>>  			if (smc->clcsock)
>>  				release_clcsock = true;
> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..36a3b8f31f28d 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
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
>>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>  	    smc->conn.alert_token_local) {
>>  		struct smc_connection *conn = &smc->conn;
> 
> [Severity: High]
> Does this guard miss a fallback socket in SMC_ACTIVE that still has a stale
> alert_token_local after its lgr reference was dropped?

Fixed in v11. I updated smc_conn_free() in smc_core.c to call
smc_lgr_unregister_conn(conn) unconditionally rather than gating it on
!list_empty(&lgr->list). This ensures alert_token_local is always
cleared to 0 when the connection is freed, preventing the diag reader
from entering CONNINFO/LGRINFO/DMBINFO blocks on fallback sockets in
SMC_ACTIVE. Added Fixes: 2a0674fffb6b.

> 
> On the server side, the peer can answer with a CLC DECLINE that has the
> first contact bit set instead of a CONFIRM. smc_clc_wait_msg() then does:
> 
> net/smc/smc_clc.c:smc_clc_wait_msg() {
>     ...
> 		if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
> 		    smc->conn.lgr) {
> 			smc->conn.lgr->sync_err = 1;
> 			smc_lgr_terminate_sched(smc->conn.lgr);
> 		}
>     ...
> }
> 
> smc_lgr_terminate_sched() calls list_del_init(&lgr->list).
> 
> The handshake then aborts through
> smc_listen_decline()->smc_conn_abort()->smc_conn_free(). At that point
> lgr->list is empty:
> 
> 	if (!list_empty(&lgr->list)) {
> 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> 		smc_lgr_unregister_conn(conn);
> 	}
> 
> So the connection is not unregistered and alert_token_local stays
> non-zero, but smc_lgr_put() still drops the lgr reference. The socket then
> falls back, smc_listen_out_connected() stores SMC_ACTIVE, and the socket
> stays hashed.
> 
> Later, terminate_work runs __smc_lgr_terminate():
> 
> 		lock_sock(&smc->sk);
> 		smc_conn_kill(conn, soft);
> 		release_sock(&smc->sk);
> 	...
> 	smc_lgr_cleanup(lgr);
> 	smc_lgr_free(lgr);
> 
> For SMC-R and non-nocopy SMC-D, smc_conn_kill() does not unhash the
> socket. Nothing on this path takes the smc hash write_lock either.
> 
> A diag reader that already saw a non-zero alert_token_local holds only
> read_lock(&smc_hash->lock). Can it then read conn->sndbuf_desc->len and
> conn->rmb_desc->len after smc_lgr_free() has freed them? The same question
> applies to conn->lgr->is_smcd and lgr->list in the LGRINFO/DMBINFO
> conditions.
> 
> On non-RT kernels the window is small, but on PREEMPT_RT the read_lock is
> preemptible.
> 
> Would it work to unregister the connection, or clear alert_token_local, in
> smc_conn_free() even when lgr->list is empty? Another option is to skip
> the CONNINFO/LGRINFO/DMBINFO blocks when conn->freed is set.
> 
> [ ... ]
> 
>> @@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  			.lnk[0].link_id = link->link_id,
>>  		};
>>  
>> -		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
>> -		       sizeof(link->smcibdev->ibdev->name));
>> +		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));
> 
> [Severity: Medium]
> The commit message says this change is meant "to avoid racing with link
> clearing during SMC-R link failover". It removes the NULL dereference
> through link->smcibdev->ibdev, but is the race itself still there?

Updated the commit message description to clarify that copying cached
link->ibname specifically eliminates the NULL pointer dereference / UAF
of link->smcibdev->ibdev during concurrent link clearing.

> 
> This block loads link = smc->conn.lnk with a plain load. It then copies
> ibport, link_id, ibname, gid and peer_gid while holding only
> read_lock(&smc_hash->lock).
> 
> At the same time, smcr_link_down()->smc_switch_conns()->
> smc_switch_link_and_count() can run:
> 
> 	atomic_dec(&conn->lnk->conn_cnt);
> 	smcr_link_put(conn->lnk);
> 	conn->lnk = to_lnk;
> 
> This runs under lgr->conns_lock and conn->send_lock, and the diag reader
> takes neither. smcr_link_clear() then does the final
> smcr_link_put()->__smcr_link_clear():
> 
> 	memset(lnk, 0, sizeof(struct smc_link));
> 	lnk->state = SMC_LNK_UNUSED;
> 
> smcr_link_init() can later reuse the slot. smc_cdc_msg_validate() also
> rewrites conn->lnk under send_lock.
> 
> The link is embedded in lgr->lnk[], so this is not a use-after-free.
> However, could user space get an SMC_DIAG_LGRINFO record with an empty
> ibname, ibport 0, link_id 0 and all-zero GIDs, or a mix of two links?
> 
> Would taking conn->send_lock around the conn->lnk load and the copy, or
> holding a link reference, give a consistent snapshot? If not, could the
> commit message say that only the NULL dereference is avoided?
> 
> [Severity: Low]
> This isn't a bug, but link->ibname is only written by
> smcr_copy_dev_info_to_link() when the link is created. SMC_NLA_DEV_IB_NAME
> in smc_nl_handle_smcr_dev() and the pnet table still use the live
> smcibdev->ibdev->name.
> 
> After an ib_device_rename(), the name in SMC_DIAG_LGRINFO will not match
> the SMC device dump or the pnet configuration. The commit message
> documents this, and it matches the existing SMC_NLA_LINK_IB_DEV link dump.

Acknowledged. As noted, this matches the existing SMC_NLA_LINK_IB_DEV
netlink dump behavior.

pw-bot: cr


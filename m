Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE2E3F4DD9;
	Wed, 30 Sep 2026 07:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752095; cv=none; b=YRMObdbU97XY90/mU48kJOXmAh8qFBWSlvvYwo8DlRTTjlW4q3ZKt+jQQk8EDbAdjTp7ZN+UQnOclCDL9IqRvQSf8G8v8h7wKY7S6XtI8ThObY811CU+Sgu/9IaKi3wG4tlp3ak2180Bh/WRAEfrTRkqkvnH7Theo7BRsuP3tdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752095; c=relaxed/simple;
	bh=XN9j+yRGiSyXdJOCouLt0n3Divz5QtLeRQqXKUqxHk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EkJcq98WyBs2FrdUf0NpHECtg1JuCn/TszyQznnODZ4voBiXV9FpRLTty+ZiETVe4ghETaWfloL9EE3N1aZpOSChiauLDp1fpMVGEo3DVJrwCW6X97yvKbR0kt6B+k4FRk+pVGEO2pqQOm/DQVmM7GSrAR7/5Fj8lHIFX5V3qQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YiBwfLq9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YiBwfLq9"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TNZfS3120044;
	Wed, 30 Sep 2026 07:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HkmRXi
	QDKm6QdkTQDTgyVzMbLeU0wo28UNNLCK6XkNU=; b=YiBwfLq9aFdD4SkozMvIk5
	cvpwiief9gEWkZtek8tOELVBkpVi9QTs58PdEBsUnFQieG0/v2roltVmhdhNau4g
	C7tyO1zMTUK+9ki1uIPYRR38kPN++oM/UKMX9h93KTjM4/GHThJC44YdeUFpaba4
	4doEXQTJhVDghSQRX2uGFN/k0JJht7eLRC2CBMYJWjNf79qxVdND5vqBVtxO1dbF
	TBJ/WQKH2dYd2WePy6uqHVwfO9TjJCieNqE8637t6KXIMZ6r1Yk0RCXjB8X8gU+I
	hY6SzQOR5IHJV2Xj1ut006paOfS91+YBEKsbNl4kKGv0YIODgwt0z4wfC9C8E22A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4feanc4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:08:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68U4f6H22581769;
	Wed, 30 Sep 2026 07:08:04 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h0j23jgjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:08:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68U782AH6095744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 07:08:02 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14CF45805A;
	Wed, 30 Sep 2026 07:08:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F0558064;
	Wed, 30 Sep 2026 07:07:56 +0000 (GMT)
Received: from [9.123.5.239] (unknown [9.123.5.239])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Sep 2026 07:07:56 +0000 (GMT)
Message-ID: <68a19db3-a9ae-4303-83f2-0062dd58d56a@linux.ibm.com>
Date: Wed, 30 Sep 2026 12:37:55 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
 <179072950825.434549.9827562031861482481@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179072950825.434549.9827562031861482481@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6abcb555 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=bRPZyr_2oIILjFdXLQoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAyOCBTYWx0ZWRfX0cwhz7dI9STl
 bcI+k29AvlBsq5vmJOqj3Q3ZL595StoUjYIzmR8Gb6EHv8ucsC/n/DHbQQQkv1fdTLrQV/ufZFT
 FKbeXwmqnktHgBDajiZI+PyhYlVepwY=
X-Proofpoint-ORIG-GUID: 8sj6QPh2qyHiHoQgktKUeir_9paCdF7L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAyOCBTYWx0ZWRfX0kyZ2hlwyfVj
 +1yyzjlGFUUYsqemx5JEorVYDDmbubPklvl/43wKhc4TuaU0luZtoJXacl6G01kyg0HPUTWhzF2
 FLNAizqTiAlzr8JDDnjv8a8vsBMrMMR8kT4DcUxw+X9vLGRiYsV9NbL+5yYy1ERpSDJ4sjj6q90
 +MNqypZLePF+c5KGmETZghQnbszqloayqAYJ/L/B0chXiuJRuf4ywl4yrxMAgIaTkhD8N6YM3JT
 JfsU8fEHSMook5PPVRJkCWIC7f/udDkl29hK3JuCpA3dD4H4utPXPqa7V5QI/nwWIbeYQ43wwqA
 4E5DWnDrCSazPr0/yOl/Zea7VXEivcz/P6PWC/IIe0zw1UejCBLhgRLd61Px3hzZr04hddVvq+X
 roHpAX5aNSqZafhufsNcrsAyukBOaIk048JY6emT8U86/0Gq1dd1k65cfFvcSY4T4R0eB5R/3nl
 EG4i3ZacjAJqFIxOWoQ==
X-Proofpoint-GUID: 0wpBqYiaOGqIG2q1pJxrh4AXPuDi2c9X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609300028



On 30/09/26 6:21 am, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 2 (1) · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch leaves open another window of the class it says it
>   closes ('a hashed socket has freed or partially freed conn/lgr/lnk…
> - [Medium] The new early exit in __smc_diag_dump()
>   (net/smc/smc_diag.c:107-108, `if (sk->sk_state == SMC_INIT ||…
> - [Medium] For the smc_conn_abort() path, the patch's only protection
>   against dereferencing a freed conn->lgr in __smc_diag_dump() is two…
> - [Low] The second race the patch fixes is smcd_buf_detach() freeing
>   conn->sndbuf_desc in smc_conn_kill() while the socket is hashed and…
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_diag_handler_dump() (net/smc/smc_diag.c:245-260) starts the dump…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch aims to close races between the SMC sock_diag dump and the
> teardown of conn/lgr/lnk state. It unhashes the socket before
> smc_conn_free() in the close paths and at the top of smc_conn_kill(). It
> also makes __smc_diag_dump() skip the lgr->is_smcd load, and all extension
> blocks, for SMC_INIT and SMC_CLOSED sockets.
> 
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 9974149659c2f..663926465ba7f 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>>  {
>>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>>  
>> +	smc->sk.sk_prot->unhash(&smc->sk);
>>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>>  	else
> 
> [Severity: Low]
> Should this patch also have a Fixes: tag for ae2be35cbed2?

You are right! I'll add this in v7.

> 
> The commit message says this hunk is needed because smcd_buf_detach()
> frees conn->sndbuf_desc in smc_conn_kill() on the dmb_nocopy path:
> 
> smcd_buf_detach() {
>     ...
> 	buf_desc = conn->sndbuf_desc;
> 	conn->sndbuf_desc = NULL;
> 	kfree(buf_desc);
> }
> 
> That path was added by ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer
> DMB if supported"). It was moved to its current place by 36cdf5d48ca1
> ("net/smc: unregister the connection before draining the rx tasklet"),
> which itself has Fixes: ae2be35cbed2.
> 
> Both tags in this patch, f16a7dd5cf27 and 9dbe086c69b8, are older than the
> dmb_nocopy detach code. Without a tag for ae2be35cbed2, stable trees that
> lack dmb_nocopy would get the unconditional unhash, but the stated reason
> for it would not apply there.
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
> Is a plain read of sk->sk_state enough to stop this from reading a freed
> lgr?
> 
> smc_conn_free() never clears conn->lgr. On the smc_conn_abort() path the
> writer does the following under lock_sock(), using only plain stores:
> 
> smc_conn_abort()
>   smc_conn_free()
>     smc_lgr_unregister_conn()     /* alert_token_local = 0 */
>   smc_lgr_cleanup_early(lgr)
>     __smc_lgr_terminate()
>       smc_lgr_free()              /* lgrA freed, conn->lgr dangling */
> 
> One of two things follows:
> 
> - smc_switch_to_fallback() and then sk_state = SMC_ACTIVE, for example in
>   smc_connect_fallback().
> - In the ISM/RDMA v2 server retry loops, smc_conn_create() sets
>   conn->lgr = lgrB with a new token, and then
>   newsmcsk->sk_state = SMC_ACTIVE.
> 
> The reader here holds only the hash read_lock. There is no READ_ONCE(), and
> nothing orders the sk_state load before the later loads of
> conn->alert_token_local, conn->lgr and lgr->is_smcd. The control dependency
> on the sk_state test does not order those later loads.
> 
> On weakly ordered CPUs such as arm64 or POWER, could this see SMC_ACTIVE
> with use_fallback still false, together with a stale token or the stale
> lgrA pointer, and then read lgrA->is_smcd after it was freed?

On s390 arch, the hardware memory model provides strong ordering — all
loads are ordered with respect to prior loads, so the speculative load
scenario described in this comment cannot occur there.

For the race to be observable on arm64 or any other weakly ordered arch,
all of the following must be true simultaneously:

1) A diag dump is actively running (smcss or a monitoring tool).
2) A connection is in the narrow window between smc_conn_free() zeroing
alert_token_local and smc_lgr_cleanup_early() completing smc_lgr_free().
This path fires only on early handshake abort, before the CLC handshake
completes — a window measured in microseconds.
3) use_fallback is still false. The use_fallback check at line 91
precedes the sk_state check; if fallback has already been set the reader
never reaches the guarded code.
4) The arm64 CPU speculatively executes the conn->lgr->is_smcd load
before confirming the sk_state != SMC_INIT branch. This requires two
independent speculative loads to both produce stale values: first
conn->lgr (no data dependency on sk_state prevents its speculation), and
then lgr->is_smcd off the stale pointer.

The window requires all four conditions simultaneously, the practical
risk is negligible. Rather than addressing this in isolation here, a
proper audit and READ_ONCE/smp_load_acquire annotation pass across
net/smc/ for weak-ordering correctness would be better handled as a
separate patch.

> 
> This sk_state test and the second one below are separate reads, so within
> one dump they can return different values. KCSAN would likely report both
> as data races.
> 
>> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
>> +		goto out;
>> +
> 
> [Severity: Medium]
> Does this drop CONNINFO, LGRINFO and DMBINFO for SMC_CLOSED sockets whose
> connection is still registered and valid?
> 
> A hashed socket can reach SMC_CLOSED with its connection intact. For
> example, after shutdown(SHUT_WR) in SMC_APPCLOSEWAIT1 the socket is in
> SMC_APPCLOSEWAIT2, and then the peer aborts:
> 
> smc_close_passive_work()
>   smc_close_passive_abort_received()
> 	case SMC_APPCLOSEWAIT2:
> 	case SMC_PEERFINCLOSEWAIT:
> 		sk->sk_state = SMC_CLOSED;
> 
> The fd is still open, so smc_close_passive_work() skips both the new
> unhash and smc_conn_free():
> 
> 		if ((sk->sk_state == SMC_CLOSED) &&
> 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> 			sk->sk_prot->unhash(sk);
> 			smc_conn_free(conn);
> 
> The socket therefore stays hashed with alert_token_local and conn->lgr
> still valid.
> 
> With this patch, every caller of smc_conn_free() unhashes first:
> smc_close_active_abort(), smc_close_passive_work() and __smc_release(). It
> looks like any SMC_CLOSED socket still in the hash has valid connection
> state. If so, the SMC_CLOSED half of this check only hides valid data that
> smcss -D and smcss -R used to report when the matching diag_ext bits were
> set.
> 
> The commit message describes only the narrower sk_state != SMC_INIT guard
> on the is_smcd load. This early exit appears only in the v5 and v6
> changelog below the --- line, which is dropped when the patch is applied.
> 
> Could the SMC_CLOSED part be removed, or described in the commit message if
> it is intended?

The SMC_CLOSED guard is *intentional* — needed to prevent a UAF where
smc_conn_free() has already run but the socket is still hashed.

There is also no observability regression: smcss (from the separate
smc-tools userspace repository, not part of this kernel patch) already
does goto newline on diag_state == CLOSED and never reads CONNINFO,
LGRINFO or DMBINFO for closed sockets regardless of what the kernel
sends. The rationale is currently only in the v6 changelog below ---
which gets stripped on apply. Will add it to the commit message body in v7.

> 
>>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>  	    smc->conn.alert_token_local) {
>>  		struct smc_connection *conn = &smc->conn;
> 
> [Severity: Medium]
> This is a pre-existing issue and was not introduced by this patch, but is
> req->diag_ext always inside the request payload here?> > smc_diag_handler_dump() starts the dump without checking the request
> length:
> 
> 	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
> 	    h->nlmsg_flags & NLM_F_DUMP) {
> 		{
> 			struct netlink_dump_control c = {
> 				.dump = smc_diag_dump,
> 
> The generic check in __sock_diag_cmd() only compares against struct
> sock_diag_req (2 bytes), not struct smc_diag_req (52 bytes). inet_diag,
> unix_diag, packet_diag, netlink_diag, tipc_diag and vsock_diag all check
> nlmsg_len(h) against their own request size.
> 
> With a 2-byte payload, diag_ext at offset 3 falls in skb tailroom that
> netlink_sendmsg() did not initialize. When a live SMC connection exists,
> whether CONNINFO, LGRINFO and DMBINFO appear in the reply would reveal bits
> of that uninitialized memory to an unprivileged local user. KMSAN would
> likely report this as an uninit-value use.
> 
> Should smc_diag_handler_dump() reject requests where nlmsg_len(h) is less
> than sizeof(struct smc_diag_req)?

You are right! I'll address this issue via a seperate patch as its a
pre-existing issue.

> 
> [ ... ]
> 
>> @@ -185,6 +189,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  			goto errout;
>>  	}
>>  
>> +out:
>>  	nlmsg_end(skb, nlh);
>>  	return 0;
>>  
> 
> [Severity: High]
> The commit message says the patch closes windows where "a hashed socket has
> freed or partially freed conn/lgr/lnk state". It also cites 9dbe086c69b8
> ("net/smc: fix invalid link access in dumping SMC-R connections"). Is SMC-R
> link failover still exposed to the same race?
> 
> The LGRINFO block above this label runs under only the hash read_lock:
> 
> 	if (smc_conn_lgr_valid(&smc->conn) && !smc->conn.lgr->is_smcd &&
> 	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
> 	    !list_empty(&smc->conn.lgr->list)) {
> 		struct smc_link *link = smc->conn.lnk;
> 		...
> 		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> 		       sizeof(link->smcibdev->ibdev->name));
> 
> At the same time, smcr_link_down() or smc_llc_process_srv_delete_link() can
> run:
> 
> smc_switch_conns()
>   smc_switch_link_and_count()
>     smcr_link_put(conn->lnk);
>     conn->lnk = to_lnk;
> smcr_link_clear(lnk)
>   __smcr_link_clear()
>     memset(lnk, 0, sizeof(struct smc_link));
> 
> The link switch takes only conn->send_lock. The socket stays SMC_ACTIVE and
> hashed, and the lgr stays on its list. So neither the new
> SMC_INIT/SMC_CLOSED check nor the list_empty() check skips this block.
> 
> If a reader has already loaded the old conn->lnk, could it dereference a
> NULL link->smcibdev? Could it instead report fields from a different link
> that has reused the lgr->lnk[] slot?

The smcr_link_put() in smc_switch_link_and_count() drops only the
per-connection hold taken by smc_conn_create(). The link's base refcount
(initialised to 1 in smcr_link_init()) is only released by the
smcr_link_put() at the end of smcr_link_clear(). Therefore
__smcr_link_clear() and its memset(lnk, 0) are never triggered from the
smc_switch_conns() path, and the race described in this comment is *not*
reachable.


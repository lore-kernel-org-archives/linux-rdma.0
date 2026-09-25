Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4B39769B;
	Fri, 25 Sep 2026 06:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318334; cv=none; b=hbVj6FDLPNbVUMiFBg3KyB1t1fGTnwlK1lgdMUVVssJFljtXI3MCqGIwLRcWasEMimThTjBk1+ZZ0gPT8NJqZ0PAFIFR3JRkzf/kqubNbzyvGuzcpkgLbR3rI4x9w3dngn+V5hQXKvb9o+Pddy0Tfd57RvaYBNvfndvDQ8iqEfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318334; c=relaxed/simple;
	bh=Kx2FTHjANCexFxlTXWpOw90MEvQnQPMZnsbgGPFT3oQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S32E4i/gKHaE517gQFNrH6JTfDwhhWIVpT1ea7ag8Fq9tdy5gn1CAYB+X6ZXBPBLhp8rO7EkayukcTB9EVUj3wU94ZrGVNqxqFI4ZYw+12+dV2xlwo0HwU6a4tfB6xtOLP8PhOyyz3AgvnePLscQHJ1tTt5HjLp7oRWztx6+mOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l3so31Cg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l3so31Cg"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4aDEH074518;
	Fri, 25 Sep 2026 06:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Uagz98
	eh/mahAwwBREcI7xRyVPw/6sqouZ8XEfabap4=; b=l3so31CgupnOGkaFVuIX19
	lg7jM3uNj5xvhgsUwKbJoHIEYhzTuMBtAI65LtIKRBi3T8B3D+b1SNw+k/Vk4CbQ
	t/3VosYW9wCZXut/WoZZNyadNIJIDIWnOEE9EszTYV842KDR5dzp7rEobFyoVuL/
	EIKS/mayPmY6T0yQ53bfdhsHVjqTtBcd+k1kX6spp2SkOnDYJdovPVcK4aAReEd8
	iUcHxyIq9F0i8sJ8m2GtD0xnhMbTmkQC+TGkvKk9DTKRb2SQ2cYcu6J6gjTPKfuE
	/GswpCTj267grnQzF7Z+IuIHWD1YK/0WdqhimaO3kgYFGRvIayzJI1EzxB+bM9HA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskg2wp3m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 06:38:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4laUd3244947;
	Fri, 25 Sep 2026 06:38:43 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbu918yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 06:38:43 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68P6cgxI32703164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 06:38:42 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 391EF5805E;
	Fri, 25 Sep 2026 06:38:42 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A72658045;
	Fri, 25 Sep 2026 06:38:35 +0000 (GMT)
Received: from [9.39.21.9] (unknown [9.39.21.9])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Sep 2026 06:38:35 +0000 (GMT)
Message-ID: <f3318ef1-02d9-4eda-80b9-d371bbbe1bf2@linux.ibm.com>
Date: Fri, 25 Sep 2026 12:08:33 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
 <179028482174.2160803.16069872683642574185@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179028482174.2160803.16069872683642574185@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: aNUD6pwb3Kd1ntFYZ5tTRpsRhf3JyGPo
X-Authority-Analysis: v=2.4 cv=I43w19gg c=1 sm=1 tr=0 ts=6ab616f5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=-Cb9ymFxY4KYdMEwedoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAyNiBTYWx0ZWRfX+BrI78t1bbj3
 lzuWV3jPV9KXZfov1RS7oATp5zpbTbNNgiR7vnR/GF3ss5mQLxvBQWbB+pkncemiuvhny8mHqXs
 QiNL7nM5DpBcmvkVyPJz8Wt5kqNgIfdMqbPnNe2GYQ5/GlZ9CCjs9G+B8j6kohevPxMhA8cXuwR
 gHV3BV//lUDEv7TvEY1Qduo3RM8Et1f0w3/dx9Z1PLuZHcKGt/IbV1qXATbBj+YmcZuD2fBRtCk
 0nnmGZBj79pdbCMG3iNW4BcSsrhbqQ5RTGGCOINE2LslbxLGhR8KGidj1MeK5LFonZQfY/UyDnb
 puFS52qiIem2ZFVcMVr44ESWiEN1vQqnurrmct1PA5ve0GvggSe+tifAriiZ5iZIi5Jm/i4+yyd
 jL9ag/d4a8K4tblhLBaG5/bTm3oSwh9P3XYXMyc0bIqErFh+b++yE9Y2pKTT6BuTz8h1jx9n5bn
 2d4cZM7rEKNjnSBUDXA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAyNiBTYWx0ZWRfX7sbW0WMvO3aM
 sGF9bIgJ9jcvuTU4IqwKDnGrsR8BBboUSS9xY9Z91OJ1eDIlxALajtaSqYi3eSkPzA+8BEsPLnS
 A45v1cfMpk5RnkMnwNDCiXugZBxUpRM=
X-Proofpoint-GUID: mObDE-BHI6C7tLj1JEeILXMIMqHKl3Hg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250026



On 25/09/26 2:50 am, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 (1) · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] __smc_diag_dump() (net/smc/smc_diag.c:91-96) still reads
>   `smc->conn.lgr->is_smcd` to work out r->diag_mode.
> - [High] In the SMC_DIAG_LGRINFO block, __smc_diag_dump() does `struct
>   smc_link *link = smc->conn.lnk;` and then dereferences…
> - [Medium] The commit message says the socket is unhashed "before
>   smc_conn_free() is called at the two terminal teardown sites".
> 
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the patch
>   leaves it open while adding an unhash that runs too late on the same…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch unhashes SMC sockets in smc_close_active_abort() and
> smc_close_passive_work() before smc_conn_free() drops the lgr/lnk
> references. It also makes __smc_diag_dump() skip the conn/lgr/lnk
> attribute blocks when the socket is in SMC_INIT or SMC_CLOSED state. The
> goal is to keep the diag reader from dereferencing a freed link group or
> link.
> 
>> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
>> index bb0313ef5f7c1..3940098c651d9 100644
>> --- a/net/smc/smc_close.c
>> +++ b/net/smc/smc_close.c
>> @@ -130,6 +130,11 @@ void smc_close_active_abort(struct smc_sock *smc)
>>  	struct sock *sk = &smc->sk;
>>  	bool release_clcsock = false;
>>  
>> +	/*
>> +	 * Unhash before any branch calls smc_conn_free() and drops lgr/lnk refs;
>> +	 * the diag reader must not see a hashed socket with freed lgr/lnk.
>> +	 */
>> +	sk->sk_prot->unhash(sk);
> 
> [Severity: Medium]
> The commit message says the socket is unhashed "before smc_conn_free() is
> called at the two terminal teardown sites". This unhash, though, runs
> unconditionally for every state. Is that intended?
> 
> The SMC_ACTIVE, SMC_APPCLOSEWAIT1 and SMC_APPCLOSEWAIT2 branches never call
> smc_conn_free(). They only set SMC_CLOSED and call sock_put(). SMC_INIT,
> SMC_PEERABORTWAIT and SMC_CLOSED don't call it either. Neither does the early
> break taken when smc_close_cancel_work() changes the state.
> 
> On link group termination, smc_conn_kill() calls smc_close_active_abort()
> for every connection:
> 
> net/smc/smc_core.c:smc_conn_kill() {
>     ...
>     smc_lgr_unregister_conn(conn);
>     smc_close_active_abort(smc);
> }
> 
> Doesn't this make killed SMC_ACTIVE sockets vanish from smc_diag/smcss
> right away instead of at close? The application still has them open, and
> their lgr/lnk references are still held.
> 
> These sockets reach smc_conn_free() later in __smc_release(), which already
> unhashes first. smc_release() is also a third caller of
> smc_close_active_abort(), and the commit message doesn't mention it.
> 
> Would it be narrower to unhash only right before the two smc_conn_free()
> calls in the SMC_PEERCLOSEWAIT1/2/SMC_PEERFINCLOSEWAIT and
> SMC_PROCESSABORT/SMC_APPFINCLOSEWAIT branches?

You are right. The unconditional unhash at the top of
smc_close_active_abort() was placed there because v5 traced the
smc_conn_kill() → smc_close_active_abort() → smc_conn_free() chain and
stopped at smc_close_active_abort() as the insertion point. This was too
broad — it also fires for the SMC_ACTIVE/APPCLOSEWAIT branches which
never call smc_conn_free(), and for the smc_release() call site where
the socket is a live connection the application still has open.

Fix in v6: remove the unconditional unhash from the top of
smc_close_active_abort() and place it scoped, immediately before each of
the two smc_conn_free() calls — in the PEERCLOSEWAIT1/2/PEERFINCLOSEWAIT
branch and the PROCESSABORT/APPFINCLOSEWAIT branch.

> 
> [Severity: High]
> This is a pre-existing issue, not one introduced by this patch. Still, on
> the smc_conn_kill() path this new unhash runs too late to protect against
> it.
> 
> On SMC-D with dmb_nocopy (for example loopback-ism), smc_conn_kill() frees
> the sndbuf descriptor before it unregisters the conn and before it calls
> smc_close_active_abort():
> 
> net/smc/smc_core.c:smc_conn_kill() {
>     ...
>     if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
>         smcd_buf_detach(conn);
>     ...
>     smc_lgr_unregister_conn(conn);
>     smc_close_active_abort(smc);
> }
> 
> smcd_buf_detach() does this:
> 
>     buf_desc = conn->sndbuf_desc;
>     conn->sndbuf_desc = NULL;
>     kfree(buf_desc);
> 
> During that window the socket is still hashed and still in SMC_ACTIVE, so
> it passes the new diag guard. alert_token_local is also still set. That
> means __smc_diag_dump() enters the SMC_DIAG_CONNINFO block and evaluates:
> 
>     .sndbuf_size = conn->sndbuf_desc ?
>         conn->sndbuf_desc->len : 0,
> 
> These are plain loads, and only the hash read_lock is held. Could this
> dereference NULL, or read ->len from an smc_buf_desc that has been kfree'd?
> The lock_sock() in __smc_lgr_terminate() does not exclude the diag reader.
> 
> Would unhashing at the start of smc_conn_kill(), before smcd_buf_detach(),
> close this as well?

You are right. In smc_conn_kill(), smcd_buf_detach() NULLs and frees
conn->sndbuf_desc before smc_close_active_abort() is called, but the
socket is still hashed during that window. The v5 unhash inside
smc_close_active_abort() is too late.

Fix in v6: move the unhash to the top of smc_conn_kill(), before
smcd_buf_detach(). Both call sites (__smc_lgr_terminate() and
smc_conn_abort_work()) hold lock_sock and have no expectation that the
socket remains hashed after smc_conn_kill() returns. smc_unhash_sk() is
idempotent so the subsequent unhash attempts further down become safe
no-ops.

> 
>>  	if (sk->sk_state != SMC_INIT && smc->clcsock && smc->clcsock->sk) {
>>  		sk->sk_err = ECONNABORTED;
>>  		if (smc->clcsock && smc->clcsock->sk)
> 
> [ ... ]
> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..fe32091e37dab 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -103,6 +103,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
>> +		goto out;
>> +
> 
> [Severity: High]
> Does this guard cover the lgr dereference earlier in __smc_diag_dump() that
> sets r->diag_mode?
> 
> net/smc/smc_diag.c:__smc_diag_dump() {
>     ...
>     if (smc->use_fallback)
>         r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>     else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>         r->diag_mode = SMC_DIAG_MODE_SMCD;
>     ...
> }
> 
> That load happens before the new SMC_INIT/SMC_CLOSED check, and only the
> smc hash read_lock is held.
> 
> The commit message says this guard handles the smc_conn_abort() SMC_INIT
> case. Take a handshake failure such as smc_listen_decline() ->
> smc_conn_abort(new_smc, local_first). The socket is still hashed in
> SMC_INIT and use_fallback has not been set yet:
> 
> net/smc/af_smc.c:smc_conn_abort() {
>     ...
>     smc_conn_free(conn);
>     if (local_first && lgr_valid)
>         smc_lgr_cleanup_early(lgr);
> }
> 
> The following chain then frees the lgr synchronously:
> 
> smc_lgr_cleanup_early()
>   __smc_lgr_terminate()
>     smc_lgr_free()
>       smc_lgr_put()
>         __smc_lgr_free()
>           kfree(lgr)
> 
> Nothing on this path takes the hash write_lock, and conn->lgr is never
> cleared. smc_conn_lgr_valid() is only plain loads of conn->lgr and
> conn->alert_token_local.
> 
> Can a diag reader pass smc_conn_lgr_valid() just before the conn is
> unregistered, and then read lgr->is_smcd after the kfree()?
> 
> smc_diag_handler_dump() has no capability check, and a remote peer can
> cause the handshake failure. Would checking the state (or use_fallback)
> before any conn.lgr access close this?

You are right. The conn->lgr->is_smcd load in the r->diag_mode
assignment happens before the SMC_INIT guard, leaving a window where a
concurrent smc_lgr_cleanup_early() → kfree(lgr) on another CPU can race
with the reader. This is remotely triggerable since
smc_diag_handler_dump() has no capability check and a remote peer can
cause the handshake failure that leads to smc_conn_abort().

Fix in v6: inline an sk->sk_state != SMC_INIT check directly into the
else if condition, so conn->lgr->is_smcd is never loaded for SMC_INIT
sockets. The SMC_CLOSED check is not needed at that line — on every path
that sets SMC_CLOSED, either the socket is unhashed before
smc_conn_free() runs (__smc_release(), passive work), or conn->lgr is
still live and the dereference is safe.

> 
>>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>  	    smc->conn.alert_token_local) {
>>  		struct smc_connection *conn = &smc->conn;
> 
> [Severity: High]
> Sockets in SMC_ACTIVE and the closing states still get past this guard. Is
> the SMC_DIAG_LGRINFO block further down still exposed to a concurrent link
> switch?
> 
> net/smc/smc_diag.c:__smc_diag_dump() {
>     ...
>     struct smc_link *link = smc->conn.lnk;
>     ...
>     memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
>            sizeof(link->smcibdev->ibdev->name));
>     ...
> }
> 
> Only the hash read_lock is held here. During SMC-R link failover,
> smcr_link_down() -> smc_switch_conns() -> smc_switch_link_and_count()
> replaces conn->lnk under conn->send_lock and drops the conn's reference on
> the old link:
> 
> net/smc/smc_core.c:smc_switch_link_and_count() {
>     ...
>     smcr_link_put(conn->lnk);
>     conn->lnk = to_lnk;
>     ...
> }
> 
> When smcr_link_clear() drops the last reference, __smcr_link_clear() calls
> put_device() on the ibdev and then memset(lnk, 0). The lgr stays on its

After tracing the refcount accounting I believe this race is not
reachable. The smcr_link_put() in smc_switch_link_and_count() only drops
the per-connection hold taken by smc_conn_create(). The link's base ref
(initialised to 1 in smcr_link_init()) is only released by
smcr_link_clear(), which is called exclusively from the lgr termination
path. Hence __smcr_link_clear() is not called in this path.

By that point the lgr has already been removed from the global list, so
the diag reader's !list_empty(&smc->conn.lgr->list) check already gates
it out of the lgrinfo block.

Will post v6 shortly.

pw-bot: cr

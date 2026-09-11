Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A073624CF;
	Fri, 11 Sep 2026 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137819; cv=none; b=Nznbs3B6ipynX8at6Ba7xcr/lO8eDY2MTOBliYyxA48qGXWDCl++WNY3cXzUIHpoqdLVIRrl6siI7gzDPiPTy6NiJlsLO+l8rjqRqpf1lYbX5w1J4XY4KpD8vMqFuiSlSqxAe8zxlbXvKpQ8jDoni98uHuFHxopdhRKtlTYTpoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137819; c=relaxed/simple;
	bh=iw24BJxAATKnd25eqMx/8+UCIpRconcOOPTUfVFcc58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SBivd8HnskEiHKR+hQc9P7Tor+tXvjlHKNiR6xTu3FVC6f7XTR9j2+y5CXAoNkwP71dhR+IdqTs5t0RIpS0erzRzsovdAi04rEuckj0cFmGBtLwyTZ4kW7Ji/30hEPjP3Wa6Vxq1jmQzqwOttW2hzYlvMhO/0VkrKzX6UeUjnVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ifssJJVp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ifssJJVp"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BD1NmO4169275;
	Fri, 11 Sep 2026 14:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bxPNWA
	+zA8HUTgq1oL1lCSrIeqX5n7G/10zWNxeTRBY=; b=ifssJJVpaODMG1QrJ4OL+b
	v581TZsxkjJQmirMWuf88Nlfjy2LDqe506jUED28OgrFTSznf+2pqToS9uyA/7QS
	9g04jFcDutCtGngfGYyeN0eaGE3B80r01uphw7motU2PDVh7k5dMw1h4KGXW09RN
	4dM3J6WtT0vFVobqd+CveDiUij5p8Xl+l364B/s66vzWvR9FjmY65qTKwLrRS+Hk
	FLhx5RMvOSz5TvrVIRA0YgPN7dbYrKfcXZij6zltMHQihz99hf6T7xjKD2yCWWQ4
	G7fiHSjRn3ivlkluj+siTVty2Ev6xVC44XwQ78+UVKz5LHtkcmPwLNuaqXgqNQJg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8nc5gr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 14:43:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68BEZAKv1745891;
	Fri, 11 Sep 2026 14:43:28 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvreu98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 14:43:28 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68BEhRBv47710524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 14:43:27 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 027B25803F;
	Fri, 11 Sep 2026 14:43:27 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C02758064;
	Fri, 11 Sep 2026 14:43:20 +0000 (GMT)
Received: from [9.124.211.27] (unknown [9.124.211.27])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 14:43:20 +0000 (GMT)
Message-ID: <cdfe2637-ee72-4fc7-b208-58019f8e2071@linux.ibm.com>
Date: Fri, 11 Sep 2026 20:13:18 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/smc: fix abort_work termination in
 smc_conn_free()
To: netdev-bot+sashiko@kernel.org
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260907114721.1303498-1-hidayath@linux.ibm.com>
 <178895454461.219967.1315505922405395089@kernel.org>
Content-Language: en-GB
From: Hidayath Khan <hidayath@linux.ibm.com>
In-Reply-To: <178895454461.219967.1315505922405395089@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa41391 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=hNcEowdC0seFr4XGLsAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: gziv1Agz3qELbO7KcpZ3odfrIxMql0n5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIwMyBTYWx0ZWRfX91DPoO9oHDrv
 oiH69xHXVjpKa8ti6pIOM0GwYVEDF1vxJJgZX/4tCjc0p5gsY95mim24Zn7gyaerTSftgSV477Y
 kWFiEdQFFx/Zl0veDGaJKq9Dju2lEvcYVkaQbNZW2ffXb+A1oLG8o22wDMsRtWmolctuoI6leQC
 S91PMb6xNZ7AQDzye1bPU2zlE0fEJ8DuJoI+CfoGn3I/2rZS26jr+PgGGedZFUu5aquH2QeVhnB
 ZDB4rmH/wCNGsrlyxLM1OU5mfFtSzxFKKNTaM5ZwUxBAkFsuv09AYlWpOpveQqzfJoMfXm1O3gg
 LDUHL/rNvgwzeDp+RQ8e9B2+RVcefIS47YU23qU8zCSj8qQnmHXXHQzN6ePUZWc/Xg3rAYsCKzH
 LfkEWIwRu0r9F+dnVen2sP/2Rm1rXt38+tmer8FcpHXSSKwrEeMxjYrMTRB/kD2HgsPgtA50CnO
 2QOC0g+RzSeYaNSp91w==
X-Proofpoint-ORIG-GUID: F4QgWaDmAdpNaaK50IRm2l5XP50GrlRi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIwMyBTYWx0ZWRfX1gHrYlsFiPmj
 GMZJU254HA7BPzx+w6YC10kcg2zzmiUkJx7WNOR+vPgtZ1JR6yEev7Ne27upTb9rSqJnCgr2XS3
 sB2bbVxbMLxgtZrn56jVJRG7cZiaSoU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_04,2026-09-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110203


On 09/09/26 5:19 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
>
> Critical: 0 · High: 1 · Medium: 1 · Low: 0
>
> - [High] New lock-drop window in smc_conn_free() invalidates the
>    smc_cdc_wait_pend_tx_wr() barrier before the connection buffers/link…
> - [Medium] smc_conn_free() silently changes its locking contract without
>    documenting or asserting it, and its callers were not audited for the…
>
> --
Thanks for the review. Both the findings are correct, and together they rule
out the approach v2 took rather than asking for an adjustment to it, so v3
drops the lock-drop entirely.
>
> net/smc: fix abort_work termination in smc_conn_free()
>
> This moves the abort_work cancel in smc_conn_free() into a new helper
> smc_conn_cancel_abort_work() which drops the socket lock around
> cancel_work_sync() and drops the socket reference when a pending item was
> removed.  It also makes smc_conn_abort_work() skip smc_conn_kill() when
> conn->freed is already set.
>
> Link: https://lore.kernel.org/netdev/20260806081549.595001-1-hidayath@linux.ibm.com/
>
> A couple of questions about the new lock drop below.
>
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 04aedd957543a..9a109eae73b92 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1251,6 +1251,25 @@ static void smc_buf_unuse(struct smc_connection *conn,
>>   	}
>>   }
>>   
>> +/* Cancel a pending abort work item.  smc_conn_abort_work() takes the socket
>> + * lock, so the lock has to be dropped here.  Otherwise cancel_work_sync()
>> + * waits for a worker that is itself blocked on the caller.  This is the idiom
>> + * smc_close_cancel_work() already uses for close_work.
>> + */
>> +static void smc_conn_cancel_abort_work(struct smc_connection *conn)
>> +{
>> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>> +	struct sock *sk = &smc->sk;
>> +
>> +	if (current_work() == &conn->abort_work)
>> +		return;
>> +
> [Severity: Medium]
> Should the new "caller must hold the socket lock" requirement be documented
> or asserted?  smc_conn_free() is declared cross-file in net/smc/smc_core.h
> as
>
>      void smc_conn_free(struct smc_connection *conn);
>
> and its comment still reads only "remove a finished connection from its
> link group", yet for lgr->is_smcd == false it now unlocks and relocks the
> socket.  There is no sock_owned_by_me() or lockdep_assert_held() to catch a
> caller that does not hold it.
>
> All current call sites do hold the lock (__smc_release(),
> smc_close_active_abort(), smc_close_passive_work(), smc_conn_abort()), so
> nothing is unbalanced today.  A backport or a new error path that reaches
> smc_conn_free() without the lock would call release_sock() on a lock it does
> not own and then return with the lock held.
>
> There is also a caller-visible half.  The tree's idiom around a
> lock-dropping cancel revalidates state afterwards, as in
> smc_close_active_abort():
>
>      sk->sk_state = SMC_PEERABORTWAIT;
>      smc_close_cancel_work(smc);
>      if (sk->sk_state != SMC_PEERABORTWAIT)
>          break;
>      sk->sk_state = SMC_CLOSED;
>      smc_conn_free(&smc->conn);
>      release_clcsock = true;
>      sock_put(sk); /* passive closing */
>
> The smc_conn_free() calls in smc_close_active_abort(),
> smc_close_passive_work() and __smc_release() revalidate nothing and act on
> state that was observed before the new window (release_clcsock = true, the
> "passive closing" sock_put()).
>
> Does this also invalidate the invariant declared in smc_listen_work()?
>
>      lock_sock(&new_smc->sk); /* release in smc_listen_out() */
>
> On an SMC-R handshake abort, smc_listen_work() -> smc_conn_abort() ->
> smc_conn_free() now drops that lock in the middle, so another thread (for
> example __smc_lgr_terminate(), which does lock_sock() before
> smc_conn_kill()) can run against a half-set-up socket.
>
> The changelog describes the change as a local fix to the cancel; would it be
> worth stating that the calling convention of smc_conn_free() changed for
> every call site?
>
>> +	release_sock(sk);
>> +	if (cancel_work_sync(&conn->abort_work))
>> +		sock_put(sk); /* sock_hold done by schedulers of abort_work */
>> +	lock_sock(sk);
>> +}
>> +
> [Severity: High]
> Does dropping the socket lock here void the pending-TX drain that
> smc_conn_free() performs immediately before this call?

Yes. This is the finding that ended the approach, and the ordering makes it
the natural interleaving rather than a narrow race. In smc_cdc_tx_handler():

     if (atomic_dec_and_test(&conn->cdc_pend_tx_wr)) {
         if (sock_owned_by_user(&smc->sk))
             conn->tx_in_release_sock = true;
         else
             smc_tx_pending(conn);

         if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
             wake_up(&conn->cdc_pend_tx_wq);
     }

conn->tx_in_release_sock is set before the wake_up, on the very completion
that lets smc_cdc_wait_pend_tx_wr() return, and the socket is owned by the
task doing the teardown. So the drain returns with the flag already set,
and the release_sock() immediately after it runs smc_release_cb() ->
smc_tx_pending() -> smc_tx_sndbuf_nonempty(), which posts RDMA writes out of
conn->sndbuf_desc and re-increments conn->cdc_pend_tx_wr. smc_buf_unuse()
then memzero_explicit()s that buffer and sets used = 0, returning the
descriptor to the link group pool - it never clears conn->sndbuf_desc - so
another connection can be handed a buffer the adapter is still reading, and
smcr_link_put()/smc_lgr_put() run with cdc_pend_tx_wr non-zero.
>
> The SMC-R branch of smc_conn_free() is now:
>
>      smc_cdc_wait_pend_tx_wr(conn);      /* cdc_pend_tx_wr drains to 0 */
>      smc_conn_cancel_abort_work(conn);   /* release_sock() ... lock_sock() */
>      ...
>      smc_buf_unuse(conn, lgr);           /* zeroes sndbuf, used = 0 */
>      smc_lgr_unregister_conn(conn);
>
> release_sock() on an SMC socket is not a passive unlock.  sk_prot->release_cb
> is smc_release_cb(), and net/smc/af_smc.c has:
>
>      if (smc->conn.tx_in_release_sock) {
>          smc_tx_pending(&smc->conn);
>          smc->conn.tx_in_release_sock = false;
>      }
>
> conn->tx_in_release_sock is set from BH in smc_cdc_tx_handler(), on the very
> completion that lets smc_cdc_wait_pend_tx_wr() return, when the socket is
> owned by the task:
>
>      if (sock_owned_by_user(&smc->sk))
>          conn->tx_in_release_sock = true;
>      else
>          smc_tx_pending(conn);
>
>      if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
>          wake_up(&conn->cdc_pend_tx_wq);
>
> So smc_tx_pending() -> smc_tx_sndbuf_nonempty() -> smcr_tx_sndbuf_nonempty()
> can post RDMA writes out of conn->sndbuf_desc and a CDC send, re-incrementing
> conn->cdc_pend_tx_wr, inside the window this patch opens.
> smc_tx_sndbuf_nonempty() only gates on sk_err, an empty send queue, peer RMBE
> space and:
>
>      if (conn->killed ||
>          conn->local_rx_ctrl.conn_state_flags.peer_conn_abort) {
>          rc = -EPIPE;    /* connection being aborted */
>          goto out;
>      }
>
> conn->freed is never consulted on that path.
>
> Is there a reachable state where sk_err and conn->killed are both clear while
> staged data is still present?  Closing an SMC-R socket with SO_LINGER=0 or
> from an exiting task returns from smc_close_stream_wait() immediately:
>
>      if (!timeout)
>          return;
>
>      if (!smc_tx_prepared_sends(&smc->conn))
>          return;
>
> which leaves prepared sends outstanding and the state at SMC_PEERCLOSEWAIT1,
> so __smc_release() does not free the connection.  When the peer closes,
> smc_close_passive_work() reaches
>
>      smc_conn_free(conn);
>
> with sk_err == 0, conn->killed == 0 and data still staged.
>
> After lock_sock() returns, smc_buf_unuse() does memzero_explicit() on the
> send buffer and sets used = 0, returning the descriptor to the link-group
> pool while the HCA may still be reading it, and smcr_link_put() /
> smc_lgr_put() then run with cdc_pend_tx_wr non-zero, so a later
> smc_cdc_tx_handler() completion dereferences pend->conn and the link WR
> structures.
>
> Note also that conn->tx_work is not cancelled here, while
> smc_close_cancel_work() does cancel_delayed_work_sync(&conn->tx_work).  A
> tx_work armed from BH via mod_delayed_work() in smcr_tx_sndbuf_nonempty()
> can take the socket lock in the same window and post the same way.
>
> Before this patch cancel_work_sync() ran with the socket lock held, so no
> lock-taking tx path could interpose between the drain and the buffer release.
>
> Would it work to cancel abort_work (and tx_work) before
> smc_cdc_wait_pend_tx_wr(), or to repeat the drain after lock_sock() returns
> and gate smc_tx_pending() on conn->freed?
Cancelling before the drain does not help, because the problem is not the
order of the cancel and the drain - it is that release_sock() on an SMC
socket runs the tx path at all. Moving the cancel earlier moves the window,
it does not close it: the lock is still dropped between the drain and
smc_buf_unuse().

Repeating the drain after lock_sock() has the same shape as the first one.
The completion that ends the second drain can set tx_in_release_sock too.

v3 removes the window: the socket lock is never dropped. smc_conn_free()
sets conn->freed under the socket lock before it releases anything,
and smc_conn_abort_work() takes the same lock, so an instance that is
running is parked on that lock and will find the flag set, and one queued
afterwards finds the same - and then the cancel no longer has to wait for
anything, so cancel_work() replaces cancel_work_sync(). Returning the
reference when it reports it removed a pending item fixes the leak v1
was about.
>
>>   /* remove a finished connection from its link group */
>>   void smc_conn_free(struct smc_connection *conn)
>>   {
>> @@ -1276,8 +1295,7 @@ void smc_conn_free(struct smc_connection *conn)
>>   			smcd_buf_detach(conn);
>>   	} else {
>>   		smc_cdc_wait_pend_tx_wr(conn);
>> -		if (current_work() != &conn->abort_work)
>> -			cancel_work_sync(&conn->abort_work);
>> +		smc_conn_cancel_abort_work(conn);
>>   	}
>>   	if (!list_empty(&lgr->list)) {
>>   		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> [ ... ]
>

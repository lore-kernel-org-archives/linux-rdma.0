Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631CA45FFC1;
	Mon, 21 Sep 2026 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984618; cv=none; b=QZ3RSY5fBuB6v1gxnPROwTDtgzcByXRQlbrlFbbvBAPRAUojeHdvFxeCT3RZ4vG1hG6tQKmCluNv9GVPWrZYcV8+QTZJxeeZcfOsKSsRrCO0eiFomvmgkQ/faR/64xrmHMQL+ijS7xEeebeRaWVfMDewdHEwXLqShh6jdWIJXHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984618; c=relaxed/simple;
	bh=afPWeVtNosfkfqz6nT4JYmzOblGm5bb6LiJW7SZQ9hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2tFWofsYjZal6btJ3F/LRg5lGEpofl4J80Wd7ed8S4xhZl8EDikVWdVFiVmyFyzhPWfgW5odDA/l40p6EYaRwUOt3uLL5bjuZqnOrBg80ffJM/Xce3fh8j0AHiQAoiEr7cjRQNRfWfcknRuiOzLtQhtSE02hdo7FhqyBqYjL7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PSwJ9sPa; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PSwJ9sPa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789984605; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=oYMuedQM0+s59Z/nrPJ2/AY8JGfsst0uvx3eSiTELVk=;
	b=PSwJ9sPa8JHof/6fxkkTGa7DHMpGUMxeataodOY7ZW9BBDtHHNz8uuYmke4TudBWeTfymVkmmLnxhrmsZPl+C8hYcEvRzS5QpzNMAt70riQGyCzZf9o7RQBYnuGAstj5Wg+4m6rwkIdUaDXrlGIINaFfJRpvgkGCLcMyPjjsfyE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XBM90FO_1789984603;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XBM90FO_1789984603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 21 Sep 2026 17:56:44 +0800
Date: Mon, 21 Sep 2026 17:56:43 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, hidayath@linux.ibm.com,
	stable@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
Message-ID: <arD_Wzbv3Z01ZSCv@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
 <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
 <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>
 <aqq0rnQjiKymR3TM@linux.alibaba.com>
 <2111df0c-33b1-4330-8adf-ac5a0f1de451@linux.ibm.com>
 <aqwM5USzvdm5zF40@linux.alibaba.com>
 <d11098fd-042c-4246-ba3b-9c2662447f21@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d11098fd-042c-4246-ba3b-9c2662447f21@linux.ibm.com>

On 2026-09-18 12:57:13, Mahanta Jambigi wrote:
>
>
>On 17/09/26 9:23 pm, Dust Li wrote:
>> On 2026-09-17 13:15:23, Mahanta Jambigi wrote:
>>>
>>>
>>> On 16/09/26 8:54 pm, Dust Li wrote:
>>>> On 2026-09-16 14:04:42, Mahanta Jambigi wrote:
>>>>>
>>>>>
>>>>> On 15/09/26 8:43 pm, Dust Li wrote:
>>>>>> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>>>>>>> The diag dump walks the socket hash table under a read_lock and
>>>>>>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>>>>>>> drop those references via smc_conn_free() while the socket is still
>>>>>>> hashed:
>>>>>>>
>>>>>>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>>>>>>> smc_close_passive_work() -> smc_conn_free()
>>>>>>>
>>>>>>> This allows the diag reader to dereference a freed lgr or lnk.
>>>>>>>
>>>>>>> Fix it by unhashing the socket before smc_conn_free() is called at
>>>>>>> each of these two sites.  Any socket visible to the diag reader
>>>>>>> under the hash read_lock then has valid conn->lgr and conn->lnk
>>>>>>> pointers.
>>>>>>>
>>>>>>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>>>>>>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>>>>>>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>>>>>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>>>>>>>> unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>>>>>>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>>>>>>> so direct calls at the two teardown sites in smc_close.c are
>>>>>>> sufficient - dropped the __smc_release() hunk: it needs no change
>>>>>>> since the subsequent unhash there is already a safe no-op - fixed
>>>>>>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>>>>>>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>>>>>>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>>>>>>> there would make live fallback sockets invisible to smcss -
>>>>>>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>>>>>>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>>>>>>> and then smc_conn_create() on the next device; unhashing in 
>>>>>>> smc_conn_free() would permanently hide the established connection
>>>>>>> from smc_diag since smc_conn_create() does not re-hash the socket
>>>>>>
>>>>>> Hi Mahanta,
>>>>>>
>>>>>> This version looks clean. And you explained why we can't call unhash
>>>>>> in smc_conn_abort() well. But smc_conn_abort() still calls
>>>>>> smc_conn_free(), when the smc_sk is still hashed, is there still a
>>>>>> race window with dump ?
>>>>>
>>>>> Hi Dust,
>>>>>
>>>>> Thank you for catching this corner case!
>>>>>
>>>>> During early handshake setup (when sk_state is *SMC_INIT*),
>>>>> smc_conn_abort() can be called on connection failure/fallback and
>>>>> invokes smc_conn_free() while the socket remains hashed, leaving a
>>>>> window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
>>>>> and dereference conn->lgr / conn->lnk.
>>>>>
>>>>> Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
>>>>> and userspace (smcss) *skips displaying link-group, DMB, and connection
>>>>> details for INIT state sockets anyway*, we could have __smc_diag_dump()
>>>>> skip inspecting connection/link-group extensions when r->diag_state ==
>>>>> SMC_INIT:
>>>>>
>>>>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>>>>> --- a/net/smc/smc_diag.c
>>>>> +++ b/net/smc/smc_diag.c
>>>>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>>>>> sk_buff *skb,
>>>>> 	r->diag_state = sk->sk_state;
>>>>> +	if (r->diag_state == SMC_INIT)
>>>>> +		return 0;
>>>>> +
>>>>> 	if (smc->use_fallback)
>>>>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>>>>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>>>>
>>>>> Together with unhashing before smc_conn_free() in smc_close.c for
>>>>> established and closing sockets, this cleanly closes the race window
>>>>> across all socket states without touching the hash table mechanics
>>>>> during fallback/retry.
>>>>>
>>>>> Does this approach look good to you? If you agree, I will prepare and
>>>>> submit v5 with this change. Please let me know if you have any other
>>>>> suggestions or alternative approaches, and I'll be happy to look into them.
>>>>
>>>> What about this path ?
>>>>
>>>> smc_listen_decline() -> smc_listen_out_err(), where smc_conn_abort() has
>>>> already run, and the sock state is then changed from SMC_INIT to SMC_CLOSED.
>>>
>>> Hi Dust,
>>>
>>> Good catch on the smc_listen_out_err() path as well!
>>>
>>> In smc_listen_decline() -> smc_listen_out_err(), the server socket fails
>>> handshake and is transitioned to SMC_CLOSED while remaining in the hash
>>> table until smc_accept_dequeue() runs.
>>>
>>> Since userspace (smcss) skips displaying all connection, link-group, and
>>> DMB details for both SMC_INIT and SMC_CLOSED sockets (smcss.c:186 and
>>> smcss.c:199), we can update __smc_diag_dump() to check for both states:
>>>
>>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>>> --- a/net/smc/smc_diag.c
>>> +++ b/net/smc/smc_diag.c
>>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>>> sk_buff *skb,
>>> 	r->diag_state = sk->sk_state;
>>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>>> +		return 0;
>>> +
>>> 	if (smc->use_fallback)
>>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>>
>> 
>> I checked the code again, and I'm afraid adding SMC_CLOSED is still not right.
>> 
>> smc_listen_decline(): smc_switch_to_fallback(), smc_clc_send_decline() then
>> fails, and smc_listen_out_err() sets the socket to SMC_CLOSED. The socket
>> stays on the accept queue, hashed, until accept() reaches smc_accept_dequeue().
>> 
>> But the early return sits after nlmsg_put() but before diag_mode,
>> smc_diag_msg_attrs_fill() and the SMC_DIAG_FALLBACK attribute are filled.
>> The record is still emitted, but diag_mode is left at 0 -- which is
>> SMC_DIAG_MODE_SMCR, not "unknown" -- and the fallback reason attribute is gone.
>
>Regarding your concern about wrong output when the early return fires
>before diag_mode and SMC_DIAG_FALLBACK are filled: you are right that
>diag_mode must be filled before the guard. *smcss.c* reads diag_mode at
>lines 177 and 179 for --smcr/--smcd filtering, which happens before the
>SMC_INIT and SMC_CLOSED state checks. If diag_mode is left as 0 for
>a failed-fallback SMC_CLOSED socket, --smcr would incorrectly include it
>and --smcd would incorrectly exclude it.
>
>*SMC_DIAG_FALLBACK* however is *not* needed before the guard — smcss
>only reads it inside the diag_mode == SMC_DIAG_MODE_FALLBACK_TCP branch
>which is never reached for *SMC_INIT* or *SMC_CLOSED* sockets, as those
>two states hit goto newline before that point.

I don't agree on this.

Here what we are changing is the UAPI behaviour, which should not be
constrained by what smcss did.

And SMC_INIT can coexist with fallback. For example:

smc_sendmsg() calls smc_switch_to_fallback(SMC_CLC_DECL_OPTUNSUPP) under
MSG_FASTOPEN while sk_state is SMC_INIT and never changes it afterwards --
fastopen does not call connect(), so the state never goes to SMC_ACTIVE.

>
>So the correct placement is after smc_diag_msg_attrs_fill(), which fills
>diag_mode, diag_uid, and diag_inode, but before SMC_DIAG_FALLBACK:
>
>    r->diag_state = sk->sk_state;
>    if (smc->use_fallback)
>        r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>    else if (...)
>        ...
>    if (smc_diag_msg_attrs_fill(sk, skb, r, user_ns))
>        goto errout;
>
>+   if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>+       goto out;
>
>    fallback.reason = smc->fallback_rsn;
>    ...
>
>+out:
>    nlmsg_end(skb, nlh);
>    return 0;
>
>At this position all fields smcss reads for these two states are already
>filled correctly, including diag_mode for --smcr/--smcd filtering.  The
>CONNINFO, LGRINFO, and DMBINFO blocks — which contain the unsafe lgr/lnk
>dereferences — are never reached.
>
>What is your opinion on this?


I didn't have any better ideas to fix this issue with minimal changes.
So I agree that we can go with this the fix.



>> 
>> Why don't you use conn->free instead of sk_state ? It is set unconditionally
>> at the top of smc_conn_free() before any lgr/lnk reference is dropped.
>> 
>> 
>> So maybe something like this ? Please double check.
>> 
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..a19f16881ae7e 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -103,6 +103,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>         if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>                 goto errout;
>> 
>> +       if (smc->conn.freed)
>> +               goto out;
>> +
>
>Regarding conn->freed: it does not fully close the race. The check and
>the subsequent lgr/lnk dereferences in the LGRINFO/DMBINFO blocks are
>not atomic. The diag reader can pass the conn->freed == 0 check, then
>smc_conn_free() runs concurrently and calls smc_lgr_put() which may drop
>the lgr refcount to zero and free lgr, and then the reader resumes and
>dereferences conn->lgr — a UAF.

Your are right.


>
>>         if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>             smc->conn.alert_token_local) {
>>                 struct smc_connection *conn = &smc->conn;
>> @@ -185,6 +188,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>                         goto errout;
>>         }
>> 
>> +out:
>>         nlmsg_end(skb, nlh);
>>         return 0;
>> 
>> BTW, as we talked in the previous threads, the teardown path is messy and lots
>> of hidden holes, so I think we will finnally refine those.
>> As for now, if this works, I think we can go with it.
>
>I agree, as of now I am trying to fix the UAF bug with minimal changes.

Great!

Best regards,
Dust


Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5613B1CD1E4;
	Mon, 31 Aug 2026 12:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180230; cv=none; b=W1vdn8jtWxfy9nS+WjzKjEi5++MNcOrUkLh2mYhWgLJrXmyBnMQCcksOaS21INy4XNA/wnENpQY7EbUBj3FVPQ1EOXpANHagBpGYdorLBaRcHgGXojhs6MBXkVDMCz04R3JINbEzDZh7gQrP3GAsaaEtznZZOxhkd2fcP1qO1SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180230; c=relaxed/simple;
	bh=Qon2GcefADdCTNebfMC59ZmH2icWwE8zU8HWAUX9vVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgSNjX1G1bAiv4n+Cr/q8f64pHfyhGi0HwyqzzpPpuTPYQGbveWHyW6+AD82sab/bmYDORWuRntoOXWkUDBfFw9xlKAoT8qU2COJhWHvIuV8zCgvj9OAvEoDRH3XLfnDC7e+EuWsdJ58aGsJk7UzgyGg63p/m0Wl9GY/hcaUZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fNaQ1HOA; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fNaQ1HOA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788180219; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=UL2vDvxzkPaK73d2MOOzUisYqdbGkPmdsXRoPyCyMUk=;
	b=fNaQ1HOA6R2MQTP/yNnpmsjir/NQBxLpT2/hVn8PadzGn9TV0FzqOajJImJDVQrw3q0GboTEYBhUcGItHNPT9clC4lQmSyDxSfSIf0/hr5n3JY9KRpvl4Xmc9V/EwBwD4uBDXDeiagTXuND+i2u+E6mAS8lLU3K2Yn4zLEJtl/I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9yvHlE_1788180217;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X9yvHlE_1788180217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 20:43:38 +0800
Date: Mon, 31 Aug 2026 20:43:37 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: serialize clcsock teardown in
 smc_accept_dequeue
Message-ID: <apV2-XsGaE45KudZ@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260824065851.1070988-1-mjambigi@linux.ibm.com>
 <ao5bB9OCbJ5PQbEp@linux.alibaba.com>
 <bd56d983-e5bf-4343-910e-8965c3ff57dc@linux.ibm.com>
 <apBErK3BBw0KHd6Y@linux.alibaba.com>
 <d2b3f465-9ebb-4963-8dcd-3ec2969e9465@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2b3f465-9ebb-4963-8dcd-3ec2969e9465@linux.ibm.com>

On 2026-08-28 16:48:28, Mahanta Jambigi wrote:
>
>
>On 27/08/26 7:37 pm, Dust Li wrote:
>> On 2026-08-26 14:42:31, Mahanta Jambigi wrote:
>>>
>>>
>>> On 26/08/26 8:48 am, Dust Li wrote:
>>>> On 2026-08-24 08:58:51, Mahanta Jambigi wrote:
>>>>> smc_accept_dequeue() open-codes clcsock teardown for SMC_CLOSED child sockets
>>>>> without taking clcsock_release_lock:
>>>>>
>>>>>  new_sk->sk_prot->unhash(new_sk);
>>>>>  if (isk->clcsock) {
>>>>>      sock_release(isk->clcsock);
>>>>>      isk->clcsock = NULL;
>>>>>  }
>>>>>
>>>>> This bypasses the clcsock_release_lock discipline used elsewhere in SMC clcsock
>>>>> lifetime handling. In particular, other paths serialize clcsock access and
>>>>> updates with clcsock_release_lock, but this local teardown path does not.
>>>>>
>>>>> Fix it by taking clcsock_release_lock around the local teardown and by storing
>>>>> NULL before sock_release(), matching the established ordering used by other
>>>>> clcsock teardown paths.
>>>>>
>>>>> Fixes: 127f49705823 ("net/smc: release clcsock from tcp_listen_worker")
>>>>> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
>>>>> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>>>> ---
>>>>> net/smc/af_smc.c | 12 ++++++++----
>>>>> 1 file changed, 8 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>>>> index 00403175b740..bbf8269876ee 100644
>>>>> --- a/net/smc/af_smc.c
>>>>> +++ b/net/smc/af_smc.c
>>>>> @@ -1833,10 +1833,14 @@ struct sock *smc_accept_dequeue(struct sock *parent,
>>>>> 		smc_accept_unlink(new_sk);
>>>>> 		if (new_sk->sk_state == SMC_CLOSED) {
>>>>> 			new_sk->sk_prot->unhash(new_sk);
>>>>> -			if (isk->clcsock) {
>>>>> -				sock_release(isk->clcsock);
>>>>> -				isk->clcsock = NULL;
>>>>> -			}
>>>>> +			mutex_lock(&isk->clcsock_release_lock);
>>>>> +			if (isk->clcsock) {
>>>>> +				struct socket *clcsock = isk->clcsock;
>>>>> +
>>>>> +				isk->clcsock = NULL;
>>>>> +				sock_release(clcsock);
>>>>> +			}
>>>>> +			mutex_unlock(&isk->clcsock_release_lock);
>>>>
>>>> Why not call smc_clcsock_release() here ?
>>>
>>> I initially considered *smc_clcsock_release()*, but it unconditionally
>>> calls cancel_work_sync() for child sockets (since listen_smc is always
>>> set and current_work() != &smc->smc_listen_work is always true here).
>>> Even though smc_listen_work has already completed before
>>> smc_accept_enqueue() is called, cancel_work_sync() is not truly free on
>>> that path — it still acquires the worker pool spinlock and scans the
>>> executing-worker list before determining the work is idle. The inline
>>> open-coding avoids that overhead entirely.
>> 
>> OK
>
>For this patch specifically, the smc_accept_dequeue() path is a clear
>lock ordering violation that can cause a crash independently of the
>broader design issue — would you prefer I withdraw this patch and
>address everything together in the larger refactor, or keep this narrow
>fix and do the refactor separately?

I think you can keep this one for stable tree.

>
>> 
>>>
>>>>
>>>> After looking deeper into this issue, I found smc_diag_msg_common_fill()/
>>>> smc_getname() and many other branches hasn't hold lock_sock() and may also
>>>> have the race issue ? For example, smc_getname() calling smc->clcsock->ops->getname()
>>>> while the other workqueue is releasing the clcsock.
>>>
>>> I am addressing the smc_diag_msg_common_fill() issue via a separate
>>> patch[1].
>> 
>> What about other places that dereference clcsock, like smc_getname()/smc_set_keepalive() ?
>
>Yes, smc_getname(), smc_set_keepalive(), and all other unprotected
>clcsock dereferences would be fixed as part of this refactor, and in
>fact they are the strongest argument for doing it.
>
>The reason they become safe is structural, not incremental: once
>sock_release(clcsock) is deferred to the SMC socket destructor, clcsock
>is guaranteed non-NULL for the entire observable lifetime of the SMC
>socket. Any caller that holds a sock reference — whether it is a syscall
>path, a workqueue, or a timer callback — is by definition executing
>before the destructor runs. So smc_getname(), smc_set_keepalive(),
>smc_poll(), smc_diag_msg_common_fill(), and every other reader can
>dereference clcsock directly with no lock and no NULL check, and all the
>if (smc->clcsock) guards become dead code that can be removed.
>
>clcsock_release_lock itself would also be removed entirely, along with
>all its lock/unlock sites, since the mutex only exists to coordinate
>multiple sock_release() callers — a problem that disappears when there
>is only one.

Yeah, this is exactly what I expected for the refactor.


>
>>>>
>>>> Since SMC has long been plagued by this kind of locking issue, I think we
>>>> should consider a long-term solution to address it.
>>>>
>>>> What about stop releasing the clcsock early and tie its lifetime to the SMC
>>>> socket itself. The early paths don't really need to release it ??? a
>>>> kernel_sock_shutdown()/tcp_abort() is enough to stop it, and calling them more
>>>> than once is safe because the TCP layer already handles that.  sock_release()
>>>> is different: it frees the socket, so it must happen exactly once. If we move
>>>> this single release to the final teardown of the SMC socket, no user can exist
>>>> at that point anymore (fd users are gone after smc_release(), and every
>>>> work/accept-queue context holds a sock reference), which makes both
>>>> clcsock_release_lock and all the if (smc->clcsock) NULL checks removable.
>>>>
>>>> Ideas ?
>>>
>>> I agree, but it is a significant refactor touching every early-release
>>> path in af_smc.c, smc_close.c etc & it warrants its own patch series
>>> with careful ordering of changes.
>> 
>> Yes, that should be a bit refactor, are you interested in doing that ?
>
>Sure, I can take that up. It will need a bit of careful work — the close
>state machine has multiple paths that currently call
>smc_clcsock_release() early, and the smc_tcp_listen_work() error path
>where kernel_accept() creates a clcsock that is never assigned to an SMC
>socket will need special handling. I would plan to send it as a small
>series rather than a single patch.

That's perfectly fine.

>
>I am currently occupied with a few other things so it may take some
>time, but I will pick it up once I have bandwidth. If you have any
>specific ideas on the approach or would like to co-develop it, I am very
>happy to collaborate — feel free to share your thoughts and we can work
>through the design together.

I shared my thoughts with my agent and had it implement a draft version for
me — let me send it over so you can take a look, and we can figure out how
to move forward together.

Best regards,
Dust

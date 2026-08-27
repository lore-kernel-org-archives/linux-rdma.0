Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E913847424F;
	Thu, 27 Aug 2026 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839995; cv=none; b=mS5ZA/C4Xue3WB6dZBtKtYAaAbhYPmK9E/ubkwcmOsZ3dmlOtKyjoxR8BpWxSPPvfsg0QZplwnLT8kGxsmDp+FTpsrQcg/luXXYd1zEihxNPFHsehxXdGozdjHoMV9Y8ip0qRfVWYwqpr+swRuM7Eo5nRZBmM79cGg9xwKTXCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839995; c=relaxed/simple;
	bh=qgoTk0FffKkqSpgQvoC0WiZvAqC3Sczemg8Y1gXFwzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aa24add7BPW3S1vNPsu5VA4mCpKttGjPHJFHaViJ42IwNbnQvvjgEMhlSthH/FmX2luO2biey7uNZBSXHXXYyMAqK/fQZxZychIdzdmTh0qm1lud7ZIxAlBeVxs3S71TWjGI5I8Av++I7xhyNoWG7eKveoHhubeIq3cMCyRa+6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q4UtTmqE; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q4UtTmqE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787839986; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=F6giDRd0p/yf7qoIy3FaS4PKsSAbcJZMzUCM/HAW+00=;
	b=q4UtTmqEPO/YZApv0sR3Zll9k9ZBBfq3EeLiBMEcid2nanA2J5o4CVfsuVxWzIo5BdLEfcPxOmIIdd5igbaw0N8R4vtBq+J3IamXvrHFcYmhIzeoH3Gi5lB0SFmtLAR8F14Gpz8g/3/qGSytKPJzBQ1Gb4ehMzu+4TRd/ScGIXg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9jskyo_1787839660;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X9jskyo_1787839660 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 22:07:41 +0800
Date: Thu, 27 Aug 2026 22:07:40 +0800
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
Message-ID: <apBErK3BBw0KHd6Y@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260824065851.1070988-1-mjambigi@linux.ibm.com>
 <ao5bB9OCbJ5PQbEp@linux.alibaba.com>
 <bd56d983-e5bf-4343-910e-8965c3ff57dc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd56d983-e5bf-4343-910e-8965c3ff57dc@linux.ibm.com>

On 2026-08-26 14:42:31, Mahanta Jambigi wrote:
>
>
>On 26/08/26 8:48 am, Dust Li wrote:
>> On 2026-08-24 08:58:51, Mahanta Jambigi wrote:
>>> smc_accept_dequeue() open-codes clcsock teardown for SMC_CLOSED child sockets
>>> without taking clcsock_release_lock:
>>>
>>>  new_sk->sk_prot->unhash(new_sk);
>>>  if (isk->clcsock) {
>>>      sock_release(isk->clcsock);
>>>      isk->clcsock = NULL;
>>>  }
>>>
>>> This bypasses the clcsock_release_lock discipline used elsewhere in SMC clcsock
>>> lifetime handling. In particular, other paths serialize clcsock access and
>>> updates with clcsock_release_lock, but this local teardown path does not.
>>>
>>> Fix it by taking clcsock_release_lock around the local teardown and by storing
>>> NULL before sock_release(), matching the established ordering used by other
>>> clcsock teardown paths.
>>>
>>> Fixes: 127f49705823 ("net/smc: release clcsock from tcp_listen_worker")
>>> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
>>> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>> ---
>>> net/smc/af_smc.c | 12 ++++++++----
>>> 1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>> index 00403175b740..bbf8269876ee 100644
>>> --- a/net/smc/af_smc.c
>>> +++ b/net/smc/af_smc.c
>>> @@ -1833,10 +1833,14 @@ struct sock *smc_accept_dequeue(struct sock *parent,
>>> 		smc_accept_unlink(new_sk);
>>> 		if (new_sk->sk_state == SMC_CLOSED) {
>>> 			new_sk->sk_prot->unhash(new_sk);
>>> -			if (isk->clcsock) {
>>> -				sock_release(isk->clcsock);
>>> -				isk->clcsock = NULL;
>>> -			}
>>> +			mutex_lock(&isk->clcsock_release_lock);
>>> +			if (isk->clcsock) {
>>> +				struct socket *clcsock = isk->clcsock;
>>> +
>>> +				isk->clcsock = NULL;
>>> +				sock_release(clcsock);
>>> +			}
>>> +			mutex_unlock(&isk->clcsock_release_lock);
>> 
>> Why not call smc_clcsock_release() here ?
>
>I initially considered *smc_clcsock_release()*, but it unconditionally
>calls cancel_work_sync() for child sockets (since listen_smc is always
>set and current_work() != &smc->smc_listen_work is always true here).
>Even though smc_listen_work has already completed before
>smc_accept_enqueue() is called, cancel_work_sync() is not truly free on
>that path — it still acquires the worker pool spinlock and scans the
>executing-worker list before determining the work is idle. The inline
>open-coding avoids that overhead entirely.

OK

>
>> 
>> After looking deeper into this issue, I found smc_diag_msg_common_fill()/
>> smc_getname() and many other branches hasn't hold lock_sock() and may also
>> have the race issue ? For example, smc_getname() calling smc->clcsock->ops->getname()
>> while the other workqueue is releasing the clcsock.
>
>I am addressing the smc_diag_msg_common_fill() issue via a separate
>patch[1].

What about other places that dereference clcsock, like smc_getname()/smc_set_keepalive() ?


>
>> 
>> Since SMC has long been plagued by this kind of locking issue, I think we
>> should consider a long-term solution to address it.
>> 
>> What about stop releasing the clcsock early and tie its lifetime to the SMC
>> socket itself. The early paths don't really need to release it ??? a
>> kernel_sock_shutdown()/tcp_abort() is enough to stop it, and calling them more
>> than once is safe because the TCP layer already handles that.  sock_release()
>> is different: it frees the socket, so it must happen exactly once. If we move
>> this single release to the final teardown of the SMC socket, no user can exist
>> at that point anymore (fd users are gone after smc_release(), and every
>> work/accept-queue context holds a sock reference), which makes both
>> clcsock_release_lock and all the if (smc->clcsock) NULL checks removable.
>> 
>> Ideas ?
>
>I agree, but it is a significant refactor touching every early-release
>path in af_smc.c, smc_close.c etc & it warrants its own patch series
>with careful ordering of changes.

Yes, that should be a bit refactor, are you interested in doing that ?

Best regards,
Dust

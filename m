Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2DE30B517;
	Tue,  8 Sep 2026 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788837761; cv=none; b=p9U+ne3HFO/G0WxmKLdEQzOfL+RjZfGOAYjhewrVV0g+1SFpvmUY2Z769/D3jOSAYhcWYE7xq053gwRADw5y4E6Rk+WFLX3TejuVp5TP8UNygAdLYBUtQaV7gtVSjGLhysz/5Splbs8N+GR+MZX/5IubYGcOb7qVq8sZdVbKyXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788837761; c=relaxed/simple;
	bh=Itk99Hsm4qcvis/e8VoZg8ExIu1OKk5Wvvy4gGx1KQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxC1GZLlrb3j9jx2anAWR4vQz7QL3Sgu8aLg9bN5s7uIbNwSS3BehxZ2xDyhJS395cSRPbXdSW0bMSkR25lGZT+K+MdmCQkA5Utfk+rEl2COscaHNJW4SAzkaOmuEXQ22Zp8RpVrdj8YpycCIgVjWTY3xWOF5rUBE5X1tEFq5bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j6DXNnJt; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j6DXNnJt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788837754; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=+/kMDDLkf7Y6JJc45zDEOVV2sG3ehocg7qxV9pm6GCI=;
	b=j6DXNnJtGVrKr+6BzNin0gKcleo3sE56PzsnAkT5prDcbTkpedEgYqDOKTLtmkaWB1GhUGKFE73td2PATF5mSQu740ABDUbV/ty1IsuBwMKfLvlsmAq4h4fE7kQGq+pR7HbCrogSbv8sW3bUKjxdWcMt528TyOdu1BnLf4prvGU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAa8pVd_1788837753;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XAa8pVd_1788837753 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 11:22:33 +0800
Date: Tue, 8 Sep 2026 11:22:33 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Hidayath Khan <hidayath@linux.ibm.com>, alibuda@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
	andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: fix abort_work termination in
 smc_conn_free()
Message-ID: <ap9_eZanOQkbYZVB@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260907114721.1303498-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907114721.1303498-1-hidayath@linux.ibm.com>

On 2026-09-07 13:47:21, Hidayath Khan wrote:
>smc_conn_free() disposes of a pending conn->abort_work, but it gets three
>things wrong:
>
>1. Deadlock: smc_conn_free() runs with the socket lock held and calls
>   cancel_work_sync(), while smc_conn_abort_work() takes the same lock.
>   If the work has already started on another CPU and is waiting for that
>   lock, the cancel waits for the work and the work waits for the caller.
>   The current_work() test only stops the work from cancelling itself,
>   not when the two run on different CPUs.
>
>2. Reference leak: Schedulers of abort_work take a socket reference, and
>   smc_conn_abort_work() drops it when it runs. If cancel_work_sync()
>   removes a pending work item before it runs, that reference is never
>   returned and the socket is never freed.
>
>Both are fixed the way smc_close_cancel_work() handles close_work: drop
>the socket lock around the cancel, and release the reference when the
>cancel reports that it removed a pending item.
>
>3. Late-queued work race: smc_cdc_rx_handler() finds the connection and
>   drops lgr->conns_lock before smc_cdc_msg_validate() decides to queue:
>
>     CPU0 (smc_conn_free)              CPU1 (smc_cdc_rx_handler)
>                                       conn = smc_lgr_find_conn()
>                                       sock_hold()
>                                       read_unlock_bh(&lgr->conns_lock)
>     cancel_work_sync()                  /* nothing queued yet */
>     smc_buf_unuse()
>                                       smc_cdc_msg_validate()
>                                         queue_work(&conn->abort_work)
>
>   cancel_work_sync() only guarantees that the work is not pending or
>   running when it returns; a racing enqueue lands after that. The work
>   then calls smc_conn_kill() on a connection whose buffers have already
>   been returned.
>
>Nothing smc_conn_free() does can prevent that enqueue, because the
>receiver already holds the connection pointer. Make the late work
>harmless instead: smc_conn_free() sets conn->freed with the socket lock
>held before it releases anything, and smc_conn_abort_work() takes the same
>lock. Check conn->freed inside smc_conn_abort_work() to skip
>smc_conn_kill() if teardown has started. The work still drops its socket
>reference.
>
>Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
>Cc: stable@vger.kernel.org
>Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>

Hi Hidayath,

Thanks for the fix. I think this is the right fix, and we can go ahead
and fix it this way for now.

Mahanta's smc_diag dump fix may need some rework on top of this one.

I believe the refactor I discussed with Mahanta in another thread would
address the root cause of these bugs more cleanly:
https://lore.kernel.org/netdev/apriDec7yHBkQgNv@linux.alibaba.com/

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust


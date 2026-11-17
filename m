Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904521;
	b=od+r8xu0ipOaoioqQmr99edxgcDJEEUmUJwkz8M7ScAw1hsQEwbYtx8jYUYOSdTpS8XD
	 xOle5Q2rnYxB2KZnMmuTW9Ono8HZwif2F+FFfoNL2u4k35//pCl60mlYpHDIyIOff0E9W
	 18pNFmNA5w+fslH9KRlL4X3pblNdNu+3OUjfAb0VVsW/INpFXQ/UsiSP6YqSUmfQv3eNy
	 VnZHwSJRiWiQFdOBJyma85v2hXo2MKTB63/7RKeeUB0lrBjW3f1E6pyGKsoBOgk9siHIF
	 aCOV5337VKI+xzJS3YRlWZXAMZZabPh5D/SDIoPY5d5NT9vdln0LzWVb0bbyzVH+3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904521;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=rFi9I5t2exAzyHDuda6uvYh1L6vcjp/5ii4dTULm/YM=;
	b=yIt1NZa7ZCvo7UXVQqH5EdL+JVML5y0fwJxjpELchnenK9f3mqJkdwdJVeRPu4qIYKXn
	 A11hzq4vRKxx31UX3HFJuWaYQ7XglTkQ440G0JTAlKz0uFnqfCLpEH+dRWBiu9tEgQPDz
	 I7qDUwraKowIPOfiWkDYLXL64u3Tfze+et2BrH/YpqPAZcxDlDLKPiQCLSWfm27FTQ+js
	 hfDumUF4cBhnNI+cNyj8DoABYGj3XwR5tc4cdpE7moZJOHL3G1WUzP/w7nw9Ml4WFOIqz
	 VE+sGcOhic5gKGsxmsi/s3a9yzzsD24kFS3ChsEAsVq3tu9hAT2gLg0GSS20HD7Fc4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLBowRMY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B614D606A89F;
	Tue, 17 Nov 2026 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLBowRMY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91161F000CB;
	Tue, 17 Nov 2026 08:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794904521;
	bh=rFi9I5t2exAzyHDuda6uvYh1L6vcjp/5ii4dTULm/YM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TLBowRMYC//cKiaOx0eCzhWAxcp8lpAcRXZ+PsisfFJ5tOQ7gAWpkK0OHFKfX0gRQ
	 RLg61gvu5c2uz5s2My6MjvYEQdSKBzdgT6hR5m1bQmt+0dHvVxyiDNFgrsHIWhS1LJ
	 xKi6Ak/Di9XhwebzfWzDFF4vUPBVxHuwW799Z3OGHD5gedWkIPdG0f+dzJ6/BsTdls
	 4up63DCafsvs6G0k28eDsQwc370IrQzk1ioVDkppsXq7OqAcanVzLXsC2cIT5vd008
	 5RTCVHGG+Z/GLZ4HUMDPKy4zOqG+VnugCWuli6nFe6lve4wgcTGlK4Cq5hjpghbUH2
	 XgMZd1rldxXiA==
Subject: Re: [PATCH net v2] net/rds: defer CM id destruction to a workqueue
From: netdev-bot+sashiko@kernel.org
To: chenaibing@cmss.chinamobile.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Tue, 17 Nov 2026 08:35:20 +0000
Message-ID: <179490452051.3136.18322831263977968329@kernel.org>
In-Reply-To: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
References: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The lock cycle this patch is meant to fix can still happen.
- [Medium] After this patch, each probe RDMA CM id created by
  rds_ib_laddr_check_cm() stays alive after bind() returns, until…

--

net/rds: defer CM id destruction to a workqueue

The patch moves rdma_destroy_id() on the probe cm_id in
rds_ib_laddr_check_cm() onto rds_wq. The goal is to break the lockdep
cycle between rds_trans_sem and handler_mutex. If the work item cannot
be allocated, the id is still destroyed synchronously, and rds_ib_exit()
now flushes rds_wq.

Closes: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..66af4a72a5595 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c

[ ... ]

> @@ -419,6 +434,15 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
>  			       NULL, RDMA_PS_TCP, IB_QPT_RC);
>  	if (IS_ERR(cm_id))
>  		return PTR_ERR(cm_id);
> +
> +	/*
> +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls this
> +	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
> +	 * takes handler_mutex, which the CM callback path acquires before
> +	 * taking rds_trans_sem.  If the allocation fails, fall back to the
> +	 * synchronous destroy.
> +	 */
> +	w = kzalloc_obj(*w, GFP_KERNEL);

[Severity: High]
If kzalloc_obj() fails here, the out: label calls rdma_destroy_id()
directly. Doesn't that still run inside the down_read(&rds_trans_sem)
section of rds_trans_get_preferred()?

rds_bind()
  rds_trans_get_preferred()
    down_read(&rds_trans_sem)
    rds_ib_laddr_check()
      rds_ib_laddr_check_cm()
        kzalloc_obj() fails
        rdma_destroy_id()
          mutex_lock(&id_priv->handler_mutex)

That is the same rds_trans_sem -> handler_mutex dependency that lockdep
reported. The other half of the cycle is handler_mutex -> rds_trans_sem,
taken via cma_ib_req_handler() -> rds_conn_create(). If a writer such as
rds_trans_register() or rds_trans_unregister() is queued on the rwsem,
this can also hang.

The commit message says:

    if the allocation fails, the id is destroyed synchronously as before.

"As before" is the behaviour that produced the original report. The
allocation failure is also easy to trigger with failslab, which is what
syzbot uses.

Could the work item be allocated before rdma_create_id(), with -ENOMEM
returned if that fails? rds_trans_get_preferred() already treats any
non-zero laddr_check() result as "not this transport". rds_bind()
already maps that to -EADDRNOTAVAIL or -ENOPROTOOPT, so no new error
handling should be needed.

>  	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
>  	if (ret)
>  		goto out;
> @@ -484,7 +508,13 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
>  		 cm_id->device ? cm_id->device->node_type : -1);
>  
>  out:
> -	rdma_destroy_id(cm_id);
> +	if (w) {
> +		INIT_WORK(&w->work, rds_ib_destroy_id_work);
> +		w->cm_id = cm_id;
> +		queue_work(rds_wq, &w->work);

[Severity: Medium]
With the destroy deferred, each probe cm_id stays alive after bind()
returns, until rds_ib_destroy_id_work() runs. What limits how many of
these can be pending?

rds_threads_init() creates rds_wq with
create_singlethread_workqueue("krdsd"). That makes it an ordered queue
with one worker, shared with the connection, shutdown and free work for
all of RDS.

An unprivileged user can call bind() on AF_RDS sockets in a loop. The
call reaches laddr_check() either through rs_transport (set via
SO_RDS_TRANSPORT) or through rds_trans_get_preferred().

A failed bind leaves the socket unbound. Each attempt with an IPv6
address, or with an IPv4 address not yet in rds_ibdev->ipaddr_list,
queues another item. Producers on several CPUs feed one consumer. That
consumer also contends on the global cma lock mutex and sits behind any
slow RDS work.

Each pending item holds the rdma_id_private and the
struct rds_ib_destroy_work. The latter is allocated with GFP_KERNEL and
no __GFP_ACCOUNT, so it is not charged to the caller's memcg.

If rdma_bind_addr_dst() got far enough, the item also holds two more
things:
- a cma_dev reference from cma_acquire_dev_by_src_ip()
- an ephemeral port in the shared RDMA_PS_TCP space from cma_get_port()

Before this patch, all of these were released before the syscall
returned.

Could a backlog here pin memory, use up ephemeral RDMA_PS_TCP ports
needed by other in-kernel users (NVMe-oF/RDMA, iSER, NFS/RDMA), and
delay IB device removal? cma_process_remove() waits here until every
pending destroy has run:

	wait_for_completion(&cma_dev->comp);

> +	} else {
> +		rdma_destroy_id(cm_id);
> +	}
>  
>  	return ret;
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116075423.782-1-chenaibing%40cmss.chinamobile.com

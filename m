Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250252;
	b=y0sZEeUWVnDjx13i23UC4UMKIHBDDA0d5s/b/6IbRLnemMigwayU4Ses/wB3B2GGoEZl
	 s5Y+MGeZ9eTLnjJkr1tVIMXCyeo8Ops4VMJOzP3bu2LNz4a2/PCkCkk0IZtIZ5WfaCjs+
	 qM5jXAzRfRSmnzlIqhXA4xSwk9f38BGdEc7jXsocfFsKV44i2cTIXb5M+cvuBhnLTZzNe
	 Lp3EMEZMcp6FZGtqt0z+u1digQDlfsO2kk659XTuhjmZs9rKRQJ82Y2CuNqvnqGeJPs11
	 T12arhUfXUm2O+zP4YEILRidemdizkW0aK+sO4G8QF3bmZ81aTuziNtLXkh1I5Y5gDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250252;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=k91HK40mTtE/BmAJ1Mcvc81qH3uQcXvyFodm9y1hP/w=;
	b=Z0eLUr7MHut0j3RvuLvcyAoTqnV15N0vvkpO/goIX7e3Ug8zTRJQMoaAWNyVPi4HBXqX
	 q2uKOjDB+HC/edkSKgXYsPDUItlao/y9OVaGRrf522+YQVuYoTffHYJAlY1EL62fQoYT/
	 WPSwqxin/E+O3H+/aZeuoaM0QksiA3xGAVHBdYsIWmS9ytkVMyVOY7IwQvkPeOifbwDI/
	 PvMkq9szC/639IleAjW8KjwS1/D+Ntid8g/R9pdWpxK3xV5kp0ATjgnCzrdLSTWXktrYO
	 5pHRzr5kdZ6Nwza7HgravRgGOCaAw6RLeezuCfCDlIxXToUyeLNHh64DfpWQS68NfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4kJ3hp9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5D606A320;
	Sat, 21 Nov 2026 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4kJ3hp9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6541F000C0;
	Sat, 21 Nov 2026 08:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795250252;
	bh=k91HK40mTtE/BmAJ1Mcvc81qH3uQcXvyFodm9y1hP/w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Q4kJ3hp9MJdTqS0w3N6iqenk9ff9yLPLt19Aj4YCaUxEFxFTKqW7MJ5d1111H8aPo
	 N0MjvteCaWfDHkRnC3EPR+bNF72NsQyczNgtlfn9jP5S6vCIqRhpZQI38gX3zb/vQV
	 wHDrHDgPCq0Pfy8BkMfY/mtkgJml/tTA9KbnmHRl5deTLTuRRirTADeQ2GwbMI3unv
	 MzQBhNMyvQvtWfJY9jQiGk0edycdJNAlULRfK3Jxz7a59cX/ifaFtJ3jQ8qaJCZjQZ
	 FRcziVpG+QBvNPY32h2i18LhlW1AeruE/+m9PF5khB9vgVm7O9JOWHl6WguYaW1pEp
	 /ZktjJLIYQK3A==
Subject: Re: [PATCH net v3] net/rds: defer CM id destruction to a workqueue
From: netdev-bot+sashiko@kernel.org
To: chenaibing@cmss.chinamobile.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2026 08:37:31 +0000
Message-ID: <179525025125.3135.10066600297379507793@kernel.org>
In-Reply-To: <20261117082145.1737-1-chenaibing@cmss.chinamobile.com>
References: <20261117082145.1737-1-chenaibing@cmss.chinamobile.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Each call to rds_ib_laddr_check_cm() (net/rds/ib.c) now
  allocates a work item (kzalloc_obj(*w, GFP_KERNEL), line 439) and an…

--

net/rds: defer CM id destruction to a workqueue

This commit moves the rdma_destroy_id() call in rds_ib_laddr_check_cm()
to a work item on rds_wq, so rds_trans_sem is released before
handler_mutex is taken. The work item is allocated before the CM id is
created, and the address check fails with -ENOMEM if that allocation
fails. rds_ib_exit() now flushes rds_wq after unregistering the transport.

Closes: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..44b46defa1ae0 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c

[ ... ]

> @@ -411,14 +425,28 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,

[ ... ]

> +	w = kzalloc_obj(*w, GFP_KERNEL);
> +	if (!w)
> +		return -ENOMEM;
> +
>  	/* Create a CMA ID restricted to IB devices and try to bind it. */
>  	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
>  			       NULL, RDMA_PS_TCP, IB_QPT_RC);

[ ... ]

> @@ -484,7 +512,9 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
>  		 cm_id->device ? cm_id->device->node_type : -1);
>  
>  out:
> -	rdma_destroy_id(cm_id);
> +	INIT_WORK(&w->work, rds_ib_destroy_id_work);
> +	w->cm_id = cm_id;
> +	queue_work(rds_wq, &w->work);
>  
>  	return ret;
>  }

[Severity: Medium]
Is there anything that limits how many of these destroys can be pending?

Before this change, rdma_destroy_id() ran synchronously. The number of
live cm_ids could never exceed the number of threads inside bind() at
that moment.

Now each call keeps two objects allocated until the krdsd worker gets to
the item: the work item and the rdma_id_private from rdma_create_id().
The caller returns right away, so the producer gets no backpressure.

An unprivileged user can reach this by calling bind() in a loop on an
AF_RDS socket, using an address that no IB device owns:

rds_bind()
  rds_trans_get_preferred()
    rds_ib_laddr_check()
      rds_ib_laddr_check_cm()
        kzalloc_obj(*w, GFP_KERNEL)
        rdma_create_id()
        ...
        queue_work(rds_wq, &w->work)

A failed laddr_check leaves the socket unbound, so the same socket can
call bind() again at once. The rds_rdma module has to be loaded, but it
can be autoloaded through SO_RDS_TRANSPORT.

Neither allocation uses __GFP_ACCOUNT. Could the pending objects pile up
as kernel memory that is never charged to the caller's memcg?

rds_threads_init() creates rds_wq with
create_singlethread_workqueue("krdsd"). That leaves one ordered worker to
drain items that can be queued from many CPUs.

The same workqueue also handles other RDS work:

- the cp_wq for RDS IB and TCP connection paths
- the TCP accept worker
- message unpin work
- rds_ib_dev_free()

Could a backlog of destroy items hold up connection, accept and teardown
work for every RDS user on the system?

When rdma_bind_addr() succeeds (for example IPv6 on IPoIB), each pending
cm_id also holds an RDMA_PS_TCP port until its destroy runs.

There are a few possible ways around this:

- return the cm_id to the caller and destroy it after
  up_read(&rds_trans_sem)
- limit the number of in-flight destroys
- use a dedicated unordered workqueue and add __GFP_ACCOUNT

Would one of these work here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117082145.1737-1-chenaibing%40cmss.chinamobile.com

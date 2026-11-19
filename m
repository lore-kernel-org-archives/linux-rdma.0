Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795070029;
	b=eMFKH4rUYnRQ4t88pW/ET1R+NYKFdzpAftq5LkWCNjGWxR/xdXY+wNU0wXP5QVki2TsP
	 JOaY3pcr+f7w7VMXE4B5+U/O3pM70tRLcfZW9k3O97/XBogwgQlDmfUrB/zfaCgbWU2vi
	 JdoqtwtYGZDng2BQzlE79DEebaAbw5Dafy/viV+6FnpGKYIK1M/2fvxfZnop4FV5Skx7d
	 GRVW2lciYgVYkWTg4iMtyaGv4yJRx+E4jWCHaJjS6fLMf1Cto4K64UMFb8glpqd3RNnQO
	 ZFy1g8JthHobU8LpOeQ4RMulpYHzA8rjjZ1WEmFROrIj/MLd3LTRDuQHVRhL4Y0hktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795070029;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=Z6U9zB+kVSL5/rIaYC5amOQy+hf11/wJMrdBLlaOUtQ=;
	b=Cddi5d9qgD9qZodmEDQxFI+fpOTfFWJpwgUraioqQgWVLMl1dFJdU/4zLQ0CMPC7T5xY
	 w8QhSJXu2B1G297j0Tl+llPrqwnjV1NiViexmW7kUQXa/7k7DQLMUuzjsflT/C55v8T38
	 g75JAE6Ku5PHepjiQQTEj166W75RjfYoaekveWx2lr7yhqNoa+wm8i+i8NuQjfHONYavd
	 A96LdhNiy5q5/0fuUJ36Sn0cFMdlYpcl2g7G/FFuthz23+2gp2BxLCOWLhSK5vnsfA5r6
	 UsyJ6Ld+TfFYHkdDRSDo8XKIoCCU+FkRSyRRvZMFKeiyGKAAfKuNioiveHquCnmh1mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CF+ERc+H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80F606A320;
	Thu, 19 Nov 2026 06:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CF+ERc+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B931F000C4;
	Thu, 19 Nov 2026 06:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795070028;
	bh=Z6U9zB+kVSL5/rIaYC5amOQy+hf11/wJMrdBLlaOUtQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CF+ERc+HuHNVBCVPKikPUJcJfXWyZJ04AVdcXtH8iTv8jb/uM/O5TsqoD0HkKxIU/
	 boMUuS6NBbgSsXEqM2F93H5KtSzUu7AmddHMi5PLWS+koXCLUU/5CmmD8Gh216NhEo
	 yOUqQfZ1oZX73mltJH/e6tDs+42laVW3D4eyNLnWufbs4br248xC6EOeWqAronSp9h
	 JFegFBjHCrpgIzoKRZzHogcbdOeyn6an1wS3ndk+ULJezB2WAELQ35aW5r6lcpGaM3
	 IcNnYy42AN3RPQlxiDb6S2/Wh4Iqvn9o7OGWXte7twqmKNqGZ7wvDYxn4lkA9QRPsY
	 X8ko7gZHrwuSg==
Message-ID: <1065d21dbab9fdcbe3a34e2f3b1deac934b4a5ce.camel@kernel.org>
Subject: Re: [PATCH net v2] net/rds: defer CM id destruction to a workqueue
From: Allison Henderson <achender@kernel.org>
To: netdev-bot+sashiko@kernel.org, chenaibing@cmss.chinamobile.com
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2026 23:33:47 -0700
In-Reply-To: <179490452051.3136.18322831263977968329@kernel.org>
References: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
	 <179490452051.3136.18322831263977968329@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-17 at 08:35 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>=20
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 0
>=20
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>=20
> - [High] The lock cycle this patch is meant to fix can still happen.
> - [Medium] After this patch, each probe RDMA CM id created by
>   rds_ib_laddr_check_cm() stays alive after bind() returns, until=E2=80=
=A6
>=20
> --
>=20
> net/rds: defer CM id destruction to a workqueue
>=20
> The patch moves rdma_destroy_id() on the probe cm_id in
> rds_ib_laddr_check_cm() onto rds_wq. The goal is to break the lockdep
> cycle between rds_trans_sem and handler_mutex. If the work item cannot
> be allocated, the id is still destroyed synchronously, and rds_ib_exit()
> now flushes rds_wq.
>=20
> Closes: https://syzkaller.appspot.com/bug?extid=3Dccdb5058c3df2d94811c
>=20
> > diff --git a/net/rds/ib.c b/net/rds/ib.c
> > index 4ea9838d090c3..66af4a72a5595 100644
> > --- a/net/rds/ib.c
> > +++ b/net/rds/ib.c
>=20
> [ ... ]
>=20
> > @@ -419,6 +434,15 @@ static int rds_ib_laddr_check_cm(struct net *net, =
const struct in6_addr *addr,
> >  			       NULL, RDMA_PS_TCP, IB_QPT_RC);
> >  	if (IS_ERR(cm_id))
> >  		return PTR_ERR(cm_id);
> > +
> > +	/*
> > +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls t=
his
> > +	 * function with rds_trans_sem held for reading, and rdma_destroy_id(=
)
> > +	 * takes handler_mutex, which the CM callback path acquires before
> > +	 * taking rds_trans_sem.  If the allocation fails, fall back to the
> > +	 * synchronous destroy.
> > +	 */
> > +	w =3D kzalloc_obj(*w, GFP_KERNEL);
>=20
> [Severity: High]
> If kzalloc_obj() fails here, the out: label calls rdma_destroy_id()
> directly. Doesn't that still run inside the down_read(&rds_trans_sem)
> section of rds_trans_get_preferred()?
>=20
> rds_bind()
>   rds_trans_get_preferred()
>     down_read(&rds_trans_sem)
>     rds_ib_laddr_check()
>       rds_ib_laddr_check_cm()
>         kzalloc_obj() fails
>         rdma_destroy_id()
>           mutex_lock(&id_priv->handler_mutex)
>=20
> That is the same rds_trans_sem -> handler_mutex dependency that lockdep
> reported. The other half of the cycle is handler_mutex -> rds_trans_sem,
> taken via cma_ib_req_handler() -> rds_conn_create(). If a writer such as
> rds_trans_register() or rds_trans_unregister() is queued on the rwsem,
> this can also hang.
>=20
> The commit message says:
>=20
>     if the allocation fails, the id is destroyed synchronously as before.
>=20
> "As before" is the behaviour that produced the original report. The
> allocation failure is also easy to trigger with failslab, which is what
> syzbot uses.
>=20
> Could the work item be allocated before rdma_create_id(), with -ENOMEM
> returned if that fails? rds_trans_get_preferred() already treats any
> non-zero laddr_check() result as "not this transport". rds_bind()
> already maps that to -EADDRNOTAVAIL or -ENOPROTOOPT, so no new error
> handling should be needed.
>=20
> >  	ret =3D rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
> >  	if (ret)
> >  		goto out;
> > @@ -484,7 +508,13 @@ static int rds_ib_laddr_check_cm(struct net *net, =
const struct in6_addr *addr,
> >  		 cm_id->device ? cm_id->device->node_type : -1);
> > =20
> >  out:
> > -	rdma_destroy_id(cm_id);
> > +	if (w) {
> > +		INIT_WORK(&w->work, rds_ib_destroy_id_work);
> > +		w->cm_id =3D cm_id;
> > +		queue_work(rds_wq, &w->work);
>=20
> [Severity: Medium]
> With the destroy deferred, each probe cm_id stays alive after bind()
> returns, until rds_ib_destroy_id_work() runs. What limits how many of
> these can be pending?
>=20
> rds_threads_init() creates rds_wq with
> create_singlethread_workqueue("krdsd"). That makes it an ordered queue
> with one worker, shared with the connection, shutdown and free work for
> all of RDS.
>=20
> An unprivileged user can call bind() on AF_RDS sockets in a loop. The
> call reaches laddr_check() either through rs_transport (set via
> SO_RDS_TRANSPORT) or through rds_trans_get_preferred().
>=20
> A failed bind leaves the socket unbound. Each attempt with an IPv6
> address, or with an IPv4 address not yet in rds_ibdev->ipaddr_list,
> queues another item. Producers on several CPUs feed one consumer. That
> consumer also contends on the global cma lock mutex and sits behind any
> slow RDS work.
>=20
> Each pending item holds the rdma_id_private and the
> struct rds_ib_destroy_work. The latter is allocated with GFP_KERNEL and
> no __GFP_ACCOUNT, so it is not charged to the caller's memcg.
>=20
> If rdma_bind_addr_dst() got far enough, the item also holds two more
> things:
> - a cma_dev reference from cma_acquire_dev_by_src_ip()
> - an ephemeral port in the shared RDMA_PS_TCP space from cma_get_port()
>=20
> Before this patch, all of these were released before the syscall
> returned.
>=20
> Could a backlog here pin memory, use up ephemeral RDMA_PS_TCP ports
> needed by other in-kernel users (NVMe-oF/RDMA, iSER, NFS/RDMA), and
> delay IB device removal? cma_process_remove() waits here until every
> pending destroy has run:
>=20
Hi Aibing,

Thanks for the quick response on this, v3 takes care of the fallback,
but the second sashiko finding on v2 applies to v3 as well since nothing
limits the pending probe ids there either.  So likely we'll need to
bound it somehow.

I think the easiest fix would be an atomic counter that is incremented
when a probe is queued and decremented in the worker.  Check it at the
top of rds_ib_laddr_check_cm(), before the allocation, and return
-EAGAIN if it's above a defined cap (say 64 pending probes).  Remember
to decrement it on the -ENOMEM and rdma_create_id() error paths too.

If you'd like to take it a step further, the probes could go on their
own workqueue so they don't get stuck behind slow connection shutdowns
on rds_wq.  rds_ib_exit() could then call destroy_workqueue() on it
after rds_trans_unregister() instead of flushing rds_wq.

Please also mention the port exposure and the cap in the commit
message, so the reasoning stays with the patch.

The sashiko review for v3 is still queued, so let's wait for it to
land before sending v4. That way we can address anything else it finds
in the same version:
https://patchwork.kernel.org/project/netdevbpf/patch/20261117082145.1737-1-=
chenaibing@cmss.chinamobile.com/

Thanks for working on this!
Allison

> 	wait_for_completion(&cma_dev->comp);
>=20
> > +	} else {
> > +		rdma_destroy_id(cm_id);
> > +	}
> > =20
> >  	return ret;
> >  }
>=20
> [ ... ]
>=20


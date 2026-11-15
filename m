Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755157;
	b=nFDJpJkRV7NeweeRxANS9owJsQBwcG/4m7vXCXGoPMPVZo32Lib0WQjeE7nxzzqyBmYq
	 sco76ZMBfyKcv5fIuowYlpm/v7m9CXQczliwsTEkWaibMEfdI9SiODx3IiBnrPr2Tm59Y
	 EgwfNfKcuVSScCCtw3aqGoLG93gaG9NbHRCr7S/4BoSMfg6alyTckYncuLRfyzF4NXoyA
	 dBu5qX/ramzWSA3Mf6247IylNKx35MmsF3eTc5PeRW5vjTURbSWkwR0e1VYpuCAGY02Rf
	 l18OpJ6dFsy+jo2RAdo2CxCFimdaSwhKmF3ncZtjZTlyqElVfCB8YxQVVXm/zFxyuAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755157;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=afKxXXTBu9Fv/roU6xJqQsHoyjdjXjPVw/zZ0fQSgyU=;
	b=GsirouiPjP/sRPEhd6/gVFLP84cdA9zBKM1A9bJL7qlzez5frl1bNf2JCRnEC0zMkwP5
	 xLbrcEfoEmNUAUFXBLESvbyD6yCvnI4djqsaYF4qU9DSEkDIySZIW+0eMwknX5Hnslcts
	 +T5abq5VqW6IBl9cNY1DqtyWVHGAcJEdksMYut8EaXwC72jSKL7IEyM5XCbswIgmKgj69
	 jWmpjwTUcDTzt5AjH34xuJ/SRwuKFq7XhScv+ZaF0Mq1bT+rPISQJBYTtcTKFVcjrqprw
	 9kASqChaYFW1aJvpq1UYmWzpyyS2BaoKI51mnMVzJJuu0ywU9JxMr8/MShzzluC7mYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHO968lW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC34C606A329
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHO968lW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD241F000C4;
	Sun, 15 Nov 2026 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755157;
	bh=afKxXXTBu9Fv/roU6xJqQsHoyjdjXjPVw/zZ0fQSgyU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fHO968lWMiyzuYuJ1Wauh8MmOGtUj7ZdV2XHT4uG3WywOrv3tEFopszG+0m3YsCPy
	 WnTXpRfnDwhQdaj6YXNcSWfGDqlVAeizUumtSHevKmIWvZzyH/75NF5FWgg++TwU9k
	 CGkYL0D4KLlpQ+RUpZlaANyYVTTUxT6Gc7foOkQ3SMa57SnbupEEjgIPr1cnp93qsP
	 XiAaQ4aR3BPOB2Ighc0WJ5QdBbkid09c7sRMsfMActlv0sCC/0gzdVdPCzaCb18lv9
	 jtRYVWNw3itQmxGbscUU0K4jVDxIPQ16Y4/RmLdAF6+zlVqMUucvW5Q7eogiYy6bZG
	 +puW9XW10ANgQ==
Message-ID: <sashiko-outbox-215605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cma: add rdma_destroy_id_wq() and use it from RDS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 15:05:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] RDMA/cma: deadlock on ordered cma_wq in destroy_id_work()
- [Medium] net/rds: UAF on rds_rdma unload with pending
  rdma_destroy_id_wq()
- [Medium] RDMA/cma: cma_cleanup() tears down cma_pernet before draining
  cma_wq
- [Low] RDMA/cma: missing Fixes trailer on RDS lockdep bug fix
- [Low] RDMA/cma: missing documentation for exported
  rdma_destroy_id_wq() API
--

commit 8d1d784abda4c543f5197cf89fc2119bf91e1d62
Author: Aibing Chen <chenaibing@cmss.chinamobile.com>

> RDMA/cma: add rdma_destroy_id_wq() and use it from RDS
>
> syzbot reported a possible circular locking dependency between
> rds_trans_sem and the RDMA CM handler mutex:
>
>   CPU0 (bind path)                    CPU1 (CM callback path)
>   ----                                ----
>   down_read(&rds_trans_sem)           mutex_lock(&handler_mutex)
>   rds_ib_laddr_check()                cma_ib_req_handler()
>     rdma_destroy_id()                   rds_ib_cm_handle_connect()
>       mutex_lock(&handler_mutex)          rds_conn_create()
>                                             rds_trans_get_preferred()
>                                               down_read(&rds_trans_sem)
>
> rds_ib_laddr_check_cm() destroys the CM id from inside
> rds_trans_get_preferred()'s read-side critical section, while CM
> callbacks create RDS connections (taking the same read lock) from
> under handler_mutex.
>
> Break the cycle by destroying the CM id asynchronously: add
> rdma_destroy_id_wq(), which queues the destruction on cma_wq, and
> switch rds_ib_laddr_check_cm() to it.  The destroy work is embedded
> in struct rdma_id_private, which keeps the id alive until the work
> runs; rds does not touch cm_id after the destroy call.
>
> This formalizes the approach proposed and syzbot-tested by Hillf
> Danton; Eduard Zateev additionally verified the fix on a real QEMU
> system (KASAN + lockdep + RDMA_RXE, active and passive RDS
> connections established without any lockdep output).
>
> Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dccdb5058c3df2d94811c
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Tested-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
> Tested-by: Eduard Zateev <hackerowskiy@gmail.com>
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>

[Severity: Low]
Since this fixes a lockdep cycle in the RDS/IB transport, should it
include:

  Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf72..d10aaf51ee86b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2126,6 +2126,25 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  }
>  EXPORT_SYMBOL(rdma_destroy_id);
> =20
> +static void destroy_id_work(struct work_struct *work)
> +{
> +	struct rdma_id_private *id_priv =3D
> +		container_of(work, struct rdma_id_private, destroy_work);
> +
> +	mutex_lock(&id_priv->handler_mutex);
> +	destroy_id_handler_unlock(id_priv);
> +}
> +
> +void rdma_destroy_id_wq(struct rdma_cm_id *id)
> +{
> +	struct rdma_id_private *id_priv =3D
> +		container_of(id, struct rdma_id_private, id);
> +
> +	INIT_WORK(&id_priv->destroy_work, destroy_id_work);
> +	queue_work(cma_wq, &id_priv->destroy_work);
> +}
> +EXPORT_SYMBOL(rdma_destroy_id_wq);

[Severity: High]
Can destroy_id_work() deadlock the ordered cma_wq workqueue when another
event queues work for the same id_priv behind destroy_work?

cma_init() creates cma_wq with alloc_ordered_workqueue(), so only one work
item runs at a time in FIFO order.  After rdma_bind_addr() attaches id_priv
to cma_dev->id_list, rdma_destroy_id_wq() queues destroy_work without
removing id_priv from cma_dev->id_list or marking it RDMA_CM_DESTROYING:

CPU0                              CPU1                  cma_wq
rds_ib_laddr_check_cm()
  rdma_bind_addr(cm_id, ...)
  rdma_destroy_id_wq(cm_id)
    queue_work(cma_wq,
               &destroy_work)
                                  cma_netdev_change()
                                    cma_id_get(id_priv)
                                    queue_work(cma_wq,
                                               &work->work)
                                                        destroy_id_work()
                                                          ...
                                                          _destroy_id()
                                                            cma_id_put()
                                                            wait_for_comple=
tion()
                                                            <-- hangs forev=
er

Because cma_work_handler() is queued behind destroy_id_work() on the same
ordered workqueue, it can never run to call cma_id_put(id_priv) and
complete id_priv->comp, wedging cma_wq system-wide.

[Severity: Medium]
Can queuing _destroy_id() on cma_wq race with cma_cleanup() during module
unload and access freed cma_pernet memory?

In cma_cleanup(), unregister_pernet_subsys(&cma_pernet_operations) runs
before destroy_workqueue(cma_wq):

drivers/infiniband/core/cma.c:cma_cleanup() {
	...
	ib_unregister_client(&cma_client);
	unregister_pernet_subsys(&cma_pernet_operations);
	destroy_workqueue(cma_wq);
	...
}

If rdma_bind_addr() bound a wildcard address (leaving id_priv->cma_dev NULL
while allocating a bind_list entry in pernet->tcp_ps), or if _destroy_id()
finishes cma_release_dev(id_priv) just before cma_release_port(id_priv),
ib_unregister_client() will not wait for destroy_id_work() to finish.
cma_exit_net() can then hit WARN_ON(!xa_empty(&pernet->tcp_ps)) and free
the pernet structure before destroy_id_work() calls cma_release_port() ->
cma_ps_remove(), causing a use-after-free.

[ ... ]

> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index d639ff889e649..ac1c1d9177e2e 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -167,6 +167,7 @@ struct rdma_cm_id *rdma_create_user_id(rdma_cm_event_=
handler event_handler,
>    * asynchronous operations associated with the id.
>    */
>  void rdma_destroy_id(struct rdma_cm_id *id);
> +void rdma_destroy_id_wq(struct rdma_cm_id *id);

[Severity: Low]
This isn't a bug, but rdma_destroy_id_wq() is a newly exported API placed
right under the kernel-doc comment for rdma_destroy_id() without
documentation of its own.  Unlike rdma_destroy_id(), it returns before
in-flight callbacks and operations associated with the id are canceled or
drained, so documenting its asynchronous lifetime and callback constraints
would help callers use it safely.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..1290747cdd991 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -484,7 +484,7 @@ static int rds_ib_laddr_check_cm(struct net *net, con=
st struct in6_addr *addr,
>  		 cm_id->device ? cm_id->device->node_type : -1);
> =20
>  out:
> -	rdma_destroy_id(cm_id);
> +	rdma_destroy_id_wq(cm_id);
> =20
>  	return ret;
>  }

[Severity: Medium]
Can unloading rds_rdma while destroy_id_work() is still pending on cma_wq
cause a use-after-free in rds_rdma's code and rodata?

rds_ib_laddr_check_cm() creates cm_id with event_handler set to
rds_rdma_cm_event_handler and restrack kern_name set to KBUILD_MODNAME.
Previously, rdma_destroy_id() waited for cm_id teardown inside
rds_trans_get_preferred() under rds_trans_sem, which serialized against
rds_trans_unregister() in rds_ib_exit().

With rdma_destroy_id_wq(), rds_ib_laddr_check_cm() returns while cm_id is
still attached to cma_dev->id_list and restrack, and rds_ib_exit() does not
drain cma_wq:

CPU0                              CPU1
rds_trans_get_preferred()
  rds_ib_laddr_check_cm()
    rdma_create_id(...,
      rds_rdma_cm_event_handler, ...)
    rdma_bind_addr(cm_id, sa)
    rdma_destroy_id_wq(cm_id)
  up_read(&rds_trans_sem)
                                  rds_ib_exit()
                                    ...
                                    rds_trans_unregister()
                                  /* rds_rdma module freed */
cma_send_device_removal_put()
  id_priv->id.event_handler()     <-- calls freed module .text

A concurrent netlink RDMA_NLDEV_CMD_RES_CM_ID_GET dump in
fill_res_name_pid() can likewise read res->kern_name from freed module
rodata before destroy_id_work() runs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114150541.1908=
-1-chenaibing@cmss.chinamobile.com?part=3D1

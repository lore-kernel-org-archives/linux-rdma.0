Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896148;
	b=ZiqHHSrd2720aZUz7coG+mDmiOsHJ8tTY1G93dN6uxMcOfQwrRFxozSpp0KKKbXWgx7f
	 M/wZc6iFGuYliAE61mtai0IKbj1ZUbP9iD2d00Y/AsrvoIHiyZleBBfGYV1/HPRmsdOaj
	 iudVj+E6bUXQXDOtKY17ZFXHpEX279aVEw8i52nnq9lO9LtJDC5x6nbEdD9TQs0NNboGW
	 HqQv84vlDzVwPBcHgQlmwjWXnL+5ScYImcGsnmRbLIQly+V56OwAwe4onQuuxfo7LBv8o
	 7JwxgSCFwDA5JRvI6IwhFDXNvr0wgFHGddgPaXs8U+XXO3xtkNpz67PDcbfhjgp3UPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896148;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=77exyfdtiO92nBdMS15TrDt356pTZ+Pg32vOrZO0z0Q=;
	b=hOx7N6V+oCRKLXAjrV5Gze4+O6Mqer69pC8aImgk2VTp9Rs21rQFX1PAKgel7kVYPBZ3
	 Q8AcaxAJzk+LXT3oMuAi/TRntASwk9YSw/iV4oW8yJEWgybTjJj35dsBmzPHKJDYb/XjY
	 upTUtb0gqrukJSaz+SFRZDaMVL7Co7uwJRkvUEteMagAf8K/+hXmimqbr0JopniCPvcOJ
	 jR2Hh946m6sZYXU4gxhT94PSA43h+tC6mxs1S6ascrGM4vLpbVXSraZCXrybwfcMKBOOL
	 H3GTMSvBoPSYows7fvfp0NzPEecd18MrHQlX8O0OFjaHC7wL++jZnt2DokPNZ4VTaXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLIJvECu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F713606A329;
	Tue, 17 Nov 2026 06:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLIJvECu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E751F000C4;
	Tue, 17 Nov 2026 06:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794896148;
	bh=77exyfdtiO92nBdMS15TrDt356pTZ+Pg32vOrZO0z0Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kLIJvECuQQoZoW6ujqEW2ygTN456z2D797kWRlr4xc9nmluypmCUCF0GERs42MiWZ
	 h7u2nonnD9CQrQKVR3fVFix4qQkkuZ22NOcsb9xXl6m6CQr+pmCjJVoJCUiPYrhlWF
	 dri2fOjcj89I3qq/RiYB63GRx+dDh9lVj7giwrz59nsI3ubuPnC0JoBFeuyRkM+Mgv
	 2nJ2F74NeIJk4koN5onTp7JZsRuqQckp4loi2bPkLL33cEWteMFP4Gin0l4z9nfDuI
	 v4Z8reYuO2r5l8qeZ/EhbML8njpgirjiv53XkQGZLI7aMC4LS0uZusse4oGHl1w/VV
	 O1yXiTOV8HsiQ==
Message-ID: <6f4cebe1dae4c25d7618f0a08c1412cd0c68faeb.camel@kernel.org>
Subject: Re: [PATCH net v2] net/rds: defer CM id destruction to a workqueue
From: Allison Henderson <achender@kernel.org>
To: Aibing Chen <chenaibing@cmss.chinamobile.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Mon, 16 Nov 2026 23:15:46 -0700
In-Reply-To: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
	 <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
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

On Mon, 2026-11-16 at 15:54 +0800, Aibing Chen wrote:
> rds_ib_laddr_check_cm() destroys the RDMA CM id it created while
> rds_trans_get_preferred() holds rds_trans_sem for reading.  The bind
> path then takes rds_trans_sem and afterwards handler_mutex in
> rdma_destroy_id(), while the CM callback path takes handler_mutex in
> cma_ib_req_handler() and afterwards rds_trans_sem through
> rds_conn_create().  lockdep reports the resulting cycle.
>=20
> Queue the destruction on rds_wq instead, so that rds_trans_sem is
> released before handler_mutex is taken.  The work item allocated here
> owns the cm_id until rdma_destroy_id() has run; if the allocation fails,
> the id is destroyed synchronously as before.
>=20
> rds_ib_exit() flushes rds_wq after rds_trans_unregister() so that no
> queued destroy runs after the module text is gone.
>=20
> Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dccdb5058c3df2d94811c
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Suggested-by: Allison Henderson <achender@kernel.org>
> Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
> ---
> v2:
> - move the workqueue from RDMA core into RDS, as suggested in review.
> - flush rds_wq in rds_ib_exit() so a queued destroy cannot run after
>   the module text is freed.
> - add the Fixes tag, drop the Tested-by tags.
>=20
>  net/rds/ib.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d0..66af4a72a 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -391,6 +391,20 @@ static void rds6_ib_ic_info(struct socket *sock, uns=
igned int len,
>  }
>  #endif
> =20
> +struct rds_ib_destroy_work {
> +	struct work_struct work;
> +	struct rdma_cm_id *cm_id;
> +};
> +
> +static void rds_ib_destroy_id_work(struct work_struct *work)
> +{
> +	struct rds_ib_destroy_work *w =3D
> +		container_of(work, struct rds_ib_destroy_work, work);
> +
> +	rdma_destroy_id(w->cm_id);
> +	kfree(w);
> +}
> +
>  /*
>   * Early RDS/IB was built to only bind to an address if there is an IPoI=
B
>   * device with that address set.
> @@ -411,6 +425,7 @@ static int rds_ib_laddr_check_cm(struct net *net, con=
st struct in6_addr *addr,
>  #endif
>  	struct sockaddr_in sin;
>  	struct sockaddr *sa;
> +	struct rds_ib_destroy_work *w;
>  	bool isv4;
> =20
Hi Aibing,

Thanks for the quick turn around, this is looking much better.  Just a few =
things to get this
through: we cant fall back to the synchronous destroy if alloc fails, or th=
e same bug
will come back under memory pressure.  Lets hoist the alloc up here before =
the
rdma_create_id().  If alloc fails, just return -ENOMEM right away.

>  	isv4 =3D ipv6_addr_v4mapped(addr);
> @@ -419,6 +434,15 @@ static int rds_ib_laddr_check_cm(struct net *net, co=
nst struct in6_addr *addr,
>  			       NULL, RDMA_PS_TCP, IB_QPT_RC);
>  	if (IS_ERR(cm_id))
Then add a kfree(w) here before returning on this error case

>  		return PTR_ERR(cm_id);
> +
> +	/*
> +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls thi=
s
> +	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
> +	 * takes handler_mutex, which the CM callback path acquires before
> +	 * taking rds_trans_sem.  If the allocation fails, fall back to the
> +	 * synchronous destroy.
> +	 */
> +	w =3D kzalloc_obj(*w, GFP_KERNEL);
>  	ret =3D rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
>  	if (ret)
>  		goto out;
> @@ -484,7 +508,13 @@ static int rds_ib_laddr_check_cm(struct net *net, co=
nst struct in6_addr *addr,
>  		 cm_id->device ? cm_id->device->node_type : -1);
> =20
>  out:
> -	rdma_destroy_id(cm_id);
> +	if (w) {
> +		INIT_WORK(&w->work, rds_ib_destroy_id_work);
> +		w->cm_id =3D cm_id;
> +		queue_work(rds_wq, &w->work);
> +	} else {
> +		rdma_destroy_id(cm_id);
> +	}
And then this else part can be removed since w is guaranteed here

Other than that, this looking really good.
Thanks for working on this!
Allison

> =20
>  	return ret;
>  }
> @@ -542,6 +572,11 @@ void rds_ib_exit(void)
>  	rds_ib_sysctl_exit();
>  	rds_ib_recv_exit();
>  	rds_trans_unregister(&rds_ib_transport);
> +	/*
> +	 * rds_ib_laddr_check_cm() may have queued rdma_destroy_id() on rds_wq;
> +	 * wait for it before the module text goes away.
> +	 */
> +	flush_workqueue(rds_wq);
>  	rds_ib_mr_exit();
>  }
> =20
>=20
>=20
>=20


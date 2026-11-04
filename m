Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830549;
	b=ihe9ra1Um2YrtJT2wG2neN2Ev2mRz2xtm2Us5e5ZBuBwRHgVKlVQGjItBPOqe6G1uHDY
	 VN5gNnYMSXYc52RO429Vpv1PgvY10fU1dD4kzV71wD8qogjNS+HGqEO5gKveWQ9y4yvab
	 ptFOQCYPZcV3aBHqVY2+CAkfz3pZPI58gnZwN6akM39l13iqFKU6vnJshs454Dc3j9J2b
	 iJN99Kx5ZOwdX+bEQUo2++9QbELUHfwxEbUcxkm+yKufdtLfKvUXl+0dz3cU/lLEIoIO/
	 HC9RUts2C9Z3w0iJhLw0WC91LoHXjKJNhyaVSKKKH25biDQKDqOilg5BekLxP4URJMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830549;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=3F2m60G+gxvBW4y7hHQfye8ccenVYUgHpUwX5iBXsZ8=;
	b=G9FngmTgHzFR7j365zDAAiBsEs/Fiqgq+T4FQPx57uyYjrZriLZh6/9t7FmfJJ4qE3Jj
	 bHgiM9f3jBzNQzQArrxOW709YcMxCzwRpvhkt76ogIwveKkZmH7WxzLDmyEiVUlfH87+8
	 MPOWAO8kzsQwHXI3VCee0FtEgEaubzHI//gKOx1wn4sZxQHfloRoXX1wiBdTMv47GLFA8
	 v48MSVq3wf5BzBrfiR2/CTFO+ebqSNoZcPuvs9jGnS7kkUHrUhzKxlOhxkGwvNExdoShj
	 XXp9VE99RbmpD/ymStPgBSkytcjH4tT5vbUXl/sfHtANbRKrks7p937eH7WoGHkZG9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJOZs+AM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A61606A333;
	Wed,  4 Nov 2026 22:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJOZs+AM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53661F000C1;
	Wed,  4 Nov 2026 22:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793830548;
	bh=3F2m60G+gxvBW4y7hHQfye8ccenVYUgHpUwX5iBXsZ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dJOZs+AM4zB+jYeDBNu+8sm5YhR0e3ZjPOxteGNYsvz1a/yShGJxsSdMMuKOAg8W6
	 JDB21X3tYBniVSMV95Q9/3YKfVHwgLQ7+LZt0oCeckS2VF6c2hVQC5DiutJa2C7PYS
	 bYuVdfaB1zXEpyjMH+eoaONQyhn6aXKO67wxl/hdlLwrCcXTAYC4lMmh2Ft2w6DVjR
	 J7metHeoA8E7rvU7K1jY7pGDLl+oqrsorvh4ryOdCmQ6SY6T4H1qhal/6zHf5OSS4S
	 7OmCEDUeRY0eSWjjMVNs2Iyzu3C3d6yGGOYBvV1MmyJb+Bs3yvIQG581tN52S7w9Nr
	 GTNRMljkU+YaA==
Message-ID: <b9b97bf371302d42319ce21fbd4532d39ee97a28.camel@kernel.org>
Subject: Re: [PATCH] net/rds: drop the device reference for ODP memory
 regions
From: Allison Henderson <achender@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>, "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,  Simon Horman
 <horms@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com
Date: Wed, 04 Nov 2026 15:15:46 -0700
In-Reply-To: <20261104022810.1484182-1-vulab@iscas.ac.cn>
References: <20261104022810.1484182-1-vulab@iscas.ac.cn>
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

On Wed, 2026-11-04 at 02:28 +0000, Wentao Liang wrote:
> rds_ib_get_mr() takes a reference on the rds_ib_device with
> rds_ib_get_device().  The FRMR path stores it in ibmr->device and
> rds_ib_free_mr() drops it when the MR is freed.
>=20
> The ODP path allocates the ibmr with kzalloc_obj() and returns it
> without recording the device.  rds_ib_odp_mr_worker() only deregisters
> the MR and frees the ibmr, so the reference taken for every ODP MR is
> never dropped and the rds_ib_device can no longer be released.
>=20
> Store the reference in ibmr->device and drop it in the worker after
> the MR has been deregistered, which also keeps the device and its PD
> alive for as long as the MR exists.
>=20
> Fixes: 2eafa1746f17 ("net/rds: Handle ODP mr registration/unregistration"=
)
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Hi Wentao,

Thanks for the patch.  The fix itself looks reasonable, but few things to u=
pdate: since
this is a bug fix, it should should target net with [PATCH net v2]. The com=
mit message
should mention how this was found, and whether it was tested. Reproducing t=
his needs an
ODP-capable device, so if it was only build-tested, please say so. It looks=
 like there's
a few check patch nits to work through as well:
https://patchwork.kernel.org/project/netdevbpf/patch/20261104022810.1484182=
-1-vulab@iscas.ac.cn/

Other than that it looks straight forward to me.

Thanks,
Allison

> ---
>  net/rds/ib_rdma.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29..8cd8295f66a3 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -591,6 +591,7 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned =
long nents,
>  		}
>  		ibmr->u.mr =3D ib_mr;
>  		ibmr->odp =3D 1;
> +		ibmr->device =3D rds_ibdev;
> =20
>  		sge.addr =3D virt_addr;
>  		sge.length =3D length;
> @@ -697,5 +698,6 @@ static void rds_ib_odp_mr_worker(struct work_struct  =
*work)
> =20
>  	ibmr =3D container_of(work, struct rds_ib_mr, work.work);
>  	ib_dereg_mr(ibmr->u.mr);
> +	rds_ib_dev_put(ibmr->device);
>  	kfree(ibmr);
>  }


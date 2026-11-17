Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794902082;
	b=WTyzjCIffS6z7OyV2l8dHnOopq+J7ZV38kZ+PURTVGFlh6TATV2ZyR2LK0al9IwD8JHm
	 +avJCIWFVRqVPb/4SqEYix871k75iMwP28s3jy6wfcLn9otdus7eUvriaSJbiB/ETpNB0
	 Sfr7CxLWm8StTJaosHsU8FfNSfM69OkZTvS1jGNyvhla4O3JXexjrI3V2UE/ef4Hb74e+
	 edATF5GxBWzElJI4Nq+rUR/k/EZMOThnN/1+Hj3Y+4ghH1eC5laO/mJIBuC3dq4VRw6NX
	 NwFv6G0La23uAokqaecOrttMZIATng/sfweq+sW6b6n9TkUvPhftGhY6VSaZUQkwn4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794902082;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TZ9sHJr0x8Py/9bd1KP5YcVhFOB8T0PLW5omMOxXU8A=;
	b=iDQAX6ragzqd2Q4jGzCLsJ0YPp5a9STFNK3HazxFT7oVYBBisfY9wUPZQbfMegbbPTAg
	 GHR3MBxis52sGRpDKFJkwuFtkqZMX91rAwIr1EVtFeOG1EQxL2a5/ihoiANChUCNbVVw7
	 dkyiMN3bj5nP2EZ5yu8aj9gVvOroWpCppRhax+WwmFChqbyWhoi8FSp0hby0zL4Wf1vEL
	 ST+TyVUNkLDKV52XCCfKMdrIsT+KBd97rw0TTh6Bojh5l62hm6RkCcFtxuuJUJO26j2Dc
	 T/mKfLhO9RZOhuPktcgKvW8y5oX7w7Q0nZQDbCRz5CB/OU77XozX1qR+3Qv2y5+pamQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrGJnJga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551FD606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrGJnJga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FB31F000C4;
	Tue, 17 Nov 2026 07:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794902081;
	bh=TZ9sHJr0x8Py/9bd1KP5YcVhFOB8T0PLW5omMOxXU8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mrGJnJgaDkTx/gyDZJc4fkU+2GIG5e2jmxXIMedl+QWgLapWW4hXuti88AhpSYqTq
	 kWDqS5yY80YBME+zzeMBedbqPpDGGWgir8eBwM+itfYQQLTnMxbrqqOR9xcRyhsXvZ
	 zZDoDnn4rjJG/PXDa6XSPlJDkPJ3LKeK7cTsLjwEzavKMYq5qxkXEyoEDRe1qX2iA7
	 kIbX58Uudm8XBY0qhEa3v5Ilny2F7Nx4QyU6Oa5iU2r+I+xBGsmf9nu3Q7B8JmxKWV
	 k8r8OY2sqSjPSLi9B0FUZnKA9n1jzUUSBFbiDuFNHOCrsQY42cOV3AD72iCwpDlciK
	 YqpPRAshXAmSQ==
Message-ID: <sashiko-outbox-218388@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/rds: defer CM id destruction to a workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
 <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 07:54:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/rds: synchronous rdma_destroy_id() fallback in
  rds_ib_laddr_check_cm()
--

commit 26cfa811c05ca14cedb9fc00446b35dbd44dc87e
Author: Aibing Chen <chenaibing@cmss.chinamobile.com>

net/rds: defer CM id destruction to a workqueue

This commit defers rdma_destroy_id() from rds_ib_laddr_check_cm() to
rds_wq to avoid taking handler_mutex while rds_trans_sem is held, and
flushes rds_wq in rds_ib_exit().

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..66af4a72a5595 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
[ ... ]
> @@ -419,6 +434,15 @@ static int rds_ib_laddr_check_cm(struct net *net, co=
nst struct in6_addr *addr,
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
> =20
>  	return ret;
>  }

[Severity: Medium]
Can the fallback to synchronous rdma_destroy_id(cm_id) when
kzalloc_obj(*w, GFP_KERNEL) fails still trigger the rds_trans_sem ->
handler_mutex ABBA deadlock this patch fixes?

Allocating w before rdma_create_id() (returning -ENOMEM if !w and freeing
w if IS_ERR(cm_id)) would ensure cm_id is never created without a work
item to destroy it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116075423.782-=
1-chenaibing@cmss.chinamobile.com?part=3D1

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916123;
	b=KC2P7qD+1Ozr4OjIxFK6n3B8roCPTAlVN/LZDyn//IENwlxdCCw8r4uyVaRE6XfqbeSH
	 7MfzZxcbFgSKz0DZtqSaUbn2aLfzjn8Yhk49mChLzU/t69HVclbq21h9yR67q3HM7FCr0
	 h+CQ3iyJpriajJLTm0tJ+GZPXhjfiJFrOM+cgHbHO1jaLrwWDNEenI9Fxd/befFNQCa0Y
	 kWYxDUKcM2D+KDTvCoUPjX/P7rLaNMkiOdtmnxF3ug15VHV4MHZlIoObQx+/pwzyhEGwY
	 22FGQa+YG0XeWUtMofy5+rvqXjo/OoUmJoGXTDzX8Y3FqaVW6B9FpXXOqwcfEK+Swuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916123;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sYjTNuUy8aIm9y9hvhwwHMxlXxKiv9TzIARPYf8z+nU=;
	b=VVBI1v55fVaHSQc76vVHKgO+eGnPUXNcMlwP6zsGVtkRSriXalg+C8Cy81G1I0XzzdjW
	 Y3d7KeB5zMmoqUKmP6KMuCrLPx+XNW/06TljYFlrYOEHjwNv2863Q6P9Q0ouf6skdMsQO
	 HXxRp5gWexLHse5Xb3eCtZfhWODkp9af4TZrSnyDuNbsq99dJtwQXjokHpR7M/QMaNfJH
	 TVv2BaHg+tS8mw37B/6Acly4NHs8BTb9IHxNTzdWK3giSK4szcWdj2NakmJ5b2p7cRtLO
	 4e72iGf2zs6P+Yd3GQtdHcD/IpJ7XlNx6XZOmeYHLDMqBIffTjU18icKIcl14M/YWBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7vAu3FB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D9606A323
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7vAu3FB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EEE1F000C4;
	Tue, 17 Nov 2026 11:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916123;
	bh=sYjTNuUy8aIm9y9hvhwwHMxlXxKiv9TzIARPYf8z+nU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D7vAu3FBDx6Y85eil3tHhvQJRnrY/p3AyPMeiFlMXJo6spBafr4Y3u9uRyS+Kocsx
	 kaZ93XuIH6KhdrxLmXUuHx4GsFkea+h7XEs6rMgCAg8LEiO/cnBiK2e/RPm+/aJkUz
	 4jM1qYANfSoHDkUySNOX/JauNNPZjI8s6mhYesuRJWaXMeHtnGVp0uCwhXSeTYlqRU
	 cJ9qSLGADu+cFkHEj7fpoyCH5s9iGr5Mpwz/jF1l8dxz6uvhmmkNVuTpUWC5AiGvpZ
	 i3q+1XWfvoF+WIBozEa/4d/Q1IYeaoHygT84KgfFDOrSqJerdMNV1smBTk080ebk5s
	 Zh9hQc83/vd+Q==
Message-ID: <sashiko-outbox-218731@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/cma: Use a separate lockdep class for the
 listening cm_id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?U2hpbidpY2hpcm8gS2F3YXNha2k=?= <shinichiro.kawasaki@wdc.com>, linux-rdma@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
In-Reply-To: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
References: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 11:48:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] RDMA/cma: unsafe lockdep_set_class() placement in
  rdma_listen()
- [Low] RDMA/cma: unreclassified handler_mutex on
  nvmet_rdma_enable_port() error
--

commit d2c299202b2d013f5516cd16c2fdd187fc66e56a
Author: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

RDMA/cma: Use a separate lockdep class for the listening cm_id

This commit assigns a separate lockdep class to id_priv->handler_mutex at t=
he
start of rdma_listen() to prevent a false-positive circular locking depende=
ncy
warning between listening and connected cm_ids in nvmet-rdma.

Link: https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf72..b3678ddc79a4a 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3949,6 +3949,13 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
>  		container_of(id, struct rdma_id_private, id);
>  	int ret;
> =20
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	static struct lock_class_key cma_listen_handler_mutex_key;
> +
> +	lockdep_set_class(&id_priv->handler_mutex,
> +			  &cma_listen_handler_mutex_key);
> +#endif
> +
>  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
>  		struct sockaddr_in any_in =3D {
>  			.sin_family =3D AF_INET,

[Severity: Medium]
Can calling lockdep_set_class() here race with concurrent users of
id_priv->handler_mutex and misclassify non-listening IDs?

rdma_listen() reinitializes id_priv->handler_mutex.dep_map before validating
id_priv->state and without holding id_priv->handler_mutex.  Through
ucma_listen(), userspace only holds ctx->mutex and can call rdma_listen() o=
n a
cm_id in any state while another thread or CM callback acquires or releases
id_priv->handler_mutex:

CPU0                                  CPU1
ucma_listen()                         cma_ib_handler()
  mutex_lock(&ctx->mutex)               mutex_lock(&id_priv->handler_mutex)
  rdma_listen()                           look_up_lock_class()
    lockdep_set_class(&handler_mutex)     ...  <-- data race on dep_map
    cma_comp_exch() -> fails

Even when id_priv->state is RDMA_CM_ADDR_BOUND, id_priv is already on
cma_dev->id_list, where cma_send_device_removal_put() or addr_handler() can
hold id_priv->handler_mutex concurrently.  Mutating dep_map while the mutex=
 is
being acquired or held can trigger the lockdep WARN_ONCE() in
look_up_lock_class() or corrupt the held-lock stack on unlock and disable
lockdep.

In addition, if rdma_listen() fails the state check, fails rdma_bind_addr(),
or jumps to err: and reverts id_priv->state to RDMA_CM_ADDR_BOUND, a
non-listening cm_id is left with cma_listen_handler_mutex_key, defeating the
lock-class separation if the ID is later used for a connection.

[Severity: Low]
Does reclassifying id_priv->handler_mutex in rdma_listen() still leave the
false-positive lockdep splat reachable when nvmet_rdma_enable_port() fails
before reaching rdma_listen()?

nvmet_port_subsys_allow_link() holds nvmet_config_sem across
nvmet_enable_port() -> nvmet_rdma_add_port() -> nvmet_rdma_enable_port():

drivers/nvme/target/rdma.c:nvmet_rdma_enable_port() {
    ...
	ret =3D rdma_bind_addr(cm_id, addr);
	if (ret) {
		pr_err("binding CM ID to %pISpcs failed (%d)\n", addr, ret);
		goto out_destroy_id;
	}

	ret =3D rdma_listen(cm_id, 128);
	if (ret) {
		pr_err("listening to %pISpcs failed (%d)\n", addr, ret);
		goto out_destroy_id;
	}

	port->priv =3D cm_id;
	return 0;

out_destroy_id:
	rdma_destroy_id(cm_id);
	return ret;
}

If rdma_set_afonly() or rdma_bind_addr() fails, rdma_destroy_id(cm_id) locks
id_priv->handler_mutex under nvmet_config_sem while handler_mutex still has
the default lockdep class, recording the same nvmet_config_sem ->
handler_mutex dependency as before.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117113129.7464=
90-1-shinichiro.kawasaki@wdc.com?part=3D1

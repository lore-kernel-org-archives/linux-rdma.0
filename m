Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444956;
	b=AG5A3m6xffkwIBSosiljolMao/M7/Uzah3snQ7I0NNV3u7GOp4PAlfOD6ifMX1f9KVDj
	 AE1Lwu2IXsqN9Vj082Vll4CZuo/7mQ2pLxAxG1ExBFpBiVjm57YDGHytbwMClZ+JHDzAo
	 37r5zjfQjJEdOk+FHKUFiGulpdpQYHdU4dhEZOVPsBfNdhu74214F9uauSRAtLu7tSWij
	 dDpiHgy7XBViECy9b5okaP0CkdNixQ45Oe+EKD36EeT6syyhx3fCs+KrtFMhFZk4BXf3/
	 XxRcs6/+lRXmCfIi2M5AroEe8CCkJEc3IaBpqUmi/5DhxONExN4zkww/Tho49EFOPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444956;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EF3sjXq1JiEEIjptCPysvMCeHXZbbrsksoD4VQxmTMs=;
	b=RGBWF1Em/yVUCChzD8dvM+wt3+KrzSDfsq/k6eU75BXwfYj/8zPepgdjKgJzzfSENKs3
	 09a2Za5zwQV5KBrNz1YDOvLVWtAXN/aErPEtsg1oEQwrpXaiJGTrE7gwfvipYrA9RbXE/
	 V7GGTway0DMVkQK4rnh8yDJ4ryTpNJUHBCGYjSjJuHmvrFQLacPhCIdWxqNWfPwDqRRcL
	 iaiLao47C3EGykqz4BxIqoJYH5y9tHmuffWygQfB5b6+V2UeY7G1J3PMzxPGR1Ez52bYB
	 KcahU14/wxHVDRs6sOlXNj1DdP7zuYLrmatgf1M121un+WpX7n2quWBX1iQNw7gUpBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Q+p86/kd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55581606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q+p86/kd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452B1F000D4;
	Mon, 23 Nov 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795444955;
	bh=EF3sjXq1JiEEIjptCPysvMCeHXZbbrsksoD4VQxmTMs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Q+p86/kdqXnFS7nj1KT08JmRODHR0QnkLDNxO6okVLflOSCdKh5b1wMTRuciTks0c
	 TyhTm9qJgefwHuJI2MUMFqfulGaCLJDEmHoMEd6W2bbzvj5WH4re5wfjxH6Oa6tns4
	 9v2LHjFzEDkmcsap3ZiAXs3fLPyVrJIWlEXxfxVRxvMcAGk16C/vSVRVGA12ckcM5D
	 H2XmehB8eYyrUyw0j/mcoxOdLkF6wAapBxPYrXXRP4M9k3gwOcfIyEyqFcjITaDrMM
	 /nXeqJQUdxP0HuMxuA+Kn5IOlBzgnJ98a3nEWhKool5a9qaX6X0LYvcu5kUZ3JMBnY
	 fHRJTzBlGYNuw==
Message-ID: <sashiko-outbox-229434@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] RDMA/rtrs-clt: rename pathname parameter to
 sessname in rtrs_clt_open()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Md Haris Iqbal" <haris.iqbal@ionos.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261123143719.938876-6-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-6-haris.iqbal@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:42:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] RDMA/rtrs-clt: use-after-free in rtrs_clt_open() [1]
--

commit d270a6058ae45a4fbd952be02c065eb235215fda
Author: Danil Kipnis <danil.kipnis1@ionos.com>

RDMA/rtrs-clt: rename pathname parameter to sessname in rtrs_clt_open()

This commit renames the pathname parameter of rtrs_clt_open() to sessname
in the header declaration and implementation.

> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index 5ef912a472cda..c059d69c3e5a3 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c

[ ... ]

> @@ -2848,7 +2848,7 @@ static void free_clt(struct rtrs_clt_sess *clt)
>   * Return a valid pointer on success otherwise PTR_ERR.
>   */
>  struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
> -				 const char *pathname,
> +				 const char *sessname,
>  				 const struct rtrs_addr *paths,
>  				 size_t paths_num, u16 port,
>  				 size_t pdu_sz, u8 reconnect_delay_sec,
> @@ -2858,13 +2858,13 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_c=
lt_ops *ops,
>  	struct rtrs_clt_sess *clt;
>  	int err, i;
> =20
> -	if (strchr(pathname, '/') || strchr(pathname, '.')) {
> -		pr_err("pathname cannot contain / and .\n");
> +	if (strchr(sessname, '/') || strchr(sessname, '.')) {
> +		pr_err("sessname cannot contain / and .\n");
>  		err =3D -EINVAL;
>  		goto out;
>  	}
> =20
> -	clt =3D alloc_clt(pathname, paths_num, port, pdu_sz, ops->priv,
> +	clt =3D alloc_clt(sessname, paths_num, port, pdu_sz, ops->priv,
>  			ops->link_ev,
>  			reconnect_delay_sec,
>  			max_reconnect_attempts);

[Severity: Critical]
This problem wasn't introduced by this patch, but can a failure in
rtrs_clt_create_path_files() later in rtrs_clt_open() cause a
use-after-free and double free of clt_path [1]?

When kobject_init_and_add() fails in rtrs_clt_create_path_files(), it
calls kobject_put(&clt_path->kobj), which invokes rtrs_clt_path_release()
and frees clt_path via free_path():

drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:rtrs_clt_create_path_files() {
    ...
	err =3D kobject_init_and_add(&clt_path->kobj, &ktype_sess,
				   clt->kobj_paths,
				   "%s", str);
	if (err) {
		pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
		kobject_put(&clt_path->kobj);
		return err;
	}
    ...
}

rtrs_clt_open() then touches the freed clt_path in list_del_rcu(),
rtrs_clt_close_conns(), and free_percpu() before calling free_path() a
second time:

drivers/infiniband/ulp/rtrs/rtrs-clt.c:rtrs_clt_open() {
    ...
		err =3D rtrs_clt_create_path_files(clt_path);
		if (err) {
			list_del_rcu(&clt_path->s.entry);
			rtrs_clt_close_conns(clt_path, true);
			free_percpu(clt_path->stats->pcpu_stats);
			free_path(clt_path);
			goto close_all_path;
		}
    ...
}

[1] https://sashiko.dev/#/bug/linux-982ecccb-b1ca-401f-8293-d1973992f3f6

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.9388=
76-1-haris.iqbal@ionos.com?part=3D5

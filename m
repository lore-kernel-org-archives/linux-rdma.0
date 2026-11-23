Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445044;
	b=u3nCYIgBy5IugsYLWjBJDXVTrmgHsUqLWQre8Wmm08eg0S/ZtqUHnY8tbTcH5/va2/rN
	 u2qzXmfO1evrW6Wt/ddhmyB5oivHFmWI3sfnL04ay57T/O35mIz5dhTJRWzcMBVN5+j7Q
	 jDMYrOYyV2XfUa7LNrTPc3VjKxnubd+8dmuM18Pqf74+OonQKk7wapL3BMYiKiS0CaqYa
	 rpu38qHLHDWg5Pd8cFdyg60X3sdXJUVp0lRgsWZIeysjvgK5ejLXYKNDWglAB/mOGd4d9
	 Qp//Yjy1pT4BWvYU2FzKEvvSfRuWh0u768HoW1TPcAdh+qyd5JjsW5vsV0L7CutYtJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K+0Hq3j+CLv0lcpTIhI2+oy/RkIRguKmH6KO2GoswtY=;
	b=sLfcGoI1qF511CAGbY+ZX9mAH6Uk9SIjyk2JZCYBQT11lprbX1IcT5mE/KhWRrpyxR4f
	 Yqyktbrg2E5Hwhv10ayt9uNARPhCv8I3l33+nqLbzkb0Q58pTH4PvrbN86OIgwUIruTWB
	 cjjj/HhUVhLYgTm2uMn2chzS3fZK96ZtsxKngtbO8UuVcPnKBg+cIkvLf5LYh6kYSE7M0
	 0lfpAJvz68a28W1P7Po3jPoErJ77nBYTanYMrk9Ogu4WmZvINWw38Sdx2NwDNRDl1blex
	 E/QJnvvg0O2q11pqZlwf7T7mzgQNfimE1hTPpFobSFhgv8OdsSLnvkeZoQfHCqAl9mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UBj7H54x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6143606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UBj7H54x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAD11F000C0;
	Mon, 23 Nov 2026 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445043;
	bh=K+0Hq3j+CLv0lcpTIhI2+oy/RkIRguKmH6KO2GoswtY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=UBj7H54xPXUvUOX3uXooutCrf7672FOQdkduAdC7goGw6A2hN4SoJRXkgoUnq3AAI
	 7vkb3Wp9xK617xcs44gBfHtQWYUGEBKvlsoRwK1/4iiRHum86A03uCim4+XFnIrAHm
	 DlUpD8rDCNjMskf0EcVjeociteRIfrO+oALMFNxySkkD987HhMRw7TDb7nhI3oFJdN
	 hX+jOWNIu9Bx37cXeX27hsOy5YwNuLlcdTCO5uZ/gR79gNKbxX74zICy+MY1wBnhC3
	 3fKrTXbzZd0RLAJJa6hmlZqsFcU1TB1n5Grl0nXLqTWv+uHxHdtzcCy3ciKemIVwFO
	 pOdeba1d7rfXw==
Message-ID: <sashiko-outbox-229435@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] RDMA/rtrs-clt: Add mpath_policy module parameter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Md Haris Iqbal" <haris.iqbal@ionos.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261123143719.938876-2-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-2-haris.iqbal@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:44:02 +0000
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
- [Medium] RDMA/rtrs-clt: unclamped runtime sysfs writes to mpath_policy
  in alloc_clt()
- [Low] RDMA/rtrs-clt: __stringify() on enum MP_POLICY_MIN_INFLIGHT in
  MODULE_PARM_DESC
--

commit 9f1bdddc73a41e6280e607ffdea1faff0f78b52e
Author: Danil Kipnis <danil.kipnis1@ionos.com>

RDMA/rtrs-clt: Add mpath_policy module parameter

This commit adds a runtime-adjustable mpath_policy module parameter to
configure the default multipath policy for newly created RTRS client
sessions.

> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index bf3a0377da3ff..573beb5ccdf07 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -39,6 +39,13 @@
>  MODULE_DESCRIPTION("RDMA Transport Client");
>  MODULE_LICENSE("GPL");
> =20
> +static int mpath_policy =3D MP_POLICY_MIN_INFLIGHT;
> +module_param_named(mpath_policy, mpath_policy, int, 0644);
> +MODULE_PARM_DESC(mpath_policy,
> +		 "Default multipath policy for new sessions (default: "
> +		 __stringify(MP_POLICY_MIN_INFLIGHT)
> +		 " (min-inflight), 0: round-robin, 1: min-inflight, 2: min-latency)");

[Severity: Low]
Does __stringify(MP_POLICY_MIN_INFLIGHT) expand to the literal token name
"MP_POLICY_MIN_INFLIGHT" in modinfo rather than "1"?
MP_POLICY_MIN_INFLIGHT is an enum constant in enum rtrs_mp_policy, not a
preprocessor macro.

> @@ -2758,7 +2765,7 @@ static struct rtrs_clt_sess *alloc_clt(const char *=
sessname, size_t paths_num,
>  	clt->max_reconnect_attempts =3D max_reconnect_attempts;
>  	clt->priv =3D priv;
>  	clt->link_ev =3D link_ev;
> -	clt->mp_policy =3D MP_POLICY_MIN_INFLIGHT;
> +	clt->mp_policy =3D mpath_policy;
>  	strscpy(clt->sessname, sessname, sizeof(clt->sessname));
>  	init_waitqueue_head(&clt->permits_wait);
>  	mutex_init(&clt->paths_ev_mutex);
> @@ -3220,6 +3227,10 @@ static int __init rtrs_client_init(void)
>  	int ret =3D 0;
> =20
>  	rtrs_rdma_dev_pd_init(0, &dev_pd);
> +
> +	/* Validate and clamp mpath_policy to valid range */
> +	mpath_policy =3D clamp(mpath_policy, MP_POLICY_RR, MP_POLICY_MIN_LATENC=
Y);
> +
>  	ret =3D class_register(&rtrs_clt_dev_class);
>  	if (ret) {
>  		pr_err("Failed to create rtrs-client dev class\n");

[Severity: Medium]
Does clamping mpath_policy only in rtrs_client_init() leave runtime writes
to /sys/module/rtrs_client/parameters/mpath_policy unclamped?

Because mpath_policy uses mode 0644 with standard param_ops_int, writing
an out-of-range value via sysfs after module load stores that value
directly into clt->mp_policy in alloc_clt().  New sessions then report
"Unknown (<val>)" in mpath_policy_show(), and negative values fall through
path_it_init() to get_next_path_min_latency instead of clamping to
MP_POLICY_RR.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.9388=
76-1-haris.iqbal@ionos.com?part=3D1

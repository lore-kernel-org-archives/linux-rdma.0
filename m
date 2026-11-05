Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886869;
	b=DWVfYgv0e1pqL0KBPW2RHsZIKO56RuPuLGL8cFgwM01DNe1qSyacAZ7i3XWKj/4R4R05
	 KweLqiIXzpaI3n6yyuOAHp4iQC/sV/QsMUi+7dtvSGW+MKuIS/T/Fcyoy0t0W+43W/7dt
	 KTJWo1cslYVHOryQsetlpmvmeln/yzv9PNHN26p55S9qKzko3vLmYiqzqx0eIJGOVHVCJ
	 +jaLECa9puyDNe+8E/Z93XE5u1UXbzHUGPvDw8Ayljl9xCOscGJxXqze4K+hVUnbbQwar
	 Eztnh3vAT8E92RdSpA7UOvh85DwDY7ANnIFn9n1yzFYe2N8nd1Uv/HsQlt/CeDVaSHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886869;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Y8DD57fC2j6CrK2mpR2Wjue08rOsdhPmsgCv5F0bk5M=;
	b=L/qPZRAZpCP5/1+PugockCvr04Qc2xNoYa+lukTa0k66t95flgsUfYu8gtXMvu6/6jVX
	 TrWTH7EBgTJKXP7fTsxM158ZJGm/zNr2TjmsDivlBg4bxMhRcBjeei7P+JInfQKW5F9za
	 r2TPcsYOQZMIT4rWlsdF6nmHky/YEupkUp90npDuplQPqfCBfI7KxtkeVIBzHzEOEZhrv
	 b50v97qr9IJn0zSvOkCVnNy8UNn6rlkx23DqtX6/gOqJYzySJ7ZEqGhyFUsOL92b5ATLp
	 /c0ITMFRAr+LSGnUOXjuG/Ue4qrbjI3ThSqlVHRuD0AsSpq/d+4BwdF90QZijHcSQgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=KYGRv6ef;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33977606A32E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 13:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33977606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=KYGRv6ef
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4b4571ff080so20367505e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 05:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1793886866; x=1794491666; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y8DD57fC2j6CrK2mpR2Wjue08rOsdhPmsgCv5F0bk5M=;
        b=KYGRv6efmo5SCAkP2Ws2kAUCj6ljMDSd6DrEYj21Q4na8uQbaaai6wLHApo0qEzEP+
         4HjDyzIjfIDuO6lXcDT5D6YYFa1rnsOwlO8cmH0ijbutCiHYqDNVPbU//9m15cwIuK+P
         l8qiEtKsKsfAAETztJ+AQovUklB9tmUzNzpX1vUu4wWwPjVq/x6skzJdC4N1aUV6enOW
         PsA0OOGJhqyjx9sl6TVcKLWMWsKTUzccaskDUqQ1t1LgdLZ18KvtBWgV1bkHxG3PUv2q
         Nbd0cFUg2MxhHIEZ/8C/9aXbJNrbunGz8dPlbeKcP4esVFMChp72s51XggfAbzOGeH2O
         /KOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793886866; x=1794491666;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y8DD57fC2j6CrK2mpR2Wjue08rOsdhPmsgCv5F0bk5M=;
        b=SOANKNny2mtYKZ8XtY0Wr/OwRRXGQzS22w38L6TB3oGovS+YLFrMdHFzD6Xze2HOvo
         S+GT4TDPOLg7L7FPwid2FrINUDDZnL9Hi+CCM9urVWjz0+4Khh1XOaNjzyJ/YskAqbrl
         leN8IJkltAeXD9b1kqmGiXUiT7WrDFjQxTwhfa8VX53IVmp366mT+QXqLrxJsOXOQWV+
         Tp/ouR7VVcKEZVXBERmqT3Kw3mdq8SwlXU0WsVsTPc1YQV2Flnxrv79Utd+i9Zk0+2nD
         KHSKi/gIIgn5c4MkeahYhZ0xHPLtyMFJ6zQeaxBdhBmPehrk0M9kC1895AtJrBFGz3qU
         Zugw==
X-Forwarded-Encrypted: i=1; AKwUvBxLgwaW0nj9rhUZ4etrvefQ1dgoRpW6UyKSDN2oRAN5wblKHsEJDEJg1pIclT3t0FvNTFnfeDuRNKvU@vger.kernel.org
X-Gm-Message-State: APuU4Z/IN5vH3bFh/GxWj0nvvYN9QXDomzUpupZznKFs+ihN3YG6hnh+
	7ToZhwB/x2CjEVCYC7Mh2mc13Z3QRaVgmMBWDebZoredH24ymjVI0K9f1e9mEw12LZg=
X-Gm-Gg: AYBFou0ihtKLR17m6/c43M4UpWi+1CqrM19shEzivixDP8k/0vl3eeEnN4tZuRBUs23
	wH+dw5Sd4wiwiX3yCVmO4BnOXMEtkMIByT9eHbi2pHAHY6unbVxZFi4FchprKsMtc0qZ/PQ2Hnu
	vSFJTj4BD/PeI2qiQap+gfBOQA8EnkH7WV3CYeEwjWhGGvIr876bug6v1Cxatl7N/z7Gp1IBx4Z
	Kfd70MLfmhOEddImuqnRHtybUW63d8WbsqhY2yY/IiANGwTrSxEluXo3Ked+WyhZPPiILQ1P91C
	NxhYaG1QXFvmATyRHSib2eaQmCAGpYdGrKxWovq7GnCkDMFO2J/S5x/dskVZk+gT/NjiwtxffWv
	JYiQHyZxGB/eZ0QCsFysl9DOKmJggx34caxhc8ifYMAceyYS6hVIvmvzSTQ0kNOHGHB47OEFCzC
	wA7AalhoN2b81hwAKNdr55zDN5+eefBbGXUcV9RzQ4la2QzghlQPN7WecnMNBfSKDZKAax0qMV8
	BveYKoUeXWaWwqOrw+gWQEBRt6NoQVQ8P4kkm3l2EHata07wZwZDl+mD6jrSelAfu7o332dzBFl
	pokYxC+ISxRRfIplNvEU1Ga82nE=
X-Received: by 2002:a05:600c:4f8b:b0:4a3:5d64:df91 with SMTP id 5b1f17b1804b1-4ac17ffaf95mr426570585e9.18.1793886866545;
        Thu, 05 Nov 2026 05:54:26 -0800 (PST)
Received: from localhost ([194.213.108.7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4b56f0237aesm70297105e9.9.2026.11.05.05.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:54:25 -0800 (PST)
Date: Thu, 5 Nov 2026 14:54:17 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Doug Ledford <doug.ledford@hpe.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Iraimani P <iraimani.pavadai@hpe.com>, Mamila Santosh <santosh-kumar.mamila@hpe.com>
Subject: Re: [PATCH 04/11] RDMA/cxi: add the native ABI and resource
 definitions
Message-ID: <auyIsEVLUBT4i12F@monoceros>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261030-cxi-for-next-v1-4-bc6e49e07037@hpe.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a4rnyelrw54cnpdq"
Content-Disposition: inline
In-Reply-To: <20261030-cxi-for-next-v1-4-bc6e49e07037@hpe.com>


--a4rnyelrw54cnpdq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 04/11] RDMA/cxi: add the native ABI and resource
 definitions
MIME-Version: 1.0

On Fri, Oct 30, 2026 at 09:35:32PM -0700, Doug Ledford wrote:
> +#include <linux/mod_devicetable.h>

Please drop this include. Even if there was a usage of a *_device_id
this would be wrong.

> [...]
> +struct cxiverbs_lni *cxiverbs_lni_get(struct cxiverbs_ucontext *ctx,
> +				    u32 handle);

unusual indention, please align the continuation line to the opening (.

I would expect that this declaration is added in the same commit as the
actual function.

> +void cxiverbs_lni_put(struct cxiverbs_lni *lni);
> +
> +/* ---------------------------------------------------------------------=
--
> + * Protection domain (ib_pd)  =E2=86=92  shared JobID-anchored LNI + RGI=
D (isolation)
> + *
> + * PD no longer owns its own LNI; instead it references the JobID-anchor=
ed LNI
> + * from the ucontext. The PD can optionally express a preferred_svc_id f=
or QPs;
> + * if not set, QPs can select any service at creation.
> + * ---------------------------------------------------------------------=
--
> + */
> +struct cxiverbs_pd {
> +	struct ib_pd    ibpd;
> +	struct cxiverbs_lni *lni_ref;
> +	struct xarray qpns;
> +
> +	u32             job_id;		/* cached from ucontext->job_id */
> +	u32             preferred_svc_id;	/* optional service preference (0 =3D=
 any) */
> +
> +	u32             rgid;			/* RGID for resource isolation */
> +	u32             pd_id;			/* RGID-based PD identifier */
> +	u32             default_pidonfep;
> +	u32             pidonfep;
> +	u32             qpn_addr_mode;
> +	bool            default_pidonfep_valid;
> +	bool            pidonfep_valid;
> +	struct mutex     resource_lock;
> +};

Please make the alignment here consistent. Either align all members or
none, but not this mixture. My preference would be a single space
because these alignments tend to get annoying when they are kept during
future changes or diverge even more. Same for a few further struct
definitions further down this file.

Best regards
Uwe

--a4rnyelrw54cnpdq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmrsioYACgkQj4D7WH0S
/k4+FAf+PsChnDyjO+yWLbN1ez4nNv7S+z5I7eoSvvWJ+KNWzI6ASwfI9LEG9yvy
qlKZGTAjoCnr6Llb4wefzul8a/JXQ6LZeJbZIfpH96B7B5ftDTdLGJ56s0Cw2M9r
uilNr+VB1D31Wmn2uUisNu8qnpw/7IltLdwmisE93fgY0j9mJLA84nqdxV/empbo
VXgpEVUcpWqI8PGOmU+eTcygZW/iST4HJSmJNIPdalkw/iHmle15JPR0HFhV3nCU
1FVPDqn/mY5BdiUR00I5m8zzJ8GY02zkf0+J/Cf44KtAqPOp3TYMtM3cKMUmDVoM
Xfd9Nw78oH/4go0ZSoH554RsNB4fKQ==
=2n5D
-----END PGP SIGNATURE-----

--a4rnyelrw54cnpdq--

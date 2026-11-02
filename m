Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793614098;
	b=bGgUj3DzWAzb8S/9Ox73vmbN91lB1DnxoBfnTUfZVlUzoXemmm1nhNYDQFMhKIUtkLJJ
	 3mWfPN7a3fBYFY76ebFi2yKrmpgEBtaRlJcataD0W6rNGJ6wC0ayf16dJOpcsjf1W9v8T
	 BCog621JoOq/6z7CHlHk7HAqA6Ts45KZj/xYPD1SWCEUKwcjOLWaCe6AY8cBN58LA+yM0
	 uEV48TnQ7TojxzB35lMKsrFyPYJsA9f548Ijblym2HbzCEm+euFxfYE5Br+rJk0sTFFfK
	 dTsYAnfrPUVQQX3xSoZ2FPTSNynzTkpmGIvMPNMI1OpRr5n+Zwva0t3IhztIUAEe7uw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wjdX9vjSkHROmqfsKSKqGYi8+XO+tioACNXCf5IEahg=;
	b=m9Cd31BDY4/6k2GKkzPZL/uSEoq8Abfd4vyWHNTmOozJs5bhXBfQaQpdkuBoP1yu2HS8
	 heEB+Dh/1hv9dss7yPXOtxWnPn2x2KtzpAObVARuUx2/+I0ADg5GtZkb3vIEFkGuaIceT
	 fOIes41n6F4tQuWFpZc1FkJahMPPlDkB67IG+TYXVoYVpULthHsjg3UE7KfFR+r9V1hQu
	 AcrJFW+RvPhkI32guy/Yiv++uTH5lAgx6nP6a+T8L2dhmkHReOwnmCcRjReHMdY1qFfi9
	 4WTvBLeJCe8i+ubPeIZa/MrMaaM/OjK05aBXz2VvBrDH0k7y/mDpdYvJPjC1QZ2UeoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JA8H98Wr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89BD606A329
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 10:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D89BD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JA8H98Wr
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-677d35fd1d2so2536854d50.1
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 02:08:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793614097; cv=none;
        d=google.com; s=arc-20260327;
        b=Jl3GzNjH74r5bCj82b1tCo5oZydfnFag2FJ+z0iKubwUvIApMCo3u8xsEj7beM62bC
         y1IOJ8Cpmq1P7cvVmnmy0ZoYmxjUr94is7UKFhMiZN93B15BBtpoevGLX1VRn5VkkF8R
         X90/grwAgDDrGs6vN/LjQWxVj6Ty5t6R97OGwYP5f1eWMKma1BWkCqhChnAeu0qFNGeN
         azqWxQiUZAlXiLBBEiZDaXBOpIoWpQbf8Rk4mRHmnBC5hFQ91u4ewjBFV4nZAx18nltk
         jnDqqns3mSfOR2+ivLWS8MH7/PayEwwVcq2WH9DshdD7FkaDGkUO3nDIDgvCOqru4uL3
         hG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wjdX9vjSkHROmqfsKSKqGYi8+XO+tioACNXCf5IEahg=;
        fh=SF388+yM8GKrfuIWgxvYZzLKgjAy/ceZ2ol/bG3y8pI=;
        b=JTF5KAq7oJiDFxlXe543adRxj0Z9vVe6eFqvOh7xMzQTyUwLh58AOeTolqPluB0K+7
         +EVrF+rLDCCHtErk8bmHl+ZQNTlP7uFX93NoXUmZeXdj3R+8T6Fw1PPyt9UzxQ1gf0td
         ry8Yz06elePrSIFaZpYM8hlggY6imUwiqG3K/rns/bTJOKksPtAPjU2E4MygrQ/cBDDS
         M03vE4jXjoF6HLrX/SMrtwjljlvyIwWEOnHOh8oN0zjHDkTPPFyF3GdT+8Pbldm8USBD
         9O6AU1Qci5RN1vB9FAMbRuza+URGXG9Q9OcTJGkFScZsQYfcEvN8e6MKI5Af+DqZHLIa
         vbiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793614097; x=1794218897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wjdX9vjSkHROmqfsKSKqGYi8+XO+tioACNXCf5IEahg=;
        b=JA8H98WrxbjorH6fYzNlpwEnkRdhQP78BDVAampLqxnP18Mi6TFaP3r8pDXLYzayuV
         IzeR8POsWALnuR3XXhVpJwWzkP10lwcmKF4EOuIBgPE57n56qSoi15c+jKmufdjg5JL0
         2dJKVdOppcgpGuMRa1S0+JOKiMS7GN6mE5+f2bSkv1EFR5wTN0WOB1bi7/YvKD8v0A7m
         YtW9yL4mB4JcX2a6ROGUSkw8diE4HyG+Oo01BH0Jvr9spQI2uUS94x5onQ9B7pGFgz6R
         hQcJm4dcsS4m2LQLE0LAjdWhLsQBLnuz1e8TZSPPMw6SkGPqhWmOeNY1AlZscvTVBg6i
         EXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793614097; x=1794218897;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wjdX9vjSkHROmqfsKSKqGYi8+XO+tioACNXCf5IEahg=;
        b=ZtjB2SxpT8fbRMrWhNRBEFhmf7R39FmW60POo60bN5kedUG+Q9NVs2an3jQTtet/JB
         zpoE/+1f2DT23D9K8dN9r46rot7z9sisEOii0mJyNSKxBu+OJza2B51Y540ZzMCDDtRJ
         Dn/tGrnQzlrgAeD92nPjxd2VzhVs2JAKL+6NTLwDaO+Y4gDIhAoq+oZL/fCKp3UziCbG
         Ku5JbpmudWZHlAcXdc3gCqMvuKGLRScnKU4TZwKw47lhZ6lUfhbKS3CckYM0DPXcy2B6
         gp1zXgBl02CQvQ/Vo0fWlRVloMY2IPJWh1WuiAfb0DGz3qYXOh2FHXy/lf9d8lLdquh3
         c+bg==
X-Forwarded-Encrypted: i=1; AKwUvBzafaCMKanl6yG1QbtThqSBawR2qtulsMuydLKkl+teZjcBEiq/XFrlJMIaFa9XnwyGaTPF5NJLDjQS@vger.kernel.org
X-Gm-Message-State: APuU4Z9Qb7XDq2ksaIWbmjHZUe4n/SjxQzp1sRE+oq60cws39Xj9i9zu
	vLEjKGwYVwWu7ySBo25RsTl9nuXvq6X4gWHrSLMjohV4VaSGKGLALzXkLf+hUCG3nGRX/JnFHmf
	5kYynB7g4G5UKyJsKcfPXWTNXPaFB3ik=
X-Gm-Gg: AYBFou0ZYyS4AE0Y/ZKGOHjJs/PHs4MxrfcTz2HKZKh4a93kv5panJMs7WJyXmJHJRc
	yKwR3FUolJ+wX0AbgEoNv2nM8wXvgmSBiXJXDziWAyPFqfSPYBEuRu4OiDuq5Lik+XST0+3TKJT
	7Jz98qw7e7SeMWFu0fjQMqLyUKPHPgVf9JNmZfCFsTbgjHcug2AwK4Xl85fsz8eBNEsji4jB/AY
	3uOlU7Zay+n1L5GYbMvdOA7oJcoRmWOzIZowdp5CiazWWfCAVxhpHSaN6UzxE2fgzav50CQdG9V
	mFGZd/axX3ulieAfIKu5npl+MFeqFUUOrjEQ2lrdfqO8eqR74xnKHE/YHoz1Py2PFpBXlf6ocVj
	ghl7WPEO4pOltPTx8fMX921onx+kK9bVgh5diSCtTc/sDXOYX5urTescHiHSVh9WK70e1DU5c7T
	XO+fs7G9IUEy2dsmlAeRJK04VHC+SVE05UljbMCZRyp4MuFogaJs0SsUaeLc8dXJufVhyf3vACl
	o07yB9I6fo=
X-Received: by 2002:a05:690e:12cc:b0:679:b2ba:3cb4 with SMTP id
 956f58d0204a3-67ba503171cmr5496564d50.59.1793614096717; Mon, 02 Nov 2026
 02:08:16 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101105615.20253-1-kartikey406@gmail.com> <577128ea-4d44-45cd-8b3e-5f103e530d98@linux.dev>
In-Reply-To: <577128ea-4d44-45cd-8b3e-5f103e530d98@linux.dev>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 2 Nov 2026 15:38:05 +0530
X-Gm-Features: AclHuK_qPDvsdMb9b1bWcQf48bDpbIfluE3IgFGIXnQRQWbM2y9h1fsbTWibNzM
Message-ID: <CADhLXY6WuOVmZLkgffcy2yd5tuOBPKYm38mhBFy4LRTQ89ZDuQ@mail.gmail.com>
Subject: Re: [PATCH] RDMA/cma: Don't warn when device removal races with rdma_resolve_addr()
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, leon@kernel.org, metze@samba.org, stfrench@microsoft.com, 
	xiongweimin@kylinos.cn, ammrat13@gmail.com, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 1:56=E2=80=AFAM Zhu Yanjun <yanjun.zhu@linux.dev> wr=
ote:
>
>
> =E5=9C=A8 2026/11/1 2:56, Deepanshu Kartikey =E5=86=99=E9=81=93:
> > rdma_resolve_addr() on an unbound ID (RDMA_CM_IDLE) first binds it with
> > cma_bind_addr() and then moves it from RDMA_CM_ADDR_BOUND to
> > RDMA_CM_ADDR_QUERY with a second cma_comp_exch(). These are two
> > separate steps. Once the ID is bound it is attached to the device, so
> > cma_send_device_removal_put() can find it and set RDMA_CM_DEVICE_REMOVA=
L
> > before the second step runs. The exchange then fails and hits the
> > WARN_ON() added by the commit below.
> >
> > syzbot triggers this with RDS over rxe, where rds_connect_worker()
> > calls rdma_resolve_addr() while the rxe device is being deleted:
> >
> >    WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src
> >    Call Trace:
> >     rdma_resolve_addr
> >     rds_ib_conn_path_connect
> >     rds_connect_worker
> >
> > This is a valid race and not a kernel bug. If removal wins before the
> > bind, cma_bind_addr() already fails and the error is returned to the
> > caller, and err_state in the same function already ignores a failed
> > state exchange. The caller gets -EINVAL, and RDS destroys the ID on any
> > error from rdma_resolve_addr(), so nothing is leaked.
> >
> > Drop the WARN_ON() and keep returning -EINVAL, and document in a commen=
t
> > that the state may change because of device removal.
>
> Resend this becase some error occurred.
>
> For this specific case, we can consider this behavior expected rather
> than an error and remove the WARN_ON().
>
> However, I'm not sure whether the WARN_ON() is still necessary for other
> test cases.
>

Hi Yanjun,

Thanks for the review. After cma_bind_addr() succeeds the state is
ADDR_BOUND, and the only legitimate change before the second exchange is
device removal (cma_send_device_removal_put() sets DEVICE_REMOVAL under
id_priv->lock without comparing the old state). The other ways to fail
are ULP misuse (a concurrent destroy or a concurrent call on the same
ID), and those still get -EINVAL returned to the caller, as before.
Only the stack trace is dropped.

I can send a v2 that adds a comment explaining the race, and keeps the
WARN_ON() for states other than DEVICE_REMOVAL if you or the
maintainers prefer. Please let me know.

Thanks,
Deepanshu

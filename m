Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9380325B0BE
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 13:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810681; cv=pass; b=gZ3WyfjKZGuGLPY/tWsAd+DndCwSePotwNZt4EoehuMWkb92RjZM3TKYXkpm4cVEXsI53+6GDr7zdiia2F4Dc1o/C5pki6hFRqkle1bjdXTbA6qyfBpcuQIu3qWn9bKuxFY1VGIXFvpylmi+DCmesYYpxqhu9NwAnW5LoF8NYZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810681; c=relaxed/simple;
	bh=vZHWFDEmbKduz63d699Nep2aAfQ+Bo8jP6g5WKOHG0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RAgOjIBax2SpTgZmxM/Aa+DRqCU5W5ffRnGQknO9IBPPbf2412qkIokx/8YKcXOyFph/XoHtuaHYqo1U9mndBsSgYO08A3t2mApD75BltHowvsHTw06nxjm1mS1d4c+dL/hxvTjVBQG/AJRNFQm5bxO8m5zT/lyXiXirVHQAbpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=VI//LySD; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VI//LySD"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a87c8d792fso2528231fa.3
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 06:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791810677; cv=none;
        d=google.com; s=arc-20260327;
        b=Hlt9bvQdwion5+o8Uerj+5szlK/Fopm4FQxsGXdsQH5xf4eKOQ2vPx5XU1jSxSPK5g
         P6igEWeQPSbPTDy9E6NEsdWLxXTwMyc1YsYm1uA6fPoEsR446pEeoiDR12a7JNFuIbcD
         7nqbnwFdgoP16Qvsn66l7+jW2/F0DyoU7P/X1sg4mqItIFhIvh/qskYscsxLt8ntDGHY
         hDi7JiHUNuTgmdSBKHV5pOR2E6FaFIXUObwXuU5ldtHuaqaJgZHmQX1RICxQqRGP4RDI
         yd1Bd7qtKGk/K1prOMVkeWhhLmoEXdeDODK6+/FF46d+F3KLr3vUMgReYVMk0pEoI4BL
         dNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z+0/3nkr6N+f3/zaPQD7b048Vl6ulUc+pAZFeOWlLi4=;
        fh=HwtQlls1ENI7mYR+gadTzOmTV6g0lWqOKFtHDMJNdfY=;
        b=BBTWlAXMwwR4yxvSzO1t3oba2l/JlcU3KfwzslmHA3vlnmh8NiUQXFFHxR+42VN94n
         Tco44/GGbML7KBgD3fN8P/NRrLYV+fHs7PQKyRM5VuqEWrDcGO4TC15JtbzDrG8e5wa5
         btJeGI7eHdMvoUEz+BOU9QEk4P8VVU4tixd6MPdcLPGhumr3oorh9AjYMMxSnDsR3u5e
         F5XmI8HcGOzkuPCeSXH0zwzsEpOqbyBlhEzQ+yF5opWlzb3YnP+MPveSw0Ot0lvdfkFz
         Ihq/Y78Lw0UwyNHj9+NCUd/lVFnCyXYxRbOhiltPqP3NPMOoZsjjlVK6ubmFRdDQhd+4
         bZLQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1791810677; x=1792415477; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z+0/3nkr6N+f3/zaPQD7b048Vl6ulUc+pAZFeOWlLi4=;
        b=VI//LySDVelveBZwPbq4GaS6cEw4S8KniX8uH4PNMll5Vbz8rS5DmMX8JRAnJkFNHi
         MGPsuiPHM5uhR8eY6PrGlfNSBM/n8wnKhzh3feJta9p+8eBTO+QI+jPBq+Qt+ts/9WUt
         glmNSWFZJOciy3caHJrO7izcGMKVHntcj/i3wJwvEf46I/Ip/lJOhPNvLFpTouKA29IC
         q0r/DG4X7yJaUk5WXXFeRCdvvz1K36C/KxBNYyHJpU8+lBCHq8wkk/c4rQrFySGhYJmP
         p9etrRf+6aLPxo1XemXV6d9L1xFft83E64HAcV2y0TB7eHtTvfsYXfC1JcK4WOp3H7Cw
         K0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791810677; x=1792415477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z+0/3nkr6N+f3/zaPQD7b048Vl6ulUc+pAZFeOWlLi4=;
        b=Gc/fcfsssuWZOa5dHTMVbn2a0tlqGGq4vdhUfi9ckP9kqbAQ1fzBMggU9TkkW7f+C2
         9NzrRrWLrZDM521MB6/KJBZ3uUvNvBHzW6+FE1b3P4M8cw1wY9e0AAkot4lPrF+Ovy+C
         9C9S9T8FsRe+6WXQwSPcnqJAYI5E7G6CkMgnwpgB23GLHl91ihZ3RVkr3pneDehcAsIt
         DLNMszKQ04ZhUkM75dKUVAWj31RsYbY8PDO1sBg3hZCA0xBylEyphKdIEbxE4wdjjuWw
         6eOJ4DMNsdlIe4WC+KdrYr2gukZ/9rTeXAp1+1x4apEjvvygzbbg8e8Wh9u9QKxxIGVK
         +NpA==
X-Forwarded-Encrypted: i=1; AKwUvBxZXraWZWuCjrsv7gKOraH1PDmBlGMsDpeB/Q38KNKQElzD8oXrTQVo/6z5DOKYae+rmfMxxc4ijJ3T@vger.kernel.org
X-Gm-Message-State: AFq9FYJNOhTQqxSGaU2VSMBCUwMsrVs4FdIZO8F8vXSQ6SQj7KXGVqO6
	5HIs1tLcEdkEZkqGOwp2WNNTa+itH4RMnXjZChDWbxsZuZccH8SOvyBwgvkXSSgTo82yOvTV3ux
	GiZlR4APUFG7UVOHwvyVXKQOJ1nhjHCk5IDxW2/7wf3vxOZlW1Iu46lo=
X-Gm-Gg: AYBFou3pkknlkcqq0iRcM13x09epvaXJYT0SDTa5nFdJn8P/INTsqoFECRveyfsY2VQ
	vuoKr39rjY0NSFx615d1JOXYA4pM9F1yM60M452I6sUPOUN12zp5flodLzhJGQV0bEH25LXa8hr
	/bVlC+zs9d1bfmgKs0gpLpgJgmCRRZOc36u5kHKFeV1ey19upJGXoexbQqRsIjt155i9NbSnC5D
	UmXHZwkpCwKicZYKNNM1JtR/bPqTeuI9/LGVQILrl5Y0IJ4hgiK2Kbo/oGYptgKaHLWr1yJW89y
	D4roSTmDt0vnNfkWK+ocJh6JlgOU/9CpG7bDI4pXXHBhkYSMGGvVdA8=
X-Received: by 2002:a05:6512:61ac:b0:5bc:e45b:bf21 with SMTP id
 2adb3069b0e04-5bce45bc064mr3045870e87.2.1791810676631; Mon, 12 Oct 2026
 06:11:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009131715.39217-1-serhatkumral1@gmail.com> <20261012080826.GB219304@unreal>
In-Reply-To: <20261012080826.GB219304@unreal>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 12 Oct 2026 15:11:05 +0200
X-Gm-Features: AclHuK-tL9QNeyAXSqRN8d5FNfYQlOeSFxAyQoXGFxRQ7IA3NK9qBQr56rP8C0Y
Message-ID: <CAMGffEkYWj77M5V_p9W+i=_pKEg+seVV1S_EaFro9-feYaki9Q@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs: Use strscpy() to cache the HCA name
To: Leon Romanovsky <leon@kernel.org>
Cc: Serhat Kumral <serhatkumral1@gmail.com>, haris.iqbal@ionos.com, jgg@ziepe.ca, 
	danil.kipnis@cloud.ionos.com, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 10:08=E2=80=AFAM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> On Fri, Oct 09, 2026 at 04:17:15PM +0300, Serhat Kumral wrote:
> > As the comment states, the HCA name is cached for sysfs. Use
> > strscpy() to copy it directly without unnecessary formatting and
> > avoid interpreting format specifiers in the name.
> >
> > Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> > Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> > ---
> > found by smatch:
> > - drivers/infiniband/ulp/rtrs/rtrs-clt.c:1906 rtrs_rdma_conn_establishe=
d() warn: call of 'scnprintf' with non-constant format argument
> >
> >  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniban=
d/ulp/rtrs/rtrs-clt.c
> > index 927e3f30483c..c85e22f670ba 100644
> > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > @@ -1918,8 +1918,8 @@ static int rtrs_rdma_conn_established(struct rtrs=
_clt_con *con,
> >                * Cache the hca_port and hca_name for sysfs
> >                */
> >               clt_path->hca_port =3D con->c.cm_id->port_num;
> > -             scnprintf(clt_path->hca_name, sizeof(clt_path->hca_name),
> > -                       clt_path->s.dev->ib_dev->name);
> > +             strscpy(clt_path->hca_name, clt_path->s.dev->ib_dev->name=
,
> > +                     sizeof(clt_path->hca_name));
>
> Haris, Jinpu
>
> These names shouldn't be cached.

Leon, you mean the hostname could change at runtime?

>
> Thanks
>
> >               clt_path->s.src_addr =3D con->c.cm_id->route.addr.src_add=
r;
> >               /* set for_new_clt, to allow future reconnect on any path=
 */
> >               clt_path->for_new_clt =3D 1;
> > --
> > 2.53.0
> >

Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312F369980
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 06:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784357717; cv=pass; b=eyao3H588UU549xnGyUeKeoQB0paq+sLp5eq2RST9z2Q3j0E6S47IQfxwD7Uy0p+1x4v9wDRJT4a+KiRUJv4UlYcrlegHlrxa3/hqWKrCi77DAvRvzhAhlU4BsTfF3QYadloJg1tPwMrY6sXTR5sMGFP6F/J471DhOXS6mVEskY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784357717; c=relaxed/simple;
	bh=3HXuM0xbB9ZjYajXsFxIO364Ea85v7v2vlxwbYKFREw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LhzMp2MY9Pt6oIS1JKdFJ2E8GLxh+NRg6LFoEAi6axdeICENZK0Y0WpSXguvLKZH921PiMXjyo4cgDFhOzRi0m+Z9wIf2T2G0tEF2JNtx7WndYi+FUol5TWKwbVpQUMW9cz7T8bGoBVRunqwqr19RNFvRWuYyjBIXGlgx03tBHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGPNKJf8; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGPNKJf8"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81eaf3709b4so62350247b3.0
        for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 23:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784357715; cv=none;
        d=google.com; s=arc-20260327;
        b=ZqqWMQx4+lJz96Ww1ehum6w2RBwAePC+0uyf7hsTVi6c6gcP5n2NOVxCKVt4ZeTcaK
         PkHsEPtBIbE/E/WtD27ag8FetzJ1FTtkQJuBuYIFXHUCb0xod8Ih4ZzX+j916q4Bh2mY
         2xzC6gt0+wih5ej20z1tJAjIHWrB0ptbQmnOf6K6LiF7A1aDvEH3t6eMpjkwu+HfnYQX
         olbu8T5wJUQit1no4atvXyXsBGEup1ZZ4PFniJNp18nvy0fnzKk/I+2GOj2QmdSGvsFV
         JzrHWe8XITT/bBfTHpudr756F6QFUwQ15/8DAUFbVSGbPz6UH1jFEy5I++Rl/0yFwy7f
         cFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6SRa8XLwCo7Ic+ETUfDLMv0LJrBGSH7qHZ3uFel85Ng=;
        fh=/5F0FlBmg0XtzkPZJRBzs3AuDR+EFKZX2aCo621Ke9A=;
        b=pMLMf1rL5n/a/ieDGCqo7aV3YP8PrxOlGOwwRuO9lpdNhab+rnO/3oFnYGzmo/vHPF
         uAhTpjl4dtA6ppuWphJ9GndESFtW1wsE0hDcpJrzm6bYTBwTlko7imC9u6no7mK+WK5T
         DQAb474VMJQqY+tCW4sqim05Lu5Vj7aMQ5vxLXcA7GfxQ8+fjTjdvChz3sI5nzo8iRGv
         vtf+O+kFcJQnD0duIJpHDU+/geWOh55oh1PNgyD33fF7bYxcdiHjIb/+K7noZeSED5fA
         DzNbmxSLTBGuB7aZ4cEE7eLF1WEdoitYJ5Hdb8y3Z5bqnCyufIgrqDIgVO9+EXO9l/J5
         txhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784357715; x=1784962515; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6SRa8XLwCo7Ic+ETUfDLMv0LJrBGSH7qHZ3uFel85Ng=;
        b=bGPNKJf8W3vy10kz0ppyevyo9d9Z3sNs0rxclKE8jK/pg2P6r/nedYyHdPljhHA/sq
         Lmm48iXNLZRQhs7/spbIkpnPCbKQqx3eK2YK4Vo0kN2VLRr9wvSve7b3qs0R9eH3BpkI
         KFRM1z84lOMsEv1DTcM9atQSw9XIiFW9FD1C53+/TF7CtbNFBpZweid+1F5TDyjD1vM3
         X5OSdRoc8WnJUqDWlYoXsdCLDNw3RxPr/pmiF4LcZ6+jl9FDjHChQA4eVDllzddfm++B
         lCb82Fb/8w5r6JpkbBDWZxaMSL9F1r5SDxT7k3SzS2HuD+SkKalceb2wMtGLHoUt5Elr
         7WFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784357715; x=1784962515;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6SRa8XLwCo7Ic+ETUfDLMv0LJrBGSH7qHZ3uFel85Ng=;
        b=jOBC4oDMbG3yvJuTqzvsrLTFwQ4XpFNSI9M6mPMpRr9+Hxd8rLcn1Verl1TpG3/G48
         nigsTcKz4Zj1u3qfZc/SCa/B0HDs2r4usBIdNImnGcjkIz6vNGUWZpKB6NAClj7cW14u
         IjXKa3Px5jb4mK21j8cW4IaYlFGFeP0IdKDRDEjMpv1vHKWP4AD15NXQA+gVvC/hADpl
         DLUF3nqNrOP/Cdm0WIGpLNEJdYYczccQFUisan0XMfxmDqoVnLyAZVtabS+CvlhaMYew
         I70bUEPJyTIoe7b8ci/7efiyVySmZCRAnLq9Rfj31Vqiyc0E0j81ypUDJmWk2JFfJR0m
         gAjg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/M5+G0MC6aWA4lIT+RhyLxrsbwYrCjuDC8CxSIcR+oEan42MovosJ9wi46WgJ3QNhyAKn9oiwXS39@vger.kernel.org
X-Gm-Message-State: AOJu0YxlEI6rGluONiMElydvJS2cpHNvlGQjNBa46UIvcbCe3bhl2XFs
	8drIJSkDGvVd8d/Po1XNiXy+x4a29RSgz9P103jBYd8ySedAovQi/xg402Xmyj1BLHyUGLGOjiy
	ky6Sw9gSnafEshHmv/niScV/fKrJNzxRAjZjxF1sxhw==
X-Gm-Gg: AfdE7cnkbcDZFQGtJV7TvXJTGxuX42Q7JCiazvDa/PZnO/nqqiZJXP0zaY9EyB5pvvL
	pPMCD1SGeBD65/9Zuv3zvAhpOAtrjvVqTgN2CkEouk5XQgvVfNxc2O02SOa8eEWT9Ligg7Sxg/b
	2yFUsmHEGuLjubPsTetoy0puPGQioJAu1+vSNUkgtKa0RpCv48ea+Tby7tjGdzqAjdW9l0Zb3uU
	qzYJ8mTCRM4wQragh31LMMT2XfTgu5aOf6kimEcbz35H+j9w373r0peFhrzWkMg
X-Received: by 2002:a05:690c:63c6:b0:81e:cf49:99ff with SMTP id
 00721157ae682-81ef286ec6emr21309927b3.67.1784357714872; Fri, 17 Jul 2026
 23:55:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714142838.1723076-1-lgs201920130244@gmail.com> <20260715081720.GD21348@unreal>
In-Reply-To: <20260715081720.GD21348@unreal>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Sat, 18 Jul 2026 14:55:02 +0800
X-Gm-Features: AUfX_mxMF7nFpP0bJZj1JVWIBUvABoRUFoZzHni9Wgp1pj-15GIHaV9qe4mob_E
Message-ID: <CANUHTR-wDnrAYQuFvM+PEyZL6SyovFRb-FqVyiBV=1CKUvDG1Q@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
To: Leon Romanovsky <leon@kernel.org>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Leon,

Thanks for reviewing.

On Wed, 15 Jul 2026 at 16:17, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Jul 14, 2026 at 10:28:38PM +0800, Guangshuo Li wrote:
> > alloc_path() allocates clt_path before rtrs_clt_create_path_files()
> > initializes its embedded kobject.
> >
> > If path sysfs creation fails, rtrs_clt_create_path_files() calls
> > kobject_put(). The final reference invokes rtrs_clt_path_release(),
> > which calls free_path() and frees clt_path for the first time.
> >
> > After the helper returns, both rtrs_clt_open() and
> > rtrs_clt_create_path_from_sysfs() continue to access clt_path and call
> > free_path() again, resulting in a use-after-free and double free.
> >
> > Let the sysfs helper undo the sysfs and stats setup while retaining the
> > path kobject reference. After removing the path and closing its
> > connections, release that reference with kobject_put() so
> > rtrs_clt_path_release() remains the sole owner of the final free.
> >
> > This issue was found by a static analysis tool I am developing.
> >
> > Fixes: 7ecd7e290bee ("RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 20 +++++++++++++++-----
> >  drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 12 +++++++++---
> >  2 files changed, 24 insertions(+), 8 deletions(-)
>
>
> We have already discussed this multiple times. What is still
> missing?
> https://lore.kernel.org/linux-rdma/20260428105515.362051-1-lgs201920130244@gmail.com/
> https://lore.kernel.org/linux-rdma/20260511130804.773204-1-lgs201920130244@gmail.com/
> https://lore.kernel.org/linux-rdma/20260514113834.865530-1-lgs201920130244@gmail.com/
>
> Thanks

The previous discussions addressed the server-side path,
rtrs_srv_create_path_files(), involving struct rtrs_srv_path.

This patch addresses a different client-side failure path in
rtrs_clt_create_path_files(), involving struct rtrs_clt_path. Here,
the helper may release clt_path through kobject_put(), while its
callers continue to access and free the same object, resulting in a UAF
and double free.

Although both issues involve kobject lifetime handling, the affected
object and call path are different.

Sorry that I did not make this distinction clear enough in the commit
message.

Thanks,
Guangshuo

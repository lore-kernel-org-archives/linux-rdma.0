Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7154E3D3CE2
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538913; cv=pass; b=VkHTv/o0tJWcpO5FwYuDbsgaZ4I8eClgwzOkiiFPUMHfFat6HDfEbULDA/rBucv+tDk3gp07w4KJLWhj7Nw3HwEOAU5kB2YAudep866Ttk39DDGnt53O8KWvzQf5kl4AvGxEIs6L/xeSsUDbjLLewA2h1oPx2HyeQBQa2GI5ZWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538913; c=relaxed/simple;
	bh=7J20WNJcFbDG3BJz9zBSjgQgo+t8Wou2adAX1mgK1mA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tt+RbWBLpmPH+opE6/m6qrQQ4NIFbq6lZQZsHhk9OjE8paSv7vDvfQN1HknAWVf4jz7l332Z/aNP/Z7Dt0IzvBfhubHNRx5rwSwA8W3woywVJddMLrctAe6bApprTgRIMtYqG4CHyDSaUPCjKbcHvON1HOHkJb6XLRUxGpj9zVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h73Wd3bB; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h73Wd3bB"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81e9d8f3289so73162017b3.1
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 02:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784538910; cv=none;
        d=google.com; s=arc-20260327;
        b=ptB8btKhLYQgPDD1ElpxwWbIGDXQF0dXwpS7PL5eEJn8P776DbE2eq1kBVLumJotdX
         TA0+iOmKDZaiXO/zK3+mtzGCdVySCTGh/oiV89XbXY2ay9oG7/Ewenn54shtucvq3eM1
         RuQ2LJ4y4eGK7SoqQfhdWD/4rBSklkxvMph+rR3WD1K0SaF7c0QtwbdDT+87KNbzEEmV
         +5KagloBLmUBTZuObL4ZDWc56GKkkr4J7HEsqVtKpPb+Czs+51RxqKdlTASiEx2xBNQb
         LdWzJGd24Z0gBvAPSjvSX78CxisxbddD/lQlU3RTAn6rzS5uh9Goe0PClJpltyR7emVJ
         daLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KNImRKuLNAcq9n4QfrBYn+qTbZeWKlcheJ2/1rBz3M8=;
        fh=2icfNyuuhuvJItJrYkUOZlJrv8jmACUrBJshvKt2tdA=;
        b=q/bQJwgFJOapIlHSKSfYPh75Q0/70xE/smQ4y1/4AXvtyXVVXPbwrGgHVfeQK5wGVw
         ciu8gM9qRCAdV2/pDIsMG+jLskAvmYt6ci6umX/xzKWAVpFejzY6bdgfamBCm3J3aF22
         gWsLCYRvV8kk5CflpN0p7WVWDE4tAMRZDs9qC3hJ83mg8DmoIsE1K3fIvSZkZWZC0d2Q
         ZQpCd3TRcctT5O1Abm0xnZOzhkOSQMEk4UD1KAXp53//GvO1eubBcOUa3fYiKF20EKMl
         nq6+Yob7+zYszpG8DxSFEyXeBFXgG38ATrX9Y7M0UJeRJav9a4fyXjYwdpcopjVfEqeu
         M+Og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784538910; x=1785143710; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KNImRKuLNAcq9n4QfrBYn+qTbZeWKlcheJ2/1rBz3M8=;
        b=h73Wd3bB7jl98YeU5mgkGyNW0kfWoNkstAt0yfPA+wfFPtymEyIq98w34Xw5aTlE1F
         UPWcBZfiI21UQQW8HWzn5frcJf4vDOVsgUlI/agoKRGLTQXG2wV1aD8J45oVdQ2IxwYx
         izD6GhuqTmtBgVQqQR+I52JOoHZuKPBiXo4loRq/g+M6RWDvV97oxf+P2kSXKKhzPJPn
         UaPi5enp5ru1SpmAwE14NvjNpQQGlhAwZcd2pwrYtkLxcyh2P50chiArvy2gAnTZ5rSw
         XaKRI/LVZuYsshTpWBhPKD5U65ejQM/d+oWVeo/mpE4F9ku5pdyWXR86+faqC+2/CXAe
         p0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784538910; x=1785143710;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KNImRKuLNAcq9n4QfrBYn+qTbZeWKlcheJ2/1rBz3M8=;
        b=qmyCZfVRVkVyXrUx9Q6LVkyp0PgJdfOhT6u57+SQqM6/BjJb477PcjrwMjchd1v3rW
         +fKcBmqzVho6p6UHskVPt9l51W5n3kaHk6uvFSRUpVWZg8OSZ+gAbwWrLYGUOHSecoo1
         CVQCGIZFTFp1DfiTrZJXZXksEVi7bZiyOiBvkjyM2+ZB9Dh/Uwcohja0vkou20LIf0kW
         TFt6BHpwbt//5MnFUM7Wtwh9RVglgp3cNEejKRrjk5VF9da6yKhjHP15IHYwuqdbbtuk
         VlvDwMiGpwQZIryZuCm3/4vwXx42m6sbCAdN+wVAZPFDWbPPH4nPFmX0m21mSGY9pdaz
         S8vw==
X-Forwarded-Encrypted: i=1; AHgh+RpQxI+JyTxn83bs/u5Fl7Ru5DuEkMXloZHqzlktGt53tcW2yMRyDY+WfrDklTigpCpfEasNMkpVmGIS@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs/9Q1DutrirITPNwK2RkqCAe9AMsA9zRDjaHzl9U/7yX7NrKI
	x4T2ERAyqAJ0/2GE2HTPpUUspjiXAepy+TD4Bja6nABH0Cmxgm8zFV6mqdqAK7wqrfKNGWCGXy1
	hceF6OYG2TdLFDBbziEMQGM6A/I5YsD0=
X-Gm-Gg: AR+sD12Ahw6x4tXbiraFrw6MoOGiycXOadwwJmUYZQnO4YJM4DgbWx8Ou5L4N7n5wKO
	eWIBhpSL0yvF23ZA7I6eqTY/0XwUpJ5Fjm4k6D/jpOz48ukrS9UcPsAeRFgRA5kUXcLUO8bzudW
	h4Sr5hEZu3AHXt9WaU+IeGLsc5i6BiWeCZa9BhwRkLzLrbb2ppYUEXNoPFuhqFIcfCz9im7syix
	3rRE2EEka0APcyXTtpfRJ8Diz70TLJkiWXjg+ORdhOevYJUyyUUutbNaaTdjcvy
X-Received: by 2002:a05:690c:c50f:b0:80c:85c6:898f with SMTP id
 00721157ae682-81ef26631cdmr39001997b3.62.1784538910157; Mon, 20 Jul 2026
 02:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714142838.1723076-1-lgs201920130244@gmail.com>
 <20260715081720.GD21348@unreal> <CANUHTR-wDnrAYQuFvM+PEyZL6SyovFRb-FqVyiBV=1CKUvDG1Q@mail.gmail.com>
 <20260719092638.GC110966@unreal>
In-Reply-To: <20260719092638.GC110966@unreal>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Mon, 20 Jul 2026 17:14:55 +0800
X-Gm-Features: AUfX_mz9f8dAPEZDAjp7NNNgTC2ru0pk9qUhkCF9ucg980ci-UD51wKohRW-oic
Message-ID: <CANUHTR_qDy0KCXt_4YfKuJETA6Qf0SE01Ky0SwvNh=9c8gbYMg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
To: Leon Romanovsky <leon@kernel.org>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Leon,

Thanks for reviewing.

On Sun, 19 Jul 2026 at 17:26, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sat, Jul 18, 2026 at 02:55:02PM +0800, Guangshuo Li wrote:
> > Hi Leon,
> >
> > Thanks for reviewing.
> >
> > On Wed, 15 Jul 2026 at 16:17, Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Tue, Jul 14, 2026 at 10:28:38PM +0800, Guangshuo Li wrote:
> > > > alloc_path() allocates clt_path before rtrs_clt_create_path_files()
> > > > initializes its embedded kobject.
> > > >
> > > > If path sysfs creation fails, rtrs_clt_create_path_files() calls
> > > > kobject_put(). The final reference invokes rtrs_clt_path_release(),
> > > > which calls free_path() and frees clt_path for the first time.
> > > >
> > > > After the helper returns, both rtrs_clt_open() and
> > > > rtrs_clt_create_path_from_sysfs() continue to access clt_path and call
> > > > free_path() again, resulting in a use-after-free and double free.
> > > >
> > > > Let the sysfs helper undo the sysfs and stats setup while retaining the
> > > > path kobject reference. After removing the path and closing its
> > > > connections, release that reference with kobject_put() so
> > > > rtrs_clt_path_release() remains the sole owner of the final free.
> > > >
> > > > This issue was found by a static analysis tool I am developing.
> > > >
> > > > Fixes: 7ecd7e290bee ("RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats")
> > > > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > > > ---
> > > >  drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 20 +++++++++++++++-----
> > > >  drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 12 +++++++++---
> > > >  2 files changed, 24 insertions(+), 8 deletions(-)
> > >
> > >
> > > We have already discussed this multiple times. What is still
> > > missing?
> > > https://lore.kernel.org/linux-rdma/20260428105515.362051-1-lgs201920130244@gmail.com/
> > > https://lore.kernel.org/linux-rdma/20260511130804.773204-1-lgs201920130244@gmail.com/
> > > https://lore.kernel.org/linux-rdma/20260514113834.865530-1-lgs201920130244@gmail.com/
> > >
> > > Thanks
> >
> > The previous discussions addressed the server-side path,
> > rtrs_srv_create_path_files(), involving struct rtrs_srv_path.
> >
> > This patch addresses a different client-side failure path in
> > rtrs_clt_create_path_files(), involving struct rtrs_clt_path. Here,
> > the helper may release clt_path through kobject_put(), while its
> > callers continue to access and free the same object, resulting in a UAF
> > and double free.
> >
> > Although both issues involve kobject lifetime handling, the affected
> > object and call path are different.
> >
> > Sorry that I did not make this distinction clear enough in the commit
> > message.
>
> You likely need to apply the same fix as in the srv patch.
>
> Thanks
>
> >
> > Thanks,
> > Guangshuo

 I will prepare and send a v2 following your suggestion.

Thanks,
Guangshuo

Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE5282F19
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 02:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779070737; cv=pass; b=Waijg4BhNouvsC2D0yRsopcPIvWsdBPTb2ma/UmWjd/FwL+tmeTcrMd6yk+tQkN55z5m9mKZiiy/bcLihOogeLcOIcurNwBKECV8+qJATPa8JGAzMabqf9laCYY9y7mYmZOJO/izLYiWpp3if0rv2yl3a9dvdKcax93FT4YBNwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779070737; c=relaxed/simple;
	bh=EsgsenQYQFbOGr1IgXLgdV/kl1aGeTZNwCzWkANAUpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u1jsoFR0i8Rnr825rUWzOt7s4o5kWZYTsmJ+XXaN92IpAw8xAw1JhaXndXM0qjubSeQCylj4qUCcCLZhWKYk0BvDWKIMVAS76kBU4jc6MgHG/XvbFB5Y6F+AAQ4cL8e/Pbs3d4gYYRznJIHoy+aJVJmCEfI9etJE6rNXgUgFXrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlgHHnGh; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlgHHnGh"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65c305f381eso1977794d50.3
        for <linux-rdma@vger.kernel.org>; Sun, 17 May 2026 19:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779070736; cv=none;
        d=google.com; s=arc-20240605;
        b=ed6ZBH2pCCrJITw7+jVX01jP8/lTdjSo9gHYkyCZNMNQ9Gl0uUXRs1PyttzH4jCYmK
         YQIAYuCWKqsH6jYRst1iYrOMK97sZFZN3TLyYtLeYjr1HNWHdubCh+zp28b0v24vtjF2
         6n8A8l9OHJV5SjEbJbafcQol0XVDvW69L/mLlJ9jACj14T5055NXVrKSri83K0MttAH7
         YX/jucY8psmi4EgklEH89XrKRQgU5HGM6KNqVuaHOvdm3oV4gCxuQDDlzcIkJiVMMnjZ
         sKaGGu/rnqHSaeQZdmHWNjChGh1/eXFWtSH8jdsR2Wt6jr43mHvLUhZZWD35iBch6Aqx
         Dt7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/oS0JK7mxlMz3UFq0hcP+zmFG2ZpJi+5oDQUvOnyxHc=;
        fh=UxsawODRAe8Ta4HSQzhj2yhEYi3qQUUm350f2Y8/E/U=;
        b=Iu1GjVS0U2bdrVat02eyhNxfSrhayE4U2+GNah8cD5pZW2GHmFHP6EMu+/ZkSPineH
         nfr+3eMFsNq02TL/VRwKnGx5BUmWXYYrejE5koBTqPXdmfNbRVKPS5spq2ZxcDcQEQhk
         Jc9oUuHFJYVXaNV2EAkMUFVXGckF3mfS4ecyw8HcTlYzyZ4ur4KNCJ916X3DU+eMPsR5
         8sV7cuS71lQRGEUCXfpF/6NRFSmSxiJQtwtHAkvxLlWpLrF/3co9xFLcynHpo0nGu49j
         ltjy3xuVFcpj6rt7SUcngcrTEQkCMh1vrj5bhdfnanAzXHpo97uyXqgosqS9pYpSWJy2
         97xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779070736; x=1779675536; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/oS0JK7mxlMz3UFq0hcP+zmFG2ZpJi+5oDQUvOnyxHc=;
        b=IlgHHnGhG7fxge9s9w5FJqoePvdjcuH9gCbS/ipBx8qvb+N+00zAqsaT1RwmYQ2zK9
         y9iXgbpWecdNJ6YUs+m1vw1luIyHdqn7YBkWq9yMXd747YBafwuvKZEwW1Q0fNnewSg6
         87u6j+YLW0kKP6alks4rz6J5J92eVLufszwVdwZHcoB5wGON3va+xZKip+n1fvcPAQZr
         Q/Kl02JaseMlkZhI6qTmK19kJ+x6aJC1/HEjP2QRgo7WVUYD6GdSDuiEvHl7sfWoEyuf
         MnR/FBAeFqFQLqswjyikJuQfnot6jNPhJywVlAnYO4iwHozYPN3P4ZuTzlThrjA7WK3j
         BMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779070736; x=1779675536;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oS0JK7mxlMz3UFq0hcP+zmFG2ZpJi+5oDQUvOnyxHc=;
        b=exUxyn3i1GCGVaivpSlpaiNaXc58yMSHHvCMjEXZzxYSMZhN2y45O72tFjYr/RwXhi
         njihZ+IHN4K3kH/h640BSfZj+yLEebomhUKHUhO/CxDbufTGAoofgjdD3MNCByNhvQfN
         ggzrMfgAFK9tbDSjRFNytk/XQzpubFBWL9tj4a7Xc+tmstNFU1JZ5nvn47eq2QOvCBUC
         2BQpIr9u1M0YqKlKCVT/pLLf2RH1mcOBkFZUablPjHt4nNeXqskJeY4YuLrUw7iRC7m1
         uuGpWhyNU/8iqlD/tk+WtY6AylQgKfcNFiA9ObvoWKWG4I48v9tqsCJ101JLL3+7AZZ7
         le8Q==
X-Forwarded-Encrypted: i=1; AFNElJ8G9vRc8miOTGpdZLMfZEY6kPa+spWsPLIMKM2gddhsXzt1gb8Jpp50WJApNFVqua1cZrySkuq6/m1s@vger.kernel.org
X-Gm-Message-State: AOJu0YxPGudB+PrJGxJIiTP+qaZpiSdbH/3XYMaGuyonIBcyf39DozDP
	zyfYefxlctul/sXh0XdSfOiGeTjq0dS+U5uqi0iNDesd1H0Ao4f31zkPigv31E/ndYKYjQt7QGK
	3OhFnrATcgOTPFsfoQkQ5K/VMOr6u721qXwoEmVieZQ==
X-Gm-Gg: Acq92OGmanHudkn8lgfIvMGX7ehK/J6ZyGUfFJDdzzxdCfd9TTuxXGnMofFX+VL6e/U
	EZLrFiB1s9qxASfmKi2GLfWSGmKz4DvnsyIHSVgQMtO2v2ubpwmJ889K2ym0+p9GJVHWDQqzNAM
	VRGGXfohGoKGw4hbZBRt2Ilu+VDUmKi4gtPKznjSO75z7HS0epDvu+T+BFdG9xihxxbpaInft6w
	fc9z6oFRVQ7eZYpx2osw5ynN9R1JAsu9d5UvK5yg0BhUx56VnTbNiIKnzx44ZT7INR9BYqGzFIw
	0I13rUNi5TYkNVMwh58=
X-Received: by 2002:a05:690e:148b:b0:65d:b75e:9bc5 with SMTP id
 956f58d0204a3-65e22837bb6mr14333384d50.45.1779070735494; Sun, 17 May 2026
 19:18:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514110139.864340-1-lgs201920130244@gmail.com> <20260517142719.GH33515@unreal>
In-Reply-To: <20260517142719.GH33515@unreal>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Mon, 18 May 2026 10:18:43 +0800
X-Gm-Features: AVHnY4IReBLVd08LhwkXjsmT5T1hfWrVkgoE5UIaZS8vWnBngdc3JNS4AgSlqAQ
Message-ID: <CANUHTR_nYrt-NN5Kf81hDG4A2V0ydjnWSnv9=-2ZfP_0muD0vg@mail.gmail.com>
Subject: Re: [PATCH v6] IB/mlx4: Fix refcount leak in add_port() error path
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jack Morgenstein <jackm@dev.mellanox.co.il>, Roland Dreier <roland@purestorage.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Leon,

Thanks for reviewing.

On Sun, 17 May 2026 at 22:27, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, May 14, 2026 at 07:01:39PM +0800, Guangshuo Li wrote:
> > After kobject_init_and_add(), the lifetime of the embedded struct
> > kobject is expected to be managed through the kobject core reference
> > counting.
> >
> > In add_port(), several failure paths after kobject_init_and_add() free
> > struct mlx4_port directly instead of releasing the embedded kobject with
> > kobject_put(). This leaves the kobject reference count unbalanced and can
> > lead to incorrect lifetime handling.
> >
> > Allocate the pkey and gid attribute arrays before kobject_init_and_add(),
> > so failures before kobject initialization can be handled by directly
> > freeing the allocated memory. Once kobject_init_and_add() has been
> > called, route failures through kobject_put(), and call kobject_del()
> > before kobject_put() on later failure paths after the kobject has been
> > successfully added.
> >
> > Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> > v6:
> >   - drop the Cc stable tag
> >   - allocate pkey and gid attribute arrays before kobject_init_and_add()
> >   - keep the release callback unchanged by ensuring the attribute arrays
> >     are initialized before kobject_init_and_add()
> >
> > v5:
> >   - split the add_port() error paths after kobject_init_and_add()
> >   - call kobject_del() before kobject_put() for failures after
> >     kobject_init_and_add() succeeds
> >
> > v4:
> >   - route all add_port() failures after kobject_init_and_add() through
> >     a single kobject_put() based error path
> >   - remove duplicated attribute array frees from add_port()
> >   - keep mlx4_port_release() tolerant of partially initialized objects
> >
> > v3:
> >   - make mlx4_port_release() tolerate NULL attribute arrays
> >   - drop the parent kobject reference on the kobject_init_and_add()
> >     failure path before putting the embedded kobject
> >
> > v2:
> >   - note that the issue was identified by my static analysis tool
> >   - and confirmed by manual review
> >
> >  drivers/infiniband/hw/mlx4/sysfs.c | 39 ++++++++++++++++--------------
> >  1 file changed, 21 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
> > index b8fa4ecfc961..e4c822c96ee6 100644
> > --- a/drivers/infiniband/hw/mlx4/sysfs.c
> > +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> > @@ -636,12 +636,6 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
> >       p->port_num = port_num;
> >       p->slave = slave;
> >
> > -     ret = kobject_init_and_add(&p->kobj, &port_type,
> > -                                kobject_get(dev->dev_ports_parent[slave]),
> > -                                "%d", port_num);
> > -     if (ret)
> > -             goto err_alloc;
> > -
> >       p->pkey_group.name  = "pkey_idx";
> >       p->pkey_group.attrs =
> >               alloc_group_attrs(show_port_pkey,
> > @@ -649,13 +643,9 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
> >                                 dev->dev->caps.pkey_table_len[port_num]);
> >       if (!p->pkey_group.attrs) {
> >               ret = -ENOMEM;
> > -             goto err_alloc;
> > +             goto err_free_port;
> >       }
> >
> > -     ret = sysfs_create_group(&p->kobj, &p->pkey_group);
> > -     if (ret)
> > -             goto err_free_pkey;
> > -
> >       p->gid_group.name  = "gid_idx";
> >       p->gid_group.attrs = alloc_group_attrs(show_port_gid_idx, NULL, 1);
> >       if (!p->gid_group.attrs) {
> > @@ -663,28 +653,41 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
> >               goto err_free_pkey;
> >       }
> >
> > +     ret = kobject_init_and_add(&p->kobj, &port_type,
> > +                                kobject_get(dev->dev_ports_parent[slave]),
> > +                                "%d", port_num);
> > +     if (ret)
> > +             goto err_put;
> > +
> > +     ret = sysfs_create_group(&p->kobj, &p->pkey_group);
> > +     if (ret)
> > +             goto err_del;
> > +
> >       ret = sysfs_create_group(&p->kobj, &p->gid_group);
> >       if (ret)
> > -             goto err_free_gid;
> > +             goto err_del;
>
> You should call to sysfs_remove_group() too.
>
> Thanks
>
I added sysfs_remove_group() for the successfully created
pkey/gid groups before kobject_del() and sent v7.

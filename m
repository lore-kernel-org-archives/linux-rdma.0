Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C60C400E15
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786572819; cv=pass; b=ElzOzNK+SlxFJNd5UV6uop2c4qz40dSFfHpeoU+/O3Vb4hieMQjGatCJnQ+c1kLLQJ5KlrizMDN8R5wiZWjEfB7Tuht8QxEJ9K+0OMo/JpeApvYu+eTENFQlbkOVayDgY0Y0PCuPgUau8NYmS0ias1JzgqkBiIwRZOltSiwTbzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786572819; c=relaxed/simple;
	bh=byyagvsc1UjkE8b+SW2ccxMNYjbe0DMj7QW0GEW3cJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHrtRzzQ/MacU0g4tAp0a2jomA1oPoLpcGtw8vjAcT1uRMBPDWRIechwtRLPttqxDuoKgnc9Z9iKdSdNLcVfLzyXGly6K92YDPVIxIQ4ahD0QY2aX4GKPvkmdf4mObAUhs3V/DLzX9ySBtDnbjXUnkMa20gZprPPkNhoOy+xeeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/9mm1CP; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/9mm1CP"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so1620491a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 15:13:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786572817; cv=none;
        d=google.com; s=arc-20260327;
        b=FG2SMiQdDsPpDIx0XuwOR7QQqlZvAOWpHoMOIzH8boKW1hDkiSyReunDv+ORI/EhSv
         cqInihshPr5m86hscR/+FqlevG+21533gPs7u4WGS4w0uxq0HwLfgkITQdNJoQo/JS8T
         SpNEuy+Hjvf7CufbPZDOPu0YUvbjoe524XSnxFu6KBX2vMVgLxQoGTWrJFBFLjQFkmyB
         sm3WdN33/gYrnbJoS5ogIKxhEN7Rb6DnFrmBx9js+04RlU0sSfARKytWWvDWjcIYnOeW
         H7KORtKRX8/ZA/dXo/wm+vidyslOewf1ww/Di2SJh5ZLAsoh8iEyzuShqWIFPYKDSPjT
         OvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        fh=ECGIXy9GPNHCPa9bOr59gJxiqUzvtY8YpGHDi3cNX0g=;
        b=N7tNcO63IhUe55QP9vATcEO1dHBvROXtqv/ChYhzxhXzKK6sTlObBDdOgOt+gWe1rh
         P/1OWYPUsS6ZOmIAaProiXf8PYH95acia7pYccEWgzzl1QUa/x6CkO6XhjaZTmeMJ81e
         i4sRaJfU8EF5cgiZuHmWcDxYt1PhAqXyNpA+S0wlBMoaAOtIk68mhfyqGvl0StsYAum3
         kfBR+HUOPBcYRNH2F6N1poTADzKy/2o+IKc5Ig4tzWqVpwea6RA0yGmjaG+nwepDxFRG
         gInI/l6X/GrwIo5w7clAGrz4CpCCp3hpzxshvcDtLaiQinQDGSHpDCvznnjuPTRjxjke
         pa0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786572817; x=1787177617; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        b=L/9mm1CPbIdg9Qw7XP9oilnJsDnMJMBwrE+hchPA7UoXCFAg8LDjYqNnw8d1czCwqe
         U/FAs7gTaieY3w0Sgpk7GZ15VWODjeOQR8UXmXUNbDIGwyfiWD6cJlUQ+KUYHwgq8QJa
         taTPO4Kew46OnyqbQyOXvVu4TlDohVnp1+ri6P55Ccu0J8fSWkidBU1MvxGrae+0v7K/
         jMMUxgUEVCJ19Diw1levlv8jEZI4vTq/oTdb0OGP7G4FbNsIw24H5xUpPWCDpAhuh3dx
         67syzg8MXi4C6E4vHJ4BeqZmy4A3eaNyhkIZCmrwParQjn2GJfAtTSz+3YolQ1bMByV9
         564Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786572817; x=1787177617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        b=PwOJb+3d/p/tXNd2nitVyJS8GfcGFH82IsYW1TEidYSqwJOABITTEygTBUZ4ZMgDU4
         elXiitbbQ/xdhrRjej5dxXN6iGJVhLGXTx844FBfF+axbLZb4hEHPne6ej5V3TRBxPEV
         GW9nGtjdWtsviXV2LazQ7nJt4crGCywX784abEqiswkhtjwAhECS6l6QFI2hIcgbmCUX
         +0KadhDA2p2OZjbK0pBLvQQpBwM7I4c8VtQ2MlHmSRbY3hdG34pgVo69DD0fN2tjUucq
         6iV3dzXuRhDnYr3SkBXutI0syWu+PHlDXdnjRqaM+VkGRirpK4cS00DBcGQw+pJz70C6
         U8SQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQMb91kZufgX0wxcUEKzuJbFdvHrQENSe9MAZ3t2Zk6K3ByB1rnUTRRkn108L+kRUV41k1lrtit52m@vger.kernel.org
X-Gm-Message-State: AOJu0YyhNU7EhQZLTRKQCt8+gsBfC1FTbdFSZ4qd0WxPZcFX7LXUIKpX
	TiG+1uogV9xQZqB9OfYcfbA3Fph7fxsDz1qa+h+S7JTJ4z9Rtzm1cM6KEJ0UKOwEmBpN6L6VQjH
	RkFNr7F4c7ywWGMLJddiDXj/kgVyNoSSlul9whuS6G2HarrKLfLzaFFCiU6U=
X-Gm-Gg: AR+sD12wJldhUByhvW2qh4s3cAIpw126+9xD/ZMLaUjyQoGJbjqA6923mlFEVQnivha
	+riYOQSMQfSNuFT3xt/Lo84ib9xR7swDTh77kgFNxLUwW26hR3x0w1IzupXJ3vTB0E6jILOZ3Kj
	esvHaQDvuj6y0Ai7/sVPpORnMA8vZJRNxjCxHinF/7xqZoX7rT55eCJ/eGvmgqUzsMNthQRk9jd
	HEoLEtcnsQpBegz8JGsgMAIILDccXu+kI6hpnbF1jhOOdptOEhE+IPIXpqfD1DdcXGJ1B25mSG0
	ggrhmzLGmASZ70f3RI3mjrMbo4yhYqZrccIMOHGhwwXv0kV3djeiCI0=
X-Received: by 2002:a17:90b:4e8e:b0:38e:5b59:c2ff with SMTP id
 98e67ed59e1d1-3931dfd0888mr1664002a91.3.1786572816160; Wed, 12 Aug 2026
 15:13:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com> <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <anzvkibgzTae9eV9@google.com>
In-Reply-To: <anzvkibgzTae9eV9@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 12 Aug 2026 15:13:09 -0700
X-Gm-Features: AUfX_mwo8Ob8itM9mFOrvjUREAOlXg8MDm_8-_pKnvDnHzhEXLZf3Bq4dnwstOw
Message-ID: <CALzav=dptFQTKyUAiDVsv4LF79pkhfHaVyaYE8FD4-5rrWHGZg@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] vfio: selftests: Allow drivers to specify
 required region size
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 3:11=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:
> > Add a region_size field to struct vfio_pci_driver_ops so drivers can
> > declare how much DMA-mapped region they need. The mlx5 driver will need
> > ~18MB for firmware pages. Existing drivers pass in the sizeof their sta=
te
> > struct. Since drivers all use only their declared state we can use the
> > value directly and remove the SZ_2M hard coding.
> >
> > Assisted-by: Claude:claude-opus-4.6
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>
> ...
>
> > diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/=
testing/selftests/vfio/lib/iova_allocator.c
> > index 4a660f636f4972..c8075575e9131d 100644
> > --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> > +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
> > @@ -13,8 +13,10 @@
> >
> >  #include <linux/iommufd.h>
> >  #include <linux/limits.h>
> > +#include <linux/log2.h>
> >  #include <linux/mman.h>
> >  #include <linux/overflow.h>
> > +#include <linux/sizes.h>
> >  #include <linux/types.h>
> >  #include <linux/vfio.h>
> >
> > @@ -50,7 +52,8 @@ void iova_allocator_cleanup(struct iova_allocator *al=
locator)
> >  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t s=
ize)
> >  {
> >       VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> > -     VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power=
-of-2\n");
> > +     /* Adjust the size to the allocator requirements */
> > +     size =3D max_t(u64, roundup_pow_of_two(size), getpagesize());
>
> ...
>
> > diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools=
/testing/selftests/vfio/lib/vfio_pci_driver.c
> > index 5e65434d2318b2..52b9c2a2bbb9b6 100644
> > --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> > +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> > @@ -32,6 +32,9 @@ void vfio_pci_driver_probe(struct vfio_pci_device *de=
vice)
> >                       continue;
> >
> >               device->driver.ops =3D ops;
> > +
> > +             VFIO_ASSERT_NE(ops->region_size, 0);
> > +             device->driver.region.size =3D ops->region_size;
>
> I'm seeing failures with the IGB driver with this series. I think it's
> coming from here. The region size needs to be page-aligned so that the
> IOMMU map/unmap calls can work?
>
> The size of struct igb is 0x20080 bytes which is not page-aligned. The
> size of struct mlx5st_device is 0x200D000, which is page-aligned, so
> that's probably why your Claude did not notice.
>
> # #  RUN           vfio_pci_driver_test.iommufd.send_msi ...
> # /usr/local/google/home/dmatlack/kernel/trees/review/tools/testing/selft=
ests/vfio/lib/include/libvfio/iommu.h:42:
> # Assertion Failure
> #
> #   Expression: __iommu_map(iommu, region) =3D=3D 0
> #   Observed: 0xffffffffffffffea =3D=3D 0
> #   [errno: 22 - Invalid argument]
> #
> # # send_msi: Test failed
> # #          FAIL  vfio_pci_driver_test.iommufd.send_msi
> # not ok 33 vfio_pci_driver_test.iommufd.send_msi
>
> Applying this on top fixes things and also avoids a potential overflow
> when doing the roundup_pow_of_two() in the allocator.
>
> diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/te=
sting/selftests/vfio/lib/iova_allocator.c
> index c8075575e913..66a160d4ff9d 100644
> --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
> @@ -52,8 +52,11 @@ void iova_allocator_cleanup(struct iova_allocator *all=
ocator)
>  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t siz=
e)
>  {
>         VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> -       /* Adjust the size to the allocator requirements */
> -       size =3D max_t(u64, roundup_pow_of_two(size), getpagesize());
> +       VFIO_ASSERT_LT(size, rounddown_pow_of_two(SIZE_MAX),

Oops, that should be VFIO_ASSERT_LE().

> +                      "Invalid size arg, too large (%lu)\n", size);
> +
> +       size =3D roundup_pow_of_two(size);
>
>         for (;;) {
>                 struct iommu_iova_range *range;
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/t=
esting/selftests/vfio/lib/vfio_pci_driver.c
> index 96a940ea59b5..b31abfe2c7ff 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> @@ -36,7 +36,8 @@ void vfio_pci_driver_probe(struct vfio_pci_device *devi=
ce)
>                 device->driver.ops =3D ops;
>
>                 VFIO_ASSERT_NE(ops->region_size, 0);
> -               device->driver.region.size =3D ops->region_size;
> +               device->driver.region.size =3D
> +                       round_up(ops->region_size, getpagesize());
>         }
>  }

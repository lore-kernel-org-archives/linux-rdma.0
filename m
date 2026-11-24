Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795556819;
	b=bcvpvhCz+oQ2ygaBDbolSmdNTP82hjeorSUWWgJT1gdESpi8w7AkTS4IaFLLX+c3lYNe
	 OxEyRngY1U0gLRKbAN8OmBYtNczDeJ+kmMDUcrxe001IoYFgJSDbxEoWRWxgLgUjAdxXy
	 FlIfOD3G6eTzTRqXKwPfZBCH2vMP2KQ1ZEk5uL3V75jUWQy/UZUB4YGVKw1r0cXiXvu+8
	 QMWZvU7XGKZbq7GUU+Y0rNoAeoqN6dSgEgCrSfT0Wa9Itj/FKK1fV+jZAStgE1xpPJzoP
	 hqA8N1/0NayZR0kqcqexwEtktwItZObzQMjJZxb5xmvmtcuAexYQPlGlSp2fqw9Lkzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556819;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FGbzPrH+xJoIPLYXvjSmWetHWVVd093lv1v7NFu6vPo=;
	b=QU3nmfHwoQNdmFDqFJ/8KCPnDdgVbuflGkTlsFGzuEcCLlL8inuNvHNveUtmpZZ5vnWa
	 uuhm0oqkYQeMrj7MF4Uvt9UYwbQjR71nOmb5M5NwGRVPY+IxIonnmMkRTSlUQhcOWG8QH
	 eEoF2eDWAKJipCD+nnFkrkQhB5caELvbNN6LM+Er6ycs9OBED8MLX4B9n0rcP2j+aqELB
	 kOGY/OQygNKM6v5cXq/QKEx7/KYvAHlULCvBi6hs4TcLCN6EE7X9czqLZjrmNOvuoIMoM
	 nxq5Qv8YTr1OC7BJIMZRNWwFd7BGDIBzYlcJi4CrtUG+uhY3dgRUD0a99GQV7icmsSw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=StA1JVy9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3969D606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 21:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3969D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=StA1JVy9
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9211efaca89so58885716d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 13:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795556818; cv=none;
        d=google.com; s=arc-20260327;
        b=oYN1otfz7tyusdhMfoqXetPij/PuFE/X0K9eSWbTKHbY1EEB6ScOxKj0Dlp8r8mX2S
         d8YWdA/GIJwScrYnt5RgOVKAwEO6Wkv1X232bHm13p+FUmRzooGYKjO6zWu1MQKtmi1o
         LvJaYn46I79FU1OqzyzZR6Y+zN9Nwjpqf2+X+B0HulyBNY26bOD8FjmZcpqp7+zRObRu
         W8iWHVrGV8oCn+Hw2ZmKoOULppl2cT/FD4E3wtcXM7wVCmM/ECyTz+wLD7l6SrF5g0Wj
         ZeWdUVRN5Jh8zwcCUMo2txq1oNF64iW2QdsaEENzTqDK2ufMk/bDnkuQJhdBqWVd9utg
         74vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FGbzPrH+xJoIPLYXvjSmWetHWVVd093lv1v7NFu6vPo=;
        fh=5jYwkV4SJvE+FpBE3VzVwM2kW3OPWxYe9xdnf60KM/w=;
        b=QFXO7i0K0xFRrwMkN+7CH6uwhaQIcmk9kS1+GJl+MdGkgovQ0lS84FUaQRjHGiTF+o
         /sm4tVxaz2A0eG9Zsr7bH/uOORJ1ugktwuptc1F27+r7MX+VA3BUfOsLL7RNutQzreyf
         QjSpz4JHzsPWZcHplMy8FdmB0H0KESXLrlrwua7bkftWvuElyWnDTSo4KTCFzaCvvFbX
         s40z6g4TCUJ053q8JQkuH42hJkdzkWUGHjjIVspvsbri3xRIpJnIn6jq5eu6A2RKaxqw
         pndKH3Wzjj/jCRPAUYUF+2cJQECT4OyB14xN2OmNKB68fzxF/IbvFrW4MDW+leJIWkiX
         WcKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795556818; x=1796161618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FGbzPrH+xJoIPLYXvjSmWetHWVVd093lv1v7NFu6vPo=;
        b=StA1JVy9XpHc5CNPoCkhTYxJPY5nYrDYJf45NysPkn7jD/J2o8l27ESQJA2rWSNZIi
         9nCgiTcXM7E+AkOFIPilMW9REQzxpTWxagLMK+1OpNvqMVcS4z2fDkB/QbysHvjqh7s9
         clf/EE+S21FmnGb/WSx7Fcyv7MP5cESQLXqiAfTK7VpsMiF8H4af2s1XcZTh5tOCuzZX
         LZKY1KzTKScQ0DMGktv7vz2Pd9VjQRkobp7DxAPjV2SYkkwK9MbHXLhJZvbf0dSaXqGm
         I4iOLnFLsWD8kb6/skzYA+qS8SbjRIaJkWRtQEYpZDSN2NMSmf3nk2HBlKvKXQWtMU6m
         xfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795556818; x=1796161618;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGbzPrH+xJoIPLYXvjSmWetHWVVd093lv1v7NFu6vPo=;
        b=bP9ADGhl2UT4viFBgmb7y1DWM6ohNjzbtkVRw6aMTCqZ98ZZpGBLgnlImPFsBO8zyf
         t8VpkGTCJqMhkvak8zfBpnSVl82RN7LaXE37qLSKcTvc4T/dXqX1JBTNBO0AlQXubpfw
         jp62xnhhhDGQBB4ds4id9xKmmI/c5OsFWepIvRhJsWwdontbKmmEVxV68bWlmNjTygSh
         0R20hhPrjXdcsZ4gIiacwtCHVyhGg7eNKOe1z/JtBOlUSPmov08NZlbRrhUG5AWhydQu
         t6Kb6Nj2i8HiSQR901YSHOQr7ypAartVCSwUKQlwaA6cilj6dSv4TIfs8jG5j2niIvRP
         6H+Q==
X-Forwarded-Encrypted: i=1; AL+hErHXGISp9X8gsdIDyvUXbDRUyfuMpHVkPSwF6Q/uiLmXSfGESEGbdcPhms+sj5TWAWYDHGjjda2KpLLL@vger.kernel.org
X-Gm-Message-State: APuU4Z8c90XSBMXlcOR3zgPyljtxeFb2LHto+2ftHex3e6qZcRxiDD/N
	6ONeXUTiZ5Zpc9YevPS57z1csKg0HPdKJgEjIhUh7+n+ufl2HD3BXKvtfICyhudJc3IC55m4bBe
	xEgGFaHqC1bOE7vnf44e2lnQBrt2tVeg=
X-Gm-Gg: AZFdTZdurBg9Abkklm2W1y5JTfhEyGOUXYCQu7DLjbTQL6FPIWafxZdlp5Ncnb+lDEq
	UH64z6cMf7NQdihSvPco1v4MjJ4t+ToxlHFzUTud1FX4mzAdpFj4+l8IXbaP8W3iOjXGp+QL0vB
	2MH8uun3V6rCi6tCSCkYTBMmc8hnezsjitF8MSNZUVCBZ+h9RN06iaGfA2sBS7G8kr1MN3CN9Dg
	gNCc/97ZSCMeLGHSiH8qdlPBfywbkruMpfSuk85kI5YZgHJ9RbM82q/E2KUuqwOhyuVscUTerGY
	zxtlz2d6ds24uGssgfZ0MSohTIeqDAuQTf3imDkdHdTn2ezgFPV5RZqtowIKuGQ+kOQdujvbNFT
	ZPgbhS81AQKhU4Rm9Yswj69OEOYAQX0GqRJU0cC4e2NRz4xLgVxYrrvD9buimBK7onCWW0o6fY0
	NKRjdeGPQk7KimSTYydIhbbsEGaUMyebdVN0B8mSD6NOh2fPqwVu+s1G22AR4bynqqBuEOuDrog
	Oy5YI+CkpLkFvSwP6I11oUrjW0Po+xXYdS8GQ==
X-Received: by 2002:a05:6214:528a:b0:921:2e36:b77e with SMTP id
 6a1803df08f44-92134b2bba0mr261321926d6.47.1795556818060; Tue, 24 Nov 2026
 13:46:58 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123140620.64393-1-astellman@stellman-greene.com> <cc93cdad-7458-488f-9a29-de24f364f1b1@linux.dev>
In-Reply-To: <cc93cdad-7458-488f-9a29-de24f364f1b1@linux.dev>
From: Andrew Stellman <astellman@stellman-greene.com>
Date: Tue, 24 Nov 2026 16:46:47 -0500
X-Gm-Features: Aa3M54qCXpHCmMW9B22M8mnwEs6RTptaR_9prAYtJl4015X3i-vlsHZUGKP_CA8
Message-ID: <CAChPuV8TBy8d7sbCLzNzFQKoich5O+yD=g6zzOg0bGaS786Tpg@mail.gmail.com>
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero struct rxe_mmap_info on allocation
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review. I'll go through rxe for other unzeroed
allocations and send anything I find as separate patches.

On Tue, Nov 24, 2026 at 4:41=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
>
> =E5=9C=A8 2026/11/23 6:06, Andrew Stellman =E5=86=99=E9=81=93:
> > rxe_create_mmap_info() allocates the structure with kmalloc_obj() and
> > does not set info.pad. do_mmap_info() copies ip->info to userspace with
> > copy_to_user(), so the 4 pad bytes of struct mminfo come from
> > uninitialized kernel heap memory.
> >
> > On x86_64 v7.4-rc3 under QEMU with init_on_alloc=3D0, an unprivileged
> > user (CapEff 0) issued 300 CQ_CREATE ioctls on rxe0 and read the driver
> > response. After the guest had run ls -lR on /proc and /sys and read
> > /proc/*/status and /proc/*/stat, 101 of the 300 pads were nonzero. In a
> > separate boot with slub_debug=3DP, all 300 pads were 0x6b6b6b6b. With
> > this patch, all 300 pads were zero in both configurations.
> >
> > Allocate the structure with kzalloc_obj() so the pad is zero.
> >
> > The issue was found by Claude Opus 5.5 running Quality Playbook, an LLM=
-driven code review tool:
> > https://github.com/andrewstellman/quality-playbook
> > The fix and this changelog were drafted with Claude Sonnet 5.5 and revi=
ewed by me.
> >
> > Fixes: 8700e3e7c485 ("Soft RoCE driver")
> > Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> > ---
> > A reproducer is available on request.
> >
> >   drivers/infiniband/sw/rxe/rxe_mmap.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/=
sw/rxe/rxe_mmap.c
> > index a4ead89cc..ac851f245 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_mmap.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
> > @@ -102,7 +102,7 @@ struct rxe_mmap_info *rxe_create_mmap_info(struct r=
xe_dev *rxe, u32 size,
> >       if (!udata)
> >               return ERR_PTR(-EINVAL);
> >
> > -     ip =3D kmalloc_obj(*ip);
> > +     ip =3D kzalloc_obj(*ip);
>
> Nice catch, thanks a lot. Could you also check for other unzeroed memory
> allocations like this and fix them?
>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
>
> Zhu Yanjun
>
> >       if (!ip)
> >               return ERR_PTR(-ENOMEM);
> >
>

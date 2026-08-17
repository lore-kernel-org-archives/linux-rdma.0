Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF332C3261
	for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 04:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786942652; cv=pass; b=u2mU/JMbp4CQFv2gO2EoaPeHkKBBhX+5nyAsoDiEqWWVynYSAeXllQG8i6WnbKoj2KPdEMl55iDtwPpbaBLgp23jvRgN8E3a7tb4IWw/HJtfHE+7xdIrL2sAKPz22UULwFK1DyLV+0WDXhbDmyBw+L/zg7rQHHJ4RWfxcQCc6io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786942652; c=relaxed/simple;
	bh=Xe8iOXEzvGF8X/Z5Oe18dBSQMAZyQLXlioa1e6bzjMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J7RFkBxpwP3o8ut/MHYjutNtA7zRxXj7HP9AnU7X4hFliFuBaPZue3KCVYQQUMaTr6/gtPGYXaLCN3Y8Kp30j3Fe9WoRt7NfzX8UB+OefVCfbotFoiTyrWQ7c13JYM8KztFT5EI5SSQWmFktLDlzBXybe4dh9bVvCe+yQD9ZMuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=TCNfTCad; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="TCNfTCad"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a18af264f9so624395a12.0
        for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 21:57:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786942648; cv=none;
        d=google.com; s=arc-20260327;
        b=iz8AXJQwm/9kxEgxAdOxsu3uCzje7+Rt31GHpvJC0WvIJThQeeljRYFuTfJvD3WdcI
         Rs9/7Kx8Kr2ylEDmgND/KRruhn1bjFFEYWg5xQl8XjKXWlBxJuDAcJmd3hhidPVm4sFU
         UlXHvTqyArtrD/RDpvouCh6nW7H+mHYQ9V8se2LYG6VEhaVvq3fK8buEA0zRu0KEaeLb
         JfStQjZUdxr4WAT+Y+6L8DnBta7kszGqhuuEgCXxCgPKwf/mzmOOFpnN+jHpvHj1kh7v
         j0ZKZhUZSs3H+Lx/BxoZ0kTrE7F6PakfhHOceiRR+zLreoU22nHXKNc5ECjXAwW1fVgb
         msDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gPFRlHsP6ZSYOc/0Yyk82UYEXupiVd/7lqX8P0d0I5E=;
        fh=+jpd4cEVdEV1YIQVsV1nuIKnVRqWmwSKKsjV19msu44=;
        b=m3cBMpBoe9o8uLWK5BQPXO8eJgttHDWoARySSURDP0820YXH9v74TNsHGlGGVS0dc8
         KqXZQ/wJUtxDCLy44QMLRMOUcxe74AHqJq4ogRvhPUAcnPKzRLM3iUt6h44sNgrwY6MP
         NNkRvNRjxjd3pXVekYMjh6HN6SJtOesa1SXRVXQXfhAtp7RHiwPQF3eVCfbZM0AQO17+
         DdBvRBfxxfoy3qyMIVcXCvNf/JLaUOtPb3FLvsCvb18HVjoeof5kMH17wYPw8iIC/YhU
         fBYSxUBTbBJD5zmTM7G4As3f06BfP1vvb0+fsYTnEGf9w2VTFdPl+7wtKrM6G9NZH3rZ
         sR4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1786942648; x=1787547448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gPFRlHsP6ZSYOc/0Yyk82UYEXupiVd/7lqX8P0d0I5E=;
        b=TCNfTCad/XueXx5/+kgfBBZH9HP3GLTNIv58kgSUMSUKJcg9dRsWLsV2eJFGxrvuvM
         p2KQZxyIthqu9DKjADsQLRWJKeGYGx6AwwDSRqCe7yvCmVQp7SoKpW4shgextB6wDY0c
         flxZopmdUivUPApDZ3Zwa1MDjYGTn35oGtzck+UH5LhC9/Qe3SKNmwISSgtG1JEnlCzh
         onvO3ZAUYR8rBZ+hWfijQ9XVDDrC3uCnCvLYlcNhOP/tzzruMOwzy7MQlWJxhCky74Fg
         TJSMW408zgcd2psPSCLDEkqE8xBwLZzC6ip0hchYQ3G/Q09eOFX6EqyzVVa3VjfuCtff
         5Ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786942648; x=1787547448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gPFRlHsP6ZSYOc/0Yyk82UYEXupiVd/7lqX8P0d0I5E=;
        b=lhf2YbXdFiIezG6zgg9D8axp+0x3Py6GcMYdNNHFeU5qRpk1cXoVXQJ1QpbbF6LKUB
         aZ81P6xmVfkCRMPuYo7QL662j/Y0Y6MCacMDOt3nQguF++LTh8y5BXh0T/FEp0GLDSyz
         6Y0SvBdM4VDwIrC3Li1w5TqYhCYJ7qUATYFtrPedDKNDEfk5/YiQ5mIIw4TX7zZnLZ9P
         6mJb8zjSqJKiby91ww5JhAtUTpV/64UKyWZhHmd0mf5HFZOiWLEnxTYHkGC+DpQYCsXy
         4l+7zhPXBmITBTfiVKZvoINVAKW2KoxvwNGWi0flil9fdFc6C4qPdMUVceRVa7bB+5Sl
         4R/A==
X-Forwarded-Encrypted: i=1; AHgh+RqOUBU9cCdnL6rxMth0vK926Ja2he4pS7xvDz4rVkkByPKWtXb5OKoVSM+NyTj1SpSprSobeOD5IWQj@vger.kernel.org
X-Gm-Message-State: AOJu0YyG6a4hEdZl63zdEO/pZJaa/JVH5DrchuKAWWoFipSFy32Eri6+
	6X4C+YUbskJW5w2KypW/fKTI0B3ckfvSqN26vVI1p8aNTr3gb6VlWSNmVvchyVzK2LEJAMEne75
	x1/CsW0iX9ZMfdMYtW+ps3kTnqGPtPz49HUxchJQxOQ==
X-Gm-Gg: AR+sD10UB7C3YlTfN/47xO8XWHfTUx4GvRaqlhICuNqdLARCKtiaXFf9ar9ZjOkxr78
	fkoMd9ryhO36/RnXc4jFmJDezdwBzZt3lTp1e+7Rd4c2mh3UHDtRJxEAed/bw/iQQ0CvdIGs3MV
	INHYvcGMcVwjAcESUz6YgDzZVmpn8gfvTW8vp6R8djyc4b2VvhKIVJ39Ko19defa9wdkyRVyLtD
	70/yXGRFINkyFTikbMCrpQAA/8jilzvocAmTULjOO3KH29n22SW7tQ9e4Tu8OWFJeZgEx+bJm82
	1Y0QEd2T8f8WCyfRFkjEQAcsc6zCWz5+IZAzo04Gcjz1m8etlyXLE/z8vsYJfmRvL+pIvDSVVgA
	saF9SrCDzXzs9
X-Received: by 2002:a17:907:849:b0:c16:1290:11a7 with SMTP id
 a640c23a62f3a-c2129b328f3mr617622266b.1.1786942647948; Sun, 16 Aug 2026
 21:57:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260816165935.90523-1-dragonliu2018@gmail.com>
In-Reply-To: <20260816165935.90523-1-dragonliu2018@gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 17 Aug 2026 06:57:16 +0200
X-Gm-Features: AcwNN1VVmJNOC0M4GGbei7tGa4912Vs8syCoQgMLbSv6NqhxtOxT2kRxH3Jf8Os
Message-ID: <CAMGffE=v_Euy+ZPEuYByft66MKMY2ar5dfxr1TU4Yu7B++ZaiA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation
To: Liu Zhenlong <dragonliu2018@gmail.com>
Cc: haris.iqbal@ionos.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 16, 2026 at 7:00=E2=80=AFPM Liu Zhenlong <dragonliu2018@gmail.c=
om> wrote:
>
> __rtrs_get_permit() allocates a free permit from a bitmap under lockless
> contention: it scans with find_first_zero_bit() and claims the bit with
> test_and_set_bit_lock(), restarting the whole scan when it loses the
> race.  Each retry rewinds to bit 0 and re-walks every already-set low
> bit before reaching the free region again.
>
> Under high queue depth - the RTRS/RNBD data path - the low part of
> permits_map is densely set, so a lost race wastes a scan proportional
> to the number of in-use permits on every retry.
>
> Use find_next_zero_bit(), resuming from the last position, so a lost
> race continues scanning from where it left off instead of from the
> beginning.  When the scan reaches the end, wrap to the beginning to
> exhaust the map, so a permit freed below the cursor is still found
> and NULL is returned only when the map is actually full, matching the
> original behavior.  The scan remains non-atomic, so the
> test_and_set_bit_lock() retry is still required and the race
> handling is unchanged.
>
> A userspace model of the bitmap-allocation algorithm (not the kernel
> find_*_bit primitives) quantifies the mechanism: with qdepth=3D512 and 14
> threads holding ~98% of the bits set, a lost race in the baseline
> re-scans the densely-set low region, traversing ~1.3k bit-positions per
> allocation, while the patched version resumes and traverses ~260.  The
> benefit is contention- and density-dependent: under low contention
> (sparse map) the two are equivalent, and the wrap adds a small amount
> of code over the single-scan baseline.
>
> End-to-end RNBD/fio throughput was not measured (no RDMA hardware
> available); the model isolates the allocation mechanism, not the full
> IO path.
>
> Compile-tested: arm64 defconfig + INFINIBAND_RTRS_CLIENT=3Dm, rtrs-clt.o
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Liu Zhenlong <dragonliu2018@gmail.com>
Hi Zhenlong,

Thx for your patch, it looks good, nice optimization.

We may simplify the commit message a bit:
"Callers from different CPUs may grab the same bit, since the bitmap
scan is not atomic. But then the test_and_set_bit_lock() will fail for
all the callers but one, so that they loop again. This way an explicit
spinlock is not required. find_next_zero_bit() resumes from the last
position so that a lost race does not rescan the already-set low bits;
if it reaches the end, wrap to the beginning to exhaust the map and
still find a permit freed below the cursor."

Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>

> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index d34d7e5f34d6..a1df90243c41 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -70,19 +70,24 @@ __rtrs_get_permit(struct rtrs_clt_sess *clt, enum rtr=
s_clt_con_type con_type)
>  {
>         size_t max_depth =3D clt->queue_depth;
>         struct rtrs_permit *permit;
> -       int bit;
> +       unsigned long bit =3D 0;
>
>         /*
> -        * Adapted from null_blk get_tag(). Callers from different cpus m=
ay
> -        * grab the same bit, since find_first_zero_bit is not atomic.
> -        * But then the test_and_set_bit_lock will fail for all the
> -        * callers but one, so that they will loop again.
> -        * This way an explicit spinlock is not required.
> +        * Callers from different CPUs may grab the same bit, since the b=
itmap
> +        * scan is not atomic. But then the test_and_set_bit_lock() will =
fail
> +        * for all the callers but one, so that they loop again. This way=
 an
> +        * explicit spinlock is not required. find_next_zero_bit() resume=
s
> +        * from the last position so that a lost race does not rescan the
> +        * already-set low bits; if it reaches the end, wrap to the begin=
ning
> +        * to exhaust the map and still find a permit freed below the cur=
sor.
>          */
>         do {
> -               bit =3D find_first_zero_bit(clt->permits_map, max_depth);
> -               if (bit >=3D max_depth)
> -                       return NULL;
> +               bit =3D find_next_zero_bit(clt->permits_map, max_depth, b=
it);
> +               if (bit >=3D max_depth) {
> +                       bit =3D find_first_zero_bit(clt->permits_map, max=
_depth);
> +                       if (bit >=3D max_depth)
> +                               return NULL;
> +               }
>         } while (test_and_set_bit_lock(bit, clt->permits_map));
>
>         permit =3D get_permit(clt, bit);
> --
> 2.55.0
>

Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2304AFE22
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445563; cv=pass; b=C1yd1BZ3PUrhrwSl2+vkUK+ndTTde20bCeDbYNq8+/Sy6KfFpuJnAABeh9J8VPGk3Yxp5onLRzTigmsJMp/XzuqVKWH6QOFb2aMl0TS34EB9sGOiY2qfVwu+hsinY+Oqp/uSE+HvA1bpyOx9Bv0xeXO3CYB/0qE2aMRe5jtzkDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445563; c=relaxed/simple;
	bh=AkoSVahsG/XB7G6s+Z9HJxaQQ7ISAP+LdDS1W8kcDDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pBLIxI+Pa1xir+59t7uSJhZGYq2iIpyicemny3rYnS6nMiHYMHGXLd3+6ePnJhRoaI6iCYyOS8ebbtqJUDLU5c3OOuXxQS4DS2V6uYnRrrBW/Yq+Rw2xFT8Q9O9vgUTLdgp0nE2RFxFbiVn2r1P6z3g9f+6lPIFWGb99hmC41ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=af+rHkS3; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="af+rHkS3"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6b3671a1b20so1649934eaf.3
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 07:25:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788445553; cv=none;
        d=google.com; s=arc-20260327;
        b=ouDTlWGwHI4jXtkQOMxi9HQwRyeE1FvhxM+IImuxs1MxBGcBiuXLYBbnLJafEbag7X
         hsmrhKy+GGfdDpC3YkO66yAtmMedgz2hSFPKYFgQNcDeL7eLUyfHmsw7M4U0tjOoRd/E
         k1szi1C1LI8ppvlKLzOYs2l0LFERPapHd9VZ7jKLb8mHYyauuCf0H7o+PZRBZ4KrUZss
         XyA7Q4pJ4Lvtpj28ngCb4yXBWsmCzRu7KlQ8G71i/0M15p0yFh0rriba3rT1lbwUrYQY
         9+W1V68xDZQHp9pZPbbgmEulsxO1KMI6E6XHRou3wAYf9c/pYJ/HnKLcB96mbAB8C/iY
         ge9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bZnZz8IAxs2JFszciywmbc6VVqlV+5qRJQ2UhF2WNa0=;
        fh=wJuo+VFFNBl8dp/yFvKbd73pAqU2OR/HBiSg+r3j4Dg=;
        b=oplMBScki6fqhl1zYPZb9y+oyzFMOOaLkqCudM1y5Scmk/5Zp7qLrJIDgVD3TgstTb
         0APp4OvcJMs++xauZ678b7XLhCQ67GCWlvX2u5i5YB9W7uFGnnDgQoROQtSzu0l+M8EZ
         hO7uo//X/CZQto8YO0XJAqHtT6Jos3sNXVCA0czt87maSngcn6VIEE6pWdWMICN1S9S5
         vvEwASGS9w/j3Vad7rnmM77CVbRcu2fcsMM2kDK9XgnOiUk05OoFXi8/7JFQMRQtTdEd
         ooZjZZBMZxVQKXRi2l3dtDETBB5BuuDYRu3ggWTLl/cGCXzhltXtz52u0bkw9Pth8Bn3
         WROg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788445553; x=1789050353; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bZnZz8IAxs2JFszciywmbc6VVqlV+5qRJQ2UhF2WNa0=;
        b=af+rHkS3L9Mw7JI4ecn8VYqnrIB3DAF6Ikuw9JLpI6ZvX8MxcnvuSWUcCiGMvSZNQP
         i0GNlQ+VHY8YHL4/QwNdj0ZKjHHB/FrHbvfV3XnSLmAzMaU98KrmpI+jVialX8byL3K0
         AyIPquHbKF7kijp50QCBD4aYJ5xYVRPCxubvF7TAlxhBY/mRnUjFN3vGfM18NchUqdnb
         lD827OzA7DqKgb3ujMp2DNAd+ByLXGDZvD65YSiGVAsdt/uvUee5iGsRdNPXD0BhezUn
         9OIWyOnqX/BHyp0rX/2QCp4f46ozeMZiqj6NWlVy49MriC9GUXkeRXByrpx8Tf8j0wza
         gpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445553; x=1789050353;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bZnZz8IAxs2JFszciywmbc6VVqlV+5qRJQ2UhF2WNa0=;
        b=ecMrthAFag4Ue03zh7GXhnvNhSqHE8hGXtlPoda7tZ3IhhuEd5ndFRWFFO1M9t/u0w
         5slu4RPLcE+mkshFrEq/ikDmVX74M7l2j2N9ZmoKZNp7YJRY94rUsBHLMXi5Sw9UCvrA
         nEs3P4fGGWvsPD6DRkrtTSRChCtAcEysnHOfLbeHP4Y7woVwmxveXO4s5037Eop83KUq
         +RKP/i1hlEgdjaLkKgLMkiZuH2iOfSm4eHMFsN/2qE79rkfauVbqB1aG65K/kxhXzUty
         32iLQb4cc/RvW9rUfvm+XuhApYsuuv6HDIiy6P4k0VCg1bOwOUT0f10mO3xGWO4HSTi2
         apLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzfU/5jkt03MlnBEpc4ni/EukVDQ5OWqgTvOVoWhkbSH7E7YoU/7IHKowUOyy3m9G29RMKz+5jbIabm@vger.kernel.org
X-Gm-Message-State: AFuF++n4SpLZp6ToA0Y7KU730SBkNqbVCKXFyfA34eE/0Ug0X3NAfL5H
	E1GvOA/UhxqY8bWVChsPcNKvd4OXYl6bcm3z32lx1U85ksX2YebaDwENgPqocRAUXvBHbL++uqv
	uKeEOkxvNzeATDprpCKq5vQTFiwHHcTZ/Kgw9d3gY
X-Gm-Gg: AYBFou27Y3MjdBsXgvbGr2DeLDQYSQIziBGpelSDR3ajqemxPw6xceMjrR0zGDjIPXg
	5+Y4uXZW8IDPDfrWov275bmpf5NzfGqNYnAaSBbE6Cts9ldrEyPikLnpw0S46ETgo2DMU9t7yYu
	x25+XN65Uwuk8O796v5nrRIuWeGk9fUVFiVCBlbkLMyDJfLUhVIg5WbVoeJnPrlcLKaah/dcjbw
	BMMuHq/2nB6Kz3MO6ce4HsuT6viVUCe9eTlWGICEpRWGTkWOmiFkXqYxeONfzvXp8tdt2EeTV8v
	M1pZqoAnUfp6Jstb0bVpsIfdxli3jrhYGYjxqmBrEMZHdrsMA9gvc3N14xi/kojdLU1OR2s3ULE
	=
X-Received: by 2002:a05:6820:212:b0:6b1:7798:a80e with SMTP id
 006d021491bc7-6b47ecca7f2mr10124357eaf.6.1788445552106; Thu, 03 Sep 2026
 07:25:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
In-Reply-To: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Thu, 3 Sep 2026 10:25:40 -0400
X-Gm-Features: AcwNN1Xgi-5VMbZ4r-5uCQqWMAuevTL0Tjsg26cc0zHaxNR-HWscYcHWAVjr2Gc
Message-ID: <CAHYDg1QGvmzcAXCkb_g52x+ZcMr3wEcH0vaEgbgNzXmxw9uFUA@mail.gmail.com>
Subject: Re: [PATCH rdma-next 0/2] RDMA/irdma: Preserve fast-registration
 IOVAs and simplify SQ posting
To: Leon Romanovsky <leon@kernel.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Jacob Moroni <jmoroni@google.com>


On Thu, Sep 3, 2026 at 7:39=E2=80=AFAM Leon Romanovsky <leon@kernel.org> wr=
ote:
>
> Fast-registration IOVAs are u64 hardware values, but irdma passes them
> through pointer-sized types. This truncates the upper bits on 32-bit
> kernels and can program the wrong WQE base address.
>
> Preserve the full IOVA throughout fast registration. Also remove post_sq
> controls from QP flush and fast registration because every current call
> path requests the corresponding send queue to be posted.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Leon Romanovsky (2):
>       RDMA/irdma: Preserve fast-registration IOVA on 32-bit
>       RDMA/irdma: Remove unused post_sq arguments
>
>  drivers/infiniband/hw/irdma/ctrl.c   | 23 +++++++----------------
>  drivers/infiniband/hw/irdma/hw.c     |  2 --
>  drivers/infiniband/hw/irdma/protos.h |  3 +--
>  drivers/infiniband/hw/irdma/type.h   |  7 ++-----
>  drivers/infiniband/hw/irdma/verbs.c  |  7 +++----
>  5 files changed, 13 insertions(+), 29 deletions(-)
> ---
> base-commit: 6ea2157ce8c7497a2862bd3579a987afe6b129ed
> change-id: 20260903-64-bit-iova-is-silently-truncated-to-f29be6986041
>
> Best regards,
> --
> Leon Romanovsky <leonro@nvidia.com>
>
>

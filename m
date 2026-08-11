Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90E3955FF
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786474521; cv=pass; b=MwqYecqU57FKfPn/8GtoKrxKp9n1GAsRe11LRM+A6lu7Ar6GrN3zONz+YdM2hjxKai29YFLo3qCMoCm2qxPQPnvxz8QMQsUdrHU/4+d3TAnm6BtMh23BMHpvFBfZ0qU1zjYLtRmyoRgD6uI4TedTuegfCBaxrykz0GtJogeOoV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786474521; c=relaxed/simple;
	bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nawyaCgHYJBQry4V/MANYZ3PGbyBIYWRVG1woJfSYMgM9vZZMoXp9uHI3dID/+NBQS4OiQgLSoLlw2ebJukXoV4407hH8KHzMC5/HgLJ7P9x+rXW+zSQGeWxenF/eC9UBdg9s5CdCtubJk/YDVbRdOtqDP+UThDyUvNVQIGlHYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MvA8cOKC; arc=pass smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MvA8cOKC"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ceab75934dso3188815ad.2
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 11:55:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786474519; cv=none;
        d=google.com; s=arc-20260327;
        b=njyeghWgh8+tz5PkLztbZ06fbuMsLApS2JCoZatNJRvWyK2PWCV7dgSO+Xi8bwNLXZ
         p57nIWdtX9aYpB3FPN1La/yT6/86OUPjHTPlBpsZczoGMnRqYyJoxkjK8zMOkIf/NHph
         0VQp0NCFToWBSWpyvimymVqdD/pCtUKD2qgbWLLC2wdMHYF1d94ePZSBl8GBzueCADYc
         Cb2cXPkME9zl96I2uqDVh0/U4bltleaQ7DY8u/CenH64Hw5K2b29T/ghWx1SXpcJm2YK
         uHDQfCO9O0XumZPmCUOXHbH/g7SK4ZhiCVTc4Q+Y2+zkejgu1WqHxY0EXijs/D9fZ/Lh
         GDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        fh=IbBPl8flYchSdXbxbvFQHTWxz7hvcox2wYfLa2x92+0=;
        b=NwU9LXsaYa38rcBspouplbdn2lTDC5vOiFnchN05ZZcwKk6gIGN++1/q7PCGzFlevR
         MchyivGnDB1yRFENjTDYo3k4n+FMNRdMCXfYZWhn79ZTh2yrGy5EI9Xyk7p0H+k+Q/Ns
         JanclLih+JPXUO058oQOxmSFNgoQWDgTUXiSt/ceObgtlPyQ+GiMHhbTuKhI9CXjMvPz
         fGYIbmwvJyvB0hgJoEoL3DAvR5eOw0raTPx3d6m/jr1wE/REG8Vd7jKgoTUfyvY7W6K1
         xHYv1sTqjJox+7fb0V4XyTFq7yb8ZLl+OmHFxBuNasljsJ8kE5azQ5qbDpdZb6haPBci
         0njg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786474519; x=1787079319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        b=MvA8cOKCCXQQlEI5MpSTG7Uni96YcPS5b/rfl+m9QzwZ1k6yGDSnhcD5xe8meOnssX
         Xs0Pr8pUP4mCgH1sBCVHw7bmve95hnxFLe3DncNcFRrJA2JIGbtAVbfry5z0a1Ab+mNI
         IgK8R9sRjwIR1fvw8R9WTX/fWpLuPoVEQZpFQNK+i24csuxgw/43lNUo7K3VmfphX6c5
         x3tVIMLV1Gxw1UdGkArwhiAMJERGpENe+zSp+zEUY2KLf7F1VBCg9VutYYWuBru7qC3+
         qrJ9hWdcklkm0d6YOqad+x6T1VLz5HHA139/xswx5aDGzlj+eybfBSs4kV9otrqwGUeJ
         cwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786474519; x=1787079319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        b=EtHovto4DwMcez62mf1S2+Xjs2gMNkVb6xOl1hyUtR07MSYh5WZojlxapGIZ32t7hN
         U+IjNov5fIax1/NcpUyJL8Rq73irUxJnmLq+A/Mt07Cjyq7s45saVO71edq+NVhmvn2N
         P5oUafasFO4KkNCD1HSiLOoRvTPJlGXq+X2C9IQdjpdNr2ZrUobOgbnyl5QLl3W2MP6i
         NLSCdGUDL/oV/gKlo2bT4CmnBARrc7768yJGqf8+5YO7e6CR8IZDF9fwNN83EqDzE9bA
         ETRBl6/JIXCFDA4m1jETYHjryZ+j8Mq2V7WoOmF+SvbSeRaUiHVO/YkEnAr2xtGXU4DH
         8Xsw==
X-Forwarded-Encrypted: i=1; AHgh+RriR2pH+EJxY+NQnSZmDz7yBIjS+Ggxjtyb0ZTahQ4/rK9XQeDwHQVNU8qS9c3Q8U0Epz3aOfQf5fZk@vger.kernel.org
X-Gm-Message-State: AOJu0YznmvaKPghcy2jMZen0wAnvNanWD9DpGtwnAIAE0QmByTo+DPQ0
	RDIiEqEjTLPfw+rudcBELpvOcZ0hQ82cMgHm9rFLTzsB7hz/0aJuPGmvTTC2l9g1XRGo6JThiRL
	1MtgE+/lbxxwUt6FYHQYDKuZQfa5hxGCCtj93KFCy
X-Gm-Gg: AR+sD10UFbaWORyfhuqmRNxe33veR3MmbtTL58yrUCbkC180MQbjscnoIjzeenZxJHL
	6GTNq9MARuJRPxmrTzXG9m6F4UO82QbrqyaSR04jhcZNnqPmcbkoqzPAqTQydyz8RXBHOHunqRS
	9MClJ2d5io7uHgf4NQAMSJaO/vjhWp8isxTpmgB8RHSCJ3yjkIMoUL+9PyXwttEx0U180Y+r3cf
	uxvi9OtzJXiUxo9dOu5WQUQC68BkfZjYo7SjWFnsScahUOFaz6OPz5UVX5qqxTlB8NqbKQF3kDQ
	yD0oO4p4l1iGpiPTtdJF/hKozFq7jVYZw7eJombZqHzm
X-Received: by 2002:a17:90a:ec90:b0:38e:2860:253f with SMTP id
 98e67ed59e1d1-392ec53e6c1mr6200831a91.12.1786474518666; Tue, 11 Aug 2026
 11:55:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com> <20260805183702.GA72896@nvidia.com>
In-Reply-To: <20260805183702.GA72896@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 11 Aug 2026 11:54:50 -0700
X-Gm-Features: AUfX_mzn4PfVgkS4FrNbhoBz42phR-uhV7z36r-0P3XLSgGGUO-8rzrUFVLpZk0
Message-ID: <CALzav=f5oUW+B9RvOyaRGtG=6CX_4g-2Di+obFZ4O6B-chZtAQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] mlx5 support for VFIO self test
To: jgg@ziepe.ca
Cc: Alex Williamson <alex@shazbot.org>, Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev, 
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 11:39=E2=80=AFAM <jgg@ziepe.ca> wrote:
>
> On Thu, Jul 16, 2026 at 02:03:16PM -0300, Jason Gunthorpe wrote:
> > Add an mlx5 driver to VFIO self test. This is largely a remix of the
> > existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> > to issue RDMA WRITE operations which effectively perform memory
> > copies using DMA. Since mlx5 has a stable programming ABI this
> > should work on devices from CX5 to current HW. The device FW must
> > support the QP loopback configuration.
>
> David I was going to respin this to fix the minor nits, do you have
> any more feedback or are we good to merge it ?

Sorry for the delay. This has been on my to-do list, but it keeps
getting preempted.

I will do a pass through it today and make sure there's nothing else
needed in the respin.

Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9A328610
	for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782394170; cv=pass; b=CCPADJ/MjaIsFJiBD37ttxIhCiMQgVKs1Q6wVc3y8uu5qwMniFSePXtB13ztY5aTzfr1X5G2cKiO5YrHgZPmd77UbC6S77i3YeHSvkYvNHVadF1/cQLm687xgrLUlY0OrDmsPwSI1l+DFfqRjKL/DI66tzaKPIjZLG8xZMVH4rQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782394170; c=relaxed/simple;
	bh=xNyFddjqdOPUcLqjKI6cf/kZxvmO5gXEEvzzreF5G9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmapbuJfVlRRkVMVY/eQnLgCHHcMea7iMC3qH3ca7M9gdO+ky6ZEluX/uRCs/5BGRa0POVUVYTMpG3x3FTt7Xgv1nk/XZJdO2wNjk1QBKpunHHbcG5oA7on8VQW6lB7CZ0YhE8re347FqPtQLmAEvpjgWYJUBWbD8Gbz2Q7eOIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DJHN6FTZ; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DJHN6FTZ"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6fa36a1b6so1517142a34.1
        for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 06:29:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782394168; cv=none;
        d=google.com; s=arc-20260327;
        b=geY+GjpdOvZVGhinE8pq0hJ/x7RDnyXYeZYtAa9iwO99kNkEB/T2qFEuLjAQ81JEWb
         tp1wdzay1paScJVdhCNMt7cJLGJKYilxJaECSHYBlAoG1Pizt+z/w5TIEETezk1YlYzn
         TLarY5JeZ+NSOCZibn1NbEgDRBBhoc4oZzMl4NV/zEBZJ0eysFDLb/h+E8DL0TR/2Z12
         7pFuDan2qzc8QLfoyBisHn0e8QYnN6WVz2RBINUuRPLjlANwDMUbCQYi80YMu+6gQtqm
         pZmF9CGG841mCedz00TDnMHGdD4r73rSPeiVC/5wqt5zC+GjMYKvSyIVF+TzpOBOJ6dB
         kcyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xNyFddjqdOPUcLqjKI6cf/kZxvmO5gXEEvzzreF5G9Y=;
        fh=SDlC2WazE21zNVKMHVElU8CZUsuHx4bQgMhuHB0fnXc=;
        b=d4tXd5mvlLD/HMgpDuD2bO3ru4Wgoj3aJUcjSS0Pnv1YKxSjVPJRsNsXMbmhKT8CYJ
         8Ie6HMF8nZC2pIydKaxhjtmxNCUIVYspDKJLbhvOMQSUJ9xI8W2pJoXUmlB/xcCfJd9m
         chLLp1unFZ6heb2jefUMDkTXR5wdX52rz47zxtnhOnnlDIIiJI8DjAHsIz8/Z7HYhMi0
         muQvxQwnOXzFfwchGiISS7+heztSrsECMamzyEs8+OinSAo+OVgM3OCh/YcLuB2X5LZl
         ZwqDoMVv1aOpg07WKf5d5HSuWbcupagVqn5P/dDSd72XT8kFFaNnHdzUJALXcmv2lbnU
         UQAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782394168; x=1782998968; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xNyFddjqdOPUcLqjKI6cf/kZxvmO5gXEEvzzreF5G9Y=;
        b=DJHN6FTZMnfB5hXMxsjJIbmJrY433ndSW8iN9ITX+YybB5w3i4Uzk76q15AS+JpPED
         kNCa7kamJS2bX8mozSoVPaZWRavuvGtcbTJvmYQPlOXphkwx4wcY72JiRnlmHHkkaZ0C
         5oLhZGOZC0FO4AJXvCZ2Jy36aToz32LuZ/UY3RGBAEcgWBsL0Vkn9+m/RaL+JU7NXlZf
         pbDWysoAAMRNhsDhVtG61RDX6p69MPVZvHPlLomFFPCySQJHekbNMw4Isb+n7oAfqdBv
         LEJNhckmagqirYSELH5Rl3NPUxgTxyPwiv+9ZzTyvytfru7L4fGx8xXilXur1tdfEuBr
         Ldnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394168; x=1782998968;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNyFddjqdOPUcLqjKI6cf/kZxvmO5gXEEvzzreF5G9Y=;
        b=idgwSjm+ow2zqONAHvscYSlXVxZM8scPOwnZa3bzE/VcyhuxvI+qFIn7SAV8uissZc
         Qh52c+VLCMIK/cPzWeHe1aG93or88/GY1SGVZsUx2zqjhn+MATC+/tcUmxg2WXGg66zN
         daTeHitYFj+wPGiTy11WVQDNaL4ji/3StRwzu0RVKqDLDqfwNVPfYCcRF9vC0dlk2d9k
         DrEQXJ87E+MeWwEdmfOo5IAHY1v9xOeGZEZa7Bag3LXHHMVcXe0vgmMgPpk3DKzUPVfb
         cnRlOgBm9NNd7EUrmxkq2G42lF3qPgpqrV9ifCIFVZCWrgHIy9YPvYlt033bZlqbsER2
         Fi7g==
X-Forwarded-Encrypted: i=1; AFNElJ/pNf7zwY3CNZvnQ7GU9V6++b5Tl6NVvtPa6NmE6RKQ9FLiyUZNdPSyO7C+BzvgYuOTFvfidoyCjNpJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwggANPsXYj62V/tL5Q1u0RDAKVRwtFGPZNLTnH6MxwCugwEtzG
	hXzSqdTR6OKh4kR7uRCQ1Rvv4EGtBcdhbspnbhOjuI+0RYmVskrLFlgp7T7pbwp3WWwFlNNq+Vn
	QPIGEIYhv65szYCP/PoB5R3jVJs0qj38aTSz04d14
X-Gm-Gg: AfdE7cljAmcDf6DegrofopxmB/VpfBUsrX2gvZrNBEcM4MNb6mk9NQQ2+JJxs4iZsSY
	7uHzpTWsTOAHPmVjj5IHdLLRadnnuFFQxlDgyiqfLgtKKPChlEpwKjQG/NFCAFFKQAR8uVXui/3
	vyi1kRt17a1eJaxogohynYDDDAFzieRRT4CvHx0pSzDOX01PB3KAHR0UvzBHYsQgFj8UN539OYJ
	lfuQCt6Zcd73p4gwKxzRxkN61h8IaTdxMEl6+VKAhLBAhu4hAdsZ4QdKZcJv0Tw3VBjaZnMQfcW
	0gG/UFV3RjuNm7plhBgyHDnLs2nzmxRrBrEMtiIZ8g==
X-Received: by 2002:a05:6830:378e:b0:7d7:e142:2ead with SMTP id
 46e09a7af769-7e99c3fc680mr2338205a34.20.1782394167344; Thu, 25 Jun 2026
 06:29:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623114444.1429042-1-kotaranov@linux.microsoft.com>
 <CAHYDg1RQ8vEMrKPoS3qHgtf5S+T1Wzrm=YuwdfzFEX3g22Ruhg@mail.gmail.com> <DU8PR83MB0975639D552898AC93801EEBB4EC2@DU8PR83MB0975.EURPRD83.prod.outlook.com>
In-Reply-To: <DU8PR83MB0975639D552898AC93801EEBB4EC2@DU8PR83MB0975.EURPRD83.prod.outlook.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Thu, 25 Jun 2026 09:29:15 -0400
X-Gm-Features: AVVi8CfW--73HPVfv5gY3M4mrv2TaEMvHnRLa5K_dCso2zVWSyJNactDTwFlzuM
Message-ID: <CAHYDg1SiAfCFBUy6JsdC=ROuLcxy4_ro40MNeieJ3sJp4R_cuA@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/1] RDMA/mana_ib: Adopt robust udata
To: Konstantin Taranov <kotaranov@microsoft.com>
Cc: Konstantin Taranov <kotaranov@linux.microsoft.com>, 
	"shirazsaleem@microsoft.com" <shirazsaleem@microsoft.com>, Long Li <longli@microsoft.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Thanks for explaining. I think it makes sense.

> Otherwise, the change would be more complex: new response for alloc_ucontex

Do you still need new response fields/bits for alloc_ucontext so that
the client knows whether it can actually use the new capability - like
a driver "ack"?

The fixed WQE capability may be special in that it sounds more like
a one-way hint, but I am wondering about features that require explicit
kernel support (just hypothetical) before the client can actually use it,
like maybe features that require activation in HW, etc.

> With the wave of robust udata,
> providers will be locked to one udata request format for alloc_ucontext() without a chance of extending.
> That is why, I try to introduce the idea now.

Good point - I was wondering if alloc_ucontext would be an exception to
the robust udata policy since it's the first part of the handshake. As in,
clients would be allowed to provide non-zero udata input that the driver
may not understand and it would be up to the driver to acknowledge
features or not by sending a response. Seems kind of similar to how I
think your solution would work.

Otherwise, it's kind of locked in as you said. Enforcing a real comp_mask
in alloc_ucontext would mean that clients wouldn't be compatible with older
kernels since context allocation is too early for them to know which bits
are allowed or not. I could be misunderstanding though.

Thanks,
Jake

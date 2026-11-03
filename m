Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793732616;
	b=dbf6Pu5axt6jJXpwPWLlzxDdeN0XTQdPOSnu5zikE7DwDHPS4f0unXSdfGOJSj42GS0+
	 S9GPU2MPm+DKWTfbZ13EZrDXE1d62dCc6fMzASTk2Ve2xUDvaJucTrXbej1+kEj0f8A9N
	 FapbKhYKsBHiH4mZ+oq3Ixqxwad8QczS3/5EItff14y0InMfn1DXqHX6aIXHw5JoxuIiK
	 CDGnGLDubohbGd8w4q0346lHMiWITl894wqAUcM9WLJX4WXT/pYNi6enMA67U5sGHsJf+
	 tNCaRPRcNfujv8mEoSfXm5fht/8YU9RhkmpbS0pxg9Ue6n+jyNWYoyoyQOsE3dwE00A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732616;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=P9YIaSVOIFDCGM+06fwVMBsO9ra2iweeAuUBvKRsY8Q=;
	b=bZR4VcK7og8oxVb/I3EBcYVPpV59Yq7YoP/LJ1gXpH79wUPXfa4Lr/kPCr4CRk8oZ/Q3
	 bzNHyMCvjjLQZRrRFsdfLC1pFj/zjMyOjcq0ZizcZgfufTLKiAB96wY8XT8BQbSGq/JL1
	 1KU14EPueY4ZSuNtKPoZPg6rkK8ZikYoOz6SbWR7LWtkqIB8fpckiZ81+KOGREQvrvtQJ
	 Tg81bJfnpl/m27ihjOn9jvIPXAqAXT8vZpfrmI851cKb89BrqjEjBRhkMQlKWDLU2JOhk
	 g+/WRy85G3ASBm1YtfbTviQa7bjWbdLmYvrYuEt6XcYlzNh2bkSrfUrWE50fE8mm0hA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hbwph+ig;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3400606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 19:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3400606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hbwph+ig
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4a75171af39so956191fac.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 11:03:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793732615; cv=none;
        d=google.com; s=arc-20260327;
        b=KU8sFg68jY5QtLVr7orkHK+o9dtnOqwn1aiXP4DlzueRbbXq5Um0vIvKAYazIIyag6
         ObDuS9l3K497GHYO9jZlY6KiSNj7DujMEbFbqJhKrcQC2BQPt+orOqIU44+YEPnIHV3p
         2kRtCb2sHFLZyjKhcBZyfqAYYprYOSOe7hGxzoKOEeb08CeQtf73GFH3foCOHjjcCCyg
         SE8PZBctVlOgCM/emOwAzhGup/CVR8wiXAlkRpULg2IUkg9oomYTUCmKWIfFDYI6AYLp
         WP/MkGEgwIx4rmVKQ/wu3bt3H/rtxWNTKarwl6dk80s+gWgKRWvlZ9E+w2Jo5dDTJSFx
         AZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=P9YIaSVOIFDCGM+06fwVMBsO9ra2iweeAuUBvKRsY8Q=;
        fh=KSFp5WDHMkIxXfG6L9l+MxYKmqyjKNVkbXQuLXIcuTg=;
        b=O8kF1xOeoxyox5fq/P+MS3xLt4jbiKrYpNeSJIPlr3PQYE3BMZOawaJvH/4HzHGs9r
         n5ZRiJJWf7OJLQvQLEoYN6nKfJH8w2OVEF9HTPBuVRpJrDmFFRlKFEDhTRhac3cBUWzw
         FQkxD2RSTBSMiUfdklDKoMh93UIhCf8T2Ai6uLWNqX5AduT47i9c/b1uDPhhVsH1HAJi
         EjKyh2trq2VuW7IEwUSB7kqyQJnHXe8kBJrrOVFe96jIZ8ZEBUlUabdO8BZ5f+UGpw/S
         M42tH/H4cozqx7DB+uJHXy4APnbn/zplf5mts/LgbnTgTetS1AntUwTMf3QIyVlHrlNX
         1PWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793732615; x=1794337415; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P9YIaSVOIFDCGM+06fwVMBsO9ra2iweeAuUBvKRsY8Q=;
        b=hbwph+igLMFBZHD2+mjZUcq9Ls211+EZPHs0k1YIt/6KqXgtywV5IoKmfAHUDpvdNO
         uPPN5RnAV7O5nBgrFETfJAyneVzQ9NXhMKkHq9BfzzgsOYXt0Or0Fy0Je1F1nR8qinKH
         iCCGQjQmvVZxfwLfyADoATIJipEE8FPfJUA5YC9EoocmvPaSmHH1JT1CP7fk9halKjRD
         SUiOy3tM7mKgvRyp2C1OTz5KPquzADqeBuv4ncCIU2XcMbWzijyj52nngv2GHtTrSGaT
         Ct6gPvxI5Khy3c5zb3uOJCHcUaVkHI/VsaIyhTa37T4iX5+Z3oPgDWEqQIBLR5XIHERI
         fMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793732615; x=1794337415;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P9YIaSVOIFDCGM+06fwVMBsO9ra2iweeAuUBvKRsY8Q=;
        b=a5RwhiRDb9v9bHGO6pU/BLKj5HGSIhGNw/RXCO+YRz4h+wwAo+0Eh15G/Sn37mLtYu
         dB/EJgiHeom/44P1We3/zifq5EmQTj+r24DtbehLg4ABfkZUr2MR3fP7Qu6qoFPWwNU9
         UQtrYLbGvdYvv2pmOToCbpK9OJyoSocpfuw2SsoLAB3XoVllmOXA7T5ovQEKjKhKGhmQ
         A00Hpx0df3ALfXwxGxuf2KRa0lNPUMrX9iN7yspFXP5HP8R0C/B4rn0+iGMBGrAx4AXS
         kpTQB/u4smG+cadEEqm1WIs9Yu0e1TJOd7b7Kt6uQ6Tagtnq+blMGBeLAkTORgqRJsaB
         FeCg==
X-Forwarded-Encrypted: i=1; AKwUvBxQXWkF8hOCJO0ysOQYu8Iwan/Ij/SH5P36oaJ6fx8G3P16x5RirNFjj21HquxLM/p3Iw8yKiAYYtRy@vger.kernel.org
X-Gm-Message-State: APuU4Z8fy2Gwv0LU1ZxcBDA/oUwozlyOPNoJBLLg7DmqLvj7SUkm2kIm
	pwP6Q7X3DHWQFHuTaQzh2zIccS1ljs/+LopjFoBF11bxbHYwAdERPI2CN4uANSHRThx7xSr/KLe
	7kqy8yT+xaw96YkVu3/pl6M1weKiBTaI+HpImbjYW
X-Gm-Gg: AYBFou0opkSBXsgoeDxjJIKcaosBMYADV/Gt9nBMG+zMxF/VJLodkpwvkBfEX4l0tTB
	vRRpWUi8MJg4z1gn9XM+t4zZcp0QEm/AbJUbhYqPOnmPrk3FBpLaEYsQkJw3XESDb2sSKHhsCGd
	vQXij2Rr69QfORZ6X5V9s/FsXKqOLN+891d581BuZ1cRaX3g8pIZABEzahAkHNlWOAJjfvAz4fO
	fyrT73E2djfCYWAq9SYewJNbXHqjuaP9FfmYXK3GeVdY3qBotuTjmD40hemroJgBJbF8ObEI6iM
	XwrB0FW9BA/eOZh9NA8M3v1lf4w7f3hHxwK4OAcbYQn5LXGrQECtErNw5rdPX/h5QgVXhDwPD+z
	0MmHP0sSVW/YmJlfu6gbTc3O5nYYZpX7kv26vgGD9rKNxvxOZolH5qiv3rbGmF5Hw/CVco9MOGD
	rW81QPrXJDVvyZVi94iua0wcjLOXOzuephOCc=
X-Received: by 2002:a05:6870:330d:b0:48f:e0e5:a1e0 with SMTP id
 586e51a60fabf-4a9077482acmr8991565fac.53.1793732614026; Tue, 03 Nov 2026
 11:03:34 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103163949.1554-1-yishaih@nvidia.com> <20261103163949.1554-9-yishaih@nvidia.com>
In-Reply-To: <20261103163949.1554-9-yishaih@nvidia.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 3 Nov 2026 14:03:22 -0500
X-Gm-Features: AclHuK8ywmthycKAmjfKbn4VSRuUvkSGxm-2-uZNuBVCtRwDkAgCNnLK-FxSWgM
Message-ID: <CAHYDg1TnFq3EnG+6ej5SosbN02C_h5tobDtrqy5XQBk+g914Jw@mail.gmail.com>
Subject: Re: [PATCH rdma-next 08/23] RDMA/core: Suppress kverbs_provider for
 adversarial_mode devices
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com, 
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org, 
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com, 
	moshe@nvidia.com, maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Out of curiosity, is the idea that these restrictions will eventually
be lifted once the
ULPs (and I guess the drivers) are hardened? Or is it considered
infeasible? I am
most curious about RDMA CM.

Even if the drivers are hardened (no round-tripping WR IDs thru HW
from WQE->CQE,
sanitizing values from FW, etc.), I think it may be impossible to
protect against certain
bogus payload scenarios such as a NIC reporting a CQE even though it
never wrote the
data (or wrote bogus data), but this sort of risk seems like it would
apply to untrusted
Ethernet devices as well, IIUC. I can imagine it being very difficult
to harden RDMA CM
for this though.

Thanks,
Jake

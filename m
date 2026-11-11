Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794410153;
	b=iGaZIoTvKyLwD1uy+ULFX0PO4bJEUnsaqJgS9qDdvM08bgQMROYUp3jH+N53/GNGrttf
	 x1ZJGhHWcZ/pcHqIFtldoboVE9tViKBlvA6XAqJcdN6k7DH6/c1G0xa/AnAUv58p9DMZo
	 YNZHaHLGpnd+fnN2cE2SLeIvGP/ctioSwjSkZwfa6olk8YUGe8nEUbn9sWPD9ugMgG5HL
	 jZa0o3y6usGygFtXwh8yHqHWeZZRsM5A+YsMqZWtZF2j29actplHjwh5xqb1Qczq6Fa1M
	 X7nQdTupr86FubUcBOU59J4s1e1QKOVTdwSQlrnO0tuEp7dTsAMY+DJnAMbvJQ+yV2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410153;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=12qva3kO9NMXV3ZjsX8ymdd40I9ua49Cy0e6eRmwhRg=;
	b=ruxPUfx+P0OnHvGMnk6guQ9phcmoOrKh1r7QFvVwM3TwPsP8fVXQXc8ij3qurfkK8n5A
	 TQXOHIS0xiH4S824Lq0X0RK2ghIbCeWGDvdwC/uCMsRAagAzHzQwWnWlcEZo+vplk/17J
	 ky06vWuR3OJaUgImx/YKa5IzX7Qsty6YnpKssGdepTSXAKoGWfseW1W+sQUajbx3cTbm6
	 WZ1W9bnxtzf4ooYYvIG07iaPJSQB2F23z9HXIhz5dD9lVjDp+Fb33597vcg7KUq8xPOw2
	 innrjNJ3mBYcL//bFURT/zu4fTlnLlXK15ZsvL7nQgcESobueh0EnDVJgCf5CADH9hg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqTZa1Co;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.53
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72812606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 15:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72812606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqTZa1Co
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6d290b10a35so1329512eaf.2
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 07:15:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794410152; cv=none;
        d=google.com; s=arc-20260327;
        b=V+uldBLE/8X6MXEVMgs4xo8QIr4VudnyBZMiROUkt+YrEEC2Y7Kq6mKyqn22GPhMUh
         SzT4WSnc86kUOysYgY3uoMDj2mTMMZdoUyQK+9Zj1n3NoW8z4ehe/0uSuToThClYWyqk
         A2cDf7KwvZn7N0CdE1q/iw/bE+OtRpdYLp/sVlbJtuaPtvzHFJoW1vbLCnqA90tBX7H5
         +qRu5m2D9I30qS/mpBPDmQVxfL6dBt8+1dhfNPdJ1EssGuAqe4QjbVu571y0Xalh2PKw
         9aGHqG+QdftJgSnqW1lWgOwgnGvWm4NQims8skrahuJa5fFE7aXOU4Lz9mcWzkIuCIKF
         4jjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=12qva3kO9NMXV3ZjsX8ymdd40I9ua49Cy0e6eRmwhRg=;
        fh=UEgZ9WbFwi/J4psDg4loRtD98HlX2D+qlpI5IfxAD+o=;
        b=Ze53+Ghz4Dv2K+2MQinxrdCh3rXl8csOSn4oag0pYzTu4K5lNEnpuupk1Se7YZDtsN
         Mu8UnWLnTLu1gCRN3JlcmNSGQGXUYSkucXupmav9dUxKdcYJJv5LsTu6WKtMqzpxtvZs
         e4OGaPDMAnp00GR8fisy5aWlKsnBTO5oxaG8r2F5fIBfQEXxqKE+AssyLUWoHcmbF0j9
         v85vFKMJxsvYKuCeVwKHN/W3CthivR56qa4wjkERqmcATBp+sqzD9RW4DQhbEiQw6dnc
         lpRy+Dou7rK3mp/gKWDI5YYdUc7xf9+/+4iC8YgfoKmsRc62A/j0HYZ9z24ySnLqPAZE
         2h8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794410152; x=1795014952; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=12qva3kO9NMXV3ZjsX8ymdd40I9ua49Cy0e6eRmwhRg=;
        b=MqTZa1CoC8/Oi9lstEeTqcF692a0bT+fIapN4rv19/TQHhwrz1q0ulMKA2wMWg1mXI
         jm1bE17u6V/U05pmSrgpCLVMzWh1S8l/fk1Lmy0znbgHyB3Wq7Ya4GFh6F1uN1JlYp2U
         aFzFej0+eeLFPwQBJjbJITFPErKDXki5IkFPhMyRvEengDJJwyPy2WvhB72tqnL9Gn5w
         1XTOaHkElyQKa20nHI7EoxL+BApLl8G+POluGQBHx53OLEzZjGpcDT2UBko4iIUaiFSs
         nsoNjOMiRC5y+tmBHF4KmEc47foCT8XCWHJ6+U4peSj5GKGk8iNub6GtTUNX3F/Cydq+
         jHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794410152; x=1795014952;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=12qva3kO9NMXV3ZjsX8ymdd40I9ua49Cy0e6eRmwhRg=;
        b=MJVnx+2R82xz+paiSChDo8knCTEhCUxPQIHMSQO4ZAubG8S4noptPLmQj0PQEBt+rx
         8Y9zrxOQIXjqfA/nPZ//PtYMe9N3uErdOGBE4tjkPI49nx5PTnHXSNIdoeOIwRwajj6J
         k+x+Wnusq+tFGzFHWAPLqnprp6fbmuCPhFuwWyEZEwq3zj2F01kJqb1Vl15/R+earFRK
         uLP+sLg3QMjgIFiEkyrmz9Prgny7dg0Tb7NiNauuARSvZCS1xMkOJJn/XBDvVU2mJ21F
         tP+mr0uAnKQR2FvMub4nr+HQl5eVdyXmHKaeXyz/Hw132jJ/hV0R2rcbcdXGhpIoOvms
         RQ+g==
X-Forwarded-Encrypted: i=1; AL+hErGC59hBa8BWUleWsITW4SdXCQF0oMLKrIlFBZj/F4iU1LSCOCFn9GHuAt67qU1uN+Ft4dhULWmuaW79@vger.kernel.org
X-Gm-Message-State: APuU4Z+INOdIKRlHmIRgt2+GpOuBrYNrThIc97NiX4vvlXjWic/oNHXG
	QuR8rGmCWiWUV1vEZQ4pwnaOBc8hmvM4cip9cRhm8d1mL6or4lGfzAcrMW4QACgpMs+t0qykLss
	jt0j0EGVeQAfQ9+dSHeyPP1Newvt3ptBp0aYK4HI6
X-Gm-Gg: AYBFou28q+XW9i5na/jq1Y1d74XC/xfb317JOrttvoaf3WQdzV5FOjU13EDHf8abHv4
	wyhmrGXGqUREMXCJAp4JE78r3V0FFZGRI2aOt7c7JF5Uvqns7TZpYBVzLEBcSSSn1j6gRFR7zBA
	J/3gY9t8wzaWdwLJ4PV2fnAV/FxwAHYmSGJpaxSxiFd44hdA0Q7q3YH41eImhqfHHHUEMtyzWvI
	F/rpEQUiOyQ1pcI4xyc5mHhhL98TCAWl7D4bTovtBPXsbfFMjabK0KmSmcCYpMeeRLd5i4n1anP
	gCSSekL45JkNX31Gwtc5Q21M68zmEMRiDPRth1+d9p4U+uPN7QbJyGjnUancrnXWN8T0jx6Dyp9
	eSEwPzWekKRh7r+vdru3cI8FV8/QSRx78SOc4ZfdZAcdlBDGcOObZEt6ACmTmH3Cmzkpwj14YKv
	zhZXgonQ==
X-Received: by 2002:a05:6820:1341:b0:6dd:1d43:8cd0 with SMTP id
 006d021491bc7-719179ad6dfmr1495859eaf.80.1794410151612; Wed, 11 Nov 2026
 07:15:51 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111092505.3121847-1-lee@jaeyeong.cc>
In-Reply-To: <20261111092505.3121847-1-lee@jaeyeong.cc>
From: Jacob Moroni <jmoroni@google.com>
Date: Wed, 11 Nov 2026 10:15:40 -0500
X-Gm-Features: AclHuK98LgEQHpnp7gUNAvVHjaxsZ5PsQKymcaEXqojXPpEtvDXgfkwqN8-1VGc
Message-ID: <CAHYDg1SDOd_0ukm=7AX029Cr7Oc1UKoSpmd=iBz55C3DFzv_hA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: publish APBVT entries after hardware setup
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, linux-rdma@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Shiraz Saleem <shiraz.saleem@intel.com>, 
	Mustafa Ismail <mustafa.ismail@intel.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks. Looks good.

> +       entry = kzalloc_obj(*entry, GFP_KERNEL);
> +       if (!entry)
> +               goto out;

I think the GFP_KERNEL argument can be omitted here.

Reviewed-by: Jacob Moroni <jmoroni@google.com>

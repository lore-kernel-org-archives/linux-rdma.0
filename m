Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792492159;
	b=RdzwPN9vYX5HaQ2k18rvFUXMgWulE2L8Mn5sn+SfFhvOZXRbTFbhpR6Uvuze3HNdx/bj
	 V/3oQ8/CUehNWlMmgRt5CSH6hxALBLxmAgtREH7aZVF+i3C4cIRN72VLOIKc9+1rievGV
	 KXESju7GgKC679y6EC+ln98AZegt0pyMvg9cdOfagjQOLU1pvmMkWlnwbV9FaWZCj+ByV
	 uUaR7aOTPAW+nvYeiE6NJjpJXzGk57DPVv7/gVB/G+U09KwcNM+s4zhPa3bXL4uDqadaQ
	 HnXioiQvBxkhzM4nIpTs8pAYNsyMqMxwYdHmkw4eAOVESG4j3sgw+7swFVyaUn4j3oA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792492159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=DaGQmjJp37UYSV/iBuExkFx+biffzuBEmX37u8YFfQg=;
	b=uoDVxWuDPc3Np7MupBnkdL2SqlP1LQnA1b6yTvpnDaahbgNs9oVpC4gX5g3gLgOLBdbh
	 gtHdl86g4aaNqKGxq9OUnkHEIySIzxMvgB4MMwRRULbfLvl+VLXsSwx3FZtDt5J6ua6Am
	 T8pWdDH1QlQ2ERP1u7BeQQPLq2sbRLMdZvn5hYdycTeyKO4CQ0XSso83HJ7hU+zeDpIji
	 Q+5mpePIuqonYkPt8dZd5F66CQYjcKirMoiHTh/PwHBZI/T14pBj4hil3uEdhYchXZVqy
	 oPX8IJsdD+9QVwL7zq/bm5N8OrkO6VRiKLgPWbMnfMnoS/P6qDdYDsRLUBZXcsfXBQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UgnKyVx2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34323606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34323606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UgnKyVx2
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7fccba9c675so785187a34.0
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 03:29:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792492158; cv=none;
        d=google.com; s=arc-20260327;
        b=QTWesMvMsTQVM/YlCmujb2FrcKa+BNuIrVUcg9OCcXkIN301MyiSNSxbr02GiGNDqx
         c7nGiGpVxY9TMaw/JWy6EbSvHRH8LchBlCf7/qlVh6irQbI/Lt2KH3SuDoNGfb4BWhbm
         unmBJoFURyqycnANvk/l+8DDCHkAXioYuSeDbxeTDb0+/6Wp7h2d68LoiZIZf7Ae4x5i
         YMYRJJFmCtqclFomwPzsbxW7eJ9jIIGZxjNac5ElFMKuEgF8n9Mkcc/pJpEF3BkKkA4L
         1Z00QoHQyYbcuMk2HwRU6w7mMSRDFlMfbAz9IFHkDjZq6inXwtVzxY0xhXvEBcBM9kIy
         rv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DaGQmjJp37UYSV/iBuExkFx+biffzuBEmX37u8YFfQg=;
        fh=V+6OU3kcDJHrYnXKhhHg6nc8qDaEmTWOO/w/kUGOsSE=;
        b=n2XBXDPIOuuqUykVOCPnKsYVBAaV8HF2JGI+sj0OITmx/9eikvTCRCfBPU/96fpaom
         9uaa70q/v4BuyJqQZjGDrytiO8h/1W3R/cAQhls5uMWPJBxMpp0JYM86XrFOj93IxUMj
         lqRFHRABlzZR/Uew9F3d74iiOm4ct145PU6iVucGvxD9OoAaKLpaVIxeIekuUPk+UxtS
         DbPaZ+f8BwIJMaLmJcS/K5oZSAwTDCD/Um/xDhI5jMueVIHElWP4DA/89rhS8WUJQHFx
         2WRE3bs/YkeSQiz2jLc4eRauzHaglnoxeLH6wKaVmgaj6MaREN9klEIVqEoaSj6FY0cQ
         F+Bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792492158; x=1793096958; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DaGQmjJp37UYSV/iBuExkFx+biffzuBEmX37u8YFfQg=;
        b=UgnKyVx2lESGArjr2dtbpJZ3jxb2VUQkASgb/7srbrB9yEt5S5buntFjZhWHJCK956
         pd+3dJ4g4voSIxoWT0Yt203YWp0OjJuYg5evDFQDWD54kt7mlm1tiypQtc6YwpK/agtM
         wim2UG0abVcfEgQ7eHJe23+TGR/pfnSmijn01DT0zfIqh/5T32ZFtGcjmdAP2SM7kLaX
         RrdYEFZa+nGtPwwBGLiNUxQAchKquKrJX5eb0tPojBTEQmUceLGp9+PBaWXCZe2qh62s
         vZxYvMCf43HvWKql2UJmSrAvvnRI9J9ysDF2pGSzqeuQlEtxugzmsnHozByQIAgdt0GY
         Icxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792492158; x=1793096958;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DaGQmjJp37UYSV/iBuExkFx+biffzuBEmX37u8YFfQg=;
        b=LoAEek1n/675P/J9CO1so8iorb2RzKSezT+pL94fcTiDBQAEwHicF4jRrkEwnkhW7D
         rsyzIxdyUCFDPb4jv3I4Kn6GvJ11iHTNecFvZJpKWY0ySXrPIDZAkUgxYsm8/J6Bj9qn
         8/XHlLkaRK883Wl7lZice8HmSPK2+MHbfwUn8dyKkZcBR50Jgz7M5eteYpIe5LFP9ZMK
         4i1fwzamJyw/n2L/5qaJFJVshf5S7H/nFQ1V/bZlAwny8GDhS3a7Kiz8XmG0DWOPGa+y
         6Q92ZTVyOQCGWgrOeG/fBo2rjVaqnWUOVt+6us/xiR8zyolN+JDBtJoxvajnG9H9BIhT
         14sg==
X-Forwarded-Encrypted: i=1; AKwUvBzBb6VK+Ty7g26/kU9RDJUm3tX9T0lSnkA/z70aUwr8Byy5Oy9SbTPqxw1Z9GrZjpcCz7jwO1DUJhit@vger.kernel.org
X-Gm-Message-State: AFq9FYK4hpbcB4cg6GPjyRETJqTEPfA+PwO2LwDQFJu3p8881q53WYBK
	i+WqW8bb1mIGAUdxjtqQjYvLksXFgfay4BHTgB5dDVvDxnRyRvVAn0w8LhIEmQWYJSgkePYcik6
	NErCFTCWgaPztxvDyoK4S2JDXBHkLNIQ=
X-Gm-Gg: AYBFou1UHu23/eM5syKJ+2dBxmq5tQJwWUovC7jdXqp8YAVTnLmMph0XBTUOt0W7Ze1
	2gEiQRVSyATIxDdPfBNyYCiTtOGNU4/tiw09OcBM2sVoIRo/fsAtplB9SufFHVhRiZG+pDH+GVj
	2qqKk+EWdXNidzaAEez2aAXKUvx/KrU1r2PgLJDaEtVzZFbsiryfx9zPfnzuTPlVMvNcrDl6r7V
	1LVcUvwCFzviG+jaqkdasEWGaaiVvBbk6WpF8O/dUiLVbr9T3SrW5PNJUCAP8vZhQ9rH3E+5hdo
	n9s8JZTUM9juhlswUgRef8gCE1uVfWWEp1pC20YwmphpA+Ag4BH75XTsX5IHab5vAc4UZj8EffY
	hWSbZlAEfNhipp37VBOWJcxX6HL9gZnYzVjT1PvufqNjEvz1fEK14Cas37q5X+Puv+fI8NYsYcY
	wqsi/1oYRB+JcI2bqu/dDjfVuNz6CnCB6+UzVAdV5zWRciNfVLvH8=
X-Received: by 2002:a05:6830:718c:b0:821:dd7e:330a with SMTP id
 46e09a7af769-84b74767c52mr1172363a34.8.1792492158132; Tue, 20 Oct 2026
 03:29:18 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFcZKTyCu7K=1OOETBvVrKf-9YKHRk7wXNRyZW7m5P0PEPg1zQ@mail.gmail.com>
 <20261015092200.GZ219304@unreal>
In-Reply-To: <20261015092200.GZ219304@unreal>
From: Peter Morrow <pdmorrow@gmail.com>
Date: Tue, 20 Oct 2026 11:29:06 +0100
X-Gm-Features: AclHuK-Hqleao73VUBziUblRp_E3tFyPASV536hNnVlfimnJbooKVRRcaLJeklg
Message-ID: <CAFcZKTyLm3P8Jr31sQSGpE62W=v9+Jj3iZAQ7MNDM1DcXzroXw@mail.gmail.com>
Subject: Re: mlx4: no ib device for Ethernet ports without IBoE since v6.6
To: Leon Romanovsky <leon@kernel.org>
Cc: tariqt@nvidia.com, petr.pavlu@suse.com, yishaih@nvidia.com, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 10:22, Leon Romanovsky <leon@kernel.org> wrote:
> The best approach is probably to add a similar mechanism for mlx4. However, since
> that driver is quite old and has limited test coverage, it would be better to
> implement something like this:
[...]
> Can you please send proper patch?

Thanks Leon. I've tested your change on an Azure VM with two
ConnectX-3 VFs on 6.12.111: both get eth and ib auxiliary devices,
and DPDK attaches both VFs and passes traffic. I'll send it as a patch
this week.

Peter

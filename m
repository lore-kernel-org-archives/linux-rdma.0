Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FDB361961
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 08:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522754; cv=none; b=MlzBlHw67Xud8rMOJM716oFkKKDASwPQzxD7NTvp1p6Uqq+j9O2Up4e07jLkvT/XbNExkTaYSlDcf9xIW+iK+CNRCH+lUqlEfKUlHhIDmOmNjjCpad1fS2VDzbR/sBRcO+dbrnzCr1+3zYSrlcbHtBYyep9hGixQCYGZLn2uefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522754; c=relaxed/simple;
	bh=bEOr01HocXDAqRG+q99yycPHud0SKzNFTdPYQ4BVHps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MigN6Lr7ZcqDTsHeK9Cd2ZijZ61UfKdUjHIBr1bbHUXee972HLys/EcX5e30F7y4OPrMWwy57BI7WxcWY6Gq2GxfnRRPiT811+OtoGnzWgwzN5+VyL6M5zZs4yqJwUyv1Ua9IyukIOv++83rQMuaCuFuJLYL0IHqhfcN5j/0AOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bnETKm5m; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnETKm5m"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2074710751so108875566b.1
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 01:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786522751; x=1787127551; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FuiaRqE2K+qZOLkd807fL363LSKM/Mttn0VBtRmG7WY=;
        b=bnETKm5ms8WniZ7sJ7RXWvrUXkLGQx5J4FbrCBXQefSGuExYu5g4QMkEWQRDxhbOfh
         mph1gT+fk5/CLHnxScPKwNbn4CGDUVFMX+Jf6Btnevlg5ie3gjVuf1qUYiv/bYXfSWWN
         sVbygcCGZIEs2KMRl9KqKHe0Plgb4CA2mvu5Eekai7jeCqQC67UlgpI+F+XMt9AnUnzm
         lJrcVzcdozvacyevTopiNXYI7K69yaEU56NkjRFtdeT2gfBiTUEkFj4kRaMGGI7omwvg
         R6z6UI0XC29F5tVMJpc+/1uq9OYpztd6PTd6H8Jpr8qM1VDPP8gIdUqazADqaBqcZT8W
         RMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522751; x=1787127551;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FuiaRqE2K+qZOLkd807fL363LSKM/Mttn0VBtRmG7WY=;
        b=cnQ0iNhDKn5U1O4KAYVzKFBis6z80Eqybol7oyMajDmgan7FHhdeiY1y9DISASoedV
         KRk9zve5FVsWWw8pbkZxbXXvmciXibHwt4ohvpIdIH9qSxrR1Z1pSAZAK9Dx9nBTW7iM
         +ggub4rzs3nfMgXDr//f86ha4f1ePZ0Qpq5UEWc7SF1etrEfBfc/hdeqY+iOmwMn6MeL
         +t6J6CUrffN09nHTXIlfs67yKOu0PFRVwezw1c6N0fVg7nFzNwS/dFgmJ+VaMLtnYtOI
         QWU3s3P9odoEXJ7rpvleTU2HTSBF7Y1l2MrchwVBz/mAi9vSmPtbCma6b182X0vDdykK
         MSgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrodVPc85Og04BECXC/pthV0sWp01A3gJoxwmEqSaVvw/piAy7LsKpr+Yg2ilvpvl6pjpwx8EkYknCn@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9oJg0EaYGDaYARebXybmv+nD3PmyhJUqZk2wTFXXNvSJYAHLL
	27cytre2++2V/AgkdH/8p0LKUH9TNPbwd8On0CNYhDBlVmLVUHgvxj2kHFrY7l15K+U=
X-Gm-Gg: AR+sD119k09/Nj0iF1/StU1iortwvzHZPKLZZdRhvMAqbr5L7BTGRrIe+MDQb6dl1L4
	XJH2ML3KDdVICgyfFQhNkr9q3Rn5vDefG6GDnLu400OfLdrCWnNZ29oX8arogjM/5OwjI/+WxpT
	5l9YEI5GNQzyWHZFEM6uY2sYL2bH0tAc/nhF4g3bf9q0BrLbhrlKG8/oeOD1QMcbkie4yHKIU6m
	aE0ruHctVjdr3QIQowow4L3UVx9Jtk6hHI+PMQ5N+je8XoqgNFFdDPqFkW4u2bqBW4vo94ojWZe
	01Z2cbKdWYACIb31uAQ6qZMGXasYOvZIwY259nfEz5abzgUB8tUskmyhPgbYSrj0C9C43x5yEa7
	KHBw1iIWCSsErGJw/NDbbCcygI8kwBMKUjmm8WUaOvGLzsr8PTxUcbh1/RN78U1liJTmdeICcGG
	PqeaNZALVpZIfUFDYsuRs75My2z50s/p1Yxkj+YzEgaw9FEf2D3RYZh4zr5O6HMbBaCrSzVV0x2
	Jp9/8VpRVyEdorc+DTM+IEX198EITNxeWvNIPUuOEiqsV0oxNirUE1c+llpGMcuhSFfuFiQ2l+r
	jD1rDPRyP82Dz4QEULqA9z/XfHPX7KoITZ2mLbiEYa21SRj0T2WGwlTP0lxmG1lVqN1yD3qIeUS
	loA==
X-Received: by 2002:a17:907:3cc5:b0:c20:191e:89de with SMTP id a640c23a62f3a-c20f301112bmr170570066b.25.1786522750932;
        Wed, 12 Aug 2026 01:19:10 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20f0acf633sm62154366b.42.2026.08.12.01.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 01:19:10 -0700 (PDT)
Message-ID: <8a15a6d9-20b0-4fe2-b96e-9b9371eb1831@gmail.com>
Date: Wed, 12 Aug 2026 10:19:09 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] RDMA/core: Reject unregistering netdevs in
 ib_get_eth_speed
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com,
 syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
References: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
 <20260810113308.5db6937e@kernel.org> <20260810183902.GD507588@ziepe.ca>
 <de87c6a6-44c9-4b78-991b-ff858e21e806@gmail.com>
 <20260811163025.GM544626@ziepe.ca>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <20260811163025.GM544626@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks. I have sent v4 patch rebased on top of for-next branch just a 
moment ago.

On 8/11/2026 6:30 PM, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2026 at 11:21:19AM +0200, Krystian Kaniewski wrote:
>> Thanks for your comments. It's my first contribution really, so I'm still
>> learning on how to do it properly.
>>
>> I'll do the requested changes by both of you.
>>
>> Should I rebase the v4 patch on top of any specific branches for rdma?
>>
>> I found "for-rc" branch while looking at
>> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git, would it be a
>> good target?
> At this point the for-next branch is a better choice
>
> Jason

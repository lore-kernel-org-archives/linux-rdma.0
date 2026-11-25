Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630377;
	b=INWTGcG1o+0Jo1UfPj+G6nqtLuRnl0x8UOB0vRrQfF+iztUFOKWSpZEmvzURAf0SnI0q
	 PohOFMpmd5SZCQAeAq5y+2mdXJGfhiK6XOr2hMfuodMAe1p0KgIzB69u3s1ZDro2b0pMs
	 S3O43RCRWq4KrkmPXavCHXhK0HulDBuWnECbLyHwEBwcQVHavCvr8hvtaUeWshQ1Q+J68
	 PvoHBxsdd6BpVon839KLGvaEttnGfhxk+8q/curuPx4CYJDi9CdCZySFEpIcdWX5auOuc
	 6JnDv4fMwIb7X4qBh3EquuaB288EZRTXLRsGMly9SxF3o7mkZv/Dx8hrgtE4ElvP5AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+jl2a6MD9u0WX2eMTbDkIYQ14DZ1p7jge40/5A1LWnc=;
	b=S77y7Ns7zfxpxTB7uYk3YZLhQXTl5bdPJgYwZ0S8AdZZ9tHcBL3G5w/wCVrhJRwbfBQ4
	 Frgvh1YXsELAzDKMid/XKK4K2MT3XzxFL4PQmVms/oVyqXgo1Ig9ycks3YJp2zYriQ+hx
	 7S+6PUqCy9qCAGU9HxgJsbAgnAVTkdoW5yD4gtJAIb55nVPOoczZr+uHtNk2JP5ayI4JH
	 hVPB/n5W9Ai021xqMS5ZMOV1uRqHPTqOpA7Weyo/8DMFJZGz8JZSgDzWVjfs+9/De8QV0
	 6vcoblirK6Ng9eO9BUXWFZ8Kvtm1swB/4ypJuoDX/byA/HBbMdcaZJtEkT3YhyQIikw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AUVQ8n8v;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0BD606A681
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E0BD606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AUVQ8n8v
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2f04e3bf46dso44983875ad.2
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795630375; x=1796235175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jl2a6MD9u0WX2eMTbDkIYQ14DZ1p7jge40/5A1LWnc=;
        b=AUVQ8n8vozaET4HwbCoMH0xZZwpgdCqh97occpv/jvNdyD0E7lpv9k+hF7Dw1ZyrHn
         6E3pUIlfiU3BhYvz1CrNVO66p8mRkVsW4NZZn+lHm1qwISIJOmHmr1+inve9hmL5lE8o
         5CtMmI5WTsf4hh6Wd/z4fkk/tyYrFZbgTfewKszSFaBaLcm4UazQTOcfhR3/LhUrmHem
         LsZ33r08IpAHg9sV/kdrTmtV6esnQ0rPvPjPi3ebL/9LH2104htXAZZN7MED10by8E5L
         5TcsFnSfpwEf0JF/IlLVtZ0+p4mfK1FqKQDHotTAUKfDCDZrKeIBVdLU/kokkhRiNsH4
         aPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795630375; x=1796235175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+jl2a6MD9u0WX2eMTbDkIYQ14DZ1p7jge40/5A1LWnc=;
        b=dxVYU31WnaOBM/kqB4O50zQ9kcUWpvRd/Wm4gVsRY+TpHyN1V/G/9bgMeIWsJirFUf
         dBG1x9gAyliVFRCJH40hrtPj78uLxHRa3TMtmwSWbXICB7sQ7bnKogbE/yUt4WGBr2Vg
         P9npCte00gnVbBPConVmEo8tXiOWDXfrtPIs4X25NVWck/JaTu6jTnmZxypzLUpt552M
         hlAA7np1GZh4HxjAOrLPg5TKktlQzGz+tY0TeUovJg45JUp4cnOx96ZCFYiZ+avG62J0
         0Y8vahR15/Gc1ANKE9F7stC+GVnqyKWx7qPPK+bnWxpMpFvl8dQnB4Ux9OaAPaIZBq0X
         95Yg==
X-Forwarded-Encrypted: i=1; AL+hErGnEnDO844hJDBeIqcSNA3o7cCNVRwEIPf+sqvqWI1Ju615dnWMm3bZ8LnyslSSRUFCSexO26WG2/zJ@vger.kernel.org
X-Gm-Message-State: APuU4Z8y4fYpKRvEv2bz47l+0pvLCz4iuFNbacn2tavUxpfrru+EyJ3+
	0g1F+3xLj/7uZe2RaN11MvQ822dw2cBh18vh0BSUh/n4uqQzutxPC8BFwV2vrtsWZxw=
X-Gm-Gg: AZFdTZerr8hITnsaKKnCqjYjqbJbmCRddk4yzcqaHs7sYx6+Kybc2kEfxcAGLTp1XSB
	DNCGlDb9jdtW6HXPZ6bSO9qU+1xoKwefUZHgj722xK5f5kw8NYbI9J9ulhmoPUfFd7aJtS+FZOT
	UdA/y2tNKnbf6tjcObVTjTP2bXlw+2QogyE/RZI7cOLgfnbd+ppEr4EnNZDTo6vlL6EzfjcMdYA
	4a25jrZP12kSFWJz9Hqcpd+dUJtUaFXWXj+10dH+PRFlBbLpGTcuLJAqUbgXsATUdYIyP7q/f7L
	vzwD8LKyDGqsgUi9SOUrGDtGpXwysgGGxnVkvq48QEILsfvFJfdBEK0YfvkV4rmF/6issbFuSbl
	ry3mtrjgw0AYlmaZM0bqUkNtpzgBdKl80DpF/yg6XL1BeEUQUVpTvIID5/z6VaAj3D8ZDIfdOBM
	ok7RiarVfOXp7AIA4cKcC7pMpYp2cNbIXvMj7MFTYYq/zp2lu+nVQtpJTzfVBzGue2o+qIYGpME
	2ZtZfhMmymLhKpZdEFUyMfohT7LSKidbuIFidagEjk6D/WA1wm2c1L82eH4a6PZOYM9805rwO5m
	hrf+9/+VNbS1vPlMVycdryd4e1rphVKa+eJI8QlfhA==
X-Received: by 2002:a17:902:ec8a:b0:2ed:a8bc:6d9e with SMTP id d9443c01a7336-2f03f1ed325mr201637065ad.30.1795630375416;
        Wed, 25 Nov 2026 10:12:55 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1482c3sm89337525ad.73.2026.11.25.10.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:12:54 -0800 (PST)
Date: Wed, 25 Nov 2026 10:12:53 -0800
From: Joe Damato <joe@dama.to>
To: mdshahid03@gmail.com
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx4: fix error propagation in mlx4_load_one()
Message-ID: <awclJaYkHbGuXdqv@devvm20253.cco0.facebook.com>
Mail-Followup-To: Joe Damato <joe@dama.to>, mdshahid03@gmail.com,
	tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261125022913.205366-1-mdshahid03@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125022913.205366-1-mdshahid03@gmail.com>

On Wed, Nov 25, 2026 at 07:59:13AM +0530, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> The return value of mlx4_check_dev_cap() is not assigned to err at
> two places in mlx4_load_one().
> 
> If the helper return an error ,execution jumps to err_fw,but err may
> still contain zero from the previous successful operation.
> 
> Assigning the helper's return value to err ensures that the error is
> correctly propagated.
> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

Looks right to me

Reviewed-by: Joe Damato <joe@dama.to>

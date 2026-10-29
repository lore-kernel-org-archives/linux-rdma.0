Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300688;
	b=zS2CnDK29FIPxr0s6l6j+mSDwz8KR5ZqNBYCCJ3ATdKhbLFwcMnsvI0ckhZDO3aGhs9R
	 EdxXGd34E/Kzn6gfQYpg2XNGA2wQQh5CNgsjgepkeqMXd2PVcQNNsYtvUe/aAKxHfEJ1Z
	 IylKn2O9LrgMr0+VUXScJGwcFSlPZ3RJJuW9JqK4A0nGI8rr9fbg/ehDyY+R4PP57frJT
	 MqPwU/MSCmSgUd4r09/Ya1WOXMnG5vy5XVsEYK9Ls9upMLvVNDpNyaz4vXAiV0PMYQwD/
	 L5cU6D7VWR1RPd2ce/yZol/nTWtkptGBTn9zlkq9Zi305w00G053vivtZX8jjTKoGrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=XdoAl12lw/fEQqYaealcRh6QQpZb1wPL9tsyUs8XxOA=;
	b=ikjgD7rVVqWjZ4NhQJ8rH8DOJacnYELo6f+ax2Dnudq/e07Sdy64z7ZfpTuNMWQ/SOY7
	 WT5vIHyi1JlAqCDX5YdmI5uu6mHJIzVSwwFIgquQCpdq1uPrNsZBu7aoUG0xzDVrZtfEt
	 9lUe5XfTAqzJN5Fo/kSXqTuVCd/NR5NFSpSPu1wSjTmohhkVbUMB7RItGk8TrZqTeKNEz
	 Z5UGnyaMWiWRApSSQu3VA1jP9L/rE0l7It4x+zrsCfnLUFgojzK5bSDAOYn5RI4a4/rwA
	 O+avXU/1OSohcZ+NImAR/0tjACLDCCADaLdEui0s2zkzclbsQFLZ/V1cmY/evUIitDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=JuVgGKU4;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB94606A31D
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 19:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEB94606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=JuVgGKU4
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-537548b811aso21553001cf.3
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 12:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793300686; x=1793905486; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XdoAl12lw/fEQqYaealcRh6QQpZb1wPL9tsyUs8XxOA=;
        b=JuVgGKU4qzuw3o2r45SDb17dWVTn3dpcj5kPT5ZJyL6z65sPT1+Csf5ybM6DnbO6Cl
         rCHv4iuylZjRSsFwJpr+DWHg74RQldYGkgypTB9KdKLS80d40uLCjKJm1ERtWDEvkJrr
         LGyJaNBUFamgVl6ugJ/yU1Rt3pEM1o/4+YSqH5oQXhDA1gzYNZ1H/INzbJ+OLHm1tJbc
         arFz640hRHvJh4/v2f+vhe/R0XjyFFaxH4eqQnAC6aGp5hPdefx4V1IlJ9p6bYSDM4zx
         xEcsXkdnhfAHRMkBf64gYbzTYqttpA01uoaqaOegQAHurgYibhr10Y60YPEKdEPJhrLD
         ArDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793300686; x=1793905486;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XdoAl12lw/fEQqYaealcRh6QQpZb1wPL9tsyUs8XxOA=;
        b=kHmmAwVZoTaEocZXexr77hxhhcWS7jM7qqGksQpMlN1Va1oWe0tcvz/HgvmNOG1Act
         SxBwPYr+oILPU/ydQgaNEODdAGEmJQLGx1Q8IN37i5icQixWmZrIuef3iF58LkjNTTRi
         rv+oM4rvtgt+uD0avw1zCV4mrYhyczQWUfcyEryo15jreRfI92hesfErgYBqvvM7es3z
         Wd9Qb8c0+3gkl0X5erNIfJBLZYoLCBr7gYEzyI+ZLKF+A04Kest1/tJO/VXq8oVetuUH
         ktQSGwQuZMOWPNw8puA3WDfaOhErL4TbscO9wdcvp2A+mIE5hCn4ZYgWUYCl+aMqOsUs
         epSw==
X-Gm-Message-State: AFq9FYJeKwjebQVvf7Qv8mWh1QpTKS+acf0VOL8NWGt+QupgPBII9LTu
	sC63nH8a6Rmo+MbkyqWOxNqq7OZJqjuBnzc9cg0ZlQfQRcBlc022AzS3bYHv79lmqH0=
X-Gm-Gg: AYBFou034cXjUvFv2GD/WL+fIAHXibsGKUF6eW4qmJEeBPKNGv9Y1XBJ+QIr0gHe6r2
	24WVnNEotu3iheLwkS0IrP8cRLNAUrYeXIuC5FxQ3+6daxR+TMOqjkg2oRTw+52vHOwU85Cxy21
	oQqD3p4bkRKqhsaetkTTxyfTLvHNl2VFH9+yermc1Sn4Yv/YAMoQZzr1fmeWi7rRpqcLQgMHn8q
	oSivjfAOZfWTZtpX+Gg/mkUQN+dC+dKFoA0MEKfa+M7ZbjhRrLqDXH4/0SeO4GYxZo9/jlRuyLU
	qLP94QfVkCm56CJxFd/XMn35fnAxL0ifQRU/ftxA1dYqiJeLRipbq8Eo975dqdTR4XVzmTnuo+J
	uXw+f8aspZKdEhKmsdMe/l0TCGlrd2JUHYh5YVb/13QMdvKO90HQVVEVAXhTB008J9zJO9vrECv
	sBLHBOOV6K6hdr4nxKZWHnk3a+ANidB/kLi6h45yyJ2y9yLoFal/f2yv/nm7wcw+aplsJZfmOV2
	qMoT/OIhoQrO+Aj9G3Ofk4DjoPrA3NifjjCnOMTnymIo4/keph5LOPTfm8bSZWhnyXAANiKKG+P
	Gih6BG88wYmGISRIujoYstU+CXizhqcyulSGKZAADI9wceCV4FARwe2K57qJVPqeNwCQvyIjV46
	QG/jC3INTkcQ=
X-Received: by 2002:a05:622a:4017:b0:531:190c:85d6 with SMTP id d75a77b69052e-53fcb20df7cmr104066131cf.16.1793300686497;
        Thu, 29 Oct 2026 12:04:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca3131971sm3641926d6.30.2026.10.29.12.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 12:04:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMVQb-0000000GIKH-0xOL;
	Thu, 29 Oct 2026 16:04:45 -0300
Date: Thu, 29 Oct 2026 16:04:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
Cc: linux-rdma@vger.kernel.org
Subject: Re: mlx5: dma-buf MR on GH200 GPU memory wraps every 2^k bytes when
 the base is 2^k-aligned (k >= 32)
Message-ID: <20261029190445.GS1685504@ziepe.ca>
References: <20261028103430.Horde.FEW-mpmPqkkJwfVq8q5rABm@webmail.uni-tuebingen.de>
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
In-Reply-To: <20261028103430.Horde.FEW-mpmPqkkJwfVq8q5rABm@webmail.uni-tuebingen.de>

On Wed, Oct 28, 2026 at 10:34:30AM +0100, Dezhen Lu wrote:
> Hi,
> 
> On Grace Hopper (GH200) with a ConnectX HCA, a memory region registered
> through ibv_reg_dmabuf_mr() on GPU memory behaves as if its mapping wraps
> every 2^k bytes when the region's base address is aligned to exactly 2^k,
> with k >= 32. RDMA operations complete successfully with the full byte
> count and no error, but they target the wrong location:

This was fixed a while ago, upgrade your software.

Jason

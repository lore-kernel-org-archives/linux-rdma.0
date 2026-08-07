Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC753F0A85
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786144243; cv=none; b=Lzahnyrq7GDvzuuN0Ye795BBbjvdMonXF2HoS6GFCLu5OtOuuxulLbdlt0p2/UApiM32qZ4gPc9gmc7n89awjvTGfJoCnv3SElVjleVK1n8wvhBZqRGdiPvQLKsg6SSVH2K3Vv7vknUBGYmG0A1V+oScLol/1hcU6/GZQ4qdVlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786144243; c=relaxed/simple;
	bh=OtTpg3/+phjoNKRtYnKTBXAMVSzYj9eDFwM7dBQ4sfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h76Al4WAhfuPs4mBP7xgoYNHDz8mbOtMUiM4KENs+cLYqGv67Y49dpr0ufwhItccHYsQhnZ/ZjL+AHQva8/VuKk42gZoTpAx0AohdNQNG01+y/4FK8gIK2tR4rMZjViUNws3ym6O7otYBNKm+e+NFAtQDTd4my2OABpnhEXk8+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZhSz3j8l; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZhSz3j8l"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ff20870ac7so60106d6.1
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 16:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786144240; x=1786749040; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6qo9YccwPJ9ZOSgvw/uI18wGt51F/MO39xuGoXJlXr0=;
        b=ZhSz3j8l4NTNcc9P4cQcPhYXNnvW+w8DOJFNS3lACxjwj2BrcqAuVWXmtECHNtETYx
         u6R8qmv0ZMGnFqr1/4MRUFnc/RbYFtkvwBK8rsjTil9FXYa09rQlzNXvHoNj5rMTYUMx
         1iO1t5WKEgupoepOAz6FOugKJu0hr385uwxlKMgtAKG/fMll8QJrSADvWn/9at1rJcZe
         C5wKZacwaZoAozsRH0KvqZAp3ObN1GyDjXyaiwF+0/gbaEaTiL+sIi6pl4Y85vB18wE/
         DbFGOAaRQjJa7Yw6OJYbkl9ArcQo3KoDL0kPQCaops60605ShJHs0+kLGbkt2TBHJx1L
         T84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786144240; x=1786749040;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6qo9YccwPJ9ZOSgvw/uI18wGt51F/MO39xuGoXJlXr0=;
        b=g4xI8XJb6BZrGTYeDQ/9Kgr6fAHF6WNtUNAf1ezEtSZq9DXGeeFnnuFvr/vY2OrZH2
         w41hIuT0bKc++tAHGbFt/1im1SyWjmlvC7hUFyQegdxCZJBAyK9DHFIJiu1RbjD0YA8d
         OiwSyC+kfMNsgBme3jUqZExJi2ETSAXRqJhJ1FrDOB0lH68Z/fOKSHuwoxtc1V+H0SH6
         xcPal96qzLIu003tg0CjrFxCXVe4NpRuqmk0PZvtG6cXtzSy8NY3XLkHMlVNrKwZi0p1
         Lr4mBMQMkNDk5xeflKFQUs/YNnafgjvWt3XBDrmzdRBnQzusYkM2Jt/RyYa7pYBjw4Ml
         0rww==
X-Forwarded-Encrypted: i=1; AHgh+RrqJjEbF8zwhwzsikMWY/JD4LElFyk4ppRl9vyWNkBDMOEUujoGj72sVJuvqBsBkq4A44ZH51nZCzZk@vger.kernel.org
X-Gm-Message-State: AOJu0Yxno4pydr+VOSj0ioeBff9HmJfv1z3faG++1mM+j6ZpNmxTVAgT
	qY2iKhhIE6LnWnyld7P+mrcPMA5Bn+AIRpQiRQm3AiadDrVzBON2YIIfA15ZqWaZZUs=
X-Gm-Gg: AR+sD12rkqtZZFsX96k4Rp16HwdPAntn1jXuq2j1dBRZg/wPjNGSoUBkby8Gpy1y1pc
	glXohxgnYcFIsaxqPekdopwqRoE8EHaKB6HplJw8QSflTjOPNecj1mcMc7s9XTjpCpelTzW1GuF
	AMQrJmh5Z1uziszDK/gOHdHty/FtJcQ3tfX0m8OP3Bnr4rjHf0egXS41+FM2tb0d+3ykDvPw8Ka
	rPhcRqwZ7+gL6W6T7gdGevZFqWRMba4lsU6hV0Wn+AP/9TKjdZHsWsaAxvgHZodMPFX9i3wS7Q2
	h5zdKnaFBruZge92e7Qb0/gYhmLHeJZno4nzst364EOEFKtyPhC8lhOCiSJqCgyLhe9QzCJyBwa
	5FEBr7i2mtvttrjZ1p7ex7xGS2G08WWQqyVmODSfsZHaQ2bVYUhXzAAfHpW+/GucB8ScXXaRiSd
	apMHDKteVvjtbvWPrnUmaK/RIA9yD+/G4IikdttQ==
X-Received: by 2002:ad4:5941:0:b0:907:840e:bf11 with SMTP id 6a1803df08f44-908811b01e8mr284845196d6.10.1786144240257;
        Fri, 07 Aug 2026 16:10:40 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a918eb4asm20001456d6.7.2026.08.07.16.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 16:10:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsTi2-00000001Hd0-3IYT;
	Fri, 07 Aug 2026 20:10:38 -0300
Date: Fri, 7 Aug 2026 20:10:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Make sure that UMR page is aligned
 to PAGE_SIZE
Message-ID: <20260807231038.GL200537@ziepe.ca>
References: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
 <amEczxLd_WnHzj5M@ziepe.ca>
 <20260723083555.GD110966@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260723083555.GD110966@unreal>

On Thu, Jul 23, 2026 at 11:35:55AM +0300, Leon Romanovsky wrote:
> On Wed, Jul 22, 2026 at 04:41:03PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jul 22, 2026 at 02:41:13PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > The UMR XLT buffer needs to be aligned to PAGE_SIZE.
> > 
> > Why? It goes into a sgl? The device certainly does not work on
> > PAGE_SIZE, so if there is some alignment here it should be the MLX5
> > adaptor alignment
> 
> We need an alignment to 2Kb as a minimum here.
> 
> In our case, we got the following assert:
>  ‘mlx5_post_send_umr: assertion failed (MLX5_GET64(umr_pointer_desc_argument, data, address) & 0×7ff == 0)’

So use that value, or the adaptor page size

There is no reason to align this to 64k if we need a 2k only.

Jason

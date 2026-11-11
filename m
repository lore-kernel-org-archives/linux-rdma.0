Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411436;
	b=R1yrmzgjFwG7+rY0tfcIsDTVo+6FbI9LCQH/umXZKu6czrqVyfJZ1YlRKDW3qU8v1JpQ
	 5dzyx/3FTriQ9tTCcToo9XsjrNULvzA2a9k/F52E3I3ipLtRTu20LWQGWUsL7W66WnW4S
	 3vt9kYbY1RGWAi+anum9NrO14CxufPbc7ipuvnLqssfXUTSwAeJbZ32dRYsk+g++lupCU
	 COKYjZg1X1lCFtQxHuTdFsSp6+fZ4M70Cc3lj2nXQBEHaEfxgUng2kGZzmvZ1Jm/J1I7b
	 1Qc5xQ66BSnPgiwVcYYkG1lhUIP/pBugBXTJxkSFDOAiltKY/oy7AlQ006axo/zsn5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=tj3GxIxqCdUc9IJQxKZYu3eLGgYe7ecnDezY1yOGQuw=;
	b=NJ35vTI3izHbDBmu50mAWT6/obUBvPnmdYjrfz//KBTqSzP6SYecpwPSHadDphaQ6sIW
	 H9urLFsnjDcHUWRQiCJWhHzV14y5mWg0r980AT57LBrcse/YNaLor2lgBnLjllQ/aLJI2
	 eoRD/Yuwok5vgru8pFurQbkCAOWsvadOIOQYKNE4ZM1fQMQSw5NTnV2cL9twzG2A7/78z
	 YD8/qU6Pyx2F85Q8UdsROotXZojd2/QUOFgHGILB9BFWtWXW448UmDs60cB9s9BaNOR9T
	 zGy8/P2mjm4boa0fTXkfobobG1glvg19EFCA3A+LyammaCDOeL03RvFQk5rWInae2Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Kd2jOdtI;
	arc=none smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1003606A32D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 15:37:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1003606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Kd2jOdtI
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91f0b9f0b1cso4424626d6.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 07:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794411435; x=1795016235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tj3GxIxqCdUc9IJQxKZYu3eLGgYe7ecnDezY1yOGQuw=;
        b=Kd2jOdtIbpC+S+dovcuAORD2DyTS+3fXr7VJomxlsq1MNhW6gGTfPD+80nkNRvPUgu
         xVjU0lDiBQv/0fjAtLiCJOD0fRulcZhjRiunUX2+VSlY1BD+gS3Qltkn6g705/prablY
         1Cy0LEcD7hzmkS8CwE3rJRrbkazhTbKAqIBKmFk+zHOw9oPpXcyFTeNl+bJQjs0MhjlT
         5fOzU/62syqkbWUqpNEyGrs8mbHSsn+Q+XWFLplYhdKPQpZT/vyYLNxQ/SkT7X/v86GG
         +WyJ8iabvuSBLRjKA2HPEf5TSwcHMkf58KHktxlWAsy/BSB48Eh5MrH+4fI3Fo1dTG84
         Nr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794411435; x=1795016235;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tj3GxIxqCdUc9IJQxKZYu3eLGgYe7ecnDezY1yOGQuw=;
        b=UOmpOUUu3IHrKJ/pGDp90u1WHFM9wR2fsc4OJCB9xHMQ8PDxcP+CzaBs8eP9b99UH1
         6vjFoF5XsSKzqnMRTfh8PFMmRwOdlX23mzJ6zJPRNt7yBrYK96uxSqQn74/vk31AVUC5
         gFM/8q43znSRo+O6chXO+vAHaDyk9Ijy52WBGQtTY4/8tL50dTfADrP9yy0ifucyZTxZ
         Yzdy748OePm8coQfihrraK87Fw9l7xgCpqkAm1CAWswc22FxGmBhgPyAvkLizUjFDW3U
         AjPATu0qI9Z65hRbO7stwiPL/8xrqAiCSbcPHrHLYdq+g7O909hykqkza5+qqN08n0Kr
         edyQ==
X-Gm-Message-State: APuU4Z86d6HvOR5gesf6EAz1XJJ0elFaGpuQ/Bu4/BbQBd6bWAwUIiE2
	TcnbWEgaj9n11UUABwzx+hXhxQLjR0zBUTrhLxt4/RmlrIc8uZxp3LKcVHz5ig/ugj8=
X-Gm-Gg: AYBFou177hFf51zPiPGVbFdk5w2xXqz2OtwrcCQBOC7zAHmWWkEyMJK+s3RuqfBdrKx
	Voj9jTXaLigK2JczUDh8d9nTf56cUHRhL+J+SyTjQ2KgxGHm2zcSxw7nxky0TTQ+wpWgkenW1MP
	WkUvs8b4FVRGZp1p7RtqRMwKT/VjxO6JFRtx79nPdLC/Bw/xJpv/1wayj2bUFSKN6bYiBO/UL6z
	OIeiDmhGw9XNhfpAeJHxzmXf+qoU4gb4cAyy/ooFq+ydx8ANEhmd+T3eFZuxiUIhC/AbGfwdnA3
	aSztI/VrtDMt6ORP24JpPw9LwJPKB9f4iIL39HkpPDsPvoYdVHGZs5u5aB2TY+2d1KbIIdHm1P/
	XQbdw0WypzgTxcmPfMrm3BxYBKWrULjZ8NwylRpZBa4CC5FcvsP6IM3A0unonb5HIM6jIrpyPni
	OrCy0OPBT9rvnrm12DdapikF9yXAxq+5EVsqB3eKRKpATvtPvGQ/JszaDrmjsB8ZwRNmysKqEnM
	U95F1/WAAfp5CzuZ0rWiYhZeYrRGweHpOdPThXprXeRtFQU5Dm2xD96SJ2uL0CXqEClhFas0cNH
	uQ==
X-Received: by 2002:a05:6214:3d0f:b0:91e:97f7:c7a2 with SMTP id 6a1803df08f44-91f04072c9dmr46236076d6.11.1794411434568;
        Wed, 11 Nov 2026 07:37:14 -0800 (PST)
Received: from ziepe.ca ([99.192.80.87])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef05493desm49564276d6.45.2026.11.11.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 07:37:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xRANs-0000000AjhG-2xzE;
	Wed, 11 Nov 2026 11:37:12 -0400
Date: Wed, 11 Nov 2026 11:37:12 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>
Subject: Re: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for the
 listening cm_id
Message-ID: <20261111153712.GA2532299@ziepe.ca>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
 <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
 <20261110003243.GS663069@ziepe.ca>
 <avP07JWvBtMboL8k@shinmob>
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
In-Reply-To: <avP07JWvBtMboL8k@shinmob>

On Wed, Nov 11, 2026 at 02:01:58PM +0900, Shin'ichiro Kawasaki wrote:

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf7..334f39c2f5e5 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3949,6 +3949,12 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
>  		container_of(id, struct rdma_id_private, id);
>  	int ret;
>  
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	static struct lock_class_key cma_listen_handler_mutex_key;
> +	lockdep_set_class(&id_priv->handler_mutex,
> +			  &cma_listen_handler_mutex_key);
> +#endif
> +

This seems OK, I think we already have examples of this in CM IIRC?

Jason

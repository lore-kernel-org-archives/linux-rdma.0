Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814043;
	b=SR0V1F+zfS35YNlMZYq/rxb+5bruR5Kbrc4pqOO9svlW5NfY1+Q/IMY4tJHiecQpRfYU
	 0ZFTnY+OtycZp1RVWpt9nIB2yTFwZCqccsvjpqwI+MKHEyMKFxPsa51eMb8zR8kkMUk5C
	 cItDkC0iq9WjQGeH2c25EDl0A9hArA+dxFBJ25dNyovPkd7nv5d9vOtXqSDtu2SKbQmx5
	 9yIQl8SVc5M02UJ2a5XmZLNoW/bM1RDxrN6JHoDQTOElHgIdo497QsAa8wa4kDiRT5GEk
	 bduya+flL6h1RTvvfrvyTYL2ASRT7HGqWC9uLtp/kMmqiQ12kSdhZKmKuOzXSglwlZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=YhtsBhvAospz3gnGs+ngXfQiCOJCp4pP7kl7qhf9OF0=;
	b=yJKWnT0ogeIOAJEJQRAu4pPx8x3rL/vOlFRO2ty03O7spJxgt/4C5rO1JNm48nKKD493
	 wTXYGnTzOVBzsFsNgZJKPlAlEmXERpI5kSEqyLxa95CX6OsCHBMmMyIu3UIGk3SIPUFiS
	 p7KYesEFSkmTiXsdDXwoVewLwvKQX/2ZAwTOFUrmk4bAyvP2K1jtDQkL+vzqojdurpvME
	 NWPErwSl55BzChffXZOohG5Gagpj3kabfEKyMdiif05ML0LSI9l1duwmPxnmfcqTykVxh
	 fcdhjQOdQdDVaHhO8otfdsb0K5RmUMIovmfUThjZZZwVVCw3h1JkgUGlQKtWP/1cyAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hCETnKBj;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CF8606A331
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:40:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07CF8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hCETnKBj
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-943e8d35f74so92469285a.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 09:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793814042; x=1794418842; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YhtsBhvAospz3gnGs+ngXfQiCOJCp4pP7kl7qhf9OF0=;
        b=hCETnKBjmqap4TuILlk1+y/t0ff88T9bZ+dOuwmLpwI6VzqQXi+7Ew1fUV0EIAA1Oe
         F8n5/Bs8WbP5ggdzMFDDPirWaPqIAx1iA/mDgvVJL7nQofjclhAmGbrh6dLRfzskNhB7
         ZczB48jwVorfxwOqKyEaj0deWOyd2jxm73M/SO+t68KSEg3LRDOS8txtRYEIGFQ/wO9F
         AFPz8T7X6Dkf0onwwvqIXu+u89B6aWxxrnvyvHPOMy6hW4tHhDs42P/YG+wJPPJAP7z5
         +htRw9gum7ooVb0W++2j2THOtF8fcc+b/xcGhtRsZffcGxHM6VTCl/yRyTyEigEerFK4
         CWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793814042; x=1794418842;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YhtsBhvAospz3gnGs+ngXfQiCOJCp4pP7kl7qhf9OF0=;
        b=M0ot9iRU/bqVG6/QngSp0fCOCPpRRl7tjazuLpdTjKBBPe2OYP4mhxzyKXr2FoIyQ3
         /YHpA0ujFYMsFw3mTLiDkFkBNMxzEctXhp3mPFaRprgSIf5t87iXhJlKrz3uZfqnDt02
         Y+H5dOAfc38Fi/61M/4EABGuIaaoM0bPak0oQglCZ3VSfnih7h3IDXFt5CXDBAAmSvpJ
         Weq1w+afQKvRd6e0FkXc2oxbMYrJy1tmo0V4TuQngauzlkQ1p0RQrO49BsfWzXLe2uCx
         tNHyzmJS7L1RPRuvSZ4keBOuZx+ItGnG3ZH0nyG19aZRPC/1dQuTlytsBQx1L+89V7Y2
         hBug==
X-Forwarded-Encrypted: i=1; AKwUvByb3XG0ldxJ0/cp4xHmjXS3+5WMydF/M3aAttIZl6hlpKyrQ7gdb16rlxzQzxxjVAjM6TUWzswPITT4@vger.kernel.org
X-Gm-Message-State: APuU4Z9cr+KcMWZDcOXFvGRznyNB8OV0ZuwJxV25aeLqCQ+TBanXw/KM
	lBd5I6CvqLt/nq+Q3c7D2cx5IMv3OPP9Gqk/P6C5HMifW3TdjLBMNbEFUK641bDxDEo=
X-Gm-Gg: AYBFou2339JUju/zj37XB46clWI9jilDuGkssB4RSGQyzg2kkPGEhdoJWIRq9jYLTSD
	DhJHDO6lznxCqrvkk/2k925TYJ7ZFKPiRtPuu/repkvwxhZJxlIRmPmOgfNR8gjAyJPXTdexvon
	ghzEo06HoJK7QfQpiiIpemFj9OPsYnW3ZbmjSNiLb28RbelBJLxXwLZrz40IYYO9gE3eOQZzfWb
	Ja90QZKnWjSzpzCE+r5ekxnJozicGpnpbAnF16bup5kXEMGD1g9J9pnrajO4tHgXCwvhqrfibrX
	wCgWYQvyJZ2DCdzqc3jqqSl8rIM7dNFIXqz+wQkH+B7f+RN5m4OqJQjqQGfK308PoboOeQfnQbT
	6y0C/0FUCkZALlN+MIfBQAUN8EGJ0GyHBIV1F9AHaemaDsZ9BozZW4Nw6+QEIrifNYqsggEVHPw
	K8+l20z5JlurGK0URlOX95VL3IwEZRy99HRPf3b/b2fv+yGIDiK9pAhMCUwEByY7t5kXtqx6SRy
	8JeVQEwhDaZavnIpj3fOSAaKleyOM8FF724A5H83mrz3BCGsj2Tmh10R8pT/iur3RiMeDGBOJKf
	yWqKoXVJjmGdNinT0Ce0luhxlcpHo14sdQOYWqgNPDIfzIiGf7ru09qyE8cmygtSHxJiz5/sjIF
	1mD3+y26Wyw==
X-Received: by 2002:a05:620a:f04:b0:93e:6f65:de63 with SMTP id af79cd13be357-944217bd696mr2734997985a.47.1793814042031;
        Wed, 04 Nov 2026 09:40:42 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7dfb3aadsm24214876d6.8.2026.11.04.09.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:40:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOeyX-0000000GzI9-0S67;
	Wed, 04 Nov 2026 13:40:41 -0400
Date: Wed, 4 Nov 2026 13:40:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: 0z5a <dezhen.lu@student.uni-tuebingen.de>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Message-ID: <20261104174041.GY3889730@ziepe.ca>
References: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
 <20261104100747.GD478286@unreal>
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
In-Reply-To: <20261104100747.GD478286@unreal>

On Wed, Nov 04, 2026 at 12:07:47PM +0200, Leon Romanovsky wrote:

> Isn't this fix enough?
> https://patch.msgid.link/r/1-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
> 15fe76e23615 ("RDMA/umem: Fix truncation for block sizes >= 4G")

No, the long AI generated commit message buried what the bug here is:

> > -static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
> > -					       unsigned long pgsz_bitmap)
> > +static unsigned long devx_umem_find_best_pgsize(struct ib_umem *umem,
> > +						unsigned long pgsz_bitmap)
> >  {

That 'int' is an integer truncation if the page size is > 4G. The
entire page size path from the core code has to be unsigned long if
the pgsz_bitmap is unsigned long.

Similar root cause of truncate, but different code.

Jason

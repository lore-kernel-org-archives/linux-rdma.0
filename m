Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894EB313273
	for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010604; cv=none; b=jDOVNWfFEDU8p1sOIltvNmyEtgBt4AFt0RWkiCSQk510XVWQKFwNjnkydK84xE4LfE2EHnewJvqjzDO8gtOZfPLfoZ1QfRfZzInfmb16PB/HyJL9nKTROSEzyOE6GETkhqcxLOGj4kx79GkmRzF5gXtaD4zg13gI/UG9qBQr0wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010604; c=relaxed/simple;
	bh=q7hXpke/3/yOS39pnZAAHMgYMjm6i7TC9CfciaL4A2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQROSWn8uq1PYHBagQ5cIPUueRf1hvB+I6EkrwBXXHs6RLNXkJOwgQTGHAYXVGDmDG74XCv5xzCC0MP7SfbakCFOhY66vYCi/gjnByLQE3i9quzXUvaQyTT3RVdZQMImz0IwkpSXCJYyjJPKIGLP2S5TOSa6f/KFEH3TnOOsIuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=UZIOstkP; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="UZIOstkP"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c537a42b53so993359885a.0
        for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 07:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769010601; x=1769615401; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7hXpke/3/yOS39pnZAAHMgYMjm6i7TC9CfciaL4A2Y=;
        b=UZIOstkPydJrsgD3IcwJy0K5b0HX/cogftTYVCT9yYnxEvRH6cXvIA3FGl2IdegZSR
         R20Aehqc9EEZjuT34Da9lgA5UsLPzmY1U+k1MeoihhCEQHnYi4aI/x+QB48Er6Hf3bIC
         1iGUXDtcfhHIS/NOdgW2mvk6t3sdX4yoQbjVZEaltQ3RGTfjl2Sx+mVjuwEtHaiWMRHH
         lrPdkfEH2kEZWLBzRyYi9iDhyjlHsSTX2xv84HaDfSUANyTQmMD8oH+rRYQiJKr+BtzF
         0DdPx9B7WR23DhSJGLwtsVwkf3oCFY+2WxGWG/DRLQIvjnF0eJhqMU4/EMzs/6pQm2Qi
         CMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769010601; x=1769615401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7hXpke/3/yOS39pnZAAHMgYMjm6i7TC9CfciaL4A2Y=;
        b=EpfzWZwJ96WRzAj0bNq+qGorTmluBuH30gyyP0Pl493DH/j8tvOkRSbFpvqy6aZa4s
         hKQUn7O25+vUiXlpguOwt8ELLiMGA1EFx0Lbo6PGs7nW9kCcYxwJLERU/PoYh3OH8B3H
         K2QQw5dNmtgnTW2mdB6PHYR5KaahcmoTtNw3d/v6vA1+LSFDOzs2bV/qvXr6qoFrtqiB
         QGE+CmUsEmDjTCQZ+L89t9XpnfUNmOYNgqwdaDxLid5uzcjV2o+2020VJMnGTQKcKr9Q
         zyhJ5jyHwRM7KrsLyWdT0syGMWh7JWElclG2wMk2kBxcbTQez18D4ISiGkLZ7XQKw9ac
         hz4g==
X-Forwarded-Encrypted: i=1; AJvYcCUz/Jr4T+Tcp2oRpwaUgQV2v98qSw1PBCua6+J8wj9+FFkLGjsuJLRq9HrQxdNasi4Y3pwSwrSikkq0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/WDOKZJwqx95vTrDaA9mjWOlpSyb1GkeO4DPSjfuuwPj5QjVG
	WtdKJ1W4jmxappJopkGM/+xQg9cnukE5mNz4YfuIh7IkTsIcZqEOx3u00RH0kF3cZqI=
X-Gm-Gg: AZuq6aJ87i6qhN3y3HhDMPfeCSK39e8wFZUZcyEDlmI8sPgHIgppLRuoeKjVCVGqoRm
	w/B2+asOs6EOtRmrFwIEAEOhL/q+58y0yzc/Kl0jvAdJFXwaSDOf5vByi6GWNKTPsclbfIYe76t
	5z8jAARyFqlRTDsx1I7EUr71UCA2Sy6Qei1dIpafssMGIs/swRK52Swue9wjwqfS5Med76a62tY
	8VdEKBFesNIX+Jz/uoTiZTi/0ZkHdi8gT/N9BE2K3d6AUC04e3OhDflP2eiyTuSdt/ldTtZAaDh
	KG897C9V/5DxchqpvdqQpNYFcEOJ5I//fbatlLWPs+CK6WvNy0PxSnLqarCjGfnTle5GiMdl/9A
	m0l0egkY3Cm/ZWK+oUz/LT/xwr9Z8hQVtCL+ucwQYquoxLj8nywC6utGZcKvb/qZziFpyz4qeeS
	M8WwV1NEYdjjiBlpfpl2NTeKjBDZgQP2UHzC5GMLFZInoTOqo4n1WISFaBu0PRfhFOQLwK1B29t
	PeJwA==
X-Received: by 2002:a05:620a:298a:b0:8b2:7290:27da with SMTP id af79cd13be357-8c6a68ec70emr2561552085a.12.1769010601362;
        Wed, 21 Jan 2026 07:50:01 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6a9d97sm127467116d6.34.2026.01.21.07.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:50:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viaT2-00000006Emy-0KMB;
	Wed, 21 Jan 2026 11:50:00 -0400
Date: Wed, 21 Jan 2026 11:50:00 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pranjal Shrivastava <praan@google.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] vfio: Validate dma-buf revocation semantics
Message-ID: <20260121155000.GE961572@ziepe.ca>
References: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
 <20260121-dmabuf-revoke-v4-8-d311cbc8633d@nvidia.com>
 <20260121134712.GZ961572@ziepe.ca>
 <aXDhJ89Yru577jeY@google.com>
 <20260121142528.GC13201@unreal>
 <aXDnAVzTuCSZHxgF@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXDnAVzTuCSZHxgF@google.com>

On Wed, Jan 21, 2026 at 02:47:29PM +0000, Pranjal Shrivastava wrote:
> But at the same time, I'd like to discuss if we should think about
> changing the dmabuf core, NULL op == success feels like relying on a bug

Agree, IMHO, it is surprising and counter intuitive in the kernel that
a NULL op means the feature is supported and default to success.

Jason

Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BAE44CACB
	for <linux-rdma@vger.kernel.org>; Tue, 20 Jan 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768933103; cv=none; b=Dc+UOaguZwUoZ7w+269+IIE4RjWNZR1jbK3AmiT0bn1JDZQDFB0KmoqgUUP3xrTAc9bFW5liIDBAsxcHsqtD3vqqQ8M41Ovhzztmd7g7KRZeMCQI4gjEDUWMUDzRmzyQ8ay0I4mud4Qx8nEawfcopnc99bnBdSxBedn/9Il5hjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768933103; c=relaxed/simple;
	bh=1L7c8BdoqxZUQDENcVXtZThUOiLDYDJQMPX7ZV7N9xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxOMBQ9ynuz/HpP3FFeHJyzsenscRILES/Or6CIKAXCf0oWKvEnJFj0pMkHDMh4rae0dwi81LVErVNtZnuvrwn0UZjP1DZbRQ+DqfI6Etv3/2wsSMWdAk8BthE+nWdgcrUdE5AN+osNQi9kLikxRXm4e6t6ii31tovGdM36195Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=avpr/md1; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="avpr/md1"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89469143ebcso5356516d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Jan 2026 10:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768933101; x=1769537901; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UjKhtF6uFrGGz9QpG86rUrUwPRn2VxIJfZmcip97T7s=;
        b=avpr/md1vuSh2XL2Y1i36eqW+S83q+obfD0emf4zuMUEOWTKUhGkHKL1kBuO/4AA4f
         W9QufuzqG/TYMXy3og4z2kGtwGKV6nxnJ599X4VsETaXHkxFuSyJeAJPy26BrRWxaYVH
         2XIWwSgQ7fawTZyHicTOzhS5EVRGiuoLmnZtDhzqtv8DWHSTgohszhgj4n1+u72Lh4lw
         McOIfV4bDsOfoP/QwKkT9K+9HEZb4y97ZRuhH17MhsjemlTigU+kSy0f7hP8/HTCALEV
         aFeOFilo/nvQBPaZQGrgLZ67PtGeO2rVh+hM9q1PGU4SW9YhZQR2tif19DBqz2VAN6Hb
         s+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768933101; x=1769537901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjKhtF6uFrGGz9QpG86rUrUwPRn2VxIJfZmcip97T7s=;
        b=jRV4fPq1osExGUNdE/beRRVNafjjEHn5Muz54uc8ClUiYXFEgWtM6RUVwvxBIcdDJA
         lzge9NQJxMK/t/YSOBHWvWKTKbVg2iVXhVT4oNRI/PffL9gsoHHT+xQ8NwgRP/3EOfyZ
         BY0N86/QTS4WrC92Bh1F+/+PLVTRMOcYQVm79NgSrGw6EX5MyZd9EotRJxN99Qx+C0N4
         vZkjUm5N0xej9oJDS9U+GNaTk263cv438MYR/3fSSbLE96+/x3Zo7IN6IaGFVjnhOQM6
         lj1ckSPpmRp04MyiWszobbSgkKw7yIYuUoKqSKqNu9xFRJaec2t77e4TsMwuLc9EBTj2
         Yzeg==
X-Forwarded-Encrypted: i=1; AJvYcCW/qs0k2Pk6GqyeJn8XRylK71ysSC7Unpryhk/3LrBMuvUugJhSFTajbVwHCs1pATCbvrT/36mIyEnv@vger.kernel.org
X-Gm-Message-State: AOJu0Yya5WHoM6t6rUtHz47bVU2YEF/ToweFr74lkvwK7mbzMuwEy+El
	Tb3KFXyu7MxP+Cz6E6DwjTXeoXMNZ5yz1+MmSOVhOb59evRcuMEdhxj6pMnVZkUGlLg=
X-Gm-Gg: AZuq6aKMdzSNqeP6bidti+NqVM5+xT471Pw5Fw0kpBPV2HQH1rV8SzbtHrHgPmK3Pjc
	TLpeJUl/2cAYgJRDtJ45CYcx485QCf75+bqfaV/RAfWNFSlc6Yb+D/1MX400pZmT8H036U65T+y
	GYYRgkJ+AyWqbxZudDQVPpPJ5zPBIZOr8N8CMKeY5fnnCJJoYQ89BIyO0DBniXG4TdM62bP8pHG
	RxDrdsEh+LexZ6p/8dTJKe8vN6rIlXiHMxtlDL0dm3T/sk83bGT3iDWTpllfFARQaVy1cwSWgpc
	xfVaUya6nyXgeLKxts1a4IEZEtR3F6cJNe+4GrUtFCXHzSn2N1fn1hnIHGzhhe80Sx2jWfiMe05
	n30euJfgWxJcoM9jb4lWx8TjlghzQgnyTAp0WDzcdkiVcCky1T5S15tT18s/esO2svk9Mv3n65+
	9RH650UHxF25HlH0nD83QlmHob0sCBOYWZb0m8mIf7wFc7/4sugRk50ghNgnRBL6MfVCM=
X-Received: by 2002:a05:6214:1301:b0:88e:6db7:f999 with SMTP id 6a1803df08f44-8942e0c342cmr235499176d6.6.1768933100910;
        Tue, 20 Jan 2026 10:18:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e5e535dsm114108506d6.4.2026.01.20.10.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 10:18:20 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viGJ1-00000005aZS-41Vi;
	Tue, 20 Jan 2026 14:18:19 -0400
Date: Tue, 20 Jan 2026 14:18:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Edward Srouji <edwards@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 2/2] RDMA/mlx5: Implement DMABUF export ops
Message-ID: <20260120181819.GT961572@ziepe.ca>
References: <20260108-dmabuf-export-v1-0-6d47d46580d3@nvidia.com>
 <20260108-dmabuf-export-v1-2-6d47d46580d3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-dmabuf-export-v1-2-6d47d46580d3@nvidia.com>

On Thu, Jan 08, 2026 at 01:11:15PM +0200, Edward Srouji wrote:
> +static int phys_addr_to_bar(struct pci_dev *pdev, phys_addr_t pa)
> +{
> +	resource_size_t start, end;
> +	int bar;
> +
> +	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
> +		/* Skip BARs not present or not memory-mapped */
> +		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
> +			continue;
> +
> +		start = pci_resource_start(pdev, bar);
> +		end = pci_resource_end(pdev, bar);
> +
> +		if (!start || !end)
> +			continue;
> +
> +		if (pa >= start && pa <= end)
> +			return bar;
> +	}

Don't we know which of the two BARs the mmap entry came from based on
its type? This seems like overkill..

Jason

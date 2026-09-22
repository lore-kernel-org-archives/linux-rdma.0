Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1554B1CB;
	Tue, 22 Sep 2026 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082835; cv=none; b=ZwHCuNAkReXq3VexfYmXpFHzxcD9sPC4yp4SxvtyV74Xs3Yq6EsSfM/bGFDuQvXD65xZ/7GXmDOm2gBC3Aga9XhjXKTCmtPxfLrXA8qAc2Hhh4BJaEQAo20k8MujDLGD0LV7M0bRfBZk+AXanXrFxWDfXEfMmYvYVtv9NBmq2J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082835; c=relaxed/simple;
	bh=eGeZAQPDXdolGYpsApnujjkkSWNew0KyXu9UdOni0Ec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GNX5m2DGkC5ulCTD0k19k4+VwkvwmCaoaOfG1oO9oqJJ87DZ0RGE0VYE1H418W3O2Lz1INVlROfWjnbj4+bf6fuo1pUN5kHvgz40qrZsUGUlvq5+cpe3Muy8D1qOyvSdIgGu1hrh+re+75qG/k5Gi9OdR2+lMDXI9QQRthF7gYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIgfkEkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIgfkEkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C6E1F0089C;
	Tue, 22 Sep 2026 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790082834;
	bh=lFpj+ISgjbQkMiUIYm/dxfsT2GFXZm5jRNEMsFvP8ls=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=CIgfkEkp4e6Q4pwHvOUvAYsO+M2TMBNFHX/wUk0U3/4z7MihqBoEuE6zqLEuSAYmr
	 CBPbiAywyKxcCLQqEY+Oa03Q61zmMQ+y3Qwwgg3PdrCnJXgOq7N8fWUdk7RLSQv1D9
	 ctp82eqH81bSc38dkv85d8cn3U5HhQg7kFscb1f7CtUc6KUYnyAB75dXfmiEWwNhrX
	 LLaj1oTwHG/f0Ik6Y5JSqljcMNuG9rOfntZv59uDN4oiROsQ59QB9l7KkgR5R7+zEU
	 5Ls6qoVNA9fmz8Bpsd43lv8bHUS5ufL7tNdTds+FPpwrigCrEdAKqX8+XtgU75FkLW
	 sr7l2supVe8aQ==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shiraz.saleem@intel.com>, 
 Mustafa Ismail <mustafa.ismail@intel.com>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Guangshuo Li <lgs201920130244@gmail.com>
Cc: stable@vger.kernel.org
In-Reply-To: <20260914122840.1709743-1-lgs201920130244@gmail.com>
References: <20260914122840.1709743-1-lgs201920130244@gmail.com>
Subject: Re: [PATCH] RDMA/irdma: avoid use-after-free in icrdma_remove
Message-Id: <179008283122.3238103.2042812322939438468.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 09:13:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 14 Sep 2026 20:28:40 +0800, Guangshuo Li wrote:
> icrdma_remove() dereferences iwdev after calling
> irdma_ib_unregister_device():
> 
>   irdma_ib_unregister_device(iwdev)
>     -> ib_unregister_device(&iwdev->ibdev)
>       -> __ib_unregister_device()
>         -> ib_dealloc_device()
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: avoid use-after-free in icrdma_remove
      https://git.kernel.org/rdma/rdma/c/8a8088b899e4cd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


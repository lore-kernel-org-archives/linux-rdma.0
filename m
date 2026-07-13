Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E5E43C05B;
	Mon, 13 Jul 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783954578; cv=none; b=cyeiV8YUQIiq/9W506nATZqsuEktxFbrgzJ4HuweLa9toPvRS6WuMpyj2k+4V67FKTDQPKVqwhJjh+JZiNE++5TSn/Dt0eGNIiLR93rE22FqL7x7IrXSzSTlzGx89s8HX6Q0+pCSX2/C4qdCzkwil+tAoedgX0i0Jyz3VJy81IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783954578; c=relaxed/simple;
	bh=qGoZMaIn5OxdmMzcf1HdJsWkQXyTpqf8ZMZPNeSMGBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2w343n7ai4DJzvwb1/S7MCg3jNAhx5W80Zy696CY06iIwku1YWyHC9Jh+duJ3jFJI5K4ce6KmGw5Ij78V7Q3W5U5mg6dIiKtoXbaluXKrNnxHmiUaZ3SDvs9Vyqa0vSyu2Rgv7ulpb70uDwkSPxPT+JsZVjufiKepYXlw/90tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/enGef0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/enGef0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583F61F000E9;
	Mon, 13 Jul 2026 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783954575;
	bh=4s99NOE2S8uWxsvjl5LeV+x8csV47mPIYwADaHJ87xY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/enGef0gqnHFA1vYJZybfhU6VQmvSVMq+px75XXIKcpjJNYb4vxrPpVkAXzVVHs3
	 mtsLq4o3rn1mM0719I4CIzULGgcGznCka5ab4TiuIaOavhwaITye3rYhJmxTBhPoMd
	 VQC2BmfRwObXtxcnl1DuyFTpwPqxhej/Vw+/J/KZFUN7wyxqBBFTjYVFzdRQj8LiiK
	 qGkKQmVhxWEXG6lIU4HFLwCCGxkxukRjmGWCppAGgYblsILAvIOgUCIeYPEu1K/aXO
	 IAf+K7UJCXNYBYMNIc8MTvy7zqgyslopP6tA9GdF2ybTMRWve7UK4ruDmyl4u30K7S
	 hZe2ixb7aTs6g==
Date: Mon, 13 Jul 2026 17:56:08 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/bnxt_re: Validate udata before
 destroying resources
Message-ID: <20260713145608.GO33197@unreal>
References: <20260713-fix-destroy-no-udata-v1-0-fcca2e34fd57@nvidia.com>
 <20260713-fix-destroy-no-udata-v1-1-fcca2e34fd57@nvidia.com>
 <CAHYDg1S5jpZY=CRmbcH8MYHzyV4ro4MdzJ2gAj2fhaFfQo-yXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYDg1S5jpZY=CRmbcH8MYHzyV4ro4MdzJ2gAj2fhaFfQo-yXA@mail.gmail.com>

On Mon, Jul 13, 2026 at 10:21:49AM -0400, Jacob Moroni wrote:
> These changes look good but there is also a call to ib_respond_empty_udata
> in bnxt_re_resize_cq (but that method does take input data).
> 
> Is that one a problem? I guess the resize could complete but the upper
> layers would think it failed if the ib_respond_empty_udata call fails?

I think that modify verbs should be fixed too.

> 
> Reviewed-by: Jacob Moroni <jmoroni@google.com>

Thanks

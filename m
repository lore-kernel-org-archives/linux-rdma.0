Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C54C2DF6E9;
	Tue, 10 Mar 2026 18:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167253; cv=none; b=D43G3AEtlabI3ZhO2mr0FqdoBmGWtWXvE29rUn8KbuuwznZ2zm4FxK1O3/+2P9Qklx73zgNWOB9gkbFdsc7fvzGEtzPkS7roGDPr95wxwO5linz6cDpI0c24XbRqLskbx8/6zItHHu6ViukRsdeEKy260JVGZ0i0kNSMx1kPa0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167253; c=relaxed/simple;
	bh=b24i4Z7BOygflKMZx7uFLoKgYs5ql97e8Cw/DSK5PpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuooqpI7lyfYXbmsYhBLqdxe9ueF6rPcUtT+4Oh3iyEVCpWdOWbFcug+q9pyskwN4namUBEwS2SkjG4uf3RyICZE40bn63QOkKWTdRjAqjadNjytZ4+0r6ovc5SeM5Tecknf0q6QDjFnMFt2XZ0hYgCGFlenHi5GciMh69HY0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjP9L89o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjP9L89o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE21C19423;
	Tue, 10 Mar 2026 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773167253;
	bh=b24i4Z7BOygflKMZx7uFLoKgYs5ql97e8Cw/DSK5PpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cjP9L89oo/rf1PhzqMFJD5061e4hV9ZaUTXw3ELzcaUq0DMluStl5wilTATAQ95Eg
	 ufLRCmEi0plTC30bei3B4LSeDZP5R0q2t2CGcOoAJNOpYCfVMFlU5guy4td5xVVgsT
	 5H4B3zZCjnTluzNPJs85YDXUsyLPM6876e381FFIxUOMvTpfyP897krPDo2KlCA2Z9
	 Vb4MHNCtsSiNdqrpXaPRUkFt7BLixAmFnD4D3P3hgXUe7rjHlk7vRAzOd+2c55Y/b4
	 soJZKZLhYz4g/Qm/kLxJOgpU4Q2Aux2zKSuYW2z7b5a9vCeol3wY5NiiT/Rt7+7qwy
	 n7CAxR2i1Oi/Q==
Date: Tue, 10 Mar 2026 20:27:29 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 2/3] dma-mapping: Clarify valid conditions for CPU cache
 line overlap
Message-ID: <20260310182729.GG12611@unreal>
References: <20260308181920.GH1687929@ziepe.ca>
 <20260308184902.GR12611@unreal>
 <20260308230916.GI1687929@ziepe.ca>
 <CGME20260309090352eucas1p283a75c78cac495b5ad87df74c79aab07@eucas1p2.samsung.com>
 <20260309090342.GS12611@unreal>
 <c1d058f3-f864-4ed7-9f7a-683d6f4bf1ce@samsung.com>
 <20260309150502.GX12611@unreal>
 <20260309151356.GN1687929@ziepe.ca>
 <aaebc5b6-2805-46d3-a68e-549c26a3ef03@samsung.com>
 <20260310123405.GR1687929@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310123405.GR1687929@ziepe.ca>

On Tue, Mar 10, 2026 at 09:34:05AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 10, 2026 at 10:45:38AM +0100, Marek Szyprowski wrote:
> > Jason is right. Indeed the rdma/uverbs case needs some extension to 
> > ensure that the coherent mapping is used, what is not possible now. This 
> > however doesn't mean that the DMA_ATTR_CPU_CACHE_OVERLAP is not needed 
> > for that use case too. I'm open to accept both. The only question I have 
> > is which name should we use? We already have DMA_ATTR_CPU_CACHE_CLEAN, 
> > while DMA_ATTR_CPU_CACHE_OVERLAP and 
> > DMA_ATTR_DEBUGGING_IGNORE_CACHELINES were proposed here. The last seems 
> > to be most descriptive.
> 
> If we do DMA_ATTR_REQUIRE_COHERENCE then I imagine it would internally
> also set DMA_ATTR_DEBUGGING_IGNORE_CACHELINES, but I'd prefer that
> detail not leak into the callers.

Yes, this is how I implemented in my v2, which I didn't send yet :).

Thanks

> 
> Jason

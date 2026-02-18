Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72C311971
	for <linux-rdma@vger.kernel.org>; Wed, 18 Feb 2026 09:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405512; cv=none; b=NF3ZzrQo0TOFzB95wdr+5e2/GsYR5N9bNNYBPDphXhw8jXcthcgZ8UsyBMsbQGKEo5SEym6JbXccuMT4c5p1bN3Fxp0WCv8cxokLIkADTpeNWDEQUuIX+0OBhoiY1R7Qsd1Tuum0Q0u9D3ua1V62jKWx09JNKt0fFBlTKNzjkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405512; c=relaxed/simple;
	bh=TWE+gh0wJp26sdLB1G9ggqkhChhN16VzPqNk+nALOzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pE3yPk5dT3b3pfcgFsLMOpKIIN54DKmz6Q7aR1fU78bClASmHp2K6IlXr18eLnvX0TjW9t5vSxig3ZJzMhVT69Jh20GCtLVBhnLj9eSav8vBx10iE8yAPRjNOWZmBl4/2vXZQcxa4OhZIDxJ2hfi0QT2dxGx5Vou+ztGhExmGHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgeLj3/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgeLj3/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0703DC2BCAF;
	Wed, 18 Feb 2026 09:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771405512;
	bh=TWE+gh0wJp26sdLB1G9ggqkhChhN16VzPqNk+nALOzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lgeLj3/s5+7lesut5qUY90SD8mrjW8IN202uZASzd4Cxg30CAmb4D4PTE+89ZCn4t
	 eM/x8d37YvfA8OTfes77wKUKQ8dxI9kuW09DMq0zc6bJGiODoVj2/y6Yg8gahi2Hd0
	 AGaymQmH21OvChmXkPJGRUYXEUTl2WbRP4UHjijkI6teJL9AfGXzg4UImn80K1YrkL
	 2mSxYUwZjWvqsqbL/zI6W5PsLVu/BCM/+IlWz4LQCVSuZffhoaifRN3zu4AwAs96AQ
	 fcpu8NgNMBE7gupvegWllCyPXQQ8wdHTsoWi8kxA7Wo9R56C50uxTcJN3bOzA3DfZ6
	 6zyhKXlKTYEyA==
Date: Wed, 18 Feb 2026 11:05:09 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>, tatyana.e.nikolova@intel.com,
	krzysztof.czurylo@intel.com, linux-rdma@vger.kernel.org
Subject: Re: [RFC] RDMA/irdma: Add support for revocable dmabuf import
Message-ID: <20260218090509.GD10368@unreal>
References: <20260217182116.1726438-1-jmoroni@google.com>
 <20260217184559.GP750753@ziepe.ca>
 <CAHYDg1QdYZjT81gB6geWKpeRR1TEPKnk9XD1eXcMriVAOHCo4w@mail.gmail.com>
 <20260217232158.GQ750753@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217232158.GQ750753@ziepe.ca>

On Tue, Feb 17, 2026 at 07:21:58PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 17, 2026 at 06:08:54PM -0500, Jacob Moroni wrote:
> > Hi,
> > 
> > Thanks for taking a look.

<...>

> > Should I create a new kernel device method for this? If so, then I wonder if
> > it makes sense to expose it as a generic "invalidate_mr" method and let
> > the drivers choose now to actually implement it (many can probably just
> > forward the call to their internal rereg_mr logic).
> 
> I have on and off thought about doing something like that with rereg
> mr as it would be more general, but I think for now just extending the
> ib_umem_dmabuf_get_pinned() is reasonable, and avoids the races.

I'm in the camp that, sooner or later, we will need a generic solution in
ib_core to handle this. More and more drivers now support dmabuf in RDMA,
and most of them lack ODP, so they will all need to implement
invalidate_mr at some point.

That said, starting with the simplest reasonable approach and refactoring
later sounds fine.

Thanks

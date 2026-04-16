Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7DA86331;
	Thu, 16 Apr 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351736; cv=none; b=A74JTDYcwxDxK2rQMA5YvIzB8AqJm309pgHDN1pREx5By5Jnu+v4w3gCZYU+5egStpgym9W9q8IyTTglDX4RKxwjlMmQ1aI2JcwlKNmYq26QvoxOi8/pendXcJvhEg8AmV7PK0lQwzw+PCaJ3yEilLRIAQeGbK6k0aMe4J+ksPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351736; c=relaxed/simple;
	bh=LajyyeXFg0XU7KHL5KLjvwU6v+hIuEgmiN/u26dKcZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoQV8vr66YIKI+k5gTw6VIySor1rhVPfOVxueEdadtj/bBwFnBXOlqPkCm5PTTaZTrZJz5UIKYSMMPFaZP1y5+kHckQ/+M5Q6h89oXAo20gtiydR7hGkIAwqskO7KGICq/SYxmluI505Ubmiw60xb0LHMMJtjHfOBhj3DVrcxe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhrioTF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhrioTF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1577C2BCAF;
	Thu, 16 Apr 2026 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776351736;
	bh=LajyyeXFg0XU7KHL5KLjvwU6v+hIuEgmiN/u26dKcZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qhrioTF/nUjIILQb/3ks6P0iT3MY7XHIdCg5esBsxcB9DKnAPPpVrJPlX3sD5gUKA
	 r1stjtKNE7NEaVw92sCphwGdE1kEG7RU6HK7IWwLM5zpB4cN/eOYx/YdtWIGkq+DEo
	 ZtiZ65/wa/OHPGfVLNyY7C+5m+2NXaWuTX0H2RJ3/ekra7k+OrgzmLOl5779IlP6P6
	 ZnDxgbM3U0VKyzMs22S510AJBtZCWhZCHl4u0YMfbUHaY1S3y79rWag7tfg8FhRb3O
	 n0wYxe3r1UIlVCveqjjNdOtww3HUnZl1OTfGgGINPFruG2qjku8oZkI7DSeq4m6RNk
	 +eOg0KAns6Trw==
Date: Thu, 16 Apr 2026 18:02:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Yochai Cohen <yochai@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC v2 1/2] vfio: add callback to get tph info for dmabuf
Message-ID: <20260416150211.GG361495@unreal>
References: <20260331083758.GA814676@unreal>
 <acvFV8c5QVxnt3Em@kbusch-mbp>
 <20260331132942.GC814676@unreal>
 <acvNsvS5ShlQlrox@kbusch-mbp>
 <20260331140309.GH814676@unreal>
 <acvWplw67b3Gwlkc@kbusch-mbp>
 <20260331190220.GI814676@unreal>
 <acwkAo2k41xaxdTS@kbusch-mbp>
 <20260409120415.GF86584@unreal>
 <ad56liSM4zI2SWWp@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad56liSM4zI2SWWp@kbusch-mbp>

On Tue, Apr 14, 2026 at 11:34:14AM -0600, Keith Busch wrote:
> On Thu, Apr 09, 2026 at 03:04:15PM +0300, Leon Romanovsky wrote:
> > Something like that, on top of this proposal:
> 
> ...
>   
> > +struct vfio_region_dma_tph {
> > +	u16 tag;
> > +	u8 ph;
> > +};
> > +
> >  struct vfio_region_dma_range {
> > -	__u64 offset;
> > -	__u64 length;
> > +	union {
> > +		__u64 offset;
> > +		struct vfio_region_dma_tph tph;
> > +	};
> > +	union {
> > +		__u64 length;
> > +		__u64 reserved;
> > +	};
> > +};
> > +
> > +enum {
> > +	VFIO_DMABUF_FLAG_TPH = 1 << 0,
> >  };
> 
> Okay, so you have the hints as a separate action from the dmabuf
> creation. 

I'm not sure I fully understood your point, but in my proposal the entire
operation is done in one pass, with the hints provided as the final entry in
the dma_range array.

Thanks

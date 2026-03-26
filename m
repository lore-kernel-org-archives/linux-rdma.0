Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF0D4AEE2;
	Thu, 26 Mar 2026 22:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564874; cv=none; b=f4QuN1YUM3g8/jr85AclOlk4dP0WfxyH40yo4n8sa4q2RvlxlOdTI937QWAMGQbXxUena+q4N56ASFYQCmDf88yVg3yMe3kjY74hEZze/hXYBPqfyg72T6ZfMGpsK4M6iCdY3ZNfZmBSbML3doB7i9Xe2ynbsBYu7n3b1d/PKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564874; c=relaxed/simple;
	bh=O9RE3qPQOrONRsorAVN2XwchrtUcoeQXGzvczDsoM0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7Ry6CFRQJntveQZQzi2R+H0Nn9uINJZPQEmxy3CXFsdLUQh4nbeDu8xXCeOODvRuOa/2dkz/olOrbl45+wIHupiLjd1/N59UeKZRpxbVHmn/KGfw8Qc+ddCKalckr0m/lVJx5Xvg5yH72SKrRNK/MtOcSiUOEOZTbga4sU0nwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsnTFjOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsnTFjOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F329C116C6;
	Thu, 26 Mar 2026 22:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774564873;
	bh=O9RE3qPQOrONRsorAVN2XwchrtUcoeQXGzvczDsoM0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsnTFjOZKBZWQ4+ymH6V5CbVtPOKgtB7APar8wQbMHAL324LaZ3YA1lEqUplGxxJM
	 7gowm/jZDTt4f9FAUW6Sei6Jhgt0w6JS9eeWENbE6MagiwxaAYVHC0tb/Z6vqwqwSw
	 zjuFISZZNCdmocM8GAFf1hQDyceBOcpfyTHl+zMcCmQNOiHamfaY0Q78xxZpPA5hn4
	 aiLf0dU4cUcJmDQ7Aa0y2Ho8lDqdhnV16Fk4Xb2dg9gInBLlHG60kzH3DVFNztBTte
	 zSlHh29e3e8PT/Nc7LWEzjm8oOGVmmTtEeGptW1/E5KVeXER+QTapM/Q/1Z2wScHex
	 nsy13cDBr1Vcg==
Date: Thu, 26 Mar 2026 16:41:11 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Yochai Cohen <yochai@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC v2 1/2] vfio: add callback to get tph info for dmabuf
Message-ID: <acW2BwQKaUbS3eL9@kbusch-mbp>
References: <20260324234615.3731237-1-zhipingz@meta.com>
 <20260324234615.3731237-2-zhipingz@meta.com>
 <20260325082534.GN814676@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325082534.GN814676@unreal>

On Wed, Mar 25, 2026 at 10:25:34AM +0200, Leon Romanovsky wrote:
> On Tue, Mar 24, 2026 at 04:46:02PM -0700, Zhiping Zhang wrote:
> >  struct vfio_device_feature_dma_buf {
> >  	__u32	region_index;
> >  	__u32	open_flags;
> > -	__u32   flags;
> > -	__u32   nr_ranges;
> > +	__u32	flags;
> > +#define VFIO_DMABUF_FL_TPH		(1U << 0) /* TPH info is present */
> > +#define VFIO_DMABUF_TPH_PH_SHIFT	1         /* bits 1-2: PH (2-bit) */
> > +#define VFIO_DMABUF_TPH_PH_MASK	0x6U
> > +#define VFIO_DMABUF_TPH_ST_SHIFT	16        /* bits 16-31: steering tag */
> > +#define VFIO_DMABUF_TPH_ST_MASK		0xffff0000U
> 
> This extension of flags is basically kills future extension of this
> struct for anything that includes TPH.
> 
> Add new
> enum vfio_device_feature_dma_buf_flags {
>     VFIO_DMABUF_FL_TPH  = 1 << 0
> }
> 
> > +	__u32	nr_ranges;
> 
> add your "__u16 steering_tag" and "__u8 ph" fields here.

You're suggesting that Ziping append the new fields to the end of this
struct? I don't think we can modify the layout of a uapi.

If we can't carve the space for this out of the existing unused flags
field, I think we'd have to introduce a new vfio device feature that
basically copies VFIO_DEVICE_FEATURE_DMA_BUF with the extra hints
fields.
 
> >  	struct vfio_region_dma_range dma_ranges[] __counted_by(nr_ranges);
> >  };

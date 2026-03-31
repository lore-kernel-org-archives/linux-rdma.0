Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56503845C2;
	Tue, 31 Mar 2026 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983747; cv=none; b=MEoXFUWyRio/VqCfkPkq88SpQqlIVufcfM00TFFxpGl6KuNB+ntdekGVstBW4xz2+VKaJLhXxyQZDWmi76WnDw/MoofmXWnoKMT0yKnyGKGGyyB0Xq4tulwJOvqukaOgXfFmw6U87KbOoljTmPAl5/LvYMulYyXGvNLrWxDiOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983747; c=relaxed/simple;
	bh=R94WVshWogD2v4hXHETq37YTuAedBBrvIpKh2CGxklY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6ch8u+sTA29x35rkToEdeneffvUmW6+9pqYHcThOrHodWiy8X6eU58IilvH+4wvj21lvSUhoPVSY/QobyN5xhSNDZcpQ2HawsFHXgnajEmrkakkMPHampBTxSPo8c9ygXoHEZixbtgaVmSOzApssRbkC7lh9yluHKiEHgbAhMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HotHbz1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HotHbz1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A1DC19423;
	Tue, 31 Mar 2026 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774983747;
	bh=R94WVshWogD2v4hXHETq37YTuAedBBrvIpKh2CGxklY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HotHbz1VpN+dUNKQYC7KDVOBp2EtyGMtsxbWiR4UaZdlPXa08F1P+GYNo8X0Y+PPq
	 ISowxrEU6fREnIPbKnvZjP5om8QNQpMUADWipKo8TsAkRHMai/75MFcTYP1JCN89Mg
	 NQVZTkO4VWfilvnfBAUIrauuZXubwNw17NP+GPHrPQAn3FUu4mFiDyR228UirXOhJl
	 0NY7OWzfD+3DlAUcC8ASJuQIbvKNwv2nDDIJ3cCJDhWH0ROsKcnLwAsyiUv9FPNqrU
	 yhNr8p3UYkImGirMJoJkt6oDzxbkZNOXiJ3PM7DYGtmpdUZfeXb71HdYdNrN1RMutv
	 OggMmxcQa/t9w==
Date: Tue, 31 Mar 2026 22:02:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Yochai Cohen <yochai@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC v2 1/2] vfio: add callback to get tph info for dmabuf
Message-ID: <20260331190220.GI814676@unreal>
References: <20260324234615.3731237-1-zhipingz@meta.com>
 <20260324234615.3731237-2-zhipingz@meta.com>
 <20260325082534.GN814676@unreal>
 <acW2BwQKaUbS3eL9@kbusch-mbp>
 <20260331083758.GA814676@unreal>
 <acvFV8c5QVxnt3Em@kbusch-mbp>
 <20260331132942.GC814676@unreal>
 <acvNsvS5ShlQlrox@kbusch-mbp>
 <20260331140309.GH814676@unreal>
 <acvWplw67b3Gwlkc@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acvWplw67b3Gwlkc@kbusch-mbp>

On Tue, Mar 31, 2026 at 08:13:58AM -0600, Keith Busch wrote:
> On Tue, Mar 31, 2026 at 05:03:09PM +0300, Leon Romanovsky wrote:
> > I understand, my proposal is always set TPH flag when new struct is
> > used.
> 
> An existing application recompiled against the new kernel api implicitly
> uses the new struct layout without setting the TPH flag, so kernel and
> application are out of sync on where dma_ranges exists with your
> proposal.

Right, what about adding TPH fields to struct vfio_region_dma_range
instead of struct vfio_device_feature_dma_buf?

Thanks

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB983EDAB9;
	Tue, 14 Apr 2026 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188057; cv=none; b=jDegAtmp/LJulswY6PnNhKBDl38VHpNdRcG28v9CnvV/6L3Wr0fHuprDQCLb3OgxurVPQPbLF+pEpz5gtWmcmK25tERtb+LDg6L2Er0LxJ/QrOX0el0oaCanWS6u60eAbliNcaZf/pF/jTzcP5DT1wFEeTnVJd288rz2WZzoICQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188057; c=relaxed/simple;
	bh=bIYKUg6KM4B2jwA0U61DhG5RQJNqCIi7oMSl3PzaDqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFpiBDfLsCb3rBUnF907grRlYT2b9pLznXQ6DOM1uGzOTniUoru0ZsRr4f+h3R9TusWStaBgjtKPUNyB4pLAUb6btm+GIeeHXoCZfDUwqgSxJvlO10EKJE4vr/LFkWUjVCDlV5TnfvRdFvtJedIGOHlUdoee4pV3e3SCbqHtes4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d99lLNat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d99lLNat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408C2C19425;
	Tue, 14 Apr 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776188056;
	bh=bIYKUg6KM4B2jwA0U61DhG5RQJNqCIi7oMSl3PzaDqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d99lLNat3zpmep1gV8Utf8/s8GvEKvRmD1JIrFdWoUlLy+SRr72tOv+ONZzBcdwo2
	 r3Y0+CBIA+/SOEpyQpdl7GLlSx7LuWs5ZrQP+QQ8VKMTuH6vXmN1GrqawyyBSsqgli
	 /iKWZbo+UQuapoELb+8sOji5Ed9TICOV+vYgyZTcEOrHXMPfTSyYZzIMbcTRsog6r0
	 GRE1DrcqxyTnIUJp4SvqHFMGm7urtEDKS3rkC9h2uAJ5jdSvH2sB7m9sHQVUODrgyo
	 QQqvlg8HhNaHUC93ntQl2YvEzHhBhBUr4DncCpFiGi8lKA3FrU19LKznpoZKvxwIAq
	 wQqZxnWE/Xt7A==
Date: Tue, 14 Apr 2026 11:34:14 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Yochai Cohen <yochai@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC v2 1/2] vfio: add callback to get tph info for dmabuf
Message-ID: <ad56liSM4zI2SWWp@kbusch-mbp>
References: <acW2BwQKaUbS3eL9@kbusch-mbp>
 <20260331083758.GA814676@unreal>
 <acvFV8c5QVxnt3Em@kbusch-mbp>
 <20260331132942.GC814676@unreal>
 <acvNsvS5ShlQlrox@kbusch-mbp>
 <20260331140309.GH814676@unreal>
 <acvWplw67b3Gwlkc@kbusch-mbp>
 <20260331190220.GI814676@unreal>
 <acwkAo2k41xaxdTS@kbusch-mbp>
 <20260409120415.GF86584@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409120415.GF86584@unreal>

On Thu, Apr 09, 2026 at 03:04:15PM +0300, Leon Romanovsky wrote:
> Something like that, on top of this proposal:

...
  
> +struct vfio_region_dma_tph {
> +	u16 tag;
> +	u8 ph;
> +};
> +
>  struct vfio_region_dma_range {
> -	__u64 offset;
> -	__u64 length;
> +	union {
> +		__u64 offset;
> +		struct vfio_region_dma_tph tph;
> +	};
> +	union {
> +		__u64 length;
> +		__u64 reserved;
> +	};
> +};
> +
> +enum {
> +	VFIO_DMABUF_FLAG_TPH = 1 << 0,
>  };

Okay, so you have the hints as a separate action from the dmabuf
creation. I was trying to set it up in one shot, but this proposal may
be fine. We'll try this idea out internally.

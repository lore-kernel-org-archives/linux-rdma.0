Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C83EBF09
	for <linux-rdma@vger.kernel.org>; Tue,  3 Feb 2026 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770112778; cv=none; b=FJlfJHCkX4SWrp9CDBGgC0LODQFCMZa0LQuesUeqyfCc8CVG2WSo/pA+380OpO+We4e804t3rvd0WpzKP/GrSofXniLuRZA57grfOtomWqOxYZnOJX8KyTHioBzDOquGMKa/UL8uADsXLR8ARg+b747CAKg5rhLf3C7iRlkoZEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770112778; c=relaxed/simple;
	bh=nVzvzVb5INAj9HvAaGcMvESN5BPoDYsRZkHxfiat1Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npAurlT662N+opq53k2a37v7jCS1Vq2Z7cYc5Qwk4KTPoR8JL9MSt9AVB6327TCk+TsIv0J9Y6ELa3LpdZsdq0vMMGKmtsnO0KkmwiZs2lRTY2PKJu0hpNW0ii4huNOBl8CB+vSTjetCpKhUSMchRgFRCNbaurPBfWm3d3hGKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCCYem3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCCYem3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D90EC116D0;
	Tue,  3 Feb 2026 09:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770112778;
	bh=nVzvzVb5INAj9HvAaGcMvESN5BPoDYsRZkHxfiat1Qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eCCYem3KhOuly2anx9Js7W2ySideF2NUarDNIXovudcFSiddvW/bxoQcB2F/qcNw+
	 MdU6OnazWFNLPaLtbwDBA7gu+w0jD2JUYqdNeInYi5yRUjfocIzFuGMdFPIXVyTjZK
	 Tswl2DRv5IeMXUGHG1Re7V8BFzTScYy/ohputOyt/+kC2m4t2/0uqEJrarqJy2zrJl
	 oiO7PvVdxFFIgVaRhKFTAZB+6gftrpmYa17t8Hy+p/bHhD8kGvgpzibZx+5OkmjYtc
	 tRcMd/svAKRNM8/xH+wl4aQV5HMfey5e5sGowOcI+PA8MJFzoA4UaL3ylo5uk6a7ay
	 qCCRd3969XttQ==
Date: Tue, 3 Feb 2026 11:59:33 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, mrgolin@amazon.com,
	gal.pressman@linux.dev, sleybo@amazon.com, parav@nvidia.com,
	mbloch@nvidia.com, yanjun.zhu@linux.dev, wangliang74@huawei.com,
	marco.crivellari@suse.com, roman.gushchin@linux.dev,
	phaddad@nvidia.com, lirongqing@baidu.com, ynachum@amazon.com,
	huangjunxian6@hisilicon.com, kalesh-anakkur.purayil@broadcom.com,
	ohartoov@nvidia.com, michaelgur@nvidia.com, shayd@nvidia.com,
	edwards@nvidia.com, sriharsha.basavapatna@broadcom.com,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next 00/10] RDMA: Extend uverbs umem support for QP
 buffers and doorbell records
Message-ID: <20260203095933.GR34749@unreal>
References: <20260203085003.71184-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260203085003.71184-1-jiri@resnulli.us>

On Tue, Feb 03, 2026 at 09:49:52AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset extends the existing CQ umem buffer infrastructure to QP
> creation and adds doorbell record (DBR) umem support for both CQ and QP.
> 
> The kernel already supports CQ creation with externally provided umem
> buffers. This patchset:
> 
> 1. Adds umem reference counting to simplify memory lifecycle management.
> 2. Adds mlx5 driver implementation for the existing CQ buffer umem support.
> 3. Extends QP creation to support external SQ/RQ buffer umems.
> 4. Adds doorbell record umem support for both CQ and QP.
> 5. Implements all extensions in mlx5 driver.
> 
> This enables integration with dmabuf exporters for specialized memory
> types, such as GPU memory for GPU-direct RDMA scenarios.

What do you mean by that?

Are you referring to the RDMA dma‑buf exporter from Yishai?  
The GPU dma‑buf exporters already work correctly with the existing  
RDMA importer.

Thanks

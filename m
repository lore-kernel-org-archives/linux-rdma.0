Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708648;
	b=eYJAXjy+7It39IW1PjyAWSJm2OOaKxE035Ws3l/ADG8GclPH/lXDYGHH0lkGxzZLrN1z
	 4H9eoPjvoYRDbR51zwKmSvILZvqE+c+8PVgoIEBb72qXuLMJMi4Zrb1tacemIibNXVeTE
	 rbwcc3Z647vSx39YyQZC9B2D2uJnNtuzTOClp4IU8lrWvTdKFOuvCsdY32FtitDJ7yJYb
	 UOI1iyCL3BZ4nkvETSOZ38S6gvLW3RA7rTjTF/fzvL8orG8f0u2Yv+sX5kRVxGXljKV8o
	 ATAzIYTtDSXn1khp9UYGUjtrUYvRZ/bkuHY4Q5P9HlH3HuuR1Q3Xfh8YQ73VFDZSdZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708648;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NDsaDuGZJ9RQNeUECfjLdCTdePLMWGh907kWO55BkB4=;
	b=VLnmrAVPE/CM46KHWjxgAQ1YaDEJRHGEUFQIrMP0JG2sg1M9FXaTv4oPLrww/msKZu8b
	 0sOQwI+IGU8K67eecTJfR5Dp078EeLbmObUy+A06Vqsz7AoRHVhkVUt77w43dkKyb6qV7
	 WiIt5SDDCgmTTSR3pUEPsnhgJ62c+HVgQ/P27M7BJCkqdTs53PIlOAyC1emE/jVBtjaFM
	 25eUjluXIwaUb7cIdL4CyeOaUD0cGgmL9uE9j2+hzT7yG/iJNkXMTEwuL9DVc0vVJy6BY
	 83o7tfmss3gELb3Vsf9A8biqnwDnNRqTySQdlbx+jaJ4k3z60WVEznxqNL/7jl0GmeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLdt7y30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14065606A31C;
	Thu, 26 Nov 2026 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLdt7y30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3F61F000C0;
	Thu, 26 Nov 2026 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795708647;
	bh=NDsaDuGZJ9RQNeUECfjLdCTdePLMWGh907kWO55BkB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kLdt7y30dHOfy7ZXbY0y2c4lrT7u5ZtAWJUKsFFD5Wcm2noeNgdUDM+b7eW8itB/H
	 APiRYlN+Wfn5x4/6nG7KQFohCqmav7BDTzpURlVvIDiO8SDECJ/kNtdk+PslxxL4fh
	 13SDN4VeMRwXZD2VXQJhWW/Ir2NgC2g733xRfOq92KTUCYQvh75ITT5DwkVHpf4NQk
	 pDhPTYvMd2dh8K6Y0QKnnd90Bor1DX0/LcGw65bYSF1160YFCjR2VLS2kcM9gM7+7o
	 jQUVPnTF3TdX017iTgdKnsh5lwXBTwdF4XP0Z1C5/3xy+UylTKF+eEAhK+lxBvcN0X
	 FZzZdDlJ0jmpg==
Date: Thu, 26 Nov 2026 17:57:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261126155723.GT774860@unreal>
References: <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
 <e8eaaaa7-545e-4019-9d7f-d2aab00c3217@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8eaaaa7-545e-4019-9d7f-d2aab00c3217@nvidia.com>

On Wed, Nov 25, 2026 at 01:41:50PM +0200, Yishai Hadas wrote:
> On 25/11/2026 11:03, Leon Romanovsky wrote:
> > On Tue, Nov 24, 2026 at 10:30:24AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 24, 2026 at 04:09:06PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
> > > > > On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:

<...>

> Would the below commit message make it clearer ?
> 
> RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> 
> In adversarial mode the NIC is not trusted. The kernel protects itself,
> but user space has to protect its own memory as well, since rdma-core
> parses HW-written data, such as CQEs, directly. Hardened user space
> might use a different data path with extra checks, so it has to know
> when a device is in adversarial mode.
> 
> An rdma-core without this support uses that data without validating
> it, so on a device in adversarial mode the process runs without
> protection from the NIC, a silent mismatch. Such versions are already
> released and can't detect this, so fail GET_CONTEXT in the kernel to
> turn the mismatch into a visible error.

This part is fine for the rdma-core-to-kernel direction. You should also
explain why the kernel-to-rdma-core direction is important.

The main reason is that rdma-core wants to move away from sysfs files.
They are unreliable in RDMA containers, are prone to races with device
renaming, and provide no generic way to locate the trust-level sysfs file
for an IB device. That file is buried under the device's PCI directory.

Thanks

> 
> The kernel reports adversarial mode in the GET_CONTEXT core_support,
> and user space declares its support with a new optional GET_CONTEXT
> flag. In adversarial mode, a GET_CONTEXT without that flag fails. In
> generic mode, nothing changes for older user space.
> 
> Yishai
> 
> 

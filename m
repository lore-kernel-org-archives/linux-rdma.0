Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9DF45C6E3;
	Sun, 18 Oct 2026 13:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792328711; cv=none; b=aPaGph1yLSind3y7qpFIwPOXYPfpZqQXNjo3Uk8FL/V5rIsj2Dud3ShUcZWuyLopp8ke5xWEo+hFYuG8Ke+7DeyLyyPfpStkwrBDW3PT9Qsr6n1+w3t0G8kKoo4TFd0Qx9pr4kjLGH6VafksuFFs2fXujsh5a2fy/vDHGmFYTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792328711; c=relaxed/simple;
	bh=sENGOwAJCqT6NkjdKCKPlLQOBHkFOdI43uFiD73smrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkrievx3915Lbncfh1MsrbT4RNtjU8B9z8Jl5ES652ygts8Iy3XsTPqXh7NxcnFE3dAC8BNjiOMkLkbCSkxO5+MQF+lkU5l3mLp3os0Fv/Sy4eRg4I9wOQrLEJ4sd/5SVRNE9hj1i6ffAvKfyP1G2Av5xV1u3FmSdchrTGHPkqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9EWGus4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9EWGus4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC61F000C5;
	Sun, 18 Oct 2026 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792328710;
	bh=Sh8/PhhU0vlFc74QUMVLaV0stOvHDT3eeZpHAy0z+xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S9EWGus4XCSTRp/H7+iwIEmfDVoc1sf6TiXJ3rlb4tLvBYvTpvW5jsHoa++FerNIt
	 3l6Z3EioI2SwmSBf2rUJ5mDg4knUEhx9cUp6a3T5bhMYDgaZfjEIGj/EoMlfua9fB3
	 bMEBGSVfdFMqCnk3Ih7njJH2Y9EOXU+HnWUlU9Qn94m//RKAw/zygC1sGa4R32nzKK
	 SkojK3RYu8Aso6wO101z4lPUUuYi3dcRpv8cvqluBKPo7tAs+5w43+wl1TYN8KxBzw
	 aupuGFtXG8pXVV5+oX+qhqBl5k+zD5AW8PcfVvbfQCKXAvBPJiUEK4VQgW5kEUKEVD
	 YFfeExXTBjgQw==
Date: Sun, 18 Oct 2026 16:05:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com,
	jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v5 00/10] RDMA/mana_ib: Add kernel RC and fast
 registration support
Message-ID: <20261018130506.GF64621@unreal>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017064413.995985-1-kotaranov@linux.microsoft.com>

On Fri, Oct 16, 2026 at 11:44:03PM -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Add kernel RC QPs and fast-registration MRs to the MANA RDMA driver
> for kernel consumers such as NVMe/RDMA and NFS/RDMA.
> 
> Implement QP creation and state management, work request posting,
> completion processing, error handling, and queue draining. Kernel RC
> QPs require extended-WQE and power-of-two-SQ hardware support.
> 
> Tested with krping, NVMe/RDMA, and NFS/RDMA, including RC send and
> receive error recovery with krping and NVMe/RDMA.

I want to set expectations. This series has Sashiko comments, but you
haven't responded to the previous comments, leaving us unsure whether
they are valid or have been addressed in subsequent revisions. In
addition, the series is too large to be considered for this cycle.

Therefore, it will not be considered for this cycle.

Thanks

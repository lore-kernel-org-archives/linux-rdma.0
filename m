Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFA838E5EF;
	Wed, 23 Sep 2026 08:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152382; cv=none; b=IFkuXFPemATS5igkpilEp/R5wrpF2mspGWVnFa76zvvvKAbKGdCwDCm5xHuNqIUI63S6363z0aC8zXf9WmaKfAE+bsk6WYPefwKZLHVSRFEzKzi4Rp3K+i494LicVahJG8R4bXX4VYUknp59O/KMb2muZ6oX2xG2bXasidDBjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152382; c=relaxed/simple;
	bh=pXwR0LARPvXUNmDW1xtJBvb5PUaMj1aERqFVze2EoDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O50CQPcKijfVhYYCh4tEfH4Hh1nEE3Tmj6zH9QtlYN/iORAcoRRzRrsaoxe6UdfbzVdmCbFAVm8vWQyH3p/XRh4Uh2ahCovpDDN027OVOggolEEd7Skbcb00y9d70fIX842IJJlbnIaDhCgDfdeIVseEzmvbb/wKUdLe9m82g3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=as+t+uBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="as+t+uBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B28D1F000FF;
	Wed, 23 Sep 2026 08:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152380;
	bh=CgUhTaaxn3U0Lt1WL8BFQpEGdIbTobyUrE2TJ71SNjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=as+t+uBdFKSw9wxXfIP7L8LSpX04VY1UHIC0L8Q5Rw0vs0LFpXqlVpm3k3yash/Mv
	 x12tmwdsnEOzQT1rmxOIlMMtKL1bTBbgPuFxXPsQiNDvPfofYpDET1Yz393bkVQQcU
	 B6cTyWsmHUv6PXhAsUf8/wOyAu5kPa/qu2BRm30bJD+7GMTR87a3s3nH05SFW749rS
	 5LPGf5E3UlvwGv1ffal7jjeNOw/PiGfVsL4LrAsuuW522TFOwn+4LxGlsGSJpUDY7d
	 bSy5AoqER6l66wLsUvvjYTuGeuMgetcMLiTv7lycEV4LibR03qCbGv6TihjmqADzHu
	 jhi5wMprGfITA==
Date: Wed, 23 Sep 2026 11:32:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: dsahern@kernel.org, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/nldev: Fix ib_device reference leak in
 nldev_dellink()
Message-ID: <20260923083256.GM563127@unreal>
References: <20260916183101.2092246-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916183101.2092246-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 06:31:01PM +0000, Wentao Liang wrote:
> nldev_dellink() takes a reference on the ib_device with
> ib_device_get_by_index().  When the driver's dellink callback fails,
> the function returns the error directly without dropping that
> reference, leaking it.  Call ib_device_put() on the dellink error
> path before returning, matching the handling of the other error
> exits in this function.
> 
> Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/core/nldev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

It was already fixed, https://patch.msgid.link/20260903082550.2257-1-lirongqing@baidu.com

Thanks

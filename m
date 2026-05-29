Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020392DF717;
	Fri, 29 May 2026 20:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780086693; cv=none; b=IFMTILIW7jyyfad3KTOhzGXmujRnWXe7FVOVIru4J3WbLUraYVZaOE7FEvyQtEx5wMCClhrvMCCI35BDcgnhFFlE9N/AgAr8YAT33tYv8KH+R/j79C6nbWmKbDyrKtvpClWHx6rbfeePuLJQ7denR7mXaQUdiR8mCkbncr8xJ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780086693; c=relaxed/simple;
	bh=uajjuqb/XF50ia154Qjr+gRVrNC1XNs9EZvGuMYP1rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEtIRC5Rij1X4ZgZ5OmR4D4W5c4DUq8e71QBadW1NmCFERMSacfCHG3DCCnGig7BV6oLn79owbitY9SxPhNu6Hh0MqPcY4vJ7dn0Yj5JXKJdwZWNhW/koPzQ6XbI0JAcc7lFIfShRFA0USYAoorpQ4z/0EK7+deYscY+/5dC/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F152Qvw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F152Qvw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0DD1F00893;
	Fri, 29 May 2026 20:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780086692;
	bh=DZuhqXRZ7B73ropw+7ipWGbAJYsiDVXSY0jkt4goiLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F152Qvw6yKoLFyZh9kVnYLSDLYITRbxREEo+3G+y61xFLW8Vh2JRdVJ4dy9+uKN0t
	 4F9yskFnkeUwrPTubsw44PP3e7bsixkmtdMFhW+UsOjhATizHGcLDtjQO6x0GqpmD9
	 d5Je41Pw76d7wxiSYhgV/1UOx+Ifmv7QUFE79BdEjBYMBtKoK2Ae7N7cFboY1J3hF5
	 DR3eKcr6eIypH23s/My2lx2HSeSzEjfKyarJygx7JftCrwgrlCFzh5Db8wKhw7JY43
	 muaNntq3czmhow09X/r2E7jwChAscPvpZPMauDxURhCeIOIZCQ3xY7/btpjzz4POHe
	 +N3Gd4X9w/J+g==
Date: Fri, 29 May 2026 14:31:30 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Bjorn Helgaas <helgaas@kernel.org>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Yochai Cohen <yochai@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>
Subject: Re: [PATCH v5 0/4] vfio/dma-buf: add TPH support for peer-to-peer
 access
Message-ID: <ahn3ovmkEq-Y-LKt@kbusch-mbp>
References: <20260526144401.1485788-1-zhipingz@meta.com>
 <a8cd01ab-d7aa-465d-bfa3-431f78f33ee1@amd.com>
 <20260527121438.GJ2487554@ziepe.ca>
 <ff247643-73e7-44e2-b3d5-8ac0a8efb871@amd.com>
 <20260527123634.GK2487554@ziepe.ca>
 <a5ff1930-e9fb-43f5-82ab-9875d7a28421@amd.com>
 <CAH3zFs2KALuHXReLZG_uoqvBBWvBzU6rHKakmt6HBV7PZEsD=w@mail.gmail.com>
 <71302a7a-6b9f-40da-af81-b1862dbd637a@amd.com>
 <CAH3zFs036sr93duQKx613pCyOYw4t0_x_TdSza1xBCaEmqijyA@mail.gmail.com>
 <8d9bb0b7-182d-4930-b683-d5d24da6b2ab@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d9bb0b7-182d-4930-b683-d5d24da6b2ab@amd.com>

On Fri, May 29, 2026 at 09:36:00AM +0200, Christian König wrote:
> On 5/29/26 08:34, Zhiping Zhang wrote:
> ...
> > There's no in-tree vendor PF driver
> 
> Well I have to admit it's a bit on the edge but this sentence is a show stopper.
> 
> DMA-buf is an in kernel interface for buffer sharing between drivers and any change to it needs an in kernel driver as justification for the added complexity.
> 
> > - the device is a Meta MTIA
> > accelerator managed entirely from userspace via VFIO passthrough.
> 
> When you have a complete open source driver stack which utilizes VFIO passthrough as the interface to communicate with the kernel drivers then we can eventually talk about that.
> 
> But as far as I can see without upstreaming or at least open sourcing the full stack to utilize this functionality it's a clear NAK to upstreaming this.

But the existing dmabuf for vfio-pci was accepted upstream without these
requirements. I see you had concerns about even that, but still Acked
under the same model that's propsed in this series:

  https://lore.kernel.org/linux-pci/57b8876f-1399-4e4d-a44b-1177787aa17d@amd.com/

So with vfio-pci and mlx5 both in-tree dmabuf users, implementing and
consuming the callback, does this not satisfy the requirement? The
userspace-driven semantics are inherent to VFIO's design. I don't see
what additional value open sourcing the user-side provides for the
kernel-side review process.

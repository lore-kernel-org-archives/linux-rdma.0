Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A432D0DD;
	Wed, 18 Feb 2026 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771404861; cv=none; b=Fwws6HsLHhVCjzu9wxaYQgJ1sMHjkBLVY5pkfahcf9ahlZCKu/saC7Yo4f7kW0Im8qenlWUKJwX9NkXFWjTrPHQd5uCKHia4owd23sBJyhRHrxIyDoIrb4Nd9wVHYvamjFFaNJce5hz0pqpaOPG7eRY9GpivaeeTudbmOZWV0No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771404861; c=relaxed/simple;
	bh=c6kyjTN08CGLmgUPWzMU7Y0uAbmelFRNXoqWtG0drVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6zfpAZsQ54cCy8FsOsL9olOK8+TJaZErLJe8dcJ0FsTs9EYqglmTcEFKeZEeGXjmVhQgpN56nDVc3NEi1Yna5gEnCHYbZ6Io0epLm7f5CUcPguWYGQw1hkiq63VtmxU9K44UpH30Eih9K/VJPHY4/MJJLuwdKJImXQMUmIs/3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtMYlV+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtMYlV+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74864C19421;
	Wed, 18 Feb 2026 08:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771404861;
	bh=c6kyjTN08CGLmgUPWzMU7Y0uAbmelFRNXoqWtG0drVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtMYlV+06QRZg4oc8GiTs+PAxi6fgLCX0n4Mk4JblFbWazpGb4LrvHEVajzQZVs35
	 9iROox/VFWMRhLyf7QXt/v0DdSokw74WnH8c3fcv2+wWrpVvslA/dZrERvQjW8BtQW
	 0i9XdLKd9P5/Pp6piBcboieX3/QUjhISYuqQC0i7u17W8n3bNbJQJFLrg5tlqzbCvI
	 364cVIXSkBrMHtOfPS5ob6AnJAtawS/JoLqCdmiKJ4SWb+Lkzx3CgFM95pA+tQSjtJ
	 LhOYgx2GHwjcTbg2Qk6TlVHuKP2JpYUGH5N+Pybovnm7iH3fcK+LDjwUjRiREEBWbR
	 gqk16mT9s9aNA==
Date: Wed, 18 Feb 2026 10:54:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Heiner Kallweit <hkall@kernel.org>
Cc: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	driver-core@lists.linux.dev,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org
Subject: Re: [PATCH RFC 01/10] IB/core: Prepare for immutable device groups
Message-ID: <20260218085417.GC10368@unreal>
References: <5d0951ec-42c9-453f-9966-ecca593c4153@kernel.org>
 <0f7f4ffa-1465-4c54-8d3d-e9b551136669@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f7f4ffa-1465-4c54-8d3d-e9b551136669@kernel.org>

On Tue, Feb 17, 2026 at 11:25:20PM +0100, Heiner Kallweit wrote:
> This prepares for making struct device member groups a constant array.
> No functional change intended.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/infiniband/core/device.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>

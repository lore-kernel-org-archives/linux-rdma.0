Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095D298CAF
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791725296; cv=none; b=ruFgZTcbPTtLzoobTo59GNCdoOEbn3Wlr2ncpRXjNL8+m5ZXwGgoM3VhrMVUb0Y+JiVM13nd5Sg6duoLdJp8l+ExYH4XjqUQ/bF1047+suX8Ic+OUUeQ+JwW80sLCItI48AcaobDuKdybmyBtHlcEnujxG9/XiYgS8rWFmEbkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791725296; c=relaxed/simple;
	bh=nlaL8FdcWvuRbcdj/4SiWgiaUgVt9qQihO64oW0Mi5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edJLMgP0l5hy2nxQ1D6Vy7Z+e2IofIjX+Uyyvi+HZS3il0YE/jWgcRCEvIJ+YqOsGdmbI7eP8xTmulstWOA1vEBUs/xs4FBY9TfmtLoHzM0XsvjHU/sPdkIQ6RF0wqoJBybF5BYJhMyOO1KP3+jdZ6P9v263wnJT1BeNuFO7Wu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edK90Ost; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edK90Ost"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A1C1F0089B;
	Sun, 11 Oct 2026 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791725295;
	bh=OvRMSZygGKtmtgsmxGPP5+Lft50z8l7l7YxAjw3XvNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=edK90Ost/IAR6ElOA7BerYhmUggyFBcKH0ZvPZSsh8bEmrZBWIJbXkSXPvkyc9ejz
	 /aEnF48uOEfarMrG0L9N35F9SHVIjPqJvaFkSAQQ+1/GZK6IwL/WFRekq62NsPRWJc
	 GpT3rvxfsHA7oVDZH7zmUnJZmVO0wURs1MuzHEmlAMixk3b2Q4G57YJQBrz1AZJhXs
	 9mCBcZmVd/v7/74OjYZwvBZxwzTC+DL6ClhifgoFwLN+Xwp58NtrHUQDk0QW9q3ZtU
	 fUsNK1R5TPEmmTZDuNABLYE2NuvJl9i1+yRt8Byz9GtOhwthIVmQUan1rZpp6frT08
	 no2j2GwTSR4FA==
Date: Sun, 11 Oct 2026 16:28:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yonatan Nachum <ynachum@amazon.com>,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20261011132810.GD27033@unreal>
References: <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
 <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261001155333.GP3401365@unreal>
 <20261002145241.GV1616761@nvidia.com>
 <20261007090136.GA35552@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007090136.GA35552@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Wed, Oct 07, 2026 at 09:01:36AM +0000, Michael Margolin wrote:
> On Fri, Oct 02, 2026 at 11:52:41AM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 01, 2026 at 06:53:33PM +0300, Leon Romanovsky wrote:
> > 
> > > > Looked at Leon's patches and it does seem like the right place to expose
> > > > such peer relations. Although it wouldn't help with our immediate need,
> > > > maybe we can add a sysfs interface on top of Leon's patches to expose
> > > > the gathered accessiblity (and maybe also performance) information.
> > > > 
> > > > Leon, what is your opinion on this?
> > > 
> > > ACPI tables are available here /sys/firmware/acpi/tables/, this will
> > > include our new p2p HMAT extension.
> 
> I was iterating over Jason's idea and what I imagine is an interface
> that contains already parsed data at PCI level, like:
> 
> /sys/firmware/acpi/p2p/
> ├── 0000:55:00.0/          # RDMA NIC
> │   ├── 0000:59:00.0/      # → GPU (reachable peer)
> │   │   ├── latency_ns     # 200
> │   │   └── bandwidth_mbs  # 32000
> │   └── 0000:5a:00.0/      # → GPU (reachable peer)
> │       ├── latency_ns     # 200
> │       └── bandwidth_mbs  # 32000
> │
> ├── 0000:59:00.0/          # GPU
> │   ├── 0000:55:00.0/      # → RDMA NIC (reachable peer)
> │   │   ├── latency_ns     # 200
> │   │   └── bandwidth_mbs  # 32000
> │   └── 0000:56:00.0/      # → RDMA NIC (reachable peer)
> │       ├── latency_ns     # 200
> │       └── bandwidth_mbs  # 32000
> │
> ├── 0000:9a:00.0/          # NVMe
> │   └── 0000:55:00.0/      # → RDMA NIC (reachable peer)
> │       ├── latency_ns     # 300
> │       └── bandwidth_mbs  # 12000

I'm afraid that writing and maintaining an in-kernel parser that creates a matrix of
non-racy symlinks to point to right PCI BDF will be quite painful.

Thanks

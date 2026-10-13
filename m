Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5909B51A146;
	Tue, 13 Oct 2026 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902063; cv=none; b=TJPXxJ7XwDzvTeqJI9lp+Sn3gUT85rLT2RX3gcQN0307UPhG7nwTyqGNwLjJpovlwjeGvzGHY4Tcu9V69wNIkkJTU8wCUEFJtANCRSW1WB0HX127t2vvmBgNpA5OuDswr6STouytyRp5XwmX1Xi+y/uQA6RVOjm9rP6sYHEfHwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902063; c=relaxed/simple;
	bh=i53K0/1SOVLhTLhnyR7/ilAXq+E4gtgZ+9cYGwWxBVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pffv0pmSzVd6M5cHAJ58gcWJoBJXI2fzTYr4rP4moSekdqke7XLX7vtysN4GVCjuYYjyT3n57RzDfiMVrmJA+yZvHyHL7vz0vlnV5a//FPxwxCWArwqzi/QG6AZoS/m4XjgxaAgmmXC8LWqJdtZEevMN9ux1vYXCEoPWGviaBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n57SlWiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n57SlWiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C061F000FF;
	Tue, 13 Oct 2026 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902062;
	bh=1zOnfp9HNirUDJFRMRkDAVaVZEbxoqoxJIUg5YMw7NM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n57SlWiS/EXKI/p/mDB7E3vUbc+f5RxFCYZJ/yEW4Nqc8LzaO4pgobliXP0FMc+UG
	 TUgAACXAeGcVMSwmjVjQ5DEwvv95oYHtPqHfqgPboFpqdVzihKY+FXi4aRFKMKO9JN
	 ALdOhp38gRtAdyLyqwowBYsWeWuO/PTVqRQzXNi4jghPtH8h2iSY3uQ2Q52vUjdYf9
	 Wa52uqqDwh7xepPWavP4xvonN36gwbC8QXyqZpZGj0xV/5QAqMlMXN8Jg+mIPUu7y9
	 SVGI0cPUeVyaPNqhhZ+wr8KgljVE7lObkUF7KvJzX4CA6ZMB3iuEgCa0WSu3mt0vTP
	 OM7favi+RXccA==
Date: Tue, 13 Oct 2026 17:34:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Xin Tian <tianx@yunsilicon.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, weihg@yunsilicon.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 00/15] Yunsilicon ethernet and RDMA drivers
Message-ID: <20261013143417.GQ219304@unreal>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>

On Mon, Oct 12, 2026 at 07:44:32PM +0800, Xin Tian wrote:
> Hi all,
> 
> This is a new submission from Yunsilicon to upstream our converged
> network adapter driver.  The hardware is a dual-function PCIe device
> (PCI vendor 0x1f67) that supports both ethernet and RDMA operations.
> 
> The series adds three drivers, which share the xsc prefix.  A shared PCI
> core driver binds to the physical function, brings up the command queue,
> the event queues and the interrupt handling, and publishes one auxiliary
> device per function.  The ethernet and RDMA drivers bind to that
> auxiliary device instead of driving the PCI function themselves, so the
> two personalities share a single probe and resource set.
> 
>   1. xsc_pci - the PCI core driver (CONFIG_YUNSILICON_XSC_PCI).
>      Owns the PCI function, the command queue, the event queues, the
>      interrupt vectors, the register access layer and the CQ/QP/SRQ
>      resource pools.  Patches 01-05.
> 
>   2. xsc_eth - the ethernet driver (CONFIG_YUNSILICON_XSC_ETH).
>      Registers the netdev, implements the TX/RX packet paths with NAPI
>      and page_pool, RSS, checksum offloads and statistics.  Patches
>      06-08, on top of the core.
> 
>   3. xsc_ib - the RDMA driver (CONFIG_INFINIBAND_XSC).
>      Registers the ib_device and provides the PD/MR, CQ/SRQ/AH and QP
>      verbs including the send/receive data paths, plus RDMA counters and
>      sysfs attributes.  Patches 09-14, on top of the core and the
>      ethernet driver (the netdev supplies port state and GID).
> 
> Patch 15 adds the MAINTAINERS entry.
> 
> The series is split so that every commit builds: the core patches
> introduce the register access, the command queue, the event queues and
> the resource pools incrementally, and the ethernet and RDMA patches only
> start creating queues once their dependencies are in place.  Patch 05
> (core CQ/QP pools) is deliberately shared by both upper drivers; that is
> why it precedes the ethernet patches.
> 
> The RDMA device is registered at patch 09, before all verbs exist, so
> kverbs_provider stays false until the mandatory verbs appear in patches
> 10-13.  This keeps each intermediate tree compilable.
> 
> Please review.

Please run Sashiko locally first.

Before we begin an active review of a new driver, we expect it to have
only a small number of Sashiko findings.

Thanks

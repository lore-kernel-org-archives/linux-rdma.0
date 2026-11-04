Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786068;
	b=zUmthn4QBZGWYl7vo8Rf5dn/VDLfuZbrtvzXQdp2clQd6YsgJY+mthjSvZePggafhyST
	 f4vRBkWzdj3sRlAn9SWwbkIEPTPsY1j0HNkBcAYag7VTUaUNUekH+nb8e7ynpmv4j4PRn
	 EGnHpjLyHDNWf606Pwnl0NAD4K7gSfKpFwQ3QmA8U4MKijCJh1UWABOvab1cIAsXbH+i0
	 VmCjxHOx/KXwHgOUxKY8J2fBZ/c6554c/Jixn3aVWowAbPb+QVbrLnMtNxq5ZaIi7pKuS
	 s+jdwKsFQgfJiuEV9ydBuqbydz5CY2v1iFRQTQbCeSvc6gqTPGJ3Y85ENPXbiU4wLAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786068;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=UujO1dehyrQlC7jK+eEtk1MAPSYkYaYdKMh0bnJv77E=;
	b=wuo2VoS/UVe5xOT/cgQWaPhP5ZX76AnKOsl4cZNaxgwN1vR+xK84+0ASOfLy4r49J+jQ
	 PvLLpnMYfPVQrn7KTQ1DQDdLEqscdl2Sg6oB83ZDW+8XWslsJ66Qh7iyfzqcpZh9qcQf1
	 ZHCtrRY1quUymUpWZT48JZch4yAi+IjA4WFpxTf8XsbvBR8xN/IRP6QeSRR4BXvTL4hF5
	 lBHlp+om4cS5kM1Dkk8yZVS+8s7wX1BE1ax8kJzB/C+jy0ZU6LftNnMoVDPOCfJLMdyXS
	 Tnl9+oaVB8/BGIk8YnHkaSsZVhK+MljTIOjWgh/y2DZ3kGusujASIGFYQKJVgzFBl/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U73OeWfY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244C8606A31B;
	Wed,  4 Nov 2026 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U73OeWfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FDA1F000C1;
	Wed,  4 Nov 2026 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786067;
	bh=UujO1dehyrQlC7jK+eEtk1MAPSYkYaYdKMh0bnJv77E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U73OeWfY2Kz7OJYEknsAwqkM8Lylw1SMu3ly2K1TjmTkwkIzk9+b4o4iCF4yTsaIr
	 Ld18JDKF/js9QMB6DV7fsk09G5YkTkoE3s7Ywee9EtH5VM4qtSqtv+U64vF2sAOWfo
	 8DupwOnIV/8TX+58LWAB9oHWyrcAsZDAIf9+TfCCaCkccWHlxgrvv1ZwJTmeC5NAHW
	 wzE5B+yu5TEmAJOEE32njxrAbnKOQUiSq6mrATes7+33iPNNctDQaciJw4jc57vbZe
	 jHj2OPWjcru/Uyo7GEFdUsJhBSxJwl1m7DXm47Ozu8cCOdWlwvoIOvlMoicHpiq0VW
	 GYtQG4ULk5PKQ==
Date: Wed, 4 Nov 2026 11:54:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <doug.ledford@hpe.com>,
	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Iraimani P <iraimani.pavadai@hpe.com>,
	Mamila Santosh <santosh-kumar.mamila@hpe.com>
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
Message-ID: <20261104095424.GC478286@unreal>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal>
 <20261103143004.GJ3889730@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103143004.GJ3889730@ziepe.ca>

On Tue, Nov 03, 2026 at 10:30:04AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 03, 2026 at 04:28:26PM +0200, Leon Romanovsky wrote:
> > On Fri, Oct 30, 2026 at 09:35:28PM -0700, Doug Ledford wrote:
> > > This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cassini
> > > NIC. It exposes the NIC through the verbs API using the UET reliable
> > > unconnected (RU) queue pair type from the UET RDMA core series.
> > > 
> > > cxiverbs does not drive the hardware itself. It is an auxiliary bus
> > > client of the cxi-ss1 Cassini core driver and does everything through
> > > that driver's exported CXI interface.
> > 
> > <...>
> > 
> > > Before posting, the series was reviewed with the Sashiko AI code
> > > review tool and checkpatch. All valid findings are fixed, except the
> > > open items listed above.
> > 
> > <...>
> > 
> > > ---
> > > base-commit: 306a2f8432f516069b2e673de7a07043132c034f
> > 
> > Sashiko failed to apply this series as this base-commit doesn't exist.
> > ➜  kernel git:(wip/leon-for-rc) git show 306a2f8432f516069b2e673de7a07043132c034f
> > fatal: bad object 306a2f8432f516069b2e673de7a07043132c034f
> > 
> > https://sashiko.dev/#/patchset/20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com
> > 
> > Please make sure that upstream sashiko runs on it too.
> 
> I don't think he can, it relies on the core code series. I Don't know
> how to instruct sashiko how to find another series to stich it
> together

This may be a radical, unheard-of suggestion, but how about merging another
series before sending follow-ups?

Thanks

> 
> Jason

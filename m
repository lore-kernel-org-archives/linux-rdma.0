Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EC24A0EF6;
	Tue,  6 Oct 2026 19:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791314998; cv=none; b=IlCU1etm2m2cLROZbRMSc3z7dzSdxF+QIBP9GvrVcnzUxWl/7WwAUY2v3lqg0FmXDxAEViE3NSjSSh/1eX9/KzFN+AxbEjt74pOcLbLUkD8L6esxJAONSbgfmXxBJuAkQ52O1aS65DyMZ0VXjkQwmdQs9cvgWQ89sQetjyLtV+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791314998; c=relaxed/simple;
	bh=3tAzhzFSkj3K+S01ftkQWvUsVPs0Vx/11VP42amP9qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AYHMyxdGQbrginFhAQQN0HuyqBw9wLf3eDGB51lHYrKE2lMSGZ8Rpo6bGRYO0P/sNz50lNurfBEPOzO3UuyRZxOdEX8rJ11GGoHDCuGX8pWlwSzdWivyrV8QZFQ4FKYasFNjZsAJA/heT4KimuyOxGJiyoAn0sHzxzpvFUJU8rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcJS+scZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcJS+scZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231CB1F0089B;
	Tue,  6 Oct 2026 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791314997;
	bh=E3R9izeh7FIJECvgCCVpi1mo2nxrzOBff+skIfgO+Rs=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=bcJS+scZy/6Ervd4affik0znYY7JZa8yo9ks/hJ/Wi8kEV6e/KSbN6DLhH4cvTpEi
	 iv1i3WiOGk68dleHJ296gqU0BhMCEJVAVOZytyc3QKyrYEr2/tnG/0UFyIPfrIj3tg
	 SItyEr00wVeaV0//cgD/K4SQvOZOLnemHSI1OJAFgTEBCV+hiT1KtsppspX2evocA7
	 ZCQ0Wl20EzvOsu1/yNFVx6Xg4cGeVs0hzCrznBNfgOi0wFN/Avs81GC98fmWJ7AFoR
	 B0uvsH9pjMZFUorJQnadwi8SHKWnKBdfcOjggeubITjVyfME5vEDwO1ixmFyhMjfNP
	 GU6veX6QcYM6Q==
Date: Tue, 6 Oct 2026 14:29:55 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v9 00/18] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261006192955.GA703309@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:08PM +0300, Leon Romanovsky wrote:
> PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> This misclassifies asymmetric and nested switches, and reports one answer
> for every kind of TLP.
> 
> Three ACS controls act on TLP attributes the client chooses rather than
> on the topology: Translation Blocking and Direct Translated P2P act on
> a Request's Address Type, and Completion Redirect skips Completions carrying
> Relaxed Ordering.
> 
> Evaluate each direction at the path divergence, decide every class from the
> one walk, and treat a client with ATS enabled as translating unless its
> driver declares per-mapping ATS.
> 
> This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> ...

> Leon Romanovsky (18):
>       PCI/P2PDMA: Document the TLP attribute assumptions
>       PCI/P2PDMA: Derive routing from directional ACS controls
>       PCI: Reject unreadable ACS controls in isolation checks
>       PCI/P2PDMA: Evaluate ACS controls at the path divergence
>       PCI/P2PDMA: Document directional ACS routing
>       PCI/P2PDMA: Collect the path's ACS controls before deciding
>       PCI/P2PDMA: Answer routing per TLP class
>       PCI/P2PDMA: Route Relaxed Ordering Completions directly
>       PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
>       PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
>       PCI/P2PDMA: Log detailed ACS routing diagnostics
>       PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
>       PCI/P2PDMA: Test the ACS P2P routing walk
>       PCI: Add KUnit coverage for ACS isolation checks
>       PCI/P2PDMA: Document TLP-class routing
>       PCI/P2PDMA: Let a client declare that it selects ATS per mapping
>       PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
>       PCI/P2PDMA: Test the routing of clients with ATS enabled
> 
>  Documentation/admin-guide/kernel-parameters.txt |  15 +-
>  Documentation/driver-api/pci/p2pdma.rst         |  80 +++
>  drivers/pci/Kconfig                             |  15 +
>  drivers/pci/Makefile                            |   1 +
>  drivers/pci/p2pdma.c                            | 719 ++++++++++++++++++--
>  drivers/pci/pci.c                               |   7 +-
>  drivers/pci/pci.h                               |  58 ++
>  drivers/pci/pci_acs_test.c                      | 860 ++++++++++++++++++++++++
>  drivers/pci/quirks.c                            |   6 +-
>  include/linux/pci-p2pdma.h                      |  12 +-
>  10 files changed, 1687 insertions(+), 86 deletions(-)
> ---
> base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
> change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261
> prerequisite-message-id: <20260830-batch-p2p-fixes-v1-0-5044e8dfbe2e@nvidia.com>
> prerequisite-patch-id: 6b25c7fcf164cdfc14e9fac5b908d97fcf6509d7
> prerequisite-patch-id: 0d083c281001365aae4b35544cf28891a6ab9a96
> prerequisite-patch-id: bfd9dabf271f3cc9a3a61f46387d20c20311363d
> prerequisite-patch-id: fad0275efc722830fc591509506c0a5e4f581073
> prerequisite-patch-id: 0c83bee688fec1f6d1564654df7c630fa6a4a978

This seems like material for the PCI tree, but I'm not sure how to
apply it.  It doesn't apply cleanly on the current pci/p2pdma
(https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/log/?h=p2pdma),
which does contain your series from
20260830-batch-p2p-fixes-v1-0-5044e8dfbe2e@nvidia.com.

I could probably fix the conflicts but I don't know why there should
be conflicts, since the only commits on pci/p2pdma other than yours
are a few trivial allow-list updates.

Bjorn

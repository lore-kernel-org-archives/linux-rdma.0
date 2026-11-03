Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793749064;
	b=r/rQhe0JfnAm8CO8dkb63y+Eqqnt/9W1EajzMGaUJg4psFKTNhM3G6xTHYnhS5vAwDR6
	 lieIoiFd/cor4HFBcy/JWr7sU43AwtsCtTz6iR3APh8Rcx42cyXjwkuKN1lHdlUQyYekx
	 70b3Yw+Ppif6X4cMEze4TEKA/9/L+bq79CY6Mm54Z6XZ1XxH3a3DQXvVfxofroChlc2V6
	 /ixQJyvPXhK33RgmUnBJ0OuiD4moHt2gSVDHqPrbaXmvmeuF4TZEl1YkaOKfL51ZCet87
	 cdfk0x3BSrdcl8LSUTVXpTtfOnjNjqUswVDaVRtQSTr5vcEkRue5bVm6cLct+WgwgYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793749064;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4wfqiCZwxR1HfUPAhThr9gcJLD7YNx6kTBnqWyt9+bI=;
	b=njvtOnwKJMW3FN6E5VQCdBguP09Ds5pf9MJKCtR9pJ0zGAyCuxqqdUOWV7AMIln08NMF
	 UJGW2oP5jvEROg6J/XLt0muBhBopftNVP8rdOa97GTyO7WzaYagYKvuXRi/F//7UQ6w88
	 pPCrMUlIEz6L8fM2NRPFm2loz87MBSNXswdnlmbvRF9OVqgoo2DqXIlmLNhL6s2hNDFEQ
	 7MjdcE5yv/8ZqjWREXJLXK7jAdIveMBuafqu6yQ8mtiwREX2AY1HluswfrzeoPIpEBEG9
	 Z8Ib6qJgHqwzRL5hh1FjKKIa2G1+KoReQfqdc+NUQ4FTL27qD+FJ5MJ40AAWbcq7GaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OF6RH6Xa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC412606A31B;
	Tue,  3 Nov 2026 23:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OF6RH6Xa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB01F000C1;
	Tue,  3 Nov 2026 23:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793749063;
	bh=4wfqiCZwxR1HfUPAhThr9gcJLD7YNx6kTBnqWyt9+bI=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=OF6RH6XajejLEaRO0+BM9d4/sTm6iiR9bIeg3XYuSSa2A+LO5xgR2HmpjIEdeX6fW
	 z3bMl5cSQIuuqrSouIOdJl+uCkv3nwz/KMTQPQT2lUg+vSbaQPIJ/CvQ83rOichkfM
	 FwPnVMVNVwXi/9aVHMXY+pwwAcjESqhFUUmYjYdkPZbGWAntl3YDAvxuii2TG2PTMW
	 +/GU17Tr0k9A7KTV7Q9vDfe/2OquHv4t5UckT5Psg3Q5BV26x76amGq8GcXRaGtN6Z
	 3SmkHQLYucXN4npjf7JIu12aZwxaQ+1PB+0lCVi6LmUqhF5VtFlf2/NaOLxuO/uUMD
	 9QxoYKERoXfwg==
Date: Tue, 3 Nov 2026 17:37:42 -0600
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
Subject: Re: [PATCH v12 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261103233742.GA1162403@bhelgaas>
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
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>

On Tue, Nov 03, 2026 at 10:29:39AM +0200, Leon Romanovsky wrote:
> PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> This misclassifies asymmetric and nested switches, and reports one answer
> for every kind of TLP.
> 
> Three ACS controls act on TLP attributes the Requester chooses rather
> than on the topology: Translation Blocking and Direct Translated P2P act on
> a Request's Address Type, and Completion Redirect skips Completions carrying
> Relaxed Ordering.
> 
> Evaluate each direction at the path divergence, decide every class from the
> one walk, and treat a client with ATS enabled as translating unless its
> driver declares per-mapping ATS.
> 
> This completes the P2PDMA side; dma-buf and mlx5 follow separately.

Is there a one- or two-sentence explainer of why we want this?  I'm
thinking in terms of what Linus will want in the merge request: a fix
for something that's broken or some new functionality.  It sounds like
this is solving a problem, but I don't know enough to translate the
nitty-gritty details to the higher-level user-visible problem or
feature.

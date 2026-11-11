Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436898;
	b=hF52i5wjXcBo09JVWFfhQtqiDCoFyFIYh69J42MuJR/CLhfO7aYkoxvq20w2VwoYZ7JL
	 3aU0mfmxwTIaOVS2Ki7AYY7GhqWV0RP3Fuz0dj0cB548MnIR6kVIkf1GA6ydPS9yE4ENE
	 xDMnxaQ6j+pTr/qvl4DDTQz1J/Mk/603j7hxD5fBEiBnQCAMAhnFx9WEBVJHU4PXorE21
	 8EebjiSbL066WY+GcfPEdW7CEus2yNU0LCskwuoSSGMTd9Zkabaug3/G7+TQY0CRdxF44
	 8BbQUXDxeVr1rNZF7PpzMUiWrXnecfhVvxGDwHGio7lmVSOS12+gcGtPrptEIIEWB8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436898;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=artujVBtkITv0xul/f4LcgQN/4n5We9dzsh5W3Leptw=;
	b=RbbJnpEEENc8N9IYCYDH5ubFc67SbNDnYOEfIPWkXpR1vhusiZpGG/+/o0XtA3dudz1e
	 Q2JCxG64eiFTuyhlEnHQ6ZqVLvmMeWZOo2m1b4J38alWUOepApnoogiAEqcX/gNQzVlcz
	 hXu+JQ9vdXfJmEuF/TfGPfs6gh5a846AGKviYZ8+6xe9h+HsiOW+AfZws05HoSv3/TGXc
	 8mft6dZbys8or2Dt93VlYzQOp1sf8Riliv3mk1zJpalo7F3sao7weJN/Ab7LR8bEv6dWS
	 vxSIPaZdzZdDAV1CEMge2frl9ODan28mqiNjm4pl4IiVbjpUEf86ZRBLKBYcXj27dRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZELOpHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66808606A33D;
	Wed, 11 Nov 2026 22:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZELOpHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6CA1F00A0A;
	Wed, 11 Nov 2026 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794436898;
	bh=artujVBtkITv0xul/f4LcgQN/4n5We9dzsh5W3Leptw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=BZELOpHA05LqzQ806/IA3hS/mble4JA4SMN5wo/zZjQaqIWC0OCBlMBDK2sQhvV+n
	 dkA7m+l9XAXrrJ1vyvuvsCgDJ/n1YkeFfGi5ibtx5yBDc6YnZBeNneFpO6Am8qxS2m
	 UQulPJ79zSsWSZr4aSoYUBmRPIIEF3JPNSnHPhViMlkc4d6j2fkLwElxe1ezZ5JGwy
	 ku4SNNqQ4WTMY6p5pFj0Wv+mM+gzbo/k3+40qdSCIAMGoySt1wld4Bdz7vIeKjrwhD
	 1EbT+YjayK34qLqRx9lukCB8yqmedx6P8IsSOoZXBBKuYH/g2B+tmEv2oTzfBfytUd
	 /bFe8kKnUK0Vg==
Date: Wed, 11 Nov 2026 16:41:36 -0600
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
Subject: Re: [PATCH v13 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261111224136.GA754433@bhelgaas>
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
In-Reply-To: <20261111121602.GQ8635@unreal>

On Wed, Nov 11, 2026 at 02:16:02PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 12:04:31PM +0200, Leon Romanovsky wrote:
> > Punch line for Linus from Jason:
> > "Enhance detecting if the PCI fabric can support a peer to peer path
> > by evaluating the full bi-directional fabric path over each of the
> > three traffic type ACS controls. Expand the number of fabric
> > configurations where the P2P algorithm makes the correct determination
> > of support to include non-uniform ACS and situations where translated
> > takes different routes from untranslated."
> 
> Bjorn,
> 
> Just a friendly reminder.

Thanks for the reminder.  I put this on pci/p2pdma for build testing
(no issues expected; I always try to get build testing before merging
into linux-next).

I'm still struggling to describe this in a way that connects to the
code changes and is accessible to non-experts, so please correct
things I get wrong here.

I had the impression that this series helps VMs by making P2PDMA work
with passthrough devices in cases where it currently doesn't, but
maybe that's not the case; I don't see any mention of that in the
series.

IIUC the P2PDMA core doesn't actually *control* any TLP routing, i.e.,
it doesn't change any ACS controls or change any TLP attributes that
affect how TLPs are routed, so to me, these subject lines suggest more
than is actually happening:

  Route Relaxed Ordering Completions directly
  Reject Translated Requests blocked by Translation Blocking
  Route Translated Requests under Direct Translated P2P

It seems like we're just *learning* whether RO Completions will be
routed directly, whether Translated Requests will be rejected, etc?

I think the core basically looks at the ACS controls on the path
between two devices and decides whether:

  (a) the devices can do P2P DMA directly (PCI_P2PDMA_MAP_BUS_ADDR),

  (b) they can do P2P DMA but only through host bridges on the
  allowlist (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE),

  (c) no P2P DMA is possible (PCI_P2PDMA_MAP_NOT_SUPPORTED),

  (d) PCI_P2PDMA_MAP_NONE -- I don't understand this one; the comment
  says "not a P2PDMA transfer", and pci_p2pdma_state() returns it when
  the page is not a p2pdma_page, I guess because
  pci_p2pdma_add_resource() has not set MEMORY_DEVICE_PCI_P2PDMA?
  Not sure how this is used.

I guess one benefit of this series is that a path where P2P Completion
Redirect is set used to mean that pci_p2pdma_map_type() would return
PCI_P2PDMA_MAP_NOT_SUPPORTED (unless the RC was allow-listed), and now
it might return PCI_P2PDMA_MAP_BUS_ADDR because if P2P Request
Redirect is clear, Requests can be routed directly?

That sounds great as long as the Request uses Relaxed Ordering, so the
Completion won't be affected by P2P Completion Redirect.  But devices
aren't *required* to use RO even if enabled, and I'm doubtful that a
non-RO Completion redirected to the RC is going to work.  So I don't
understand how p2pdma.c can guarantee safety.

Translated Requests seems similar -- are we assuming that if ACS
Direct Translated P2P is set and ATS Enable is set, the device
*always* generates Translated Requests?

Bjorn

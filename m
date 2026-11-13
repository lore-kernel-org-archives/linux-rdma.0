Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599978;
	b=QQeZDwEPdc5KuMB6Q69//ClNkExNonnj/7IfUr/7jWSBS8KrVNNjjrX2GR6WTDZ7pXb1
	 sG9ACM8G8b7euzv6GjEGWAa7GS5Ghtd69uixRd+Fk7GxYlh2f8qWjiQHqoMr+06jXPt7g
	 jAEEARFxSYM3OEy90p0ClLqtWGeZhguKzANIgFJj8mcIDTugBrMFKaJ1k25PHZsHNDsHo
	 uTx0KCF4LQsEasmjgDiPWFtRH3P5KZgH6kbLkTYsH1XIAl6vBKTssCDcSRaPcxoNoI/VZ
	 ni58MFoWZcNgY7bTJXiwc4R4te+J/GoKxwPNQrD68cnHWpUQ1625lpenseRW+pJBSNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ZZ2nZZ3s6y7qol6GLZvqI4xyT/lOQ3RMsv1KGP5S3jA=;
	b=yPShKmLap3cO5HmEFHDvpYZoaqNU0t7N7Q32wrh+CUnK57pdp50RWD5Nx7dnM7L+odQC
	 R22xiS0YJucZpVGyj3JS//u8+2ts721ri+CiT6gLjLgp4YGQVVhRHe+KikjGCXhGpmyUY
	 jsslaKB2Go7qIl85kyt9FBV/dRLNTOMWRS/WdwLPJLGlrW9BMmF1Y4UW03l38bYSHbUm7
	 HLI5/hXEKYNtQy9cB6JPPT//HBm8dloOPTHk7iIOhWLj36Typ+tScgrdA2ZkaHEuhT1Ir
	 Ons8NaCN990D5UwfqCm/vGjgN5FvvaqrZ5Q/dhyKhGAmoEz7OVI1L/Pv8CNg4oUlcOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Po3n9AZ5;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B52606B540
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 19:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07B52606B540
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Po3n9AZ5
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91f30ff609eso6418686d6.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 11:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794599977; x=1795204777; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZ2nZZ3s6y7qol6GLZvqI4xyT/lOQ3RMsv1KGP5S3jA=;
        b=Po3n9AZ5ukCVtyxupRbbfrpLGYxngRljlMmr6URQx5mXBtNOQmayJr515hpgVNj4sx
         SfBF8u0oI8BRgh0FyosgUvP4tKwELgo4ewaKIi5JN8mRtCuCRmvkGWXjuAw/02iadmRA
         uDnxdZ7AXUvdkY1hWsdsHvfshz1nH6EsEpR5OkjhwJvolkOQui9lyzTw24vhAEBxWDRt
         KI1J+fFxELXn2bRApiz8FOoEpAjp37dDgQtZRNcDqm1xmiXUP7jrvFn6TT9BHVcob1x2
         umNuZjQRMa9C79LylxXf/Ma826OY9RYwk2x+s7ONJ5FVSABT6CpUk/vzeFrO9xuYf9Ln
         k9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599977; x=1795204777;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZ2nZZ3s6y7qol6GLZvqI4xyT/lOQ3RMsv1KGP5S3jA=;
        b=jSeQ9IR6h9VXnIgApDeN2AFmqRtr1E27pPLkOgURdG1yMSHwkdBAdR+tt6VeCgmjFn
         C4Fp8hVWtmdMvio5i7zm0wKWih9v2AywyoTj+T+K/w6l4jiXaAUSYKQ0sqBLJrysCThp
         LKpRgwnKItlVQ6eSLKBa2tkyTXGzoTHysgIMpQSCgUA6/YgCNApsz4aG84ym04/9W3kL
         Vi1FKbg+RqupgfBpGlgF0hhfr+x0c5hRn0Npfwk8D1QtsBC6VdFhg1SZTUtP7cyWAS1Q
         KccdSIXBiZvcjQUpvY3us9PJbycY3LOgvc1Ky3oXsPYr7+l0kiiJEohhvPMPatEZgfMv
         fW5w==
X-Forwarded-Encrypted: i=1; AL+hErHALcJ99HlFV1wIvFSwd4+fEJXy4PpIu9zOxEw5M4UZLhnBOfo+UWHzwKoJFXZxc+DHxf6Q3A2QWizZ@vger.kernel.org
X-Gm-Message-State: APuU4Z8Hx72wU1WSbftnwpqsc3onR8OPDtpbqZJN6jxvQvxdAJi/PQ/p
	hXe4MXOIgCgxoHRyJAH6XbkJDwH/vPyd/mBT9lFRRDeEqMcdu1OzRHVH7O654J+EQ6Q=
X-Gm-Gg: AYBFou1KC/mlu6ER0J0mFyq8bMEdZkUfZ4OF/Ad5AQQ8y/bedZ4miKckVDskkQvDBMe
	U/D/prfCgMjOR2nBIajN0DAdqBr6ilg92jw61HItCYV8Pl9ExRuHzNzQfB8iw+yrQJS6vGvwf0u
	p7YTioezsRJghwnIk0UMiJkyeVGQkIMvC1UFX/BywsjWvxzMoYEcfBfioGGUVy8+q8fnsa+uBIT
	1tMnxZp7rLgY2VGbkxm0xVYx44idNJn0xOzqdo3qMuPD1AEUl3K821K/TxOe5JUgajcqOgcZ9Qc
	gf16NR5QDs+4rZ4O7euqfyQojmoyBR0ETWg1rwOAkSLl0hoJOGpM5ffUfxIWCBbrONuL8szdH01
	eUgdKxjj3ug4Ea+Et5pxdPt9D/6h6zEYmO3Vo6yUPJkoauitcV8hYEBG9og7I9qUkcEM5vw5w45
	4QE39Sk4Z2FW1xEiCHUTBHM4d5vb249e8QagLbRxSEN3dH/m3pUAqTRXB8y/1yde5bJkYm64ik0
	+1KUIYfs8g8p2pD2ltD5X2UHCqtgjexiUg6l67Fl6/Qeuy3oW2GzsqiYFDgkcnmSDXD+CVGbn91
	PfXPlQ==
X-Received: by 2002:a05:6214:451e:b0:91e:8d6d:21c8 with SMTP id 6a1803df08f44-91f2423e922mr59090456d6.54.1794599976764;
        Fri, 13 Nov 2026 11:59:36 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db49c5sm27322246d6.41.2026.11.13.11.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:59:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xRxQs-00000001ekG-3813;
	Fri, 13 Nov 2026 15:59:34 -0400
Date: Fri, 13 Nov 2026 15:59:34 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
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
Message-ID: <20261113195934.GD2532299@ziepe.ca>
References: <20261111121602.GQ8635@unreal>
 <20261111224136.GA754433@bhelgaas>
 <20261112092326.GU8635@unreal>
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
In-Reply-To: <20261112092326.GU8635@unreal>

On Thu, Nov 12, 2026 at 11:23:26AM +0200, Leon Romanovsky wrote:

> > I guess one benefit of this series is that a path where P2P Completion
> > Redirect is set used to mean that pci_p2pdma_map_type() would return
> > PCI_P2PDMA_MAP_NOT_SUPPORTED (unless the RC was allow-listed), and now
> > it might return PCI_P2PDMA_MAP_BUS_ADDR because if P2P Request
> > Redirect is clear, Requests can be routed directly?
> 
> I'm not sure the first part (return PCI_P2PDMA_MAP_NOT_SUPPORTED) is correct,
> since callers have so far ensured that P2P is supported before calling this
> function. The second part is correct.
> 
> > 
> > That sounds great as long as the Request uses Relaxed Ordering, so the
> > Completion won't be affected by P2P Completion Redirect.  But devices
> > aren't *required* to use RO even if enabled, and I'm doubtful that a
> > non-RO Completion redirected to the RC is going to work.  So I don't
> > understand how p2pdma.c can guarantee safety.
> > 
> > Translated Requests seems similar -- are we assuming that if ACS
> > Direct Translated P2P is set and ATS Enable is set, the device
> > *always* generates Translated Requests?
> 
> PCI spec allows "A Function is permitted to intermix translated
> and untranslated requests" and p2p doesn't decide anything except
> if routing is possible or not.

Both of these are basically the question we left open in the
discussion with Christian.

To use this new TLP specific API correctly the initiator needs to tell
the API what kinds of TLPs it intends to generate, and ask if that set
is OK.

So you need to say 'I will use translated, I will use RO, I will use
untranslated' because each of them can have different routing.

NOT_SUPPORTED has to be returned if the modes the driver asks for
don't have identical routing.

I forget how this ended up when that got deferred, but that missing
driver input is an important part of the puzzle.

eg mlx5 knows exactly which of the three TLPs it is going to generate.

Jason

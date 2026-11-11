Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399366;
	b=1sHZ4bKzrYGRfcjMn4mCoMouIhn9t/XLa8MAk20T8Q8WDGQmTBTZ/DQXhqXcLSf6oJv+
	 ExBspPsE8Ulg7mD3NJe42uRlR/0vM6aiKc3OmwhGpFOcRsUlMYBS9fA5jMbWQXCAwm5I1
	 Aav5Dlu/OoJGgjoFdu+siwyrUUnXw6mzIZPj/VmqTaxIhhfCO+VB5f9t1HA1k60F+RPsf
	 fOKYQ3wE8I/L1OWivo1wBCxdtTkhh0X/gDIwMXI/xcZ9lhwqIwJrIiMenMzB8lHrvm/9j
	 sZMKm6WLfDRIbebp50HHj9mKPY2s7z9M66hTWtqvqM6lBdpqeIKQjKwh5I4TnvXWqoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399366;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qc1N5Uc+wy8ltC14m/VdOEe2OVJ/DsFDi7Wdu8p3PFI=;
	b=vbAelOssuEfijUQEXq93I2eCDzdK9pJvpPHIYohIQu23n4GWRg0vBoVhvPHh7D3tYy5C
	 tXDlDhLo+4LtwHK9KMuIzcch6tlEugsJek82I8SIr54FbBgTRmTzmDe5yAsZrIGIlFQjq
	 O97oskrsBznyQ+ZoWKBg/eziDqv7Lc8pa+I926DuJkQkptO20yKQ6UB53EDJLoYp8eila
	 QbpGtEuxlsyzeXgWAk8aOKNecE7RwRWWDYDdYPj7CjnVX+wAC2VBfuL9YG3NGW4CUXsAz
	 l4UHEvRzOZD27vSi9TS4rhpq7rXqrhDZGCB6EbZbQJhR9EGTdHBRe1Q1onRTyeAY6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onlB7k+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74E9606A334;
	Wed, 11 Nov 2026 12:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onlB7k+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C291F00A05;
	Wed, 11 Nov 2026 12:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794399366;
	bh=qc1N5Uc+wy8ltC14m/VdOEe2OVJ/DsFDi7Wdu8p3PFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=onlB7k+kkABml/t8+gkpZvXlK49IkjHX0Ie3jRPouDS1A37DXNb3sWucYH9w1UmkJ
	 XbuCu4sR7afiwRAvdfhrIkNZqmMAbjVZsOd2YwvLkM0Oja5F5phRdXIVlHZ8Q6u4al
	 wo6iIi7sN/Qln9v5Pm/OlG6P7GoTC+kacdGWaaJjGJePEmUwIu/Du8hFGyKVovLqU7
	 kHBCtP4zKeQ3IzCrEMOwBcWq9gSg7u38qZkj7SbT1NsgYAMgJ8fnM3buiBS51WY+wP
	 T9rECHE6S532kCq9g6YcpisTsaqIxxuzx88iv4PcnNkIycJDOHa3Ik1ey4T3i2e1J7
	 /+IZl1Op9qp8A==
Date: Wed, 11 Nov 2026 14:16:02 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
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
Message-ID: <20261111121602.GQ8635@unreal>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
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
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>

On Thu, Nov 05, 2026 at 12:04:31PM +0200, Leon Romanovsky wrote:
> Punch line for Linus from Jason:
> "Enhance detecting if the PCI fabric can support a peer to peer path
> by evaluating the full bi-directional fabric path over each of the
> three traffic type ACS controls. Expand the number of fabric
> configurations where the P2P algorithm makes the correct determination
> of support to include non-uniform ACS and situations where translated
> takes different routes from untranslated."

Bjorn,

Just a friendly reminder.

Thanks,

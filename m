Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F232F501290;
	Mon, 21 Sep 2026 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025599; cv=none; b=WyVsvtz+9FBp/ixmQS3KGY876R6hYMTbtNXphNikyyRMdTI+O6vcGt780BCdt+8JcATWorYBMODNd0BpKI9fOJ+YLgcQIEEVsbgprcPWV0IrzHikbmwzvjqQuGiwgzwaxiiBu9DjB6EP6NNZWBjoxtPYkOX/kikNaP4ZXeFPzBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025599; c=relaxed/simple;
	bh=pVFVNpryK/50omAZCNkcvjfe5nFPxxjWqY4zKIS+Wco=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=eQm8JtdEPGsZ/eMSa1ZK4vI3BVhsdakB6+C5CskiDr35W9xD8Oi0ESayWUYXSYBj0fFDOlAjM44WS7TxISJpE0rB6uKU+nna8/m5DPCFxOfZB5XSzzeEbFBU4yQfr+qgedL0iZXrgYmIBRSw61RsQNegVt0Qytnwhsr0QRJ0dlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=ErRE0zur; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="ErRE0zur"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=g1ST6U2BpQn/s3D8UpgYd2KCtTjj3ldN0h2dyB/bZ1Q=; b=ErRE0zursoMY+UMyjDwlvee3Ni
	KA0G6w/m3ydbimYpQQUck96YqgySKBEOmHmVTKRDnOSBjXwLk823Iyzn19FH5wIRNyOd8lHCcCOKF
	P4e0/xf7B99zvFBls/UtyMwxWMPlkopEgNqDz2HBzZ+BN0XiC2bQLmA9ey2luseNU9pagmqqvcRBg
	X5WL28iC9i3rfIjgzKuHTOMbAZBQXwEdIErvGXDZfX/f15ftDFp1bId1GIvg6+M9qgvuceibqnwk3
	gV7hSE5AohGjlJ+NEsDquVHADVHT9YX5Kzbjm+P60e79A2ZT0irlax3JIJfDcRd7sn2BOJDrjfqsg
	6x4VUOpQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x8lQX-0000000F5FQ-0Kc5;
	Mon, 21 Sep 2026 15:19:54 -0600
Message-ID: <9e868c06-be53-436c-a78d-790ed2b91c3e@deltatee.com>
Date: Mon, 21 Sep 2026 15:19:40 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
 <20260920-fix-p2p-acs-v4-0-v7-11-ca0828ab697c@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-11-ca0828ab697c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 11/19] PCI/P2PDMA: Log detailed ACS routing diagnostics
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-20 05:41, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> When P2PDMA rejects a mapping, existing warnings identify only the final
> ACS or host-bridge result. They omit topology, live controls, divergence
> ports, cache state, and intermediate routing decisions.
> 
> Emit debug-level messages for verbose calculations and cache lookups.
> Report both paths, decoded ACS controls, directional decisions, host
> fallback, and the final mapping. This keeps incidental unsupported probes
> quiet while allowing the diagnostics to be enabled when needed.
> 
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks good to me:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

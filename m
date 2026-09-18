Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703CF348C6B;
	Fri, 18 Sep 2026 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789765878; cv=none; b=P9mVq4w7lWuSpMIT7Or5ReM04Dz+E5CiIaPxStgsXjjBLy23LZW1jpxmSYB3J5Ch37oT5pqRv2W7opgtpNbRaL7qN7+LHwqdtPM62KrJoU04LwaTC7xWql62xUNQKEnqg/pK2mWC7WsvqdVSLd8JgWXplc3XIRelDxrjwS878M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789765878; c=relaxed/simple;
	bh=iTA2JmU9v7HJ5V5IljVnQwoIkWnikrfuoyICSQaKHl0=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=qDcr1luZ7g7a5ac7RX6JlQ8IJ1yi4DuE/o12ff4985fZjKf2HzyCxE5DAGfgTOObk93z3XH/4gsS+Ok632+aouae1ivo4qqzF5W5WCNX57goztQVawWKQyvqiIEIbjTZmKCDB+NUscD5ycha3Z4b7tKqds1OwBRKFhvdmDJPdmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=MK5blqq2; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="MK5blqq2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=ULK5VZAuxSXWm8LF6Ikgli/YbS6dUrioNZM7oqlPxpI=; b=MK5blqq2y3XgRiBDMg9+TPw8T0
	UT496dXnWXaagiYpJ1QjxAfmCHoXmHvKAkurXXQNRO1vHuwD8QANkRnJJ4GzcOMFvPlayeMSYYpgY
	MrmLiAKp2mxyWv4ot7eFkFMFP0I6KlAWyMj8WcV8lQkz/uFyXIBWnswMqzddGeC2DcMGbKvmMBVhr
	Xfy/J004Cc45D2ZsVjDFWzx9u0yYC2UjzdUKLosanchXkMCKHW7YTK6o6dA2MLNLMRvBS1XHYfNva
	jhYUyth0v1bllQNFaJMTlXZWV2E2PHAeUZASCOMn8XxquG3udEVsm99SRFGRR3xLRzs7xfkAa5m55
	OROgvIIg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7frU-0000000Ct2f-3PJO;
	Fri, 18 Sep 2026 15:11:13 -0600
Message-ID: <df87832e-8c45-467c-bbfd-d5154158172d@deltatee.com>
Date: Fri, 18 Sep 2026 15:11:11 -0600
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
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-7-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-7-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 07/18] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> calc_map_type_and_dist() reads each divergence port's ACS Control register
> and folds the result into running counters as it goes. Any routing property
> that depends on the kind of TLP being routed would have to be threaded
> through that code, so there is nowhere to put one without reading the
> registers again for each kind.
> 
> Collect the two ports' ACS Control values into struct pci_p2pdma_acs_path
> first, then decide from it. pci_p2pdma_route() applies the same rule as
> before: a path routes directly only when both directions do.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Big patch, but I think it makes sense. Might have been easier to read if
splitting out pci_p2pdma_warn_path() was done first in a prep patch. But
this is already a pretty large and growing series.

Overall though, I think the patch is ok:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

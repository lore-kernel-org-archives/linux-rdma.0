Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC643C05E;
	Mon, 21 Sep 2026 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023098; cv=none; b=MdhbMRAYOyPbg1WTDhVvGKt1rVk0TaOtPBODmS9nWGgpIB7TV8Q9+rC25Xb8Vbj+ohFYo/hJYHVOOVHPbma6+bVm4gnSiCjUrYcfAgYSPmX1VhyYP1oNKRNxose4YbIt79bsSdXYmjretTYfj5VpqMoOl9IogfghcNyAfLvPOnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023098; c=relaxed/simple;
	bh=eYmGtKrob21NWMfAQ95fckRcqt+uVQGfzglKt7C19oY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=pKg6Yuy3JSX4L0i9/qJpafn/LlVrsgI89UMvjm9Y1vbyWzizmSftZqNh94nwvaOoAG7MEajMEKnoeCNqfc1NkeRKQa8JHfJZV2R5fZ5ESjjoQ8jB/7AWzHXFPz4mO16gfOdVWA4UWiVasJg2RhTkLxd+Qf0neJ4GQ1nQPnEKL3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=LsKW3NzD; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="LsKW3NzD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=Sr1qhGABu2EZeNtmrODjYoKQgc9j8cv9j73nR1L57ck=; b=LsKW3NzDV8inZjUq6NrZSEC48G
	3MkUOffQBf7rtALq+krqCwpV4UHCjoTxdPFsIP8DFtXqvVKwEioT1Cdn1lv1P9SzDVlrBFfG/XMZ9
	Fs03BSlR0j2+oZ4iyoY2LAwViJLntqOIDaG99B+Erxl9MgSfArvsxm3puFumHsbCbSidz+laCrr9K
	8DCBlV4VsoMt/nH4fzRJvjoz0nSwjx+ljCmCLmhG72sIgW+ojj6vQGUn/R2jITMzh4crlfd+5z1su
	tkZIOwSo9KaAJ9LTeZSR6M/eAK9dh0+CHIrd73lTZSfUpRtEPAnWBq1cjcaQl3lo6AdZ4NFJhYILD
	LsDqJvHQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x8kmC-0000000F4jb-3Od7;
	Mon, 21 Sep 2026 14:38:13 -0600
Message-ID: <81c888b7-5d43-42cb-87ea-273e169d8343@deltatee.com>
Date: Mon, 21 Sep 2026 14:38:09 -0600
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
 <20260920-fix-p2p-acs-v4-0-v7-9-ca0828ab697c@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-9-ca0828ab697c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 09/19] PCI/P2PDMA: Reject Translated Requests blocked
 by Translation Blocking
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-20 05:41, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> A Downstream Port with ACS Translation Blocking enabled treats every
> Upstream Memory Request whose Address Type is not Untranslated as an ACS
> Violation, ahead of "any applicable ACS P2P control mechanisms" per PCIe
> r7.0 sec 6.12.1.1. P2PDMA never looks at that bit, so it reports a
> bus-addressable path where an ATS client's Requests would be rejected.
> 
> Add PCI_ACS_P2PDMA_BLOCKED, and because blocking is not a routing control,
> scan the path for it rather than the divergence port alone. A blocked
> Request has no host bridge fallback, since the Address Type is rejected
> wherever the Request is addressed.
> 
> The two routes do not pass the same ports, so scan them separately. A
> direct route turns around at the divergence and only passes the ports
> below it, while the host bridge route keeps climbing and passes that port
> and everything above it as well.
> 
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

> +/*
> + * Report whether any port between @client and @common rejects Translated
> + * addresses. @common is NULL to walk every port up to the host bridge. A port
> + * whose ACS Control cannot be read counts as blocking, which withdraws only
> + * the Translated classes because an Untranslated Request is routed by the
> + * redirect controls instead.
> + */

Some awkward wording, maybe:

"If @common is NULL, every port up to the host bridge is walked."

Besides that minor nit:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>


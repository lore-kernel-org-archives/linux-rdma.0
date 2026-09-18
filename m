Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9700351CF4C;
	Fri, 18 Sep 2026 20:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764859; cv=none; b=NK5R8/TQ94+zt3RjvYvHnfZTmgEKTiXPNmVm86of4iv7IXzp706ldPaoXy4tRu5rFVqYWgkmMbotMFHJUOGqrZoLUywzt3aNkdROcgLLYc0Fh/3DVTZglW5PC0wd4M/k9gWmFxQmE7Y+TSdtkoVs7YuOudZj+x1bCOZH0EETSr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764859; c=relaxed/simple;
	bh=X12mV0iQNA8wD1Jzhx/1YBoYJPHdHf0r9UY86zeKS8Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=OON3/0zhZ/P8zMk6CuVdONtYou4jin0Z1O23ikIysPxpzL2YqfYVZLvSfPJnoTfL9liKS81fPXoNQx/KRX0yftQaC58ywOBZfbb40VkDUMOtKEgu8j0rHWkZ4kvxHN3p8AzRA/GE84mIgBHfnrVEewnBrzCstxPTNSvK2Ah/Yco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=LpbRADbv; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="LpbRADbv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=+EF6n2UXLQQ4v0vXMKg6Y5r9VaSza1T1e5xKD84icBs=; b=LpbRADbvXs4zcm1gcSJ/IPKA2+
	8pCG8wQ4vU8xEayNsVIpQtVu2w1Nwg8LQd8duRi1DwAYGFnU0hvPEmG/rSpADy6Q7ZFKWjoJqGXdm
	rcW8Ccio2xDGOgAp727lrKANRiUkgh47M0eGk0Ugelg5fR3CnP1/jOy7webBXflq5xov3dWxDVVfo
	NbFqrA/HTjijqZZSECvbpTznw/Jy3lDNQMbZieByyOlbKXY8+dcnCMfxRPIvhz2K1G5dk+iBhIL5p
	kCAslwv0+dLXAceOJ1kdAYJkC9/Ehq3eceNcR5oJozk6F94tPoFARUO0qwHeNnrsF1XSTvzRiRK3u
	G+mX4C+A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7fam-0000000Csdo-14eH;
	Fri, 18 Sep 2026 14:54:14 -0600
Message-ID: <43948cef-5a40-4ff3-8dd5-081d203f6b42@deltatee.com>
Date: Fri, 18 Sep 2026 14:53:44 -0600
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
 <20260914-fix-p2p-acs-v4-0-v6-6-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-6-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 06/18] PCI/P2PDMA: Document directional ACS routing
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> P2PDMA documentation describes ACS controls as path-wide, although Request
> and Completion controls apply to different transaction directions and only
> affect peer-versus-upstream decisions at the path divergence.
> 
> Document the fixed client and provider roles, the divergence port checked
> for each TLP direction, and the conservative handling of unreadable ACS
> state. Clarify which controls disable_acs_redir changes.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  9 +++++----
>  Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..43a25f3f94fd 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5291,10 +5291,11 @@ Kernel parameters
>  		disable_acs_redir=<pci_dev>[; ...]
>  				Specify one or more PCI devices (in the format
>  				specified above) separated by semicolons.
> -				Each device specified will have the PCI ACS
> -				redirect capabilities forced off which will
> -				allow P2P traffic between devices through
> -				bridges without forcing it upstream. Note:
> +				Each device specified will have the PCI ACS P2P
> +				Request Redirect, Completion Redirect, and Egress
> +				Control features forced off. This may allow P2P
> +				traffic through bridges that would otherwise be
> +				redirected upstream. Note:
>  				this removes isolation between devices and
>  				may put more devices in an IOMMU group.

Seems like the new sentence and the following existing note are saying
very similar things. Maybe we could drop the 'Note' and say something like:


"This may allow P2P traffic through bridges that would otherwise be
redirected upstream and thus this removes isolation between devices and
may cause affected devices to share an IOMMU group."


Besides that minor nit:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>



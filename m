Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C5040B0EC;
	Mon, 21 Sep 2026 20:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790022010; cv=none; b=fAfsvBT+8O/mbj174NsYh4bSaJq77dotdcfmDFKNG5LIJDp5qzXy/19gDaL/oDEI4oRmUxRm+08mFPUjk6UnCZV7fNoVzLG714LWvTEORaDZdwbvv5FCKM8SpuWsZnq0hiAuVkn2nDKKoF0/sTNVYMj7v84Xm1qKmaRlUHAoHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790022010; c=relaxed/simple;
	bh=ULL2sCfVDm6zc7ankviblB2XQp/aT+4WTaCaV0sJlaw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=eDcUrMPElDptb2Al+8iigZIYmR828zM7+g1zRpu1qMbMAeRH3hI1zTEzDs8SxPN7YasJJ0X5NLmalb7TK5qc/a3GdsSF7CDL3OukDuiaSZqQ7lnErH4Zxioc+dYyTZLTk4RL5QKvuyoAODKmyd358L3k1Ggg1+w7pEf6QkiBLE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=hBugeAc7; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="hBugeAc7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=/kI6oW2E5j3Q5O4fdEa3eYERY9JobvSzq1pyfLPXvP8=; b=hBugeAc7MrRyOU4zBBCUqtS5XS
	6+RXvhBejB2Fpn0eyZquoh0extXUkJ3cSiML7q4kcs+2HZShy/FLhx3xDR8ERnzuxkkOygY4Dyxp/
	cxBNa2IKbP7A7czer0QQNdwZVLcrB8Qgjf4BUS1DyXjVpeDFvB9EaO6JLg1TRi3xb2RiKmH5JI+uC
	EQsgw3q1T+FeczuwLQHEDxk6luELJbNOfCyzAOuDwobdL3t7hEyxq6eX141qiHY38qeDbDgUgWpHL
	GZH9fnTofY1KboZF0j5B6HBoFPFWZMuwg2fmN+7+TaxYsyuurMOSpMH4wlQjZ2oNNOAv6NSrY9w6I
	cStzuOnA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x8kUe-0000000F4dP-3Hw8;
	Mon, 21 Sep 2026 14:20:05 -0600
Message-ID: <dada3ea0-61e7-479b-96c4-241eb3420542@deltatee.com>
Date: Mon, 21 Sep 2026 14:20:02 -0600
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
 <20260920-fix-p2p-acs-v4-0-v7-7-ca0828ab697c@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-7-ca0828ab697c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 07/19] PCI/P2PDMA: Answer routing per TLP class
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-20 05:41, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> calc_map_type_and_dist() returns one mapping type per provider and client,
> valid only for strictly ordered Requests carrying an Untranslated address.
> Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
> do with their traffic.
> 
> Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp()
> to ask about one. The topology walk and the ACS Control reads do not depend
> on the class, so decide all of them from the one walk and cache them
> together, four bits each. Every class still answers alike; the controls
> that tell them apart come next.
> 
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Ok, this makes more sense to me after a fresh review:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

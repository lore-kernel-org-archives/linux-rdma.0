Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057903E4117;
	Fri, 18 Sep 2026 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789768575; cv=none; b=tKw6j6tpMe+YotVNf5pcbWcZFWzmXEVySAYQTrQe0yFoKMVeIGkxKOtYpQ5pTdACqaXrquc8+7Mpdd2ZBthHjq6292XEacn5jQ74+2lGkGIcFjFpLfYlbed652Ax7WvGQ+J+RmGT7UfWZRuLxZ1aVEny7zxyBGmXQrJuknavCkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789768575; c=relaxed/simple;
	bh=wSd+7xxm/Jk4mb/OlPys26D/2/ycFjXxQT7dww+dnGY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=ZGvI48oulwI15nsz6TcF97/tQI5nqSbamfk2311hHmNNSmNzGgxC8TA9cag5+63SgFK9epQL8SFFJv4kPpDHXni6LtlsgaoxWw7KySYIjpzVFu55a0BqVYdwrK8p8HSqf89iPJk6b76ueK2VXc9VWyS6HbVZI5Vbf2UFF3qQnGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=V7/dGNn8; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="V7/dGNn8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=1u/pZfJXhGil71agQiDuc1fg1s4Wvg6SbnxIE4w9uUY=; b=V7/dGNn8rpaLuDMtEQbu4NwVat
	r6CU1FoTHRfd6LZTn8ZTJbZnNalXfOJahoFWdWsNQ0a3oePx4O7x7puIWxrpPMVuaoTdhgqXjXlL+
	Hy+zOTdWSciE50KlVhUJDXZnQyOtMz2BCb30ESsBoG+qyFKiMNWStyTNLuZ0t+6caRQ1pzDbzxhMZ
	tbijgnjt7Na9oR4dxe9UVOvo3Te834VI2eG2mnRpKkczJldWteEbXEGzQTHXCe3J93gGy89XvQbEb
	87v4jvbZ7xBiMlHXKeoWtiUe01dL3bDO9ClLyjTsK+9Rzl1EYSq31rXPsmgXYSKxO8pZPL1pHZ7dT
	vVNdli6A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7gYz-0000000CtIG-2R2G;
	Fri, 18 Sep 2026 15:56:10 -0600
Message-ID: <5ee9b103-85ea-47e0-9397-b1e2dc2a9dcc@deltatee.com>
Date: Fri, 18 Sep 2026 15:55:57 -0600
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
 <20260914-fix-p2p-acs-v4-0-v6-8-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-8-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 08/18] PCI/P2PDMA: Answer routing per TLP class
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
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
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>


I'm not sure I fully understand all of this big patch, but I tried and
couldn't find any obvious issues. For what it is worth:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

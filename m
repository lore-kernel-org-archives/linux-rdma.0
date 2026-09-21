Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5A63CCA02;
	Mon, 21 Sep 2026 20:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023918; cv=none; b=AQEWVITaixkD5Qrl49DbYY0DoKYhptC6KZTKcXTqRhh/+3FyhWud3j3yWW+S0prnFJ9Lw8yWO17shQnE9Y3qt2hD8C8mxzhcy8E6bf3kWydf8/hCG2xUFZI2getW6a1Kw6AVpXRJ+QZyCdDYKWnOgYNBExFJy6tXbahRYJCNfg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023918; c=relaxed/simple;
	bh=1CDELqiiofivXiZl5QErg8K2kh1qvy2PGzpNAH+s/Ak=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=E7E1i79wnpbhGwrKd1+8uHSqIsK5zBKgki1dbNL6mSl0/krdeEFfHw8fQObwo6U1Ddomqa8gwdq4NeUnHUnOqMizAHIC6L2G+tpB2NhcT1U9mp58KXNeEUzcQSvRZWExmUBu3jvGTHvJeDLXuWnCHXQWCLKWCeaNRgA8xN6RPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=X2MF/i4M; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="X2MF/i4M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=BpVc1oOlMNPMnv8BG9zWt0tN3zKEilatFXc42t7lFMQ=; b=X2MF/i4M59hS2XH8iC5SkeBMCq
	UW4T2hxrNk/lFHCJtbIFG03BljH0G1+JThASbEgwqqzeswupAYCkYxdNvSsYljfmHd6nizAKAZEsw
	uXi7lrUjextbyIn0shF78Kbi4olRNAoeDbF+to0ksD1wdK/xXJoUh3AcHksF9eNxAHaFnqEcbxFEm
	jLdTfD0ZhDTjjSDnO/KdwrIRcmFtQIz6zsqzlY+ICNdacwJNXqa1hZprAom2PNkTE0LEeuF3eBHOr
	gMej4EeqHr4Os+wecDS3tXlmZOD+au5N6HrShSzH4Og+s7WH6Q+EUv4TuA/wcc9vF/f2NKac/NgRD
	3LIhTFrA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x8kzQ-0000000F4ow-3YlI;
	Mon, 21 Sep 2026 14:51:53 -0600
Message-ID: <a9aad34b-949d-4e35-96db-7a969aef78ef@deltatee.com>
Date: Mon, 21 Sep 2026 14:51:50 -0600
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
 <20260920-fix-p2p-acs-v4-0-v7-10-ca0828ab697c@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-10-ca0828ab697c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 10/19] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-20 05:41, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> A Downstream Port with ACS Direct Translated P2P enabled routes a Request
> whose Address Type is Translated "to the peer Egress Port without
> redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
> Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries an
> Untranslated address, so it sends an ATS client through the host bridge
> even where the fabric would route it straight to the peer.
> 
> Add PCI_P2PDMA_TLP_TRANSLATED and consult Direct Translated P2P for the
> Requests it describes.
> 
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks good to me:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

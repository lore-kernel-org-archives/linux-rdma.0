Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3E335E956;
	Fri, 18 Sep 2026 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761601; cv=none; b=gxmnZerjEWLcNSrBDAEnlRm8aikLN4LoMLtTqXF9+JVLni7x+H0xgNZuGmnHW7uzcvNkAhWon2LGYPA1btg8Z2er+9GzqP7G3Tsjf5fiE+Alv4idm8l+OaJFBIYy7My3d/ep3TT+OqQENKnWQkVZLqcBuWeTaUM8m2qS01WENOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761601; c=relaxed/simple;
	bh=ujkhGy2FSYAIasmOkN8vs+uHhKJMbQlyvbnsVAWbj1o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=IKzrhETNZm4Id2TBQ2+vdXFmAhy8b4lD3Ijd2as9QzU+nElmDRICochwDeUUPxTomKA5Vp2OuUJhPn53cRZayk1b8NR0mMZn76nmPJAxC+iElqQ2CFixUjUxQrOLcOoW59UavlLsEKQVRmUule42wpuRs49zkr98pfHdnZKQEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=W/ONbTcH; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="W/ONbTcH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=cmiry3JcpazZ6l/PDBYrf3Gg/OWOS79zaTVf2b02IB0=; b=W/ONbTcHvbbIcERFDBy5V9+fz8
	ClXKlqhfI9/+PEX5UPZD/o9kNZB2xeLc6zsCCTmVEebXhBjHQB1VHAH3gZOcPOirQCS5xTtaH0f5y
	s0JCpmFhn7hlwfUnwEhUXZMND0d06IpSnuXzm8j86ZILMwQr8gCPbjPiwyNNd/0T4UK7TSQzEcPNC
	5aqkcHGEO3iirTALpNPzRsqeyqDK7uUa2nahHS2hhtAH2q05KmkruKKkOSr1EwNbW/d6ezacx2EXb
	kuJwha3ZRhs0SHbPVT9LjGFOUI6TCSn71LmSJBR0L8gAurJAb3h9zxd1NU58TeZwTWpyag9nqPIUW
	MSa9+CMQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7ekV-0000000Cs4I-1zVG;
	Fri, 18 Sep 2026 13:59:56 -0600
Message-ID: <1384e37c-d4d4-41d7-8d74-c4e60f52c9d7@deltatee.com>
Date: Fri, 18 Sep 2026 13:59:54 -0600
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
 <20260914-fix-p2p-acs-v4-0-v6-4-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-4-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 04/18] PCI: Reject unreadable ACS controls in isolation
 checks
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls.
> 
> Return false when either ACS capability or control state cannot be read.
> An unknown state cannot prove isolation.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks good to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

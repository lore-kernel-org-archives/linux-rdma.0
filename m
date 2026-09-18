Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F422931F8;
	Fri, 18 Sep 2026 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760415; cv=none; b=LI46YPoahelWrWmba8QHofrdepQyJjLcxFUKq8rfx3WZBdnPO2iO59sy7IWVdx948M050ocMP1PI0JKTkl1DTIeP0IpiSXFm6BzkGAYgceOMOoBTQNUtIBGQOLVzJXXrMK/IKUb75e7DTlft/I97nVEpHLo917qJWDoUC0WtqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760415; c=relaxed/simple;
	bh=Kk3ar4q45siHy1y0rPnYfhOrE+vVoxmAnZK8w5kMOiw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=OTFQ6+aomGsXsOr0YIeRK9gExMd6+vr68CB3LyY8kbzuULJy/YDm0jOZIax1tqlhA1Nu/6K7OH3lsAGmBcXnzTPrkXxKbHVxNW4Y0WBMIWIiqvERF8SD4wfaApwdXfaTeEe+LPjSKKM+o0P9DKa9zpCH1dhriPa5A7bT7BohzLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=p1hFKb1F; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="p1hFKb1F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=lQAIrUFP3+D+tD4U17DzHrKkOc11Ho5y+ORRcF4NPXs=; b=p1hFKb1F/D9iIDg6hNHtr8GiM2
	l37aQ39NUCI6IRV6cw9gskBQm2rzWzmoVGB1A1sSt6dz5QZVE29rnly2O4sra+jAVtX5GubBbhzIT
	estioaTW7b42lemwzxUqTkaexKwqWBQXacYsSjVZzNvKbOFT+MjWkLM0OirZSxU2f7sT+NKmqaUfV
	o2SyHTECs+cKETwfqStVBNeQngTXT/DtkXdqEV9Mma6d2VcU0eUSuvkbsuX6aqp80gMFjKciNXgwC
	YI36SyWZbHBozXXE9/fXLmwHKXHr3dGHRBoTkxESWTCrljgEUe7uToA9S6ifHB5P/eblW6xIUFZVM
	uH56LcFg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7eRN-0000000CrxC-0gtG;
	Fri, 18 Sep 2026 13:40:10 -0600
Message-ID: <19bee27e-17d7-4b67-b796-ca5bb44e8de7@deltatee.com>
Date: Fri, 18 Sep 2026 13:39:55 -0600
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
 <20260914-fix-p2p-acs-v4-0-v6-3-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-3-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 03/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.
> 
> Evaluate Request Redirect for client Requests and Completion Redirect for
> provider read Completions. Continue treating enabled Egress Control
> conservatively as a Request redirect.
> 
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Core patch seems fine, minus one minor point below:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> @@ -1132,10 +1173,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
>  /**
>   * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
>   * @provider: P2PDMA provider structure
> - * @dev: Target device for the transfer
> + * @dev: Client device that initiates the transfer
>   *
>   * Determines how peer-to-peer DMA transfers should be mapped between
> - * the provider and the target device. The mapping type indicates whether
> + * the provider and the client device. The mapping type indicates whether
>   * the transfer can be done directly through PCI switches or must go
>   * through the host bridge.
>   */
> 

This hunk does not seem like it belongs in this patch.

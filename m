Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EFB3F1ABD;
	Mon, 21 Sep 2026 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790021157; cv=none; b=fH8rfzNLcZwH6rFE7Aoip9wxLWkQMo1ssH+eDyDfHCmiFcmoRs6WfRi8+/pnxd3HP+kHwIQ2phtUIiHKerFqFJIYi6n94Hkfmp2nOkRNKugZFjeU6P7cEFd5psK1nXOLQVefjt9IRgaohroHgLQTxxWZmKSWUz3co17fpFUX6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790021157; c=relaxed/simple;
	bh=pect6xtOnju9Z/P/c6mdBBxKTlsdyogbO75mykbCoQ8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=VMtOMM1pEhH3SqoHEmw9OTeFW6WEtK4Lc6MEdWFiPnF5XdByUf6D2C5GOm6w0E39gbNzlVhS85Rg4yFaczyXJs3tKxqc/zryDCrEQM8IrI5u5TTS9I+CV92120NW+iz3+EqkKjdRF6bScUF4RoRbAgCh4PGaN/07AtGE+loFb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=MWuX8Icz; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="MWuX8Icz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=DK/qrJt0Ap9dv8WpV7Wvu69ob6X/ds9pDh5dhWphwkg=; b=MWuX8IczTBvONmG/xlPQD0jiXo
	lwn0eAfVBfG4Na2wPqrsAR3Vig+h5m9Z+jcLcQ8g/pL4KjoVq75I8t5Uz9wcrvVbCETfAKKGJFv9s
	UWHIAAlgndWq+Kha33Ydvo+UyD0YqOBSB0tOxiZKalaKgOVuoN++XYy0dRrT5feo/D7gPYIHgxtKO
	WwCOBe+9hheeBow8IXtzwF+Ux+IaQ6rCIL6at0s6HDwoHvShO5X1n8EEhPct6hgaAZL43dTIxVE8C
	2i74d+K7cxY0gdvmWRxWxbgCoJkpyQio+LAZy3MGsKNIa9N1SV3OKkMb/CHP0Mf4tOBU+BYOd9n13
	yObNM5MA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x8kGk-0000000F4Yk-1hRC;
	Mon, 21 Sep 2026 14:05:43 -0600
Message-ID: <0ab682be-9b58-48aa-88e9-d21edaac19d5@deltatee.com>
Date: Mon, 21 Sep 2026 14:05:18 -0600
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
 <20260920-fix-p2p-acs-v4-0-v7-2-ca0828ab697c@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-2-ca0828ab697c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 02/19] PCI/P2PDMA: Derive routing from directional ACS
 controls
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-20 05:41, Leon Romanovsky wrote:
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
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Still looks good:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD65437FF68;
	Fri, 18 Sep 2026 20:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789762064; cv=none; b=ui3Cv5NdZaaAboiRtDnJTqWdW7ud8RG820WQOpTFIDdOpoyyQgT5PdZy+mrLKUdOZq+yYeoH9Sfm2q4CH8LXQFI1ZZuCGeL43RyiDd7rqSCNBqZPpmSUfPiud2Ze7zMq+x5UCY2VxA/jT1Ti4/+GAxHhsI6bAHiM9TquBjBzCYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789762064; c=relaxed/simple;
	bh=/V7mSylXoMK+jkLlBzPSKoPOqJXtmnyWjv/QXQfBwBI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=c98lJqy13c6/5n5HPad1iQFI0RCIbgJeJ1RYOqdGWMsInsqwKGSvQQh/Jc0q6DRiJQ+MX8Mc6O1COplne8NvbqRo+x9FWvITKkOOnWNHOTrAplyj01oQ3cL3hzprDAj5++11Kq8kKuMgGgw0wEH845K/Qmq7RKQRWY45N3FGdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=KGv8ai85; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="KGv8ai85"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=I9+s5+K/DpZgsWdaC4psIlA8J8Zx5wR4CRtj24i+rVk=; b=KGv8ai85MAx/Sdr7ncFrnU1GEe
	gRzsCB/CSdZQhb0L8DXgcgP0GNgItLQXPZskeIp+zAruBxb4fMQOuY/Z2IZiKzv0duBXEiGAHJtPK
	i8DXDp1zoTZA+V/oeDodyWlUBxJYOZykZqf5tPX2YkbytsGTF5Tsb+KpbPkUDdosPuncJ+gPCc7dM
	ExHflG2VdS1IA0ouX3cwaIVa6XyubxJPs2LytZ/R29QODp1lfRgqI4hEJtsy9nU7Ka8dtsZSp7LoX
	mNWrDxLzWruEL+UPDnK+PASA66N2LfCqO69Zr+ff55lrC2sg/gd5zDlnBdxMJ+K0ixYHcutK9zyyl
	ItQHcsEQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x7ery-0000000CsOc-1rKW;
	Fri, 18 Sep 2026 14:07:39 -0600
Message-ID: <8623c5e5-bca8-4398-895b-2a7b1227e93b@deltatee.com>
Date: Fri, 18 Sep 2026 14:07:36 -0600
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
 <20260914-fix-p2p-acs-v4-0-v6-5-5ef07ec9ef06@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-5-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 05/18] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-14 05:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ACS redirect controls choose between peer and upstream routes only at the
> path divergence. Applying them below that point rejects valid nested
> topologies because traffic already has only an upstream route.
> 
> Evaluate Request controls on the client-side divergence port and Completion
> Redirect on the provider-side port and reject an unreadable ACS Control
> register.
> 
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Still looks good to me:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

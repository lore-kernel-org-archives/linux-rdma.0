Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE719CC0C;
	Fri, 17 Jul 2026 00:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248572; cv=none; b=tVL29etqR44DTw57289NgbUV63+SzbWgbsucIaNKHJ2GigfX/X7tBlALVEAC5DZRbQFDCBKFDpR3UcDXCwFi0ukE8bFWyYYv/P5WWJugDoZ1Qx07X3fb/2efnMliY619kB+d2dnkQleKS2eHITTxyO3+NYWCIgBWXZu329lMHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248572; c=relaxed/simple;
	bh=R35XCsJuc5jHpdqAZs18ThP0ZLP2q+C5rSlqxC63PQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UjsNzBeTDaqG8w7/eur7XsmG3NlaGbhHPvlrrDZEzgzMNzVtRTQQFTlveXTCtAdNGEVVQBlH/qIYVyQJxb4noBHv7twx7bVyekBy54NwVUwMKg3Lz2m72iUM/Gna5SZm5k+Eb0g8uyuc2SzYbDBLTR7IEOG7r7IRVkjhpa+MeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2UrT9pL8; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2UrT9pL8"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Hl6h2IYcYuwXBYOOL7pqYx9d2RhCGbCk8YRDzXACsQA=;
	b=2UrT9pL8FZiKdNFXwq/xDWAfGVdGwVuRz2kBWN1ijLwMJsELUDaZ3NgaedV0eQkKgpSXazU3g
	gSmCb5yJdxnr3lEkKxlKQlDEVuWNkDeM3h6miVUsWXmkMtmcnEtR9VDv+RRM4e3ve3Yf8I+/rJm
	eHxkyKmfLhCy1bp47xvVWts=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h1W1d4zHVzcZy9;
	Fri, 17 Jul 2026 08:26:45 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id A504C40561;
	Fri, 17 Jul 2026 08:36:04 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 17 Jul 2026 08:36:03 +0800
Message-ID: <d9285ce1-33bb-4be6-ac9e-6269bf9644a6@huawei.com>
Date: Fri, 17 Jul 2026 08:36:03 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 3/4] vfio/pci: implement get_pci_tph and DMA_BUF_TPH
 feature
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260715204008.3911275-1-zhipingz@meta.com>
 <20260715204008.3911275-4-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260715204008.3911275-4-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Acked-by: Chengwen Feng <fengchengwen@huawei.com>

On 7/16/2026 4:39 AM, Zhiping Zhang wrote:
> Implement dma-buf get_pci_tph for vfio-pci exported dma-bufs and add
> VFIO_DEVICE_FEATURE_DMA_BUF_TPH so userspace can publish TPH metadata
> for a VFIO-owned device.
> 
> 8-bit ST and 16-bit Extended ST are distinct PCIe TPH namespaces; the
> uAPI carries both with explicit validity flags, and get_pci_tph()
> returns the value matching the importer's requested namespace or
> -EOPNOTSUPP.
> 
> Publish and read the TPH descriptor under dmabuf->resv, matching the
> locking used for other importer-visible dma-buf state. The SET ioctl
> takes dma_resv_lock_interruptible(), while the callback runs under
> DMA-buf's asserted resv lock.
> 
> Hold memory_lock in the SET path while checking that the dma-buf still
> belongs to this vfio-pci device and while publishing the descriptor.
> Cleanup clears the dma-buf/vdev association under memory_lock; taking the
> same lock prevents publishing into a dma-buf that has already been
> detached from @vdev, and preserves the memory_lock -> dmabuf->resv order
> used by the move path.
> 
> The attach path reads @revoked without holding memory_lock. Use
> READ_ONCE() for that lockless attach-path test and WRITE_ONCE() for the
> revoke/unrevoke writers to document this intentional lockless access: the
> read is a benign early-out, and a racing revocation is re-checked under
> dmabuf->resv in vfio_pci_dma_buf_map() before any mapping is handed out.
> The annotation only needs to keep the access well-formed against the
> memory_lock-protected writers.
> 
> Reject requests the device cannot consume as a completer:
> pcie_tph_completer_type() must report at least
> PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY, and Extended ST requires
> PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH. Make PROBE follow the same hardware
> gate so the feature only probes as supported when the device can really
> consume it.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>


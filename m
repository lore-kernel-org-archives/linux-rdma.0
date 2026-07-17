Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242523EA9B;
	Fri, 17 Jul 2026 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784249983; cv=none; b=DIbXbXKeV4BwGScYyFc9LaglA8VbzcElNgWrTl8yGhWC04VN96mh0S+YES0GWBTsDT6QIP9H4m+rpAPwUQwtbcvif3igpmf5KD3n9W/s9aubvBOZ6qGq8mtFjSq+EwD4Hi+NHDdXYcc3/Pe4KA5fn/swJuiniC18KFrHTeppB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784249983; c=relaxed/simple;
	bh=C70pd21lKM/GbcDiuX1tX6jo8exVdW5d0qTXY2wTvl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nfCAyDtE03JmT4bAyQ0L3OL5d0DG4/8bhagA7BYf8i9d6LXRQqGI1ROhn3wCptGYAD12f+er3BnaIjCejJv18/aVMtt94wQMUa+caYiB08nJIC8DKe6/2kJ+OZ8CNiMed2VZfgmlqytovQKxl+6Uv5fta8cttdGOucVivt9KNlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6BBT39xb; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6BBT39xb"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nWoZa2YysZYvHhIKyBXhQj2SUK0JAZADfZa/bF6lYtU=;
	b=6BBT39xbWNCt7O0eJH0Jgdc3NtOekMzUgen41y1SfouXyku128rBE2UJLg0LWwom2pJJ2zjJY
	W5zOOCbMRpNTslnTsRyL297Tn35E55/hXfGUaxb5SzJeqs2iph4PIcg1GgEST7LF+QrN7W/nzFW
	6/di4e+HDSqrEIjqwGPP6+0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h1WXw10csz1T4LH;
	Fri, 17 Jul 2026 08:50:24 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 2187E4058C;
	Fri, 17 Jul 2026 08:59:37 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 17 Jul 2026 08:59:36 +0800
Message-ID: <126de128-9090-455a-ba79-14c5a53ad444@huawei.com>
Date: Fri, 17 Jul 2026 08:59:36 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/4] dma-buf: add optional get_pci_tph() callback
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260715204008.3911275-1-zhipingz@meta.com>
 <20260715204008.3911275-3-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260715204008.3911275-3-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Acked-by: Chengwen Feng <fengchengwen@huawei.com>

On 7/16/2026 4:39 AM, Zhiping Zhang wrote:
> Add an optional dma_buf_ops.get_pci_tph callback and a
> DMA-buf importer wrapper, dma_buf_get_pci_tph().
> 
> TPH is PCIe TLP Processing Hint. 8-bit ST and 16-bit Extended ST are
> distinct PCIe TPH namespaces, so the importer requests the namespace it
> can emit and the exporter returns the matching ST/PH tuple or
> -EOPNOTSUPP.
> 
> dma_buf_get_pci_tph() is the importer entry point. It requires
> &dmabuf->resv to be held while the callback runs and returns
> -EOPNOTSUPP when the exporter does not provide PCI TPH metadata.
> 
> The first user is VFIO_DEVICE_FEATURE_DMA_BUF_TPH in vfio-pci, with
> mlx5 as the first importer.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>


Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A62EB10;
	Thu, 24 Sep 2026 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790212438; cv=none; b=AGda3+diohXYWqOHhGE+bsPcV0KYC7+kOe/0wpsSBT0UYd1IkTPhlycaoP1tEPE2VH1sYWEdROZl/KR3Z9efK/2Gcr6AwHpIDkG/soKos97R63BbdrijwKZNhwNB4yOud2APvMDU93Mm1HO6g68gW3r+LKWg5lh4ptmgWYqKpak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790212438; c=relaxed/simple;
	bh=HpgpCSDNVrrbMdkpghl+3RuobrvMeA7OjI3SzX9cmOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WJJ23KQNX6wSo23JcWjmqYSJT0xx324SFCjm4oA8YQUg0RAraU1CQe1ec1rd7o5bYU5cIYp0cvyaS0Xacmb/sxybM4mDTzKnE71E4DFVMZJorz1AqVrz1tyzGjZMUKexAGFdP7PNhzFDPoDDaXdhtYWaPiv26VndRRrdAmvopow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=N8Z7N+uY; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="N8Z7N+uY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ejjww0YvZd/2aF2RB25fAygrE8VohS4ZO/F+ChXYyNw=;
	b=N8Z7N+uY4kp4ilTD4AqnqONCCNCDlHWHOTkdKZQIZ/nY0EYp18BWpeRayonLW5AmJ+3RwWDg1
	/UBFHoNSRaYOoPRH2BBMvHHt8epKRATf+FZCXaHG9i+szVvai8rHavIHEb+zTOV6r6AZB/6HKcZ
	F4RwvxriQ9f3vZZAxKLVQ04=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hqwXQ47ZDz1T4Lb;
	Thu, 24 Sep 2026 09:01:58 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 00E9D4056D;
	Thu, 24 Sep 2026 09:13:51 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 09:13:50 +0800
Message-ID: <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
Date: Thu, 24 Sep 2026 09:13:49 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <20260731211601.3033906-6-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260731211601.3033906-6-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Hi Zhiping,

On 8/1/2026 5:15 AM, Zhiping Zhang wrote:
> Peer-to-peer DMA between a mlx5 NIC and a foreign PCIe endpoint
> (typically a GPU or a vfio-pci passthrough device) traverses the host
> PCIe fabric. The endpoint exporting the dma-buf knows which PCIe TLP
> Processing Hint (TPH) Steering Tag yields the best placement for the
> traffic it will sink: per-endpoint hint selection lets the root complex
> or switch direct DMA to a specific cache slice / NUMA node, cutting
> cross-socket snoop traffic and DRAM pressure under sustained p2p
> workloads.
> 
> Until now the mlx5 importer had no way to learn the exporter's chosen
> ST tag, so dma-buf MRs were registered without TPH and ran with the
> default (no-hint) routing. With dma_buf_get_pci_tph() in place this
> patch wires up mlx5_ib to query that metadata at MR registration time
> for p2p access and use it to program requester-side TPH on the outbound
> mkey. If the exporter has no metadata, fall back to the existing
> no-TPH path so behavior for non-TPH-aware exporters is unchanged.


While working on v21 of the VFIO PCIe TPH series, we got review
feedback that importers must add pci_p2pdma_distance() validation
before retrieving ST values from a dma-buf.

Your mlx5 patch follows the same importer pattern – it consumes
dma-buf TPH metadata. I think this patch should also include the
same distance check.

Thanks,
Chengwen


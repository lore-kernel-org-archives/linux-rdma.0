Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271B02D8385;
	Mon,  3 Aug 2026 01:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785720103; cv=none; b=EhChvgBECVV4jwH6nTwvTaZSecjWaTglqn+M8UPNyB9Xb8Tf9bbHV0j47eqTiNbg1zytcwsPSY5QtZfxIBl6Id06+3cyqD3gogfesV2uEXy+lNNxSobD2kzM1x7fiT53s559Yu0sTyUeFgJrBjz4MZrBca16Oh/QFLez2cl6FOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785720103; c=relaxed/simple;
	bh=xVsG/er4XenXEoZabooGDLTOdUBym6kpLxe9oCMjmaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=syIg7hC/tqUVagOPeRQB5w8bphge12zjV6Ozd37uyIAtNBRJ+sHR/Azl5xNx0jU+DPCUi9IG35N4ivvNCIJlvpOKPVYfOEyan+MhV19rzpjsWKlDN34LDkzJi/9WgBR2iG3jBdNRO+FrMg80ImFIF7ZmCWkLrT5T3J2QVB362Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FDiIXd67; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FDiIXd67"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QBTSQW3rBxxBkqrVdfO4HnXM/A/lDWbO0oY2tB4Prmo=;
	b=FDiIXd67LseMwIsQuHBroN3jP/iBNqZmK1rXL3jwcdCOkPoJJ8Wi7pokOyAAGKgKlPOBqnndy
	rBVCN4FEgCLAK6ccICzlCXDJJyoV2wkfXT3Y3NR0FxAzXpjKKQbDBowyUUfoCO6CVqWU0ThuzuR
	x7XBuTh1QdxcIiCwAlpTN0g=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hCzCy67PRz12LGW;
	Mon,  3 Aug 2026 09:11:58 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0760240575;
	Mon,  3 Aug 2026 09:21:26 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 09:21:25 +0800
Message-ID: <46677117-c0be-4f25-a848-03b4fe9131dd@huawei.com>
Date: Mon, 3 Aug 2026 09:21:24 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/5] PCI/TPH: Add requester/completer type helpers
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <20260731211601.3033906-3-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260731211601.3033906-3-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Acked-by: Chengwen Feng <fengchengwen@huawei.com>

On 8/1/2026 5:15 AM, Zhiping Zhang wrote:
> Add pcie_tph_enabled_req_type() so drivers can query the enabled TPH
> requester mode without reaching into pci_dev internals.
> 
> Add pcie_tph_completer_type() so drivers that publish TPH metadata for a
> device acting as a completer can gate on the "TPH Completer Supported"
> field of Device Capabilities 2 (bits 13:12, PCI_EXP_DEVCAP2_TPH_COMP_MASK)
> rather than reusing requester-side state. It applies the same reserved-
> encoding fold as get_rp_completer_type(), inlined, so the reserved 0b10
> value never reaches callers.
> 
> This keeps pci_dev::tph_req_type and the completer-capability decode
> inside the PCI/TPH code and provides !CONFIG_PCIE_TPH stubs for callers.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>


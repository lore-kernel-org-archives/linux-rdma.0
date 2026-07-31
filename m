Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235736402E;
	Fri, 31 Jul 2026 06:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785478198; cv=none; b=s9836y7bZaCKTHxsk6RkEuCnd+90d+OTTUqcP9EXM2PgetH0SiptHX07kbzvE2jOr601s7tMnFWg/cOpr2eGohEnPcBfIeZdpKOwlxbqdLWVoeMlnzraxgNd206nRuLxpWtP6EH4S/rb+skcCsULuuJuhYq+rxtVPhX90Jkif3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785478198; c=relaxed/simple;
	bh=fHU09IeHbPJu3Fqw/zME/3RU+coYtGy9yRhkMw8hKdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dS1FQit0FTX3cjBB6l04m98q2dhr15drKew2Vh2LnhqNq46L4rZRoIu+K5uurMe2p0KshIU/igrhngDWEgT+lUBl3uVtRwCzoSZNzTbguqWkwsty9J+dpIq46VnCJnRadIv1JjTOUkpzOrpYzka3koEtKmqIEmyM2qohfOJjhPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2spNaG8O; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2spNaG8O"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=krAaybUxov1jqDzEkPx3xMSeUnl1e0hy5hUXESg7+4I=;
	b=2spNaG8OwWP1Un1a0XjnSKCZgE2uzk9JKd1yyHFEMWZ1XYun2s4RM91eEkYvw+rinXLdCl1KR
	7UF2qtoMynKuUwOEJzPfqyzIS5AoGwFItUlTAHcP3rrMy9ReLz3IdVYt++pYwKSeXyEDmq+vaq7
	1qjvRpx4wSi+vZeuFSRCOaE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hBFlq3GKJz1T4JN;
	Fri, 31 Jul 2026 14:00:07 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 957DA40579;
	Fri, 31 Jul 2026 14:09:40 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 31 Jul 2026 14:09:40 +0800
Message-ID: <3eae368a-fad9-4381-99ff-fdd14239639e@huawei.com>
Date: Fri, 31 Jul 2026 14:09:39 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] PCI/TPH: treat reserved 0b10 completer encoding as
 unsupported
To: Zhiping Zhang <zhipingz@meta.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Wei Huang <wei.huang2@amd.com>,
	<linux-pci@vger.kernel.org>, Christian Konig <christian.koenig@amd.com>, Alex
 Williamson <alex@shazbot.org>, <linux-rdma@vger.kernel.org>
References: <20260720172304.117134-1-zhipingz@meta.com>
 <154760d3-a880-4d1a-b949-7d22efb805ce@huawei.com>
 <CAH3zFs0L-k209Ct-uJn9UOctesJRWf6RmVNyD0kfhDdDtpu7JQ@mail.gmail.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <CAH3zFs0L-k209Ct-uJn9UOctesJRWf6RmVNyD0kfhDdDtpu7JQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo500009.china.huawei.com (7.202.194.199)

On 7/31/2026 7:11 AM, Zhiping Zhang wrote:
> Thanks Fengcheng and all!
> 
> Alex pointed out in the vfio/dma-buf TPH thread that keeping this as a
> separate dependency makes the main series harder for review tooling to
> apply, while this patch is a self-contained hardening change with no
> known affected hardware. That makes sense to me.
> 
> Unless you prefer this to remain a standalone PCI patch, I plan to
> include it as the first patch in the next respin of the vfio/dma-buf
> TPH series.

That works perfectly for me, folding this hardening patch as the first
commit in your next respin is fine.

Thanks

> 
> Thanks,
> Zhiping
> 
> On Mon, Jul 20, 2026 at 4:42 PM fengchengwen <fengchengwen@huawei.com> wrote:
>>
>>>
>> Acked-by: Chengwen Feng <fengchengwen@huawei.com>
>>
>> On 7/21/2026 1:22 AM, Zhiping Zhang wrote:
>>> get_rp_completer_type() returns the Root Port's "TPH Completer
>>> Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
>>> 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
>>> into the requester type:
>>>
>>>       pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
>>>
>>> and later writes tph_req_type to the TPH Requester Enable field, which
>>> only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
>>>
>>> No known hardware presents the reserved 0b10 in this field, so this is
>>> defensive hardening rather than a fix for observed silicon: fold the
>>> reserved encoding into "not supported" so only the three architected
>>> values can ever reach the Requester Enable field.
>>>
>>> Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
>>> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
>>
> 


Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6746031A7E2;
	Mon, 20 Jul 2026 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784590970; cv=none; b=hws6ApW5qdVRPijZ/1003dIyYXoTFFRHKSWPh4n27wFTGP+RuWRWO52e9B/VW+EZnRjUGSs4m4RTE7jToum1dkKZPIJA15mTqEA4sWYDU7PKG5I6t3oPYuiQq2Js8BgWgqeWSP5fRoKVH66FmNYMVHrHTSJg9HCu/7QBgvJ0dfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784590970; c=relaxed/simple;
	bh=3DHeJcC3hUoJ/8vd4n5CaYg+/HaX8V+o33nD6KI6YzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lpBLADGFg00WpifvSKBNHBYykwoMWfEVphwsdBZSl7It0p93xESWhNj9Oc5bDKPPF31HrvndkRMAcTENUwL4s0vIbsNHyT5+rrheyMwrF0rr2Tsd8B1gYscLqTyphTgXwqUhxN8ln+7EuzsmF71Rxs+GLK1pEsIRaIWcuqPi750=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NRZxcJSx; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NRZxcJSx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aFr1e2omOUVT+nr0A9sRvK7efGIooS6BQr+q1D7L5e4=;
	b=NRZxcJSxkqFws3ocBIDJCnmw9QCdk9dYcXR1m8mNcp4KIbHMY58UE2jWPnzVYB8W/qEqZnXc2
	Dv1pC7h7YvNe0sZ7nlAkdqXUAA2EYRwoNoMjBbgbn5lAI2vBLol6TboL2uVpIv0YuxaJiN24I16
	MEwGZsmzG65HVsk0JEOHi8w=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4h3xf72sJkz1K96b;
	Tue, 21 Jul 2026 07:33:19 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id ED36F40586;
	Tue, 21 Jul 2026 07:42:39 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 07:42:39 +0800
Message-ID: <154760d3-a880-4d1a-b949-7d22efb805ce@huawei.com>
Date: Tue, 21 Jul 2026 07:42:39 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] PCI/TPH: treat reserved 0b10 completer encoding as
 unsupported
To: Zhiping Zhang <zhipingz@meta.com>, Bjorn Helgaas <bhelgaas@google.com>,
	Wei Huang <wei.huang2@amd.com>, <linux-pci@vger.kernel.org>
CC: Christian Konig <christian.koenig@amd.com>, Alex Williamson
	<alex@shazbot.org>, <linux-rdma@vger.kernel.org>
References: <20260720172304.117134-1-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260720172304.117134-1-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Acked-by: Chengwen Feng <fengchengwen@huawei.com>

On 7/21/2026 1:22 AM, Zhiping Zhang wrote:
> get_rp_completer_type() returns the Root Port's "TPH Completer
> Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
> 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
> into the requester type:
> 
> 	pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
> 
> and later writes tph_req_type to the TPH Requester Enable field, which
> only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
> 
> No known hardware presents the reserved 0b10 in this field, so this is
> defensive hardening rather than a fix for observed silicon: fold the
> reserved encoding into "not supported" so only the three architected
> values can ever reach the Requester Enable field.
> 
> Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>


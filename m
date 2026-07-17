Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE2B16DEB1;
	Fri, 17 Jul 2026 00:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784247404; cv=none; b=GeJbzyCxn3vTq11CaTXDgvs0exCiRXhIci4S7VIu8LkM85pUsfQr69k4AyjLRCXd6g+8fnVRWqVYBZAh+LDgOKCfspp4FduouGLNML8LSqyw4cuTnHkhxDRx2PocRAAvI/mPYGS4My3clQTZg97hICXCW+vLpY5cp+4NFsv+G7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784247404; c=relaxed/simple;
	bh=dDkeumXBcxxpV+nysA0bxBOdPtfCfPkslKv643IhY80=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IrKDhCLWT6FUdWMzbq8TgzIIw0LkhrUFdZNKbkfzFXN7HYZMZpy9A1HMXizuzaSP6sc3FTH+hyceeVo6mK35iBvQJK82PCCI/8G5JNc+t7JEaRAEPq3P6utbB3Q/PzwKqhmmNOXtImiHuX1jM9qbSKOv7x5QJX/WRjJx7r0K3BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AvWpgteR; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AvWpgteR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SYwy6QobYtfLX+TFA3XAHC6CKwVcv5/eHXjCp5polzo=;
	b=AvWpgteRLh7Ai4tN3A9nHSUkPydX2mLUe2z2zpVVLaUx5yc4C9x0rCidbQmHPcMnz2puAedBQ
	oMijff9E3RIGFU6YWhyhDXAbDMcxlwX9mohFxxfX7zmi8yfmIX6GnsEVyOxbNtfNRiD8H2z8QfC
	KrxmpFGDKkc7NUvBhT47PNk=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4h1VbB6yjCz1K96b;
	Fri, 17 Jul 2026 08:07:18 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 18D4540572;
	Fri, 17 Jul 2026 08:16:37 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 17 Jul 2026 08:16:36 +0800
Message-ID: <a855b8da-5ec5-433b-b5cf-177034ae5392@huawei.com>
Date: Fri, 17 Jul 2026 08:16:35 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer
 access
To: Zhiping Zhang <zhipingz@meta.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Michael
 Guralnik <michaelgur@nvidia.com>, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>, Alex Williamson
	<alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	<kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260715204008.3911275-1-zhipingz@meta.com>
 <7dd5c995-a23c-4d3a-9ba0-7fc77972339f@huawei.com>
 <CAH3zFs0Wbz5EYUMQArmUtT-jdAtisafw6e89RWKZJrJpipYQoA@mail.gmail.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <CAH3zFs0Wbz5EYUMQArmUtT-jdAtisafw6e89RWKZJrJpipYQoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo500009.china.huawei.com (7.202.194.199)

On 7/17/2026 4:08 AM, Zhiping Zhang wrote:
> On Wed, Jul 15, 2026 at 6:07 PM fengchengwen <fengchengwen@huawei.com> wrote:
>>
>>>
>> Hi Zhiping,
>>
>> One concern I'd like to raise is the implicit topology constraint of the
>> TPH P2P path. TPH Steering Tag only works reliably when both importer and
>> exporter devices sit under the same Root Port (or same TPH-aware switch).
>>
>> For cross-Root-Port P2P traffic (e.g. P2P devices located in different
>> RC or even socket), most server-grade Root Complexes do not forward TPH
>> prefixes through their internal routing. The ST field gets silently
>> stripped before reaching the target device, so all TPH setup becomes
>> ineffective with no error reported to user.
>>
>> Because cross-Root-Port P2P traffic with ST does not affect the host, but
>> merely the completer may experience some performance degradation because
>> it lacks the TPH hint. In this case, I suggest adding restrictions in the
>> uAPI.
>>
>> A further step is to check whether the importer and exporter are under
>> the same root port. However, this verification will cause the P2P TPH
>> to be unsupported in the case of multi-host or multi-root PCIe switch.
>>
>> Thanks
> 
> Hi Fengcheng,
> 
> Agreed the RC may not preserve TPH across Root Ports (PCIe Base Spec
> r6.4 §6.17.4 requires all intermediate routing elements to support
> TPH, and cross-RP forwarding is optional/implementation-dependent, cf.
> §2.2.10.4.2). But the uAPI can't gate it: there's no discoverable "TPH
> routing" capability -- DevCap2[13:12] (r6.4 §7.5.3.15) describes the
> completer, not P2P forwarding -- and a same-Root-Port check would
> wrongly reject switch and multi-root topologies where ST does forward.
> 
> And it's harmless anyway: per r6.4 §2.2.7.1 an element without TPH
> support ignores the TH bit and completes as if unhinted, so a stripped
> ST just degrades to the non-TPH baseline.

Thank you for your detailed explanation. I agree to maintain the current
implementation.

Thanks

> 
> Thanks,
> Zhiping
> 


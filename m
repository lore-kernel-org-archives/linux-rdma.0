Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792828;
	b=sY/BqSUoNHpI2+udGz6oYvEgZIligtf6SE67k/qqPXICkYsUtM90ZGI61Q7D6nr5V1pf
	 1Hvzm8DifvC7+Gc5kkHbTDBvM1oAFb+qK/AsutMfgxT5tlHw3s3ctjNSxLvFFjFwqqM9t
	 uKKGn1Yg9j8aCl5kZh3X7O95It9YOj4Ruh9pGxDPpwZUoKkwe9AJsZoIOnuLjwayVbDH4
	 hhuHakRU2D9UjikYlUIHhFHAfDtDNnl4r2nV/bbggdZT8nPJXiV14J845vSbV0LeRu1K2
	 PfVAb0/H+gq8IsssfttL2GjyEVQhp/5cI+7Hx6ZoVaT5vdb0ICyhL2xzMvLx4vtKUJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792828;
	h=DMARC-Filter:DKIM-Signature:Message-Id:X-Lms-Return-Path:
	 Content-Type:Date:Content-Transfer-Encoding:User-Agent:
	 X-Original-From:References:In-Reply-To:Received:Mime-Version:To:Cc:
	 From:Subject;
	bh=Ff5JZSPNEuNIye63t7X6NTIFmNJCPxejiNHNKQKzrAM=;
	b=1tq5KXXA2zRnMD43N1IQw3izZagiaM1zCOi5poyC6vXTtmrR4RKIVmHj11X6x8uLC+/f
	 3oLYI1abIkyLO9+1CqpvzyMGlCglLgP6dmMfK1xGQJnKxCK4zVDE0X93e9yhA/qEaRNsG
	 KgkQqyTIZUvzBnLvyplSnAiK+SZB0TbKrJBvEn6LVcciRcO1DyKGq7yFeW5mWRb3Ofpie
	 KUOQD0hDGn0VJNzNG8SGeFsFweDJsLEG8Jhz3XuOIAgNX+QdNqVvdjyqzEuxfH6rLiHiD
	 fmJA/dyjY9wLxMYCK1nDCUdz7TGB+9ddS0h7ohvthporYuE3hiL6TBn5K4PtvgZuxfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=j2sFxhnt;
	arc=none smtp.remote-ip=209.127.231.29
Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CB0606A32C
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 11:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18CB0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=j2sFxhnt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793792823; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Ff5JZSPNEuNIye63t7X6NTIFmNJCPxejiNHNKQKzrAM=;
 b=j2sFxhntiruHhEgiDipIVdldJpUhis2cqWL/JXORDUy7UQcbLtmRcX06D0I7Jm4r6CSSmJ
 miLkgdGoqP31Dxf4YxF+yBgCyenTCgOr4rJ50teuYMLgKGu3czoO2AAJmNNdAruLmy/Lv1
 u5RTLDoVmf2BpdNhju1U6I8zHSZNmnzYOCc3vkuYuI48t6Hqqkt04zTKbcHJK4gZel4ra5
 00687ZzRe0ixDkOXnufc7I1b0pmurPLGB2ZQN9HoE63hNX8ETWSlVh7GIG/d3o846T212W
 sivwnVCZd2rZsPDBLsqLjajK4E64z508eCSVe1jevIvH6GfbutZX3fZBrW1Z3A==
Message-Id: <8f242876-3411-4d50-9e4e-548fa8e026f6@yunsilicon.com>
X-Lms-Return-Path: <lba+26aeb1b36+52f227+vger.kernel.org+tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 4 Nov 2026 19:47:00 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Original-From: Xin Tian <tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com> <20261013143417.GQ219304@unreal>
In-Reply-To: <20261013143417.GQ219304@unreal>
Received: from [127.0.0.1] ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 19:47:01 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
To: "Leon Romanovsky" <leon@kernel.org>
Cc: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	<weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: Re: [PATCH 00/15] Yunsilicon ethernet and RDMA drivers

On 10/13/2026 10:34 PM, Leon Romanovsky wrote:
> On Mon, Oct 12, 2026 at 07:44:32PM +0800, Xin Tian wrote:
>> Hi all,
>>
>> This is a new submission from Yunsilicon to upstream our converged
>> network adapter driver.  The hardware is a dual-function PCIe device
>> (PCI vendor 0x1f67) that supports both ethernet and RDMA operations.
>>
>> The series adds three drivers, which share the xsc prefix.  A shared PCI
>> core driver binds to the physical function, brings up the command queue,
>> the event queues and the interrupt handling, and publishes one auxiliary
>> device per function.  The ethernet and RDMA drivers bind to that
>> auxiliary device instead of driving the PCI function themselves, so the
>> two personalities share a single probe and resource set.
>>
>>    1. xsc_pci - the PCI core driver (CONFIG_YUNSILICON_XSC_PCI).
>>       Owns the PCI function, the command queue, the event queues, the
>>       interrupt vectors, the register access layer and the CQ/QP/SRQ
>>       resource pools.  Patches 01-05.
>>
>>    2. xsc_eth - the ethernet driver (CONFIG_YUNSILICON_XSC_ETH).
>>       Registers the netdev, implements the TX/RX packet paths with NAPI
>>       and page_pool, RSS, checksum offloads and statistics.  Patches
>>       06-08, on top of the core.
>>
>>    3. xsc_ib - the RDMA driver (CONFIG_INFINIBAND_XSC).
>>       Registers the ib_device and provides the PD/MR, CQ/SRQ/AH and QP
>>       verbs including the send/receive data paths, plus RDMA counters an=
d
>>       sysfs attributes.  Patches 09-14, on top of the core and the
>>       ethernet driver (the netdev supplies port state and GID).
>>
>> Patch 15 adds the MAINTAINERS entry.
>>
>> The series is split so that every commit builds: the core patches
>> introduce the register access, the command queue, the event queues and
>> the resource pools incrementally, and the ethernet and RDMA patches only
>> start creating queues once their dependencies are in place.  Patch 05
>> (core CQ/QP pools) is deliberately shared by both upper drivers; that is
>> why it precedes the ethernet patches.
>>
>> The RDMA device is registered at patch 09, before all verbs exist, so
>> kverbs_provider stays false until the mandatory verbs appear in patches
>> 10-13.  This keeps each intermediate tree compilable.
>>
>> Please review.
> Please run Sashiko locally first.
>
> Before we begin an active review of a new driver, we expect it to have
> only a small number of Sashiko findings.
>
> Thanks
Hi Leon,

Understood. Sashiko was run locally twice and the findings were addressed.
I'll post v1 shortly to see whether the Sashiko run on the list finds
anything we missed=E2=80=94happy to fix whatever remains.

Thanks,
Xin Tian

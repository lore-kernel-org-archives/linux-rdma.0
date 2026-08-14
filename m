Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737A5346A11;
	Fri, 14 Aug 2026 04:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786682380; cv=none; b=hvkSyvLVq2o9/ycQ3l8mqoffF4uXHlOQsiE5z5NhU0KyyWvPlghNaaVW8ZSgT6e5qXADUFctBiBDsYQ2zkQ6tvU+cSXhsh6kmig3PZQ4q28R7jGmKeaZ2xXIhpcsI+zorPcO1Lt3Nfz6KeWEIwlMg6hf6ceE32x3/k74fp29dV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786682380; c=relaxed/simple;
	bh=l7MlkFcx5aXhWYUWVpvxGnnEJL694R59rO1Mj51uBK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i2mTNVR4IuvTIDGnroG3yqwZ69/2z3liV04yeAuP9bAhTRQAARB2kpj4z5Tr2U+EjcAxk6oowDaPRUtv9KIXURdevLsaQmdaiMb3epvpYVEKOUzQtG3PWzXH8hilNoXbG2NpYEA9WrVhidxP6cPNnFSt13tUHLLoQZC6VMLknm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dj4mOji6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dj4mOji6"
Received: from [192.168.1.72] (122-34-238-49.southernonline.net [49.238.34.122])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0A95420B7168;
	Thu, 13 Aug 2026 21:39:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A95420B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786682352;
	bh=MOe6fLrAlEx+A1d/mzHUXYx7j4HKsqNLoNeyfEBpCRA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=dj4mOji6sNNHg2ML9OZz9BI3QnqKeaIsoVJTvB66q7ZSMa5/q4RyxB+DK5iwGA+0R
	 Og4XPWds2BmdU6xVlU1uoFQtxoLhNJFcDQYuinIjNC8qu6BbBb35Pvml4mEfG07ebw
	 MnOoDf99zko/yOHk6puzpuEvhP1leJnsvoGci72s=
Message-ID: <c8d403ee-641e-4b7c-90e3-41839b9a8bff@linux.microsoft.com>
Date: Fri, 14 Aug 2026 10:09:28 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/2] net: mana: Avoid DMA queue allocation
 failure under memory fragmentation
To: Paolo Abeni <pabeni@redhat.com>, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, kotaranov@microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, dipayanroy@linux.microsoft.com,
 shradhagupta@linux.microsoft.com, kees@kernel.org,
 sgeorgejohn@microsoft.com, ssengar@linux.microsoft.com,
 gargaditya@microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
 <711d525c-cfc6-472c-b073-0fcfc9f95b14@redhat.com>
Content-Language: en-US
From: Aditya Garg <gargaditya@linux.microsoft.com>
In-Reply-To: <711d525c-cfc6-472c-b073-0fcfc9f95b14@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13-08-2026 17:12, Paolo Abeni wrote:
> On 8/7/26 10:56 PM, Aditya Garg wrote:
>> The MANA driver can fail to bring up its queues on systems with high
>> memory utilization because every GDMA queue ring is allocated as a
>> single dma_alloc_coherent() of the whole power-of-2 ring size. Under
>> memory fragmentation these high-order allocations may fail, preventing
>> the driver from creating queues when opening the interface, after a VF
>> reset, or when reconfiguring channels, ring parameters or MTU.
>>
>> Per-queue sizes that are problematic, with depth and size given as
>> (default, max) over the ethtool ring settings:
>>
>>    ring                  entry  depth          size
>>    ------------------------------------------------------------
>>    TX completion queue   64 B   (256, 16384)   (16 KB, 1024 KB)
>>    TX send queue         32 B   (256, 16384)   ( 8 KB,  512 KB)
>>    RX completion queue   64 B   (1024, 8192)   (64 KB,  512 KB)
>>    RX receive queue      32 B   (1024, 8192)   (32 KB,  256 KB)
>>    event queue           16 B   2048 (fixed)   32 KB
>>
>> This series addresses the issue by:
>>    1. Routing all CPU-side ring access through mana_gd_ring_ptr() and
>>       mana_gd_ring_contig_avail(). On a contiguous ring these reduce to
>>       simple arithmetic, so this patch is a pure refactor.
>>    2. Falling back in mana_gd_alloc_memory() to a vector of scattered
>>       order-0 coherent pages when the contiguous allocation fails. The
>>       device sees the same page-list format either way, as
>>       mana_gd_create_dma_region() already describes a ring as a list of
>>       MANA_PAGE_SIZE addresses. The HW channel stays contiguous, as
>>       advertising a scattered page list needs the HW channel itself.
>>
>> Throughput testing confirms no regression. Since the fallback only
>> triggers under memory fragmentation, the scattered-page path was enabled
>> unconditionally for all eligible GDMA queue rings during testing (iperf3,
>> Gbit/s):
>>
>>                   Baseline    Patched     Patched
>>    Connections   Contiguous  Contiguous  Scattered
>>    -----------------------------------------------
>>    1                  46.1        46.2       46.1
>>    16                 182         182        182
>>    32                 182         182        182
>>    64                 182         182        182
> Given the above, I suggest to follow-up and remove entirely the single
> dma_alloc_coherent() allocation; you will get simpler code and less
> pressure for later dma users.
> 
> /P

Thanks for the review, Paolo!

I got these throughput numbers from an idle system running only iperf3, 
so we're not sure whether they would remain the same with other 
workloads running in parallel. I'll try to get these numbers as well.

Also, our hardware team indicated that this fallback leads to additional 
resource consumption on their side. I'll check with them and post a 
follow-up.

Regards,
Aditya

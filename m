Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363F2EDD69
	for <linux-rdma@vger.kernel.org>; Wed, 29 Apr 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478674; cv=none; b=eL5+JM0Xl/beJZHE5ZZtCrs1nS+mQAvZE0zE5jG1XF9j4d6Hc4xOuvqfMWvWc/X8kdVbdKp1MBw7BbsPXT/X2VMzYRYX0+vWsaFZ3FE07zGpkU1za16Hgh+o4ypF8vxfvTqXPjuHS5L2AatSc8c6+4fNoIVrHzsR6O1RvVhhBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478674; c=relaxed/simple;
	bh=qG7kr8Ms/PBiIXPO+nJkfeDaNPmqqc0GifexNjHfKxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O/KFpU2q/kL8Hmrf7Nt3CBpiRuVlQqro4DihD/lkLrXRHS722H67xQAlIlck+JR4eoza9v3r5/xkPhAOLbjkY7go/js9K6IO8O5SzADrNvr1s/Gd9IpUfEP/OcXn7nIn/jdVm6zPe4k2smQUnOu1XPNsB3YCSHZMb9slE0msbaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XuX4RpXW; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XuX4RpXW"
Message-ID: <58485c92-0ee5-4927-b9e4-dd4858219b17@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777478670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gPZrBoLsbuD0OEZX2ZqYvNJjGhWHSghCFzaorvk3Iys=;
	b=XuX4RpXWFkltBmr0ckMvYnhUOSSjvZS95312VHHONYi1r8kpkbtEexqiAdK0R4aXZWb0sn
	QPP/VRfHqzyIhc3s6wVXBtTQb3m3wZcn/5tNglhhZJX5poyVZEjPZUdZywFievMVRWDalf
	qACNR+B7Krp5kQP1hQ67U8AbNNjXDOg=
Date: Wed, 29 Apr 2026 18:04:15 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH] RDMA/siw: use kzalloc_flex
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: rosenp@gmail.com, leon@kernel.org, kees@kernel.org,
 gustavoars@kernel.org, linux-rdma@vger.kernel.org
References: <20260421192821.2305-1-bernard.metzler@linux.dev>
 <20260428155536.GA2774550@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260428155536.GA2774550@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 28.04.2026 17:55, Jason Gunthorpe wrote:
> On Tue, Apr 21, 2026 at 09:28:21PM +0200, bernard.metzler@linux.dev wrote:
>> From: Bernard Metzler <bernard.metzler@linux.dev>
>>
>> Simplify umem allocation by using flexible array member.
>> Add __counted_by to get extra runtime analysis.
>>
>> Suggested-by: Rosen Penev <rosenp@gmail.com>
>> Signed-off-by: Bernard Metzler <bernard.metzler@linux.dev>
>> ---
>>   drivers/infiniband/sw/siw/siw.h     |  4 ++--
>>   drivers/infiniband/sw/siw/siw_mem.c | 19 ++++++-------------
>>   drivers/infiniband/sw/siw/siw_mem.h |  2 +-
>>   3 files changed, 9 insertions(+), 16 deletions(-)
> 
> Sashiko has quite a few interesting things to say about this:
> 
> https://sashiko.dev/#/patchset/20260421192821.2305-1-bernard.metzler%40linux.dev
> 
> Jason
Excellent. I thought about that issue, but probably my
conclusion that's all right is just wrong.
I'll rework.

Thanks,
Bernard.

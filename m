Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0026B40D58E
	for <linux-rdma@vger.kernel.org>; Sun, 28 Jun 2026 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782690934; cv=none; b=MK0HCP1sC52Hy9DWEtzNjLRAxCBVNQ5DJIPDDPNtuKHSIZbnSpCdsgGokv5WYZMt02kCfZLkkQXNu3KZ9UzZkb723R9aMNTcge7H9scTyJENBWgS8c5JLI3tapJsYnnKIMtqIdW2nhU1e4b43KJHcNPtM7WIQo7MV0wjFlm8Qzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782690934; c=relaxed/simple;
	bh=1iGzbc/ihiojGypt1O30+8mo7mH0LgpOsPvWYUZLeCE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J1y5X+R0E3VMM1p6EMNMk7ll9fO/ZM1F/tl7ue3k8Q6TPXvjwMsOMos+tGCQpAaOZeve0E0hymK/e2HPJL8UMf12JJIlBgEn+J9G2BZoXOOUcmWeqKgRSbSbfZEnvJe5E5WtKM6cPqZhhyIcjhHjr0YDCp9m8S8RLkYiIX/ik1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ml0u0fnx; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ml0u0fnx"
Message-ID: <0892f5e8-7ca4-4efc-a002-8c1ed244b18e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782690929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWJ9m0B2lARXAerF+kQRyl3GwQ7mSztH/5H45745C7k=;
	b=ml0u0fnxeOD3TDUQoQBKFWCstaPO5JjU8s3x+N71MCNi9B9tXSfYscQzhI2Sb1wpggERiC
	PxpqearG1H4OKQLoskDaWvUI5fW+iWc/VyWFW3yh7Thfhvj2Ncqoz9p+OxDW3zblWY4Jq9
	ozCEs7Jdoh4uJN+j1BVRpnCSlYs9qXM=
Date: Mon, 29 Jun 2026 07:55:22 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH iproute2-next v3] rdma: display resource limits in
 curr/max format
To: David Ahern <dsahern@kernel.org>, leonro@nvidia.com
References: <20260615005315.169582-1-cui.tao@linux.dev>
 <4d98d9a3-07e1-4333-b040-c72e5f561a63@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <4d98d9a3-07e1-4333-b040-c72e5f561a63@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi David,

Thanks for taking a look.

The kernel counterpart that introduces this uapi attribute is the
following patch, currently under review on the rdma list and not yet in
Linus' tree:

  [PATCH rdma-next v3] RDMA/nldev: add resource summary max values for usage display
  https://lore.kernel.org/all/20260615003646.168704-1-cui.tao@linux.dev/

That is the one adding RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX.

You're right that the iproute2 side should reference the kernel patch.
I'll add a Link to it in the commit log of the next revision, e.g.:

  Link: https://lore.kernel.org/all/20260615003646.168704-1-cui.tao@linux.dev/

If you'd prefer, I can also hold this iproute2 patch until the kernel
side has landed, so the uapi is already in tree when it goes in. Happy
to do whichever you think is best.

Thanks,
Tao

在 2026/6/29 01:22, David Ahern 写道:
> On 6/14/26 6:53 PM, Tao Cui wrote:
>> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
>> index 4356ec4a..e5b8b065 100644
>> --- a/rdma/include/uapi/rdma/rdma_netlink.h
>> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
>> @@ -604,6 +604,11 @@ enum rdma_nldev_attr {
>>  	RDMA_NLDEV_ATTR_FRMR_POOL_PINNED_HANDLES,	/* u32 */
>>  	RDMA_NLDEV_ATTR_FRMR_POOL_KEY_KERNEL_VENDOR_KEY,	/* u64 */
>>  
>> +	/*
>> +	 * Resource summary entry maximum value.
>> +	 */
>> +	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,		/* u64 */
> 
> I do not see this uapi in Linus' tree. What is the status of the kernel
> commit? Put a reference to the kernel patches in the commit message.
> 


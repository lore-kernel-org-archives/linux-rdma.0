Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501953446C7
	for <linux-rdma@vger.kernel.org>; Thu, 12 Feb 2026 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770915458; cv=none; b=mmU9Z/aaHxoqmgtEuP3FntewqV3kddTqR3LWxMHdxgUT/wfoDDnrVSApL1wc66lP4Z++Wm6ljnN9Cbn6JcFYfSmR0egYhX50+rESjF/XsYenLwAKlcZL5Y5q8kr+OZ8GjzbX9PvP10zzfyCvUuzidfzqlhCtm2WNdFfQBBRv5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770915458; c=relaxed/simple;
	bh=1bqn3Lthfpqi/grsqw8jP4+iILhvlPXLJLm72ebuOXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0Qn7LV/SXMh2a+zGfiYkRS0XAXy+H5KLhb1LegXw1oM610/R6jE6xdGrXtVjOGv9vAm8IRc4HlNnSwl0JkoRHq3ZPhhjJwMCHnzuy/YBNjlXvnoBFu5mh0GLqBgCcCpAM/DFStwj01YxlDxaqX6FP7fpHiXgvkssCG/KYaoz6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nv9m5ULk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nv9m5ULk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BCFC4CEF7;
	Thu, 12 Feb 2026 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770915458;
	bh=1bqn3Lthfpqi/grsqw8jP4+iILhvlPXLJLm72ebuOXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nv9m5ULkSlYnD4YnflKCGVWBN7nQYKLuc8+G5KrekOsV2EDImnPHJOJ/t2ii3SHdz
	 Vjkp4AsIdSqfAClj0eZjlCS5P2kBRdgN4YfSRO2MeSS8nt1Zx0/HfFomZDVuW9ALX+
	 v1lEk6K8iLnxRdAb+ASVN2N6Zb67+FVolfBMmah+7SVQtWOGNe2+7+cimuI8hznPgq
	 4/v86AHEIFQrkVAKTtlQR18YYCyTXhih3BgBPpD0vuUzjcwRYyZ8iCJhBlF/1Eh7XN
	 kb9L0SuODXzTfwNGY92DJBO45AXaWcPxYQlc4fnMvcnXGaJXNyW609vMNv6QgOF8qN
	 JLO/menmadH9w==
Date: Thu, 12 Feb 2026 18:57:34 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linuxarm@huawei.com,
	tangchengchang@huawei.com
Subject: Re: [PATCH for-next 3/3] RDMA/hns: Support congestion control
 algorithm parameter configuration
Message-ID: <20260212165734.GI12887@unreal>
References: <20260206103110.3414311-1-huangjunxian6@hisilicon.com>
 <20260206103110.3414311-4-huangjunxian6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206103110.3414311-4-huangjunxian6@hisilicon.com>

On Fri, Feb 06, 2026 at 06:31:10PM +0800, Junxian Huang wrote:
> From: Chengchang Tang <tangchengchang@huawei.com>
> 
> hns RoCE supports 4 congestion control algorithms. Each algorihm
> involves multiple parameters. Support configuring these parameters
> by debugfs.
> 
> Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_debugfs.c | 278 +++++++++++++++++++
>  drivers/infiniband/hw/hns/hns_roce_debugfs.h |  25 ++
>  drivers/infiniband/hw/hns/hns_roce_device.h  |  25 ++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c   |  66 +++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h   | 140 ++++++++++
>  5 files changed, 534 insertions(+)

Please remove all these complexity, delayed work, multiple configuration options in one file,
provide one directory with multiple files. Each file is a key, which can accept multiple
values and not like it is implemented now.

Also, please add examples to this commit message.

Thanks

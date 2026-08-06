Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C0E2DCBF8;
	Thu,  6 Aug 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006468; cv=none; b=HxVzr2HjWY5j94HbVlrRCxhD5+yvQeL+smJJq1m8y+cYeNCCXLlmLXsAr1OxXir/SZXqKFRIw7RlDu3mkk8TZrlm9LPKZh5TexJrqHraW1De7Eh0Tasl27PfmWGqGIEub4sAMimZuE1AoKBCRgzi93PKlhRialFhBdFC14Y3AVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006468; c=relaxed/simple;
	bh=l+ox+pql1Ler/vWYPalqfK92yRK3YuHK9nR2ZpuRlfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gqpTK/L5NRMZ2DJFFLEQl2zWu79WyrG7V7T1nct3dQNAAi0V7/DprKJ1aV+gCHSkxVaE+x/mp/lYoj/bizkOWm0A+ysadKJZjybHJmL3hmpXdcoflfxiQumyM46qiTKqTbaEBeMFXN/PuZtFSPcQ7qCGWr27WmjoCrxwP/NATOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jj1FXq1y; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jj1FXq1y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786006462; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SWwBiJYDyRTkTnbxgSxuvjbEy/vwGbVGvztmA/3oOrg=;
	b=jj1FXq1yT9tQCXqB3uSR3wVLxrobOLI+1qetyL0iZM/exBQX7SgeGosv33OASBQz8SceJPnPS1KeOByVZnSWuFVn342m43PQL3xeBB3n4sxMaRUZkl+iuydxO1/g892cA0/3qDAtWR1NWzhsiRkka9uAi3FAWxRrWvVNdQo0JiY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X8TXBQl_1786006455;
Received: from 30.221.122.232(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X8TXBQl_1786006455 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 16:54:21 +0800
Message-ID: <a7df8139-4f1d-b87e-176d-9702e29a5e07@linux.alibaba.com>
Date: Thu, 6 Aug 2026 16:54:09 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH rdma-next] RDMA/erdma: restrict the driver to
 little-endian systems
To: Leon Romanovsky <leon@kernel.org>, Kai Shen <kaishen@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com>
Content-Language: en-US
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/6/26 4:48 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The eRDMA device interface requires explicit byte ordering, but several
> DMA-visible values that should be little-endian remain native-endian.
> Command request payloads are copied verbatim, data-path SQE headers are
> written without cpu_to_le64(), and kernel doorbell records are assigned
> plain u64 values. The command completion path also reads a little-endian
> SQE header without conversion.
> 
> These paths are byte-swapped on big-endian kernels and can break command
> processing during probe. Since complete big-endian support requires
> converting every device-visible structure, depend on !CPU_BIG_ENDIAN.
> 
> Fixes: ca7fd6cff3b8 ("RDMA/erdma: Add driver to kernel build environment")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> RDMA/erdma: restrict the driver to little-endian systems
> ---
>  drivers/infiniband/hw/erdma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Cheng Xu <chengyou@linux.alibaba.com>

> diff --git a/drivers/infiniband/hw/erdma/Kconfig b/drivers/infiniband/hw/erdma/Kconfig
> index 267fc1f3c42a..745e5551773f 100644
> --- a/drivers/infiniband/hw/erdma/Kconfig
> +++ b/drivers/infiniband/hw/erdma/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config INFINIBAND_ERDMA
>  	tristate "Alibaba Elastic RDMA Adapter (ERDMA) support"
> -	depends on PCI_MSI && 64BIT
> +	depends on PCI_MSI && 64BIT && !CPU_BIG_ENDIAN
>  	depends on INFINIBAND_ADDR_TRANS
>  	depends on INFINIBAND_USER_ACCESS
>  	help
> 
> ---
> base-commit: 961ac0f0c5e414abdd6b33fae84b311d9fde0bd0
> change-id: 20260806-missing-endianness-conversion-for-64-f0af69246071
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>

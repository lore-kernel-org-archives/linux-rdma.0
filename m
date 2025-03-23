Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0121AA791
	for <linux-rdma@vger.kernel.org>; Sun, 23 Mar 2025 07:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742716454; cv=none; b=rfPAktCn1pERAGiYc34hiJnZ7iotHg3UXjpmZeqwmJ7+kRTTopq2iw/yKyJxDmw88uiDsKOEg2a6Uez18x2ApiEVFMd47PrYSVWtK5slFbtdWp7LCd3YKsR4L969WNIJTsLfnS/MOxVLFs8xc272jEQlLIHH3P4LdqULHmhrLKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742716454; c=relaxed/simple;
	bh=HHEpaAJIzWRT4YdDqeqbPHxYUCXXpvTHQQEsYxq+nLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+yMmCV6lMXUYcHfuhmcGq47QiQ3wUgslB+JFC9fsgwKkmTMDHBM85xzanvbHikZ3XZlmsINSlZFWGM0pqJ8TRq1wX5cXuTbImJYil91HepjhT2hdDtEBERp0REpFfkR9fv8fT8MrrrfAtZbPRj1UR3Tfm67sY8LaL8kLIeUdjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XMOSs9oK; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XMOSs9oK"
Message-ID: <6d37fe4e-91ed-4b65-b729-5de69e8655a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742716449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t91weCdocCs8WtmddblHqpl+hrIaErsXsrsdkt1n15c=;
	b=XMOSs9oKmSOjB+RYeChs4oc5PlKkB6m63RJKZxCGdeTeFoiF7YF0A1OseZKUrJCeCI4W41
	3uP6S4z5QLuO2K0uZfdBgOEBQTLB2eY0ZNNyacclo6Bl3cYp+RNg2ojgvtp/gCXPNaG39U
	l8wT0Erzd0yUBkB/DpyzhUzXWYweDGA=
Date: Sun, 23 Mar 2025 08:53:50 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH -next] RDMA/usnic: Fix passing zero to PTR_ERR in
 usnic_ib_pci_probe()
To: Yue Haibing <yuehaibing@huawei.com>, benve@cisco.com, neescoba@cisco.com,
 jgg@ziepe.ca, leon@kernel.org, liyuyu6@huawei.com, umalhi@cisco.com,
 roland@purestorage.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250323033414.1716788-1-yuehaibing@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20250323033414.1716788-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2025/3/23 4:34, Yue Haibing 写道:
> drivers/infiniband/hw/usnic/usnic_ib_main.c:590
>   usnic_ib_pci_probe() warn: passing zero to 'PTR_ERR'
> 
> Use err code in usnic_err() to fix this.
> 
> Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>   drivers/infiniband/hw/usnic/usnic_ib_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> index 4ddcd5860e0f..e40370f9ff25 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -587,9 +587,9 @@ static int usnic_ib_pci_probe(struct pci_dev *pdev,
>   
>   	pf = usnic_ib_discover_pf(vf->vnic);
>   	if (IS_ERR_OR_NULL(pf)) {
> -		usnic_err("Failed to discover pf of vnic %s with err%ld\n",
> -				pci_name(pdev), PTR_ERR(pf));
>   		err = pf ? PTR_ERR(pf) : -EFAULT;

When pf is NULL, PTR_ERR(pf) will warn "passing zero to PTR_ERR". Thus, 
if pf is NULL, the err will be set to -EFAULT.

But from the current implementation of "static struct usnic_ib_dev 
*usnic_ib_discover_pf(struct usnic_vnic *vnic)", it seems that pf can 
not be set to NULL.

But this commit can prevent this warning when the implementation of 
usnic_ib_discover_pf will be changed in the future.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> +		usnic_err("Failed to discover pf of vnic %s with err%d\n",
> +				pci_name(pdev), err);
>   		goto out_clean_vnic;
>   	}
>   


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563240929A;
	Wed,  8 Jul 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526085; cv=none; b=NRdAJ/DruzB3vhEvHGMri0SflCMzNMnFv23BK9MDPx5qc0IdoMDsSO9cB/Dqu5fm6VSWpSeRhPgpgUYaVTtSjDO6A5y0sOTMlR98IpnxdPZ9Kq31zUBoplLy3HehILt1t/Sgm1WsJk4pv5gLcnEPdGV6q9e1jhSkY2kWuBXf/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526085; c=relaxed/simple;
	bh=DLS6VSSemakoBkDhOWGR9m6sSSKE9/Pp9lCNn8ra+wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNkCtMqHUldVF63zFuWTPOFPhDHFqgUkMmRtBLhi1rXJH2WfLaJq8iYNu2aMo8SjVMLixJkpED1wzDjgglCcpvVdhex/00nqvCdFqQU6zyAADyDeLiz5w8FW93nNNW1LiIZGZ1JZmc3oStSVWdGmSWWlm1QyD+JiLVAIXDlIz9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2vMsTpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2vMsTpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC5C1F000E9;
	Wed,  8 Jul 2026 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783526083;
	bh=KKAzj4n0YE1Xa5FzF2BSDGqiRzx/bn1JAO4Hbd9XW3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2vMsTptkfou8lJ8jzolPg3/0xKJCLpVP+OC6NWBWhuhi2wRw/PBETlfPiarBWa5J
	 Y3RJBIcl9zC4LhRGo6tyTM/u9MHQyp65ntFqPd/GRpTzqmvK3l2kEMawiWoyDV309S
	 YgEh3zalFpXny0RSXoC2EZT1rK2u1/a7XJaQrpIJWqTt+jz/lP12UYKS7o8VmadOWA
	 HQRyyQ0XqXTg81E5uXsMBNBou5mUhcN1GuGMkz1MNNaaN+8OU4dTNXMUdxLGsvsDTn
	 js5lqOO/cLw31ArXnYH9M0tRVWAIi/Yp0cjOOiS1HvrlKa2fI1d7LDX/J7Jhx4inyc
	 iibPs0xov9kdA==
Date: Wed, 8 Jul 2026 18:54:35 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alexander.Chesnokov@kaspersky.com
Cc: xuhaoyue1@hisilicon.com, David Laight <david.laight.linux@gmail.com>,
	lvc-project@linuxtesting.org, Oleg.Kazakov@kaspersky.com,
	Pavel.Zhigulin@kaspersky.com, stable@vger.kernel.org,
	Wenpeng Liang <liangwenpeng@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Xi Wang <wangxi11@huawei.com>,
	Weihang Li <liweihang@huawei.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/hns: Fix arithmetic overflow in
 hns_roce_v2_set_hem()
Message-ID: <20260708155435.GO15188@unreal>
References: <20260707140938.3106919-1-Alexander.Chesnokov@kaspersky.com>
 <20260708092146.3325855-1-Alexander.Chesnokov@kaspersky.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708092146.3325855-1-Alexander.Chesnokov@kaspersky.com>

On Wed, Jul 08, 2026 at 12:21:46PM +0300, Alexander.Chesnokov@kaspersky.com wrote:
> From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
> 
> If hop_num is 2 or 1, then the expressions like
> i * chunk_ba_num + j are computed in 32-bit
> arithmetic before being assigned to a u64 index field,
> which can lead to overflow.
> 
> Declare i, j and k as u64 so that the address index
> arithmetic is performed in 64-bit.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: a81fba28136d ("RDMA/hns: Configure BT BA and BT attribute for the contexts in hip08")
> Cc: stable@vger.kernel.org
> Suggested-by: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

Please resend this patch as standalone message without "Reply-to".

Thanks

> 
> ---
> Changes in v2:
> - Instead of casting the operands to u64, declare i, j and k as u64
>   so the index arithmetic is performed in 64-bit (David Laight).
> 
> v1: https://lore.kernel.org/linux-rdma/20260707140938.3106919-1-Alexander.Chesnokov@kaspersky.com/
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 1c180a6b1c07..3469a9a68d3b 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -4238,7 +4238,7 @@ static int hns_roce_v2_set_hem(struct hns_roce_dev *hr_dev,
>  	struct hns_roce_hem_mhop mhop;
>  	struct hns_roce_hem *hem;
>  	unsigned long mhop_obj = obj;
> -	int i, j, k;
> +	u64 i, j, k;
>  	int ret = 0;
>  	u64 hem_idx = 0;
>  	u64 l1_idx = 0;
> -- 
> 2.43.0
> 

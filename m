Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BBC17D6
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 09:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788685959; cv=none; b=UToKOJtdQRDtV/KvLbV4Cq2d4Y/9CutYLgnZIqFIkDEYc0jHtuR/EvLZXM6+SfN46vWSJlURoI5sTIbU90+JaXosR2Kb9VP4WmHVuK7PGXJjR0MLog+l2s4bL6wL4kV4fyzdxLtFKOpIyptFtI5kNFpAqrD4U3FDAMIitBul3N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788685959; c=relaxed/simple;
	bh=0h+eFub3ASGS8lbV2R+wEjSjQlq2I6Uw4ooOM92nSR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBABz7XwkGRoZik/zCBCcVJnsIWjosqGi9ulJTGDspQwVeTFrT0KxdTUMF0eKQ+UmMf7EEol3kFIdFa5fb1DmL3nlNvFUPCJeyuq+vkxTXOanVwP2fkiJPGkbWB+RTHSXDAYnFLLdswWkVyPFeU7hInJ0is2Pc5CfF5Nr3UzfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6hvvdxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6hvvdxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDD21F00A3A;
	Sun,  6 Sep 2026 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685958;
	bh=g+3/dNBulvGbmZJyOt1ia0LrZYsTGmANz8zY/ReD0FQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P6hvvdxIC6NB0XroWcY1aOtLPfMGYtT6kDmXpLEE8cKZDNGYgNg9LbxK45HCZiN7C
	 9DgciUDkUe5rj1rgLaek40pD8Dg+G4QdER7ntEXoU0+ezFJtRAVEIzXN8Nn9mWE8pc
	 vHt1Akfjtlp3OikfUoXBwXVAZJ3B6InBWFTPs6XjjuZImNZCaYgxQRrfdatDdikNJL
	 k/VsaLcb9j4GWtlPw1puAn+kSmDfi3IKfAlKS0TmtOeJYizeKtG9N/EJnp7bhr5r/z
	 RQZUJORlJs+TfpZQXmKoa9/KrjT1tRqMIFqJUFgpkrCpvuMr66nSAq+k8cPFyrWFG2
	 uTiHZIB9LLuwg==
Date: Sun, 6 Sep 2026 12:12:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, tangchengchang@huawei.com,
	linuxarm@huawei.com
Subject: Re: [PATCH for-next 1/2] RDMA/hns: Limit gmv_entry_num to avoid
 memory waste
Message-ID: <20260906091233.GC13683@unreal>
References: <20260904093837.1633748-1-huangjunxian6@hisilicon.com>
 <20260904093837.1633748-2-huangjunxian6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904093837.1633748-2-huangjunxian6@hisilicon.com>

On Fri, Sep 04, 2026 at 05:38:36PM +0800, Junxian Huang wrote:
> The GMV entry is a HW object corresponding to a GID. Since gid_table_len
> is already limited to a maximum of 256, there is no need to allocate
> memory for those extra GMV entries as they will never be touched.
> 
> Fixes: 7243396aaf12 ("RDMA/hns: Add a max length of gid table")
> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 27cc7df55ee7..3edceadbca76 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -2416,8 +2416,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
>  					 caps->gmv_bt_num *
>  					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
>  
> -		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
> -							  caps->gmv_entry_sz);
> +		caps->gmv_entry_num = (u32)caps->gid_table_len[0];

Please fix the declaration of gid_table_len first. It should be u32 in the
first place.

Thanks

>  	} else {
>  		u32 func_num = max_t(u32, 1, hr_dev->func_num);
>  
> -- 
> 2.33.0
> 

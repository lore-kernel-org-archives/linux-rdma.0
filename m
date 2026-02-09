Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA92DCBFA
	for <linux-rdma@vger.kernel.org>; Mon,  9 Feb 2026 06:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770617502; cv=none; b=YRgZLjroSWm4AozkZJLf7jn+uslnCOu0t5JhlxVB4sTv8ytO+q+D4ArLxEn5aeOIo32Id2FV7EjQ6zqTOXjnAuNQRpW02MT0q3xJH8/AGjn/1EQzevYF5ZEwQeBZtPSMSnZZLYR5J5FYHC8l5op5CF412vjdaQha2CrtJEKdp6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770617502; c=relaxed/simple;
	bh=8xkvVvjUdJgJGWW1V5mM2yysdqyi5HUqK8zg9CKEIyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z1uv/jeVuPTs/AKhr7LuMVSzyKyVATQTlV1300+hnXdxBav5X+RaGPeJLp7+BYTKTd7sQtKbrHitQVHIA6nRp5NLNQO3SgMJsOivQwMpYYli6EkT9EybFBm4UtohOgWqicwhO3/NBqTKNFiqlGSrlbILAXzDyscuEG7ISLEREQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4f8Z352C3jzRhQS;
	Mon,  9 Feb 2026 14:06:57 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id CD2804056E;
	Mon,  9 Feb 2026 14:11:33 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 9 Feb 2026 14:11:33 +0800
Message-ID: <5d569a30-832d-fe8d-1227-e409176b75ef@hisilicon.com>
Date: Mon, 9 Feb 2026 14:11:32 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 01/10] RDMA: Add ib_copy_validate_udata_in()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Kalesh AP
	<kalesh-anakkur.purayil@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
CC: <patches@lists.linux.dev>
References: <1-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <1-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/2/6 9:45, Jason Gunthorpe wrote:
> Add a new function to consolidate the required compatibility pattern for
> driver data of checking against a minimum size, and checking for unknown
> trailing bytes to be zero into a function.
> 
> This new function uses the faster copy_struct_from_user() instead of
> trying to directly check for zero.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/rdma/ib_verbs.h | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 8bd020da774531..32dc674ef78cf1 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -3119,6 +3119,43 @@ static inline bool ib_is_udata_cleared(struct ib_udata *udata,
>  	return ib_is_buffer_cleared(udata->inbuf + offset, len);
>  }
>  
> +static inline int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
> +					     size_t kernel_size,
> +					     size_t minimum_size)
> +{
> +	int err;
> +
> +	if (udata->inlen < minimum_size)
> +		return -EINVAL;
> +	err = copy_struct_from_user(req, kernel_size, udata->inbuf,
> +				    udata->inlen);
> +	if (err) {
> +		if (err == E2BIG)

The E2BIG should be negative.

> +			return -EOPNOTSUPP;
> +		return err;
> +	}
> +	return 0;

The logic here can be simplified like this:

err = copy_struct_from_user(req, kernel_size, udata->inbuf,
			    udata->inlen);
if (err == -E2BIG)
	return -EOPNOTSUPP;
return err;

Junxian

> +}
> +
> +/**
> + * ib_copy_validate_udata_in - Copy and validate that the request structure is
> + *                             compatible with this kernel
> + * @_udata: The system calls ib_udata struct
> + * @_req: The name of an on-stack structure that holds the driver data
> + * @_end_member: The member in the struct that is the original end of struct
> + *               from the first kernel to introduce it.
> + *
> + * Check that the udata input request struct is properly formed for this kernel.
> + * Then copy it into req
> + */
> +#define ib_copy_validate_udata_in(_udata, _req, _end_member)              \
> +	({                                                                \
> +		static_assert(__same_type(*(typeof(&(_req)))0, (_req)));  \
> +		_ib_copy_validate_udata_in(_udata, &(_req), sizeof(_req), \
> +					   offsetofend(typeof(_req),      \
> +						       _end_member));     \
> +	})
> +
>  /**
>   * ib_modify_qp_is_ok - Check that the supplied attribute mask
>   * contains all required attributes and no attributes not allowed for

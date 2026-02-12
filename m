Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2332BD586
	for <linux-rdma@vger.kernel.org>; Thu, 12 Feb 2026 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877967; cv=none; b=mwbXBinnWnAS8egOiByhA9XwCMkwkIDWZQDPww35sfiEkBqLwDkdVjA55uufQD1nq2TFJkT63iMsD8+GCtfWm/MEZyC3H9re7nYc/pgxnS2cG2Kqr+Kh381iMHPcvvVDFO2/EDtt+Wo9+ht+03nGQdZt77jyt5DScARjIW3kVNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877967; c=relaxed/simple;
	bh=FRHlWrxIVzb4IegmiPrSpZ5Hso+mLMNkmV4GMNnZkzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxoSQo7f2o5Ry7mcUiVsx6YdKox6+YkW9+hekVc/iW5LBcqTZOGWCFuTCKGZc+LWQCJ4tVLY/m1okITH324Yx3jJlry3puI6s02eBK2tHnci1+VSdhg8SYthKSsChyvONMdXuDp5db88Gk1CA7hBzZGqEomzxo6F9/Pzs51AwIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GYeuy6aa; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GYeuy6aa"
Message-ID: <4db3f295-ed9f-45dd-b0b6-7b08377819cd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770877963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZzN6OZbHroSLkt9zLTTP3jknr+fN1lHMUBwNZClxhA=;
	b=GYeuy6aa4kVzbRK6ZkKHxY79GU8EEQanZqnzq7M+gXJ5yE69/6uByioefAIrJBd6/oyx9x
	hIJ/7sGv6I1nlUb0Mf/RB/x7SuzJ9vAi9qbziq2owZrlCnuz5+LyITQ2thQLgCtj6AxIUP
	iixnk1zakPE3kVHUr/jZj0tnMxGqJ5k=
Date: Thu, 12 Feb 2026 08:32:36 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH for-next] RDMA/efa: Expose new extended max inline buff
 size
To: Yonatan Nachum <ynachum@amazon.com>, jgg@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com,
 Firas Jahjah <firasj@amazon.com>
References: <20260211113346.9996-1-ynachum@amazon.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Gal Pressman <gal.pressman@linux.dev>
Content-Language: en-US
In-Reply-To: <20260211113346.9996-1-ynachum@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 11/02/2026 13:33, Yonatan Nachum wrote:
> diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
> index 98b71b9979f8..13225b038124 100644
> --- a/include/uapi/rdma/efa-abi.h
> +++ b/include/uapi/rdma/efa-abi.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
>  /*
> - * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
> + * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
>   */
>  
>  #ifndef EFA_ABI_USER_H
> @@ -44,7 +44,8 @@ struct efa_ibv_alloc_ucontext_resp {
>  	__u32 max_llq_size; /* bytes */
>  	__u16 max_tx_batch; /* units of 64 bytes */
>  	__u16 min_sq_wr;
> -	__u8 reserved_a0[4];
> +	__u16 inline_buf_size_ex;
> +	__u8 reserved_b0[2];

Do you need both values exposed to userspace?
Can't you reuse the same uapi field?

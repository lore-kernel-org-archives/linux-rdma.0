Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FEA53D0B8;
	Thu, 15 Oct 2026 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085080; cv=none; b=fTfVZUpBfjPDHa9419bjFd6FSeisxMhkdAoy+o6ZgEKHhAapUKXbjxqZTTuA1F437vnVuz2ZHFrGBAvGWR9YexKpxBF41peyRCGXfTMDjlDZ3YwTiSqAOywMeS7BMm/GSIBuVoZG5WWORgQWcvBW6j8YEG7GV5IfZzNdRnBC/ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085080; c=relaxed/simple;
	bh=uXdqRmUF8e2b+VSx0rQk7GUMpnZqtLMmBD242Ualea4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AghIua41sntIq9SUesP/pemh4eXxRGja3esiJOY2MSZ6h/evsRxXyXfdv6/1BnomrFgR11liDqdxSZUUtMDOSHMOAAMhsI+2jyaTEBrGGew7xhjUdfEy4YsAwi4qPtB5xhf0Y9sWgPnvneAJtUtmXVGMLQPbsr/mkdHtyvrYyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dZ+J0yHS; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dZ+J0yHS"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5FLP6XhZz1XM5kD;
	Thu, 15 Oct 2026 17:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792085065; x=1794677066; bh=LrJgWJLjAeW0II0nobB3caQS
	2vY/kxVZnnnwULVwf6U=; b=dZ+J0yHS6N7jGvI/wexQzkkGLkaJitsrSFOSlwc8
	8viXMKO3tU6d2Rzj/keU0ZWHYYtUEEwZUBweoooMlihsYGd+M8vs/+PyvZ91PVLb
	KFRvMF47JsLCNbD1/Me4wAvxwlWVUSdJLEu6dD/yLhriPP2kWHFubMae5Ub8J8kY
	8uH4bvHzIbbBl12CqEYsR2y3TcoVidPp4sgy1zT0dRMe9tp6K+25fgIcELQlCgu3
	zZDA49mrSTZwE+/Kxdhrs+JppY6HqTUyZWNNBQPhIp1OGAEcBFG07Wlhdu3wvNW4
	GD1L/PKX6pxD7jufe4YwMYkwY2YVtGGgNkE77BMg24JFyA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nniE_vZoA-5e; Thu, 15 Oct 2026 17:24:25 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5FLJ4fG0z1XM4Tl;
	Thu, 15 Oct 2026 17:24:24 +0000 (UTC)
Message-ID: <fa01c872-9d1d-4b60-b994-08ba86a5ebaa@acm.org>
Date: Thu, 15 Oct 2026 10:24:22 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
To: Andrei-Alexandru Bleortu <me@andrei-z.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-3-me@andrei-z.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261015125118.2966247-3-me@andrei-z.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/26 5:51 AM, Andrei-Alexandru Bleortu wrote:
> +/*
> + * The verbs API cannot report a device's inline data limit. Some drivers
> + * have a fixed one: Intel irdma 216, 101 or 48 depending on the
> + * generation, Alibaba erdma 96. Try those first, by vendor ID, then step
> + * down SRP_INLINE_STEP bytes at a time to zero. libfabric's verbs
> + * provider also probes the limit (vrb_find_max_inline()).
> + */
> +static const struct {
> +	u32	vendor_id;
> +	u32	max_inline;
> +} srp_inline_limits[] = {
> +	{ PCI_VENDOR_ID_INTEL, 216 },
> +	{ PCI_VENDOR_ID_INTEL, 101 },
> +	{ PCI_VENDOR_ID_INTEL, 48 },
> +	{ PCI_VENDOR_ID_ALIBABA, 96 },
> +};

A table like the above makes maintenance of the RDMA subsystem harder
than necessary. Shouldn't a mechanism be added for querying this
information from the RDMA adapter?

> +	 * Ask for enough inline data to post command IUs inline (see
> +	 * srp_post_send()), or for as much as the device accepts.
> +	 */
> +	cap = init_attr->cap;
> +	inline_size = srp_inline_size(attr->vendor_id, SRP_MAX_INLINE_DATA,
> +				      false);
> +	for (;;) {
> +		init_attr->cap = cap;
> +		init_attr->cap.max_inline_data = inline_size;
> +		ret = srp_create_qp(ch, init_attr, &qp);
> +		if (!ret || !inline_size)
> +			break;
> +		inline_size = srp_inline_size(attr->vendor_id, inline_size,
> +					      true);
>   	}

What changes in the RDMA core would be needed to eliminate this loop?

Thanks,

Bart.

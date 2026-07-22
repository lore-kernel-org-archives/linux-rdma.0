Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4530C60F
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 06:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784700296; cv=none; b=AZBjt7fsjcqSXd9PbTlCVfbW+xBcEgvQQLlNDg7Bm1+dgFdM/YmeyXg0f4OmbC/txKXAxo1weQjlMeF5NlV1ApAzldhLljqtCKN+U3R/dTRFUu94zjrI6/FpMYvFRrM5KLZ7o6Y53wtAw6lxXeNiLeLYOaOk/WO0531LTZFRS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784700296; c=relaxed/simple;
	bh=01y7U4luyZxx8YmrhBv6klKCsgwEahIjnJG4SOXcHmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wrxwcw1PwzkVJMFX+6reYKns3O5+EkQ2rKIR1/3v8B7asRcKnrn3DkDFri43DyjZM1b4TLHIp8O2zOGeOg+S+6rs+iZ4rmqu1Ws5f2uQOQh6p0dLZD9+SBNtYPFzV6L8oS9//DrUPIq1SNGuEXZTdrU2PboINlsbfbD4Wopkl/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u2P/8+tP; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u2P/8+tP"
Message-ID: <047c1566-905f-4d22-97fa-66945278a6dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784700291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Jd/T4jA/WOCkfIexsltr8/LFSvlOL5IDg6tM+EJxUc=;
	b=u2P/8+tPKZkDZ+Xj0mBLRGLy/3VPiEElJb8vPJn/OYEjJlzTcbmP3HYhPl04VjBcN/q8PV
	XiWYcRwTQGW6Id/nUdEx4EeLKW2FvKm1WJc9M+Pl9dkLt3hZgMHWzwYfMDaF2xcyGv8YcT
	GhnzwmAhocmbwDbGxTwrp9DgJClu7HM=
Date: Wed, 22 Jul 2026 09:04:36 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH for-next 2/2] RDMA/efa: Expose 64-bit send WR ID support
 to userspace
To: Yonatan Nachum <ynachum@amazon.com>, jgg@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com,
 Tom Sela <tomsela@amazon.com>
References: <20260721070026.1635441-1-ynachum@amazon.com>
 <20260721070026.1635441-3-ynachum@amazon.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Gal Pressman <gal.pressman@linux.dev>
In-Reply-To: <20260721070026.1635441-3-ynachum@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 21/07/2026 10:00, Yonatan Nachum wrote:
> Currently EFA WRs support 16-bit request ID, this requires EFA to manage
> a translation table to translate the IB WR ID from 64-bits to 16-bits
> and translating it back on CQ completion.
> Expose a new device capability to handle 64-bit request ID for SQ WRs
> allowing userspace to directly post the 64-bit ID to the device.
> 
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Reviewed-by: Tom Sela <tomsela@amazon.com>
> Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> ---
>  drivers/infiniband/hw/efa/efa_verbs.c | 3 +++
>  include/uapi/rdma/efa-abi.h           | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 001bd8cb4f66..85e32a7c76c3 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -264,6 +264,9 @@ int efa_query_device(struct ib_device *ibdev,
>  		if (EFA_DEV_CAP(dev, UNSOLICITED_WRITE_RECV))
>  			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV;
>  
> +		if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
> +			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID;
> +
>  		if (dev->neqs)
>  			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_CQ_NOTIFICATIONS;
>  
> diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
> index fc4b2eb903c9..1e371bfef6d8 100644
> --- a/include/uapi/rdma/efa-abi.h
> +++ b/include/uapi/rdma/efa-abi.h
> @@ -135,6 +135,7 @@ enum {
>  	EFA_QUERY_DEVICE_CAPS_RDMA_WRITE = 1 << 5,
>  	EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV = 1 << 6,
>  	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
> +	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
What happened to 8?

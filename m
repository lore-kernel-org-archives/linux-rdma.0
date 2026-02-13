Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AD73EBF10
	for <linux-rdma@vger.kernel.org>; Fri, 13 Feb 2026 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770982514; cv=none; b=kLt/Se+2QRr5PjQhMWg9tLEA4rrCcJUcM/0zHJVZBoAX4PGo5TbYeZU4uTsPrUmAqjxTnMy24FPlaUIGludz0sGxAU00aWkvYH5pY0C6NUdEAK0sG5dFDIzdKpd0WvU7kKmgHtiv2QwS+elWmTWeHTfxLLDKmaVpQqSdP3qvKkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770982514; c=relaxed/simple;
	bh=CHIm0TY40gjxmzWyA0Ea01XbmihQZin04w2OA3GzmmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdYKXyQkqRQrsbUXCykN1ByEkzBim+SXQDA6F1G/XajXtivnUnGBooV5yObpmEOF9KsJfoUmW49Pyqd8CATLzwJSLuABn1MpQmkmW6SokdrmujBnhE6nHS/X4VmTtBEhG2IOpJrrjs1Z9cepUEPTEmfo/k5qe/1E/VsFbWajFl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1IUKK7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1IUKK7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86DDC116C6;
	Fri, 13 Feb 2026 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770982514;
	bh=CHIm0TY40gjxmzWyA0Ea01XbmihQZin04w2OA3GzmmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a1IUKK7fOQMzaFp8Ag+Z4zncAsGj35vmJChdaZEJR8UOSAdK9ERbjdcLQxlrsmxfP
	 dHdNJUPjWUqTdf5pUKUb7cywEaikAfcRDDWAfDEL3vVqyt+zlqllEkLUSofsnVvnLS
	 aocUkcYvTcB40I8uQdbkcsb2CK8Gy/eQSFS6qBsrPLKNrHJtQ0lRcIMiOOagYHIeD4
	 c1WYfrQEhbaa20Ys2qhrz//sMWExHzyda1wehynuufyYkrlFbIe47bXqNhoF4MzsPu
	 KwTpciHK6kqvp54N1uTWwLUlro9BZFKkWJZmEeIbj3rZjhcYcOHZ6nQ0U8kCv/kSpG
	 ronlWVArqXemQ==
Date: Fri, 13 Feb 2026 13:35:10 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose new extended max inline buff
 size
Message-ID: <20260213113510.GQ12887@unreal>
References: <20260211113346.9996-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211113346.9996-1-ynachum@amazon.com>

On Wed, Feb 11, 2026 at 11:33:46AM +0000, Yonatan Nachum wrote:
> Add new extended max inline query and report the new value to userspace.
> 
> Reviewed-by: Firas Jahjah <firasj@amazon.com>
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> ---
>  .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 22 ++++++--
>  drivers/infiniband/hw/efa/efa_com_cmd.c       | 55 ++++++++++++-------
>  drivers/infiniband/hw/efa/efa_com_cmd.h       |  3 +-
>  drivers/infiniband/hw/efa/efa_verbs.c         |  3 +-
>  include/uapi/rdma/efa-abi.h                   |  5 +-
>  5 files changed, 59 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
> index 57178dad5eb7..93e5ffe900e9 100644
> --- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
> +++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
>  /*
> - * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
> + * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
>   */
>  
>  #ifndef _EFA_ADMIN_CMDS_H_
> @@ -38,10 +38,11 @@ enum efa_admin_aq_feature_id {
>  	EFA_ADMIN_DEVICE_ATTR                       = 1,
>  	EFA_ADMIN_AENQ_CONFIG                       = 2,
>  	EFA_ADMIN_NETWORK_ATTR                      = 3,
> -	EFA_ADMIN_QUEUE_ATTR                        = 4,
> +	EFA_ADMIN_QUEUE_ATTR_1                      = 4,
>  	EFA_ADMIN_HW_HINTS                          = 5,
>  	EFA_ADMIN_HOST_INFO                         = 6,
>  	EFA_ADMIN_EVENT_QUEUE_ATTR                  = 7,
> +	EFA_ADMIN_QUEUE_ATTR_2                      = 8,
>  };

<...>

> -	result->max_qp = resp.u.queue_attr.max_qp;
> -	result->max_sq_depth = resp.u.queue_attr.max_sq_depth;
> -	result->max_rq_depth = resp.u.queue_attr.max_rq_depth;
> -	result->max_cq = resp.u.queue_attr.max_cq;
> -	result->max_cq_depth = resp.u.queue_attr.max_cq_depth;
> -	result->inline_buf_size = resp.u.queue_attr.inline_buf_size;
> -	result->max_sq_sge = resp.u.queue_attr.max_wr_send_sges;
> -	result->max_rq_sge = resp.u.queue_attr.max_wr_recv_sges;
> -	result->max_mr = resp.u.queue_attr.max_mr;
> -	result->max_mr_pages = resp.u.queue_attr.max_mr_pages;
> -	result->max_pd = resp.u.queue_attr.max_pd;
> -	result->max_ah = resp.u.queue_attr.max_ah;
> -	result->max_llq_size = resp.u.queue_attr.max_llq_size;
> -	result->sub_cqs_per_cq = resp.u.queue_attr.sub_cqs_per_cq;
> -	result->max_wr_rdma_sge = resp.u.queue_attr.max_wr_rdma_sges;
> -	result->max_tx_batch = resp.u.queue_attr.max_tx_batch;
> -	result->min_sq_depth = resp.u.queue_attr.min_sq_depth;
> +	result->max_qp = resp.u.queue_attr_1.max_qp;
> +	result->max_sq_depth = resp.u.queue_attr_1.max_sq_depth;
> +	result->max_rq_depth = resp.u.queue_attr_1.max_rq_depth;
> +	result->max_cq = resp.u.queue_attr_1.max_cq;
> +	result->max_cq_depth = resp.u.queue_attr_1.max_cq_depth;
> +	result->inline_buf_size = resp.u.queue_attr_1.inline_buf_size;
> +	result->max_sq_sge = resp.u.queue_attr_1.max_wr_send_sges;
> +	result->max_rq_sge = resp.u.queue_attr_1.max_wr_recv_sges;
> +	result->max_mr = resp.u.queue_attr_1.max_mr;
> +	result->max_mr_pages = resp.u.queue_attr_1.max_mr_pages;
> +	result->max_pd = resp.u.queue_attr_1.max_pd;
> +	result->max_ah = resp.u.queue_attr_1.max_ah;
> +	result->max_llq_size = resp.u.queue_attr_1.max_llq_size;
> +	result->sub_cqs_per_cq = resp.u.queue_attr_1.sub_cqs_per_cq;
> +	result->max_wr_rdma_sge = resp.u.queue_attr_1.max_wr_rdma_sges;
> +	result->max_tx_batch = resp.u.queue_attr_1.max_tx_batch;
> +	result->min_sq_depth = resp.u.queue_attr_1.min_sq_depth;

Please split this patch to two: first is rename and second one is
addition.

Thanks

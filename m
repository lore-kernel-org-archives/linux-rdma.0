Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794701799;
	b=AwESVKE2Ag8155pCmAfVZtaM1xf/nOaWW482q94hIHpHGvPHmdzkJox1qfQYPFKyYeQz
	 /pZIsHQVX8h7jq85WuUQKEHOaHS3f+q13BqOpdYvBLbDrpwm7/8tHvNHexwOsJ2cPzeP4
	 bi4436qsWm8LKNlXUGs4zSDb9tECnSYM/0vaPP7GTbK7d91p28e6RXTfuH1bJyqlixUSv
	 5zUEC5xgrQIhOCw5N3OGVcgbPB3aPjIHm/lq5v81eyBSqtAHRtV2zrcBt/bKgOLgiZl+f
	 19s1sVQVyLRSxy0vlxU3LtFm2Th9acnnp2w8pEA6zPF6yPyJwPIRVXT/JBhD/tBWr+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794701799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VEBzE1knwqMxBYVeqkNmuJaFWfXuXmCAgemIUauhHa0=;
	b=maR2FJpsOHRCcfAja0VI9A0/gTtAVrdcYO160TQGcOjlLupvYhRzEuVHLI1TYw9gCPfT
	 1O3Dr18q74W6oNOf0zxyHaF7o32yFWrm7QFiQwKwjvr3OvhOAihU33GC+4TD9T1dVXnYr
	 XKVdOJfTiQei5yOVN7L1XLQdRyteVwSSgBOgQqvRV1ESv0BCxpjaA5PHzzKLB5kYYMYje
	 aKmM5IX6sPKR5ZG6Ojd6sCKeUV3Tx22KZyrfeRLwIDbJRdC4w6fFFAQzI8fv0l3es86NE
	 18VMLIIwDsvCLJ7DMz8vH7fV9H+UzE3vEDOLW/wiCUvfGiogIetnm7S2Ien0Wi/07HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=izAWa80e;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17DB606A323
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 00:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C17DB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=izAWa80e
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-55ade1de0b4so32920961cf.3
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 16:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794701797; x=1795306597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VEBzE1knwqMxBYVeqkNmuJaFWfXuXmCAgemIUauhHa0=;
        b=izAWa80emUNgO47E34Ip0dphvGCCx6mqhJZZLPZQrzTx1vrjgkrya+suDkNBT+2MP/
         JhDUKGVelW+Dsz3PWo61oqpgNO2TgdCdAesi+hFSYJUOJEzAjVbwkykQAuf3hryFwFGc
         SrfKLupg4gbamE6TbtnPdLfNp7T/p4IIyKSgCGFNosdb4dpQ/0PG3ahElS6rO8fk909a
         DnjZBRoMyDUxyZ7bOtzFTS3Ku2NxklCvwvy246oLeoiRuQwti2g32uBa7nSZMoXOQ65Y
         9PvBWt9wTF/DEaF6JReif4w8yfR65PI56WiJXVxJIZ1FRPAbHNzG8RydAJzz+EBISp7I
         HYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794701797; x=1795306597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VEBzE1knwqMxBYVeqkNmuJaFWfXuXmCAgemIUauhHa0=;
        b=w3DJ7sGeqUirHY67VnaHg56ceq2bQsCELkM21UFWVqsw8WyacdEP56Ft3l/ByGzLYq
         lMR0ozX2FKEmSJhO1kOOqPcWZo46bs7/J4+IphvuNV75Q1tApF8njYLVly9iDCMOVftj
         3tgrCih3dppGAOPuabg+dYnToCHnL7gs9vo4ysPhUv2cbzmh99oKvLeDUxMqYv5Ha97E
         EDPx7kzSVS0CSKZd1kXaZzTNBs8V4ymruObT5NFXezt6HvAbtGpNm8rcYLNp8wr2vo10
         sdo6/t4mJllH3kYFnekVB3wXIGh3+T79kvbK71O5mMF6CLTGsOgvUjPFMtvvUc8fVAXc
         IzLg==
X-Gm-Message-State: APuU4Z94geQOTmeGAqUONaElJHUyRV81ZNLTBWTKOodKlqofGjVtLFiI
	MboJtaMxkZqGnyYcJyUuxqQJJsDdxZ5eN3+mFTczps7ox2hVfmCSOQIR1LzeIz+G/gg=
X-Gm-Gg: AYBFou2P2Qr0PXswGQLP3OJxUXJk0hyr6WKq8X3f/vLmuR+zcVaHIK8VA6BZ0YeHWXN
	VRvLB7VKi0nxLqA3gUFwCLXDem/riYzoU16CLNxbpg+RX+x8pssT7gFiywPXZLOli1EUaArXsw6
	CDEHV9Bhh8/A+8OQtwqZ61Em8dcVVG1peghFP0gWtxBQoJBxFBPk313anDAMWXe1ywSAVGi/Iw6
	yQSMYZyRxVWBeLTHrvMOi1qy+u0V53f3BAjICWTybD03GwkU7whuqqd2W+uuLmaAunBi/x6G8jU
	wcy2uDhncB2fl2Zm3gpvh2CdoJKBitC8Xg5I7V0A6wu2fas3u1EDq/o7OqSOiL9wJ0UrJSvg9Pd
	CnX4Hfh2qgm7/P5ajO7v4QC00f0MM8JlmeOuxIMQ9pUi2ep7/Np3e8btmiQjRyoYjvpqodUcIsQ
	mMZfUIsGnjJ3cOvf2zO0Mth7HEVvv7EJ+HAAS5inWMBP9wOc6iMkoy8taweifdnQr4sjPcbAvnf
	aqlNXUmWk+vgrU2A/hCVwKvBobGqX3Gjp4svn8t0yykcXgzTa3tXrRlF2ZKKDIY3SRQPNFTrud9
	3TfB2Q==
X-Received: by 2002:a05:622a:191b:b0:535:a5fc:3b58 with SMTP id d75a77b69052e-55ac8b9ba4dmr103255151cf.68.1794701797437;
        Sat, 14 Nov 2026 16:16:37 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad1b11d9csm50567131cf.28.2026.11.14.16.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:16:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSNv7-00000005EDn-1Vc8;
	Sat, 14 Nov 2026 20:16:33 -0400
Date: Sat, 14 Nov 2026 20:16:33 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with
 its new context
Message-ID: <20261115001633.GG2532299@ziepe.ca>
References: <20261112-ucma-conn-req-ctx-v2-1-yuehongwu@cmss.chinamobile.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-ucma-conn-req-ctx-v2-1-yuehongwu@cmss.chinamobile.com>

On Thu, Nov 12, 2026 at 09:42:00AM +0800, Yuehong Wu wrote:
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -534,8 +534,25 @@ static int ucma_cleanup_ctx_events(struct ucma_context *ctx)
>  	/* Cleanup events not yet reported to the user.*/
>  	mutex_lock(&ctx->file->mut);
>  	list_for_each_entry_safe(uevent, tmp, &ctx->file->event_list, list) {
> -		if (uevent->ctx != ctx)
> +		/*
> +		 * A CONNECT_REQUEST that has not been delivered to user
> +		 * space is queued on the listening context but stores a
> +		 * pointer to the new connection context.  The new context is
> +		 * live in ctx_table before the event is queued, so it can be
> +		 * destroyed before the event is fetched; the event can then
> +		 * no longer be acted upon.  Drop it instead of leaving a
> +		 * dangling conn_req_ctx in the event list.
> +		 */
> +		if (uevent->ctx != ctx) {
> +			if (uevent->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST &&
> +			    uevent->conn_req_ctx == ctx) {
> +				list_del(&uevent->list);
> +				/* Return the slot taken for this request. */
> +				atomic_inc(&uevent->ctx->backlog);
> +				kfree(uevent);
> +			}

The seems like it defeats the cleanup process, or moves the race
around.

I would expect the solution to this problem to hold some kind of
reference while the uevent is alive.

Or perhaps blocking ucma_destory_id while the event still exists.

Jason

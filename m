Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526F64534A2
	for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903717; cv=none; b=Zs86E4+1fDt379I/btndhVjC83SpfxX4Kw/B0gff0l525QVUZQVoVF1DBctiBNUqVDyVFMG91C6UmAQ7NcDNqVh8QCVw8kncj2kFtGZRzmGTC8KsaqIffU08lV49LjPzfR2YLf8pnmwozH1jow4cH5AJP2UUNL5R4qukPruN0Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903717; c=relaxed/simple;
	bh=wKsM608Esl0fy6X1o4nG+xhV/5Q6mB3P9exIoxqFSuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EapUA152cVFaz8G0YcEjbm2p/WGuBBCmzr1PKheJLrVl9+woYuLGQoTHkzxrSkA+v/g7iYNnWMsxc334Cg3API+CzeJ0EzaZco2Pga46anb4glvy1LvmbA6eaY+VkHdXvIEoP3TWQTfnpeIpeffYB22GCnl0z0jGCZEWeCYOiDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RN1mV5fh; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RN1mV5fh"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-91173f20ccdso530738585a.0
        for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 10:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1779903714; x=1780508514; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DmrDjy36KcGDNrJKWLTqrfLWEGEdjBVPnWG8V76UL1w=;
        b=RN1mV5fhA2mINONoxIZXXBC4lPjVyYNgs2FgpFWTPpzNsnBNrFJeqXDSRYJMP/Iq1x
         YvgZztLQ/C6NkKwxia+xLecDMh9khm+8cwDOsywU51RuaXMIgNf2qi3F/PNxpI2yJHFL
         jR67bNqjbqCh0wRYanf9kPGsH8jD9yLmRYtVo9fbZBWhVEanhcrEgQ2geDQX4h4GtbUh
         ohYpM25MqBNY85RW1NuWFbQdDtk1K54rNhr5x00u08WQNyFIvHgIusnzZ8yQeaBlDOfL
         LZuEi50rNhDS5xHnMPZEcc0sxo2q3JiC2m6xtcmmz4GleILEahRLUlXd7h6beifxyl7N
         uSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779903714; x=1780508514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DmrDjy36KcGDNrJKWLTqrfLWEGEdjBVPnWG8V76UL1w=;
        b=obAHT8UR3IgT+97fND40NDA/8G19jPGZ2DHsFTA970fPPecG86Vczb2vHCAm+3K0Bq
         VZluXMBoQENN+//crCC0C9w8JYhPwdKXLwFdjWB/FwBOEbZuNcCL1etl1kioISAjOX7I
         p38BmfrDbUmhaQ6lLuc0zZtF3xfFKmoxIn/EYGuvm1/ZJIVOJGRGjheem6ja8OAkTVIP
         QMrfhjC/la1LmV2Z0nCSSXjSlgbkHXzxCSl31ogz00VOWD4ZKuSzfkHNvUn6U69mf61s
         O2BQFecUVcsRvZNeiJYqXCj6P/B4PLKTMVGmVztNcaOieeCZj46jx9lsPvjudiqVZBXo
         QzlQ==
X-Gm-Message-State: AOJu0Yw3fDu5P40LoxQQ8MmbnH6k8HoqS3mbGqm2DYYuN/ihLeGd0X0G
	4fhzZRSTxXwLcsvRKDXCZwZhjupcUKvU1y4XCilENigdRdgx6lasNZ2qrEAgZ/ZTLIU=
X-Gm-Gg: Acq92OEg2j5pFsKbD4IMoXJ4pbKTpfUv74Qg+z89wCiCf1SPVsTfznjFMUDP3Xm2yXP
	xFSZfTxJGvK6hsdcKpCnqpfY/QSOGAtTWOw2XjPsdoMJSuXeX0kkiVW+/XUSHIF1E6JACE7V3n/
	f8+k5BvpqbEqqbkE099w+4sw5AXtf/TAgcbWg7CIwt16o4WMOAr2rnWqPBwdBkZWQj93++/S3PN
	w0rgkn1R4UPEb/ofd98Y0olnQGmjgzz5HOtlsVh/Z7VcQazbxB5hjvKyMjaLrhI/CGA9XO8ireR
	AOeghxvYYPtH4GIKscfT7o4AIrYTzp1HAC1IeL/yuB7Obyme3ym+tb51CuddpLA/cmPyDXSS5dL
	mcoBFluYcKFbjFuVGwa6b+jORF1ndJ/o6n5C/Wg+gsb7ny2v5iy5lrfyOcBmyRR0P220FX9bvAi
	ZT0htr/3vxGLozxpMSarzSGUXsZ3ts7guYOOkUB1U9VmKm4KIUa2uR3mdxlMLUVcEgfW55j0A6I
	9NMMnoD9iT0bgv8FxYcg+H/iLE=
X-Received: by 2002:a05:620a:372a:b0:914:c100:6a18 with SMTP id af79cd13be357-914c10072bamr3218941085a.16.1779903713990;
        Wed, 27 May 2026 10:41:53 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80dcd3f4sm174513766d6.5.2026.05.27.10.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 10:41:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wSIGP-0000000FLqn-03Al;
	Wed, 27 May 2026 14:41:53 -0300
Date: Wed, 27 May 2026 14:41:52 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, leon@kernel.org, mrgolin@amazon.com,
	gal.pressman@linux.dev, sleybo@amazon.com, parav@nvidia.com,
	mbloch@nvidia.com, yanjun.zhu@linux.dev, marco.crivellari@suse.com,
	roman.gushchin@linux.dev, phaddad@nvidia.com, lirongqing@baidu.com,
	ynachum@amazon.com, huangjunxian6@hisilicon.com,
	kalesh-anakkur.purayil@broadcom.com, ohartoov@nvidia.com,
	michaelgur@nvidia.com, shayd@nvidia.com, edwards@nvidia.com,
	sriharsha.basavapatna@broadcom.com, andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com, jmoroni@google.com
Subject: Re: [PATCH rdma-next v7 14/15] RDMA/mlx5: Use UMEM attribute for CQ
 doorbell record
Message-ID: <20260527174152.GC3528738@ziepe.ca>
References: <20260526144152.1422310-1-jiri@resnulli.us>
 <20260526144152.1422310-15-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526144152.1422310-15-jiri@resnulli.us>

On Tue, May 26, 2026 at 04:41:51PM +0200, Jiri Pirko wrote:

> +	/*
> +	 * The 8-byte DBR is programmed to the device as one DMA address,
> +	 * so it must live in a single contiguous DMA segment.
> +	 */
> +	if (!ib_umem_is_contiguous(umem)) {
> +		ib_umem_release(umem);
>  		kfree(page);
> +		err = -EINVAL;
>  		goto out;
>  	}

Michael forgot to add an inline for this:

../drivers/infiniband/hw/mlx5/doorbell.c: In function \u2018mlx5_ib_db_map_user_desc\u2019:
../drivers/infiniband/hw/mlx5/doorbell.c:102:14: error: implicit declaration of function \u2018ib_umem_is_contiguous\u2019 [-Werror=implicit-function-declaration]
  102 |         if (!ib_umem_is_contiguous(umem)) {

Jason

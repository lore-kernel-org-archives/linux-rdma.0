Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9302046BA
	for <linux-rdma@vger.kernel.org>; Tue, 21 Apr 2026 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779199; cv=none; b=XiFtdD+jQznQbQELxqKC4juzRbFTDr0Jrz3XuR56qTIHEPJESk1uob80p/F5LG6sSuapv+Nq/4mHHeQ8BxururRYA8+gpQKwD79I+gx3fCQXTa1oWsvreWhSClNNaHKigOrKESFGVEEU1IiMQ3ZrKKoIF1aoeipfxjwWXSHxSRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779199; c=relaxed/simple;
	bh=dBG0EmDiaT2y6eAVgIXffSMssKiZ/a7o+7C34cUpjno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gD+6gvvugHB3B1TaX+UFw8nu8BKzs9TPDyyA1ZY4Hcln4+WsZdhfZZtBiI3+eipSjk64bTUQ2ZUtQQZF1QfcUIIE+igDg8yCkFaESmpOFacQZ1fUWn1t+WJioPdOlki6S+VuR6J9S0lqXN0A1fF34j0PBO5oElhw8Ud2JNWpf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Gm40ic1j; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Gm40ic1j"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8a0323830beso28026856d6.0
        for <linux-rdma@vger.kernel.org>; Tue, 21 Apr 2026 06:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1776779197; x=1777383997; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=no6LzFiHx60NlaVssMldLhc97RtMPDeonQ15V0Z8G00=;
        b=Gm40ic1jr7Y7OM4f3GYTjZgZRBenkmT5IErqiSDnQMNineyv3FP+Rj+LSe+OCHS0nl
         fHyU04BExvf/x+UTWDdSUESvhnG6UcvBqHXQ3dejHMUaUgvgYi7LueGGC4QmN4PW2I7p
         dWOHrngunMMQGHG4PfoGimC3YqvFjjFCcTVknkDfOG6K59QnTqWNd7ioXw+oEsfYdJpr
         VcRUMBUnItaCvwrFHQaHIFzWgv1tFkHZuDIGK4v0QrRJIu3lCUih3FuUggOJ3D41UZsb
         xDUbYj6gqbow+5V0ZbX3j7v986Cm4VnChdAju4nlhruooadCS715ENTTIrOA4TheLlTb
         BEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779197; x=1777383997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=no6LzFiHx60NlaVssMldLhc97RtMPDeonQ15V0Z8G00=;
        b=e6aCdDZrWI1Shn85i973Q+/LzrAmXBBjcKtAZ/Z6vxLUSFuMGxNM76InnE++uy8TyG
         Afg9moUPU3PrBS+G0iDS352sPayR/aNyO9Pr/G6BZoPLND8Q8eZii7qdkpF77o8Evi33
         ZGWOUMHrkMbC5tHbMBgodklZcKzkQqUfSTGx2Ugp6WdgyCsQbgCWjNqguZLWts+HVdNJ
         Uw0MlYCyVmQVZyudbJ3QRNr61l7fZbvxuis+7+U5zmo9jzMUWyk8Qj6Ye5hqGMExqpKl
         5rdajsGYjBZ0RutGZyRy2K6Xj8zis2fWbawJV6tGi2OtmgryttQloM8y9I7kVkzqMXxc
         HClw==
X-Gm-Message-State: AOJu0YxokzHQ3W/vkCbAbZXYvRI2zeKBcNoSjUj7hQSkzPFZawKgvDiV
	yIkGyWWFnN0Yjx9Fq9L8oKzyOpd04y+IRgxqeW/JjLl59dFDeh/8XA70+2SLudDhmpc=
X-Gm-Gg: AeBDietrn+2Hs2A+vhg2fZx3tDuT1s34Oddok1tfGEqcTYes2A4dzihTjq+P5qlygPe
	PUwVk5NYLF2Zq9FxPpFnzBnzH2LOqlEnlA03ACQckov3QduKUSwIoDv7lTmOK0IpyixbD5FzMoM
	EeumKwQrYGxoXMwj6V6oaf4PsMZ5rMTemuMn445b8B/oP/Hxg5fyrmrqmY3peU++h3YT6XevFuI
	HX13DEBK0/VHRVD3BjG9HtX4V2zj6MPkcIT36EOPplMCumm7u6rDasIuBQGbKKHlQcjahStGW6a
	80THw5P9SFfh/Yl4RRm+sr/XFvZ4mg5leyDW/95f8C8MZMtoRp8UPcQ+JrsQYwq8rdlsCb/fzmc
	YKW2JXvMGnaXBPxO2Mp/vnnCnO1x3lLNQYXR07uKL/qjcBzEpbVZBBGZtlIBpo5MujYGV928wd3
	7AGKPbV4v7x/qQMh/GjjkoPUVy72AtioKaj274JbQyaBnvaZ8PNMp2U1WReRlbkwmZj/oTtLc3b
	B4aSXCmWTDG4QJr
X-Received: by 2002:a05:6214:5f82:b0:8ae:7146:603d with SMTP id 6a1803df08f44-8b0280fc43bmr238050756d6.13.1776779196657;
        Tue, 21 Apr 2026 06:46:36 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b031f65a27sm94478236d6.16.2026.04.21.06.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:46:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wFBQx-00000001fy9-2kT9;
	Tue, 21 Apr 2026 10:46:35 -0300
Date: Tue, 21 Apr 2026 10:46:35 -0300
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
	selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next v2 01/15] RDMA/core: Introduce generic buffer
 descriptor infrastructure for umem
Message-ID: <20260421134635.GG3611611@ziepe.ca>
References: <20260411144915.114571-1-jiri@resnulli.us>
 <20260411144915.114571-2-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260411144915.114571-2-jiri@resnulli.us>

On Sat, Apr 11, 2026 at 04:49:01PM +0200, Jiri Pirko wrote:
> @@ -332,3 +333,250 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,

> +struct ib_umem_list *ib_umem_list_create(struct ib_device *device,
> +					 const struct uverbs_attr_bundle *attrs,
> +					 unsigned int slot_max)
> +{
> +	const struct ib_uverbs_buffer_desc *descs;
> +	struct ib_umem_dmabuf *umem_dmabuf;
> +	struct ib_umem_list *list;
> +	struct ib_umem *umem;
> +	unsigned int count;
> +	int num_descs;
> +	int err;
> +	int i;
> +
> +	if (WARN_ON_ONCE(slot_max >= BITS_PER_LONG))
> +		return ERR_PTR(-EINVAL);
> +	count = slot_max + 1;
> +
> +	num_descs = uverbs_attr_ptr_get_array_size(
> +		(struct uverbs_attr_bundle *)attrs, UVERBS_ATTR_BUFFERS,
> +		sizeof(*descs));

uverbs_attr_ptr_get_array_size() should get a const on the parameter,
seems to have been missed originally

> +/*
> + * Describes a single buffer backed by dma-buf or user virtual address.
> + * Passed as an array via UVERBS_ATTR_BUFFERS. Each uverb command that
> + * accepts this attribute defines its own per-command buffer slot enum.
> + * The index field selects the buffer slot this descriptor maps to.
> + *
> + * @fd: dma-buf file descriptor (valid for IB_UVERBS_BUFFER_TYPE_DMABUF)
> + * @type: buffer type from enum ib_uverbs_buffer_type
> + * @index: per-command buffer slot index
> + * @reserved: must be zero
> + * @addr: offset within dma-buf, or user virtual address for VA
> + * @length: buffer length in bytes
> + */
> +struct ib_uverbs_buffer_desc {
> +	__s32 fd;
> +	__u32 type;
> +	__u32 index;
> +	__u32 reserved;
> +	__aligned_u64 addr;
> +	__aligned_u64 length;
> +};

This seems like a good idea, we should have done it earlier :\

Arguably if you do this then the first issue of being more flexible
with umems is addressed, so a uverbs_attr_ptr_get_umem() looks much
more feasible.

Just brain storming, but if we let the driver pass in its uhw
information inot a getter:

  struct ib_umem *uverbs_attr_get_umem(struct
      uverbs_attr_bundle *attrs, u16 idx,
      u64 uhw_umem_base, u64 umem_len);

  dbr_umem = uverbs_attr_get_umem(attrs,
                     MLX5_IB_ATTR_QP_DBR, uhw->base, uhw->len);

Then if the new attribute is provided the uhw is ignored, otherwise a
ib_uverbs_buffer_desc is created from the udata parameters instead.

Drivers use the normal attr indexes to define their many umems for
something complicated lik QP.

For the lifecycle.. This series adds a 
  +       cq->umem_list     = umem_list;
 
So it is not a big leap to imagine a linked list in the object that is
appended by the umem create function. Pass the list head into the umem
allocator, free the whole linked list in the core code.

This has some appeal because it is an easier conversion of all the
drivers, instead of re-threading their flows to accept a pre-created
umem they just have to be updated to call the new function in all the
places they are currently getting umems.

You'd probably have a further helper for cq that could extract the
existing common cq attrs to a ib_uverbs_buffer_desc:

  cq_umem = uverbs_attr_get_cq_umem(attrs, cq, uhw->base, uhw->len);

Probably similar for mr and a common mr attribute.

This will be easier to put revocable and dynamic ops into the scheme,
they can be passed as arugments to the get function instead of some
complicated thing in the central ops structure.

Jason

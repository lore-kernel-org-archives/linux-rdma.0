Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F0F3E3170
	for <linux-rdma@vger.kernel.org>; Fri, 12 Jun 2026 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269324; cv=none; b=oWIfcf8s4PwK4f4aQs6r9jelsRnKlDjak/bU3H1RPKnel/T8/wk24Gov/bFtLARuSDv23ubo5cjsBHh58OjwlkCQoeJGR6nig+5zR2q75WOmEW0bqOux6GOy/+dV2+hhNEJNvj6RWRTcXJGDvziyz8vMQmnHGHAq1OHx6vFt60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269324; c=relaxed/simple;
	bh=ThH54gMV6tbGr+fgOVeUsCTRqVwecw79Ubd71Y2H1lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnbCK2v/WD4h8XLNcxBV+K/paNv3kB8HhTmssLLlXOAfZdmRjKtvfSITEwiooBtI8fzzo+XQNG/fSyuizjIL1SX57S4vM9rhC6AZ1V1wiln5ZTow9q+9dLbteJ2/sUF35GBseT9QYIqrKRfP6aZ4azodJJo0xGeQyEJqrTDgtNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Pun1hT/a; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Pun1hT/a"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69d7e72b052so592674eaf.2
        for <linux-rdma@vger.kernel.org>; Fri, 12 Jun 2026 06:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781269321; x=1781874121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gd5oYe5vuNIzqkAX3BjHZ/rVlhX+TR/gHR5DuETcImk=;
        b=Pun1hT/alDJ+LBmszRxddaTHrF5s5Rlzy+f2KmDsVJxyJArIPU4ryWxXpT5/FuXwwx
         XPWW+hteteSNn7sBikCadMbSydqg65OSw1OqXCWb/VRRpFSMe2mtAyHOmOiLxWZ9edbh
         baxvHQrpMn8qAXR2bw4Qls8XImT3dTngQH62JrQ6rB5MRa1lbDt833Lb/gcqOAYzDnxC
         gRYhvuogTUll6KNfxf5T7N414HvbLKVhuBwSlTvgn+KTvNgC6GNIwDcm6DiTgoRaj7Xx
         9/H8QDD4Y6gG/CFxyvqNguyeoVsy1p1jHvnYZp31czQM5YKsiBu1N4fw35vsVBm8Kwkx
         k9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269321; x=1781874121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gd5oYe5vuNIzqkAX3BjHZ/rVlhX+TR/gHR5DuETcImk=;
        b=B3XWP4FCJlfL9MD4/AMKQ7YKwVMPXE4rLDjnRkKsSFE8UIbY+yxmnf4GAMrQ3GbkxS
         fYG2iH6JH+H4X9q8ar96qOpMIm1Omg05PKP7pSiwaDMV1imm16i/sUcUsptxK6wr+7IY
         J2AczXVmwckuUrauWaSaAdv4b3xwa8EZuHn3+YsfGigQPuTCV6La2T7Xa3ZZtqXU+zjg
         ZFjpvImhjUMWbwlBwJqsswy4G7zn+xaow3SsW8+trloYkjLbVyIrg8rQhXptWQ5BETSE
         l44n8Fn7WPS3PBo6CsUpQvMwpOXqhYntJRP0uqNVSMX/wJxnVF0BsuLnF6HecdpbyEzS
         IQTA==
X-Gm-Message-State: AOJu0YynlN2ovc36207kZTQ4DgYd9p1t3N1R9pnsvo+D83C24WY4LwJD
	t2hqs7etwPb+Whubxiqd7D2sAWjcoV+BsHK+OZrPSOsAR9mpgG7qHBbRRznXnusSpw8=
X-Gm-Gg: Acq92OFKPrrVL2JZnbXeJBGHu9ktZfWzsaLrAg5IIbAyVsNTGJqPDb3ZPNwBINcc1Nw
	ddSW/z3hys98EphFdPthrqGEAOh0V3c7fCarpKl9i+wlqm+1qaD0ke3RtscY2Z73FT0AJ/H8tMi
	G9HwpMMFjMWg163rdH2+NmnrFvJqKrYSxfBlTtocadWhn0gpiA4H9NDO0enOAAPoyoDBra9FQcn
	Rps4gpk7PYgfx4J+qtN3sd+1BnPbgnr7ezRUcF574CYLQ2D9N03l40AYkphDJ4lya2VsZVEdk8C
	j8+DSubprkWGVOW/5eczd7v/p0h4KK5isW6D2WibfOyU9/ut+UP659nX/KU2CP5sxsE0r1D8dDH
	9lRZM0nSnTL5fIKaefFQNwxHkAurBdY8HfjpBxqCOFfNkCRb19pF0kY/4gsnPnNg866GCpFhzHL
	tekFJpw7l24f+xqhMfbsymuW7s5K3YXgrWbw8zirooZPjB2RGKJCCUlPOCjw+Lds6onT8e3PgVT
	y2NBCodSPuyH2qL
X-Received: by 2002:a05:6820:189b:b0:69d:a29f:392c with SMTP id 006d021491bc7-69edc7a9d55mr1531259eaf.56.1781269320722;
        Fri, 12 Jun 2026 06:02:00 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a06367dsm200151685a.43.2026.06.12.06.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 06:02:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wY1WJ-00000007l62-0NYS;
	Fri, 12 Jun 2026 10:01:59 -0300
Date: Fri, 12 Jun 2026 10:01:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, leon@kernel.org, mrgolin@amazon.com,
	sfual@cse.ust.hk
Subject: Re: [PATCH rdma-next 4/6] RDMA/uverbs: Add ioctl method for CQ resize
Message-ID: <20260612130159.GJ1066031@ziepe.ca>
References: <20260611151229.879514-1-jiri@resnulli.us>
 <20260611151229.879514-5-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611151229.879514-5-jiri@resnulli.us>

On Thu, Jun 11, 2026 at 05:12:27PM +0200, Jiri Pirko wrote:
> +static int UVERBS_HANDLER(UVERBS_METHOD_CQ_RESIZE)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_cq *cq =
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_RESIZE_CQ_HANDLE);
> +	u32 cqe;
> +	int ret;
> +
> +	if (IS_ERR(cq))
> +		return PTR_ERR(cq);

I think this is impossible?

> +DECLARE_UVERBS_NAMED_METHOD(
> +	UVERBS_METHOD_CQ_RESIZE,
> +	UVERBS_ATTR_IDR(UVERBS_ATTR_RESIZE_CQ_HANDLE,
> +			UVERBS_OBJECT_CQ,
> +			UVERBS_ACCESS_READ,
> +			UA_MANDATORY),

Because of UA_MANDATORY?

Jason

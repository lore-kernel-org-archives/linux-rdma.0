Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04173EC2DB
	for <linux-rdma@vger.kernel.org>; Wed,  6 May 2026 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075032; cv=none; b=DSsoeVSXO3osA799efDDrhm1FMGziPsTVWVdfG6zWVYJrGziI+fqUVFfSiqmY1g0LmjOfh7rX01BZEm8AYBmCt6bJ87JSMFfn54a96+hdI6opitekFhMaIvFEXRZjXFmkv67fHM8XVtZ+iFgQnbXSBdfIP1YVdB+LJifjjA3Fi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075032; c=relaxed/simple;
	bh=BWFMVHoUI3TRBKjBIMiKfvbqC+I2eytXhaqrYhYFC/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAxy8V8F6lV0WX5AgvPJwLwD6+I1IqDVVGWp2U3sWutu8BdFDB9ezBgR3RReccA9ZlZPdI2tIAT8GSVrcpg3UFAJKnFKVjIBkHFbkJ19vuT2Nflbg8B+UykVUY88ZMkFb+WIIKqxxvd9xORdv6UgHsbso5xz6z0/4YSX7jO71Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=heWbEG/i; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="heWbEG/i"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso35703545e9.3
        for <linux-rdma@vger.kernel.org>; Wed, 06 May 2026 06:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778075029; x=1778679829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OysEmakneUVxdThy830cjKfFF4mNDgLJCuzM5UUZCxk=;
        b=heWbEG/ikPju203wqDBBN5aGSNdecF5wAe+FMqdwR1s+SjhwJIc9u9/wiUTflCZ3vn
         /FsVuPYCJxouNyoRXPDbUQzCs66+doC7IRQglP+IZVLPu/diJXo/VeJpfXnEMVWQQjPX
         S2ehOQ/ceZDtI3oZKWkbbTYot52ZUzKxCLjcrfl33cBQEVtytwpsyFhMSVcRPL8qLilI
         op/cTxni3HbetfIeKDN+Fdm1Nx4LIuP2xC8Oqxts5KOWfDrfHrb2BmHjnQKH4RgQ7I9X
         1WwIlzRtKJlTpe56zMdOLsQnDERkAOMyy9UomJtngQFHTOFBw7ITjYgPP9pJ8eqz1Hlf
         kTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075029; x=1778679829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OysEmakneUVxdThy830cjKfFF4mNDgLJCuzM5UUZCxk=;
        b=mjET8j9jTxzkA0tZUr4wlJEIRGVU9U6yymTeYBGcnL9LpCh4c+97D7PerQXf8C51I/
         i1Xi7atAd2nIaekBWUJfMbzws2wWzKUQAB6Mab/gaTl6vEjAfbHq3RfC3qpS7Bp5r1mk
         Tvf/wtOoCaakycNuJq7Pil19pX8gCI3L24eOjeK2u3xQbTBE2YbjvwovFQmjIrm7/xee
         5IJuzvVXmdMbtrsyfXOK/Ik7acqJjvfy9oC//40kPjN0eZJZm++ier3dxgiDIkzH9sNI
         iaGY1+kQbEYtmsitrHNarx9V1Q54NJDr90Ts0sQhSAvXa9zTruM+WVHimvO7AW2NXrbC
         8gIg==
X-Gm-Message-State: AOJu0YwLEtOiwM6JYcXoZ/6EL7v/Pgx+kAn/xDCz7MITD7Ik3krzvbNw
	imRoLDDDd+hD6L4HzIzNc9CNz4WFjrRdAa6sCeEvwAyUy7nxQslJBDVzId0uS3iJUr0=
X-Gm-Gg: AeBDieu9qccCTbOQH7r77K7eAKyuz56TfbInaJDik8gsaejqJ1Imvk6rlvPprFzm0Cn
	/uwP977txCctTBqxHAj3BGXZPAHQlxJFPOkpSPgqgzVhQKxx8H0Dvy0GqrC4wZDwOhFYBbfMZTA
	PjiYpZEPGbroCayUaDXzw9LL/Kx5glAQ9ce3LzbjJ/64oT3EPQrY/2tIseL2z+ToUh2/QSxVNol
	eiEfDxYeYLDCOf9xcfLEFN08fqWduOqlUIYgkRPW7OvvfjZUOT68wto1ay10SV1btx8ttej0wnY
	9xfyeuDPDdWfjpeuepc0TDQZW6aWi2qoyrAk+BGIwdNcmzqt8qK6p2MbNHIhSsfh0yX5OGKo3zi
	Vy8ej2/2saZnl2bwmssgxdYlpmb161AWFk5pKS6LMPwestmAOUVpttXpsCUwOdwhTDhscM97D44
	T8Lp/laAk=
X-Received: by 2002:a05:600c:1e8a:b0:488:fd7e:1063 with SMTP id 5b1f17b1804b1-48e51f4cdcdmr61430085e9.29.1778075028774;
        Wed, 06 May 2026 06:43:48 -0700 (PDT)
Received: from ziepe.ca ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055960902sm14117068f8f.28.2026.05.06.06.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:43:48 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1wKcXS-0001kD-Js;
	Wed, 06 May 2026 10:43:46 -0300
Date: Wed, 6 May 2026 10:43:46 -0300
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
Subject: Re: [PATCH rdma-next v3 13/17] RDMA/uverbs: Use UMEM attributes for
 QP creation
Message-ID: <aftFko47Y56Gvsf3@ziepe.ca>
References: <20260504135731.2345383-1-jiri@resnulli.us>
 <20260504135731.2345383-14-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504135731.2345383-14-jiri@resnulli.us>

On Mon, May 04, 2026 at 03:57:27PM +0200, Jiri Pirko wrote:
> @@ -340,6 +340,12 @@ DECLARE_UVERBS_NAMED_METHOD(
>  	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_CREATE_QP_RESP_QP_NUM,
>  			   UVERBS_ATTR_TYPE(u32),
>  			   UA_MANDATORY),
> +	UVERBS_ATTR_UMEM(UVERBS_ATTR_CREATE_QP_BUF_UMEM,
> +			 UA_OPTIONAL),
> +	UVERBS_ATTR_UMEM(UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
> +			 UA_OPTIONAL),
> +	UVERBS_ATTR_UMEM(UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
> +			 UA_OPTIONAL),
>  	UVERBS_ATTR_UHW());

could an ai make a summary of how each driver would map its existing
umems to these - add it to the commit message?

Trying to guess if it is general? RQ/SQ seem reasonable, but I'm
wondering what drivers will use QP_BUF for...

Jason

Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEDA3264F2
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786457953; cv=none; b=KnP3zMTLjNCiGybBEPpU6SulOWu0ZFi+Duypd+X0stggD3QnTqKk/zadEtaHUxkQ3ocFeKBpdeWYsSLA52nmipD6FSiG/PxqZYJ0arxnvwx+bK2r0oUy4ZiNtI20klJ+PbV2N+edv64gQJuyXunxJi2xXlo6HEekjp0cROSS7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786457953; c=relaxed/simple;
	bh=+nn19uE03OTuzodfemXFOXdhsEizrqQp6Df5Dwesgz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGb+eSXpnXxuPxRrYqBgSjDIocvbdhnJIteIahCvWux5eMX/cqYQeOEjTB7M5nM/s/NwxoFlb3VQJM+sq+TpL7z80kr3KJiB6E9VLIFQFDMAxHMH8zsxhAdCQLe/CWh7WrkiTbBbLo51lXiZ/Elp+EsbiXvSgjNq2NUp0idZmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PMqqTAfl; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PMqqTAfl"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f23e851626so5854726d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 07:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786457951; x=1787062751; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w6H2WCcHsX32RYT/hOSXVqj9RwYA0w5sFO5iwrRmZuA=;
        b=PMqqTAfleQyeHiMHKk4gyBAf00rnzdA0ianlj7neOsBJZIymO42cqH2KpVTimwxkww
         OMv83h4eTzyONLbtVeqYl+s8y9bTcr/wjCTdxOggy/YisRDW1446PPph4R3G5w+Uqnob
         eczKRoxNzQQDzwj6qfsVMeXt/P/dAJv3m+iwxYk4rgu9yMYxBYtWA41+tQQ5k6EMYADa
         waKltk8JqEjuyF4h13qdCZiWYjVolL0hnQQ9EruVH0AbH9jdZpoyN/VxkBeDJA6xu8vJ
         CWyGNeRu7WZPmYWGRlmEWro4+/AZA/r+X0ljf4J6Xu5qxTlym60uTnkgUjQ1OkM/msWv
         ZkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457951; x=1787062751;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w6H2WCcHsX32RYT/hOSXVqj9RwYA0w5sFO5iwrRmZuA=;
        b=d8bURAHeZwm9rlU8yfdj+d2i2xKpM5m0fXyyAV4W+nAG0LcEMJNj/Fw6SO+P+F6Kmx
         9kyF121dWYOB4ZHUnUlPaFsbGquXqXpG03afKyTOsHjJwjgBbA75yF/BPJmwAiO+qWpv
         Hs3vBpH3IgGZ0Ol3SJeC7KW/+Q+UcHIV8WGU0ZKVj66axuYMf496Ph3IAfy1UyR7hut7
         +CVh8xqnYX0jglHhhGJeoN5AlQLNIGg0Vt/4FPQapZZ3g+y1NX1thKcdv9wqlRxGi2iH
         7dieh/7CrDpqWPiCzkvbXD+112GQIR3FpVdrypOquo0xvb0ViP8Dq8wAPyP4aYUDJwqW
         zmyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq+QyBLbubmqZ4bIphRbdFxLjWUeYRNxtbeBpn8TA1R3dVoolXXblkeL0CI5o3AwSIT7fnE4y1Xgv4H@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8LkFPNyFB7QgjnfxM33j57yWVEarEdHR0E+2QRsrj6AyO8Zww
	o7dJCLGUIN0xjBL4L6RTRrU0glqdQ1DpMYLEj269bSS1ikifDgLxQJR7dCusta9oTFUvrk/FI75
	slYoj
X-Gm-Gg: AR+sD12H0trDUZnJqmCm1O+iUeG+1oZszULiCVtvvBI+gdttNnlBrwST8yLQ0MjEK+e
	OgG9U/zLAH0xnN6jkM8TH7A3N3ZH2rfXxFlkQp3ziQuKFCYZeWMbRRYZz9DMqc5kXbr/TmlbVfu
	jsQ0FSKK4b53tOiGPjUL7yS9tJpsPHmESeeB7EeDdhbp+QwugLwkmPeShOO5Q+stSQfUE8QW7l+
	iLOKBQw0TFwcmkXb/luiDKVY/0Gj3WNKsuMOx7TO7NZlEZ6U9KJSca35a4YAObQS5kJQ+wrPIOL
	GjjdIOf5xetw1sqzmiLxPlioBBP9FhbnD3l6hCVmt6iA2zlT87nRk9DXndtuZQNVWT3njRomiFg
	aB79qX6hTFD0qJueGQddXUYgrhr9DO0gBM0y510M6Rcm8jYze/4UydCFJRQHCFmyR9Y+8k31HVP
	SAcmZcFtjfahMeYwOjylqLFSkF6jeFyJPU4bL/zQ==
X-Received: by 2002:ad4:574b:0:b0:8df:1814:3a1d with SMTP id 6a1803df08f44-90a6c1def77mr2177006d6.22.1786457951441;
        Tue, 11 Aug 2026 07:19:11 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c26e595sm358596d6.1.2026.08.11.07.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 07:19:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtnJt-00000002VGO-1ysG;
	Tue, 11 Aug 2026 11:19:09 -0300
Date: Tue, 11 Aug 2026 11:19:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yili Zhang <zhangyili01@baidu.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] RDMA/nldev: Guard against NULL ucontext in resource
 dumps
Message-ID: <20260811141909.GF544626@ziepe.ca>
References: <20260811105623.48633-1-xVq3SwEoxhQs281bogBL>
 <6a7affdd.5c752b50.b00e6.7ed7SMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7affdd.5c752b50.b00e6.7ed7SMTPIN_ADDED_BROKEN@mx.google.com>

On Tue, Aug 11, 2026 at 06:56:23PM +0800, Yili Zhang wrote:
> +	/*
> +	 * The uobject's context is cleared by uverbs_destroy_uobject() during
> +	 * the RDMA_REMOVE_DRIVER_FAILURE fallback path, while the CQ itself is
> +	 * leaked in the restrack xarray (its destroy failed, so neither the HW
> +	 * CQ nor the restrack entry can be torn down). A concurrent dump must
> +	 * not oops when it stumbles onto such a half-destroyed user CQ.
> +	 */
> +	if (!rdma_is_kernel_res(res)) {
> +		struct ib_ucontext *ctx =
> +			READ_ONCE(cq->uobject->uevent.uobject.context);
> +
> +		if (ctx && nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
> +				       ctx->res.id))
> +			return -EMSGSIZE;
> +	}

It is missing locking right? This needs to run under the disassociate
srcu probably

Jason

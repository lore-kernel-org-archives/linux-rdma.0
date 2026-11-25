Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617924;
	b=4Xng+6a34/MN+ezYa/5XZ5NGVDX+o4MSyRqv/95YAQYDAKtcWRo6Ug9Z8a/MJEizvfLw
	 HJhQUQgRon1U3iOVI6oDKz96ZAMLWGtg4Zy165i0nZhpmosAKbz2T56G+9jIm1CcSLOuA
	 nAMWHSkAjI8J4avbd73w0k/yItKSFxWNkSHqBNYQOg9y/KRvZmPJhpTuG52ZnZtTB3qKS
	 C4STocl1HbT389a6bkx8DFjK7/o+pB8zqbMTbAwWiRsmZbZo+6Bh3jpbQ7udit1ZAXn+z
	 C9t52ahzHuq9q07prioAJHU5sWFOGe1FAcfamQ/Vv/xaK3IZ3MUi90ZhB3pLnx5/XGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GQIqrvkEuCQaYgl8JZYA17fRuuRBiz0DeFEwMWUBlxE=;
	b=HoZPY07/4FscnmpgyHIU9Rtm2oKUkM/VCMcqVvspwhb7epDcLLJmCr7fyiTmSKfIgJsg
	 SG4NSQ4iq2JJXN7idL/mOhZQFGe1s5P5kHc/Y13Rp4p48YjfpCCOnBxgPG14oqw7qJyuc
	 iPDMGJHTWWzYNtGQRbRmCop62JxS5WwqkHDYlw+0yPrfSMFihhVEABWS3piq2lmqMiRot
	 WpsMHVUIb07K67w+DdqZ27ZwyjZY8NTOEgqlffs6ROdXN8Dxh7hz7TvfbYey4Ts/Z2Jh2
	 eMrz2LDHnf+W7hBtyz492waaujUYO3zaxYQw5PSajRtxt4qHFD7Xdf1PwLYPdJRt/5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=GfHorJdx;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE6606A329
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 14:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2DE6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=GfHorJdx
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-949657a20d7so556236785a.1
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 06:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795617922; x=1796222722; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GQIqrvkEuCQaYgl8JZYA17fRuuRBiz0DeFEwMWUBlxE=;
        b=GfHorJdxm/Tm/nk4NUjeAJQJeMDopYjbHRxpuzqoYvpqO3p4antAF9Co8gVV9g2PyA
         D+jEJvpcvNWs8JcznIBLvvI6KVXvooCwh1nHS41khHRAT+PPGeO/UsbuQiLLN4qglPfq
         QLJh+SV2O/J9aX4fleNQ/yXAxWIU21F5ryaFCt1ewGBY0rJxTkRvmr7Y+D9KNsR348Ke
         4VMocHdeZqjkQzWEJoUCRhhNC7TEWSHXg7Jn2gULsuOvbM9z5sgLSwQqCPcsSb188vFb
         Od3OsLXLJv9gyijuBwth+ELtyRHOI5qlbVseSdKjv8ldSPwWObeNyteRxVKytQu0/Zov
         u9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617922; x=1796222722;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GQIqrvkEuCQaYgl8JZYA17fRuuRBiz0DeFEwMWUBlxE=;
        b=bfu0JOi0z2e7cWUaHrsmoXvqawY6OcwaX7WOUNcxgeZ93lsKdgcAML2Msh7EPHfsU9
         inguRW0O19oUGDczUP5rCr8rZYn2zvhEAP/YodlIKpb7w5OW5jw0Pbl9XfHGwScgBPAe
         kQdzXj7S+NG8SPwJvDdGslGjq1wgucELExiBZ0Haw+WZ+2cta+8qQaXgev0PMYYYSX/3
         XNR2ld0g3L2Vl/gVR1Y2nU0TpiSC9Wq/12UIxCTGuRjfUS+ck4XQg8GuzJaFsS7+W+wj
         1S+nIguwDPsPtQ8TCywIuHl4VgCWkWq8BYTh9T05easAQ0w6/ST82mbH21bMedcK2G5h
         56ag==
X-Forwarded-Encrypted: i=1; AL+hErHu6S7Y/w1ZEkq2rbPQ/5zi6WAEgKrGG9K1SNDbsMlfUCoU6paF0Z4dZqKOXCmsbONaSnOaNG8wJcep@vger.kernel.org
X-Gm-Message-State: APuU4Z/jPk5UxbP6v22oa2fQhDkG0za8ik2P8EMd3YKTkwxKOdm+ETdN
	EnlHGaFl68B2G6DQ3n2l2VMpycT80Ek6u6tWWJuZLYdvQZxIiAsEAphfbXa0bFIEPtk=
X-Gm-Gg: AZFdTZeI1GXhWvdxTt1ECJ9wVf4n53YWLfJCHRFwYcb6fPOKI++TmpklctrzSsxZrhB
	eT5s3CFzW+QhCPxhBwoMWaYgtJhg4bjJmgZYShUbVWBoqJic9MXtVegy88ddgSL/c4Tyl+xTTLM
	xhA5A+8aZCwXDO4nrYhBOI2gExiTPj4OckrXP38Pf2g/W18/njUIOsF3FrwP/2ClsD8RIUKKUPN
	qQ+N687Aqv7EcgjM0j60jmbUMYoVR9flyaUhgnytFAbqkWxtP0biRokq1SasVSUT5i2W4VUf4xC
	aDEK+Ho8ezm6MDjIeuwOO5qHINZmdUR4a41Cvy3jvi/Pct8ESK1QtNz8VXBaObsfMIQaeyGD4de
	noX4QCxYsBFplt3iOpiGvoohxFnfRRsBPSM5zEF24FcOikn2J5ToXvkjaj030ywG63DlOFBAWjw
	MQg8zwpQj6reuarH6L/lMkxtIRsfRu2wDWE6PM6EqLEsss9iI8x3CpoVDqMgtppFnqMSnh2XV9p
	sgh6Pw1D8B1EDEPvhiMbJyhVkN5Dh5XLr6x/nPqwn83pePIOlislh/B0tX44j89INYR46tCohZ/
	RF8TEw==
X-Received: by 2002:a05:620a:6487:b0:949:9a8c:7052 with SMTP id af79cd13be357-949bab1577cmr2699750285a.70.1795617922348;
        Wed, 25 Nov 2026 06:45:22 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38319asm1327544785a.16.2026.11.25.06.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:45:21 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWEFN-00000001mSD-154e;
	Wed, 25 Nov 2026 10:45:21 -0400
Date: Wed, 25 Nov 2026 10:45:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261125144521.GI246011@ziepe.ca>
References: <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
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
In-Reply-To: <20261125090309.GY14811@unreal>

On Wed, Nov 25, 2026 at 11:03:09AM +0200, Leon Romanovsky wrote:
> > What do you mean? This is a mechanism to help the user manage software
> > versions by not accepting incompatible rdma-cores.
> 
> Please take a look at the patch.
> User space provides that new adversarial flag.
> 
> +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
> +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
> +	if (ret)
> +		return ret;
> +
> +	if (ib_dev->adversarial_mode &&
> +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
> +		return -EPERM;
> 
> ...
> +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
> +			     UA_OPTIONAL),

What's the issue? If the user space doesn't ACK it has the new
software then it doesn't create the context?

This is how we do every feature that needs rdma-core support, though
more often there is a fallback in the kernel.

> The kernel does not care whether rdma-core is up to date. It works either
> way, so why should we prohibit older userspace on these systems?

What do you mean?

 +	if (ib_dev->adversarial_mode &&
 +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
 +		return -EPERM;

That is not "works either way" that is requiring new software. Which
is exactly what I want to see here.
 
> > It is not a security mechanism to hard guarantee that rdma-core has no
> > bugs.
> 
> It is you who talked about "... security downgrade ...".

Yes, in that I want people using normal software to have a safer more
secure experience. Meaning you need supporting rdma-core if the kernel
is in adversarial mode, because otherwise you don't get the right
security outcome.

You took it to some absurd scenario of a user hacking their rdma-core
to defeat the check, which is not the point at all.
 
Jason

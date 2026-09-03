Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011544A2A5E
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458393; cv=none; b=sd44RO3FVcYAe2mClObnlO1q2xQWlXYAPXg4UY4R0gAV4X9BQVHlpX89WxvXTnd+dVkC/FMjWR9YhH4G8yxTaUewbaWUrgpkg5mFErFvoIcXpz4lGllNAlmYH0OQgZtXclQDR8uunyydbebpTgAYEN7o0oNa3Tq6Eiq1LveawdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458393; c=relaxed/simple;
	bh=mhAzQG62FgrcbrLHDH42+aukrfI6JHY7lgjeZmFzhFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oz32uKe3TaWGhbjS7jKRTRXF+9FRSBdTtG5yt/kgvM0PHS7bEFwwkpHqVuJZVJLDIDv7Xq1bEBk9o3R63IvihbVNag9vgYZgHSb1HfZzQZsR173oL4kdK06y8pFP9fKaZKEcFHkfwGVgGTkslJULAL75T4ua+0MeeW3gzwA+K9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q2Ki0FEy; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q2Ki0FEy"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-936cda0e3fbso7623685a.3
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788458391; x=1789063191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pFXz/2j56VPQACuH/B4wZxG+bfQ/N8fEE2dczeymib0=;
        b=Q2Ki0FEyOpnE4Ff/RS4GwTwPMYuiU6nqkIuCkNvBOZucGACxZEPbKhKRhzc2xnKQgD
         ZQzJwfg0aoFES7WitHglMx/EvTdo3TnT8CHGXKoeX/CCLfZTNBvy/9cktnJNFYJCZC7e
         js+i6XUvqm9X+wVFyGmyV3wXXjeF0i5DLQj9pyI/qD3j46cxvcT/zvfkOH8bT8TUvkd3
         HOqfJNCHKNbBWAfARYEz3LKp4MX0aUzn5DSJaI+G2pNvXyjupMRjApZ4Oj0SyIML09GE
         E/sn6AC8XYIT2sgsQb8vUgPGcAva2MBPudp0mY3qSINCQK0YFwltyLfZKvuVbpbMs3hH
         r8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788458391; x=1789063191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pFXz/2j56VPQACuH/B4wZxG+bfQ/N8fEE2dczeymib0=;
        b=ge/CbkZ9m310uJ5660pA3BpQqw57IFoBcrVT9Bp6J6CLIJqh/NNgbzwbUSvpzyayVs
         Us6iuKhIssNR0Mm6SwIlc9xC8e3dI0pp5HoRWdiHRq+ZK19zq854q1/f4MM9J0wpoxk/
         RQYTEDewMuXNY/YSbXlg7FW3583AvGCNMmA1Bv7n5TISCMzxbEd4+FVCRmtJi+yqZB4t
         RgUlaGR/EJB/3JMdp6FHkNAUVcQsxH457FmWA2flOn38WGyl9uXFqYBFi4ptjEx1nFXJ
         AVo3rvZZAg1IgTUr9l7rpJmFCBDlaYXW33D3C3fUi1VDqaEADfjtI8LuNYEOKGE59tSu
         KIVw==
X-Forwarded-Encrypted: i=1; AKwUvBwVZiMXpMe7R3sems3RHiE4tWtKAauWUAYO0e4TEZkqjHOsub69OeVYD0z9eBNkBwewdXxCPIvEq17N@vger.kernel.org
X-Gm-Message-State: AFuF++mVkYCUgckBi4o/sVjJdMTCt97da1lE8WTlxhSJimy59U6N+QUu
	R2iOxgG9DXdFi74tApgFMf49zAJfzgYa28Fi121Ir1l0M9LNP0PwRjRxHIyzF9XUkBg=
X-Gm-Gg: AYBFou1LQJXK9nQKwJm+8IECyRCf0b8zRKMngoROvD4/dW6SHM9yY4QMI0RVAml/c9k
	HJ6ffdasYxfhZ7oAIf2a4DAyiYtVKegBjBMTcVV1hUKdJqElgoPUcTuUnFiEQ+XPR/kJjm8zaoX
	qh2MKnaYyoQ3RmyJI2XLvKCPwBpyTeD5ccLgmW60BJSNYW6RdRHMHs4F4KD7KjCNkpoxKU8icyo
	DzsoH9J/KmjHdcHeBoXPtYlAtzbajY03uHTPNXnyJCRJyr4UN49vAeRXtucsSeLyktc55lWBlmu
	KUtlry3ldLuWlPST6P1hBI3CR6IX4+/t2VNe2Q7AAgKQxjJVgLMtaljxS91XFryai6OQbkK4ISV
	eirUGQ52jDgXu16UouQXM8FHGxDj2ZyXyMPpj0bIAwTonw84OLknrmvGF2es5gkNYmOUrN2GZvt
	4+lfg9KMN6FiqR3pderYuWaKEXRapigxq9ZngxACCylsq3X13QKuVLTMbMcZtjCR4rG78VhQICO
	EcIfTu0nYHWpW1XgF1NAqnL04Kc/II8gE82/B44Lyo94YDYHu51mOotVA==
X-Received: by 2002:a05:620a:2604:b0:939:4e49:4d3a with SMTP id af79cd13be357-939806da015mr7910785a.27.1788458390741;
        Thu, 03 Sep 2026 10:59:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397f80ec56sm25270185a.0.2026.09.03.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:59:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x2Bj3-0000000032R-06fg;
	Thu, 03 Sep 2026 14:59:49 -0300
Date: Thu, 3 Sep 2026 14:59:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: leon@kernel.org, Dean Luick <dean.luick@cornelisnetworks.com>,
	Douglas Miller <doug.miller@cornelisnetworks.com>,
	Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v5 00/24] Migrate to hfi2 driver
Message-ID: <20260903175949.GO2890729@ziepe.ca>
References: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>

On Thu, Sep 03, 2026 at 01:54:27PM -0400, Dennis Dalessandro wrote:
> While sharing similar bones, the chip for the Cornelis Networks next
> generation fabric technology has some fundamental differences that
> resulted in a near complete re-write of the driver. It also does not
> use the private cdev interface that the hfi1 driver exposes. After
> discussing this with the RDMA maintainers we have decided to go with
> the approach of moving to a new driver and declaring hfi1 obsolete.
> 
> It is desirable to keep hfi1 around temporarily to let user APIs
> catch up to support access through the uverbs device rather than the
> private hfi1 cdev.
> 
> This driver is designed to support future products as well.
> 
> Portions of this series were developed with the assistance of a large
> language model (LLM), reviewed and verified by the author. Each
> commit affected carries an "Assisted-by: LLM" trailer per
> Documentation/process/coding-assistants.rst.
> 
> This series applies on top of the rdma/for-next branch.
> 
> Changes since v4:
> - cport.c: rate-limit the "Op N SS failed" error log in cport_req_fn() and fix a
>   use-after-free where msg->req->hdr fields were read after cwput(msg) had
>   already freed msg, by moving the error log before the cwput() call.
> - mad.c: treat undersized CH_OP_UMAD_9B/16B payloads in cport_umad_handler() as
>   a normal, expected occurrence (e.g. periodic SM keep-alive/poll probes)
>   rather than a protocol error; count them via n_vl15_dropped and silently
>   drop instead of returning MSG_RSP_STATUS_INVALID_STATE, to avoid flooding
>   the console.
> - Updated the AI attribution trailer on all commits from
>   "Assisted-by: AGENT:MODEL" to the simplified "Assisted-by: LLM" per updated
>   upstream guidance.

There are over a hundred sashiko messages, this change log seems far
to small. Are you addressing them?

Jason

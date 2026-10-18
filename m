Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6122D662F;
	Sun, 18 Oct 2026 10:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792317907; cv=none; b=t67qT7TWGLxOsK/WEzU+4P/pPHmYnd9z9x8+rF/+bYLbHar9GWxD5xlqFfpen2jc3a8E8n16b5JcC/dMlnjtsltk2Ik6CvsZm92hCfAXb4bOKGPcFS24qqza2hw+IIuxdebdfTT03QVSgZeANMnltF0CqTdzNMaLYSIus6Ikpw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792317907; c=relaxed/simple;
	bh=iBBOOIDSN4rXVq8ehqpWoq1aASxZVdGjTkjA9rAhVC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBdAypULRal79QN15jdJTROTfqDmTWj7frjxkDxq92e/z9hb9WKuNS/ggispPWm1VmYU2MJG+GDS2eqTuBzCw5w8HfS5Z6zfveAL49eQtUMY+IO0bBkDP1nZ7U0BZDgEVzN6zQTut/5CMvpdaZQdMBHa93GivyX/nhOh2S6X3c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/XJS435; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/XJS435"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBFA1F000C4;
	Sun, 18 Oct 2026 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792317906;
	bh=iBBOOIDSN4rXVq8ehqpWoq1aASxZVdGjTkjA9rAhVC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R/XJS4355XpZOyE4U1Q76yO0n14JTSVZ7LWyPgM8uQOjphEgunOhHV5srhThC7JdG
	 9nSDsvTLpsT35lQQ6w4qk81deT4+usx0YKSOZEMu8Ax35WB7rm6KWghRcCMiZ6Tx/8
	 X/tleW35rndn2m2ICLL/bvSxcqXYceOkNcPFNYvUgoNVAQaI4yTpc3pQGEHZmn0I6k
	 4DYy+6ofipopRn/dJ3Ofx9+FblVqsHdYIgUB7Ls0az6OUHOc+1jpOr+RI6Smmna/ng
	 e7clEw804Y+LTPeJqUsv4dy79UTqc6ViSRmKMbcIMBWcI4S6bYoSR6QoV6gQ0TO/RP
	 zmK2qoApyUFGw==
Date: Sun, 18 Oct 2026 13:05:01 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Andrei-Alexandru Bleortu <me@andrei-z.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
Message-ID: <20261018100501.GA41539@unreal>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-3-me@andrei-z.com>
 <fa01c872-9d1d-4b60-b994-08ba86a5ebaa@acm.org>
 <20261015212227.3338582-1-me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015212227.3338582-1-me@andrei-z.com>

On Thu, Oct 15, 2026 at 09:22:27PM +0300, Andrei-Alexandru Bleortu wrote:
> On 10/15/26 Bart Van Assche wrote:

<...>

> If you, Jason and Leon are fine with thi

To be honest, when I saw these AI-generated instructions in the cover letter,
I ignored the entire thread:

 "Tell me if you would rather inline only when it is posted alone. Before
 going further I would like to know whether you want these."

As for your question, we need to hear from someone in the ULP community
that this series is important to them.

Thanks

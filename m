Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692833BA232;
	Wed, 26 Aug 2026 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787735474; cv=none; b=ePe/N8VEKUCKmJ8BofCdUdJZPCUmt/w3Ffw4Bc98sZCH8wCGJ/nI9T4SD/NVQOcYOjkQnPR05k4aSIWFoC9C5SXTEsKl9tWsLFau95TdZZ27bCq8PbrUNLafbwPu5p6+7WfsbRo+c6ORGvxEcS+q+CCwENUE7c367JIcXx76f4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787735474; c=relaxed/simple;
	bh=887TfgrNgGSFJL+6j0nIa0G1yh7kl1GtEYcn1+PmB/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XT/9oMTARXfGk3neaW83cbg8u4wJEdoAXxTei/Sf1ER6DLD7QVo2N6yZ4Y9TRnLgWMgxgWq52o93f2CWnNHYquTIfozXu2NsIHqaWSPKb/qZDJ2jYquQcJbNcb6SRoX6Z8CdJSyCn5nNz3EcGHixcHOi4dfg9YYEmcaC9UyX14U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oo9OgNi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oo9OgNi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A1C1F000E9;
	Wed, 26 Aug 2026 09:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787735473;
	bh=eI5nqmCk3yvwNEmwIcySN9wJ2Go1ErbxMWytjOmKfOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oo9OgNi9WTr0hNaGqcw8R+zfiOATQ5UHUfuHHYQe5M6Hx+RbJDBcmtGvPjQpwsuGv
	 3AFqRnMm5NJxS0WxRT3l4sV/IoA1JFBxKRWxz8c+MGLBdEOrej8HGoGJj3MJ/L1BIq
	 RVLVl2p+cGnOY6l1ONpMX7ocL56cEnfyofLT4XWNuzhrHJB+7C4iIoo1qbZF/B9934
	 jLnEleKlrjWkE4LwJi7og5J9A6e7htWVTcO+9EkIuGK5GkTVl1EZtx6sEPXBtnbkGi
	 fri6mP7J9pthJ+jTHTwhaVg8D2Se41kgH9LL5qkbMfJT9DbelJHZzVgYRqQ9u6lLjS
	 DB7FhQbMSgDmA==
Date: Wed, 26 Aug 2026 10:11:07 +0100
From: Simon Horman <horms@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Qi Zhang <marsy12010123@gmail.com>,
	Chengfeng Ye <nicoyip.dev@gmail.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>, stable@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [PATCH net v2] net/smc: prevent device removal during connection
 setup
Message-ID: <20260826091107.GA22033@horms.kernel.org>
References: <20260823071908.93212-1-marsy12010123@gmail.com>
 <cfd7450e-0098-42e3-af4f-d5b47e842d23@web.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfd7450e-0098-42e3-af4f-d5b47e842d23@web.de>

On Sun, Aug 23, 2026 at 11:37:17AM +0200, Markus Elfring wrote:
> …
> > This change is limited to the reported SMCR lifetime race. SMC-D device
> > selection has a similar pre-existing borrowed-pointer lifetime issue and
> > requires a separate fix.
> 
> May lock guards be applied?
> https://elixir.bootlin.com/linux/v7.2/source/include/linux/mutex.h#L253

This approach seems fine to me.

Quoting the documentation:

  Use of guard() is discouraged within any function longer than 20 lines,
  scoped_guard() is considered more readable. Using normal lock/unlock is
  still (weakly) preferred.

  Link: https://docs.kernel.org/process/maintainer-netdev.html#using-device-managed-and-cleanup-h-constructs

Reviewed-by: Simon Horman <horms@kernel.org>


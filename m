Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9408836654E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 09:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771925487; cv=none; b=d039zDmenWGK6JaWD/H1snkgoh8NwC8vX3ybbybjG7dfZ4buaQlLeJdq2O8j3lBSO1LQjxmvqylVNN/G7D9DvfjxIr1N7HEXilFl/+hz7pDYoymdnY4Xnfr4GsSfPnVhA81+wedd7G2hpXJ4VsViU5hdP7Gph3Tzuz0YqNNrbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771925487; c=relaxed/simple;
	bh=S7IWpITAoUEwYn3LTUe1fGiUYICDw1ARHGAWT4odt3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5dKTH3ggR1/Q52Fyp+WUOdz1aE4Q5rV+YN9hR2mpZXLh5kqILv1iEfkBZVo5BGhss6ZAWHkRtGAFq9FgaltsSAHfTiJsNLEynK2kMQjn8n+YGfvmlSETA7C1TF0HkMtB84TvLZnkLIAXNS75Vp2XTKOftldcSPdpOhwfpjlBLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIsDrCHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIsDrCHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C87C116D0;
	Tue, 24 Feb 2026 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771925487;
	bh=S7IWpITAoUEwYn3LTUe1fGiUYICDw1ARHGAWT4odt3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eIsDrCHwEu+VmxcJVyYUoV8bXQ4Uk3Z80RuN/txNpA3gAEXiexjOC1cC5eUbFwwGK
	 feFBG8uSmhAYyDnzaP8Sm0dDzvDfOjB2gysLBKCUWWPeJrPkMjnqfJHpbHWpoys1GG
	 QQMmfEA1hTz0IZWNrF2lm1nCdi/TaBm0RR9o/KeHa8f60sWhGAKCamIYA7UqOshwUo
	 tCNLg0tSVeHKuJXEnLQ356yYPCj6CYJHwcFgCocwzYUh0fUNMXujXVnZvMa60ZFj8T
	 R/+p9TA30CIcy15DUOKKyNplWw+knnZllyQsM0fiF7qwoFAEwNSvw9gxRPZJNXAmAB
	 btDrI+4axwz1w==
Date: Tue, 24 Feb 2026 11:31:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Hebenstreit, Michael" <michael.hebenstreit@cornelisnetworks.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: problem with duplicate resends
Message-ID: <20260224093119.GG10607@unreal>
References: <LV2PR01MB9940993E9E56B23CEF734AC4909B68A@LV2PR01MB994099.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV2PR01MB9940993E9E56B23CEF734AC4909B68A@LV2PR01MB994099.prod.exchangelabs.com>

On Fri, Feb 20, 2026 at 06:48:21PM +0000, Hebenstreit, Michael wrote:
> Hello
> 
> We have a problem in a Linux cluster using Omnipath 100 and GPFS. Typically, after a complete reboot the cluster works correctly for 10-14 days. Then problems start, happening about once ever 2-3 days. This makes the problem very hard to debug.
> 
> The problem starts with one or more storage nodes (A, B, C...) being unable to write to a "bad" storage node X. A/B/C/... would then throw an IBV_WC_RETRY_EXC_ERR error and close the QP pair. In response NodeX would also close the connection. Afterwards GPFS cannot re-establish a new connection fast enough and everything goes south until the NodeX is rebooted. GPFS is NOT my question here though.
> 
> During the last crash thanks to a new monitoring system, we discovered that NodeA/B/C/.. would execute 6 RDMA retries and accordingly the RcResend counters on the hfi1 driver would go up. But on NodeX the RcDupRew counter would go up in step with all the RcResends. That indicates the resends are incorrect and had already been previously acknowledged.
> 
> The operating system is RedHat EL 8.10 with a very old rdma-core version 48.
> 
> My question - is there any known bug in libibverbs/libhfi1verbs-rdmav34 that could explain this behavior?

From the upstream perspective, the answer is no. We are not aware of any  
related issues or discussions.

Thanks

> 
> Thanks
> Michael
> 
> ------------------------------------------------------------------------------
> Michael Hebenstreit         Principal Performance Engineer
> Cornelis Networks           Performance Team
> Tel.:+1-385-393-5444        E-mail: michael.hebenstreit@cornelisnetworks.com
> 
> External recipient
> 

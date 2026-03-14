Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6091A2545;
	Sat, 14 Mar 2026 19:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773517856; cv=none; b=IPJsdN0d1bAWUzQkgdgWMpkRRIy7M9MVUJu4pi3GjPrg8pxjEiPPxhVuBj23Sjluf/iM8tndGzuDRpbinJB9DZz9s92dbY7fCL8wr6UtM7V8ko0qZlBQuERTnpvBvw4C0/rGhMpxa1h32lrfNkvFwr1U672uvZ32D4bXY+N0T94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773517856; c=relaxed/simple;
	bh=x83of3pCZL5zt0JL1Vs+J0mJZUPe+x1bQnV5yZKxK/k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6gZYng9V+qFOTUKw+SbhK++fRsNQJlY6N6+Nz+pqqNqDNqHiOaOtIhTc09jJzKi580q1WpKGJX3v0vdkzvsQLkYDoKk8P68vi1aZsBEgAt/ia7npwP1YuUuAsHh9ziJxdxeg8O5JIEvQtoraXtyXhoGluGmumZHxMIgbrNZoIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ck3kZJWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ck3kZJWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAD8C116C6;
	Sat, 14 Mar 2026 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773517855;
	bh=x83of3pCZL5zt0JL1Vs+J0mJZUPe+x1bQnV5yZKxK/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ck3kZJWSzRE+ThVhaipuz+gu8TIY/DirFQgn8+akov6U4C9igeHq7zrvycfWE4vvv
	 +XGN83/OwtXZBsI8nuoSb3Q3oWSJQ33VQK84RqQ+M9QwuXm952WIPC+XbXrpN4iEZc
	 xYgdQjHJsyUfqkOwMurzh8vSFwD5icq0hUNbGV0B72hCRKcvNI6hgIm4ZL5rDb0nTx
	 MLSFykdS0qQbBrl/lFfP9mFXWiK0uty8S5Xk7mQbyqaN1xbmh3S+xSlecBrahoVZhM
	 e+vHlAV2z4W8hfK7mpom1qNSVbDFDbxNEeteoEi2jYQRyjh1wV51Uce47xsrj6jvO9
	 wmN1AxP/bW/qw==
Date: Sat, 14 Mar 2026 12:50:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 dipayanroy@microsoft.com
Subject: Re: [PATCH net-next, v3] net: mana: Force full-page RX buffers for
 4K page size on specific systems.
Message-ID: <20260314125053.41d6221b@kernel.org>
In-Reply-To: <abDo8XTu1EiQFC7T@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <abDo8XTu1EiQFC7T@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Mar 2026 21:00:49 -0700 Dipayaan Roy wrote:
> On certain systems configured with 4K PAGE_SIZE, utilizing page_pool
> fragments for RX buffers results in a significant throughput regression.
> Profiling reveals that this regression correlates with high overhead in the
> fragment allocation and reference counting paths on these specific
> platforms, rendering the multi-buffer-per-page strategy counterproductive.

Can you say more ? We could technically take two references on the page
right away if MTU is small and avoid some of the cost.

The driver doesn't seem to set skb->truesize accordingly after this
change. So you're lying to the stack about how much memory each packet
consumes. This is a blocker for the change.

> To mitigate this, bypass the page_pool fragment path and force a single RX
> packet per page allocation when all the following conditions are met:
>   1. The system is configured with a 4K PAGE_SIZE.
>   2. A processor-specific quirk is detected via SMBIOS Type 4 data.

I don't think we want the kernel to be in the business of carrying
matching on platform names and providing optimal config by default.
This sort of logic needs to live in user space or the hypervisor 
(which can then pass a single bit to the driver to enable the behavior)

> This approach restores expected line-rate performance by ensuring
> predictable RX refill behavior on affected hardware.
> 
> There is no behavioral change for systems using larger page sizes
> (16K/64K), or platforms where this processor-specific quirk do not
> apply.
-- 
pw-bot: cr

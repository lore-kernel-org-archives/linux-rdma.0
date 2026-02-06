Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622EE3793BB;
	Fri,  6 Feb 2026 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770374945; cv=none; b=sPw+0XSOFO5DLD1RT4Dm/KvmxHDO31Le3O1Ri4piUKwg+orakc9NQT1oPZOwjhpqByZk8mER75caVtuLMmbxiIsAl4UFl9GE0KhRh4v7ydIvo3ZnSbx5KJYnYn9AVyBdP2rkPnqtJv+hEwI73B1OmoXe3S0GEsFTGiWDmicZ4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770374945; c=relaxed/simple;
	bh=E3is48nCJBRGPdqXNixf1iJnUmoQc1bz645I0QrY9Jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C33xdFL+WAagGCL4T+D1ZbNK+jiFbP49kgTif11b2wYOLZvg3ZPR+5gHOYFFeGLLS/9ZCZLKvWUkoQkXiDuVdFryNwWmxGZU1FkqqqmPnfdg0hJY/pZgUoxFKyHVR16wH7JyrdRX2nBIw6v0+FFpphOgHkeYgmZqdHB3W95+r7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H8y+V1Jr; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H8y+V1Jr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770374945; x=1801910945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E3is48nCJBRGPdqXNixf1iJnUmoQc1bz645I0QrY9Jw=;
  b=H8y+V1JrMXkv6aydoFR1gIzXWCbiUpOffXPtbOiR/aSgr5gx+ISoX7cM
   aklY65iXrITo/Nh7Rujsg9+1P2mFG59l2qxWBpzMcxIsgP9HiLaR0b23q
   9tOVtAnxAROQxY31PerlYq3Snbho90x8YPUswuWbhrtwyWpl9vJYxc3dv
   /HPc+eEqW6o/iZMt7k+urMC+Rz0pS/bjmKHrGuL4WSBHk8TawEPVpmefL
   r99VA5PDNijJWfpdcd0ysy/P1pwDgFj30d2c6XCTZMWSkVGN7T7PIk2Xv
   DjpQotaVVu26PqGOvy1L9af6E1ODoY9UuTldrAKs0N8RKgFq/RjVHbpau
   Q==;
X-CSE-ConnectionGUID: L1AY1Yn0T9KylNAcy0mmuw==
X-CSE-MsgGUID: KxPmgfSbQGu96NE7pQKsZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="75436132"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="75436132"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:49:04 -0800
X-CSE-ConnectionGUID: L5oLL47BRpaMkoIGzL+qow==
X-CSE-MsgGUID: 5jy0tHp3QDijN1tNuWmGcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210663466"
Received: from soc-5cg4396xfb.clients.intel.com (HELO [172.28.180.107]) ([172.28.180.107])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:49:01 -0800
Message-ID: <68fe9c87-c8e3-43eb-a40b-4b05267fa236@linux.intel.com>
Date: Fri, 6 Feb 2026 11:48:58 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: Fix 1600G link mode enum naming
To: patchwork-bot+netdevbpf@kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, pabeni@redhat.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, leon@kernel.org, jgg@ziepe.ca, saeedm@nvidia.com,
 mbloch@nvidia.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, gal@nvidia.com, moshe@nvidia.com,
 ychemla@nvidia.com, shshitrit@nvidia.com, Tariq Toukan <tariqt@nvidia.com>
References: <20260204194324.1723534-1-tariqt@nvidia.com>
 <177034620683.657894.2565367947070195735.git-patchwork-notify@kernel.org>
Content-Language: pl, en-US
From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <177034620683.657894.2565367947070195735.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-02-06 3:50 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (main)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Wed, 4 Feb 2026 21:43:24 +0200 you wrote:
>> From: Yael Chemla <ychemla@nvidia.com>
>>
>> Rename TAUI/TBASE to GAUI/GBASE in 1600G link mode identifier and its
>> usage in ethtool and link-info tables.
>>
>> Reported-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
>> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
>> Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>>
>> [...]
> 
> Here is the summary with links:
>    - [net-next] net/mlx5: Fix 1600G link mode enum naming
>      https://git.kernel.org/netdev/net-next/c/215b53099b60
> 
> You are awesome, thank you!

Hey Kuba,

I noticed that in the commit message on the net-next tree the following 
tags are duplicated:

Reported-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Yael Chemla <ychemla@nvidia.com>

Is that by design or did the bot break something? This is purely out of 
my curiosity.

Best regards,
Dawid

Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D703A0E99;
	Mon, 12 Oct 2026 10:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800227; cv=none; b=OHepTF++abUIkT6a6SmrorFGRg1hlO2nj3iU2ChjVhNV6ppvb9W54iV0ALQ1v0WJomZ82MEmqVSxS6aZS2eNwoU8A24scYFgOlr1szxjKqGvYOIoEvKW22vVMsVPSSA15cd36iHvgM8cEQs9uyz7xG8nD5slb1SBi0LgVHjXqfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800227; c=relaxed/simple;
	bh=7tA7xpvV+w3K+s1d3A7rIfvkphffKAuzcmkOIyY0NNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlhJZkUAvTDFXb7oVML/KEAYPYqx57DQLB7pJn+3EzguKU42eHILK+4s5+Z+71n0YJ7rUTfcQmc4XK4cp5E+/XnjkdZ8+fvNAQIzvkeeZhPOuzCJdmDhI+0QGm8WyBJvm8efDJcJZkcdYzwRnhUtrFXCeFLhaB2RymTmP3W685Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=W//EZyOL; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="W//EZyOL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791800211; bh=7tA7xpvV+w3K+s1d3A7rIfvkphffKAuzcmkOIyY0NNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W//EZyOLxvPw1VZhn9FYsvy/w7XuztUoiCAPvV75dUZ5TLbJwQiD8+IbY5fbnWZtL
	 dmMQ0f3bZn2qGK1hYGrWIIXK0BvVX6mtPjcwKZ9Q/O8CejUS8+ajz1A88jj7+7JSZl
	 /xmoeqGmZDaSfB7gmhc5UgapnduGldXZ6iCyVy7Ajn7J4cxzb5YYGq95IXky6RbqFC
	 hseljufSV8mD9cxa0F5hHo5i9nKtNKRbDJGTQNS3XO1GOMCFyFFRff0ldhmuOPm4X6
	 7sPI4ff3ijVU6Pp/OxR7SGvz5BhYEL2YlkdxRqGhsrs2BNMMYlmC7iE1GjymW7W6ns
	 ZpvYL4VqcppJw==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 09B0844C08F0;
	Mon, 12 Oct 2026 12:16:50 +0200 (CEST)
Message-ID: <32eaed95-992c-493d-8aa5-f0a4648367a8@corp.free.fr>
Date: Mon, 12 Oct 2026 12:16:50 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: HWS, fix modify header pool match for copy
 actions
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261010120147.135825-1-acassen@corp.free.fr>
 <179172015106.434549.17424370509568875552@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179172015106.434549.17424370509568875552@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

full review at: 
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr

On 10/11/26 14:02, netdev-bot+sashiko@kernel.org wrote:
 > On big-endian hosts, does mlx5hws_pat_compare_pattern() actually compare
 > the control dword?

It does not. On big-endian the cast keeps the data dword, which HWS 
clears from the pattern of set and add actions. The same cast sits in 
the loop this patch removes, so it predates the patch. v2 adds a patch 
that reads the first dword of each action from memory. The SWS pattern 
cache has the same cast and I will fix it separately.

 > This is a pre-existing issue, but can mh_pool already be freed when it is
 > dereferenced here?

Yes, when that error path runs after xa_insert(). Patch 2 of "net/mlx5:
HWS, fix pool creation races" removes it so pools live until cleanup:
https://lore.kernel.org/netdev/20261008204230.3222198-1-acassen@corp.free.fr/

pw-bot: cr

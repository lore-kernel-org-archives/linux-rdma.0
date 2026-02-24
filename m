Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD2A3043CE
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771923588; cv=none; b=I6oSSEK/44M1zgPGECAEWN1rJRugLkkyyJlarweYpDOWGvc/DCqe6E4Y2LAlJvo28Vkft1xgoETjoLafnwLDzBPPOk5P1RpDCAkZ/LKFiC/jt+6Foy8RyZa3xcBYKsoVbp+4yKLSZ7p4Bvv7L2+yrL1+avY6VZTHJ0CBMY4P6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771923588; c=relaxed/simple;
	bh=7aelP+2yyy/N5uCIGsbVA90RgyrZ4yhjRA4AmdWpbr4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V5JRgrz+Q0yn1rE4Ctp1H+aCwERfGiCjQoQQE8Fan6gJfuEY3FYz6UdQU9g6JOvDOAzkmbodDwD6w2NWu65c6i0+PhiBBsv3LVwcBIQ27SDwmo/oQZj0kjfDBT+Zqy0kSR/LMLO1sngiIRgQ/zvhFtXVSOWsBadkjhN1nA4AeJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOmJkd01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOmJkd01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B489AC116D0;
	Tue, 24 Feb 2026 08:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771923588;
	bh=7aelP+2yyy/N5uCIGsbVA90RgyrZ4yhjRA4AmdWpbr4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=oOmJkd012nfsx50bVixQ/7uWZ8UEdsLlPyjE/DGz388htnQuNmncYjjaGQTJSUuoj
	 wDzJotLYyhEvUV8WhC559gcYH/RKB5Kg8x1D3b4CQpusWQb3GEZRCLOpZ7ItjHCdi6
	 GNK7FUR2YGNwBYClEs7B5imgLQ41o4NwbJNMCCSqYdMYYjT43S8Afz3zS3/CRMpNN5
	 JP/NxdAmoRMwfHhLo2EXErOKVQz/8nOoZ6O4Z6mmk7NIdkUXa4TDaTv0AQkuhrN7uc
	 k/I55rFYjXzfBOc/B4jGV2MrD9SCh3qIjWobsWYr1BiRn6I5pHe3Wtj+2SY9LjngCI
	 AuhGK/uOAVnhg==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Cc: jgg@ziepe.ca, msanalla@nvidia.com, maorg@nvidia.com, parav@nvidia.com, 
 mbloch@nvidia.com, markzhang@nvidia.com, marco.crivellari@suse.com, 
 penguin-kernel@I-love.SAKURA.ne.jp, roman.gushchin@linux.dev, 
 wangliang74@huawei.com, yanjun.zhu@linux.dev
In-Reply-To: <20260127093839.126291-1-jiri@resnulli.us>
References: <20260127093839.126291-1-jiri@resnulli.us>
Subject: Re: [PATCH] RDMA/core: Fix stale RoCE GIDs during netdev events at
 registration
Message-Id: <177192358498.744161.13632880551548809785.b4-ty@kernel.org>
Date: Tue, 24 Feb 2026 03:59:44 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 27 Jan 2026 10:38:39 +0100, Jiri Pirko wrote:
> RoCE GID entries become stale when netdev properties change during the
> IB device registration window. This is reproducible with a udev rule
> that sets a MAC address when a VF netdev appears:
> 
>   ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth4", \
>     RUN+="/sbin/ip link set eth4 address 88:22:33:44:55:66"
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Fix stale RoCE GIDs during netdev events at registration
      https://git.kernel.org/rdma/rdma/c/9af0feae8016ba

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


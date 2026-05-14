Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B401D38B12E;
	Thu, 14 May 2026 23:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778800611; cv=none; b=gh/6e7ArLVQghHWCQ2/COvMZ0jpjpL0BjFJE5EAZl7GlWoRrzrnFTiUbreN/CaUwg5vnDOVeBxiPCofD2BE1kaOZlvBlmDAzUJQzfRaGvrArWOVOn5eIRZQqPKFELzgXk+PQGOmVjg3FZJ6ZlJ8CbM4xICn1TSeNnoRw1wjI9dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778800611; c=relaxed/simple;
	bh=T+K/ByZHfQwBHphS3fmtQi/MNdmVkAYcBhMRQ8BUd0E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZJtOw3iOanm2ul/YXpA8ImsboxxfMg902PD3y3fRkuICkXKr4ldv6IKJDVVVHq0ZOl6IGHzQLCZJ44+CrHTDUR/Hb3icr+NJJrlT1H2Jz6OAkyEiqCngB8f1XEC9mi5o8exFk7rfT8Uz47FLJvJ2vLtzm7SQlgo3R7lG2bXSJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyOZklh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyOZklh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE59AC2BCC6;
	Thu, 14 May 2026 23:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778800611;
	bh=T+K/ByZHfQwBHphS3fmtQi/MNdmVkAYcBhMRQ8BUd0E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fyOZklh5BNe0kvI234c3td8gDlHxIwRViNF0+grmO8Ye0Pjvma7fP1CcWiq9884wU
	 EvfJRKrOMEwxxsLyPCYbNxyasi1oLyBGX4qaGrf45OuV4Z86no0mMozdngSguhIhl2
	 VEDnjRyB1i+oOPwf3a46W9hf6Axa83crG+CcXn0Waf3/UzegSC8wv4bvmoJnpULMU2
	 0x4Q5uE1q3xrUZ0d6cnQPzayszoZLAukw/2G/XhpyZ0swi6my532bW65Suxs14/ysZ
	 +bbWw5y4WRLz3jmJTsinkH1R5wK9kxhF5ZJE7QEOU488EPeuyltkYHRCyLztwvgZzT
	 Xeov+Z0aBIQgg==
Date: Thu, 14 May 2026 16:16:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Moshe Shemesh <moshe@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "Mark Bloch"
 <mbloch@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Dragos
 Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next 0/8] net/mlx5: Prepare eswitch infrastructure
 for satellite PF support
Message-ID: <20260514161649.7a59a547@kernel.org>
In-Reply-To: <639580c8-f93f-4945-acfa-ff116b841f6a@nvidia.com>
References: <20260510053448.326823-1-tariqt@nvidia.com>
	<20260513192539.7fd96592@kernel.org>
	<639580c8-f93f-4945-acfa-ff116b841f6a@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 May 2026 10:56:26 +0300 Moshe Shemesh wrote:
> Satellite PF is another type of Physical Function, its role and 
> privileges are similar to the host PF, but unlike host PF the Satellite 
> PF is on the DPU and not on another host. So it's kind of "Satellite" 
> for the ECPF which is also on the DPU.

Do you genuinely think these 2 sentences explain anything?

Maybe it's just me. If anyone reading this thinks Moshe's explanation
clarifies things - please speak up..

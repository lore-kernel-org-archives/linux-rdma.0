Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F9F2F9D89;
	Thu, 14 May 2026 01:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778720816; cv=none; b=SkmiHkeMEoOnpMvB/kWittoJYAQVSBNtzaol3kF8GuXIa5LTe5L5wbKA/SsM2gxUCIbpSALY2tlHjXIuYbdS30tby9n7qwPlVikKxYz7He5jIkWm5fB6dwwWt9Ifao9KIPTx0mKnd9Yu3h99P+kPMkpUhyKq3vw0C+MLaArc3t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778720816; c=relaxed/simple;
	bh=+7+59XcTHR7QjwCRY3QfECmy1L6pvayVvU5FPnj1gn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RbTjWd1mmUfRiSqZqXa5bu4GXI0V35/YqLM4lzPffkr+0324A9A5HLJqz5A/QDiPWrEz3FBIEuKEcCivyfGoJAozQZ/Ge5yHI+ORpjoosusya4ZSe+9bc3zXna5iqHYMEXtWJ/r2iWW5wqHyIxUBEE17tkEayvM5KLER+BEXtqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek/BVHxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek/BVHxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A8EC19425;
	Thu, 14 May 2026 01:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778720815;
	bh=+7+59XcTHR7QjwCRY3QfECmy1L6pvayVvU5FPnj1gn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ek/BVHxOBFYIDTAm/8IdI3c7Cd7o7/1r7bfEbJc5qY/6zdoaY823nIDaZ28jQ9VI7
	 FRaCEgaskawpUPpJvz2mVqpA7RysrEBKyWeKrR8a+auUxbQSCmpGollhOtN2n60AKz
	 CF5hRzfcxZiTRnTyuGQ2ldp6SULdPsfGHokw1XHaWAo4lZXqQpQo4GD0eVAJPfBjXQ
	 A06/sv2/4v5mTWRf8cbSEr0eMQHjYR22oO206eUv7o13nV06Rj/m2dTADr6gFowsrf
	 B6tMHPQSsDvT6AAmhtMLw8MOuzjgrstnfI4b6wO6EtCEOfe0xRfG99bSXHi/9dvU+V
	 9yOY1CvBmcnYw==
Message-ID: <b8ef4424-112e-4ed4-b67a-05ace9c258b3@kernel.org>
Date: Wed, 13 May 2026 19:06:55 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iproute2-next v2 4/4] devlink: Drop now duplicate pid
 fallback for netns
Content-Language: en-US
To: Leon Romanovsky <leonro@nvidia.com>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, David Ahern <dahern@nvidia.com>
References: <20260512193412.32019-1-dsahern@kernel.org>
 <20260512193412.32019-5-dsahern@kernel.org> <20260513054045.GY15586@unreal>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260513054045.GY15586@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 11:40 PM, Leon Romanovsky wrote:
> 
> You can also remove netns_is_pid from struct dl_opts.

I left it because of the uapi. I will wait for any more comments, and if
that is the only one I can add the removal when I apply.


> 
> It is unfortunate that devlink implements DEVLINK_ATTR_NETNS_PID in  
> the kernel, given that user space can provide this functionality  
> with trivial effort.


yea. really stunned that uapi exists.


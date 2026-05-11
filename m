Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830D73C661C
	for <linux-rdma@vger.kernel.org>; Mon, 11 May 2026 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778494385; cv=none; b=gp5oi1EJznT1zKohrcsCYj9CUeBHI1hVS+ctQsBTxPjpf+kjwQvIDSskp89Tw+DMjy7pPEkGS3u3m0Ct2kA95wu3yJ6ypMswE2855NGCEnQjfvgLwvbYB9LaOxHUYlwkqKAc9Xir93ed2an4fjS5MjfZXVLqMJ0TzodgI/pJN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778494385; c=relaxed/simple;
	bh=O+ipa1tXhrLP/6vH9tY/ZxVHC3m96RHeGuXbLjnv2Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4KBB03Ox4SXnSYgYgkvLmMUoPRQLnl+ECnm32EXfUHVvR6Ir3WIHp62QHwpcQ3wkKHm84NOWrGVdSW+0iadfgyu2VBahFQndFg5jZeJrl5/PNS9gKJ5HZVQzCjGdKPHvzPwE3vJSHsECJE4qpwFazDVNhM8z7N9gFE3nR3bkWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFLep+Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFLep+Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA3C2BCFA;
	Mon, 11 May 2026 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778494385;
	bh=O+ipa1tXhrLP/6vH9tY/ZxVHC3m96RHeGuXbLjnv2Lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFLep+SeKoazB1G6Nybd73Fzj+Ovo1CvfQ4OePVhD6dHWKNXwsxrOvIZrBymfZOC9
	 glragIFTdrjOeYpw8QPa/BoYBLt4/b+AlACyUJVgBjtnSIaoPyKM0hN7GuCuowQ/wj
	 rK6FntzT+1FzmS0FeaW6pH/R8pIhHYiHZRDED2SVFNVSrvitoR0HbNS9xf9EAPzM4E
	 VU2gnJMYTNrfmTFpM/Sp7iiBaMo0qG1yyMD8KBu7rUBdk/EQQGUfVHu88na42Eb0pC
	 PVT75fWtiT1WVe2nYCNNrbePL5IEVNP3APb830KEBUWh4uKXUqcqROJssn9r1lKHMB
	 D9DK+anfraClQ==
Date: Mon, 11 May 2026 13:12:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA/nldev: add resource summary max values for
 usage rate display
Message-ID: <20260511101258.GF15586@unreal>
References: <20260423061352.359749-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423061352.359749-1-cuitao@kylinos.cn>

On Thu, Apr 23, 2026 at 02:13:51PM +0800, Tao Cui wrote:
> Add RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute to expose
> device resource limits (max_qp, max_cq, max_mr, max_pd, max_srq) in
> the resource summary alongside the existing current count. This allows
> userspace tools like iproute2's rdma to display resource usage rates.

While I'm fine with the overall idea, I think we should spend more time  
determining the proper display format for this information. Once we agree  
on how it should be presented, that output should be included in the commit  
message.

Presenting utilization as a percentage seems too imprecise, and users would  
likely prefer to see the maximum value instead.

Thanks

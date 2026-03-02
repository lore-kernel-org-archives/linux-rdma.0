Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C5E1C4A20;
	Mon,  2 Mar 2026 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772479457; cv=none; b=kZJ1BFiLhVJ7VoPdxYJntZQcvI8u5QLTn2SAaijOuREtmk+aHhWVdvXWF3zCFLXQLQHpQNi96U5T3d/MVBRg7WRMI0dQeBsvwxCvXSp5BAB1LqhdPZQqh5isrHSh11HQCk0NUuUrHT2Boks9Pkcf6OT9wNfB2O+YADLyD2w4RhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772479457; c=relaxed/simple;
	bh=eUqn82idSjwQqVfXkynhtMkUOLhTsl3oVSTJl5R+I+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5fZf4OAm9UlqXhu4GVgKFTIDbGrrSrOF834Bw1YMan8fFYlNfHv04kRnnoegl7Wpxu49LNO6sF4410kj8eSGvIEMez/tuJVgcL+9ffO/u+LeMKF0Gw5gRm7FKxVdnIO1AJkkkWBu2iU6l3LuycSThrTlL7b+z2UXhF6NMt004o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQZJfFQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQZJfFQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC456C19423;
	Mon,  2 Mar 2026 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772479457;
	bh=eUqn82idSjwQqVfXkynhtMkUOLhTsl3oVSTJl5R+I+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tQZJfFQc7frvWLCkNAIvTZzWKjzfeokStTQ1u6Dq24q4BXts6IMbPjhiTbaKApWvQ
	 PCEGP6n8318iFyMGlqiXajOiNzDHy0bbTkWG+Fat7POq8RzQt43GKOVh6na/HYWwNR
	 jiG0pdHKUfMjVu5Pz76DU7GOzvczNY1+QTNePh2Rh8wbylTBZlYhJWMMU2oKGNPBLi
	 pZm3XQm1hn9prR9mlOxkvcwDOJQmO8d64E0ZAN9ueXlJq6bjJIqeEUaOY6zs5cIZov
	 VGBnfhh8qt/OeQHBp8drAcS1poxdixKsc5Qkvr0pdn71xWWf2z7RCSa5BaIraM6cWE
	 bmj9n01fMq6Vw==
Date: Mon, 2 Mar 2026 21:24:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 00/13] Provide udata helpers and use them in bnxt_re
Message-ID: <20260302192413.GS12611@unreal>
References: <0-v2-13af4a900857+4f13-bnxt_re_uapi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0-v2-13af4a900857+4f13-bnxt_re_uapi_jgg@nvidia.com>

On Thu, Feb 26, 2026 at 09:11:03PM -0400, Jason Gunthorpe wrote:
> Add new helpers that entirely execute the expected common patterns for
> driver data uAPI forward and backwards compatibility so that drivers don't
> have to open code these.

<...>

> Since bnxt_re has never implemented these rules correctly and now does,
> provide a UCTX flag to tell userspace about it. If
> BNXT_RE_UCNTX_CMASK_UAPI_COMPAT_SUPPORTED is not set then userspace must
> not use any request or response fields beyond the current kernel uAPI.
> 
> Using any new fields is only possible on kernels with the flag.

Does a similar flag exist in any other driver? If so, we should consider
making it global to ib_uverbs. If not, keeping it bnxt_re‑specific is
sufficient.

Thanks

> 
> A series converting all drivers to these new helpers is on github, I will
> send it later:
> 
> https://github.com/jgunthorpe/linux/commits/rdma_uapi/

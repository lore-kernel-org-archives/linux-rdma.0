Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314047E0FF;
	Fri, 13 Feb 2026 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770978231; cv=none; b=gqeUmZbktFRQi2y4qGKDbtOhpgbS0nFkF4MYSw6wYiGmMNE3woB2U76nozsfsFlMQlq66Vwq/Hw9udmQQheOET4DYcaM1QevHhEgJJgDjJVS1E+nbWv5QOqYBJJAKbN92UjkqQ4PjiQtf+sPM8u1au0l2xTdxDTuIzdAxB2IVd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770978231; c=relaxed/simple;
	bh=EmgYNowgzsgngqiwbNGLUCjx8s7jb22/RVygMVlURpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfvLR4JYSnyXx3baEEpXBJpQX7vxzg9B8Taeue53lH7t8OyjFW5akemarSTkX5uzLvrSLappCzTS1Yo0VCG9l32OyUBoQ3kBplEv6gQY9kQNJ5hXnEOGkbnTzlCUfcCn8hERSokG+XHFkqXoRmQQC4tZe5fuIcq/1xUZ7CNe8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jutMZ+Eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jutMZ+Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901C5C116C6;
	Fri, 13 Feb 2026 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770978231;
	bh=EmgYNowgzsgngqiwbNGLUCjx8s7jb22/RVygMVlURpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jutMZ+EqNAxWieCEWF6QzyL4yOF9XVq5JnDxoUOAZpe9ZwxCRj3CEdkVUn5Ilc8O0
	 BeIGxopvIfGz2i1Jjq+Tjih/dRx5j57wYnEZB/Zb8PmFYwRrw+Q/PP3Zxhbm4Bd0a1
	 /8trhaKFBYFdPclh8sejaZNMNx154Z14vptV5Sztjpmrktg0CyQY104Xl/9GjN9uMC
	 jmdm3R6s9ZjfzskMzTZ1lU74EYUkDApeFJ7aO0hIOZmCnpAK7mM+O6keWPFVQFKL17
	 PeB7OepKWQu49Jeh+ywMxJAEE4NFv+ZsXdfa9AEeCKSPW4Hnd0XeVwbi2XKUG8uzpI
	 bict7tCdLTt+g==
Date: Fri, 13 Feb 2026 12:23:47 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 05/10] RDMA: Provide documentation about the uABI
 compatibility rules
Message-ID: <20260213102347.GL12887@unreal>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <5-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>

On Thu, Feb 05, 2026 at 09:45:39PM -0400, Jason Gunthorpe wrote:
> Write down how all of this is supposed to work using the new helpers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/rdma/ib_verbs.h | 81 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)

Can we add these rules to Chris's review-prompts?

Thanks

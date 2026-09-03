Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8C46C4C5
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426773; cv=none; b=BbRIfS5d0sn+sDTmyB91cAIvPRv3z7wFU3Jy3HQQXe50M8pcCymNkTMELtK1RYlTRc4QzFeg9qaMKpKSAFmkCvaGyg2HsDOOnHsAFQ0dvIf2UwvJqnhmQDRoBbzXzznAOfaObYkUT1hTkvClmMjd+/sKQkLMg1loBDuC4/NhhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426773; c=relaxed/simple;
	bh=zm5yPw/q3kHZLN3OKUPkYFuWHOLhrMrVyS9RvwcmNvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7bk+gAseoqFlslZy3tQQKasYdYYXk5k6LDb+Q8bYqw3BpvVzjI+w6NJgzYvfWChYa/hqsIftHPYtmaTV2nl14+aXXsFltyFXPz1dHtBrGFRbOArwZNTTWaR9WDu2hcntfmnAeM9bqkhbqTxiQqFDHpQwpwdcZUPpvRGis6sjrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpMNlyvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpMNlyvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F541F000E9;
	Thu,  3 Sep 2026 09:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788426771;
	bh=ZGtXoKuUBhDZZ0l6o7bzMEqlufIQPj5oTlEZ9LRSsuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bpMNlyvFmcnnRmMnyfnLGElt0nFDpaRkawjHIf6kdJoc5J19TikW8384+gYsMGQGY
	 BVqZBbM6t4XkiQxVOLuLElgGfkV5Mt+QJT4EhMf84AoJWlv1QUi8IGPvPYY0WE79h5
	 G6LP5bv/vHaMlJsydrnFyD4uq+tGW5isP02AnPV8Sv84edZUocVxsZBokX6sOn0coq
	 9qPFOPMEQxlscuAyYqRdzwwC3onC48iybxgiuFueq3cbSU7CuCKCHz0U9g2TX7Hl5b
	 kAAgh/CttWiTGtAg/qjMZwRU6ltNZRQ4q0L0Pgnlm03hwGGTBBTPr8Fu5qF5cDothY
	 6FYZsfmkVtbSA==
Date: Thu, 3 Sep 2026 12:12:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: Re: [PATCH for-next v2 3/4] RDMA/erdma: Unify userspace and kernel
 queue buffer management
Message-ID: <20260903091246.GZ24140@unreal>
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-4-chengyou@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827082523.36294-4-chengyou@linux.alibaba.com>

On Thu, Aug 27, 2026 at 04:25:22PM +0800, Cheng Xu wrote:
> Userspace and kernel space queue buffers use separate helpers despite
> sharing MTT metadata and lifetime rules. Manage both through
> erdma_mem_init() and erdma_mem_uninit(), while keeping backing allocation
> and release type-specific.
> 
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> ---
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 281 ++++++++++++++--------
>  drivers/infiniband/hw/erdma/erdma_verbs.h |  17 +-
>  2 files changed, 191 insertions(+), 107 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
> index b0a47c82cbdf..aaef2b3621b0 100644
> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
> @@ -19,9 +19,9 @@
>  #include "erdma_cm.h"
>  #include "erdma_verbs.h"

<...>

> -static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
> -			   u64 start, u64 len, int access, u64 virt,
> -			   unsigned long req_page_size, bool force_continuous)
> +static void erdma_mem_free(struct erdma_dev *dev, struct erdma_mem *mem)
>  {
> -	int ret = 0;
> +	switch (mem->type) {
> +	case ERDMA_UMEM:
> +		if (mem->umem) {

I expect that if you call to this function, mem->umem is already valid.

> +			ib_umem_release(mem->umem);
> +			mem->umem = NULL;
> +		}
> +		break;
> +	case ERDMA_KMEM:
> +		erdma_kmem_free(dev, mem);
> +		break;
> +	default:
> +		break;
> +	}
> +}
>  

Thanks

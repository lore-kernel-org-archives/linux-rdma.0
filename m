Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578C52E06F
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875166; cv=none; b=nmliuGIHXVf3yq9dg3Qyl+6QcWuLtVFA7JVrqbE3P74fSerKdYKgcW8wBVBRn29MBCA0Kh05sS8R3qsfa0gZ3oPkCdW0LqRDH+du8nxaczFvCjUwYFmItEj7o5PBsa+OeYnIinTSEZ+oDxF8XByjFe7a8tfp0JYJQ8ncSXO5dk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875166; c=relaxed/simple;
	bh=hNUQ0FB6k31OKWBBFs9qFCrpfBpPix+FJtM4TKQj4Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctZdBKkgO5ZywhMT9CeZ3SquD5pR0Anj6y4NEC2sMazctQ9AWFNKA6AUh0qWKaMggxuhP75pcoR31D2EPF2jtIhtb3un3Ee6oAmrPzsRJKkdj+jdVxvnN6dvZG/XkyzFFOGHphagUiKbMddY1O2eEncguciVdd9XJ9LaQ2+exs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkwiJRqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkwiJRqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980CD1F00A3A;
	Tue,  8 Sep 2026 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875158;
	bh=XVxEawv8eWfuOOu0gN/b+xB8JnCf438aJicGZLbwZwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LkwiJRqfeJhq2TCrSjMDxypGTiSkh7AyTdiWQHNhNX/tuGPR5WE/DSPCh8TT/D1d3
	 Nm8PoGWBrrwk28Z1xXFBP0lA2JjM4bmCYimbhRPUZWgFnhM8TayHZJYqliZW1/LI4y
	 qQMHKjIQc1W0EDCT2JfyW2avLBTXc/JT5xHbfZVr9DCOYxi3C6zvYw/yAhaVw0fSgJ
	 AoDFM0+PWviOAdDuP3SVgZMqVsR7wSz1ImWGBsjLhI/ApZeuwIlM80rDoHH+6N2N0C
	 emMPoHr+njqWlBgHMh8HXSoVSNxVCHpxDX6Wd69Z0oOkV+MqPT8htS2DHnKmOthV0q
	 j0hBeXfBkSfcQ==
Date: Tue, 8 Sep 2026 16:45:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
Message-ID: <20260908134553.GO13683@unreal>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906230700.12233-2-selvin.xavier@broadcom.com>

On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> could map these kernel pages executable. Reject VM_EXEC as well.
> Also, return EPERM instead of EFAULT.
> 
> Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
> CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index ccd2702db78b..e39f99434923 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
>  		break;
>  	case BNXT_RE_MMAP_DBR_PAGE:
>  	case BNXT_RE_MMAP_TOGGLE_PAGE:
> -		/* Driver doesn't expect write access for user space */
> -		if (vma->vm_flags & VM_WRITE) {
> -			ret = -EFAULT;
> +		/* Driver doesn't expect write and exec access for user space */
> +		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> +			ret = -EPERM;
>  		} else {
> -			vm_flags_clear(vma, VM_MAYWRITE);
> +			vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);

This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
commit.

Thanks

>  			ret = vm_insert_page(vma, vma->vm_start,
>  					     virt_to_page((void *)bnxt_entry->mem_offset));
>  		}
> -- 
> 2.39.3
> 

From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 1/6] mm/gup: finish consolidating error handling
Date: Mon, 12 Nov 2018 08:41:27 -0700
Message-ID: <20181112154127.GA8247@localhost.localdomain>
References: <20181110085041.10071-1-jhubbard@nvidia.com>
 <20181110085041.10071-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181110085041.10071-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 10, 2018 at 12:50:36AM -0800, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> An upcoming patch wants to be able to operate on each page that
> get_user_pages has retrieved. In order to do that, it's best to
> have a common exit point from the routine. Most of this has been
> taken care of by commit df06b37ffe5a4 ("mm/gup: cache dev_pagemap while
> pinning pages"), but there was one case remaining.
> 
> Also, there was still an unnecessary shadow declaration (with a
> different type) of the "ret" variable, which this commit removes.
> 
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/gup.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index f76e77a2d34b..55a41dee0340 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -696,12 +696,11 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  		if (!vma || start >= vma->vm_end) {
>  			vma = find_extend_vma(mm, start);
>  			if (!vma && in_gate_area(mm, start)) {
> -				int ret;
>  				ret = get_gate_page(mm, start & PAGE_MASK,
>  						gup_flags, &vma,
>  						pages ? &pages[i] : NULL);
>  				if (ret)
> -					return i ? : ret;
> +					goto out;
>  				ctx.page_mask = 0;
>  				goto next_page;
>  			}

This also fixes a potentially leaked dev_pagemap reference count if a
failure occurs when an iteration crosses a vma boundary. I don't think
it's normal to have different vma's on a users mapped zone device memory,
but good to fix anyway.

Reviewed-by: Keith Busch <keith.busch@intel.com>

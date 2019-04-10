From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 7/8] mm/mmu_notifier: pass down vma and reasons why
 mmu notifier is happening v2
Date: Wed, 10 Apr 2019 16:41:57 -0700
Message-ID: <20190410234124.GE22989@iweiny-DESK2.sc.intel.com>
References: <20190326164747.24405-1-jglisse@redhat.com>
 <20190326164747.24405-8-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326164747.24405-8-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.orgdri
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 26, 2019 at 12:47:46PM -0400, Jerome Glisse wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> CPU page table update can happens for many reasons, not only as a result
> of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
> as a result of kernel activities (memory compression, reclaim, migration,
> ...).
> 
> Users of mmu notifier API track changes to the CPU page table and take
> specific action for them. While current API only provide range of virtual
> address affected by the change, not why the changes is happening
> 
> This patch is just passing down the new informations by adding it to the
> mmu_notifier_range structure.
> 
> Changes since v1:
>     - Initialize flags field from mmu_notifier_range_init() arguments
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: kvm@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/mmu_notifier.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 62f94cd85455..0379956fff23 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -58,10 +58,12 @@ struct mmu_notifier_mm {
>  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
>  
>  struct mmu_notifier_range {
> +	struct vm_area_struct *vma;
>  	struct mm_struct *mm;
>  	unsigned long start;
>  	unsigned long end;
>  	unsigned flags;
> +	enum mmu_notifier_event event;
>  };
>  
>  struct mmu_notifier_ops {
> @@ -363,10 +365,12 @@ static inline void mmu_notifier_range_init(struct mmu_notifier_range *range,
>  					   unsigned long start,
>  					   unsigned long end)
>  {
> +	range->vma = vma;
> +	range->event = event;
>  	range->mm = mm;
>  	range->start = start;
>  	range->end = end;
> -	range->flags = 0;
> +	range->flags = flags;

Which of the "user patch sets" uses the new flags?

I'm not seeing that user yet.  In general I don't see anything wrong with the
series and I like the idea of telling drivers why the invalidate has fired.

But is the flags a future feature?

For the series:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Ira

>  }
>  
>  #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> -- 
> 2.20.1
> 

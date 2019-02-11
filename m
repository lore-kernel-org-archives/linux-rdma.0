From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 13:39:16 -0700
Message-ID: <20190211203916.GA2771@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211201643.7599-3-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211201643.7599-3-ira.weiny@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Users of get_user_pages_fast are not protected against mapping
> pages within FS DAX.  Introduce a call which protects them.
> 
> We do this by checking for DEVMAP pages during the fast walk and
> falling back to the longterm gup call to check for FS DAX if needed.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>  include/linux/mm.h |   8 ++++
>  mm/gup.c           | 102 +++++++++++++++++++++++++++++++++++----------
>  2 files changed, 88 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 80bb6408fe73..8f831c823630 100644
> +++ b/include/linux/mm.h
> @@ -1540,6 +1540,8 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
>  			    unsigned int gup_flags, struct page **pages,
>  			    struct vm_area_struct **vmas);
> +int get_user_pages_fast_longterm(unsigned long start, int nr_pages, bool write,
> +				 struct page **pages);
>  #else
>  static inline long get_user_pages_longterm(unsigned long start,
>  		unsigned long nr_pages, unsigned int gup_flags,
> @@ -1547,6 +1549,11 @@ static inline long get_user_pages_longterm(unsigned long start,
>  {
>  	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
>  }
> +static inline int get_user_pages_fast_longterm(unsigned long start, int nr_pages,
> +					       bool write, struct page **pages)
> +{
> +	return get_user_pages_fast(start, nr_pages, write, pages);
> +}
>  #endif /* CONFIG_FS_DAX */
>  
>  int get_user_pages_fast(unsigned long start, int nr_pages, int write,
> @@ -2615,6 +2622,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
>  #define FOLL_COW	0x4000	/* internal GUP flag */
>  #define FOLL_ANON	0x8000	/* don't do file mappings */
> +#define FOLL_LONGTERM	0x10000	/* mapping is intended for a long term pin */

If we are adding a new flag, maybe we should get rid of the 'longterm'
entry points and just rely on the callers to pass the flag?

Jason

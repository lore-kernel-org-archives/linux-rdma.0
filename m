From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Mon, 28 Jan 2019 16:31:40 -0700
Message-ID: <20190128233140.GA12530@ziepe.ca>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-4-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121174220.10583-4-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 21, 2019 at 09:42:17AM -0800, Davidlohr Bueso wrote:
> The driver uses mmap_sem for both pinned_vm accounting and
> get_user_pages(). By using gup_fast() and letting the mm handle
> the lock if needed, we can no longer rely on the semaphore and
> simplify the whole thing as the pinning is decoupled from the lock.
> 
> This also fixes a bug that __qib_get_user_pages was not taking into
> account the current value of pinned_vm.
> 
> Cc: dennis.dalessandro@intel.com
> Cc: mike.marciniszyn@intel.com
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  drivers/infiniband/hw/qib/qib_user_pages.c | 67 ++++++++++--------------------
>  1 file changed, 22 insertions(+), 45 deletions(-)

I need you to respin this patch/series against the latest rdma tree:

git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

branch for-next

> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> -static int __qib_get_user_pages(unsigned long start_page, size_t num_pages,
> -				struct page **p)
> -{
> -	unsigned long lock_limit;
> -	size_t got;
> -	int ret;
> -
> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -
> -	if (num_pages > lock_limit && !capable(CAP_IPC_LOCK)) {
> -		ret = -ENOMEM;
> -		goto bail;
> -	}
> -
> -	for (got = 0; got < num_pages; got += ret) {
> -		ret = get_user_pages(start_page + got * PAGE_SIZE,
> -				     num_pages - got,
> -				     FOLL_WRITE | FOLL_FORCE,
> -				     p + got, NULL);

As this has been rightly changed to get_user_pages_longterm, and I
think the right answer to solve the conflict is to discard some of
this patch?

Since Andrew is OK with this I can move this ahead once this is
resolved, thanks.

Jason

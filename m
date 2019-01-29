From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/5] RDMA/uverbs: add owner parameter to ib_umem_get
Date: Tue, 29 Jan 2019 10:29:56 -0800
Message-ID: <20190129182954.GA10129@iweiny-DESK2.sc.intel.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
 <1548768386-28289-4-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1548768386-28289-4-git-send-email-joeln@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Nider <joeln@il.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 29, 2019 at 03:26:24PM +0200, Joel Nider wrote:
> ib_umem_get is a core function used by drivers that support RDMA.
> The 'owner' parameter signifies the process that owns the memory.
> Until now, it was assumed that the owning process was the current
> process. This adds the flexibility to specify a process other than
> the current process. All drivers that call this function are also
> updated, but the default behaviour is to keep backwards
> compatibility by assuming the current process is the owner when
> the 'owner' parameter is NULL.
> 
> Signed-off-by: Joel Nider <joeln@il.ibm.com>
> ---

[snip]

> @@ -183,10 +196,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  
>  	while (npages) {
>  		down_read(&mm->mmap_sem);
> -		ret = get_user_pages_longterm(cur_base,
> +		ret = get_user_pages_remote_longterm(owner_task,
> +				     mm, cur_base,
>  				     min_t(unsigned long, npages,
> -					   PAGE_SIZE / sizeof (struct page *)),
> -				     gup_flags, page_list, vma_list);
> +				     PAGE_SIZE / sizeof(struct page *)),
> +				     gup_flags, page_list, vma_list, NULL);

qib was recently converted to get_user_pages_longterm.  So qib would need to
be updated as well.

Ira

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/6] BAR mappings fixes in RDMA
Date: Wed, 24 Apr 2019 16:24:29 -0300
Message-ID: <20190424192429.GA31203@ziepe.ca>
References: <20190416110730.32230-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190416110730.32230-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2019 at 02:07:24PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> >From Jason,
> 
> Upon review it turns out there are some long standing problems in BAR
> mapping area:
>  * BAR pages are being allowed to be executable.
>  * BAR pages intended for read-only can be switched to writable via mprotect.
>  * Missing use of rdma_user_mmap_io for the mlx5 clock BAR page.
>  * Disassociate causes SIGBUS when touching the pages.
>  * CPU pages are being mapped through to the process via remap_pfn_range
>    instead of the more appropriate vm_insert_page, causing weird behaviors
>    during disassociation.
> 
> This series adds the missing VM_* flag manipulation, adds faulting a zero
> page for disassociation and revises the CPU page mappings to use vm_insert_page.
> 
> Thanks
> 
> Jason Gunthorpe (6):
>   RDMA/mlx5: Do not allow the user to write to the clock page
>   RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
>   RDMA/ucontext: Fix regression with disassociate

Applied to for-rc

>   RDMA/mlx5: Use get_zeroed_page() for clock_info
>   RDMA: Remove rdma_user_mmap_page

Applied to for-next

I dropped this patch:

>   RDMA/ucontext: Do not allow BAR mappings to be executable

Jason

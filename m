From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 00/20] Introduce mlx5 DEVX interface
Date: Mon, 18 Jun 2018 16:05:04 -0600
Message-ID: <20180618220504.GH6805@ziepe.ca>
References: <20180617100006.30663-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 12:59:46PM +0300, Leon Romanovsky wrote:
 
> Leon Romanovsky (2):
>   drm/i915: Move u64-to-ptr helpers to general header
>   kernel.h: Reuse u64_to_ptr macro to cast __user pointers

I dropped these since they are not needed by this series when using a
union.

> Matan Barak (5):
>   IB/uverbs: Export uverbs idr and fd types
>   IB/uverbs: Add PTR_IN attributes that are allocated/copied
>     automatically

Revised this one, as noted

>   IB/uverbs: Add a macro to define a type with no kernel known size
>   IB/uverbs: Allow an empty namespace in ioctl() framework
>   IB/uverbs: Refactor uverbs_finalize_objects

I put the above in a branch and can apply them if you ack my revisions..

>   net/mlx5_core: Prevent warns in dmesg upon firmware commands
>   IB/core: Improve uverbs_cleanup_ucontext algorithm

I dropped these two (they are linked), need comments addressed and
resent.

> Yishai Hadas (13):
>   net/mlx5: Expose DEVX ifc structures
>   IB/mlx5: Introduce DEVX
>   IB/core: Introduce DECLARE_UVERBS_GLOBAL_METHODS
>   IB: Expose ib_ucontext from a given ib_uverbs_file
>   IB/mlx5: Add support for DEVX general command
>   IB/mlx5: Add obj create and destroy functionality
>   IB/mlx5: Add DEVX support for modify and query commands
>   IB/mlx5: Add support for DEVX query UAR
>   IB/mlx5: Add DEVX support for memory registration
>   IB/mlx5: Add DEVX query EQN support
>   IB/mlx5: Expose DEVX tree

I put these in a branch also and can apply them, but I need the first
two patches in the mlx5 core branch first please, thanks.

Since this requires so many core patches I think I prefer to merge the
mlx core branch then apply rather merge a branch.

Jason

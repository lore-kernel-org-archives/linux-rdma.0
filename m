From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v3 00/14] Verbs flow counters support
Date: Fri, 1 Jun 2018 15:11:49 -0600
Message-ID: <20180601211149.GA24028@ziepe.ca>
References: <20180531134341.18441-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 31, 2018 at 04:43:27PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v2->v3:
>  * Change function mlx5_fc_query signature to hide the details of
>    internal core driver struct mlx5_fc
>  * Add commen to data[] field at struct mlx5_ib_flow_counters_data (mlx5-abi.h)
>  * Use array of struct mlx5_ib_flow_counters_desc to clarify the output
> v1->v2:
>  * Removed conversion from struct mlx5_fc* to void*
>  * Fixed one place with double space in it
>  * Balanced release of hardware handler in case of counters allocation failure
>  * Added Tested-by
>  * Minimize time spent holding mutex lock
>  * Fixed deadlock caused by nested lock in error path
>  * Protect from handler pointer derefence in the error paths

Okay,

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

I've revised some of the commit messages, fixed the two bad
check-patch warnings, and fixed the patch ordering..

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-counters

Please send a PR with the mlx-core bits and above commits.

Thanks,
Jason
